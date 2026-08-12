# App Store、应用宝与华为应用市场完整上架指南

> 文档核对日期：2026-08-12。应用商店规则和监管要求会变化，正式提交当天必须再次检查后台提示及官方审核规则。本文是工程交付指南，不替代目标司法辖区律师、金融合规负责人或商店审核团队的意见。

## 0. 先做发布可行性判断

### 当前 CryptoPay 不能直接在中国大陆公开上架

本项目当前包含托管钱包、充值、提现、币币兑换、法币出金和批量付款。中国人民银行等十部门发布的银发〔2021〕237号通知明确：法定货币与虚拟货币兑换、虚拟货币之间兑换、为虚拟货币交易提供定价或信息中介等相关业务属于非法金融活动；境外交易所向中国境内居民提供服务同样属于非法金融活动。参见[中国人民银行官方通知](https://www.pbc.gov.cn/tiaofasi/144941/3581332/4348658/index.html)。

因此：

- 当前产品不得面向中国大陆居民提供上述虚拟货币交易服务。
- 不应把当前版本提交到应用宝、华为应用市场中国大陆区或 App Store 中国大陆区。
- 不得通过隐藏功能、远程开关、审核账号特供内容、网页套壳或审核后开启功能规避审核。
- 如果产品仅面向获得许可的境外市场，应按牌照覆盖范围进行国家/地区限制，并屏蔽中国大陆注册、访问和交易。
- 如果确实需要中国大陆版本，必须先由中国律师和监管合规团队重新界定业务。通常需要移除虚拟货币交易、兑换、充值、提现、出金及推广等能力；改版后仍须完成 APP 备案和可能的金融前置审批。

Apple 的审核规则允许组织开发者提供钱包，但交易/传输只能在具有相应许可的国家或地区提供；金融交易类 App 应由实际提供服务的持牌法律实体提交。参见 [App Review Guidelines 3.1.5 和 3.2.1](https://developer.apple.com/app-store/review/guidelines/)。

### 上架 Go/No-Go 门禁

只有以下问题全部回答“是”，才能进入打包步骤：

- 发布主体是实际提供服务的法律实体，而不是个人账号或代上架主体。
- 每个目标国家/地区均有书面法律意见和适用的虚拟资产、支付、汇兑或资金转移许可。
- App 功能、官网、隐私政策、服务条款、商店描述与牌照范围一致。
- KYC/KYB、AML/KYT、制裁筛查、Travel Rule、投诉、冻结和可疑交易报告流程已上线。
- 托管、账本、审批、限额、幂等、对账、灾备和事件响应已通过生产验收。
- 能向审核员提供长期有效、数据完整且不触发真实资金转移的审核账号。
- 中国大陆分发已关闭，或中国大陆版本已经取得明确的书面准入意见和全部前置许可。

## 1. 三个平台共同需要准备的材料

### 1.1 主体与账号

- 公司营业执照或注册证书，主体名称、地址和统一识别号保持一致。
- 法定代表人/授权经办人证件、手机号、企业邮箱和授权书。
- 企业官网，包含真实公司名称、地址、联系方式、产品说明、隐私政策、服务条款和注销入口。
- 商标注册证或品牌授权书；应用名称、图标或素材不是本公司所有时准备完整授权链。
- 软件著作权证书或电子版权证书。不同中国 Android 商店和类目可能要求不同，建议上架前完成登记。
- Apple 组织开发者账号、腾讯开放平台企业账号、华为开发者联盟企业账号。
- 财务、税务、收款银行账户资料；仅在有付费服务或商店结算时填写。

### 1.2 金融与加密货币专项材料

按每个发布地区单独建立资料包：

- 虚拟资产服务商、交易、托管、支付、汇兑或资金转移许可证。
- 许可证持有人与 App 发布主体不一致时的集团关系、服务协议和品牌授权。
- 可服务国家/地区清单、禁止地区清单及地理限制实现说明。
- KYC/KYB、AML/KYT、制裁、Travel Rule、资产隔离、投诉和风险披露政策。
- 托管商、银行、法币出入金供应商和交易/流动性供应商的合同或授权证明。
- 审核说明：资产如何托管、交易由谁执行、费用如何计算、用户如何退款/投诉。

不要上传超出审核要求的用户数据、私钥、生产 API 密钥或完整供应商机密合同。必要时提供脱敏版本，并在审核备注中说明可按要求补充。

### 1.3 中国大陆互联网与行业资料

如果经法律评估后产品可以在中国大陆分发，还需要：

- ICP 网站备案及 APP 备案编号；包名、应用名称和主办者必须与备案信息一致。
- APP 备案通常由网络接入服务提供者或应用分发平台提交，省级通信管理局在材料齐全准确时办理。官方流程见[工信部 APP 备案解读](https://www.miit.gov.cn/jgsj/xgj/hlwgl/art/2023/art_564bf0759d7e41d5b4aa8ce4996b9e84.html)。
- 在 App 内显著位置展示备案编号，并链接工信部备案查询系统。
- 类目涉及金融、支付、外汇、证券等时，准备对应监管部门的前置审批或许可证。
- 网络安全等级保护、数据出境、安全评估等材料是否需要，应由合规团队根据实际数据流判断。

APP 备案不等于金融业务许可，也不会使被禁止的虚拟货币交易业务合法化。

### 1.4 隐私与用户权益

准备公开 HTTPS 页面，并确保无需登录即可访问：

- 隐私政策：数据类型、目的、处理方式、保存期限、共享对象、跨境传输、儿童政策、用户权利和联系方式。
- 用户协议/服务条款。
- 账户注销说明和可实际完成的注销入口。
- 第三方 SDK 清单：SDK 名称、提供方、用途、收集数据、隐私政策链接和初始化时机。
- 权限用途说明：相机、相册、通知、生物识别、存储等必须与实际功能一致。
- 数据删除、导出、更正、撤回同意和投诉流程。

首次启动应先展示隐私政策摘要并取得同意，再初始化非必要 SDK；拒绝非必要权限不能阻断无关功能。商店后台填写的隐私标签必须与二进制、SDK 和隐私政策一致。

### 1.5 商店素材

- 应用正式名称、短描述、完整描述、关键词、更新说明。
- 1024×1024 无透明通道的 iOS App Store 图标源文件，以及 Android 高清图标源文件。
- 按后台当期尺寸要求导出的手机截图；至少覆盖登录、首页、交易、资金、审批和安全中心。
- 可选预览视频、宣传图、Feature Graphic。
- 客服 URL、营销 URL、隐私政策 URL、服务条款 URL和账户删除 URL。
- 应用分类、内容分级问卷、版权声明、支持邮箱和支持电话。
- 审核账号、密码、二次验证码获取方式、审核步骤和特殊环境说明。

截图和描述必须展示真实可用功能。不要使用收益承诺、“稳赚”、误导性币价、监管背书或尚未开放的功能。

## 2. 发布前工程整改

当前仓库是可运行演示工程，不能直接用现有配置提交生产商店。至少完成以下整改：

1. 将 iOS Bundle ID 和 Android `applicationId` 改成公司拥有的永久标识。当前 `com.cryptopay...` 只是占位值。
2. 替换应用图标、启动页、应用名称、公司信息和所有 Mock 标识。
3. 接入生产 API，但通过 staging 审核账号运行；不得把私钥或生产管理凭据打包进 App。
4. 配置 Deep Link/App Link、推送、Keychain/Keystore、生物识别和环境隔离。
5. Android Release 必须改用正式上传密钥。当前模板仍使用 debug signing，商店不会接受。
6. 配置 iOS Distribution 证书、App Store Provisioning Profile、Team 和正式能力。
7. 补齐隐私清单、第三方 SDK 数据清单、权限弹窗文案、注销与删除账户流程。
8. 清除调试菜单、测试服务器、示例账号硬编码、日志中的个人/资金信息和未使用权限。
9. 确保服务器能按 App 版本和地区关闭高风险功能，并至少兼容两个历史客户端版本。

### 2.1 版本号

在 `pubspec.yaml` 中更新：

```yaml
version: 1.0.0+100
```

- `1.0.0` 是用户看到的版本号。
- `100` 是 iOS build number / Android versionCode；每次上传必须递增。
- 同一个待发布版本可以重新上传不同 build number，但不能复用已上传的 build number。

### 2.2 发布前质量门禁

```bash
flutter clean
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

随后完成真机测试：注册、登录、密码重置、MFA、切后台、断网重试、低电量、升级覆盖、注销、深链、推送、审批、失败/冲正和地区限制。资金流程必须在沙盒或隔离 staging 账本中完成。

## 3. Apple App Store 上架流程

### 3.1 注册组织账号

加密货币钱包和金融服务应使用组织账号。Apple 组织账号要求法律实体、D‑U‑N‑S 编号、具有签约权限的经办人、企业域名邮箱和可公开访问的网站，参见 [Apple Developer Program 注册要求](https://developer.apple.com/help/account/membership/program-enrollment)。

流程：

1. 为企业 Apple Account 开启双重认证。
2. 查询或申请 D‑U‑N‑S 编号，确保英文法律实体名称和地址与注册文件一致。
3. 以 Organization 加入 Apple Developer Program，并完成 Apple 的实体/制裁合规验证。
4. 在 App Store Connect 的 Users and Access 中分配 Admin、App Manager、Developer、Marketing 等最小权限角色。
5. Account Holder 签署最新协议；如有商店收费，再填写税务和银行信息。

### 3.2 创建 App ID 和 App Store Connect 记录

1. 在 Certificates, Identifiers & Profiles 创建 Explicit App ID。
2. 启用实际需要的能力，例如 Associated Domains、Push Notifications 和 Keychain Sharing。
3. 在 Xcode Runner Target 设置 Team、Bundle ID 和 Signing。
4. 进入 App Store Connect → Apps → `+` → New App。
5. 选择 iOS，填写名称、主语言、Bundle ID 和内部 SKU。Bundle ID 创建后不能随意更改。
6. 只选择牌照覆盖且服务可合法提供的国家/地区；不要勾选中国大陆。

### 3.3 填写产品页和合规信息

填写应用名称、30 字符以内的副标题、描述、关键词、支持 URL、营销 URL、版权、分类、年龄分级和截图。Apple 要求 iOS App 提供隐私政策 URL，参见 [App 信息字段说明](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information)。

在 App Privacy 中：

1. 填写隐私政策 URL和可选的隐私选择 URL。
2. 声明 App 及所有第三方 SDK 收集的数据类型。
3. 对每种数据说明用途、是否关联用户、是否用于跟踪。
4. 发布 Privacy Nutrition Label，并与当前待审版本保持一致。官方步骤见 [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)。

还要完成：

- Content Rights、年龄分级、出口合规、DSA trader status（如在欧盟分发）。
- 加密出口合规问卷。TLS、安全存储和加密功能也属于需要回答的范围；是否豁免应由合规人员判断。参见 [Apple 加密文档](https://developer.apple.com/help/app-store-connect/manage-app-information/determine-and-upload-app-encryption-documentation)。
- 针对加密业务上传牌照、授权文件和覆盖地区说明，并在 Review Notes 中解释业务模式。

### 3.4 构建 IPA

先在 Xcode 验证 `Runner` 的 Release Signing，然后执行：

```bash
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

产物位于 `build/ios/ipa/`。符号文件和构建提交 SHA 要归档，不要公开。

### 3.5 上传和 TestFlight

可以通过 Xcode Organizer、Transporter 或 App Store Connect API 上传。Apple 会根据 Bundle ID、版本号和 build number 关联构建，上传后需等待处理，参见 [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/)。

1. 先加入内部测试人员，完成冒烟和回归测试。
2. 需要外部测试时，创建测试组、填写 Beta Review Information 并提交 TestFlight Beta Review。
3. 验证安装、推送、Universal Link、Face ID、升级、注销和地区限制。
4. 确认审核账号不会过期、不会触发真实资金操作，也不会卡在短信或人工 KYB。

### 3.6 提交正式审核

1. 在目标版本中选择已处理完成的 build。
2. 填写 App Review 联系人、电话、邮箱、审核账号和密码。
3. 在 Review Notes 中逐步说明如何进入充值、换币、出金、批量付款和审批；说明所有资金操作运行在审核沙盒。
4. 附上牌照、集团关系、授权、地区限制截图或演示视频。
5. 选择手动发布、审核后自动发布或不早于指定日期发布。
6. 进入 App Review 页面检查缺失项目，点击 Add for Review / Submit for Review。

Apple 明确要求登录类 App 提供有效审核账号及必要配置，参见 [App Review 准备说明](https://developer.apple.com/app-store/review/)。审核中的问题应在 App Store Connect 消息线程中回答，不要另开重复版本。

### 3.7 审核通过与发布

- 手动发布：状态变为 Pending Developer Release 后点击 Release This Version。
- 自动发布：审核通过后按所选策略发布。
- 对更新版本可开启 Phased Release，逐步覆盖自动更新用户。
- 发布后监控崩溃、登录、KYC、支付状态、对账差异、客服和商店评论。
- 发现资金或合规风险时先通过服务端关闭相关功能，再评估撤下地区或提交紧急修复。

### 3.8 常见驳回

- 3.1.5：无法证明加密业务牌照或分发地区超出牌照范围。
- 5.1.1/5.1.2：隐私政策、权限、SDK 行为和 App Privacy 标签不一致。
- 2.1：审核账号失效、验证码无法获取、后端不可用或功能不完整。
- 2.3：截图、描述、币种、费用或功能与实际不一致。
- 账户创建后无法在 App 内发起账户删除。
- 把订阅或数字功能付费错误地绕过 In-App Purchase；企业服务例外需清楚解释业务模型。

修复后增加 build number、重新构建上传，在 Resolution Center 逐项回答。若认为判断错误，可提供监管文件和清晰事实申请复审或申诉，不要反复提交相同构建。

## 4. 腾讯应用宝上架流程

### 4.1 当前项目的结论

应用宝主要服务中国大陆 Android 分发。当前 CryptoPay 业务形态不具备中国大陆公开分发的法律前提，所以本节只能在业务完成合规改造并取得书面准入意见后执行。

### 4.2 注册与认证

1. 进入[腾讯开放平台](https://open.qq.com/)，注册企业开发者账号。
2. 完成企业实名认证和经办人验证。
3. 按后台要求签署开发者协议，添加团队成员并设置最小权限。
4. 准备营业执照、法人/经办人资料、软件著作权或版权授权、商标授权、APP 备案号和行业许可证。

腾讯后台字段和材料要求可能按主体与类目动态变化，应以创建应用时页面列出的“资质要求”和最新审核规范为准。

### 4.3 创建应用

1. 开放平台控制台 → 应用分发/移动应用 → 创建应用。
2. 选择 Android 应用和准确类目。
3. 填写应用名称、包名、简介、完整描述、客服信息和隐私政策 URL。
4. 填写 APP 备案编号及主办者信息；名称、包名、签名证书和备案记录保持一致。
5. 上传图标、截图、版权证明和类目资质。

首次上传后不要再更换包名或签名密钥，否则通常会被识别为不同应用或导致更新失败。

### 4.4 构建签名 APK

应用宝 Android 发布通常需要正式签名安装包。先完成 `android/key.properties` 和 release signing 配置，再构建：

```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/symbols/android \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

上传前检查：

```bash
$ANDROID_HOME/build-tools/36.1.0/apksigner verify --verbose \
  build/app/outputs/flutter-apk/app-release.apk
```

不要使用本仓库当前的 debug signing 配置生成商店包。上传密钥至少离线备份两份，密码存密码管理器或 CI Secret。

### 4.5 提交审核

1. 上传正式 APK，等待平台解析包名、版本号、签名、权限和 SDK。
2. 填写更新说明、分发范围、测试账号和审核说明。
3. 上传隐私政策、用户协议、APP 备案和平台要求的版权/行业资质。
4. 使用平台隐私/安全检测工具，根据报告整改超范围权限、提前初始化 SDK、频繁弹窗和退出困难。
5. 提交审核并在控制台查看状态、补充材料或处理驳回。

审核通过后选择立即发布或预约发布。先小范围验证下载、安装、升级覆盖、渠道统计和服务端版本兼容，再扩大推广。

### 4.6 更新版本

- 保持 applicationId 和签名证书不变。
- 递增 versionCode 和版本号。
- 更新隐私标签、SDK 清单、权限说明、截图和更新日志。
- 上传新 APK → 安全检测 → 提交更新审核 → 审核通过后发布。

## 5. 华为应用市场上架流程

### 5.1 区分 Android 与 HarmonyOS

- 当前 Flutter 工程能生成 Android APK/AAB，可提交 AppGallery 的 Android 应用轨道，但是否能在具体华为系统版本运行取决于该设备是否支持 Android 应用。
- HarmonyOS NEXT 原生应用需要独立 ArkUI/ArkTS 工程并生成 HAP/App 包；本仓库没有可直接提交的 HarmonyOS 包。
- 华为 AppGallery 支持多种包格式和分发轨道，参见[华为一站式分发说明](https://developer.huawei.com/consumer/cn/solution/agconnect/release/)。
- 当前加密业务不得选择中国大陆分发；境外 AppGallery 分发同样只能选择牌照覆盖地区。

### 5.2 注册与创建应用

1. 注册华为开发者联盟企业账号并完成实名认证。
2. 登录 [AppGallery Connect](https://developer.huawei.com/consumer/cn/agconnect)。
3. 创建项目和应用，选择 Android 平台，填写应用名称、默认语言和软件包名。
4. 软件包名必须与 Flutter Android `applicationId` 完全一致。
5. 设置团队角色；将发布和财务权限限制给必要人员。

华为官方总流程为注册认证、创建应用、配置基本信息、配置分发信息、提交审核，参见[华为应用市场发布入口](https://developer.huawei.com/consumer/cn/appgallery/)。

### 5.3 应用签名

选择一种长期策略：

- 使用自有上传/发布密钥，并在安全环境中保管。
- 使用 AppGallery Connect App Signing 时，先理解上传证书与最终发布证书的区别，并保存证书指纹供 API、OAuth、地图或推送服务配置。

同一应用后续版本必须保持可升级的签名链。不要用 debug keystore，也不要把 keystore 提交到 Git。

### 5.4 构建包

AAB：

```bash
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/symbols/android \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

APK：

```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/symbols/android \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

以 AppGallery Connect 当前应用轨道显示的可接受格式为准。华为的发布服务支持 APK、App Bundle 和 HarmonyOS 等格式，但不同地区和应用类型要求可能不同。

### 5.5 配置商店信息

在 AGC 的应用上架/版本信息中完成：

1. 上传软件包并等待合法性与安全解析。
2. 配置语言、应用名称、简介、详细介绍、分类、标签、图标、截图和可选视频。
3. 选择免费/付费、发布国家和地区、支持联系方式及隐私政策 URL。
4. 填写隐私声明/隐私标签，逐项披露 App 与第三方 SDK 的数据处理。
5. 填写年龄分级、内容声明、APP 备案信息和版权信息。
6. 上传金融及虚拟资产类资质和地区授权文件。

华为要求中国大陆手机应用提供应用版权证书或代理证书，具体格式和地区差异见[版权信息配置](https://developer.huawei.com/consumer/cn/doc/App/agc-help-release-app-copyright-0000002278981450)。最新审核指南、资质要求、备案指引、隐私 FAQ 和 Checklist 集中在[华为审核政策中心](https://developer.huawei.com/consumer/cn/doc/App/50000)。

### 5.6 测试与审核

1. 创建内部测试或邀请测试群组，添加华为账号测试人员。
2. 使用云测试/云调试覆盖不同系统版本、屏幕、网络和性能场景。
3. 检查华为设备上的推送、深链、生物识别、安全存储和后台恢复。
4. 为审核员配置可用账号、固定验证码方式和 staging 沙盒。
5. 确认软件包、分发地区、基础信息、隐私声明和资质后提交审核。

AGC 会先解析软件包，只有检测通过的包才能用于发布；官方发布和测试说明见[在应用市场分发](https://developer.huawei.com/consumer/cn/appgallery/devstart/)。

### 5.7 发布与更新

- 审核通过后按计划立即发布、预约发布或采用平台提供的分阶段发布能力。
- 先观察崩溃率、ANR、登录成功率、资金状态和客服工单，再扩大比例。
- 更新时保持包名和签名不变，递增 versionCode，并同步更新隐私与资质信息。
- 如果新版本出现资金或隐私风险，立即停止分阶段发布、关闭服务端功能，并提交修复包。

## 6. 审核账号准备模板

三个平台都建议准备一份中英文审核说明：

```text
App type: Custodial enterprise crypto payments client
Service entity: <legal entity name>
Licensed regions: <country/region list>
Excluded regions: China mainland and all unlicensed regions

Demo account: reviewer@example.com
Password: <review-only password>
MFA: Use fixed code <code> or tap “Review verification”

Review steps:
1. Sign in with the demo account.
2. Open Home to inspect demo balances.
3. Open Funds → Swap/Withdraw/Fiat off-ramp.
4. Submit a request; it stays in the isolated review sandbox.
5. Open Approvals and approve/reject the request.

No real funds, blockchain broadcast, or bank transfer occurs in the review environment.
Licensing documents and geo-restriction evidence are attached.
Support contact: <name, phone, email, timezone>
```

审核账号应至少在整个审核周期及其后合理时间内有效。后台不能因为 IP、设备、工作时间、短信通道或人工 KYC 阻止审核。

## 7. 最终提交清单

### 法务与业务

- [ ] 发布主体、商店账号、官网和许可证主体一致。
- [ ] 每个分发地区均在牌照和法律意见覆盖范围内。
- [ ] 中国大陆已排除，或已有针对改版产品的书面准入结论。
- [ ] 隐私政策、用户协议、风险披露、费用和投诉流程已上线。
- [ ] KYC/KYB、AML/KYT、制裁、Travel Rule 和地区限制已验收。

### 工程

- [ ] Bundle ID/applicationId 已改成公司永久标识。
- [ ] Release 签名、证书、密钥备份和 CI Secret 已配置。
- [ ] 版本号/build number/versionCode 已递增。
- [ ] `flutter analyze`、`flutter test`、真机回归和安全测试通过。
- [ ] 生产包不含 Mock 数据、测试密钥、调试菜单和敏感日志。
- [ ] 崩溃符号、SBOM、提交 SHA 和发布审批记录已归档。

### 商店后台

- [ ] 名称、描述、截图、币种和功能与二进制一致。
- [ ] 隐私标签包含所有自有和第三方 SDK 数据。
- [ ] 审核账号、MFA、审核步骤和联系人可用。
- [ ] 版权、APP 备案、行业许可和品牌授权已上传。
- [ ] 分发地区、发布日期和分阶段策略已复核。

## 8. 建议的上架顺序

1. 完成持牌市场的法律和金融合规评审。
2. 完成生产化改造及第三方移动安全测试。
3. 先通过 iOS TestFlight 和 Android 内部测试验证完整链路。
4. 优先提交一个许可明确的境外 App Store 地区，处理审核反馈并固定资料模板。
5. 再提交华为 AppGallery 的相同持牌境外地区。
6. 应用宝及中国大陆分发保持关闭，除非产品已完成合规重构并取得明确书面准入意见。
7. 审核通过后分阶段发布，持续监控资金、合规、稳定性和客服指标。
