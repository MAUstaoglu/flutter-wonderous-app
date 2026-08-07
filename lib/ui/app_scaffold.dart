import 'package:flutter_watchos/flutter_watchos.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/app_scroll_behavior.dart';

class WondersAppScaffold extends StatelessWidget {
  const WondersAppScaffold({super.key, required this.child});
  final Widget child;
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    // The watch clock draws over the artwork in the top-right, and can't be moved, so hide it
    WatchStatusBar.hidden = FlutterWatchosPlatform.isWatch;
    // Listen to the device size, and update AppStyle when it changes
    final mq = MediaQuery.of(context);
    appLogic.handleAppSizeChanged(mq.size);
    // Set default timing for animations in the app
    Animate.defaultDuration = _style.times.fast;
    // Create a style object that will be passed down the widget tree
    _style = AppStyle(
      screenSize: context.sizePx,
      disableAnimations: mq.disableAnimations,
      highContrast: mq.highContrast,
    );
    return KeyedSubtree(
      key: ValueKey($styles.scale),
      child: Theme(
        data: $styles.colors.toThemeData(),
        // Provide a default texts style to allow Hero's to render text properly
        child: DefaultTextStyle(
          style: $styles.text.body,
          // Use a custom scroll behavior across entire app
          child: ScrollConfiguration(
            behavior: AppScrollBehavior(),
            // Watch physics, so the crown stops with a native bounce instead of an iOS stretch
            child: FlutterWatchosPlatform.isWatch ? WatchCrownScroll(child: child) : child,
          ),
        ),
      ),
    );
  }
}
