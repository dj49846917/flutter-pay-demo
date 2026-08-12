# 架构与接口

## 客户端分层

```text
features/       页面与业务交互
shared/         可复用设计系统组件
data/           领域模型和 Repository 接口
core/           主题、导航、网络与平台能力
main.dart       生产应用入口
main_storybook  独立组件目录入口
```

UI 只依赖 Repository 接口。当前 `MockWalletRepository` 可以替换为 `ApiWalletRepository`，不需要重写页面。Riverpod 管理依赖注入、异步缓存与刷新，go_router 管理底部多导航栈和深链。

## 推荐后端边界

- Identity：注册、登录、MFA、密码重置、设备与会话。
- Customer：个人/企业资料、KYC/KYB、成员、角色和权限。
- Ledger：双式账本、余额、冻结、费用、冲正和对账。
- Payment orchestration：充值、提现、批量付款、Invoice、法币出金。
- Trading：报价、报价锁定、换币订单和成交。
- Approval：策略、审批链、四眼原则、超时与委托。
- Compliance：制裁名单、AML/KYT、Travel Rule 和案件管理。
- Notification：邮件、短信、推送和 Webhook。

## API 约定

生产接口建议使用 `/v1`，请求携带 `Authorization: Bearer`、`X-Device-Id`、`X-Request-Id`；所有创建资金请求必须携带 `Idempotency-Key`。金额禁止使用二进制浮点，API 使用十进制字符串与币种精度，例如：

```json
{
  "asset": "USDT",
  "network": "ethereum",
  "amount": "12500.00",
  "destination": "0x...",
  "client_reference": "PAY-2026-00018"
}
```

资金状态由后端权威状态机返回，客户端不得自行将 `pending` 推进为 `completed`。WebSocket/SSE 只用于通知，断线重连后必须以 REST 查询结果校准。

## 环境配置

使用 `--dart-define` 注入非秘密配置：

```bash
flutter run --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://api-staging.example.com
```

API 密钥、签名私钥、银行凭据和托管商密钥不得打包进客户端。
