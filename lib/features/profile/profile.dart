import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('用户中心')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'AC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alice Chen',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text('Northstar Trading Ltd.'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'KYB 已认证',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _MenuGroup(
          title: '企业与账户',
          items: [
            _Menu('企业资料与 KYB', Icons.business_outlined, () {}),
            _Menu('团队成员与角色', Icons.groups_outlined, () {}),
            _Menu('银行账户', Icons.account_balance_outlined, () {}),
            _Menu('地址簿', Icons.contact_page_outlined, () {}),
          ],
        ),
        _MenuGroup(
          title: '安全',
          items: [
            _Menu('双重认证', Icons.phonelink_lock_outlined, () {}),
            _Menu('生物识别', Icons.fingerprint, () {}),
            _Menu('设备管理', Icons.devices_outlined, () {}),
            _Menu('限额与审批策略', Icons.policy_outlined, () {}),
          ],
        ),
        _MenuGroup(
          title: '更多',
          items: [
            _Menu(
              '活动中心',
              Icons.campaign_outlined,
              () => context.push('/activities'),
            ),
            _Menu('通知设置', Icons.notifications_outlined, () {}),
            _Menu('帮助与支持', Icons.help_outline, () {}),
            _Menu('关于与法律条款', Icons.info_outline, () {}),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.go('/login'),
          child: const Text('退出登录'),
        ),
        const SizedBox(height: 12),
        const Text(
          'CryptoPay 1.0.0 (Demo)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

class _Menu {
  const _Menu(this.title, this.icon, this.onTap);
  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});
  final String title;
  final List<_Menu> items;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      SectionHeader(title),
      Card(
        child: Column(
          children: items
              .map(
                (item) => ListTile(
                  onTap: item.onTap,
                  leading: Icon(item.icon, color: AppColors.primary),
                  title: Text(item.title),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 6),
    ],
  );
}
