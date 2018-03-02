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
      home: new HomePage(title: 'Basic API Usage'),
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

  @override
  initState(){
    super.initState();
    listenForCoins();
  }

  compare(a,b){
    if (a.rank == b.rank) return 0;
    return (a.rank < b.rank) ? -1 : 1;
  }

  listenForCoins() async {
    var stream = await getCoins();
    stream.listen((data){
      _rawData = data;
      print(_query.toString());
      setState((){
        _coins = _rawData;
      });
    });
  }

  _filter(){
    print('Filter list');
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
              onPressed: _filter
          ),
          new PopupMenuButton<SortParams>(
            onSelected: (SortParams result) {
              _filter();
              setState(() { _query = result; });
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
      body: new Center(
        child: new ListView(
          children: _coins.map((coin)=> new CoinWidget(coin)).toList(),
        ),
      ),  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CoinWidget extends StatelessWidget{
  final Coin _coin;

  CoinWidget(this._coin);

  @override
  Widget build(BuildContext context){
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(_coin.rank.toString()),
      ),
      title: new Text(_coin.name),
      subtitle: new Text('\$${_coin.fiatRate}'),
    );
  }
}
