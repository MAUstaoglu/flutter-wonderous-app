import 'package:home_widget/home_widget.dart';
import 'package:wonders/logic/common/platform_info.dart';

/// Small facade for the HomeWidget package
class NativeWidgetService {
  static const _iosAppGroupId = 'group.com.gskinner.flutter.wonders.widget';
  static const _iosAppName = 'WonderousWidget';

  // Not on a watch: it reports as iOS, but the home-screen widget is the
  // iPhone's, and home_widget has no watchOS implementation to call.
  final bool isSupported = PlatformInfo.isIOS && !PlatformInfo.isWatch;

  Future<void> init() async {
    if (!isSupported) return;
    await HomeWidget.setAppGroupId(_iosAppGroupId);
  }

  Future<bool?> save<T>(String s, T value, {void Function(bool?)? onSaveComplete}) async {
    if (!isSupported) return false;
    return await HomeWidget.saveWidgetData<T>(s, value).then((value) {
      onSaveComplete?.call(value);
      return null;
    });
  }

  Future<bool?> markDirty() async {
    if (!isSupported) return false;
    return await HomeWidget.updateWidget(iOSName: _iosAppName);
  }
}
