import 'package:flutter/material.dart';
import 'package:mm_book/app/models/offline_book_model.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';


class OfflineBookListItem extends StatelessWidget {
  OfflineBookModel book;
  void Function(OfflineBookModel book) onClicked;
  OfflineBookListItem({
    super.key,
    required this.book,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(book),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          spacing: 5,
          children: [
            SizedBox(
              width: 150,
              height: 170,
              child: TImageFile(
                path: book.coverPath,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                      'Size: ${book.size.toDouble().toFileSizeLabel()}'),
                  Text('Date: ${DateTime.fromMillisecondsSinceEpoch(book.date).toParseTime()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
