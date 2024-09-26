import 'package:flutter/material.dart';
import 'dart:async';
import 'bottomNavBar.dart';
import '../api/api.dart';
import '../utils/constants/contants_url.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';


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

      List<FileData> fileList = [];

      for (var fileData in json_response) {
        String name = fileData["name"];
        String fileName = fileData["path"];
        String url = ip + fileName;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyDocxViewer(docxUrl: fileData.url),
          ),
        );
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
              child: Icon(
                Icons.picture_as_pdf,
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

class MyDocxViewer extends StatefulWidget {
  final String docxUrl;

  MyDocxViewer({required this.docxUrl});

  @override
  _MyDocxViewerState createState() => _MyDocxViewerState();
}

class _MyDocxViewerState extends State<MyDocxViewer> {
  late String _localPath;
  late String _localDocxUrl;

  @override
  void initState() {
    super.initState();
    _initDocx();
  }

  Future<void> _initDocx() async {
    final filename = widget.docxUrl.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    _localPath = dir.path;
    _localDocxUrl = '$_localPath/$filename';

    final File file = File('$_localPath/$filename');
    final bool fileExists = await file.exists();
    if (!fileExists) {
      final http.Response response = await http.get(Uri.parse(widget.docxUrl));
      await file.writeAsBytes(response.bodyBytes);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filename = widget.docxUrl.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadDOCX(context, widget.docxUrl, filename);
            },
          ),
        ],
      ),
      body: _localDocxUrl.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _localDocxUrl,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onError: (error) {
                print(error);
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            ),
    );
  }

  Future<void> _downloadDOCX(BuildContext context, String docxUrl, String name) async {
    final url = Uri.parse(docxUrl);
    if (!url.isAbsolute || (url.scheme != 'http' && url.scheme != 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL invalide'),
        ),
      );
      return;
    }

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Directory? directory = await getApplicationDocumentsDirectory();
      
      if (directory != null) {
        final String docxDirectoryPath = '${directory.path}/Notario_Documents';
        final Directory docxDirectory = Directory(docxDirectoryPath);

        await docxDirectory.create(recursive: true);

        final File file = File('${docxDirectory.path}/$name.docx');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document téléchargé avec succès'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'obtenir le répertoire de stockage externe'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec du téléchargement du Document'),
        ),
      );
    }
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
                  decoration: TextDecoration.underline,
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
