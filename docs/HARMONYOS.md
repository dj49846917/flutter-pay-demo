# 鸿蒙适配方案

Flutter 官方 stable 3.44 支持 iOS/Android，但不把 HarmonyOS/OpenHarmony 列为官方支持部署平台。OpenHarmony-SIG 提供独立 Flutter fork，其版本和插件生态与官方最新版不同，因此本工程不伪造一个无法验证的 `ohos/` 目录。

## 推荐生产路线

1. 本仓库的 iOS/Android 客户端继续使用官方 Flutter stable。
2. 鸿蒙客户端使用 ArkUI/ArkTS 独立工程。
3. 三端共享 OpenAPI、错误码、金额/精度规则、审批状态机、设计 Token 和验收用例。
4. Flutter 的 `data/models.dart` 仅作为客户端示例；正式共享协议应由 OpenAPI/JSON Schema 生成。

## 实验性 Flutter 路线

如业务接受维护 fork，可在独立仓库使用 OpenHarmony-SIG Flutter SDK：安装 DevEco Studio、HarmonyOS SDK、ohpm/hvigor/hdc 和 Java 17，然后用该 fork 创建 `--platforms ohos` 工程。每个插件必须逐项确认 OHOS 实现，尤其是安全存储、生物识别、二维码、文件选择、推送、深链和网络安全。

不要让官方 Flutter SDK 与 OHOS fork 共用同一个 PATH、PUB_CACHE 或 lockfile。建议用 CI 的独立镜像构建 HAP，并在真实鸿蒙设备上完成支付安全与生命周期测试。
