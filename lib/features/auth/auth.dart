import 'dart:async';

import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum LoginMethod { account, phone }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});

  final String mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  LoginMethod loginMethod = LoginMethod.account;
  bool obscure = true;
  bool submitting = false;
  int countdown = 0;
  Timer? countdownTimer;

  String get title => switch (widget.mode) {
    'register' => '创建企业账户',
    'forgot' => '找回密码',
    _ => '欢迎回来',
  };

  @override
  void dispose() {
    countdownTimer?.cancel();
    phoneController.dispose();
    smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = widget.mode == 'register';
    final forgot = widget.mode == 'forgot';
    final login = !register && !forgot;
    final phoneLogin = login && loginMethod == LoginMethod.phone;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 44),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(forgot ? '输入注册邮箱，我们会发送重置链接。' : '安全管理数字资产、付款和审批。'),
                    if (login) ...[
                      const SizedBox(height: 24),
                      SegmentedButton<LoginMethod>(
                        segments: const [
                          ButtonSegment(
                            value: LoginMethod.account,
                            icon: Icon(Icons.person_outline),
                            label: Text('账号密码'),
                          ),
                          ButtonSegment(
                            value: LoginMethod.phone,
                            icon: Icon(Icons.phone_android_outlined),
                            label: Text('手机号'),
                          ),
                        ],
                        selected: {loginMethod},
                        onSelectionChanged: submitting
                            ? null
                            : (value) {
                                setState(() {
                                  loginMethod = value.first;
                                  formKey.currentState?.reset();
                                });
                              },
                      ),
                    ],
                    const SizedBox(height: 28),
                    if (register) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '企业名称',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: _required,
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (phoneLogin) ...[
                      TextFormField(
                        key: const Key('phone-field'),
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        decoration: const InputDecoration(
                          labelText: '手机号',
                          hintText: '请输入 6–15 位手机号',
                          prefixIcon: Icon(Icons.phone_android_outlined),
                        ),
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('sms-code-field'),
                        controller: smsCodeController,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: '短信验证码',
                          counterText: '',
                          prefixIcon: const Icon(Icons.sms_outlined),
                          suffixIcon: TextButton(
                            key: const Key('send-sms-code'),
                            onPressed: countdown > 0 ? null : _sendSmsCode,
                            child: Text(
                              countdown > 0 ? '${countdown}s' : '获取验证码',
                            ),
                          ),
                        ),
                        validator: _validateSmsCode,
                      ),
                    ] else ...[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: '工作邮箱',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: (value) =>
                            value != null && value.contains('@')
                            ? null
                            : '请输入有效邮箱',
                      ),
                      if (!forgot) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          obscureText: obscure,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: '密码',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              (value?.length ?? 0) >= 8 ? null : '密码至少 8 位',
                        ),
                      ],
                    ],
                    if (login && !phoneLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go('/forgot'),
                          child: const Text('忘记密码？'),
                        ),
                      ),
                    const SizedBox(height: 10),
                    FilledButton(
                      key: const Key('auth-submit'),
                      onPressed: submitting ? null : _submit,
                      child: submitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              forgot
                                  ? '发送重置链接'
                                  : register
                                  ? '注册并开始认证'
                                  : phoneLogin
                                  ? '验证并登录'
                                  : '登录',
                            ),
                    ),
                    if (phoneLogin) ...[
                      const SizedBox(height: 10),
                      const Text(
                        '演示短信验证码：246810',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (!forgot)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(register ? '已有账户？' : '还没有账户？'),
                          TextButton(
                            onPressed: () =>
                                context.go(register ? '/login' : '/register'),
                            child: Text(register ? '登录' : '立即注册'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final login = widget.mode == 'login';
    if (!login) {
      context.go(widget.mode == 'forgot' ? '/login' : '/home');
      return;
    }

    setState(() => submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => submitting = false);

    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const GraphicalVerificationDialog(),
    );
    if (verified == true && mounted) context.go('/home');
  }

  void _sendSmsCode() {
    final error = _validatePhone(phoneController.text);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => countdown = 60);
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => countdown = 0);
      } else {
        setState(() => countdown--);
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('验证码已发送。演示验证码：246810')));
  }

  String? _validatePhone(String? value) {
    final normalized = (value ?? '').replaceAll(RegExp(r'[\s+-]'), '');
    return RegExp(r'^\d{6,15}$').hasMatch(normalized) ? null : '请输入有效手机号';
  }

  String? _validateSmsCode(String? value) {
    if (!RegExp(r'^\d{6}$').hasMatch(value ?? '')) return '请输入 6 位短信验证码';
    return value == '246810' ? null : '短信验证码不正确';
  }

  String? _required(String? value) =>
      (value?.trim().isEmpty ?? true) ? '此项必填' : null;
}

class GraphicalVerificationDialog extends StatefulWidget {
  const GraphicalVerificationDialog({super.key});

  @override
  State<GraphicalVerificationDialog> createState() =>
      _GraphicalVerificationDialogState();
}

class _GraphicalVerificationDialogState
    extends State<GraphicalVerificationDialog> {
  static const correct = <int>{0, 4, 7};
  static const tiles = <(IconData, Color)>[
    (Icons.currency_bitcoin, Color(0xFFF59E0B)),
    (Icons.account_balance, Color(0xFF2563EB)),
    (Icons.pets, Color(0xFFEC4899)),
    (Icons.directions_car, Color(0xFF64748B)),
    (Icons.currency_bitcoin, Color(0xFF8B5CF6)),
    (Icons.local_cafe, Color(0xFF92400E)),
    (Icons.flight, Color(0xFF0891B2)),
    (Icons.currency_bitcoin, Color(0xFF10B981)),
    (Icons.home, Color(0xFFEF4444)),
  ];

  final selected = <int>{};
  String? error;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('安全验证'),
    content: SingleChildScrollView(
      child: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '请选择所有包含比特币符号的图片',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text('选完后点击“验证”。', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                final tile = tiles[index];
                final active = selected.contains(index);
                return Semantics(
                  label: '验证图片 ${index + 1}',
                  selected: active,
                  button: true,
                  child: InkWell(
                    key: Key('captcha-tile-$index'),
                    onTap: () => setState(() {
                      active ? selected.remove(index) : selected.add(index);
                      error = null;
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: tile.$2.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(tile.$1, color: tile.$2, size: 36),
                          ),
                          if (active)
                            const Positioned(
                              right: 5,
                              top: 5,
                              child: Icon(
                                Icons.check_circle,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(
                error!,
                key: const Key('captcha-error'),
                style: const TextStyle(color: AppColors.danger),
              ),
            ],
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('取消'),
      ),
      FilledButton(
        key: const Key('captcha-verify'),
        onPressed: () {
          if (selected.length == correct.length &&
              selected.containsAll(correct)) {
            Navigator.pop(context, true);
          } else {
            setState(() {
              error = selected.isEmpty ? '请先选择图片' : '选择不正确，请重新选择';
              selected.clear();
            });
          }
        },
        child: const Text('验证'),
      ),
    ],
  );
}
