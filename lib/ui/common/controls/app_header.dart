import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/app_icons.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showBackBtn = true,
    this.isTransparent = false,
    this.onBack,
    this.trailing,
    this.backIcon = AppIcons.prev,
    this.backBtnSemantics,
  });
  final String? title;
  final String? subtitle;
  final bool showBackBtn;
  final AppIcons backIcon;
  final String? backBtnSemantics;
  final bool isTransparent;
  final VoidCallback? onBack;
  final Widget Function(BuildContext context)? trailing;

  /// How much vertical room the header occupies.
  ///
  /// Public because a screen that draws *under* the header has to reserve the
  /// same amount, and it has to be the same number. The artifact carousel
  /// reserved `64 * scale` and left the corner inset out, so on a watch its
  /// content ran up behind the title by exactly [AppStyle.cornerInset].
  static double get height => 64 * $styles.scale + $styles.cornerInset;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isTransparent ? Colors.transparent : $styles.colors.black,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          // Corner inset goes on the height too, or the centered btns stay tight to the top.
          height: height,
          child: Stack(
            children: [
              MergeSemantics(
                child: Semantics(
                  header: true,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!.toUpperCase(),
                            textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                            style: $styles.text.h4.copyWith(
                              color: $styles.colors.offWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle!.toUpperCase(),
                            textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                            style: $styles.text.title1.copyWith(color: $styles.colors.accent1),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Row(
                    children: [
                      // Corner btns need to clear the rounded display corner
                      Gap($styles.insets.sm + $styles.cornerInset),
                      if (showBackBtn)
                        BackBtn(
                          onPressed: onBack,
                          icon: backIcon,
                          semanticLabel: backBtnSemantics,
                        ),
                      Spacer(),
                      if (trailing != null) trailing!.call(context),
                      Gap($styles.insets.sm + $styles.cornerInset),
                      //if (showBackBtn) Container(width: $styles.insets.lg * 2, alignment: Alignment.centerLeft, child: child),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
