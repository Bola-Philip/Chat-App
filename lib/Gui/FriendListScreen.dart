import 'package:chat_app/Gui/ChatScreen.dart';
import 'package:chat_app/Gui/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  String search = '';
  String chatRoomNumber = '';
  String path = '';
  final userData = FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance;
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  TextEditingController _controller = TextEditingController();

  Future getLastComment() async{
    final fuck = await FirebaseFirestore.instance.collection('chats/rooms/$chatRoomNumber').orderBy('createdAt',descending: true).get();
    print('///////////////////////////////////////////////////////////////////////////');
    print(fuck.docs[0]['text']);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: fireStore.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final docs = snapshot.data?.docs;
            return StreamBuilder(
              stream: fireStore
                  .collection('users/${userData?.uid}/listData')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                final docs2 = snapshot2.data?.docs;
                return Column(
                  children: [
                    SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.17,
                        color: Color(0xFF770000),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Chats',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    )),
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
                                            builder: (context) =>
                                                SettingsMenu(),
                                          ));
                                    }
                                  },
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(padding: EdgeInsets.only(left: 20),
                                        child: InternationalPhoneNumberInput(textFieldController: _controller,
                                    inputDecoration: InputDecoration(
                                          border: InputBorder.none),
                                    onInputChanged: (PhoneNumber number) {
                                        search = number.phoneNumber!;
                                    },
                                    selectorConfig: SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    initialValue: number,
                                  ),
                                      )
                                      // TextField(
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       search = value;
                                      //     });
                                      //   },
                                      //   decoration: InputDecoration(
                                      //       border: InputBorder.none,
                                      //       contentPadding:
                                      //           EdgeInsets.only(left: 10)),
                                      // ),
                                      ),
                                  IconButton(
                                      onPressed: () async {
                                        for (int i = 0;
                                            i <= docs!.length; i++) {
                                          if (search ==
                                              docs[i]['phonenumber']) {
                                            print('yes its exist');
                                            fireStore
                                                .collection(
                                                    'users/${userData?.uid}/listData')
                                                .doc(docs[i]['phonenumber'])
                                                .set({
                                              'phonenumber': docs[i]
                                                  ['phonenumber'],
                                              'uid': docs[i]['uid'],
                                              'username': docs[i]['username'],
                                              'url': docs[i]['url']
                                            });
                                            _controller.clear();
                                            break;
                                          } else {
                                            print('no its not exist');
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.search))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: docs2?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      foregroundImage: docs2?[index]['url'] != null ? NetworkImage(docs2?[index]['url']) : NetworkImage(''),
                                      backgroundColor: Colors.blueGrey,
                                      backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/chat-app-b9deb.appspot.com/o/userImage%2Fperson.jpg?alt=media&token=e9a704df-d953-4328-805f-577a66bd0b33'),
                                      radius: 27.5,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            docs2![index]['username'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(docs2[index]['phonenumber']),
                                          Text(''),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.80,
                                              child: Divider(
                                                color: Colors.grey,
                                                thickness: 1,
                                              ))
                                          //Container(decoration: BoxDecoration(color: Colors.red,border: Border(bottom: BorderSide(color: Colors.black,width: 3))),)
                                        ],
                                      ),
                                      onTap: () async {
                                        String user1 = userData!.uid;
                                        String user2 = docs2[index]['uid'];
                                        int adding1 = 0;
                                        int adding2 = 0;
                                        // final reverseData = await fireStore.collection('users').doc(user1).get();
                                        for (int i = 0; i < user1.length; i++) {
                                          adding1 =
                                              user1.codeUnitAt(i) + adding1;
                                          adding2 =
                                              user2.codeUnitAt(i) + adding2;
                                        }
                                        if (adding1 <= adding2) {
                                          chatRoomNumber = user1 + user2;
                                        } else {
                                          chatRoomNumber = user2 + user1;
                                        }
                                        getLastComment();
                                        // fireStore.collection('chats/user2/friendlist/').doc(userData?.phoneNumber).set({
                                        //   'nickname': reverseData['nickname'],
                                        //   'phonenumber': reverseData['phonenumber'],
                                        //   'uid': reverseData['uid'],
                                        //   'username': reverseData['username'],
                                        // });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  chatroom: chatRoomNumber),
                                            ));
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
