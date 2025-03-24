import 'dart:io';

import 'package:android_battery_optimizations/android_battery_optimizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/routes/routes.dart';
import 'package:otter_study/utils/catcher_2_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setPrefix("goktech.");

  const prod = bool.fromEnvironment("dart.vm.product");
  if (!prod) {
    bool batteryOpt = await AndroidBatteryOptimizations.isEnabled();
    if (Platform.isAndroid && batteryOpt) {
      await AndroidBatteryOptimizations.showPermissionDialog();
    }
  }

  MediaKit.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  Request();
  final Catcher2Options debugConfig = Catcher2Options(
    SilentReportMode(),
    [
      FileHandler(await getLogsPath()),
      ConsoleHandler(
        enableDeviceParameters: false,
        enableApplicationParameters: false,
      )
    ],
  );

  final Catcher2Options releaseConfig = Catcher2Options(
    SilentReportMode(),
    [FileHandler(await getLogsPath())],
  );

  Catcher2(
    debugConfig: debugConfig,
    releaseConfig: releaseConfig,
    runAppFunction: () {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OtterStudy',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffff9716)),
          useMaterial3: true,
          fontFamily: "Ubuntu",
          fontFamilyFallback: ["Ubuntu Mono", "MiSans", "Twemoji"]),
      getPages: Routes.pages,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
