import 'package:flutter/material.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/my_libs/setting/path_util.dart';
import 'package:t_widgets/widgets/t_cache_image.dart';

class BookListItem extends StatelessWidget {
  MMBookModel book;
  void Function(MMBookModel book) onClicked;
  BookListItem({
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
              child: TCacheImage(
                url: book.coverUrl,
                width: double.infinity,
                fit: BoxFit.fill,
                cachePath: PathUtil.getCachePath(),
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
                    book.mmtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Author: ${book.author}'),
                  Text('Genres: ${book.genres}'),
                  Text('Size: ${book.size}'),
                  Text('Views: ${book.viewCount}'),
                  Text('Date: ${book.date}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
