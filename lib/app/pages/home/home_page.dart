import 'package:flutter/material.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';

import '../../constants.dart';
import '../../widgets/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // await MMBookServices.instance.getBookList('$hostUrl/ebook.html');
            final res =
                await MMBookServices.instance.getAuthorList(isMMBook: true);
            print(res.first);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
