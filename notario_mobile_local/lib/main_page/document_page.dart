import 'package:flutter/material.dart';
import 'dart:async';
import 'bottomNavBar.dart';
import '../api/api.dart';
import '../utils/constants/contants_url.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FileData {
  final String name;
  final String url;
  final bool signedClient;
  final bool signedNotary;
  final DateTime updatedAt;
  final DateTime createdAt;

  FileData({required this.name, required this.url, required this.signedClient, required this.signedNotary, required this.updatedAt, required this.createdAt});
}

 String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

Future<List<FileData>> fetchFiles() async {

  try {
    var response = await api_get_files(token: TokenUser);

      var json_response = response;
      print(json_response);

      List<FileData> fileList = [];

      for (var fileData in json_response) {
        String name = fileData["name"];
        String fileName = fileData["uid"];
        String url = ip + "/files/get/" + fileName + "/";
        bool signedClient = fileData["is_signed_by_client"] ?? false;
        bool signedNotary = fileData["is_signed_by_notary"] ?? false;
        DateTime updatedAt = fileData["updated_at"] != null ? DateTime.parse(fileData["updated_at"]) : DateTime.now();
        DateTime createdAt = fileData["created_at"] != null ? DateTime.parse(fileData["created_at"]) : DateTime.now();

        fileList.add(FileData(
          name: name,
          url: 'http://' + url,
          signedClient: signedClient,
          signedNotary: signedNotary,
          updatedAt: updatedAt,
          createdAt: createdAt,
        ));
      }

      return fileList;
  } catch (e) {
    throw (e.toString());
  }
}

class FileItemWidget extends StatelessWidget {
  final FileData fileData;

  FileItemWidget(this.fileData);

  Future<void> _viewFile(BuildContext context, String token) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/${fileData.name}';
  
  var response = await http.get(
    Uri.parse(fileData.url),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    
    final base64Data = jsonResponse['file']['data'];

    final bytes = base64.decode(base64Data);
    
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    final docContent = await _extractDocxContent(filePath);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewPage(documentContent: docContent, documentUrl: fileData.url, documentName: fileData.name),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Erreur de téléchargement du fichier : ${response.statusCode}'),
    ));
  }
}

Future<String> _extractDocxContent(String filePath) async {
  final bytes = await File(filePath).readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);
  
  for (final file in archive) {
    if (file.name == 'word/document.xml') {
      final xmlString = utf8.decode(file.content as List<int>);
      return _parseDocumentXml(xmlString);
    }
  }
  return "Aucun contenu trouvé.";
}

String _parseDocumentXml(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final paragraphs = document.findAllElements('w:p');
  StringBuffer buffer = StringBuffer();

  for (var paragraph in paragraphs) {
    List<TextSpan> spans = [];
    for (var run in paragraph.findAllElements('w:r')) {
      String runText = '';
      TextStyle textStyle = TextStyle();

      for (var textElement in run.findAllElements('w:t')) {
        runText += textElement.text;
      }

      final rPr = run.findElements('w:rPr').firstOrNull;
      if (rPr != null) {
        final color = rPr.findElements('w:color').firstOrNull?.getAttribute('w:val');
        if (color != null) {
          textStyle = textStyle.copyWith(color: Color(int.parse('0xFF$color')));
        }

        final sz = rPr.findElements('w:sz').firstOrNull?.getAttribute('w:val');
        if (sz != null) {
          textStyle = textStyle.copyWith(fontSize: double.parse(sz) / 2);
        }

      }

      spans.add(TextSpan(text: runText, style: textStyle));
    }

    buffer.writeln();
    spans.forEach((span) {
      buffer.write(span.text);
    });
  }

  return buffer.toString().trim();
}



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _viewFile(context, TokenUser);
      },
      child: Container(
         width: 125.0,
      height: 300.0,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF351EA4),
            Color(0xFF1A1B25),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFF1A1B25), width: 2.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    fileData.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      fileData.signedNotary ? Icons.check_circle : Icons.cancel,
                      color: fileData.signedNotary ? Colors.green : Colors.red,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Signé par le notaire',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      fileData.signedClient ? Icons.check_circle : Icons.cancel,
                      color: fileData.signedClient ? Colors.green : Colors.red,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Signé par le client',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  'Créé le: ${formatDate(fileData.createdAt)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Dernière mise à jour: ${formatDate(fileData.updatedAt)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: FaIcon(
                FontAwesomeIcons.fileWord,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class FileListWidget extends StatelessWidget {
  final List<FileData> fileList;

  FileListWidget(this.fileList);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2,
      ),
      itemCount: fileList.length,
      itemBuilder: (context, index) {
        return FileItemWidget(fileList[index]);
      },
    );
  }
}


class DocumentPage extends StatefulWidget {
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late Future<List<FileData>> filesFuture;

  @override
  void initState() {
    super.initState();
    filesFuture = fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0Xff6949FF)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text('Mes documents',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0Xff6949FF),
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: FutureBuilder<List<FileData>>(
        future: filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fichiers'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Vous n\'avez pas de fichiers'));
          } else {
            return FileListWidget(snapshot.data!);
          }
        },
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}

class DocumentViewPage extends StatelessWidget {
  final String documentContent;
  final String documentUrl;
  final String documentName;

  DocumentViewPage({
    required this.documentContent,
    required this.documentUrl,
    required this.documentName,
  });

  Future<void> downloadFile(BuildContext context, String docxUrl, String name) async {
    final url = Uri.parse(docxUrl);
    if (!url.isAbsolute || (url.scheme != 'http' && url.scheme != 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL invalide'),
        ),
      );
      return;
    }

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $TokenUser',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String base64Data = jsonResponse['file']['data'];
      List<int> bytes = base64Decode(base64Data);

      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final String downloadsPath = '${directory.path}/Téléchargements';
        final Directory downloadsDirectory = Directory(downloadsPath);

        await downloadsDirectory.create(recursive: true);
        final File file = File('$downloadsPath/$name.docx');

        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document téléchargé avec succès : ${file.path}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'obtenir le répertoire de téléchargements'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec du téléchargement du Document, statut: ${response.statusCode}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contenu du Document"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              downloadFile(context, documentUrl, documentName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          documentContent,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

