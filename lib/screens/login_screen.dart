import 'package:blabble/buttons.dart';
import 'package:blabble/constants.dart';
import 'package:blabble/screens/chat_screen.dart';
import 'package:blabble/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginS';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String pass;
  final contr = TextEditingController();
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
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: contr,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      pass = value;
                    },
                    decoration:
                        kTextDeco.copyWith(hintText: 'Enter your password.')),
              ),
              const SizedBox(
                height: 24.0,
              ),
              MyRoundedButton(
                  colour: Colors.lightBlueAccent,
                  text: 'Log In',
                  onPressed: () async {
                    setState(() {
                      spin = true;
                    });
                    try {
                      final newUser = await auth.signInWithEmailAndPassword(
                          email: email, password: pass);
                      contr.clear();
                      pass = "";
                      email = "";
                      setState(() {
                        spin = false;
                      });
                      if (newUser != null) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ChatScreen.id, (route) {
                          return false;
                        });
                      }
                    } catch (e) {
                      contr.clear();
                      setState(() {
                        spin = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          e.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 4),
                      ));
                    }
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
