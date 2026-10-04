import 'dart:ui';

import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/common/platform_info.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    super.key,
    this.strength = 1,
    this.child,
  });

  final double strength;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double normalStrength = clampDouble(strength, 0, 1);
    // Not on a watch yet: there a BackdropFilter fails to draw with
    // flutter-watchos 0.1.1 and earlier, so the watch gets the plain fill.
    if (settingsLogic.useBlurs && !PlatformInfo.isWatch) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: normalStrength * 15, sigmaY: normalStrength * 15),
        child: child ?? SizedBox.expand(),
      );
    }
    final fill = Container(color: $styles.colors.black.withValues(alpha: .8 * strength));
    return child == null
        ? fill
        : Stack(
            children: [
              child!,
              Positioned.fill(child: fill),
            ],
          );
  }
}
