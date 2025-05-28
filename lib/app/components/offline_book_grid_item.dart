import 'package:flutter/material.dart';
import 'package:mm_book/app/models/offline_book_model.dart';
import 'package:t_widgets/widgets/t_image_file.dart';


class OfflineBookGridItem extends StatelessWidget {
  OfflineBookModel book;
  void Function(OfflineBookModel book) onClicked;
  OfflineBookGridItem({
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
            Column(
              children: [
                Expanded(
                  child: TImageFile(
                    path: book.coverPath,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
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
                  book.title,
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
