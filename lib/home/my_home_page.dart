import 'dart:developer';
import 'dart:io';

import 'package:deeplink/home/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final PickImage pickImage = PickImage();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Home Page')),
      body: ListenableBuilder(
        listenable: pickImage,
        builder: (context, asyncSnapshot) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // pickImage.pickFile();
                    context.push('/product');
                  },
                  child: Text("Pick"),
                ),
                // Text(
                //   "File: ${pickImage.file?.lengthSync() ?? 'No file selected'}",
                // ),
                if (pickImage.file != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 600,
                    child: SfPdfViewer.memory(
                      canShowHyperlinkDialog: true,
                      canShowPageLoadingIndicator: true,
                      initialPageNumber: 1,
                      onHyperlinkClicked: (details) {
                        log('Hyperlink clicked: ${details.uri}');
                      },
                      onTap: (details) {
                        log('PDF tapped at: ${details.pagePosition}');
                      },

                      undoController: UndoHistoryController(
                        value: UndoHistoryValue(canRedo: true, canUndo: true),
                      ),
                      maxZoomLevel: 10,

                      File(pickImage.file!.path).readAsBytesSync(),
                      key: _pdfViewerKey,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
