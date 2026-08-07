import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_watchos/flutter_watchos.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wonders/common_libs.dart';

class PlatformInfo {
  static const _desktopPlatforms = [
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.linux,
  ];
  static const _mobilePlatforms = [TargetPlatform.android, TargetPlatform.iOS];

  static bool get isDesktop => _desktopPlatforms.contains(defaultTargetPlatform) && !kIsWeb;
  static bool get isDesktopOrWeb => isDesktop || kIsWeb;
  static bool get isMobile => _mobilePlatforms.contains(defaultTargetPlatform) && !kIsWeb;

  static double get pixelRatio => WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Apple Watch. A subset of [isIOS] and [isMobile], which are both true there too, so
  /// anything that needs a real iPhone/iPad has to exclude the watch explicitly.
  static bool get isWatch => !kIsWeb && FlutterWatchosPlatform.isWatch;

  static Future<bool> get isConnected async => await InternetConnectionChecker.instance.hasConnection;
  static Future<bool> get isDisconnected async => (await isConnected) == false;
}
