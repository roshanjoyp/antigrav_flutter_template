import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/section_head_widget.dart';

/// Section .03 — hairline grid of what ships in every download. Hovering
/// a cell recedes its siblings to 40% (visual state only).
class InsideSectionWidget extends StatefulWidget {
  /// Creates the what's-inside grid.
  const InsideSectionWidget({super.key});

  @override
  State<InsideSectionWidget> createState() => _InsideSectionWidgetState();
}

class _InsideSectionWidgetState extends State<InsideSectionWidget> {
  static const List<(String, String)> _cells = [
    (
      'Clean architecture',
      'Presentation, domain, and data layers in every feature. One fully '
          'worked Firestore example traces the whole flow.',
    ),
    (
      'Riverpod + go_router',
      'Code-generated providers and typed routing. No flavor menu of state '
          'managers — one good way, documented.',
    ),
    (
      'Result-typed errors',
      'Every repository returns Result<T>. Failures are values, not '
          'surprises three layers up.',
    ),
    (
      'Service layer',
      'Logging, analytics, crash reporting, storage, permissions, '
          'connectivity, HTTP networking — behind interfaces with stub '
          'and real implementations, swappable per backend.',
    ),
    (
      'Tests that exist',
      '81% line coverage: unit, widget, and provider tests, written as the '
          'pattern for your own features.',
    ),
    (
      'Guide + doctor',
      'Docs generated for your configuration — no chapters for modules you '
          'didn\'t buy — plus a setup doctor and readiness checklist.',
    ),
  ];

  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int columns = width > 800 ? 3 : 1;

    return ContentWrapWidget(
      child: Column(
        children: [
          const SectionHeadWidget(
            number: '.03',
            title: 'In every download',
            lede:
                'Opinionated where it matters. One state management, one '
                'router, one way to handle errors — every generated app '
                'reads the same way.',
          ),
          SizedBox(
            height: clampVw(
              viewportWidth: width,
              min: AppConstants.secHeadGapMin,
              vwFactor: AppConstants.secHeadGapVw,
              max: AppConstants.secHeadGapMax,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.line),
                left: BorderSide(color: AppColors.line),
              ),
            ),
            child: Column(
              children: [
                for (int row = 0; row < _cells.length / columns; row++)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int col = 0; col < columns; col++)
                          Expanded(child: _cell(row * columns + col)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(int index) {
    final (String, String) cell = _cells[index];
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = index),
      onExit: (_) => setState(() => _hovered = null),
      child: AnimatedOpacity(
        duration: AppConstants.hoverMedium,
        opacity: _hovered == null || _hovered == index ? 1 : 0.4,
        child: Container(
          padding: const EdgeInsets.fromLTRB(38, 46, 38, 52),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: AppColors.line),
              bottom: BorderSide(color: AppColors.line),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cell.$1.toUpperCase(),
                style: AppTypography.disp(
                  size: 12,
                  weight: 500,
                  trackingEm: 0.26,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                cell.$2,
                style: AppTypography.text(
                  size: 14,
                  color: AppColors.muted,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
