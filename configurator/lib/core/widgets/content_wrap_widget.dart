import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_constants.dart';

/// Centers content at the design's max width with the standard page
/// padding — the Flutter equivalent of the mockup's `.wrap`.
class ContentWrapWidget extends StatelessWidget {
  /// Wraps [child] in the centered content column.
  const ContentWrapWidget({super.key, required this.child});

  /// The section content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.maxContentWidth,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pagePaddingH,
        ),
        child: child,
      ),
    );
  }
}
