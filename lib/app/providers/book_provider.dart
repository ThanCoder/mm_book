import 'package:flutter/material.dart';
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';

class BookProvider with ChangeNotifier {
  final List<MMBookModel> _list = [];
  bool isLoading = false;
  String? nextUrl;

  List<MMBookModel> get getList => _list;

  Future<void> initList({bool isClearList = false}) async {
    try {
      if (!isClearList && _list.isNotEmpty) return;
      if (isClearList) {
        _list.clear();
      }
      isLoading = true;
      notifyListeners();

      final res =
          await MMBookServices.instance.getBookList('$hostUrl/ebook.html');
      _list.clear();

      _list.addAll(res.list);
      nextUrl = res.nextUrl;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('initList: ${e.toString()}');
    }
  }

  Future<void> nextPage() async {
    try {
      if (nextUrl == null || nextUrl!.isEmpty) return;
      isLoading = true;
      notifyListeners();

      final res = await MMBookServices.instance.getBookList(nextUrl.toString());
      _list.addAll(res.list);
      nextUrl = res.nextUrl;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('initList: ${e.toString()}');
    }
  }
}
