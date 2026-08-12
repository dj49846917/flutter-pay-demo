import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});
  final String mode;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool obscure = true;

  String get title => switch (widget.mode) {
    'register' => '创建企业账户',
    'forgot' => '找回密码',
    _ => '欢迎回来',
  };

  @override
  Widget build(BuildContext context) {
    final register = widget.mode == 'register';
    final forgot = widget.mode == 'forgot';
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
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '工作邮箱',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : '请输入有效邮箱',
                    ),
                    if (!forgot) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        obscureText: obscure,
                        decoration: InputDecoration(
                          labelText: '密码',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
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
                    if (!register && !forgot)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go('/forgot'),
                          child: const Text('忘记密码？'),
                        ),
                      ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.go(forgot ? '/login' : '/home');
                        }
                      },
                      child: Text(
                        forgot
                            ? '发送重置链接'
                            : register
                            ? '注册并开始认证'
                            : '登录',
                      ),
                    ),
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

  String? _required(String? value) =>
      (value?.trim().isEmpty ?? true) ? '此项必填' : null;
}
