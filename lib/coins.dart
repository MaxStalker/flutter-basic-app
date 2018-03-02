import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

main() {
  getCoins();
}

class Coin {
  final String name;
  final int rank;
  final num fiatRate;

  Coin.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        rank = jsonMap['rank'],
        fiatRate = jsonMap['usd'];

  String toString() => 'Coin $name';
}

Future<Stream<List<Coin>>> getCoins() async {
  var url = 'https://coinbin.org/coins';
  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
      .transform(UTF8.decoder)
      .transform(JSON.decoder)
      .map((data) {
        List<Coin> _coins = <Coin>[];
        (data as Map)['coins'].forEach((k, v) => _coins.add(new Coin.fromJson(v)));
        return _coins;
      });
}
