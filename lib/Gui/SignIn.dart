import 'package:chat_app/Gui/OTPScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text('Enter your phone number',
                    style: TextStyle(color: Color(0xFF770000), fontSize: 25),),
                  SizedBox(height: 30,),
                  Text('Chat-App will send an SMS message to verify your phone number.',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),SizedBox(height: 25,),
                  Container(margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.90,
                      decoration: BoxDecoration(color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: InternationalPhoneNumberInput(
                        inputDecoration: InputDecoration(
                            border: InputBorder.none),
                        onInputChanged: (PhoneNumber number) {
                          phoneNumber = number.phoneNumber;
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ), initialValue: number,
                      )),
                  Expanded(
                    child: Container(alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                OTPScreen(phoneNumber: phoneNumber,),));
                        }, color: Color(0xFF770000),child: Text('Next',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  )
                ]
                ,
              ),
            )
        )
    );
  }
}