import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/components/book_grid_item.dart';
import 'package:mm_book/app/components/book_list_item.dart';
import 'package:mm_book/app/dialogs/book_content_dialog.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';
import 'package:mm_book/app/utils/path_util.dart';
import 'package:mm_book/app/widgets/core/index.dart';

import '../widgets/core/cache_image.dart';

class BookShowAllScreen extends StatefulWidget {
  String title;
  String url;
  BookShowAllScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<BookShowAllScreen> createState() => _BookShowAllScreenState();
}

class _BookShowAllScreenState extends State<BookShowAllScreen> {
  final ScrollController listController = ScrollController();

  @override
  void initState() {
    super.initState();
    listController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isListItem = false;
  bool isDataLoading = false;
  bool isLoading = false;
  double lastScroll = 0;
  List<MMBookModel> list = [];
  String nextUrl = '';

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await MMBookServices.instance.getBookList(widget.url);
      nextUrl = res.nextUrl;
      list = res.list;

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

  void _loadData() async {
    try {
      if (nextUrl.isEmpty) return;
      setState(() {
        isLoading = true;
        isDataLoading = true;
      });
      final res = await MMBookServices.instance.getBookList(nextUrl);
      nextUrl = res.nextUrl;
      list.addAll(res.list);

      if (!mounted) return;
      setState(() {
        isLoading = false;
        isDataLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isDataLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  void _onScroll() {
    if (lastScroll != listController.position.maxScrollExtent &&
        listController.position.pixels >=
            listController.position.maxScrollExtent) {
      lastScroll = listController.position.maxScrollExtent;
      if (isDataLoading) return;
      _loadData();
    }
  }

  void _showBookContent(MMBookModel book) {
    showDialog(
      context: context,
      builder: (context) => BookContentDialog(book: book),
    );
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
        init();
      },
      child: CustomScrollView(
        controller: listController,
        slivers: [
          isListItem
              ? SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) => BookListItem(
                    book: list[index],
                    onClicked: _showBookContent,
                  ),
                  separatorBuilder: (context, index) => Divider(),
                )
              : SliverGrid.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final book = list[index];
                    return BookGridItem(
                      book: book,
                      onClicked: _showBookContent,
                    );
                  },
                ),
          //data loading
          SliverToBoxAdapter(
            child: isDataLoading && isLoading
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TLoader(size: 30))
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _getTitleWidget(String title) {
    if (title.endsWith('.gif')) {
      return SizedBox(
        child: CacheImage(
          url: title,
          fit: BoxFit.contain,
          cachePath: PathUtil.instance.getCachePath(),
        ),
      );
    }
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: _getTitleWidget(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isListItem = !isListItem;
              });
            },
            icon: Icon(isListItem ? Icons.grid_on_rounded : Icons.list),
          ),
          Platform.isLinux
              ? IconButton(
                  onPressed: () async {},
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: !isDataLoading && isLoading ? TLoader() : _getListView(),
    );
  }

  @override
  void dispose() {
    listController.removeListener(_onScroll);
    listController.dispose();
    super.dispose();
  }
}
