import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.currency_bitcoin_rounded, color: Colors.white),
      ),
      if (!compact) ...[
        const SizedBox(width: 10),
        Text(
          'CryptoPay',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    ],
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
    ],
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final TransactionStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TransactionStatus.completed => ('已完成', AppColors.success),
      TransactionStatus.pending => ('处理中', AppColors.warning),
      TransactionStatus.rejected => ('已拒绝', AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 54, color: Colors.grey),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class TransactionTile extends StatelessWidget {
  const TransactionTile(this.transaction, {super.key, this.onTap});
  final CryptoTransaction transaction;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    leading: CircleAvatar(
      backgroundColor: AppColors.primary.withValues(alpha: .1),
      child: const Icon(Icons.swap_horiz, color: AppColors.primary),
    ),
    title: Text(
      transaction.type,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    subtitle: Text(
      '${transaction.counterparty} · ${DateFormat('MM-dd HH:mm').format(transaction.date)}',
    ),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(transaction.asset == 'BTC' ? 4 : 2)} ${transaction.asset}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        StatusBadge(transaction.status),
      ],
    ),
  );
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.warning.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      children: [
        Icon(Icons.shield_outlined, color: AppColors.warning),
        SizedBox(width: 10),
        Expanded(child: Text('演示环境：资金操作不会广播至链上或银行网络。')),
      ],
    ),
  );
}
