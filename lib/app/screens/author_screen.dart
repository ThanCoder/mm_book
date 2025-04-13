import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/azlib/a_z_contact_info.dart';
import 'package:mm_book/app/azlib/a_z_list_view.dart';
import 'package:mm_book/app/extensions/index.dart';
import 'package:mm_book/app/models/book_author_model.dart';
import 'package:mm_book/app/screens/book_show_all_screen.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';
import 'package:mm_book/app/utils/index.dart';
import 'package:mm_book/app/widgets/core/cache_image.dart';
import 'package:mm_book/app/widgets/core/index.dart';

class AuthorScreen extends StatefulWidget {
  const AuthorScreen({super.key});

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  String authorType = 'en';
  List<BookAuthorModel> list = [];

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MMBookServices.instance.getAuthorList(
        isMMBook: authorType == 'my' ? true : false,
      );

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

  Widget _getAuthorType() {
    return DropdownButton<String>(
      padding: EdgeInsets.all(5),
      value: authorType,
      items: const [
        DropdownMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem<String>(
          value: 'my',
          child: Text('Myanmar'),
        ),
      ],
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          authorType = value;
        });
        init();
      },
    );
  }

  Widget _getTitleWidget(BookAuthorModel author, {bool isAZWidet = false}) {
    if (author.imageUrl.isNotEmpty) {
      if (PlatformExtension.isDesktop()) {
        return CacheImage(
          maxWidth: 50,
          url: author.imageUrl,
          // fit: BoxFit.contain,
          cachePath: PathUtil.instance.getCachePath(),
        );
      }
      // is linux
      return CacheImage(
        maxWidth: 50,
        url: author.imageUrl,
        // fit: BoxFit.contain,
        cachePath: PathUtil.instance.getCachePath(),
      );
    }
    if (isAZWidet) {
      return ListTile(title: Text(author.title));
    }
    return Text(author.title);
  }

  Widget _getListView() {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('List Empty...'),
            IconButton(
              onPressed: init,
              icon: Icon(
                Icons.refresh,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await init();
      },
      child: CustomScrollView(
        slivers: [
          SliverList.separated(
            itemBuilder: (context, index) {
              final author = list[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookShowAllScreen(
                        title: author.title.isEmpty
                            ? author.imageUrl
                            : author.title,
                        url: author.url,
                      ),
                    ),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text('${index + 1}'),
                        _getTitleWidget(author),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }

  List<AZContactInfo> _getAZContacts() {
    List<AZContactInfo> azList = [];
    var tag = '';
    azList = list.map((ba) {
      if (ba.title.isNotEmpty) {
        tag = ba.title.toUpperCase().substring(0, 1);
      }
      // print(tag);
      return AZContactInfo(
          widget: _getTitleWidget(ba, isAZWidet: true), tag: tag);
    }).toList();
    // print(azList);
    return azList;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        // title: Text('Author'),
        title: Row(
          spacing: 5,
          children: [
            const Text('Author'),
            _getAuthorType(),
          ],
        ),

        actions: [
          Platform.isLinux
              ? IconButton(
                  onPressed: init,
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: isLoading
          ? TLoader()
          : authorType == 'en'
              ? AZListView(contactList: _getAZContacts())
              : _getListView(),
    );
  }
}
