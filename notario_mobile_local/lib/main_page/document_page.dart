import 'package:flutter/material.dart';
import 'dart:async';
import 'bottomNavBar.dart';
import '../api/api.dart';
import '../utils/constants/contants_url.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
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
            builder: (context) => MyPdfViewer(pdfUrl: fileData.url),
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

class MyPdfViewer extends StatefulWidget {
  final String pdfUrl;

  MyPdfViewer({required this.pdfUrl});

  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  late String _localPath;
  late String _localPdfUrl;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    final filename = widget.pdfUrl.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    _localPath = dir.path;
    _localPdfUrl = '$_localPath/$filename';

    final File file = File('$_localPath/$filename');
    final bool fileExists = await file.exists();
    if (!fileExists) {
      final http.Response response = await http.get(Uri.parse(widget.pdfUrl));
      await file.writeAsBytes(response.bodyBytes);
    }
    setState(() {});
  }

   @override
  Widget build(BuildContext context) {
    final filename = widget.pdfUrl.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context, widget.pdfUrl, filename);
            },
          ),
        ],
      ),
      body: _localPdfUrl.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _localPdfUrl,
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
}

Future<void> _downloadPDF(BuildContext context, String pdfUrl, String name) async {
  final url = Uri.parse(pdfUrl);
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
    if (await _requestPermission()) {
      final Directory? externalDirectory = await getExternalStorageDirectory();
      
      if (externalDirectory != null) {
        final String pdfDirectoryPath = '${externalDirectory.path}/PDFs';
        final Directory pdfDirectory = Directory(pdfDirectoryPath);

        await pdfDirectory.create(recursive: true);

        final File file = File('${pdfDirectory.path}/$name.pdf');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF téléchargé avec succès'),
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
          content: Text('Permission d\'accès au stockage externe refusée'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Échec du téléchargement du PDF'),
      ),
    );
  }
}

Future<bool> _requestPermission() async {
  if (Platform.isAndroid && (await Permission.manageExternalStorage.isGranted)) {
    return true;
  } else if (Platform.isAndroid && (await Permission.manageExternalStorage.request().isGranted)) {
    return true;
  } else {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  return false;
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
