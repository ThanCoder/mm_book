import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/components/book_grid_item.dart';
import 'package:mm_book/app/components/book_list_item.dart';
import 'package:mm_book/app/dialogs/book_content_dialog.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/app/providers/book_provider.dart';
import 'package:mm_book/my_libs/general_server/general_server_noti_button.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';

import '../../constants.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController listController = ScrollController();

  @override
  void initState() {
    super.initState();
    listController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isListItem = false;
  bool isDataLoading = false;
  double lastScroll = 0;

  void init() async {
    context.read<BookProvider>().initList();
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

  void _loadData() async {
    isDataLoading = true;
    await context.read<BookProvider>().nextPage();
    isDataLoading = false;
  }

  void _showBookContent(MMBookModel book) {
    showDialog(
      context: context,
      builder: (context) => BookContentDialog(book: book),
    );
  }

  Widget _getListView(List<MMBookModel> list, bool isLoading) {
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
        await context.read<BookProvider>().initList(isClearList: true);
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

  // void _search() {
  //   showSearch(context: context, delegate: BookSearchDelegate());
  // }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
    final isLoading = provider.isLoading;
    final list = provider.getList;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          GeneralServerNotiButton(),
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
                  onPressed: () async {
                    await context
                        .read<BookProvider>()
                        .initList(isClearList: true);
                  },
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: !isDataLoading && isLoading
          ? TLoader()
          : _getListView(list, isLoading),
    );
  }

  @override
  void dispose() {
    listController.removeListener(_onScroll);
    listController.dispose();
    super.dispose();
  }
}
