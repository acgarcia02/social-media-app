import 'package:flutter/material.dart';
import 'models/friends_model.dart';
import 'models/post_model.dart';
import 'post_view.dart';
import 'update_profile.dart';
import 'models/user_model.dart';
import 'helper.dart';
import 'widgets/like_widget.dart';
import 'widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Helper u = Helper();
  late Future<Posts> myPosts;
  late Future<User> myProfile;
  late Future<Friend> myFriend;

  @override
  void initState() {
    super.initState();
    //initialize posts of the logged in user by getting data from the network using getUserPosts()
    myPosts = u.getUserPosts();
    myProfile = u.fetchCurrent();
    myFriend = u.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: profilePage());
  }

  //widget that builds itself and displays data when loaded
  Widget profilePage() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder(
            future: Future.wait([myPosts, myFriend, myProfile]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return buildPage(
                    snapshot.data![0], snapshot.data![1], snapshot.data![2]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        value: null, strokeWidth: 7.0));
              }
            }));
  }

  // creates list view of the user's profile
  Widget buildPage(postsInfo, friendsInfo, userInfo) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              buildProfileInfo(postsInfo, friendsInfo),
              Row(
                children: [buildUserInfo(userInfo), editButton()],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        buildMyPosts(postsInfo)
      ],
    );
  }

  // contains the current user's avatar, name, username, number of posts, an number of friends
  Widget buildProfileInfo(postsInfo, friendsInfo) {
    return Row(
      children: [
        avatar(),
        numPosts(postsInfo.data.length),
        Container(
            padding: const EdgeInsets.only(left: 15.0, right: 30.0),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        friendsInfo.data.length.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text("Friends", style: TextStyle(fontSize: 14))
                    ],
                  ),
                )
              ],
            ))
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  // creates the edit button for updating profile
  Widget editButton() {
    return Container(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdateUserScreen()))
                .then((value) {
              setState(() {
                myProfile = u.fetchCurrent();
              });
            });
          },
          child: const Text(
            "Edit Profile",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          style: OutlinedButton.styleFrom(
            primary: Colors.transparent,
          ),
        ));
  }

  // creates a list view of the current user's own posts
  Widget buildMyPosts(posts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: posts.data?.length,
      itemBuilder: (context, int index) {
        return Padding(
            padding: const EdgeInsets.all(0),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullPostScreen(
                                id: posts.data[index].id,
                                username: posts.data[index].username,
                                selectedIndex: 3,
                              )));
                },
                child: Card(
                  // contains title of task, leading checkbox, and trailing delete and edit buttons
                  child: Column(children: [
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -4.0),
                      leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg')),
                      title: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text("@" + posts.data[index].username,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(205, 255, 255, 255)))),
                      subtitle: Text(
                        posts.data[index].text,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    postReact(posts.data[index].id, posts.data[index].username,
                        posts.data[index].public)
                  ]),
                )));
      },
    );
  }

  Widget postReact(String id, String username, bool public) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const FavoriteWidget(),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullPostScreen(
                          id: id,
                          username: username,
                          selectedIndex: 3,
                        )));
          },
          icon: const Icon(Icons.comment),
        ),
      ],
    );
  }
}
