// ignore_for_file: library_private_types_in_public_api

import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/utils/duration_utils.dart';

export 'colors.dart';

@immutable
class AppStyle {
  AppStyle({Size? screenSize, this.disableAnimations = false, this.highContrast = false})
    : scale = _scaleFor(screenSize);

  /// Logical width of the widest watch, which is what the watch layout was
  /// authored against. Measured, not assumed — Flutter is handed
  /// `WKInterfaceDevice.screenBounds`, so these are roughly half the pixel
  /// dimensions and do not match the marketing sizes:
  ///
  /// | model      | logical   | physical  |
  /// |------------|-----------|-----------|
  /// | 42mm       | 187 x 223 | 374 x 446 |
  /// | 46mm       | 208 x 248 | 416 x 496 |
  /// | Ultra 49mm | 211 x 257 | 422 x 514 |
  static const double _watchReferenceWidth = 211;

  /// Scale on the reference watch. Every other watch takes a share of it.
  static const double _watchScale = 0.55;

  static double _scaleFor(Size? screenSize) {
    if (screenSize == null) return 1;
    const tabletXl = 1000;
    const tabletLg = 800;
    // Watch screens are ~200pt across, well below the ~320pt of the smallest phone.
    const watch = 300;
    final shortestSide = screenSize.shortestSide;
    if (shortestSide > tabletXl) return 1.2;
    if (shortestSide > tabletLg) return 1.1;
    if (shortestSide < watch) {
      // Proportional, not flat. A 42mm is 187pt where an Ultra is 211 — 11%
      // narrower — so a single factor tuned on the big watch leaves the small
      // one with the same absolute sizes on less screen, and content that just
      // fits at the top of the range overflows at the bottom.
      return _watchScale * (shortestSide / _watchReferenceWidth);
    }
    return 1;
  }

  final double scale;

  /// Whether the layout is running on a watch-sized screen. Note this is about the screen, not
  /// the OS: use [PlatformInfo.isWatch] for anything that depends on watchOS itself, like a
  /// plugin that has no implementation there.
  bool get isWatchTier => scale < 1;

  /// How this watch compares to the one the layout was authored on: 1.0 on the
  /// widest, ~0.89 on a 42mm. Zero outside the watch tier, where it is unused.
  double get _watchFactor => isWatchTier ? scale / _watchScale : 0;

  /// Scale applied to [insets] only. A watch is ~87% as wide as a phone but only ~49% as tall,
  /// so the constraint is the aspect ratio, and padding has to tighten harder than content.
  ///
  /// Tracks [_watchFactor] so padding shrinks with the screen rather than
  /// eating a bigger share of a small one.
  double get insetScale => isWatchTier ? 0.4 * _watchFactor : scale;

  /// Shrink factor for fixed px sizes that don't go through [scale] (tab bar, chrome, imagery).
  /// Pinned to 1 above the watch tier, so phone and tablet keep the values as written.
  double get fixedScale => isWatchTier ? scale : 1;

  /// Extra inset for controls in a screen corner. A watch display is a rounded rect, so a control
  /// at the edge is cut by the bezel. Zero elsewhere; full-bleed art ignores it.
  ///
  /// 14 is derived from the widest watch's corner radius and scales with the
  /// screen. The radius still isn't reported to Flutter, so this tracks width
  /// as a proxy — imperfect, but far closer than one constant for every model.
  double get cornerInset => isWatchTier ? 14 * _watchFactor : 0;
  late final bool disableAnimations;
  late final bool highContrast;

  /// The current theme colors for the app
  final AppColors colors = AppColors();

  /// Rounded edge corner radii
  late final _Corners corners = _Corners();

  late final _Shadows shadows = _Shadows();

  /// Padding and margin values
  late final _Insets insets = _Insets(insetScale);

  /// Text styles
  late final _Text text = _Text(scale);

  /// Animation Durations
  late final _Times times = _Times();

  /// Shared sizes
  late final _Sizes sizes = _Sizes();
}

@immutable
class _Text {
  _Text(this._scale);
  final double _scale;

  final Map<String, TextStyle> _titleFonts = {
    'en': TextStyle(fontFamily: 'Tenor'),
  };

  final Map<String, TextStyle> _monoTitleFonts = {
    'en': TextStyle(fontFamily: 'B612Mono'),
  };

  final Map<String, TextStyle> _quoteFonts = {
    'en': TextStyle(fontFamily: 'Cinzel'),
    'zh': TextStyle(fontFamily: 'MaShanZheng'),
  };

  final Map<String, TextStyle> _wonderTitleFonts = {
    'en': TextStyle(fontFamily: 'Yeseva'),
  };

  final Map<String, TextStyle> _contentFonts = {
    'en': TextStyle(
      fontFamily: 'Raleway',
      fontFeatures: const [
        FontFeature.enable('kern'),
      ],
    ),
  };

