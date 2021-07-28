import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String userName = '';

  Future getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      final data = value.data()?['username'];
      setState(() {
        userName = data;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF770000),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          InkWell(
            child: Container(
                margin: EdgeInsets.only(left: 20),
                height: 100,
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.grey.shade300,
                      radius: 40,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 110,
                        ),
                        Container(margin: EdgeInsets.only(top: 20),child: Text(userName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),)),
                      ],
                    )
                  ],
                )),onTap: () {
                },
          ),
          Divider(
            color: Colors.grey,
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text('Log out')
              ],
            ),
          )
        ],
      ),
    );
  }
}
