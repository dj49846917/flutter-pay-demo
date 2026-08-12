import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/data/repository.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});
  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String filter = '全部';
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('交易记录'),
        actions: [
          IconButton(
            tooltip: '导出交易记录',
            onPressed: _showExportSheet,
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['全部', '充值', '提现', '换币', '付款', '出金']
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(item),
                        selected: filter == item,
                        onSelected: (_) => setState(() => filter = item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: transactions.when(
              data: (items) {
                final visible = filter == '全部'
                    ? items
                    : items.where((t) => t.type.contains(filter)).toList();
                return visible.isEmpty
                    ? const EmptyState(title: '暂无交易', description: '该筛选条件下没有记录')
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) => TransactionTile(
                          visible[i],
                          onTap: () =>
                              context.push('/transactions/${visible[i].id}'),
                        ),
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const EmptyState(title: '加载失败', description: '请检查网络后重试'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExportSheet() async {
    final format = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '导出交易记录',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text('当前筛选：$filter · 时间范围：最近 30 天'),
              const SizedBox(height: 12),
              ListTile(
                onTap: () => Navigator.pop(context, 'CSV'),
                leading: const Icon(Icons.table_view_outlined),
                title: const Text('导出 CSV'),
                subtitle: const Text('适合表格软件和财务系统'),
              ),
              ListTile(
                onTap: () => Navigator.pop(context, 'PDF'),
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('导出 PDF 对账单'),
                subtitle: const Text('包含企业信息与汇总数据'),
              ),
            ],
          ),
        ),
      ),
    );
    if (format == null || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$format 导出任务已创建，完成后将发送到工作邮箱（演示）')));
  }
}

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all =
        ref.watch(transactionsProvider).value ?? const <CryptoTransaction>[];
    final tx = all.where((item) => item.id == id).firstOrNull;
    if (tx == null) {
      return const Scaffold(
        body: EmptyState(title: '交易不存在', description: '记录可能已被删除或尚未同步'),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('交易详情')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: .1),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${tx.amount > 0 ? '+' : ''}${tx.amount} ${tx.asset}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatusBadge(tx.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _DetailRow('交易编号', tx.id),
                  _DetailRow('交易类型', tx.type),
                  _DetailRow('交易对方', tx.counterparty),
                  _DetailRow(
                    '法币估值',
                    NumberFormat.currency(symbol: r'$').format(tx.fiatAmount),
                  ),
                  _DetailRow(
                    '时间',
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(tx.date),
                  ),
                  _DetailRow('网络/参考号', tx.hash, copyable: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader('处理进度'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: AppColors.success),
                    title: Text('请求已创建'),
                    subtitle: Text('身份与请求参数校验完成'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: AppColors.success),
                    title: Text('风控审核'),
                    subtitle: Text('KYT/AML 策略检查通过'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.radio_button_checked,
                      color: AppColors.warning,
                    ),
                    title: Text('网络确认'),
                    subtitle: Text('等待目标网络达到确认数'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.copyable = false});
  final String label;
  final String value;
  final bool copyable;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (copyable)
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(Icons.copy, size: 16),
          ),
      ],
    ),
  );
}
