import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:mm_book/app/azlib/a_z_contact_info.dart';

class AZListView extends StatelessWidget {
  List<AZContactInfo> contactList;
  AZListView({super.key, required this.contactList});

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: contactList,
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final item = contactList[index];
        return item.widget;
      },
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        selectTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        selectItemDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        indexHintWidth: 96 / 2,
        indexHintHeight: 97 / 2,
        indexHintDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        indexHintTextStyle: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
          fontFamily: 'pyidaungsu',
        ),
        textStyle: TextStyle(
          fontFamily: 'pyidaungsu',
        ),
      ),
    );
  }
}
