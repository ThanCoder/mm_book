import 'package:flutter/material.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/app/services/core/dio_services.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';


class BookDownloadLinkPreparingDialog extends StatefulWidget {
  MMBookModel book;
  String submitTitle;
  void Function(String downloadUrl) onSubmit;
  BookDownloadLinkPreparingDialog({
    super.key,
    required this.book,
    required this.onSubmit,
    this.submitTitle = 'Submit',
  });

  @override
  State<BookDownloadLinkPreparingDialog> createState() =>
      _BookDownloadLinkPreparingDialogState();
}

class _BookDownloadLinkPreparingDialogState
    extends State<BookDownloadLinkPreparingDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;
  String? url;
  int size = 0;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      url = await MMBookServices.instance.getDownloadLink(widget.book.url);
      if (url != null) {
        size = await DioServices.instance.getContentSize(url.toString()) ?? 0;
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: isLoading
            ? Column(
                spacing: 5,
                children: [
                  TLoader(),
                  Text('Download link ပြင်ဆင်နေပါတယ်.....')
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text('Url: ${url.toString()}'),
                  Text(
                      'Size: ${size.toDouble().toFileSizeLabel()}'),
                  size == 0
                      ? Text(
                          'File မရှိပါ!.....',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: Text('Cancel'),
        ),
        size == 0
            ? SizedBox.shrink()
            : TextButton(
                onPressed: isLoading && url == null
                    ? null
                    : () {
                        Navigator.pop(context);
                        widget.onSubmit(url.toString());
                      },
                child: Text(widget.submitTitle),
              ),
      ],
    );
  }
}
