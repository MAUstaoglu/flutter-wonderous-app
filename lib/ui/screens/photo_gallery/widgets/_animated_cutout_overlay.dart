part of '../photo_gallery.dart';

/// An overlay with a animated cutout in the middle.
/// When animationKey changes, the box animates its size, shrinking then returning to its original size.
/// Uses[_CutoutClipper] to create the cutout.
class _AnimatedCutoutOverlay extends StatelessWidget {
  const _AnimatedCutoutOverlay({
    super.key,
    required this.child,
    required this.cutoutSize,
    this.cutoutOffset = Offset.zero,
    required this.animationKey,
    this.duration,
    required this.swipeDir,
    required this.opacity,
    required this.enabled,
  });
  final Widget child;
  final Size cutoutSize;

  /// Shift of the cutout from the center of this overlay, for when the grid it frames
  /// isn't centered in the full screen (eg. on a watch, where the tab bar takes a share).
  final Offset cutoutOffset;
  final Key animationKey;
  final Offset swipeDir;
  final Duration? duration;
  final double opacity;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        Animate(
          effects: [
            CustomEffect(builder: _buildAnimatedCutout, curve: Curves.easeOut, duration: duration),
          ],
          key: animationKey,
          onComplete: (c) => c.reverse(),
          child: IgnorePointer(
            child: Container(color: Colors.black.withValues(alpha: opacity)),
          ),
        ),
      ],
    );
  }

  /// Scales from 1 --> (1 - scaleAmt) --> 1
  Widget _buildAnimatedCutout(BuildContext context, double anim, Widget child) {
    // controls how much the center cutout will shrink when changing images
    const scaleAmt = .25;
    final size = Size(
      cutoutSize.width * (1 - scaleAmt * anim * swipeDir.dx.abs()),
      cutoutSize.height * (1 - scaleAmt * anim * swipeDir.dy.abs()),
    );
    return ClipPath(clipper: _CutoutClipper(size, cutoutOffset), child: child);
  }
}

/// Creates an overlay with a hole in the middle of a certain size.
class _CutoutClipper extends CustomClipper<Path> {
  _CutoutClipper(this.cutoutSize, this.cutoutOffset);
  final Size cutoutSize;
  final Offset cutoutOffset;

  @override
  Path getClip(Size size) {
    final double left = (size.width - cutoutSize.width) / 2 + cutoutOffset.dx;
    final double top = (size.height - cutoutSize.height) / 2 + cutoutOffset.dy;

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addRRect(
          RRect.fromLTRBR(
            left,
            top,
            left + cutoutSize.width,
            top + cutoutSize.height,
            Radius.circular(6),
          ),
        )
        ..close(),
    );
  }

  @override
  bool shouldReclip(_CutoutClipper oldClipper) =>
      oldClipper.cutoutSize != cutoutSize || oldClipper.cutoutOffset != cutoutOffset;
}
