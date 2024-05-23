import 'package:blabble/screens/login_screen.dart';
import 'package:blabble/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blabble/buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomeS';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    {
      super.initState();
      controller = AnimationController(
          duration: const Duration(seconds: 1, microseconds: 250),
          vsync: this,
          upperBound: 1);
      animation =
          ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);
      controller.forward();
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: controller.value * 80.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      ColorizeAnimatedText(
                        colors: [
                          Colors.black,
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.deepOrangeAccent,
                        ],
                        'Blabble',
                        textStyle: const TextStyle(
                            fontFamily: 'Pacifico',
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      )
                    ]),
                  )
                ],
              ),
            ),
            const SizedBox(
                width: 200,
                child: Divider(
                  color: Colors.grey,
                )),
            SizedBox(
              height: 78.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.grey,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText('Chat it away.',
                        speed: Duration(milliseconds: 300)),
                  ],
                ),
              ),
              // child: Text(
              //   'Chat it away.',
              //   style: TextStyle(color: Colors.grey),
              // ),
            ),
            SizedBox(
              height: 30,
            ),
            MyRoundedButton(
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              text: 'Log In',
            ),
            MyRoundedButton(
                colour: Colors.blueAccent,
                text: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
          ],
        ),
      ),
    );
  }
}
