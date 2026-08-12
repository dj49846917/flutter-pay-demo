# iOS 与 Android 本地运行指南

本文介绍如何在模拟器和真机上以 Debug 模式启动 CryptoPay。生产签名及商店部署请参阅 [DEPLOYMENT.md](DEPLOYMENT.md)。

## 1. 准备工程

所有命令默认在工程根目录执行：

```bash
cd /Users/dujiang/Desktop/bps/sss
flutter doctor -v
flutter pub get
```

`flutter doctor -v` 应显示 Android toolchain、Xcode 和 CocoaPods 均通过检查。首次构建可能需要下载 Android Gradle、NDK、CMake 或 iOS Engine 缓存，请保持网络可用。

## 2. 在 iOS 模拟器运行

### 启动默认模拟器

```bash
open -a Simulator
flutter devices
flutter run -d <ios-device-id>
```

如果模拟器刚启动，等待进入主屏幕后再执行 `flutter run`。

### 启动指定型号

查看可用设备：

```bash
xcrun simctl list devices available
```

启动指定模拟器，例如：

```bash
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
flutter devices
```

随后复制 `flutter devices` 返回的设备 ID：

```bash
flutter run -d <ios-device-id>
```

### 使用 Xcode

```bash
open ios/Runner.xcworkspace
```

在 Xcode 顶部选择一个 iPhone Simulator，点击 Run。日常开发建议使用 `flutter run`，因为热重载和 Flutter 日志更完整。

### iOS 真机

1. USB 连接 iPhone，并在手机上选择信任此电脑。
2. 在 Xcode 的 Runner Target 中设置 Team 和唯一 Bundle Identifier。
3. 在 iPhone 中开启 Developer Mode。
4. 执行：

```bash
flutter devices
flutter run -d <iphone-device-id>
```

真机首次安装可能要求在系统设置中信任开发者证书。模拟器不需要开发者签名。

## 3. 在 Android 模拟器运行

### 查看并启动模拟器

```bash
flutter emulators
flutter emulators --launch Medium_Phone_API_36.1
```

等待 Android 主屏幕出现，然后执行：

```bash
flutter devices
flutter run -d <android-device-id>
```

也可以从 Android Studio 的 Device Manager 启动任意 AVD。若存在多个 Android 设备，请指定 ID：

```bash
flutter run -d <android-device-id>
```

### Android 真机

1. 在手机的开发者选项中开启 USB 调试。
2. USB 连接后，在手机上允许当前电脑进行调试。
3. 执行：

```bash
flutter devices
flutter run -d <android-device-id>
```

如果 Flutter 未发现设备，可检查 ADB：

```bash
$ANDROID_HOME/platform-tools/adb devices
```

设备状态必须为 `device`；若为 `unauthorized`，重新插拔并在手机上确认授权。

## 4. 运行 Storybook

iOS：

```bash
flutter run -d <ios-device-id> -t lib/main_storybook.dart
```

Android：

```bash
flutter run -d <android-device-id> -t lib/main_storybook.dart
```

指定设备：

```bash
flutter run -d <device-id> -t lib/main_storybook.dart
```

## 5. 调试快捷键

应用通过 `flutter run` 启动后，终端支持：

- `r`：热重载，保留当前页面状态。
- `R`：热重启，重新初始化应用状态。
- `p`：显示布局辅助线。
- `o`：切换 iOS/Android 平台视觉模式。
- `q`：停止应用。

演示登录支持账号密码和手机号验证码：账号密码可使用任意合法邮箱和至少 8 位密码；手机号可使用任意 6–15 位号码，短信演示验证码为 `246810`。两种登录方式都需要继续完成图形选择验证。所有资金请求均为 Mock，不会广播到区块链或银行网络。

## 6. 常见问题

### 没有发现 iOS 模拟器

```bash
open -a Simulator
xcrun simctl list devices available
flutter devices
```

若没有可用运行时，在 Xcode 的 Settings → Platforms 中安装 iOS Simulator Runtime。

### 没有发现 Android 模拟器

```bash
flutter emulators
flutter doctor -v
```

若列表为空，从 Android Studio → Device Manager 创建 API 36 或更高版本的 Arm64 模拟器。

### 依赖或生成缓存异常

```bash
flutter clean
flutter pub get
flutter run -d <device-id>
```

### Android 下载 Gradle 依赖失败

确认可以访问 Google Maven 与 pub.dev，然后重试。不要通过降低 `compileSdk` 绕过依赖要求；本工程的 `flutter_secure_storage 11` 要求 `compileSdk 37`。

### iOS 构建缓存异常

```bash
flutter clean
flutter pub get
flutter run -d <ios-device-id>
```

如仍失败，可在 Xcode → Settings → Locations 中打开 Derived Data 目录并清理本项目缓存；清理后下一次构建会变慢。
