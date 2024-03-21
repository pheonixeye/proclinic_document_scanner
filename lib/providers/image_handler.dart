import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proclinic_document_scanner/errors/image_capture_failed.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:proclinic_document_scanner/errors/img_to_pdf_conversion.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';

class PxImageHandler extends ChangeNotifier {
  final picker = ImagePicker();
  final db = PxDatabase();

  XFile? _imgFile;
  XFile? get imgFile => _imgFile;

  File? _pdfFile;
  File? get pdfFile => _pdfFile;

  Future<XFile?> pickImage() async {
    try {
      _imgFile = await picker.pickImage(
        preferredCameraDevice: CameraDevice.rear,
        source: ImageSource.camera,
      );
      return _imgFile;
    } catch (e) {
      throw ImageCaptreFailedException(e.toString());
    }
  }

  Future<File?> generatePdfFile() async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(
        await imgFile!.readAsBytes(),
        dpi: 200,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.undefined,
          build: (pw.Context context) {
            return pw.Image(
              image,
              dpi: 200,
            );
          },
        ),
        index: 0,
      );

      final file = File('${DateTime.now()}.pdf');
      _pdfFile = await file.writeAsBytes(await pdf.save());
      return _pdfFile;
    } catch (e) {
      throw ImageToPdfConversionException(e.toString());
    }
  }

  Future<String?> saveFileToDatabase() async {
    final result =
        db.gridFS.createFile(pdfFile!.openRead(), pdfFile.toString());
    final file = await result.save();
    print(file.toString());
    return file.toString();
  }
}
