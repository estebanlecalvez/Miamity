import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/AddUserPage.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:transparent_image/transparent_image.dart';
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
        child:
          Container(
            padding:EdgeInsets.all(10),
            child: Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Row(  
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FadeInImage.memoryNetwork(
                            height: 130,
                            width:150,
                            placeholder: kTransparentImage,
                            fadeInDuration: const Duration(seconds:1),
                            image:document["profile_picture"] ,
                          ),
                          Padding(padding:EdgeInsets.only(right:170)),
                        ]),
                        Text(
                          document["firstname"]+" "+document["lastname"],
                          style: TextStyle(fontSize: 20.0),
                        ),
                    ],
                  ),
                  MiamityRedButton(title: 'Delete',onPressed: (){
                    _showDialogSuppression(document);
                  },)
                ],
              )
          ],
        ),)
      )
    );
  }
  
    void _showDialogSuppression(DocumentSnapshot document){
      showDialog(context: context,builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?",style: TextStyle(color: Colors.red),),
          content: Text("This action is irreversible",style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
          actions: <Widget>[
            MiamityRedButton(
              title:"Yes!",
              width:80,
              onPressed: (){
                //So simple :o
                Firestore.instance.document("users/"+document.documentID).delete();
                Navigator.pop(context);
              },
            ),
            MiamityGreenButton(
              title:"Forget it!",
              width:100,
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      });
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
              





