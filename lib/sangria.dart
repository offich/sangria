import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria/src/use-setstate-synchronously/use_setstate_synchronously_rule.dart';

PluginBase createPlugin() => _SangriaLints();

class _SangriaLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    UseSetStateSynchronouslyLintRule(),
  ];
}
