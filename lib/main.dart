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
      home: MyHomePage(title: 'Liste des users'),
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
    return ListTile(
      title:Row(
        children: [
          Expanded(
            child: Text(
              document['firstname']+"\n"+document['lastname'],
              style:Theme.of(context).textTheme.body1,
            ),
          ),
          
           Expanded(
            child: Text(
              document['username']+"\n"+document['password']+"\n"+document['phone'],
              style:Theme.of(context).textTheme.body1,
            ),
          ),
           Expanded(
            child: Text(
              document['email'],
              style:Theme.of(context).textTheme.body1,
            ),
          ),
          
        ],
        ),
        onTap: () {
          
        },
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
            itemExtent:80.0,
            itemCount:snapshot.data.documents.length,
            itemBuilder: (context,index) =>
              _buildListItem(context,snapshot.data.documents[index]),
          );
        }),
      );
  }
}




