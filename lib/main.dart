import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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


  _showAddUserDialog() async {
  await showDialog<String>(
    context: context,
    child: AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: 
      Container(
        child: 
          ListView(
            children: <Widget>[
              Text("Add user",style: TextStyle(fontSize: 20.0,color: Colors.green),),
            TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Firstname'),
              controller: userFirstnameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Lastname'),
              controller: userLastNameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
              controller: userPhoneController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email*'),
              controller: userEmailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Username*'),
              controller: userUsernameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password*'),
              controller: userPasswordController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password confirmation*'),
              controller: userPasswordConfirmationController,
            ),
          ],
          ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          }),
        FlatButton(
          child: Text('Add'),
          onPressed: (){
            if(userUsernameController.text.isNotEmpty &&
              userPasswordController.text.isNotEmpty &&
              userEmailController.text.isNotEmpty &&
              userPasswordConfirmationController.text.isNotEmpty &&
              userPasswordConfirmationController.text == userPasswordController.text){
              Firestore.instance
                .collection('users')
                .add({
                  "firstname": userFirstnameController.text,
                  "lastname": userLastNameController.text,
                  "email": userEmailController.text,
                  "phone": userPhoneController.text,
                  "username": userUsernameController.text,
                  "password": userPasswordController.text,
              })
              .then((result) => {
                Navigator.pop(context),
                userEmailController.clear(),
                userFirstnameController.clear(),
                userLastNameController.clear(),
                userPasswordConfirmationController.clear(),
                userPasswordController.clear(),
                userUsernameController.clear(),
              })
              .catchError((err) => err);
       
            }
          }
        ),
      ],
    ),
  );
}

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return Card(
      key: document["id"],
      margin: EdgeInsets.all(5.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MiamityGreenButton("See user",(){  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowUserPage()),
                );}
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
    
  }




}
              





