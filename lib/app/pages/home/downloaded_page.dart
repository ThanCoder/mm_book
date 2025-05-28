import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/components/offline_book_grid_item.dart';
import 'package:mm_book/app/components/offline_book_list_item.dart';
import 'package:mm_book/app/go_route_helper.dart';
import 'package:mm_book/app/models/offline_book_model.dart';
import 'package:mm_book/app/services/offline_book_services.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class DownloadedPage extends StatefulWidget {
  const DownloadedPage({super.key});

  @override
  State<DownloadedPage> createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isListItem = false;
  bool isLoading = false;
  List<OfflineBookModel> list = [];

  Future<void> init() async {
    try {
      //check storage permission
      if (Platform.isAndroid) {
        if (!await ThanPkg.android.permission.isStoragePermissionGranted()) {
          await ThanPkg.android.permission.requestStoragePermission();
          return;
        }
      }
      setState(() {
        isLoading = true;
      });
      list = await OfflineBookServices.instance.getList();

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

  void _showBookContent(OfflineBookModel book) async {
    goPdfReader(context, book.path);
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
          isListItem
              ? SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) => OfflineBookListItem(
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
                    return OfflineBookGridItem(
                      book: book,
                      onClicked: _showBookContent,
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Books'),
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
                  onPressed: init,
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: isLoading ? TLoader() : _getListView(),
    );
  }
}
