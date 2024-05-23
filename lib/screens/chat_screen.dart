import 'package:blabble/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blabble/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:blabble/MessageBubble.dart';
import 'package:blabble/ReplyMessageBubble.dart';

final _cloud = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

Map<String, Color> colorMap = {};
List<Color> colours = [
  Colors.purple,
  Colors.teal,
  Colors.yellow.shade800,
  Colors.purpleAccent,
  Colors.cyan,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.blueGrey
];

class ChatScreen extends StatefulWidget {
  static const String id = 'chatS';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool replyVisible = false;
  String? replySender = null;
  String? replyText = null;
  late User user;
  String msg = '';
  List<Widget> messagesWidgets = [];

  Widget returnWidget = const SizedBox();
  final contr = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    auth.currentUser!.refreshToken;
    auth.currentUser!.reload();
    checkVerify();
  }

  void checkVerify() async {
    if (auth.currentUser != null && auth.currentUser!.emailVerified == false) {
      auth.currentUser!.sendEmailVerification();
    }

    while (!(auth.currentUser == null)) {
      auth.currentUser!.refreshToken;
      auth.currentUser!.reload();
      print(auth.currentUser!.emailVerified.toString() +
          auth.currentUser!.email.toString());
      if (auth.currentUser!.emailVerified == true) {
        setState(() {});
        break;
      }
      await Future.delayed(const Duration(seconds: 3));
    }
    getMessageStream();
  }

  void callback(
      Widget Received, bool rec, String replyText, String replySender) {
    this.replySender = replySender;
    this.replyText = replyText;
    setState(() {
      this.returnWidget = Received;
      this.replyVisible = rec;
    });
  }

  void getCurrentUser() async {
    try {
      final newUser = auth.currentUser;
      if (newUser != null) {
        user = newUser;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessageStream() async {
    var snaps = _cloud.collection('messages').orderBy('time').snapshots();

    await for (var snap in snaps) {
      final message = snap.docChanges;
      for (var msg in message) {
        bool reply = true;
        replySender = null;
        replyText = null;
        final text = msg.doc.get('text');
        final sender = msg.doc.get('sender');
        var TS = msg.doc.get('time');
        try {
          replySender = msg.doc.get('replySender');
          replyText = msg.doc.get('replyText');
        } catch (e) {
          print(e);
          reply = false;
        }

        DateTime DT = DateTime.parse(TS.toDate().toString());
        if (colorMap[sender] == null) {
          colorMap[sender] = colours[Random().nextInt(colours.length)];
        }

        if (reply == false) {
          messagesWidgets.add(MessageBubble(
            sender: sender,
            text: text,
            time: DT,
            callback: this.callback,
          ));
        } else {
          messagesWidgets.add(ReplyMessageBubble(
              sender: sender,
              text: text,
              time: DT,
              replySender: replySender,
              replyText: replyText,
              callback: this.callback));
        }
      }

      setState(() {
        messagesWidgets = messagesWidgets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser!.emailVerified == true) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // appBar: AppBar(
          //   leading: null,
          //   actions: <Widget>[
          //     IconButton(
          //         icon: const Icon(Icons.close),
          //         onPressed: () {
          //           auth.signOut();
          //           Navigator.pop(context);
          //         }),
          //   ],
          //   //title: const Text('⚡️Chat'),
          //   title: const Text('💬 Chat'),
          //   backgroundColor: Colors.blueAccent,
          // ),
          floatingActionButton: Container(
            width: 40,
            height: 40,
            child: FloatingActionButton(
                backgroundColor: Colors.black38,
                onPressed: () {
                  auth.signOut();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: const Icon(
                  Icons.close,
                )),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

          body: Container(
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('images/chatbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
                      itemCount: messagesWidgets.length,
                      itemBuilder: (BuildContext context, int Itemindex) {
                        return messagesWidgets[messagesWidgets.length -
                            1 -
                            Itemindex]; // return your widget
                      }),
                ),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Column(
                    children: [
                      Visibility(
                        visible: replyVisible,
                        child: Container(
                          decoration:
                              const BoxDecoration(color: Colors.black45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(child: returnWidget),
                              Container(
                                decoration: BoxDecoration(
                                    //color: Colors.white10,
                                    borderRadius: BorderRadius.circular(40)),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      replyVisible = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_sharp,
                                    size: 35,
                                    color: Colors.black54,
                                  ),
                                  style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                msg = value;
                              },
                              controller: contr,
                              decoration: kMessageTextFieldDecoration.copyWith(
                                  filled: true, fillColor: Colors.white),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(0)),
                            child: TextButton(
                                onPressed: () {
                                  contr.clear();
                                  if (msg != '' && msg != null) {
                                    if (replyVisible == false) {
                                      _cloud.collection('messages').add({
                                        'text': msg,
                                        'sender': auth.currentUser!.email,
                                        'time': DateTime.now()
                                      });
                                    } else {
                                      _cloud.collection('messages').add({
                                        'text': msg,
                                        'sender': auth.currentUser!.email,
                                        'time': DateTime.now(),
                                        'replySender': replySender,
                                        'replyText': replyText
                                      });
                                    }
                                  }
                                  setState(() {
                                    replyVisible = false;
                                  });
                                },
                                child: const Icon(Icons.arrow_forward_ios)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.home,
              size: 30,
            ),
            onPressed: () {
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, WelcomeScreen.id, (route) => false);
            },
          ),
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Checking Verification status.\nVerification link has been sent to your E-mail.\n(check spam!)',
                    style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontFamily: 'Pacifico'),
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
        ),
      );
    }
  }
}

// class MessageBubble extends StatelessWidget {
//   MessageBubble({required this.sender, required this.text, this.time});
//   String? sender;
//   String? text;
//   DateTime? time;
//   bool showButton = false;
//
//   @override
//   Widget build(BuildContext context) {
//     String? f_sender = sender!.substring(0, sender!.indexOf('@'));
//     DateTime timeNow = DateTime.now();
//     var add;
//
//     if (timeNow.year != time!.year)
//       add = DateFormat.yMMMMd().add_jm().format(time!.toLocal());
//     else if (timeNow.day == time!.day && timeNow.month == time!.month)
//       add = DateFormat.jm().format(time!);
//     else if (timeNow.month != time!.month)
//       add = DateFormat.MMMd().add_jm().format(time!);
//
//     return Padding(
//       padding: EdgeInsets.all(10),
//       child: Column(
//           crossAxisAlignment: sender! == auth.currentUser!.email
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               child: Visibility(
//                   visible: showButton,
//                   child: TextButton(
//                       onPressed: () {},
//                       child: Icon(
//                         Icons.reply,
//                         size: 50,
//                       ))),
//             ),
//             Material(
//                 borderRadius: sender! != auth.currentUser!.email
//                     ? const BorderRadius.only(
//                         topRight: Radius.circular(30),
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30))
//                     : const BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30)),
//                 elevation: 5,
//                 color: sender! == auth.currentUser!.email
//                     ? Colors.lightBlueAccent
//                     : colorMap[sender],
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//                   child: GestureDetector(
//                     onLongPress: () {
//                       showButton = true;
//                     },
//                     child: Column(
//                         crossAxisAlignment: sender! == auth.currentUser!.email
//                             ? CrossAxisAlignment.end
//                             : CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             sender! == auth.currentUser!.email ? '' : f_sender,
//                             style: const TextStyle(
//                                 fontSize: 13, color: Colors.black),
//                             textAlign: TextAlign.left,
//                           ),
//                           Text(
//                             '$text',
//                             style: const TextStyle(
//                                 fontSize: 15, color: Colors.white),
//                             textAlign: TextAlign.right,
//                           ),
//                           Text(
//                             add!,
//                             style: const TextStyle(
//                                 fontSize: 10, color: Colors.black45),
//                             textAlign: TextAlign.right,
//                           ),
//                         ]),
//                   ),
//                 )),
//           ]),
//     );
//   }
// }

// StreamBuilder<QuerySnapshot>(
//     stream: _cloud.collection('messages').snapshots(),
//     builder: (context, snapshot) {

//       if (!snapshot.hasData) {
//         return const Center(
//           child: CircularProgressIndicator(
//             color: Colors.lightBlueAccent,
//           ),
//         );
//       }
//       final messages = snapshot.data!.docChanges;
//
//       for (var msg in messages) {
//         final text = msg.doc.get('text');
//         final sender = msg.doc.get('sender');
//         messagesWidgets.add(Text('$text from $sender'));
//       }
//       print("EXECUTED");
//
//       return Expanded(
//           child: ListView(
//         children: messagesWidgets,
//       ));
//     }),

// class MessageBubble extends StatelessWidget {
//   MessageBubble({required this.sender, required this.text});
//   String? sender;
//   String? text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10),
//       child:
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
//         Text(
//           sender!,
//           style: TextStyle(fontSize: 12, color: Colors.black54),
//         ),
//         Material(
//             borderRadius: BorderRadius.circular(30),
//             elevation: 5,
//             color: Colors.lightBlueAccent,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 '$text',
//                 style: TextStyle(fontSize: 15, color: Colors.white),
//               ),
//             )),
//       ]),
//     );
//   }
// }
