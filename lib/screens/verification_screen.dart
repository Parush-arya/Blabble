import 'package:blabble/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

// class VerificationScreen extends StatelessWidget {
//
//   VerificationScreen(){
//
//   }
//   static const id = 'Verification_screen';
//   @override
//   Widget build(BuildContext context) {
//     if (auth.currentUser!.emailVerified == true) {
//       Navigator.pushNamed(context, ChatScreen.id);
//       //Navigator.pop(context);
//     }
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//           image: AssetImage('images/chatbg.jpg'),
//           fit: BoxFit.cover,
//         )),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(20)),
//               padding: EdgeInsets.all(20),
//               child: const Text(
//                 'Verification link has been sent to your E-mail.',
//                 style: TextStyle(
//                     fontSize: 33, color: Colors.white, fontFamily: 'Pacifico'),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const SizedBox(
//               width: 80,
//               height: 80,
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class VerificationScreen extends StatefulWidget {
  static const id = 'Verification_screen';

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool spin = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void chechVerify() async {
    if (auth.currentUser!.emailVerified == true)
      Navigator.pushNamedAndRemoveUntil(
          context, ChatScreen.id, (route) => false);
    else {
      auth.currentUser!.sendEmailVerification();
      while (true) {
        await Future.delayed(Duration(seconds: 3));
        auth.currentUser!.refreshToken;
        if (auth.currentUser!.emailVerified == true)
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.id, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/chatbg.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20),
              child: const Text(
                'Verification link has been sent to your E-mail.',
                style: TextStyle(
                    fontSize: 33, color: Colors.white, fontFamily: 'Pacifico'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
