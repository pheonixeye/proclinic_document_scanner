import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/errors/image_capture_failed.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:proclinic_document_scanner/errors/img_to_pdf_conversion.dart';
import 'package:proclinic_document_scanner/errors/visit_update_failed.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';

class PxImageHandler extends ChangeNotifier {
  final picker = ImagePicker();

  XFile? _imgFile;
  XFile? get imgFile => _imgFile;

  String? _fileName;
  String? get fileName => _fileName;

  Future<XFile?> pickImage() async {
    try {
      _imgFile = await picker.pickImage(
        preferredCameraDevice: CameraDevice.rear,
        source: ImageSource.camera,
      );
      notifyListeners();
      return _imgFile;
    } catch (e) {
      throw ImageCaptreFailedException(e.toString());
    }
  }

  Future<void> generatePdfFile(String fileName) async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(
        await imgFile!.readAsBytes(),
        dpi: 72,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.undefined,
          build: (pw.Context context) {
            return pw.Image(
              image,
              dpi: 72,
            );
          },
        ),
        index: 0,
      );
      _fileName = "$fileName.pdf";

      final result =
          PxDatabase.gridFS.createFile(pdf.save().asStream(), _fileName!);
      result.contentType = "pdf";
      await result.save();
    } catch (e) {
      throw ImageToPdfConversionException(e.toString());
    }
  }

  Future<void> updateVisitEntry(
      ObjectId visitDetailsId, String attribute) async {
    try {
      final file =
          await PxDatabase.gridFS.findOne(where.eq('filename', _fileName));
      await PxDatabase.visitData.updateOne(
        where.eq("visitid", visitDetailsId),
        {
          r'$addToSet': {
            attribute: file!.id,
          }
        },
      );
    } catch (e) {
      throw VisitUpdateFailedException(e.toString());
    }
  }
}
