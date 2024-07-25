import 'package:flutter/material.dart';
import 'package:project_try/friends_list.dart';
import 'package:project_try/menu.dart';
import 'package:project_try/new_post.dart';
import 'package:project_try/profile.dart';
import 'public_posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final int selectedIndex;
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const PostsScreen(),
    const FriendsListScreen(),
    const NewPostScreen(),
    const ProfileScreen(),
    const MenuScreen()
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'HelloWorld',
          style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: botNavBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  // creates the bar at the bottom containing icons for navigation to other pages
  Widget botNavBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.group_add, color: Colors.white),
            label: 'Find Friends'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, color: Colors.white),
            label: 'New Post'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.white),
            label: 'Profile'),
        BottomNavigationBarItem(
            icon: Icon(Icons.density_medium_rounded, color: Colors.white),
            label: 'Menu'),
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
