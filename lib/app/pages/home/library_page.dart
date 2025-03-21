import 'package:flutter/material.dart';
import 'package:mm_book/app/components/genres_view.dart';
import 'package:mm_book/app/screens/author_screen.dart';
import 'package:mm_book/app/screens/book_show_all_screen.dart';
import 'package:mm_book/app/widgets/index.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Library'),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          //author
          SliverToBoxAdapter(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthorScreen(),
                    ),
                  );
                },
                child: Text('Author && စာရေးဆရာများ'),
              ),
            )),
          ),
          //genres
          SliverToBoxAdapter(
            child: GenresView(
              onClicked: (genres) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookShowAllScreen(title: genres.title, url: genres.url),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
