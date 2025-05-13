import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/avoid_empty_container/avoid_empty_container_lint_rule.dart';
import 'package:sangria_lints/src/rules/no_disabled_tests/no_disabled_tests_lint_rule.dart';
import 'package:sangria_lints/src/rules/use_setstate_synchronously/use_setstate_synchronously_lint_rule.dart';
import 'package:sangria_lints/src/rules/use_widget_ref_synchronously/use_widget_ref_synchronous_lint_rule.dart';

/// Returns the Sangria Plugin instance.
PluginBase createPlugin() => _SangriaLints();

class _SangriaLints extends PluginBase {
  static final _lints = [
    UseSetStateSynchronouslyLintRule(),
    AvoidEmptyContainerLintRule(),
    NoDisabledTestsLintRule(),
    UseWidgetRefSynchronouslyLintRule(),
  ];

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return _lints.where((lint) => lint.isEnabled(configs)).toList();
  }
}
