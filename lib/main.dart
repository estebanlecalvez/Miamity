import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/AddUserPage.dart';
import 'package:miamitymds/Utils/Transitions/ScalePageTransition.dart';
import 'Widgets/MiamityGreenButton.dart';
import 'ShowUserPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miamity',
      theme: ThemeData(
      primarySwatch: Colors.green,
      cardColor: Colors.grey[100]
      ),
      home: MyHomePage(title: 'Liste des users Miamity')
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

  TextEditingController userFirstnameController;
  TextEditingController userLastNameController;
  TextEditingController userEmailController;
  TextEditingController userUsernameController;
  TextEditingController userPasswordController;
  TextEditingController userPhoneController;
  TextEditingController userPasswordConfirmationController;

  @override
  initState() {
    userFirstnameController = new TextEditingController();
    userLastNameController = new TextEditingController();
    userEmailController = new TextEditingController();
    userUsernameController = new TextEditingController();
    userPasswordController = new TextEditingController();
    userPhoneController = new TextEditingController();
    userPasswordConfirmationController = new TextEditingController();
    super.initState();
  }



  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return  new GestureDetector(
      onTap:(){Navigator.push(context,MaterialPageRoute(builder: (context)=> ShowUserPage(document: document)));},
      child:new Card(
        key: document["id"],
          child: 
          Container(
            padding:EdgeInsets.all(10),
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
                        ),
                      ],
                      ),
                  ]
                ),
              ],
            ),
          ],
        ),)
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
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        return ListView.builder(
          itemCount:snapshot.data.documents.length,
          itemBuilder: (context,index) =>
            _buildListItem(context,snapshot.data.documents[index]),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new AddUser()),
          );
        } ,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
    
  }
}
              





