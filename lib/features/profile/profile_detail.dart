import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';

const _titles = <String, String>{
  'company': '企业资料与 KYB',
  'team': '团队成员与角色',
  'banks': '银行账户',
  'address-book': '地址簿',
  'two-factor': '双重认证',
  'biometrics': '生物识别',
  'devices': '设备管理',
  'policies': '限额与审批策略',
  'notification-settings': '通知设置',
  'support': '帮助与支持',
  'legal': '关于与法律条款',
};

class ProfileSectionScreen extends StatefulWidget {
  const ProfileSectionScreen({super.key, required this.section});

  final String section;

  @override
  State<ProfileSectionScreen> createState() => _ProfileSectionScreenState();
}

class _ProfileSectionScreenState extends State<ProfileSectionScreen> {
  bool twoFactorEnabled = true;
  bool biometricEnabled = false;
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool transactionNotifications = true;
  bool approvalNotifications = true;
  bool requireTwoApprovers = true;
  double dailyLimit = 50000;

  final team = <(String, String, String)>[
    ('Alice Chen', 'alice@northstar.demo', '管理员'),
    ('Marcus Lee', 'marcus@northstar.demo', '审批人'),
    ('Sofia Wong', 'sofia@northstar.demo', '操作员'),
  ];
  final banks = <(String, String)>[
    ('HSBC Hong Kong', 'USD · •••• 8841'),
    ('DBS Bank', 'SGD · •••• 1208'),
  ];
  final addresses = <(String, String)>[
    ('Treasury Wallet', 'USDT-TRC20 · TX8p...2mk9'),
    ('Vendor Alpha', 'USDC-ERC20 · 0x71...c74d'),
  ];
  final devices = <(String, String)>[
    ('iPhone 17 Pro', '当前设备 · 上海 · 刚刚活跃'),
    ('Chrome on macOS', '上海 · 2 小时前'),
  ];

