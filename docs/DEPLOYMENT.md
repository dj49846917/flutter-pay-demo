# 构建与部署

本文面向签名和应用商店发布。本地模拟器、真机及 Storybook 启动方式见 [RUNNING.md](RUNNING.md)。

账号、资质、素材、审核和发布后的完整商店流程见 [STORE_SUBMISSION.md](STORE_SUBMISSION.md)。

## 版本基线

- Flutter 3.44.x stable / Dart 3.12.x。
- Android API 24–37，`minSdk = 24`、`compileSdk = 37`。
- iOS 13–26；部署前在 Xcode 确认 Deployment Target、签名团队和能力。
- 使用锁文件 `pubspec.lock` 保证 CI 可重复解析。

## Android

1. 创建上传密钥并将密码通过 CI Secret 注入，禁止提交 keystore 和 `key.properties`。
2. 将 `android/app/build.gradle.kts` 的 release signing 从模板 debug key 替换为 release signing config。
3. 配置正式 `applicationId`、应用名称、图标、隐私声明、App Links 和推送。
4. 构建：

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/symbols/android \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

上传 `build/app/outputs/bundle/release/app-release.aab`，将符号文件保存到受控的崩溃分析系统。先走 Internal testing，再逐级灰度。

## iOS

1. 在 Xcode 设置唯一 Bundle ID、Team、签名、Associated Domains、Push Notifications 和 Keychain Groups。
2. 核对 Face ID 描述、隐私清单和第三方 SDK Privacy Manifest。
3. 构建：

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

通过 Xcode Organizer 或 Transporter 上传 IPA，先发布至 TestFlight。

## CI/CD 门禁

```text
format → analyze → unit/widget tests → secret/SAST/dependency scan
→ signed staging build → integration/security tests → manual compliance approval
→ signed production build → store rollout → monitoring/reconciliation
```

生产构建必须从受保护标签生成，使用短期签名凭据，保留 SBOM、依赖锁、提交 SHA、构建日志和审批记录。真实资金功能使用服务端 Feature Flag 分地区逐步开启。

## 回滚

移动商店二进制无法即时回滚，因此服务端必须向后兼容至少两个客户端版本，并能远程关闭提现、换币、出金和批量付款。严重事件优先关闭资金功能、撤销会话和轮换凭据，再发布热修复版本。
