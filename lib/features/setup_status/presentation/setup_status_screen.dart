import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/setup_status_controller.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/readiness_tab_widget.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/setup_checks_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dev-only screen for post-download setup and shipping readiness.
///
/// Two tabs:
/// - **Setup** — runs the manifest's runtime checks (Firebase init,
///   anonymous auth, FCM token) and lists manual console steps: the
///   runtime sibling of `tool/doctor.dart`.
/// - **Readiness** — the production-readiness checklist for enabled
///   modules, read from the git-tracked `checklist.yaml`.
///
/// Only routed in debug builds; release builds exclude it.
class SetupStatusScreen extends ConsumerWidget {
  /// Creates a [SetupStatusScreen].
  const SetupStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('Setup Status'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Setup'),
              Tab(text: 'Readiness'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              tooltip: 'Run all checks',
              onPressed: ref
                  .read(setupStatusControllerProvider.notifier)
                  .runAll,
            ),
          ],
        ),
        body: const TabBarView(
          children: [SetupChecksTabWidget(), ReadinessTabWidget()],
        ),
      ),
    );
  }
}
