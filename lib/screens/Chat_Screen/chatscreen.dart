import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/model.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, fname, lname, imageurl;
  ChatScreen(this.chatWithUsername, this.fname, this.lname, this.imageurl);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? chatRoomId, messageId = "";
  User? user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot>? messageStream;
  String? myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEdittingController = TextEditingController();
  UserModel DatabaseMethods = new UserModel();
  getMyInfoFromSharedPreference() async {
    chatRoomId = getChatRoomIdByUsernames(
        widget.chatWithUsername, user!.email!.replaceAll("@gmail.com", ""));
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": user!.email!.replaceAll("@gmail.com", ""),
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      UserModel()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": user!.email!.replaceAll("@gmail.com", "")
        };

        UserModel().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe
                    ? Color(0xEB1E1F69)
                    : Color.fromARGB(255, 92, 90, 89),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return chatMessageTile(
                      ds["message"],
                      user!.email!.replaceAll("@gmail.com", "") ==
                          ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await UserModel().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 255, 255, 255), //change your color here
          ),
          title: Container(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.imageurl,
                    height: 35,
                    width: 35,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(widget.fname + " " + widget.lname),
              ],
            ),
          ),
          backgroundColor: Color.fromARGB(235, 30, 31, 105)),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: messageTextEdittingController,
                      onChanged: (value) {
                        addMessage(false);
                      },
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type a message",
                        hintStyle: TextStyle(
                            color:
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.6)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(235, 30, 31, 105)),
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                    )),
                    Text(
                      "    ",
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xEB1E1F69),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
