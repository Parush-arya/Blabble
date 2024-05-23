import 'package:intl/intl.dart';
import 'package:blabble/screens/chat_screen.dart';
import 'package:flutter/material.dart';

Widget ReturnWidget = SizedBox();

class MessageBubble extends StatefulWidget {
  Function? callback = () {};

  MessageBubble(
      {required this.sender,
      required this.text,
      required this.time,
      required this.callback});
  String? sender;
  String? text;
  DateTime? time;
  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool showButton = false;

  @override
  Widget build(BuildContext context) {
    String? f_sender = widget.sender!.substring(0, widget.sender!.indexOf('@'));
    DateTime timeNow = DateTime.now();
    var add = '';

    if (timeNow.year != widget.time!.year)
      add = DateFormat.yMMMMd().add_jm().format(widget.time!.toLocal());
    else if (timeNow.day == widget.time!.day &&
        timeNow.month == widget.time!.month)
      add = DateFormat.jm().format(widget.time!);
    else // if (timeNow.month != widget.time!.month)
      add = DateFormat.MMMd().add_jm().format(widget.time!);

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: widget.sender! == auth.currentUser!.email
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Visibility(
                  visible: showButton,
                  child: TextButton(
                      onPressed: () {
                        ReturnWidget = replyExtension();
                        widget.callback!(
                            ReturnWidget, true, widget.text, widget.sender);
                      },
                      child: Icon(
                        Icons.reply,
                        size: 50,
                      ))),
            ),
            Material(
              borderRadius: widget.sender! != auth.currentUser!.email
                  ? const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              elevation: 5,
              color: widget.sender! == auth.currentUser!.email
                  ? Colors.lightBlueAccent
                  : colorMap[widget.sender],
              child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    setState(() {
                      showButton = (showButton == true) ? false : true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                        crossAxisAlignment:
                            widget.sender! == auth.currentUser!.email
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.sender! == auth.currentUser!.email
                                ? ''
                                : f_sender,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${widget.text}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            add,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54),
                            textAlign: TextAlign.right,
                          ),
                        ]),
                  )),
            ),
          ]),
    );
  }

  Widget replyExtension() {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 5,
      color: widget.sender! == auth.currentUser!.email
          ? Colors.lightBlueAccent
          : colorMap[widget.sender],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: Column(
            crossAxisAlignment: widget.sender! == auth.currentUser!.email
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.sender! == auth.currentUser!.email
                    ? ''
                    : widget.sender!.substring(0, widget.sender!.indexOf('@')),
                style: const TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              Text(
                '${widget.text}',
                style: const TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.right,
              ),
              // Text(
              //   add!,
              //   style: const TextStyle(
              //       fontSize: 10, color: Colors.black45),
              //   textAlign: TextAlign.right,
              // ),
            ]),
      ),
    );
  }
}
