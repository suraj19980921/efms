import 'package:flutter/material.dart';
import 'package:efms/HomeScreen/HomePage.dart';
import 'package:efms/HomeScreen/ProfileScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  DateTime? lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.greenAccent.shade100,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.supervised_user_circle),
            icon: Icon(Icons.supervised_user_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: IndexedStack(
          index: currentPageIndex,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const HomePage(),
            ),
            Container(
              alignment: Alignment.center,
              child: const ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (lastBackPressedTime == null ||
        DateTime.now().difference(lastBackPressedTime!) > Duration(seconds: 2)) {
      lastBackPressedTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }
}