  TextStyle _getFontForLocale(Map<String, TextStyle> fonts) {
    if (localeLogic.isLoaded) {
      return fonts.entries.firstWhere((x) => x.key == $strings.localeName, orElse: () => fonts.entries.first).value;
    } else {
      return fonts.entries.first.value;
    }
  }

  TextStyle get titleFont => _getFontForLocale(_titleFonts);
  TextStyle get quoteFont => _getFontForLocale(_quoteFonts);
  TextStyle get wonderTitleFont => _getFontForLocale(_wonderTitleFonts);
  TextStyle get contentFont => _getFontForLocale(_contentFonts);
  TextStyle get monoTitleFont => _getFontForLocale(_monoTitleFonts);

  late final TextStyle dropCase = _createFont(quoteFont, sizePx: 56, heightPx: 20);

  late final TextStyle wonderTitle = _createFont(wonderTitleFont, sizePx: 64, heightPx: 56);

  late final TextStyle h1 = _createFont(titleFont, sizePx: 64, heightPx: 62);
  late final TextStyle h2 = _createFont(titleFont, sizePx: 32, heightPx: 46);
  late final TextStyle h3 = _createFont(
    titleFont,
    sizePx: 24,
    heightPx: 36,
    weight: FontWeight.w600,
  );
  late final TextStyle h4 = _createFont(
    contentFont,
    sizePx: 14,
    heightPx: 23,
    spacingPc: 5,
    weight: FontWeight.w600,
  );

  late final TextStyle title1 = _createFont(titleFont, sizePx: 16, heightPx: 26, spacingPc: 5);
  late final TextStyle title2 = _createFont(titleFont, sizePx: 14, heightPx: 16.38);

  late final TextStyle body = _createFont(contentFont, sizePx: 16, heightPx: 26);
  late final TextStyle bodyBold = _createFont(
    contentFont,
    sizePx: 16,
    heightPx: 26,
    weight: FontWeight.w600,
  );
  late final TextStyle bodySmall = _createFont(contentFont, sizePx: 14, heightPx: 23);
  late final TextStyle bodySmallBold = _createFont(
    contentFont,
    sizePx: 14,
    heightPx: 23,
    weight: FontWeight.w600,
  );

  late final TextStyle quote1 = _createFont(
    quoteFont,
    sizePx: 32,
    heightPx: 40,
    weight: FontWeight.w600,
    spacingPc: -3,
  );
  late final TextStyle quote2 = _createFont(
    quoteFont,
    sizePx: 21,
    heightPx: 32,
    weight: FontWeight.w400,
  );
  late final TextStyle quote2Sub = _createFont(
    body,
    sizePx: 16,
    heightPx: 40,
    weight: FontWeight.w400,
  );

  late final TextStyle caption = _createFont(
    contentFont,
    sizePx: 14,
    heightPx: 20,
    weight: FontWeight.w500,
  ).copyWith(fontStyle: FontStyle.italic);

  late final TextStyle callout = _createFont(
    contentFont,
    sizePx: 16,
    heightPx: 26,
    weight: FontWeight.w600,
  ).copyWith(fontStyle: FontStyle.italic);
  late final TextStyle btn = _createFont(
    contentFont,
    sizePx: 14,
    weight: FontWeight.w500,
    spacingPc: 2,
    heightPx: 14,
  );

  TextStyle _createFont(
    TextStyle style, {
    required double sizePx,
    double? heightPx,
    double? spacingPc,
    FontWeight? weight,
  }) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
      fontSize: sizePx,
      height: heightPx != null ? (heightPx / sizePx) : style.height,
      letterSpacing: spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
      fontWeight: weight,
    );
  }
}

@immutable
class _Times {
  _Times();
  late final Duration fast = 300.animateMs;
  late final Duration med = 600.animateMs;
  late final Duration slow = 900.animateMs;
  late final Duration extraSlow = 1300.animateMs;
  late final Duration pageTransition = 200.animateMs;
}

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

// TODO: add, @immutable when design is solidified
class _Sizes {
  double get maxContentWidth1 => 800;
  double get maxContentWidth2 => 600;
  double get maxContentWidth3 => 500;
  final Size minAppSize = Size(380, 650);
}

@immutable
class _Insets {
  _Insets(this._scale);
  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

@immutable
class _Shadows {
  final textSoft = [
    Shadow(color: Colors.black.withValues(alpha: .25), offset: Offset(0, 2), blurRadius: 4),
  ];
  final text = [
    Shadow(color: Colors.black.withValues(alpha: .6), offset: Offset(0, 2), blurRadius: 2),
  ];
  final textStrong = [
    Shadow(color: Colors.black.withValues(alpha: .6), offset: Offset(0, 4), blurRadius: 6),
  ];
}
