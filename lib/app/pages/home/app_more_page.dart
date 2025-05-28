import 'package:flutter/material.dart';
import 'package:mm_book/my_libs/clean_cache/cache_component.dart';
import 'package:mm_book/my_libs/setting/app_setting_screen.dart';
import 'package:mm_book/my_libs/setting/theme_component.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';


class AppMorePage extends StatelessWidget {
  const AppMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //theme
            ThemeComponent(),
            //version
            TListTileWithDesc(
              leading: Icon(Icons.settings),
              title: 'Setting',
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppSettingScreen(),
                  ),
                );
              },
            ),
            //Clean Cache
            CacheComponent(),

            //version
            const Divider(),
            FutureBuilder(
              future: ThanPkg.platform.getPackageInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return TLoader();
                }
                if (snapshot.hasError) {
                  return Text('error');
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return TListTileWithDesc(
                    leading: Icon(Icons.cloud_upload_rounded),
                    title: 'Check Version',
                    desc: 'Current Version - ${snapshot.data!.version}',
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
