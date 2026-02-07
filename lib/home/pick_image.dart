import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:pdf_compressor/pdf_compressor.dart';

class PickImage extends ChangeNotifier {
  XFile? image;
  XFile? comp;
  File? file;
  File? compressedFile;
  // final compressor = SimplePdfCompression();
  // Source - https://stackoverflow.com/a/64690920
  // Posted by Code on the Rocks
  // Retrieved 2026-02-07, License - CC BY-SA 4.0

  // Source - https://stackoverflow.com/a/64690920
  // Posted by Code on the Rocks
  // Retrieved 2026-02-07, License - CC BY-SA 4.0

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image!.path);

      var bytes = await file.length(); // size in bytes
      var kb = bytes / 1024;
      var mb = kb / 1024;

      log('Image size: $bytes bytes');
      log('Image size: ${kb.toStringAsFixed(2)} KB');
      log('Image size: ${mb.toStringAsFixed(2)} MB');

      final compressedImage = await FlutterImageCompress.compressWithFile(
        image!.path,
        format: CompressFormat.webp,
        quality: 1, // Adjust the quality as needed
      );
      comp = XFile.fromData(
        compressedImage!,
        length: compressedImage.length,
        path: image!.path,

        name: 'compressed_image.webp',
      );

      // log('Compressed image size: ${comp} bytes');
      kb = compressedImage.length / 1024;
      mb = kb / 1024;
      log('com size: ${compressedImage.length} bytes');
      log('com size: ${kb.toStringAsFixed(2)} KB');
      log('com size: ${mb.toStringAsFixed(2)} MB');
    }
    // Do something with the compressed image

    // print('Original image path: ${image?.path}');
    notifyListeners();
    // print('Compressed image path: ${comp?.} bytes');
  }

  Future<void> pickFile() async {
    try {
      final FilePicker picker = FilePicker.platform;
      final result = await picker.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        // pdf size
        log('Selected file: ${result.files.first.name}');
        log('File size: ${result.files.first.size} bytes');
        final bytes = await File(
          result.files.single.path!,
        ).readAsBytes(); // size in bytes
        final archivefile = ArchiveFile(
          result.files.first.name,
          bytes.length,
          bytes,
        );
        final archive = Archive()..addFile(archivefile);
        final encoderArchive = ZipEncoder().encode(archive);

        // if (encoderArchive.isEmpty) return;
        // final fileName = result.files.first.name.split(RegExp(r'\.+')).first;
        // final path = await picker.getDirectoryPath() ?? "";
        // final outputFile = File('$path/$fileName.zip');
        // await outputFile.writeAsBytes(encoderArchive);
        file = encoderArchive.isNotEmpty
            ? File(result.files.first.path!)
            : null; // Use the original file path for the PDF viewer
        log("zip file size: ${encoderArchive.length / 1024 / 1024} MB");
      } else {
        log('No file selected');
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> extractFileFromArchive() async {
  //   try {
  //     final FilePicker picker = FilePicker.platform;
  //     final result = await picker.pickFiles();
  //     if (result != null && result.files.isNotEmpty) {
  //       final bytes = await File(
  //         result.files.single.path!,
  //       ).readAsBytes(); // size in bytes
  //       final archive = ZipDecoder().decodeBytes(bytes);

  //       for (final file in archive) {
  //         if (file.isFile) {
  //           final outputPath = '${Directory.systemTemp.path}/${file.name}';
  //           final outputFile = File(outputPath);
  //           await outputFile.create(recursive: true);
  //           await outputFile.writeAsBytes(file.content as List<int>);
  //           log('Extracted file path: $outputPath');
  //         }
  //       }
  //     } else {
  //       log('No file selected');
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<File?> extractPdfFromZip(File zipFile) async {
  //   final bytes = zipFile.readAsBytesSync();
  //   final archive = ZipDecoder().decodeBytes(bytes);

  //   final tempDir = await getTemporaryDirectory();

  //   for (final file in archive) {
  //     if (file.isFile && file.name.toLowerCase().endsWith('.pdf')) {
  //       final pdfPath = p.join(tempDir.path, file.name);
  //       final pdfFile = File(pdfPath);

  //       await pdfFile.create(recursive: true);
  //       await pdfFile.writeAsBytes(file.content as List<int>);

  //       return pdfFile; // return first PDF found
  //     }
  //   }
  //   return null;
  // }
}
