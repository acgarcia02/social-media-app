import 'package:flutter/material.dart';
import 'models/friends_model.dart';
import 'models/post_model.dart';
import 'post_view.dart';
import 'models/user_model.dart';
import 'helper.dart';
import 'widgets/like_widget.dart';
import 'widgets/profile_widgets.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Helper u = Helper();
  late Future<Posts> userPost;
  late Future<User> userInfo;
  late Future<Friend> myFriend;

  @override
  void initState() {
    super.initState();
    //initialize posts by getting data from the network using getPostsFromUser()
    userPost = u.getPostsFromUser(widget.username);
    userInfo = u.fetchUser(widget.username);
    myFriend = u.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: profilePage(),
    );
  }

  //widget that builds itself and displays data when loaded
  Widget profilePage() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder(
            future: Future.wait([userPost, userInfo, myFriend]),
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
  Widget buildPage(postsInfo, userInfo, friend) {
    final following = friend.data.where((f) => f.username == widget.username);
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              buildProfileInfo(postsInfo),
              Row(
                children: [buildUserInfo(userInfo), followButton(following)],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        buildPosts(postsInfo, following)
      ],
    );
  }

  // contains the selected user's avatar, name, username, number of posts, an number of friends
  Widget buildProfileInfo(postsInfo) {
    return Row(
      children: [
        avatar(),
        numPosts(postsInfo.data.length),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  // creates the follow button for following the selected user
  Widget followButton(following) {
    if (following.isNotEmpty) {
      return Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(primary: Colors.transparent),
            child: const Text(
              "Following",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              var success = u.unfollow(widget.username);
              success.then((value) {
                if (value == true) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => widget));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(value.toString()),
                    duration: const Duration(milliseconds: 1500),
                  ));
                }
              });
            },
          ));
    } else {
      return Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  var success = u.follow(widget.username);
                  success.then((value) {
                    if (value == true) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => widget));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(value.toString()),
                        duration: const Duration(milliseconds: 1500),
                      ));
                    }
                  });
                });
              },
              child: const Text(
                "Follow",
                style: TextStyle(fontSize: 14),
              )));
    }
  }

  // creates a list view of the selected user's posts
  Widget buildPosts(posts, following) {
    if (following.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: posts.data?.length,
          itemBuilder: (context, int index) {
            return buildFriendPosts(posts, index);
          });
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: posts.data?.length,
          itemBuilder: (context, int index) {
            return posts.data[index].public
                ? buildFriendPosts(posts, index)
                : Container();
          });
    }
  }

  // gets the selected user's posts
  Widget buildFriendPosts(posts, index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPostScreen(
                        id: posts.data[index].id,
                        username: posts.data[index].username,
                        selectedIndex: 0,
                      )));
        },
        child: Card(
          // contains title of task, leading checkbox, and trailing delete and edit buttons
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -4.0),
                  leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg')),
                  title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      child: Text("@" + posts.data[index].username,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(205, 255, 255, 255)))),
                  subtitle: Text(
                    posts.data[index].text,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )),
            postReact(posts.data[index].id, posts.data[index].username,
                posts.data[index].public)
          ]),
        ));
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
                          selectedIndex: 0,
                        )));
          },
          icon: const Icon(Icons.comment),
        ),
      ],
    );
  }
}
