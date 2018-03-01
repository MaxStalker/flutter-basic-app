import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

main() {
  getCoins();
}

class Coin {
  final String name;
  final int rank;
  final double fiatRate;

  Coin.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        rank = jsonMap['rank'],
        fiatRate = jsonMap['usd'];

  String toString() => 'Coin $name';
}

getCoins() async {
  var url = 'https://coinbin.org/coins';
/*
  http.get(url).then(
      (res)=> print(res.body)
  );*/

  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
      .transform(UTF8.decoder)
      .transform(JSON.decoder)
      .expand((jsonBody) => (jsonBody as Map)['coins'])
      .expand((coins) => (coins as List))

      .listen((data) => print(data))
      .onDone(() => client.close());
}