import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/dialogs/book_download_link_preparing_dialog.dart';
import 'package:mm_book/app/dialogs/core/download_dialog.dart';
import 'package:mm_book/app/go_route_helper.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/my_libs/setting/path_util.dart';
import 'package:mm_book/my_libs/setting/t_messenger.dart';
import 'package:t_widgets/widgets/t_cache_image.dart';
import 'package:than_pkg/than_pkg.dart';

class BookContentDialog extends StatefulWidget {
  MMBookModel book;
  BookContentDialog({
    super.key,
    required this.book,
  });

  @override
  State<BookContentDialog> createState() => _BookContentDialogState();
}

class _BookContentDialogState extends State<BookContentDialog> {
  void onDownload() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BookDownloadLinkPreparingDialog(
        book: widget.book,
        submitTitle: 'Download',
        onSubmit: (url) => _download(ctx, url),
      ),
    );
  }

  void _download(BuildContext ctx, String downloadUrl) async {
    try {
      //check storage permission
      if (Platform.isAndroid) {
        if (!await ThanPkg.android.permission.isStoragePermissionGranted()) {
          await ThanPkg.android.permission.requestStoragePermission();
          return;
        }
      }
      final title = widget.book.mmtitle;
      final savePath = '${PathUtil.getOutPath()}/$title.pdf';

      if (!ctx.mounted) return;
      showDialog(
        context: ctx,
        builder: (context) => DownloadDialog(
          title: 'Downloader',
          url: downloadUrl,
          saveFullPath: savePath,
          message: '`$title` Downloading...',
          onError: (msg) {
            TMessenger.instance.showDialogMessage(context, msg);
          },
          onSuccess: () {
            TMessenger.instance
                .showDialogMessage(context, 'Download လုပ်ပြီးပါပြီ');
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onRead() async {
    //check storage permission
    if (Platform.isAndroid) {
      if (!await ThanPkg.android.permission.isStoragePermissionGranted()) {
        await ThanPkg.android.permission.requestStoragePermission();
        return;
      }
    }
    if (!mounted) return;
    //file ရှိနေလား စစ်မယ်
    final title = widget.book.mmtitle;
    final filePath = '${PathUtil.getOutPath()}/$title.pdf';

    if (File(filePath).existsSync()) {
      goPdfReader(context, filePath);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookDownloadLinkPreparingDialog(
        book: widget.book,
        submitTitle: 'ဖတ်မယ်',
        onSubmit: (downloadUrl) async {
          goPdfReader(context, downloadUrl);
        },
      ),
    );
    // final url = await MMBookServices.instance.getDownloadLink(widget.book.url);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                SizedBox(
                  width: 150,
                  height: 170,
                  child: TCacheImage(
                    url: widget.book.coverUrl,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    cachePath: PathUtil.getCachePath(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    Text(widget.book.title),
                    Text(widget.book.mmtitle),
                    Text('Author: ${widget.book.author}'),
                    Text('Genres: ${widget.book.genres}'),
                    Text('Size: ${widget.book.size}'),
                    Text('Views: ${widget.book.viewCount}'),
                    Text('Date: ${widget.book.date}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDownload();
          },
          child: Text('Download'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onRead();
          },
          child: Text('Read'),
        ),
      ],
    );
  }
}
