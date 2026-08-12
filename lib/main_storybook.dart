// ignore_for_file: depend_on_referenced_packages

import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const CryptoPayStorybook());

class CryptoPayStorybook extends StatelessWidget {
  const CryptoPayStorybook({super.key});
  @override
  Widget build(BuildContext context) => Storybook(
    wrapperBuilder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        body: SafeArea(child: Center(child: child)),
      ),
    ),
    stories: [
      Story(
        name: 'Brand/Brand mark',
        description: 'Primary product identity.',
        builder: (_) =>
            const Padding(padding: EdgeInsets.all(24), child: BrandMark()),
      ),
      Story(
        name: 'Feedback/Status badges',
        description: 'Transaction lifecycle states.',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            children: [
              StatusBadge(TransactionStatus.completed),
              StatusBadge(TransactionStatus.pending),
              StatusBadge(TransactionStatus.rejected),
            ],
          ),
        ),
      ),
      Story(
        name: 'Feedback/Demo notice',
        description: 'Mandatory banner on non-production money flows.',
        builder: (_) =>
            const Padding(padding: EdgeInsets.all(24), child: DemoNotice()),
      ),
      Story(
        name: 'Data/Transaction row - completed',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: TransactionTile(
            CryptoTransaction(
              id: 'TX-10001',
              type: '充值',
              asset: 'BTC',
              amount: .12,
              fiatAmount: 13000,
              counterparty: 'External wallet',
              date: DateTime(2026, 8, 12),
              status: TransactionStatus.completed,
              hash: '0x123',
            ),
          ),
        ),
      ),
      Story(
        name: 'Data/Transaction row - pending',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: TransactionTile(
            CryptoTransaction(
              id: 'TX-10002',
              type: '批量付款',
              asset: 'USDT',
              amount: -12500,
              fiatAmount: 12500,
              counterparty: 'Batch A230',
              date: DateTime(2026, 8, 12),
              status: TransactionStatus.pending,
              hash: '0x456',
            ),
          ),
        ),
      ),
      Story(
        name: 'States/Empty state',
        builder: (_) => const EmptyState(
          title: '暂无交易',
          description: '完成第一笔资金操作后，记录会显示在这里。',
        ),
      ),
      Story(
        name: 'Actions/Primary button',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 320,
            child: FilledButton(onPressed: () {}, child: const Text('提交审批')),
          ),
        ),
      ),
      Story(
        name: 'Forms/Text field',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 360,
            child: TextField(
              decoration: InputDecoration(
                labelText: '钱包地址',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
