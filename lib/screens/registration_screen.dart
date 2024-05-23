import 'package:blabble/buttons.dart';
import 'package:blabble/constants.dart';
import 'package:blabble/screens/chat_screen.dart';
import 'package:blabble/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registerS';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String pass;
  late String confirm_pass;
  bool spin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kTextDeco.copyWith(hintText: 'Enter your email')),
              ),
              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      pass = value;
                    },
                    decoration:
                        kTextDeco.copyWith(hintText: 'Enter your password')),
              ),
              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      confirm_pass = value;
                    },
                    decoration:
                        kTextDeco.copyWith(hintText: 'Confirm your password')),
              ),
              const SizedBox(
                height: 24.0,
              ),
              MyRoundedButton(
                  colour: Colors.blueAccent,
                  text: 'Register',
                  onPressed: () async {
                    if (pass == confirm_pass) {
                      setState(() {
                        spin = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: pass);
                        pass = "";
                        email = "";
                        setState(() {
                          spin = false;
                        });
                        if (newUser != null)
                          Navigator.pushNamed(context, ChatScreen.id);
                      } catch (e) {
                        setState(() {
                          spin = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 4),
                        ));
                      }
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Confirm Password Thikse Daal be nalayak!",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 4),
                      ));
                  }),
              const SizedBox(
                height: 25.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
