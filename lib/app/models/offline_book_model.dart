// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:mm_book/app/extensions/string_extension.dart';
import 'package:mm_book/my_libs/setting/path_util.dart';

class OfflineBookModel {
  String title;
  String path;
  String coverPath;
  int size;
  int date;
  OfflineBookModel({
    required this.title,
    required this.path,
    required this.coverPath,
    required this.size,
    required this.date,
  });

  factory OfflineBookModel.fromPath(String path) {
    final file = File(path);
    final title = path.getName(withExt: false);
    return OfflineBookModel(
      title: title,
      path: path,
      coverPath: '${PathUtil.getCachePath()}/$title.png',
      size: file.statSync().size,
      date: file.statSync().modified.millisecondsSinceEpoch,
    );
  }
}
