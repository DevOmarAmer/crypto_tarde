import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1m&limit=100');
  final response = await http.get(url);
  final data = jsonDecode(response.body) as List;
  print("Klines length: ${data.length}");
}
