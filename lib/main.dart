import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() => runApp(new MaterialApp(
  home: new MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  State createState() => new _State();
}

enum Answer{YES,NO,MAYBE}

class _State extends State<MyApp> {

  // Radios
  int _value1 = 0;
  int _value2 = 0;

  void _setValue1(int value) => setState(() => _value1 = value);
  void _setValue2(int value) => setState(() => _value2 = value);

  Widget makeRadios(){
    List<Widget> list = new List<Widget>();

    for(int i = 0; i<3; i++){
      list.add(new Radio(value: i, groupValue: _value1, onChanged: _setValue1));
    }

    Column column = new Column(children: list,);
    return column;
  }

  Widget makeRadiosTiles(){
    List<Widget> list = new List<Widget>();

    for(int i = 0; i<3; i++){
      list.add(new RadioListTile(
          value: i,
          groupValue: _value2,
          onChanged: _setValue2,
          activeColor: Colors.green,
          controlAffinity: ListTileControlAffinity.trailing,
          title: new Text('Item: $i'),
          subtitle: new Text('sub title'),
      ));
    }

    Column column = new Column(children: list,);
    return column;
  }

  // switch
  bool _value3 = false;
  bool _value4 = false;

  void _onChange3(bool value) => setState(() => _value3 = value);
  void _onChange4(bool value) => setState(() => _value4 = value);

  // slider
  double _value = 0.0;
  void _setValue(double value) => setState(() => _value = value);

  // date picker
  String _value5 = '';

  Future _selectDate() async{
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _value5 = picked.toString());
  }

  // appbar
  int titleInt = 0;
  void _incTitle() => setState(() => titleInt++);
  void _decTitle() => setState(() => titleInt--);

  // Footer buttons
  String _fotBut = '';
  void _onClick(String value) => setState(() => _fotBut = value);

  // Bottom Nav Bar
  List<BottomNavigationBarItem> _items;
  String _valueNav = '';
  int _index = 0;

  // list view builder, lecture 32
  Map _countries = new Map();
  void _getData() async {
    var url = 'http://country.io/names.json';
    var response = await http.get(url);

    if(response.statusCode == 200){
      setState(() => _countries = JSON.decode(response.body));
      print('Loaded ${_countries.length} countries');
    }
  }

  @override
  void initState() {
    _items = new List<BottomNavigationBarItem>();
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.people), title: new Text('People')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.weekend), title: new Text('Weekend')));
    _items.add(new BottomNavigationBarItem(icon: new Icon(Icons.message), title: new Text('Message')));


    // List View lecture 32
    _getData();
  }
  
  // Bottom Sheet
  void _showButton(){
    showModalBottomSheet<void>(
        context: context, 
        builder: (BuildContext context){
          return new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Some info here', style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
              ],
            ),
          );
        }
    );
  }

  // SnackBar
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  void _showBar(){
    _scaffoldstate.currentState.showSnackBar(new SnackBar(content: new Text('Hello World')));
  }
  
  // Alert Dialog
  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(message),
        actions: <Widget>[
          new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('Ok')),
          new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Cancel')),
        ],
      )
    );
  }

  // Simple Dialog
  String _valueSimple = '';
  void _setValue3(String value) => setState(() => _valueSimple = value);
  Future _askUser() async {
    switch(
    // ask user dijalankan setelah show dialog selesai berjalan
    await showDialog(
        context: context, 
        child: new SimpleDialog(
          title: new Text('Do you like flutter?'),
          children: <Widget>[
            new SimpleDialogOption(child: new Text('Yes!!!'), onPressed: (){Navigator.pop(context, Answer.YES);},),
            new SimpleDialogOption(child: new Text('No :('), onPressed: (){Navigator.pop(context, Answer.NO);},),
            new SimpleDialogOption(child: new Text('Maybe :|'), onPressed: (){Navigator.pop(context, Answer.MAYBE);},),
          ],
        )
    )
    ){
      case Answer.YES:
        _setValue3('Yes');
        break;
      case Answer.NO:
        _setValue3('No');
        break;
      case Answer.MAYBE:
        _setValue3('Maybe');
        break;
    }
  }

  // Lecture 29, row & column
  TextEditingController _user = new TextEditingController();
  TextEditingController _pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(titleInt.toString()),
          backgroundColor: Colors.red,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.add), onPressed: _incTitle),
            new IconButton(icon: new Icon(Icons.remove), onPressed: _decTitle),
          ],
        ),
        drawer: new Drawer(
          child: new Container(
            padding: new EdgeInsets.all(32.0),
            child: new Column(
              children: <Widget>[
                new Text('Hello Drawer'),
                new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
              ],
            ),
          ),
        ),
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
//                new Text(_valueSimple),
//                new RaisedButton(onPressed: _askUser, child: new Text('Click me'),),
//                makeRadios(),
//                makeRadiosTiles(),
//                new Switch(value: _value3, onChanged: _onChange3),
//                new SwitchListTile(value: _value4,
//                    onChanged: _onChange4,
//                    title: new Text(
//                      'Hello World',
//                      style: new TextStyle(
//                        fontWeight: FontWeight.bold,
//                        color: Colors.red,
//                      ),
//                    ),
//                ),
//                new Text('Value: ${(_value * 100).round()}'),
//                new Slider(value: _value, onChanged: _setValue),
//                new Text(_fotBut),
//                new Text(_value5),
//                new RaisedButton(onPressed: _selectDate, child: new Text('Click Me!'),),
//                new Text(_valueNav),
//                new Text('Add widgets here'),
//                new RaisedButton(onPressed: _showButton, child: new Text('Click me'),),
//                new RaisedButton(onPressed: _showBar, child: new Text('Click me'),),
//                new RaisedButton(onPressed: () => _showAlert(context, 'Do you like flutter, I do!'), child: new Text('Click me'),),
//                new Text('Please Login'),
//                new Row(
//                  children: <Widget>[
//                    new Text('Username: '),
//                    new Expanded(child: new TextField(controller: _user,)),
//                  ],
//                ),
//                new Row(
//                  children: <Widget>[
//                    new Text('Password: '),
//                    new Expanded(child: new TextField(controller: _pass, obscureText: true,)),
//                  ],
//                ),
//                new Padding(
//                  padding: new EdgeInsets.all(12.0),
//                  child: new RaisedButton(onPressed: () => debugPrint('Login ${_user.text}'), child: new Text('Click me!'),),
//                  new Card(
//                    child: new Container(
//                      padding: new EdgeInsets.all(32.0),
//                      child: new Column(
//                        children: <Widget>[
//                          new Text('Hello World'),
//                          new Text('How are you?'),
//                        ],
//                      ),
//                    ),
//                  ),
//                  new Image.asset('images/flutter.jpg'),
//                  new Image.network('http://voidrealms.com/images/smile.jpg'),
                    // dynamic size image become
