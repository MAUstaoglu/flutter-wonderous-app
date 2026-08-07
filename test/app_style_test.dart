import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonders/styles/styles.dart';

/// Guards the one property the watch layout rests on: above the watch tier, every factor the
/// watch introduced is an identity, so phone and tablet render exactly what was authored.
void main() {
  group('AppStyle scale tiers', () {
    test('phone and tablet are untouched by the watch factors', () {
      final sizes = {
        'phone': Size(440, 956),
        'tablet lg': Size(834, 1194),
        'tablet xl': Size(1024, 1366),
      };
      for (final entry in sizes.entries) {
        final style = AppStyle(screenSize: entry.value);
        expect(style.isWatchTier, isFalse, reason: entry.key);
        expect(style.fixedScale, 1, reason: entry.key);
        expect(style.cornerInset, 0, reason: entry.key);
        expect(style.insetScale, style.scale, reason: entry.key);
      }
    });

    test('a watch shrinks fixed sizes, and its padding harder still', () {
      final style = AppStyle(screenSize: Size(208, 248));
      expect(style.isWatchTier, isTrue);
      expect(style.scale, lessThan(1));
      expect(style.fixedScale, style.scale);
      expect(style.insetScale, lessThan(style.scale));
      expect(style.cornerInset, greaterThan(0));
    });

    test('a smaller watch gets smaller factors, not the same ones', () {
      // Measured logical sizes: Flutter is handed WKInterfaceDevice.screenBounds,
      // so these are about half the pixel dimensions.
      final small = AppStyle(screenSize: Size(187, 223)); // 42mm
      final mid = AppStyle(screenSize: Size(208, 248)); // 46mm
      final large = AppStyle(screenSize: Size(211, 257)); // Ultra 49mm

      for (final style in <AppStyle>[small, mid, large]) {
        expect(style.isWatchTier, isTrue);
      }
      // A flat factor for every watch is the bug this guards: the 42mm is 11%
      // narrower than the Ultra, so it must not receive identical sizes.
      expect(small.scale, lessThan(mid.scale));
      expect(mid.scale, lessThan(large.scale));
      expect(small.insetScale, lessThan(large.insetScale));
      expect(small.cornerInset, lessThan(large.cornerInset));

      // The widest watch is the reference, so it keeps the authored values.
      expect(large.scale, closeTo(0.55, 0.001));
      expect(large.insetScale, closeTo(0.4, 0.001));
      expect(large.cornerInset, closeTo(14, 0.001));

      // And the smallest tracks its width rather than drifting arbitrarily.
      expect(small.scale, closeTo(0.55 * 187 / 211, 0.001));
    });

    test('the smallest phone stays on the phone tier', () {
      // 320pt is the narrowest phone we care about, and the watch tier starts below 300.
      final style = AppStyle(screenSize: Size(320, 568));
      expect(style.isWatchTier, isFalse);
      expect(style.scale, 1);
    });

    test('no screen size yet reads as a phone', () {
      final style = AppStyle();
      expect(style.scale, 1);
      expect(style.isWatchTier, isFalse);
      expect(style.fixedScale, 1);
      expect(style.insetScale, 1);
      expect(style.cornerInset, 0);
    });
  });
}
