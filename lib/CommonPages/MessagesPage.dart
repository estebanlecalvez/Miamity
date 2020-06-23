import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:miamitymds/CommonPages/ChatPage.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/auth.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagesPage> {
  DocumentSnapshot currentUser;
  var logger = Logger();
  var usersToShow;
  bool isCharging;
  @override
  void initState() {
    super.initState();
    this.setState(() {
      isCharging = true;
    });
    getUser();
  }

  getUser() async {
    this.setState(() {
      isCharging = true;
    });
    var userId = await widget.auth.currentUser();
    var user =
        await Firestore.instance.collection("users").document(userId).get();

    var usersChattedWith = user.data["previouslyChattedWith"];
    this.setState(() {
      currentUser = user;
      usersToShow = usersChattedWith;
    });
    this.setState(() {
      isCharging = false;
    });
  }

  _buildListItem(BuildContext context, DocumentSnapshot document) {
    bool showThisUser = false;
    String lastMessage = "";
    for (var userToShow in usersToShow) {
      if (userToShow["userId"].toString() == document.documentID.toString()) {
        lastMessage = userToShow["lastMessage"];
        showThisUser = true;
      }
    }
    return showThisUser
        ? Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: GestureDetector(
              onTap: () {
                widget.auth.changePage(
                    context,
                    ChatScreen(
                      peerAvatar: document["profile_picture"],
                      peerId: document.documentID,
                      auth: widget.auth,
                      onSignedOut: widget.onSignedOut,
                    ));
              },
              child: Container(
                color: Colors.grey[100],
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            child: document["profile_picture"] != null &&
                                    document["profile_picture"] != ""
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        document["profile_picture"]))
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage("images/no_avatar.jpg"))),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(document["username"],
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                lastMessage,
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes messages"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (isCharging) {
              return Center(
                child: MiamityProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: MiamityProgressIndicator(),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }
          },
        ),
      ),
    );
  }
}
