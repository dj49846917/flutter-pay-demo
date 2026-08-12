# Storybook 组件目录

本工程使用 `storybook_flutter` 最新稳定版 `0.14.1`，独立入口为 `lib/main_storybook.dart`，不会进入正常的 `main.dart` 生产启动路径。

## 运行

```bash
flutter run -t lib/main_storybook.dart
flutter run -d chrome -t lib/main_storybook.dart
```

## 当前 Stories

- Brand / Brand mark：完整品牌标识。
- Feedback / Status badges：已完成、处理中、已拒绝。
- Feedback / Demo notice：非生产资金操作警示。
- Data / Transaction row：完成和处理中两种交易状态。
- States / Empty state：无数据状态。
- Actions / Primary button：主操作按钮。
- Forms / Text field：钱包地址输入框。

新增共享组件时必须同时增加正常、加载、空、错误、禁用和长文本用例中的适用项。Storybook 仅展示 UI；不得从 Story 中访问生产 API 或真实账户。
