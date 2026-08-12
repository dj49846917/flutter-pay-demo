import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/repository.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApprovalsScreen extends ConsumerWidget {
  const ApprovalsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('审批中心'),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
    ),
    body: ref
        .watch(approvalsProvider)
        .when(
          data: (items) => ListView(
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
                          '${items.length} 项待处理',
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
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
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
                                onPressed: () => _confirm(context, false),
                                child: const Text('拒绝'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _confirm(context, true),
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
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const EmptyState(title: '审批加载失败', description: '请稍后重试'),
        ),
  );

  Future<void> _confirm(BuildContext context, bool approve) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(approve ? '确认批准？' : '确认拒绝？'),
      content: Text(
        approve ? '批准后请求将继续执行。高风险交易可能仍需二次审批。' : '拒绝后该请求不会执行，并通知申请人。',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(approve ? '已批准（演示）' : '已拒绝（演示）')),
            );
          },
          child: const Text('确认'),
        ),
      ],
    ),
  );
}
