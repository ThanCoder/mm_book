import 'package:flutter/material.dart';
import 'package:mm_book/app/providers/book_provider.dart';
import 'package:mm_book/app/services/core/dio_services.dart';
import 'package:mm_book/my_libs/general_server/index.dart';
import 'package:mm_book/my_libs/setting/app_notifier.dart';
import 'package:mm_book/my_libs/setting/setting.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.instance.init();
  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/logo.png',
    getDarkMode: () => appConfigNotifier.value.isDarkTheme,
    onDownloadCacheImage: (url, savePath) async {
      await DioServices.instance.downloadCover(url: url, savePath: savePath);
    },
  );

  //init config
  await Setting.initAppConfigService();

  await GeneralServices.instance.init(packageName: 'mm_book');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
