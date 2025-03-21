import 'package:flutter/material.dart';
import 'package:mm_book/app/pages/home/downloaded_page.dart';
import 'package:mm_book/app/pages/home/library_page.dart';

import '../pages/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(),
            LibraryPage(),
            DownloadedPage(),
            AppMorePage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Library',
              icon: Icon(Icons.library_books_rounded),
            ),
            Tab(
              text: 'Downloaded',
              icon: Icon(Icons.download_done_rounded),
            ),
            Tab(
              text: 'More',
              icon: Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
