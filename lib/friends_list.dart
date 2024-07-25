import 'package:flutter/material.dart';
import 'helper.dart';
import 'models/friends_model.dart';
import 'profile_view.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  Helper u = Helper();
  late Future<Friend> myFriends;

  @override
  void initState() {
    super.initState();
    myFriends = u.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10.0),
            child: const Text(
              "Friends",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
        friendList()
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget friendList() {
    return FutureBuilder<Friend>(
        future: myFriends,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
                child:
                    CircularProgressIndicator(value: null, strokeWidth: 7.0));
          }
        });
  }

  // creates list view of the current user's friends
  Widget buildList(friends) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: friends.data.length,
      itemBuilder: (context, int index) {
        return Center(
            child: ListTile(
                title: Text(friends.data[index].firstName +
                    " " +
                    friends.data[index].lastName),
                subtitle: Text("@" + friends.data[index].username),
                leading: GestureDetector(
                  child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileViewScreen(
                                username: friends.data[index].username)));
                  },
                ),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(primary: Colors.transparent),
                  child: const Text(
                    "Following",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    var success = u.unfollow(friends.data[index].username);
                    success.then((value) {
                      if (value == true) {
                        setState(() {
                          myFriends = u.getFriends();
                        });
                      }
                    });
                  },
                )));
      },
    );
  }
}
