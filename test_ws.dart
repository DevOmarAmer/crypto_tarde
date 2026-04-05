import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  final uri = Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@depth20@100ms');
  final channel = WebSocketChannel.connect(uri);

  channel.stream.listen((event) {
    var data = jsonDecode(event);
    print("Bids len: ${(data['bids'] as List).length}");
    print("Asks len: ${(data['asks'] as List).length}");
    channel.sink.close();
  });
}
