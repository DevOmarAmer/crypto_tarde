import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class BinanceWebSocketService {
  static const String wssBaseUrl = 'wss://stream.binance.com:9443/ws';
  
  final Map<String, WebSocketChannel> _channels = {};

  /// Connects to a specific stream if not already connected
  WebSocketChannel connectStream(String streamName) {
    if (_channels.containsKey(streamName)) {
      return _channels[streamName]!;
    }
    
    final uri = Uri.parse('$wssBaseUrl/$streamName');
    debugPrint('Connecting WebSocket to: $uri');
    
    final channel = WebSocketChannel.connect(uri);
    _channels[streamName] = channel;
    
    return channel;
  }

  /// Close a specific stream
  void closeStream(String streamName) {
    if (_channels.containsKey(streamName)) {
      debugPrint('Closing WebSocket: $streamName');
      _channels[streamName]!.sink.close();
      _channels.remove(streamName);
    }
  }

  /// Close all streams
  void closeAll() {
    for (final channel in _channels.values) {
      channel.sink.close();
    }
    _channels.clear();
  }

  // Pre-configured stream helpers

  /// Stream for Live Ticker (24h stats + current price)
  /// e.g. btcousdt@ticker
  Stream<dynamic> getTickerStream(String symbol) {
    final streamName = '${symbol.toLowerCase()}@ticker';
    final channel = connectStream(streamName);
    return channel.stream.map((event) => jsonDecode(event));
  }

  /// Stream for Order Book up to 20 levels
  /// e.g. btcusdt@depth20@100ms
  Stream<dynamic> getDepthStream(String symbol) {
    final streamName = '${symbol.toLowerCase()}@depth20@100ms';
    final channel = connectStream(streamName);
    return channel.stream.map((event) => jsonDecode(event));
  }

  /// Stream for Klines (Candlesticks)
  /// e.g. btcusdt@kline_1m
  Stream<dynamic> getKlineStream(String symbol, String interval) {
    final streamName = '${symbol.toLowerCase()}@kline_$interval';
    final channel = connectStream(streamName);
    return channel.stream.map((event) => jsonDecode(event));
  }
}
