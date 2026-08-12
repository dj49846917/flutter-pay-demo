import 'package:crypto_pay/core/router.dart';
import 'package:crypto_pay/core/theme.dart';
import 'package:flutter/material.dart';

class CryptoPayApp extends StatelessWidget {
  const CryptoPayApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'CryptoPay',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: appRouter,
  );
}
