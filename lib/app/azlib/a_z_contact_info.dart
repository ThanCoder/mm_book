import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class AZContactInfo extends ISuspensionBean {
  final Widget widget;
  final String tag;

  AZContactInfo({required this.widget, required this.tag});

  @override
  String getSuspensionTag() {
    return tag;
  }

  @override
  String toString() {
    return tag;
  }
}
