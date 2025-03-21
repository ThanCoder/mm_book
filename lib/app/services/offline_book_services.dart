import 'dart:io';

import 'package:mime/mime.dart';
import 'package:mm_book/app/models/offline_book_model.dart';
import 'package:mm_book/app/utils/path_util.dart';
import 'package:than_pkg/than_pkg.dart';

class OfflineBookServices {
  static final OfflineBookServices instance = OfflineBookServices._();
  OfflineBookServices._();
  factory OfflineBookServices() => instance;

  Future<List<OfflineBookModel>> getList() async {
    List<OfflineBookModel> list = [];
    final dir = Directory(PathUtil.instance.getOutPath());
    if (!await dir.exists()) return list;
    for (var file in dir.listSync()) {
      if (file.statSync().type != FileSystemEntityType.file) continue;
      //is file && check pdf
      final mime = lookupMimeType(file.path) ?? '';
      if (mime.isEmpty || !mime.startsWith('application/pdf')) continue;
      //is pdf
      list.add(OfflineBookModel.fromPath(file.path));
    }
    //sort newest book
    list.sort((a, b) {
      if (a.date > b.date) return -1;
      if (a.date < b.date) return 1;
      return 0;
    });
    //gen pdf cover
    await ThanPkg.platform.genPdfCover(
      outDirPath: PathUtil.instance.getCachePath(),
      pdfPathList: list.map((pdf) => pdf.path).toList(),
    );
    return list;
  }
}
