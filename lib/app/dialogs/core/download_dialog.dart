import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mm_book/app/extensions/double_extension.dart';

class DownloadDialog extends StatefulWidget {
  String title;
  String url;
  String message;
  String saveFullPath;
  void Function() onSuccess;
  void Function(String msg) onError;
  DownloadDialog({
    super.key,
    required this.title,
    required this.url,
    required this.saveFullPath,
    required this.message,
    required this.onError,
    required this.onSuccess,
  });

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  final dio = Dio();
  final CancelToken cancelToken = CancelToken();
  double fileSize = 0;
  double downloadedSize = 0;

  void init() async {
    try {
      //download file
      await dio.download(
        widget.url,
        widget.saveFullPath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          setState(() {
            setState(() {
              fileSize = total.toDouble();
              downloadedSize = count.toDouble();
            });
          });
        },
      );
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      widget.onError(e.toString());
    }
  }

  void _downloadCancel() {
    try {
      cancelToken.cancel();
      final file = File(widget.saveFullPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(widget.message),
            LinearProgressIndicator(
              value: fileSize == 0 ? null : downloadedSize / fileSize,
            ),
            //label
            fileSize == 0
                ? const SizedBox.shrink()
                : Text(
                    '${downloadedSize.toDouble().toFileSizeLabel()} / ${fileSize.toDouble().toFileSizeLabel()}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _downloadCancel();
          },
          child: const Text('Cancel'),
        ),
        // fileSize.toInt() == downloadedSize.toInt()
        //     ? TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: const Text('Close'),
        //       )
        //     : SizedBox.shrink(),
      ],
    );
  }
}
