import 'package:chat_app/Gui/ProfileInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget {
  final String? phoneNumber;

  OTPScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode='';


  Future phoneAuth() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) async {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          verificationCode = verificationId ;
        });
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneAuth();
    _listenOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'Verify ${widget.phoneNumber}',
            style: TextStyle(color: Color(0xFF770000), fontSize: 25),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Waiting to automatically detect an SMS sent to ${widget.phoneNumber}.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                    colorBuilder: FixedColorBuilder(Color(0xFF770000))),
                codeLength: 6,
                onCodeChanged: (pin) async{
                  if (pin!.trim().isNotEmpty && pin.length == 6) {
                    try {
                      print('////////////////////////////////////////////////////////////////////////');
                      print(verificationCode);
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileInfo(phoneNumber: widget.phoneNumber,),
                              ));
                        }
                      });
                    } catch (e) {
                      print('/////////////////////////////////////////////////////////////');
                      print(e);
                      //FocusScope.of(context).unfocus();
                      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid OTP')));
                    }
                  //   isDisabled = false;
                  // } else {
                  //   isDisabled = true;
                   }
                },

              )


              // TextField(
              //   style: TextStyle(fontSize: 20),
              //   cursorColor: Color(0xFF770000),
              //   cursorHeight: 30,
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.only(left: 12.5),
              //       hintText: '--- ---',
              //       hintStyle: TextStyle(fontSize: 40, color: Colors.grey),
              //       focusedBorder: UnderlineInputBorder(
              //           borderSide: BorderSide(color: Color(0xFF770000)))),
              //   inputFormatters: [LengthLimitingTextInputFormatter(6)],
              //   onChanged: (value) {
              //     setState(() {
              //       sms = value;
              //     });
              //     if (sms.trim().isNotEmpty)
              //       isDisabled = false;
              //     else
              //       isDisabled = true;
              //   },
              // ),
              ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Carrier SMS charges may apply',
            style: TextStyle(color: Colors.grey, fontSize: 17),
          ),
          // MaterialButton(
          //   onPressed: sms.trim().isEmpty || sms.length < 6
          //       ? null
          //       : () {
          //     //_authenticate.phoneAuth(phoneNumber: widget.phoneNumber);
          //           FirebaseFirestore.instance
          //               .collection('users')
          //               .doc(FirebaseAuth.instance.currentUser?.uid)
          //               .set({
          //             'nickname': '',
          //             'phonenumber': widget.phoneNumber,
          //             'uid': FirebaseAuth.instance.currentUser?.uid,
          //             'username': '',
          //           });
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => FriendListScreen(),
          //               ));
          //         },
          //   color: isDisabled ? Colors.grey : Color(0xFF770000),
          //   child: Text('Verify',
          //       style: isDisabled
          //           ? TextStyle(color: Colors.black)
          //           : TextStyle(color: Colors.white)),
          // )
        ],
      ),
    );
  }
}

void _listenOtp() async {
  await SmsAutoFill().listenForCode;
}
