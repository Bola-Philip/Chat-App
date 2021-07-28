import 'dart:io';

import 'package:chat_app/Gui/FriendListScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInfo extends StatefulWidget {
  final String? phoneNumber;

  const ProfileInfo({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  String name = '';
  File ? pickedImage; //*****************************(dart.io)**********************************
  ImagePicker picker = ImagePicker();
  String url = '';

  void capture(ImageSource src) async {
    final pickedImageFile = await picker.pickImage(source: src,imageQuality: 50,maxWidth: 150);
    if (pickedImageFile != null) {
      setState(() {
       pickedImage = File(pickedImageFile.path);
      });
    }else{
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Profile info',
                style: TextStyle(color: Color(0xFF770000), fontSize: 25),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Please provide your name and an optional profile photo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),

              InkWell(
                customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(65)),
                splashColor: Color(0xFF770000),
                highlightColor: Colors.red,
                child: CircleAvatar(
                    foregroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
                    backgroundColor: Colors.grey.shade200,
                    radius: 70,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.blueGrey.shade300,
                      size: 60,
                    ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Card(
                        child: Column(
                          children: [
                            Text('Profile photo',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                FloatingActionButton(
                                  onPressed: () async{
                                    capture(ImageSource.gallery);
                                  },
                                  child: Icon(Icons.image),
                                ),
                                FloatingActionButton(
                                  onPressed: () async{
                                    capture(ImageSource.camera);
                                  },
                                  child: Icon(Icons.camera_alt),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    cursorColor: Color(0xFF770000),
                    cursorHeight: 30,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Type your name here',
                      hintStyle: TextStyle(fontSize: 19),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF770000))),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  )),
              SizedBox(height: MediaQuery.of(context).size.height*0.30,),
              Container(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () async{
                    if (name.trim().isNotEmpty && name.length >= 4) {

                      final ref = FirebaseStorage.instance.ref().child('userImage').child(FirebaseAuth.instance.currentUser!.uid+'.jpg');
                      await ref.putFile(pickedImage!);
                      url = await ref.getDownloadURL();

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'phonenumber': widget.phoneNumber,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'username': name,
                        'url': url
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendListScreen(),
                          ));
                    } else {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(bottom: 120, left: 40, right: 40),
                        padding: EdgeInsets.zero,
                        content: Text(
                          'You are required to enter your name before continuing(at least 4 characters)',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.white,
                      ));
                    }
                  },
                  color: Color(0xFF770000),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
