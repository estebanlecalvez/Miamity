import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miamity',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Liste des users Miamity'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return Card(
        child: Column(
          children: <Widget>[
          Row(  
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person),
                  Padding(padding:EdgeInsets.only(right:60)),
                ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    document["firstname"]+" "+document["lastname"],
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10),),
                  Row(
                    children: <Widget>[
                      Text(
                        "Email: ",
                        style:TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        document["email"],
                      )
                      
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Username: ",
                        style:TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        document["username"],
                      )
                      
                    ],
                    ),                ]
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.black,
                child: Text("See user [TODO]"),
                onPressed:null,
              )
            ],
          ),
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
          itemCount:snapshot.data.documents.length,
          itemBuilder: (context,index) =>
            _buildListItem(context,snapshot.data.documents[index]),
        );
      }),
    );
  }
}




