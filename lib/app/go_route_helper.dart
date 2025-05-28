import 'package:flutter/material.dart';
import 'package:mm_book/my_libs/pdf_readers/pdf_config_model.dart';
import 'package:mm_book/my_libs/pdf_readers/pdfrx_reader_screen.dart';
import 'package:than_pkg/than_pkg.dart';

void goPdfReader(BuildContext context, String sourcePath) async {
  final name = sourcePath.getName(withExt: false);
  // final config = await PdfConfigServices.getConfig(cacheName: name);

  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfrxReaderScreen(
        pdfConfig: PdfConfigModel.fromCache(name),
        sourcePath: sourcePath,
        title: name,
        saveConfig: (pdfConfig) async {
          pdfConfig.saveConfigCache(cacheName: name);
        },
      ),
    ),
  );
}
