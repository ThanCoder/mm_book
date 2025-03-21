// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:mm_book/app/constants.dart';
import 'package:mm_book/app/services/core/rabbit.dart';
import 'package:mm_book/app/services/html_dom_services.dart';

class MMBookModel {
  String title;
  String mmtitle;
  String genres;
  String url;
  String coverUrl;
  String size;
  String viewCount;
  String author;
  String date;
  MMBookModel({
    required this.title,
    this.mmtitle = '',
    required this.url,
    required this.coverUrl,
    required this.genres,
    required this.size,
    required this.viewCount,
    required this.author,
    required this.date,
  });

  factory MMBookModel.fromElement(html.Element ele) {
    final details = ele.querySelectorAll('.post-details ul li');
    final divList = ele.querySelectorAll('.panel-body .row > div');

    var mmTitle = '';
    var url =
        HtmlDomServices.getQuerySelectorAttr(ele, '.panel-heading a', 'href');
    //pdf
    final urls = ele.querySelectorAll('.footer-social2 li');
    if (urls.isNotEmpty &&
        HtmlDomServices.getQuerySelectorAttr(urls.last, 'a', 'href')
            .isNotEmpty) {
      url = HtmlDomServices.getQuerySelectorAttr(urls.last, 'a', 'href');
    }

    var size = details.last.text;
    var date = details.first.text;
    var viewCount = details.toList()[1].text;

    if (url.isNotEmpty) {
      url = '$hostUrl/$url';
    }
    if (size.isNotEmpty) {
      size = size.replaceAll(': ', '');
    }
    if (date.isNotEmpty) {
      date = date.replaceAll(': ', '');
    }
    if (viewCount.isNotEmpty) {
      viewCount = viewCount.replaceAll('View: ', '');
    }

    try {
      final res =
          HtmlDomServices.getQuerySelectorAttr(divList.last, "img", 'src');
      // title parameter ကို decode ပြုလုပ်
      final title = RegExp(r'title="([^"]+)"').firstMatch(res)?.group(1) ?? '';
      final decodedTitle = Rabbit.unicodeDecode(title);
      mmTitle = Rabbit.zg2uni(decodedTitle);
    } catch (e) {
      debugPrint(e.toString());
    }

    return MMBookModel(
      title: HtmlDomServices.getQuerySelectorText(ele, '.panel-heading a'),
      mmtitle: mmTitle,
      url: url,
      coverUrl: HtmlDomServices.getQuerySelectorAttr(
          ele, '.panel-body .img-thumbnail', 'src'),
      author:
          HtmlDomServices.getQuerySelectorText(ele, '.panel-body .author a'),
      genres: HtmlDomServices.getQuerySelectorText(ele, '.panel-body .badge'),
      size: size,
      viewCount: viewCount,
      date: date,
    );
  }

  @override
  String toString() {
    return '\ntitle: $title\nurl: $url\nmmTitle: $mmtitle\ncoverUrl: $coverUrl\ngenres: $genres\nsize: $size\nviewCount: $viewCount\nauthor: $author\ndate: $date';
  }
}
