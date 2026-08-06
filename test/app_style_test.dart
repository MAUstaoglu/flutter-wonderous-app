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