  @override
  Widget build(BuildContext context) {
    final title = _titles[widget.section] ?? '账户设置';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          switch (widget.section) {
            'company' => _company(),
            'team' => _entities(
              team.map((e) => (e.$1, '${e.$2} · ${e.$3}')).toList(),
              Icons.person_outline,
              '邀请成员',
              _inviteMember,
            ),
            'banks' => _entities(
              banks,
              Icons.account_balance_outlined,
              '添加银行账户',
              _addBank,
            ),
            'address-book' => _entities(
              addresses,
              Icons.account_balance_wallet_outlined,
              '添加钱包地址',
              _addAddress,
            ),
            'two-factor' => _twoFactor(),
            'biometrics' => _biometrics(),
            'devices' => _devices(),
            'policies' => _policies(),
            'notification-settings' => _notificationSettings(),
            'support' => _support(),
            'legal' => _legal(),
            _ => const EmptyState(title: '页面不存在', description: '请返回用户中心重新选择。'),
          },
        ],
      ),
    );
  }

  Widget _company() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFE7F8EF),
                  child: Icon(Icons.verified, color: AppColors.success),
                ),
                title: Text('KYB 已通过'),
                subtitle: Text('复审日期：2027-06-30'),
              ),
              const Divider(),
              _field('企业名称', 'Northstar Trading Ltd.'),
              _field('注册编号', 'HK-CR-882014', enabled: false),
              _field('注册地址', 'Central, Hong Kong'),
              _field('业务类型', 'Digital commerce'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: _saved, child: const Text('保存企业资料')),
    ],
  );

  Widget _field(String label, String value, {bool enabled = true}) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextFormField(
      initialValue: value,
      enabled: enabled,
      decoration: InputDecoration(labelText: label),
    ),
  );

  Widget _entities(
    List<(String, String)> entries,
    IconData icon,
    String buttonLabel,
    VoidCallback add,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        child: Column(
          children: entries
              .map(
                (entry) => ListTile(
                  leading: CircleAvatar(child: Icon(icon, size: 20)),
                  title: Text(entry.$1),
                  subtitle: Text(entry.$2),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) =>
                        _toast(value == 'edit' ? '已打开编辑模式（演示）' : '已移除（演示）'),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('编辑')),
                      PopupMenuItem(value: 'remove', child: Text('移除')),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: add,
        icon: const Icon(Icons.add),
        label: Text(buttonLabel),
      ),
    ],
  );

  Widget _twoFactor() => Column(
    children: [
      const DemoNotice(),
      const SizedBox(height: 16),
      Card(
        child: Column(
          children: [
            SwitchListTile(
              value: twoFactorEnabled,
              onChanged: (value) => setState(() => twoFactorEnabled = value),
              secondary: const Icon(Icons.phonelink_lock),
              title: const Text('Authenticator 动态验证码'),
              subtitle: Text(twoFactorEnabled ? '已启用 · 上次验证 2 小时前' : '当前未启用'),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () => _showRecoveryCodes(),
              leading: const Icon(Icons.key_outlined),
              title: const Text('恢复代码'),
              subtitle: const Text('查看并重新生成一次性恢复代码'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _biometrics() => Card(
    child: SwitchListTile(
      value: biometricEnabled,
      onChanged: (value) {
        setState(() => biometricEnabled = value);
        _toast(value ? '生物识别已启用（演示）' : '生物识别已关闭');
      },
      secondary: const Icon(Icons.fingerprint, color: AppColors.primary),
      title: const Text('使用 Face ID / 指纹'),
      subtitle: const Text('用于登录及确认高风险资金操作'),
    ),
  );

  Widget _devices() => Column(
    children: [
      Card(
        child: Column(
          children: devices
              .map(
                (device) => ListTile(
                  leading: const Icon(Icons.devices_outlined),
                  title: Text(device.$1),
                  subtitle: Text(device.$2),
                  trailing: device == devices.first
                      ? const Chip(label: Text('当前'))
                      : TextButton(
                          onPressed: () => _confirmDevice(device),
                          child: const Text('移除'),
                        ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 12),
      const Text('移除设备后，该设备上的登录状态和本地令牌将失效。'),
    ],
  );

  Widget _policies() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('单日付款限额：\$${dailyLimit.round()}'),
              Slider(
                value: dailyLimit,
                min: 10000,
                max: 200000,
                divisions: 19,
                label: '\$${dailyLimit.round()}',
                onChanged: (value) => setState(() => dailyLimit = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: requireTwoApprovers,
                onChanged: (value) =>
                    setState(() => requireTwoApprovers = value),
                title: const Text('大额付款需要双人审批'),
                subtitle: const Text('金额超过 10,000 USDT 时生效'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.schedule_outlined),
                title: Text('审批有效期'),
                trailing: Text('24 小时'),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton(onPressed: _saved, child: const Text('保存审批策略')),
    ],
  );

  Widget _notificationSettings() => Card(
    child: Column(
      children: [
        _switch(
          '邮件通知',
          '发送到 alice@northstar.demo',
          emailNotifications,
          (v) => setState(() => emailNotifications = v),
        ),
        _switch(
          '推送通知',
          '发送到已登录设备',
          pushNotifications,
          (v) => setState(() => pushNotifications = v),
        ),
        _switch(
          '交易状态',
          '到账、失败和大额转账提醒',
          transactionNotifications,
          (v) => setState(() => transactionNotifications = v),
        ),
        _switch(
          '待审批提醒',
          '新的审批请求和即将过期提醒',
          approvalNotifications,
          (v) => setState(() => approvalNotifications = v),
        ),
      ],
    ),
  );

  Widget _switch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> changed,
  ) => SwitchListTile(
    value: value,
    onChanged: changed,
    title: Text(title),
    subtitle: Text(subtitle),
  );

  Widget _support() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        child: Column(
          children: [
            _supportTile('充值多久可以到账？', '达到所选网络要求的确认数后自动入账。'),
            _supportTile('提现为什么需要审批？', '企业策略、限额或风险规则可能触发人工审批。'),
            _supportTile('如何添加新的审批人？', '进入团队成员与角色，邀请成员并分配审批人角色。'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: _contactSupport,
        icon: const Icon(Icons.support_agent),
        label: const Text('联系客户支持'),
      ),
    ],
  );

  Widget _supportTile(String question, String answer) => ExpansionTile(
    title: Text(question),
    children: [Padding(padding: const EdgeInsets.all(16), child: Text(answer))],
  );

  Widget _legal() => Column(
    children: [
      const Card(
        child: ListTile(
          leading: BrandMark(compact: true),
          title: Text('CryptoPay Demo'),
          subtitle: Text('版本 1.0.0+1 · Flutter 3.44'),
        ),
      ),
      const SizedBox(height: 12),
      Card(
        child: Column(
          children: [
            _documentTile('服务条款'),
            _documentTile('隐私政策'),
            _documentTile('风险披露'),
            _documentTile('开源软件许可'),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const Text('本工程为产品演示，不提供真实托管、交易或投资服务。', textAlign: TextAlign.center),
    ],
  );

  Widget _documentTile(String title) => ListTile(
    onTap: () => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const SingleChildScrollView(
          child: Text('这是演示版本的文档占位内容。生产发布前应由法务与合规团队根据服务地区、牌照范围和数据处理方式提供正式文本。'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    ),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
  );

  Future<void> _inviteMember() async {
    final values = await _inputDialog('邀请团队成员', '工作邮箱', '角色');
    if (values == null) return;
    setState(() => team.add(('新成员', values.$1, values.$2)));
    _toast('邀请已发送（演示）');
  }

  Future<void> _addBank() async {
    final values = await _inputDialog('添加银行账户', '银行名称', '账户尾号');
    if (values == null) return;
    setState(() => banks.add((values.$1, 'USD · •••• ${values.$2}')));
    _toast('银行账户已提交验证（演示）');
  }

  Future<void> _addAddress() async {
    final values = await _inputDialog('添加钱包地址', '地址名称', '钱包地址');
    if (values == null) return;
    setState(() => addresses.add((values.$1, 'USDT · ${values.$2}')));
    _toast('地址已添加（演示）');
  }

  Future<(String, String)?> _inputDialog(
    String title,
    String firstLabel,
    String secondLabel,
  ) async {
    final first = TextEditingController();
    final second = TextEditingController();
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: first,
              decoration: InputDecoration(labelText: firstLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: second,
              decoration: InputDecoration(labelText: secondLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (first.text.trim().isEmpty || second.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(context, (first.text.trim(), second.text.trim()));
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> _confirmDevice((String, String) device) async {
    final remove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除设备？'),
        content: Text('${device.$1} 将需要重新登录。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('移除'),
          ),
        ],
      ),
    );
    if (remove == true) {
      setState(() => devices.remove(device));
    }
  }

  void _showRecoveryCodes() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '恢复代码',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 14),
            SelectableText('CPAY-18D4-92KF\nCPAY-73LM-20QX\nCPAY-55AA-81VT'),
            SizedBox(height: 12),
            Text('请离线保存。每个代码仅可使用一次。'),
          ],
        ),
      ),
    ),
  );

  void _contactSupport() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('创建支持工单'),
      content: const TextField(
        maxLines: 4,
        decoration: InputDecoration(labelText: '请描述遇到的问题'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            _toast('工单 CP-20260812 已创建（演示）');
          },
          child: const Text('提交'),
        ),
      ],
    ),
  );

  void _saved() => _toast('设置已保存（演示）');

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
