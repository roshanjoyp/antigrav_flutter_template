/// Fluid-spacing helpers mirroring the mockup's CSS `clamp(min, vw, max)`.
library;

/// Returns `clamp(min, viewportWidth * vwFactor, max)` — the fluid value
/// used for section padding and grid gaps in the design.
double clampVw({
  required double viewportWidth,
  required double min,
  required double vwFactor,
  required double max,
}) {
  final double fluid = viewportWidth * vwFactor;
  if (fluid < min) return min;
  if (fluid > max) return max;
  return fluid;
}
