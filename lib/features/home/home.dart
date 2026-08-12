import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/data/repository.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsProvider);
    final transactions = ref.watch(transactionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(),
        actions: [
          IconButton(
            tooltip: '通知中心',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(assetsProvider);
          ref.invalidate(transactionsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _BalanceCard(assets: assets.value ?? const []),
            const SizedBox(height: 18),
            _QuickActions(onTap: (type) => context.push('/operation/$type')),
            const SizedBox(height: 20),
            const _StatsStrip(),
            const SizedBox(height: 20),
            SectionHeader(
              '资产',
              action: '查看全部',
              onTap: () => context.go('/payments'),
            ),
            assets.when(
              data: (items) => Card(
                child: Column(
                  children: items.map((a) => _AssetTile(a)).toList(),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) =>
                  const EmptyState(title: '资产加载失败', description: '下拉刷新后重试'),
            ),
            const SizedBox(height: 16),
            SectionHeader(
              '最近交易',
              action: '全部',
              onTap: () => context.go('/transactions'),
            ),
            transactions.when(
              data: (items) => Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: items
                        .take(3)
                        .map(
                          (t) => TransactionTile(
                            t,
                            onTap: () => context.push('/transactions/${t.id}'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.assets});
  final List<AssetBalance> assets;
  @override
  Widget build(BuildContext context) {
    final total = assets.fold<double>(0, (sum, item) => sum + item.fiatValue);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF23213F), Color(0xFF6C5CE7)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('总资产估值', style: TextStyle(color: Colors.white70)),
              Spacer(),
              Icon(Icons.visibility_outlined, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.currency(symbol: r'$').format(total),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: _Metric('本月流入', r'$128,430', Icons.south_west)),
              Expanded(child: _Metric('本月流出', r'$86,240', Icons.north_east)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.secondary, size: 18),
      const SizedBox(width: 7),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ],
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onTap});
  final ValueChanged<String> onTap;
  @override
  Widget build(BuildContext context) {
    const items = [
      ('deposit', '充值', Icons.add),
      ('withdraw', '提现', Icons.arrow_upward),
      ('swap', '换币', Icons.swap_horiz),
      ('invoice', 'Invoice', Icons.request_quote_outlined),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map(
            (item) => InkWell(
              onTap: () => onTap(item.$1),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(item.$3, color: AppColors.primary),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.$2,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: const [
          Expanded(child: _Stat('待审批', '3', AppColors.warning)),
          Expanded(child: _Stat('本月交易', '126', AppColors.primary)),
          Expanded(child: _Stat('成功率', '98.7%', AppColors.success)),
        ],
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 3),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _AssetTile extends StatelessWidget {
  const _AssetTile(this.asset);
  final AssetBalance asset;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(child: Text(asset.symbol.substring(0, 1))),
    title: Text(
      asset.symbol,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    subtitle: Text(asset.name),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          asset.amount.toStringAsFixed(asset.symbol == 'BTC' ? 4 : 2),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(
          '${asset.change >= 0 ? '+' : ''}${asset.change}%',
          style: TextStyle(
            color: asset.change >= 0 ? AppColors.success : AppColors.danger,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final unread = <int>{0, 1};
  static final items = <(IconData, String, String, String)>[
    (
      Icons.approval_outlined,
      '新的审批请求',
      'Marcus 提交了一笔 8,200 USDC 法币出金。',
      '10 分钟前',
    ),
    (Icons.south_west, 'BTC 充值已到账', '0.12 BTC 已达到网络确认数并计入余额。', '4 小时前'),
    (Icons.security_outlined, '新设备登录', 'Chrome on macOS 在上海登录了企业账户。', '昨天'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('通知中心'),
      actions: [
        TextButton(
          onPressed: unread.isEmpty
              ? null
              : () => setState(() => unread.clear()),
          child: const Text('全部已读'),
        ),
      ],
    ),
    body: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: unread.contains(index)
              ? AppColors.primary.withValues(alpha: .06)
              : null,
          child: ListTile(
            onTap: () => setState(() => unread.remove(index)),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: .1),
              child: Icon(item.$1, color: AppColors.primary),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.$2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (unread.contains(index))
                  const Icon(Icons.circle, size: 9, color: AppColors.primary),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('${item.$3}\n${item.$4}'),
            ),
            isThreeLine: true,
          ),
        );
      },
    ),
  );
}
