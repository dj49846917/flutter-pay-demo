import 'package:crypto_pay/core/theme.dart';
import 'package:crypto_pay/data/models.dart';
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
}
