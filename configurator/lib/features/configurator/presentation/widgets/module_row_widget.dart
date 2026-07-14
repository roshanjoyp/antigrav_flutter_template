import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/sharp_checkbox_widget.dart';
import 'package:craft_configurator/features/configurator/domain/configurator_module_entity.dart';
import 'package:craft_configurator/features/configurator/presentation/configurator_controller.dart';

/// One tappable module row. Unchecked rows recede to 38% opacity (focus
/// through de-emphasis); hover restores them. Hover state is visual only.
class ModuleRowWidget extends ConsumerStatefulWidget {
  /// Creates the row for [module].
  const ModuleRowWidget({super.key, required this.module});

  /// The catalogue entry this row presents.
  final ConfiguratorModuleEntity module;

  @override
  ConsumerState<ModuleRowWidget> createState() => _ModuleRowWidgetState();
}

class _ModuleRowWidgetState extends ConsumerState<ModuleRowWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ConfiguratorModuleEntity module = widget.module;
    final bool checked = ref.watch(
      configuratorControllerProvider.select(
        (config) => config.isEnabled(module.id),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => ref
            .read(configuratorControllerProvider.notifier)
            .toggleModule(module.id, enabled: !checked),
        child: AnimatedOpacity(
          duration: AppConstants.hoverMedium,
          opacity: checked || _hovered ? 1 : 0.38,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.moduleRowPadV,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SharpCheckboxWidget(checked: checked),
                ),
                const SizedBox(width: AppConstants.moduleRowGap),
                Expanded(child: _content(module)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(ConfiguratorModuleEntity module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.name.toUpperCase(),
          style: AppTypography.disp(size: 13, weight: 500, trackingEm: 0.18),
        ),
        const SizedBox(height: 7),
        Text(
          module.description,
          style: AppTypography.text(
            size: 14,
            color: AppColors.muted,
            height: 1.7,
          ),
        ),
        if (module.pubspecDeps.isNotEmpty || module.requires.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final req in module.requires)
                _chip('requires $req', emphasized: true),
              for (final dep in module.pubspecDeps) _chip(dep),
            ],
          ),
        ],
      ],
    );
  }

  Widget _chip(String label, {bool emphasized = false}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 3, 9, 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: emphasized ? AppColors.muted : AppColors.line,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.code(size: 10, color: AppColors.muted),
      ),
    );
  }
}
