import 'package:flutter/material.dart';
import 'package:mm_book/app/extensions/index.dart';
import 'package:mm_book/app/pdf_readers/pdfrx_reader_screen.dart';
import 'package:mm_book/app/services/pdf_config_services.dart';

void goPdfReader(BuildContext context, String sourcePath) async {
  final name = sourcePath.getName(withExt: false);
  final config = await PdfConfigServices.getConfig(cacheName: name);

  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfrxReaderScreen(
        pdfConfig: config,
        sourcePath: sourcePath,
        title: name,
        saveConfig: (pdfConfig) async {
          await PdfConfigServices.setConfig(
            cacheName: name,
            config: pdfConfig,
          );
        },
      ),
    ),
  );
}
