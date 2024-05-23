import 'package:blabble/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:blabble/screens/welcome_screen.dart';
import 'package:blabble/screens/login_screen.dart';
import 'package:blabble/screens/registration_screen.dart';
import 'package:blabble/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      auth.currentUser!.refreshToken;
      auth.currentUser!.reload();
    }
    return MaterialApp(
      home: auth.currentUser == null ? WelcomeScreen() : ChatScreen(),
      routes: {
        VerificationScreen.id: (context) => VerificationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
