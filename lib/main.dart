import 'package:flutter/material.dart';
import 'coins.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Basic API Usage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _coins = <Coin>[];

  @override
  initState(){
    super.initState();
    listenForCoins();
  }


  listenForCoins() async {
    var stream = await getCoins();
    stream.listen((data){
      setState((){
        _coins = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
      title: new Text(_coin.name),
      subtitle: new Text(_coin.rank.toString()),
    );
  }
}
