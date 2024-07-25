import 'package:flutter/material.dart';
import 'helper.dart';
import 'models/user_model.dart';
import 'main.dart';
import 'update_pw.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Helper u = Helper();
  late Future<User> futureuser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildMenuList(),
    );
  }

  // creates list view of options in menu which are update password and logout
  Widget buildMenuList() {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        const Text(
          "Menu",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Divider(
          color: Colors.white,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              child: const Text(
                "Update password",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdatePwScreen()));
              },
            )),
        const Divider(
          color: Colors.white,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              child: const Text(
                "Log out",
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
              onTap: () {
                var success = u.logout();
                success.then((value) {
                  if (value == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Logging out..."),
                      duration: Duration(seconds: 2),
                    ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()));
                  }
                });
              },
            )),
        const Divider(
          color: Colors.white,
        ),
      ],
    );
  }
}
