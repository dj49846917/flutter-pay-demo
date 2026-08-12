import 'dart:async';

import 'package:crypto_pay/data/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class WalletRepository {
  Future<List<AssetBalance>> getAssets();
  Future<List<CryptoTransaction>> getTransactions();
  Future<List<ApprovalItem>> getApprovals();
  Future<List<ActivityCampaign>> getCampaigns();
}

class MockWalletRepository implements WalletRepository {
  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 220));

  @override
  Future<List<AssetBalance>> getAssets() async {
    await _latency();
    return const [
      AssetBalance('USDT', 'Tether', 68420.25, 68420.25, 0.02),
      AssetBalance('BTC', 'Bitcoin', 0.8421, 98125.40, 2.84),
      AssetBalance('ETH', 'Ethereum', 12.48, 45672.18, -1.12),
      AssetBalance('USDC', 'USD Coin', 22500, 22500, 0.01),
    ];
  }

  @override
  Future<List<CryptoTransaction>> getTransactions() async {
    await _latency();
    return [
      CryptoTransaction(
        id: 'TX-204891',
        type: '批量付款',
        asset: 'USDT',
        amount: -12500,
        fiatAmount: 12500,
        counterparty: '供应商批次 #A230',
        date: DateTime.now().subtract(const Duration(minutes: 42)),
        status: TransactionStatus.pending,
        hash: '0x71bc9e2f7d39a3e8c8f43a2c74df',
      ),
      CryptoTransaction(
        id: 'TX-204890',
        type: '充值',
        asset: 'BTC',
        amount: 0.12,
        fiatAmount: 13984.32,
        counterparty: 'External wallet',
        date: DateTime.now().subtract(const Duration(hours: 4)),
        status: TransactionStatus.completed,
        hash: '0xc38a951e3bcff2e0eafd7482e1cb',
      ),
      CryptoTransaction(
        id: 'TX-204889',
        type: '换币',
        asset: 'ETH',
        amount: 3.4,
        fiatAmount: 12443.10,
        counterparty: 'BTC → ETH',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.completed,
        hash: 'internal-swap-982144',
      ),
      CryptoTransaction(
        id: 'TX-204888',
        type: '法币出金',
        asset: 'USDC',
        amount: -8200,
        fiatAmount: 8200,
        counterparty: 'HSBC •• 8841',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: TransactionStatus.rejected,
        hash: 'offramp-218820',
      ),
    ];
  }

  @override
  Future<List<ApprovalItem>> getApprovals() async {
    await _latency();
    return [
      ApprovalItem(
        'AP-8821',
        '供应商付款',
        'Alice Chen',
        12500,
        'USDT',
        DateTime.now().subtract(const Duration(minutes: 42)),
      ),
      ApprovalItem(
        'AP-8819',
        '法币出金',
        'Marcus Lee',
        8200,
        'USDC',
        DateTime.now().subtract(const Duration(hours: 3)),
      ),
      ApprovalItem(
        'AP-8812',
        '营销费用报销',
        'Sofia Wong',
        2.8,
        'ETH',
        DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<ActivityCampaign>> getCampaigns() async {
    await _latency();
    return [
      ActivityCampaign(
        '夏季交易挑战',
        '累计换币达到 50,000 USDT',
        .68,
        '80 USDT',
        DateTime.now().add(const Duration(days: 12)),
      ),
      ActivityCampaign(
        '邀请企业伙伴',
        '完成企业认证后双方获得奖励',
        .4,
        '100 USDT',
        DateTime.now().add(const Duration(days: 25)),
      ),
    ];
  }
}

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => MockWalletRepository(),
);
final assetsProvider = FutureProvider(
  (ref) => ref.watch(walletRepositoryProvider).getAssets(),
);
final transactionsProvider = FutureProvider(
  (ref) => ref.watch(walletRepositoryProvider).getTransactions(),
);
final approvalsProvider = FutureProvider(
  (ref) => ref.watch(walletRepositoryProvider).getApprovals(),
);
final campaignsProvider = FutureProvider(
  (ref) => ref.watch(walletRepositoryProvider).getCampaigns(),
);
