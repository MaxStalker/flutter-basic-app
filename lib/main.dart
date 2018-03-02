import 'package:flutter/material.dart';
import 'coins.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(title: 'CoinBin API'),
    );
  }
}

enum SortParams { rank, price, name }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _rawData = <Coin>[];
  var _coins = <Coin>[];
  var _query = SortParams.rank;
  var _reverseSort = false;
  var _sortType = 0;

  @override
  initState() {
    super.initState();
    listenForCoins();
  }

  listenForCoins() async {
    var stream = await getCoins();
    stream.listen((data) {
      _rawData = data;
      setState(() {
        _coins = _rawData;
      });
    });
  }

  _filter() {
    print(_query);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Filter',
              onPressed: _filter),
          new PopupMenuButton<SortParams>(
            onSelected: (SortParams result) {
              _coins = _rawData.sublist(0);
              setState(() {
                _sortType = result.index;
                if (result.index == _sortType) {
                  _reverseSort = !_reverseSort;
                } else {
                  _reverseSort = false;
                }
                switch (result) {
                  case SortParams.rank:
                    _coins.sort((a, b) => _reverseSort
                        ? a.rank.compareTo(b.rank)
                        : b.rank.compareTo(a.rank));
                    break;
                  case SortParams.name:
                    _coins.sort((a, b) => _reverseSort
                        ? a.name.compareTo(b.name)
                        : b.name.compareTo(a.name));
                    break;
                  case SortParams.price:
                    _coins.sort((a, b) => _reverseSort
                        ? a.fiatRate.compareTo(b.fiatRate)
                        : b.fiatRate.compareTo(a.fiatRate));
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortParams>>[
                  const PopupMenuItem<SortParams>(
                    value: SortParams.rank,
                    child: const Text('Sort by Rank'),
                  ),
                  const PopupMenuItem<SortParams>(
                    value: SortParams.name,
                    child: const Text('Sort by Name'),
                  ),
                  const PopupMenuItem<SortParams>(
                    value: SortParams.price,
                    child: const Text('Sort by Price'),
                  ),
                ],
          )
        ],
      ),
      body: new Container(
        child: new ListView(
          children: _coins.map((coin) => new CustomCoinWidget(coin)).toList(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CoinWidget extends StatelessWidget {
  final Coin _coin;

  CoinWidget(this._coin);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(_coin.rank.toString(),
            style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      title: new Text(
        _coin.name,
        style: new TextStyle(fontWeight: FontWeight.bold, height: 1.25),
      ),
      subtitle: new Text('\$${_coin.fiatRate.toString()}',
          style: new TextStyle(
              fontSize: 12.0, color: Colors.black.withOpacity(0.5))),
    );
  }
}

class CustomCoinWidget extends StatelessWidget {
  final Coin _coin;

  CustomCoinWidget(this._coin);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: new CircleAvatar(
                  child: new Text(_coin.rank.toString(),
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                )),
            new Expanded(
                child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  _coin.name,
                  style:
                      new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text('\$${_coin.fiatRate.toString()}',
                    style: new TextStyle(
                        fontSize: 12.0, color: Colors.black))
              ],
            ))
          ],
        ));
  }
}
