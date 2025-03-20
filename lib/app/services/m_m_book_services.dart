import 'package:html/dom.dart' as html;
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/models/book_author_model.dart';
import 'package:mm_book/app/models/book_genres_model.dart';
import 'package:mm_book/app/models/m_m_book_model.dart';
import 'package:mm_book/app/services/index.dart';

class MMBookServicesResponse {
  List<MMBookModel> list;
  String nextUrl;
  MMBookServicesResponse({
    required this.list,
    required this.nextUrl,
  });
}

class MMBookServices {
  static final MMBookServices instance = MMBookServices._();
  MMBookServices._();
  factory MMBookServices() => instance;

  //book list
  Future<MMBookServicesResponse> getBookList(String url) async {
    List<MMBookModel> list = [];
    final res = await DioServices.instance.getDio.get(url);
    final dom = html.Document.html(res.data.toString());
    var nextUrl = getNextUrl(dom);
    //get next url

    for (var ele in dom.querySelectorAll('.container .panel')) {
      final book = MMBookModel.fromElement(ele);
      list.add(book);
    }

    return MMBookServicesResponse(list: list, nextUrl: nextUrl);
  }

  String getNextUrl(html.Document dom) {
    var res = '';
    for (var ele in dom.querySelectorAll('.pagination li a')) {
      if (ele.attributes['title'] == 'Next') {
        final url = ele.attributes['href'] ?? '';
        res = '$hostUrl/$url';
        break;
      }
    }
    return res;
  }

  //genres
  Future<List<BookGenresModel>> getGenresList() async {
    List<BookGenresModel> list = [];
    final res = await DioServices.instance.getDio.get('$hostUrl/ebook.html');
    final dom = html.Document.html(res.data.toString());
    for (var ele in dom.querySelectorAll('.row table tr')) {
      final genres = BookGenresModel.fromElement(ele);
      list.add(genres);
    }
    return list;
  }

  //authors
  Future<List<BookAuthorModel>> getAuthorList({
    bool isMMBook = false,
  }) async {
    List<BookAuthorModel> list = [];
    final res = await DioServices.instance.getDio
        .get('$hostUrl/author.html${isMMBook ? '?name=m' : ''}');
    final dom = html.Document.html(res.data.toString());
    for (var ele
        in dom.querySelectorAll('#tab-${isMMBook ? '2' : '1'} .row table tr')) {
      final author = BookAuthorModel.fromElement(ele, isMMbook: isMMBook);
      list.add(author);
    }
    return list;
  }
}
