import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/ChatPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/auth.dart';

class ShowDishesDetailsPage extends StatefulWidget {
  ShowDishesDetailsPage(
      {this.document,
      this.auth,
      this.onSignedOut,
      @required this.authorDishId});
  final DocumentSnapshot document;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String authorDishId;
  createState() => ShowDishesDetailsState();
}

class ShowDishesDetailsState extends State<ShowDishesDetailsPage> {
  bool _activeAllergens = true;
  bool _activeInfo = false;
  bool _activeOpinion = false;
  DocumentSnapshot user;
  bool isThereAUser;

// Fontions permettant de switch de vues
  void _allergensTab() {
    setState(() {
      _activeAllergens = true;
      _activeInfo = false;
      _activeOpinion = false;
    });
  }

  @override
  initState() {
    isUserCharged();
    super.initState();
  }

  Future<void> isUserCharged() async {
    bool result = await widget.auth.isAUserConnected();
    DocumentSnapshot document = await getUser();
    setState(() {
      user = document;
      isThereAUser = result;
    });
  }

  Future<DocumentSnapshot> getUser() async {
    DocumentSnapshot result = await Firestore.instance
        .collection("users")
        .document(widget.authorDishId)
        .get();
    setState(() {
      user = result;
    });
    return user;
  }

  void _infoTab() {
    setState(() {
      _activeAllergens = false;
      _activeInfo = true;
      _activeOpinion = false;
    });
  }

  void _opinionTab() {
    setState(() {
      _activeAllergens = false;
      _activeInfo = false;
      _activeOpinion = true;
    });
  }

  _buildTab() {
    if (_activeAllergens) {
      List<Widget> allergens = [];
      allergens.add(new Flexible(
          child: new Text(
        'Has autem provincias, quas Orontes ambiens amnis imosque pedes Cassii montis illius celsi praetermeans funditur in Parthenium mare, Gnaeus Pompeius superato Tigrane regnis Armeniorum abstractas dicioni Romanae coniunxit.',
        textAlign: TextAlign.center,
      )));
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: allergens,
      );
    }

    if (_activeInfo) {
      List<Widget> info = [];
      info.add(new Flexible(
          child: new Text(
        'On l\'a fait poto',
        textAlign: TextAlign.center,
      )));
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info,
      );
    }

    if (_activeOpinion) {
      return new StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildListOpinion(context, snapshot.data.documents));
          });
    }
    return new Container();
  }

  List<Widget> _buildListOpinion(
      BuildContext context, List<DocumentSnapshot> document) {
    List<Widget> opinions = [];
    for (var i = 0; i < document.length; i++) {
      opinions.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                document[i]['username'],
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }
    return opinions;
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> streamGetUser = Firestore.instance
        .collection('users')
        .document(widget.authorDishId)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du plat'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          //Titre + Info sur le mamachef
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.document['dish_title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 30,
                    ),
                    StreamBuilder(
                      stream: streamGetUser,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return Text(snapshot.data['username']);
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    new Container(
                      child: new Center(
                        child: RaisedButton(
                          padding: EdgeInsets.all(10),
                          color: Colors.orange,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.message),
                              Text(
                                'Contacter',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          onPressed: () {
                            widget.auth.changePage(
                                context,
                                ChatScreen(
                                  peerAvatar: user.data["profile_picture"],
                                  peerId: widget.document["user_id"],
                                  auth: widget.auth,
                                  onSignedOut: widget.onSignedOut,
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, bottom: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: "picture_dish_of_" + widget.document['photo'],
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.document['photo']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Distance, Parts, Prix
          Container(
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Parts
                        Flexible(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                  child: Icon(
                                Icons.person,
                                size: 40.0,
                                color: Colors.grey[500],
                              )),
                              Flexible(
                                child: Text(
                                  widget.document['nb_parts'].toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 30),
                                ),
                              )
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                ),
                //Distance
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                                child: Icon(
                              Icons.near_me,
                              size: 40.0,
                              color: Colors.grey[500],
                            )),
                            //TODO Faire le calcul entre la position de l'user actuel et la position du plat.
                            Flexible(
                                child: Text(
                              '800 m',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 30),
                            )),
                          ],
                        )),
                      )
                    ],
                  ),
                ),
                //Prix
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.loose,
                                child: Center(
                                    child: Text(
                                  widget.document['price'],
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                )),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Icon(
                                    Icons.euro_symbol,
                                    size: 30,
                                    color: Colors.orange,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          //Description
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.document['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                )
              ],
            ),
          ),
          //Switch Allergènes, info cuisto, Avis
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Container(
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: FlatButton(
                          child: Text('Allergènes'),
                          color: _activeAllergens
                              ? Colors.orange[700]
                              : Colors.grey[100],
                          onPressed: _allergensTab,
                        ),
                      )
                    ],
                  ),
                )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: FlatButton(
                              child: Text('Info cuisto'),
                              color: _activeInfo
                                  ? Colors.orange[700]
                                  : Colors.grey[100],
                              onPressed: _infoTab,
                            ),
                          )
                        ],
                      ),
                    )),
                Flexible(
                    child: Container(
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: FlatButton(
                          child: Text('Avis'),
                          color: _activeOpinion
                              ? Colors.orange[700]
                              : Colors.grey[100],
                          onPressed: _opinionTab,
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
          //Affichage des 3 onglets.
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.all(20),
            child: _buildTab(),
          ),
        ],
      ),
      //Bouton pour commander sticky
      bottomNavigationBar: Container(
        height: 60,
        child: RaisedButton(
          color: Colors.orange,
          child: Text(
            'Commander',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          onPressed: () {},
        ),
      ),
      endDrawer:
          MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
