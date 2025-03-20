import 'package:html/dom.dart' as html;
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/services/core/rabbit.dart';
import 'package:mm_book/app/services/html_dom_services.dart';

class BookAuthorModel {
  String title;
  String url;
  BookAuthorModel({
    required this.title,
    required this.url,
  });

  factory BookAuthorModel.fromElement(html.Element ele,
      {bool isMMbook = false}) {
    var title = HtmlDomServices.getQuerySelectorText(ele, 'td a');
    if (isMMbook) {
      final res = HtmlDomServices.getQuerySelectorAttr(ele, "td a img", 'src');
      // title parameter ကို decode ပြုလုပ်
      final titleReg =
          RegExp(r'title="([^"]+)"').firstMatch(res)?.group(1) ?? '';
      final decodedTitle = Rabbit.unicodeDecode(titleReg);
      title = Rabbit.zg2uni(decodedTitle);
    }
    return BookAuthorModel(
      title: title,
      url:
          '$hostUrl/${HtmlDomServices.getQuerySelectorAttr(ele, 'td a', 'href')}',
    );
  }

  @override
  String toString() {
    return 'title: $title\nurl: $url\n';
  }
}
