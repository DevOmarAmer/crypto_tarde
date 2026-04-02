class OrderBookEntity {
  final List<OrderBookLevel> bids; // Green, left
  final List<OrderBookLevel> asks; // Red, right

  const OrderBookEntity({required this.bids, required this.asks});

  factory OrderBookEntity.empty() => const OrderBookEntity(bids: [], asks: []);
}

class OrderBookLevel {
  final double price;
  final double quantity;

  const OrderBookLevel({required this.price, required this.quantity});
}
