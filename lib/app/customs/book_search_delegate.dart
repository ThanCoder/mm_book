import 'package:flutter/material.dart';
// import 'package:mm_book/app/models/m_m_book_model.dart';

// final _list = ValueNotifier<List<MMBookModel>>([]);
// final _isLoading = ValueNotifier<bool>(false);

class BookSearchDelegate extends SearchDelegate {
  BookSearchDelegate() {
    init();
  }
  void init() async {}
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _getResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _getResult();
  }

  Widget _getResult() {
    return SizedBox.shrink();
  }
}
