import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/pdf_readers/pdf_config_model.dart';
import 'package:mm_book/app/utils/index.dart';

class PdfConfigServices {
  static Future<PdfConfigModel> getConfig({required String cacheName}) async {
    var config = PdfConfigModel();
    try {
      final file = File('${PathUtil.instance.getCachePath()}/$cacheName.json');
      if (!await file.exists()) return config;
      final json = jsonDecode(await file.readAsString());
      config = PdfConfigModel.fromMap(json);
    } catch (e) {
      debugPrint('PdfConfigServices->getConfig: ${e.toString()}');
    }

    return config;
  }

  static Future<void> setConfig(
      {required String cacheName, required PdfConfigModel config}) async {
    try {
      final file = File('${PathUtil.instance.getCachePath()}/$cacheName.json');
      await file.writeAsString(jsonEncode(config.toMap()));
    } catch (e) {
      debugPrint('PdfConfigServices->setConfig: ${e.toString()}');
    }
  }
}
