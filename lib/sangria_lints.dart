import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/use_setstate_synchronously/use_setstate_synchronously_rule.dart';

PluginBase createPlugin() => _SangriaLints();

class _SangriaLints extends PluginBase {
  static final _lints = [UseSetStateSynchronouslyLintRule()];

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return _lints.where((lint) => lint.isEnabled(configs)).toList();
  }
}
