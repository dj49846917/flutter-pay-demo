import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/features/auth/auth.dart';
import 'package:crypto_pay/features/payments/payments.dart';
import 'package:crypto_pay/features/profile/profile_detail.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('status badge renders localized status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: StatusBadge(TransactionStatus.pending)),
      ),
    );
    expect(find.text('处理中'), findsOneWidget);
  });

  testWidgets('demo notice identifies non-production flow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: DemoNotice()),
      ),
    );
    expect(find.textContaining('演示环境'), findsOneWidget);
  });

  testWidgets('notification settings menu provides working switches', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const ProfileSectionScreen(section: 'notification-settings'),
      ),
    );

    final emailSwitch = find.widgetWithText(SwitchListTile, '邮件通知');
    expect(emailSwitch, findsOneWidget);
    expect(tester.widget<SwitchListTile>(emailSwitch).value, isTrue);

    await tester.tap(emailSwitch);
    await tester.pump();

    expect(tester.widget<SwitchListTile>(emailSwitch).value, isFalse);
  });

  testWidgets('withdraw flow validates required fields before submission', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const OperationScreen(type: 'withdraw'),
      ),
    );

    await tester.tap(find.text('提交审批'));
    await tester.pump();

    expect(find.text('请输入有效金额'), findsOneWidget);
    expect(find.text('此项必填'), findsOneWidget);
  });

  testWidgets('account login requires successful graphical verification', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => const AuthScreen(mode: 'login'),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('登录成功首页')),
        ),
        GoRoute(
          path: '/forgot',
          builder: (_, __) => const AuthScreen(mode: 'forgot'),
        ),
        GoRoute(
          path: '/register',
          builder: (_, __) => const AuthScreen(mode: 'register'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, '工作邮箱'),
      'alice@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '密码'),
      'password123',
    );
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('安全验证'), findsOneWidget);
    await tester.tap(find.byKey(const Key('captcha-verify')));
    await tester.pump();
    expect(find.text('请先选择图片'), findsOneWidget);

    for (final index in [0, 4, 7]) {
      final tile = find.byKey(Key('captcha-tile-$index'));
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pump();
    }
    await tester.ensureVisible(find.byKey(const Key('captcha-verify')));
    await tester.tap(find.byKey(const Key('captcha-verify')));
    await tester.pumpAndSettle();

    expect(find.text('登录成功首页'), findsOneWidget);
  });

  testWidgets('phone login validates the demo sms code', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const AuthScreen(mode: 'login'),
      ),
    );

    await tester.tap(find.text('手机号'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('phone-field')), '13800138000');
    await tester.enterText(find.byKey(const Key('sms-code-field')), '111111');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump();

    expect(find.text('短信验证码不正确'), findsOneWidget);
    expect(find.text('演示短信验证码：246810'), findsOneWidget);
  });
}
