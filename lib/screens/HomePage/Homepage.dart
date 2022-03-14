// ignore_for_file: prefer_const_constructors
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:login/Screens/ChatPage/ChatPage.dart';
import 'package:login/Screens/FavoritePage/FavoritePage.dart';
import 'package:login/Screens/OtherPages/AboutPage.dart';
import 'package:login/Screens/OtherPages/NotificationsPage.dart';
import 'package:login/Screens/OtherPages/SettingPage.dart';
import 'package:login/Screens/Profile/ProfilePage.dart';
import 'package:login/Widgets/NavDrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/HomePage/EmpScreen.dart';
import 'package:login/screens/SearchPage/SearchPage.dart';
import 'package:login/screens/sign_in/sign_in_screen.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/Homepage";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //This index is for identify pages
  int Sindex = 0;
  PageController _pageController = PageController(initialPage: 0);

  final screen = [
    EmpScreen(),
    ChatPage(),
    SearchPage(),
    FavoritePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.home,
        color: Colors.white,
      ),
      Icon(
        Icons.chat,
        color: Colors.white,
      ),
      Icon(
        Icons.search,
        color: Colors.white,
      ),
      Icon(
        Icons.favorite,
        color: Colors.white,
      ),
      Icon(
        Icons.person,
        color: Colors.white,
      ),
    ];

    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xEB1E1F69)),
        actions: [
          Padding(
              padding: const EdgeInsets.only(left: 3, right: 5),
              child: SizedBox(
                height: 30,
                width: 50,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.routeName);
                  },
                  child: Icon(Icons.search, color: Color(0xEB1E1F69)),
                ),
              ))
        ],
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            Sindex = newIndex;
          });
        },
        children: [EmpScreen(), ChatPage(), FavoritePage(), ProfilePage()],
      ),
      //The button navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xEB1E1F69),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Color(0xEB1E1F69),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
            backgroundColor: Color(0xEB1E1F69),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color(0xEB1E1F69),
          ),
        ],
        currentIndex: Sindex,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            // For switch the buttom navigation bar and pages at the same time

            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
      ),
    );
  }

  //The widget for items
  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          lt(4, "Profile", Icons.person_outline),
          lt(3, "Favorite", Icons.favorite_outline),
          lt(2, "Chat", Icons.chat_outlined),
          lt(6, "Notification", Icons.notifications_outlined),
          Divider(),
          lt(7, "Settings", Icons.settings_outlined),
          Divider(),
          lt(8, "About", Icons.info_rounded),
          lt(9, "Sign out", Icons.logout_outlined)
        ],
      ),
    );
  }

  //Function for all items in the side bar window
  Widget lt(int id, String ttl, IconData icon) {
    final auth = FirebaseAuth.instance;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        title: Text(ttl),
        leading: Icon(icon),
        iconColor: Color(Color(0xEB1E1F69).value),
        onTap: () {
          Navigator.pop(context);
          setState(() async {
            if (id == 1) {
              Sindex = 0;
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else if (id == 2) {
              Sindex = 1;
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else if (id == 3) {
              Sindex = 2;
              _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else if (id == 4) {
              Sindex = 3;
              _pageController.animateToPage(3,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else if (id == 6) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            } else if (id == 7) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            } else if (id == 8) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            } else if (id == 9) {
              /* final SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              
              finalemail = ""; */
              auth.signOut();

              Navigator.popAndPushNamed(context, SignInScreen.routeName);
            }
          });
        },
      ),
    );
  }
}
