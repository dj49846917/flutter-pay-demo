import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/repository.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

const operationMeta = <String, (String, IconData, String)>{
  'deposit': ('充值', Icons.add_circle_outline, '获取链上充值地址'),
  'withdraw': ('提现', Icons.arrow_circle_up_outlined, '发送资产到外部钱包'),
  'swap': ('换币', Icons.swap_horiz, '实时询价并兑换资产'),
  'invoice': ('Invoice', Icons.request_quote_outlined, '创建并跟踪收款账单'),
  'offramp': ('法币出金', Icons.account_balance_outlined, '兑换并结算至企业银行账户'),
  'batch': ('批量付款', Icons.format_list_bulleted, '上传文件并批量发起付款'),
};

class PaymentsHubScreen extends ConsumerWidget {
  const PaymentsHubScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('资金管理')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const DemoNotice(),
          const SizedBox(height: 18),
          Text(
            '资金操作',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.38,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: operationMeta.entries
                .map(
                  (entry) => Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => context.push('/operation/${entry.key}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(entry.value.$2, color: AppColors.primary),
                            const Spacer(),
                            Text(
                              entry.value.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              entry.value.$3,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const SectionHeader('可用余额'),
          assets.when(
            data: (items) => Card(
              child: Column(
                children: items
                    .map(
                      (a) => ListTile(
                        title: Text(a.symbol),
                        subtitle: Text(a.name),
                        trailing: Text(
                          a.amount.toStringAsFixed(4),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class OperationScreen extends StatefulWidget {
  const OperationScreen({super.key, required this.type});
  final String type;
  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  String asset = 'USDT';
  bool submitted = false;
  final amount = TextEditingController();
  final destination = TextEditingController();

  @override
  void dispose() {
    amount.dispose();
    destination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meta =
        operationMeta[widget.type] ?? ('资金操作', Icons.payments_outlined, '');
    final deposit = widget.type == 'deposit';
    return Scaffold(
      appBar: AppBar(title: Text(meta.$1)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DemoNotice(),
          const SizedBox(height: 18),
          if (submitted)
            _Success(type: meta.$1)
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: asset,
                      decoration: const InputDecoration(labelText: '资产'),
                      items: ['USDT', 'USDC', 'BTC', 'ETH']
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => asset = value!),
                    ),
                    const SizedBox(height: 14),
                    if (deposit) ...[
                      Center(
                        child: QrImageView(
                          data:
                              'cryptopay:$asset:0x71bc9e2f7d39a3e8c8f43a2c74df',
                          size: 190,
                          eyeStyle: const QrEyeStyle(color: AppColors.ink),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SelectableText(
                        '0x71bc9e2f7d39a3e8c8f43a2c74df',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '仅向此地址充值所选资产。错误网络或资产可能无法找回。',
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      TextFormField(
                        controller: amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: widget.type == 'invoice'
                              ? 'Invoice 金额'
                              : '金额',
                          suffixText: asset,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: destination,
                        decoration: InputDecoration(
                          labelText: _destinationLabel(widget.type),
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                        ),
                      ),
                      if (widget.type == 'batch') ...[
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload_file),
                          label: const Text('上传 CSV/XLSX 付款文件'),
                        ),
                      ],
                      const SizedBox(height: 14),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('预计费用'),
                        trailing: Text('网络费用将在询价后显示'),
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        onPressed: () => setState(() => submitted = true),
                        child: Text(widget.type == 'swap' ? '获取实时报价' : '提交审批'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _destinationLabel(String type) => switch (type) {
    'offramp' => '收款银行账户',
    'invoice' => '客户邮箱',
    'swap' => '目标资产',
    'batch' => '付款批次名称',
    _ => '目标钱包地址',
  };
}

class _Success extends StatelessWidget {
  const _Success({required this.type});
  final String type;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 66, color: AppColors.success),
          const SizedBox(height: 16),
          Text(
            '$type 请求已创建',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            '请求已进入风控与审批流程，可在交易记录或审批中心跟踪。',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/transactions'),
            child: const Text('查看交易记录'),
          ),
        ],
      ),
    ),
  );
}

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('活动中心')),
    body: ref
        .watch(campaignsProvider)
        .when(
          data: (items) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 150,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CryptoPay Rewards',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '完成任务，解锁企业专属奖励',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...items.map(
                (item) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(item.description),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('${(item.progress * 100).round()}%'),
                            const Spacer(),
                            Text(
                              '奖励 ${item.reward}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const EmptyState(title: '活动加载失败', description: '稍后再试'),
        ),
  );
}
