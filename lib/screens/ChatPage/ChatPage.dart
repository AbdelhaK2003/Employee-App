import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Chat_Screen/chatscreen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  static String routeName = "/Chat_page";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isSearching = true;
  String myName = '', myProfilePic = '', myUserName = '', myEmail = '';
  Stream<QuerySnapshot>? usersStream, chatRoomsStream;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController searchUsernameEditingController =
      TextEditingController();
  UserModel loggedInUser = UserModel();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await UserModel()
        .getUserByUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ChatRoomListTile(
                      ds["lastMessage"],
                      ds.id,
                      user!.email!.replaceAll("@gmail.com", ""),
                      ds["lastMessageSendTs"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget searchListUserTile(
      {String? profileUrl, fname, lname, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(
            user!.email!.replaceAll("@gmail.com", ""), username);
        Map<String, dynamic> chatRoomInfoMap = {
          "Utilisateur": [user!.email!.replaceAll("@gmail.com", ""), username]
        };
        UserModel().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(username, fname, lname, profileUrl!)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl!,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(fname + " " + lname), Text(email)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return searchListUserTile(
                      profileUrl: ds["image"],
                      fname: ds["Firstname"],
                      lname: ds["Lastname"],
                      email: ds["email"],
                      username: ds["username"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await UserModel().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  getMyInfoFromSharedPreference() async {
    FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    });
    myName = loggedInUser.Firstname.toString();
    myProfilePic = loggedInUser.image.toString();
    myUserName = loggedInUser.username.toString();
    myEmail = loggedInUser.email.toString();
    setState(() {});
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Messages",
                  style: TextStyle(
                      color: Color.fromARGB(235, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          searchUsernameEditingController.text = "";
                          setState(() {});
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.arrow_back)),
                      )
                    : Container(),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList(),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  Timestamp time;
  ChatRoomListTile(
      this.lastMessage, this.chatRoomId, this.myUsername, this.time);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", fname = "", lname = "", username = "";
  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await UserModel().getUserInfo(username);
    fname = "${querySnapshot.docs[0]["Firstname"]}";
    lname = "${querySnapshot.docs[0]["Lastname"]}";
    profilePicUrl = "${querySnapshot.docs[0]["image"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(username, fname, lname, profilePicUrl)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    profilePicUrl,
                    height: 55,
                    width: 55,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fname + " " + lname,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    Row(children: [
                      SizedBox(height: 3),
                      Text(widget.lastMessage, style: TextStyle(fontSize: 16)),
                      Text(
                        " . " +
                            widget.time.toDate().day.toString() +
                            "/" +
                            widget.time.toDate().month.toString() +
                            " " +
                            widget.time.toDate().hour.toString() +
                            ":" +
                            widget.time.toDate().minute.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ])
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";

  //save data
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUseremail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, getUserProfile);
  }

  // get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}
