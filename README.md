# CryptoPay

面向企业的托管型数字资产支付客户端演示工程，基于 Flutter 3.44 / Dart 3.12，覆盖 iOS、Android 与 Web 预览。工程包含登录注册、首页、交易、活动、Invoice、法币出金、批量付款、充值、提现、换币、用户中心和审批。

在线演示：<https://dj49846917.github.io/flutter-pay-demo/>

> 当前 Repository 为 Mock 实现。真实资金、签名、KYC/KYB、KYT/AML、报价、账本、审批执行与链上广播必须由合规后端负责；不要把生产私钥或托管签名逻辑放进客户端。

## 技术栈

| 类别 | 技术 | 用途 |
|---|---|---|
| 客户端框架 | Flutter 3.44.x、Dart 3.12.x | iOS、Android 与 Web 共用 UI 和业务代码 |
| UI | Material 3、自定义 Design Tokens | 浅色/深色主题、企业支付视觉体系 |
| 状态管理 | Riverpod 3.4.x | 依赖注入、异步数据、加载/错误状态和刷新 |
| 路由 | go_router 17.x | 登录流程、底部多导航栈、详情页和深链基础 |
| 网络 | Dio 5.x | 预留 REST API、拦截器、Token 刷新及错误归一化 |
| 数据模型 | Dart 不可变领域模型、Repository Pattern | 隔离 UI、Mock 数据和后续真实 API 实现 |
| 本地安全 | flutter_secure_storage、local_auth | 预留 Keychain/Keystore、Face ID/Touch ID/指纹认证 |
| 本地配置 | shared_preferences | 预留非敏感偏好设置 |
| 二维码 | qr_flutter | 生成充值地址二维码 |
| 格式化 | intl | 金额、日期和时间显示 |
| 组件目录 | storybook_flutter | 隔离展示和检查共享组件状态 |
| 测试 | flutter_test、mocktail | Widget 测试和 Mock 能力 |
| 平台工具链 | Xcode、Android SDK 37、Gradle | iOS 与 Android 构建和发布 |

依赖版本以 [`pubspec.yaml`](pubspec.yaml) 和锁文件 [`pubspec.lock`](pubspec.lock) 为准。安全存储、生物识别和 Dio 已纳入工程依赖，但生产认证、Token 管理和真实 API 仍需接入后端后启用。

## 功能

### 账户与身份

- 登录、注册和忘记密码页面。
- 邮箱与密码基础表单校验。
- 企业账户及 KYB 状态展示。
- 双重认证、生物识别、设备管理和账户注销入口预留。

### 首页与资产

- 企业总资产估值。
- 本月流入、流出、交易数量、成功率和待审批统计。
- BTC、ETH、USDT、USDC 等资产余额与涨跌展示。
- 快捷进入充值、提现、换币和 Invoice。
- 最近交易与下拉刷新。

### 交易

- 交易列表和按充值、提现、换币、付款、出金筛选。
- 交易金额、资产、交易对方、时间和状态展示。
- 交易详情、参考号/链上 Hash 和处理时间线。
- 已完成、处理中和已拒绝状态组件。

### 资金操作

- 充值：资产选择、充值地址及二维码。
- 提现：金额、资产和目标钱包地址。
- 换币：源资产、目标资产和报价入口。
- Invoice：账单金额和客户邮箱。
- 法币出金：结算资产、金额和企业银行账户。
- 批量付款：付款批次及 CSV/XLSX 文件上传入口。
- 所有资金流程均带有演示环境警示和提交结果反馈。

### 企业管理

- 待审批请求列表。
- 批准、拒绝及二次确认交互。
- 团队成员、角色、银行账户、地址簿、限额和审批策略入口。
- 企业 KYB 认证状态及安全设置入口。

### 活动与体验

- 活动中心、任务进度、奖励和结束时间展示。
- Material 3 浅色/深色主题。
- iOS、Android 自适应布局和原生导航行为。
- Storybook 品牌、状态、交易行、空状态、表单和按钮用例。

### 当前实现边界

| 能力 | 当前状态 |
|---|---|
| 页面、导航和交互 | 已实现，可直接运行演示 |
| 资产、交易、审批和活动数据 | Mock Repository |
| 注册、登录和密码重置 | 本地表单演示，未连接身份服务 |
| 充值、提现、换币、出金和付款 | 演示请求，不产生真实资金变动 |
| KYC/KYB、AML/KYT、Travel Rule | 仅保留产品入口，需合规后端 |
| 钱包托管、签名、双式账本和链上广播 | 必须由服务端/HSM/MPC 系统实现 |
| HarmonyOS NEXT | 推荐使用独立 ArkUI/ArkTS 客户端并共享 API |

## 工程结构

```text
lib/
├── core/                 # 主题、路由和应用级基础设施
├── data/                 # 领域模型、Repository 接口和 Mock 实现
├── features/
│   ├── auth/             # 登录、注册、忘记密码
│   ├── home/             # 首页、资产和统计
│   ├── transactions/     # 交易列表与详情
│   ├── payments/         # 充值、提现、换币、Invoice、出金、批量付款
│   ├── approvals/        # 企业审批
│   └── profile/          # 用户中心和活动入口
├── shared/               # 跨业务共享组件
├── main.dart             # 应用入口
└── main_storybook.dart   # Storybook 独立入口

docs/                     # 产品、架构、安全、运行、部署和上架文档
test/                     # Widget 测试
android/                  # Android 原生工程
ios/                      # iOS 原生工程
web/                      # Web 启动页、PWA Manifest 和站点图标
.github/workflows/        # GitHub Pages 自动构建与部署
```

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

### Chrome / Web

```bash
flutter run -d chrome
```

GitHub Pages 会在 `main` 分支推送后自动部署。完整说明见 [Web 预览与 GitHub Pages 部署](docs/WEB_DEPLOYMENT.md)。

如果连接了多个设备，请使用 `flutter devices` 输出中的设备 ID：

```bash
flutter run -d <device-id>
```

演示登录提供两种方式：

- 账号密码：使用任意合法邮箱和至少 8 位密码。
- 手机号验证码：使用任意 6–15 位手机号，演示验证码为 `246810`。

基础信息验证通过后还需要完成图形选择验证，选择所有带比特币符号的图片后才能进入首页。

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
- [Web 预览与 GitHub Pages 部署](docs/WEB_DEPLOYMENT.md)
- [App Store、应用宝与华为应用市场上架](docs/STORE_SUBMISSION.md)
- [鸿蒙适配](docs/HARMONYOS.md)
