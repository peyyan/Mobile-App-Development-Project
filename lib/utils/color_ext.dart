import 'dart:ui';

extension ColorOpacityFix on Color {
  Color o(double opacity) => withValues(alpha: opacity.clamp(0.0, 1.0));
}
