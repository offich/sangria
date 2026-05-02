# CLAUDE.md

このファイルは、リポジトリ内のコードを扱う際に Claude Code (claude.ai/code) へ提供するガイダンスです。

## このリポジトリについて

**Sangria Lints** は Dart/Flutter 向けのカスタム Lint ルールプロバイダーパッケージ（`custom_lint_builder` 使用）です。ユーザーが自分のプロジェクトの `analysis_options.yaml` に追加して使用する Lint ルールを定義しています。Flutter アプリではないため、UI・状態管理・ルーティングは存在しません。

## よく使うコマンド

```bash
# 依存関係のインストール
flutter pub get

# フォーマットチェック
dart format --set-exit-if-changed lib test

# 静的解析
flutter analyze lib test

# example アプリに対してカスタム Lint を実行
cd example && dart run custom_lint
```

> `test/sangria_test.dart` はプレースホルダー（`void main() {}`）です。Lint ルールの動作確認は `example/` ディレクトリで `dart run custom_lint` を実行することで行います。

## アーキテクチャ

### プラグインのエントリーポイント

`lib/sangria_lints.dart` が `custom_lint_builder` の `PluginBase` を実装しており、`getLintRules(CustomLintConfigs)` で有効な Lint ルールの一覧を返します。

### Lint ルールの構造

各ルールは `lib/src/rules/` 以下のサブディレクトリに配置され、共通のパターンに従います。

```
lib/src/rules/<rule_name>/
├── <rule_name>_lint_rule.dart     # DartLintRule を継承 — メタデータの定義とビジターの登録
└── <rule_name>_visitor.dart       # AST ビジターを継承 — 違反の検出とエラーの報告
```

ルールによっては共通処理をまとめた `_util.dart` も存在します。

**ルールクラスの責務:**
- `LintCode`（ルール名・問題メッセージ・重大度）の宣言
- `run()` の実装で `context.registry` にビジターを登録

**ビジタークラスの責務:**
- 適切な AST ビジター（例: `RecursiveAstVisitor`）を継承
- AST を走査して問題のあるパターンを検出
- `ErrorReporter.atNode(...)` を呼んで診断結果を報告

### example アプリ

`example/` はルール違反のサンプルを示すスタンドアロンの Flutter アプリです。新しいルールを作成した際は、ここにサンプルファイルを追加して動作確認します。

## 新しい Lint ルールの追加手順

1. `lib/src/rules/<rule_name>/` にルールクラスとビジタークラスを作成する。
2. `lib/sangria_lints.dart` でルールをエクスポートし、`getLintRules` の返り値に追加する。
3. `example/lib/` に違反例を示すファイルを追加する。
4. `cd example && dart run custom_lint` で動作を確認する。

## CI

- **code-analysis.yml** — `lib/`・`example/`・`pubspec.yaml` の変更時に実行: フォーマットチェック → `flutter analyze` → example に対して `dart run custom_lint`
- **publish.yml** — `v*` タグをプッシュすると pub.dev へ自動公開

Flutter のバージョン管理には FVM を使用しています（`.fvmrc` 参照）。
