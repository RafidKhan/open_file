import 'dart:io';

import 'package:file_open/downloader.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? pdfFile;

  setFile(File? file) {
    pdfFile = file;
    print("FILE:: $pdfFile");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Center(child: CircularProgressIndicator()),
                      );
                    });
                await DownloaderUtil().downloadAndGetFilePath().then((file) {
                  Navigator.pop(context);

                  setFile(file);
                });
              },
              child: const Text("Download"),
            ),
            if (pdfFile != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (await Permission.manageExternalStorage.request().isGranted) {
                        await OpenFile.open(pdfFile!.path).then((value) {
                          print("RESULT: ${value.message}");
                        }).catchError((e){
                          print("RESULT:B: ${e}");
                        });
                      }
                    },
                    child: const Text("Open"),
                  ),
                  IconButton(
                    onPressed: () {
                      setFile(null);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
