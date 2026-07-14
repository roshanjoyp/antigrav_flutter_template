import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/craft_button_widget.dart';
import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/domain/preview_derivations.dart';
import 'package:craft_configurator/features/configurator/presentation/configurator_controller.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/preview_head_widget.dart';
import 'package:craft_configurator/features/configurator/presentation/widgets/preview_panes_widget.dart';

/// The floating live-preview card: zip name, summary, three tabs, and the
/// download action. Re-renders from the configuration on every change —
/// the product's core demo moment.
class PreviewPanelWidget extends ConsumerStatefulWidget {
  /// Creates the preview panel.
  const PreviewPanelWidget({super.key});

  @override
  ConsumerState<PreviewPanelWidget> createState() => _PreviewPanelWidgetState();
}

class _PreviewPanelWidgetState extends ConsumerState<PreviewPanelWidget> {
  static const List<String> _tabs = ['Files', 'pubspec.yaml', 'Setup steps'];

  int _tab = 0;
  bool _toastVisible = false;
  Timer? _toastTimer;

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _download() {
    final bool downloaded = ref
        .read(configuratorControllerProvider.notifier)
        .downloadConfig();
    if (!downloaded) return;
    _toastTimer?.cancel();
    setState(() => _toastVisible = true);
    _toastTimer = Timer(AppConstants.toastVisible, () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConfigurationEntity config = ref.watch(
      configuratorControllerProvider,
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.panel,
        border: Border.fromBorderSide(BorderSide(color: AppColors.line)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 40),
            blurRadius: 80,
            color: AppColors.cardShadow,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PreviewHeadWidget(
            config: config,
            tabs: _tabs,
            activeTab: _tab,
            onTab: (index) => setState(() => _tab = index),
          ),
          _pane(config),
          _foot(config),
        ],
      ),
    );
  }

  Widget _pane(ConfigurationEntity config) {
    final Widget content = switch (_tab) {
      0 => CodePaneWidget(lines: PreviewDerivations.fileTree(config)),
      1 => CodePaneWidget(lines: PreviewDerivations.pubspec(config)),
      _ => StepsPaneWidget(steps: PreviewDerivations.steps(config)),
    };
    return Container(
      color: AppColors.panelDeep,
      constraints: const BoxConstraints(
        minHeight: AppConstants.paneMinHeight,
        maxHeight: AppConstants.paneMaxHeight,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.previewPad,
          26,
          AppConstants.previewPad,
          AppConstants.previewPad,
        ),
        child: Align(alignment: Alignment.topLeft, child: content),
      ),
    );
  }

  Widget _foot(ConfigurationEntity config) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.previewPad,
        24,
        AppConstants.previewPad,
        24,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CraftButtonWidget(
            label: 'Download',
            onPressed: config.isValid ? _download : null,
          ),
          Text(
            _toastVisible
                ? 'config.json saved — run: dart run craft_generator:generate'
                : "config.json — the generator's exact input",
            style: AppTypography.code(
              size: 10,
              color: _toastVisible ? AppColors.fg : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
