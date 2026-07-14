import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/bottom_cta_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/configure_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/hero_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/inside_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/metrics_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/process_band_section_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/top_nav_widget.dart';

/// The single-page configurator: sticky nav above one scroll view that
/// assembles every section in the design's order.
class ConfiguratorScreen extends StatefulWidget {
  /// Creates the screen.
  const ConfiguratorScreen({super.key});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey _configureKey = GlobalKey();
  final GlobalKey _processKey = GlobalKey();
  final GlobalKey _insideKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final BuildContext? target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double sectionPad = clampVw(
      viewportWidth: width,
      min: AppConstants.sectionPadMin,
      vwFactor: AppConstants.sectionPadVw,
      max: AppConstants.sectionPadMax,
    );

    return Scaffold(
      body: Column(
        children: [
          TopNavWidget(
            onConfigure: () => _scrollTo(_configureKey),
            onProcess: () => _scrollTo(_processKey),
            onInside: () => _scrollTo(_insideKey),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSectionWidget(
                    onConfigure: () => _scrollTo(_configureKey),
                  ),
                  const MetricsSectionWidget(),
                  SizedBox(height: sectionPad),
                  KeyedSubtree(
                    key: _configureKey,
                    child: const ConfigureSectionWidget(),
                  ),
                  SizedBox(height: sectionPad),
                  KeyedSubtree(
                    key: _processKey,
                    child: const ProcessBandSectionWidget(),
                  ),
                  SizedBox(height: sectionPad),
                  KeyedSubtree(
                    key: _insideKey,
                    child: const InsideSectionWidget(),
                  ),
                  SizedBox(height: sectionPad),
                  BottomCtaSectionWidget(
                    onConfigure: () => _scrollTo(_configureKey),
                  ),
                  SizedBox(height: sectionPad),
                  const FooterSectionWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
