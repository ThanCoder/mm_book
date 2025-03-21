import 'package:html/dom.dart' as html;
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/services/core/rabbit.dart';
import 'package:mm_book/app/services/html_dom_services.dart';

class BookAuthorModel {
  String title;
  String url;
  String imageUrl;
  BookAuthorModel({
    required this.title,
    required this.url,
    this.imageUrl = '',
  });

  factory BookAuthorModel.fromElement(html.Element ele,
      {bool isMMbook = false}) {
    var title = HtmlDomServices.getQuerySelectorText(ele, 'td a');
    var imageUrl = '';

    if (isMMbook) {
      final src = HtmlDomServices.getQuerySelectorAttr(ele, "td a img", 'src');
      // title parameter ကို decode ပြုလုပ်
      // final titleReg = RegExp(r'title="([^"]+)"').firstMatch(res)?.group(1) ?? '';
      final uri = Uri.parse(src);
      final queryTitle = uri.queryParameters['title'] ?? '';
      if (queryTitle.isEmpty) {
        imageUrl = src;
      }
      final decodedTitle = Rabbit.unicodeDecode(queryTitle);
      title = Rabbit.zg2uni(decodedTitle);
      title = title.replaceAll('"', '');
    }
    return BookAuthorModel(
      title: title,
      imageUrl: imageUrl,
      url:
          '$hostUrl/${HtmlDomServices.getQuerySelectorAttr(ele, 'td a', 'href')}',
    );
  }

  @override
  String toString() {
    return '\ntitle: $title\nurl: $url\nimageUrl: $imageUrl\n';
  }
}