//                  new Expanded(child: new Image.asset('images/flutter.jpg')),
//                  new Expanded(child: new Image.network('http://voidrealms.com/images/smile.jpg')),
                    new Text('Countries', style: new TextStyle(fontWeight: FontWeight.bold),),
                    new Expanded(child: new ListView.builder(
                        itemBuilder: (BuildContext context, int index){
                          String key = _countries.keys.elementAt(index);
                          return new Row(
                            children: <Widget>[
                              new Text('${key} : '),
                              new Text(_countries[key]),
                            ],
                          );
                        },
                        itemCount: _countries.length,
                    ))
              ],
            ),
          ),
        ),
//        floatingActionButton: new FloatingActionButton(
//            onPressed: _selectDate,
//            backgroundColor: Colors.red,
//            mini: false,
//            child: new Icon(Icons.timer),
//        ),
//        persistentFooterButtons: <Widget>[
//          new IconButton(icon: new Icon(Icons.timer), onPressed: () => _onClick('Button 1')),
//          new IconButton(icon: new Icon(Icons.people), onPressed: () => _onClick('Button 2')),
//          new IconButton(icon: new Icon(Icons.map), onPressed: () => _onClick('Button 3')),
//        ],
//        bottomNavigationBar: new BottomNavigationBar(
//            items: _items,
//          fixedColor: Colors.blue,
//          currentIndex: _index,
//          onTap: (int item){
//              setState(() {
//                _index = item;
//                _valueNav = "Current value is: ${_index.toString()}";
//              });
//          },
//        ),
      );
  }
}

