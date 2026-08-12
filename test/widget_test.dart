import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
import 'package:crypto_pay/features/payments/payments.dart';
import 'package:crypto_pay/features/profile/profile_detail.dart';
import 'package:crypto_pay/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
