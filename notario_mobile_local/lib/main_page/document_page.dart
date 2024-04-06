import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'delayed_animation.dart';
import '../main.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'profil_page.dart';
import 'bottomNavBar.dart';
import 'package:http/http.dart';
import '../api/api.dart';
import '../utils/constants/contants_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';


class FileData {
  final String name;
  final String url;

  FileData({required this.name, required this.url});
}

Future<List<FileData>> fetchFiles() async {

  try {
    var response = await api_get_files(token: TokenUser);

      var json_response = response;

      print(json_response);

      List<FileData> fileList = [];

      for (var fileData in json_response) {
        String name = fileData["name"];
        String fileName = fileData["file"];
        String url = ip + fileName;

        fileList.add(FileData(
          name: name,
          url: url,
        ));
      }
      fileList.forEach((fileData) {
        print('name: ${fileData.name}, url: ${fileData.url}');
      });

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
            builder: (context) => MyPdfViewer(pdfUrl: 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
          ),
        );
      },
      child: Container(
        width: 150.0,
        height: 200.0,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(
                'images/pdf1.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20.0,
              child: Center(
                child: Text(
                  fileData.name,
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("My PDF Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context, widget.pdfUrl, 'document');
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

void _downloadPDF(BuildContext context, String pdfUrl, String name) async {
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
    final appDirectory = await getApplicationDocumentsDirectory();
    final pdfDirectory = Directory('${appDirectory.path}/PDFs');
    await pdfDirectory.create(recursive: true);
    final file = File('${pdfDirectory.path}/$name.pdf');
    print(file);
    await file.writeAsBytes(response.bodyBytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF téléchargé avec succès'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Impossible de télécharger le PDF'),
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
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
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
            return Center(child: Text('Aucun fichier disponible'));
          } else {
            return FileListWidget(snapshot.data!);
          }
        },
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}
