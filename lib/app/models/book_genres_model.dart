import 'package:html/dom.dart' as html;
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/services/html_dom_services.dart';

class BookGenresModel {
  String title;
  String url;
  String count;
  BookGenresModel({
    required this.title,
    required this.url,
    required this.count,
  });

  factory BookGenresModel.fromElement(html.Element ele) {
    return BookGenresModel(
      title: HtmlDomServices.getQuerySelectorText(ele, 'h5'),
      url: '$hostUrl/${HtmlDomServices.getQuerySelectorAttr(ele, 'a', 'href')}',
      count: HtmlDomServices.getQuerySelectorText(ele, '.badge'),
    );
  }

  @override
  String toString() {
    return 'title: $title\nurl: $url\ncount: $count';
  }
}
