enum TransactionStatus { completed, pending, rejected }

class AssetBalance {
  const AssetBalance(
    this.symbol,
    this.name,
    this.amount,
    this.fiatValue,
    this.change,
  );
  final String symbol;
  final String name;
  final double amount;
  final double fiatValue;
  final double change;
}

class CryptoTransaction {
  const CryptoTransaction({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.fiatAmount,
    required this.counterparty,
    required this.date,
    required this.status,
    required this.hash,
  });
  final String id;
  final String type;
  final String asset;
  final double amount;
  final double fiatAmount;
  final String counterparty;
  final DateTime date;
  final TransactionStatus status;
  final String hash;
}

class ApprovalItem {
  const ApprovalItem(
    this.id,
    this.title,
    this.requester,
    this.amount,
    this.asset,
    this.createdAt,
  );
  final String id;
  final String title;
  final String requester;
  final double amount;
  final String asset;
  final DateTime createdAt;
}

class ActivityCampaign {
  const ActivityCampaign(
    this.title,
    this.description,
    this.progress,
    this.reward,
    this.endsAt,
  );
  final String title;
  final String description;
  final double progress;
  final String reward;
  final DateTime endsAt;
}
