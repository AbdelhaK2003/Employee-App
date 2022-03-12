import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? Firstname;
  String? Lastname;
  String? nombre;
  String? email;
  String? password;
  String? image;
  String? job;
  String? Adress;
  String? description;
  String? username;
  int? price;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel(
      {this.uid,
      this.email,
      this.Firstname,
      this.Lastname,
      this.password,
      this.nombre,
      this.image,
      this.job,
      this.Adress,
      this.description,
      this.username,
      this.price});
  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("Utilisateur")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      Firstname: map['Firstname'],
      Lastname: map['Lastname'],
      Adress: map['Adress'],
      nombre: map['nombre'],
      password: map['password'],
      image: map['image'],
      job: map['job'],
      description: map['description'],
      username: map['username'],
      price: map['price'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'Firstname': Firstname,
      'Lastname': Lastname,
      'nombre': nombre,
      'password': password,
      'image': image,
      'job': job,
      'description': description,
      'Adress': Adress,
      'username': username,
      'price': price,
    };
  }

  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(email)
        .set(userInfoMap);
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = user!.email!.replaceAll("@gmail.com", "");
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("Utilisateur", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String usern) async {
    return await FirebaseFirestore.instance
        .collection("Utilisateur")
        .where("username", isEqualTo: usern)
        .get();
  }
}
