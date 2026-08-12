import 'package:crypto_pay/features/approvals/approvals.dart';
import 'package:crypto_pay/features/auth/auth.dart';
import 'package:crypto_pay/features/home/home.dart';
import 'package:crypto_pay/features/payments/payments.dart';
import 'package:crypto_pay/features/profile/profile.dart';
import 'package:crypto_pay/features/profile/profile_detail.dart';
import 'package:crypto_pay/features/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const AuthScreen(mode: 'login'),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const AuthScreen(mode: 'register'),
    ),
    GoRoute(
      path: '/forgot',
      builder: (_, __) => const AuthScreen(mode: 'forgot'),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (_, __) => const TransactionsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootKey,
                  builder: (_, state) =>
                      TransactionDetailScreen(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/payments',
              builder: (_, __) => const PaymentsHubScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/approvals',
              builder: (_, __) => const ApprovalsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/operation/:type',
      builder: (_, state) =>
          OperationScreen(type: state.pathParameters['type']!),
    ),
    GoRoute(path: '/activities', builder: (_, __) => const ActivitiesScreen()),
    GoRoute(
      path: '/notifications',
      builder: (_, __) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/profile/:section',
      builder: (_, state) =>
          ProfileSectionScreen(section: state.pathParameters['section']!),
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: '首页',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: '交易',
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_horiz_outlined),
          selectedIcon: Icon(Icons.swap_horiz),
          label: '资金',
        ),
        NavigationDestination(
          icon: Icon(Icons.approval_outlined),
          selectedIcon: Icon(Icons.approval),
          label: '审批',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    ),
  );
}
