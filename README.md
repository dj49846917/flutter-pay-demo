# CryptoPay

面向企业的托管型数字资产支付移动客户端演示工程，基于 Flutter 3.44 / Dart 3.12，覆盖 iOS 与 Android。工程包含登录注册、首页、交易、活动、Invoice、法币出金、批量付款、充值、提现、换币、用户中心和审批。

> 当前 Repository 为 Mock 实现。真实资金、签名、KYC/KYB、KYT/AML、报价、账本、审批执行与链上广播必须由合规后端负责；不要把生产私钥或托管签名逻辑放进客户端。

## 快速开始

```bash
cd /Users/dujiang/Desktop/bps/sss
flutter pub get
```

### iOS 模拟器

```bash
open -a Simulator
flutter devices
flutter run -d <ios-device-id>
```

### Android 模拟器

```bash
flutter emulators
flutter emulators --launch Medium_Phone_API_36.1
flutter devices
flutter run -d <android-device-id>
```

如果 `-d ios` 或 `-d android` 匹配到多个设备，请使用 `flutter devices` 输出中的设备 ID：

```bash
flutter run -d <device-id>
```

演示登录只做本地表单校验：使用任意合法邮箱和至少 8 位密码即可进入。

完整的模拟器、真机、Storybook 启动方式和常见问题见 [本地运行指南](docs/RUNNING.md)。

## Storybook

```bash
flutter run -t lib/main_storybook.dart
```

Storybook 包含品牌、状态标签、交易行、空状态、表单、按钮和演示环境提示等组件用例。详细说明见 [docs/STORYBOOK.md](docs/STORYBOOK.md)。

## 校验

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## 文档

- [产品范围](docs/PRODUCT.md)
- [架构与接口](docs/ARCHITECTURE.md)
- [安全与合规](docs/SECURITY.md)
- [Storybook 说明](docs/STORYBOOK.md)
- [iOS/Android 本地运行](docs/RUNNING.md)
- [iOS/Android 部署](docs/DEPLOYMENT.md)
- [App Store、应用宝与华为应用市场上架](docs/STORE_SUBMISSION.md)
- [鸿蒙适配](docs/HARMONYOS.md)
