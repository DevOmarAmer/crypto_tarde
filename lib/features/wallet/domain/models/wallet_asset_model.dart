class WalletAssetModel {
  final String name;
  final String symbol;
  final String iconAsset;
  final String cryptoBalance; // الرصيد بالعملة الرقمية
  final String fiatBalance;   // الرصيد المعادل بالدولار

  WalletAssetModel({
    required this.name,
    required this.symbol,
    required this.iconAsset,
    required this.cryptoBalance,
    required this.fiatBalance,
  });
}
