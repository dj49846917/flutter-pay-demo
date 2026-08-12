import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/data/repository.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApprovalsScreen extends ConsumerStatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  ConsumerState<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends ConsumerState<ApprovalsScreen> {
  String filter = '全部';
  final handled = <String>{};

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('审批中心'),
      actions: [
        IconButton(
          tooltip: '筛选审批',
          onPressed: _selectFilter,
          icon: Badge(
            isLabelVisible: filter != '全部',
            child: const Icon(Icons.tune),
          ),
        ),
      ],
    ),
    body: ref
        .watch(approvalsProvider)
        .when(
          data: (allItems) {
            final available = allItems
                .where((item) => !handled.contains(item.id))
                .toList();
            final items = switch (filter) {
              '大额' => available.where((item) => item.amount >= 10000).toList(),
              '我的申请' =>
                available
                    .where((item) => item.requester == 'Alice Chen')
                    .toList(),
              _ => available,
            };
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.pending_actions,
                        color: AppColors.warning,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${items.length} 项待处理 · $filter',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text('请在付款窗口结束前完成审批'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const EmptyState(
                    title: '暂无待审批请求',
                    description: '可以切换筛选条件查看其他请求。',
                  ),
                ...items.map(
                  (item) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _showDetails(item),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                item.id,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${item.requester} · ${DateFormat('MM-dd HH:mm').format(item.createdAt)}',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${item.amount.toStringAsFixed(2)} ${item.asset}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _handle(item.id, false),
                                  child: const Text('拒绝'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => _handle(item.id, true),
                                  child: const Text('批准'),
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const EmptyState(title: '审批加载失败', description: '请稍后重试'),
        ),
  );

  Future<void> _handle(String id, bool approve) async {
    final confirmed = await _confirm(context, approve);
    if (confirmed != true || !mounted) return;
    setState(() => handled.add(id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(approve ? '已批准（演示）' : '已拒绝（演示）')));
  }

  Future<bool?> _confirm(BuildContext context, bool approve) =>
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(approve ? '确认批准？' : '确认拒绝？'),
          content: Text(
            approve ? '批准后请求将继续执行。高风险交易可能仍需二次审批。' : '拒绝后该请求不会执行，并通知申请人。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('确认'),
            ),
          ],
        ),
      );

  Future<void> _selectFilter() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: RadioGroup<String>(
          groupValue: filter,
          onChanged: (value) => Navigator.pop(context, value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['全部', '大额', '我的申请']
                .map(
                  (value) =>
                      RadioListTile<String>(value: value, title: Text(value)),
                )
                .toList(),
          ),
        ),
      ),
    );
    if (selected != null) setState(() => filter = selected);
  }

  void _showDetails(ApprovalItem item) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            ListTile(title: const Text('审批编号'), trailing: Text(item.id)),
            ListTile(title: const Text('申请人'), trailing: Text(item.requester)),
            ListTile(
              title: const Text('金额'),
              trailing: Text('${item.amount.toStringAsFixed(2)} ${item.asset}'),
            ),
            const ListTile(title: Text('风控结果'), trailing: Text('检查通过')),
          ],
        ),
      ),
    ),
  );
}
