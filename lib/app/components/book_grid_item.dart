import 'package:flutter/material.dart';

import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/my_libs/setting/path_util.dart';
import 'package:t_widgets/t_widgets.dart' show TCacheImage;

class BookGridItem extends StatelessWidget {
  MMBookModel book;
  void Function(MMBookModel book) onClicked;
  BookGridItem({
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
        child: Stack(
          children: [
            TCacheImage(
              url: book.coverUrl,
              width: double.infinity,
              cachePath: PathUtil.getCachePath(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(185, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  book.mmtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
