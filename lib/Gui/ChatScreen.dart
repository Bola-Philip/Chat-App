import 'package:chat_app/Gui/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? chatroom;

  ChatScreen({Key? key, this.chatroom}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String text = '';
  bool? isMe = true;
  bool isDisabled = true;
  final userData = FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Color(0xFF770000),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Settings')
                      ],
                    ),
                    value: 'settings',
                  )
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'settings') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsMenu(),
                        ));
                  }
                },
              ),
            ],
          )),
      body: Column(
        children: [
          StreamBuilder(
            stream: fireStore
                .collection('chats/rooms/${widget.chatroom}')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              final docs = snapshot.data?.docs;
              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    if (docs?[index]['userUID'] == userData?.uid) {
                      isMe = true;
                    } else {
                      isMe = false;
                    }
                    return Row(
                      mainAxisAlignment: isMe!
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Column(
                            crossAxisAlignment: isMe!
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: isMe!
                                    ? EdgeInsets.only(
                                        bottom: 2.5, left: 10, right: 10)
                                    : EdgeInsets.only(
                                        bottom: 7.5, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: isMe!
                                        ? Color(0xBA000000)
                                        : Colors.grey.shade300,
                                    borderRadius: isMe!
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(25),
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                child: isMe!
                                    ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.5,
                                              right: 12.5,
                                              top: 3,
                                              bottom: 3),
                                          child: Text(
                                            docs?[index]['text'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 17.5,
                                            right: 5,
                                            top: 3,
                                            bottom: 3),
                                        child: Text(
                                          docs?[index]['text'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 7.5, right: 7.5),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextField(
                      cursorColor: Color(0xFF770000),
                      maxLines: null,
                      controller: _controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          contentPadding: EdgeInsets.only(left: 10)),
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                        text.trim().isNotEmpty
                            ? isDisabled = false
                            : isDisabled = true;
                      },
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: text.trim().isEmpty
                      ? null
                      : () {
                          fireStore
                              .collection('chats/rooms/${widget.chatroom}')
                              .add({
                            'text': text,
                            'createdAt': Timestamp.now(),
                            'userUID': userData?.uid,
                          });
                          _controller.clear();
                          text = '';
                        },
                  backgroundColor: isDisabled ? Colors.grey : Color(0xFF770000),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
