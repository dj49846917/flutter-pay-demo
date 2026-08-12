# Web 预览与 GitHub Pages 部署

本工程已启用 Flutter Web，并通过 GitHub Actions 自动部署到 GitHub Pages。线上演示地址：

- <https://dj49846917.github.io/flutter-pay-demo/>

> Web 版本用于产品和组件预览，数据均来自 Mock Repository，不得用于真实资产交易或保存生产密钥。

## 本地运行

确认 Chrome 已出现在 `flutter devices` 后执行：

```bash
flutter pub get
flutter run -d chrome
```

启动 Storybook Web：

```bash
flutter run -d chrome -t lib/main_storybook.dart
```

## 本地构建

GitHub Pages 项目站点部署在 `/flutter-pay-demo/` 子路径，因此正式构建必须设置对应的 base href：

```bash
flutter build web --release --base-href "/flutter-pay-demo/"
```

产物位于 `build/web/`。若部署到自定义域名根路径，应改用 `--base-href "/"`。

## 自动部署流程

工作流文件为 `.github/workflows/deploy-pages.yml`。每次向 `main` 分支推送代码时会自动执行：

1. 安装项目指定的 Flutter Stable 版本。
2. 获取依赖并执行静态检查和测试。
3. 使用 `/flutter-pay-demo/` 子路径构建 Web Release。
4. 上传构建产物并发布到 GitHub Pages。

也可以在 GitHub 仓库的 **Actions** 页面选择 **Deploy Flutter Web to GitHub Pages**，点击 **Run workflow** 手动部署。

## 首次启用 GitHub Pages

工作流会尝试自动启用 Pages。如果仓库策略不允许自动启用，请在 GitHub 完成一次设置：

1. 打开仓库 **Settings → Pages**。
2. 在 **Build and deployment** 中将 **Source** 设置为 **GitHub Actions**。
3. 回到 **Actions** 页面重新运行部署工作流。

部署成功后通常需要短暂等待 CDN 更新。若页面空白，优先检查 Actions 日志，并确认构建命令中的 `--base-href` 与仓库名一致。

## 路由说明

工程当前使用 `go_router` 的 Hash URL 策略，刷新详情页时请求仍然落到 `index.html`，适合不支持服务端重写规则的 GitHub Pages。若以后切换为 Path URL 策略，需要另外提供 404 回退或改用支持 SPA Rewrite 的托管平台。
