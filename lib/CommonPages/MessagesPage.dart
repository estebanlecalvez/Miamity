import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
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
                    padding: EdgeInsets.only(right: 30.0),
                    child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(document["profile_picture"])),
                  ),
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
                        child: Text(
                          "Are you okay mate? please respond.",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes messages"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
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
