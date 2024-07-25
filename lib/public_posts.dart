import 'package:flutter/material.dart';
import 'package:project_try/home.dart';
import 'package:project_try/models/post_model.dart';
import 'package:project_try/models/user_model.dart';
import 'package:project_try/post_view.dart';
import 'package:project_try/profile_view.dart';
import 'helper.dart';
import 'widgets/like_widget.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Helper u = Helper();
  late Future<Posts> publicPosts;
  late Future<User> myProfile;

  @override
  void initState() {
    super.initState();
    //initialize posts by getting data from the network using getPosts()
    publicPosts = u.getPosts();
    myProfile = u.fetchCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[postList(), navPage()],
    );
  }

  //widget that builds itself and displays data when loaded
  Widget postList() {
    return Positioned(
        child: FutureBuilder(
            future: Future.wait([publicPosts, myProfile]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return buildText(snapshot.data![0], snapshot.data![1]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        value: null, strokeWidth: 7.0));
              }
            }));
  }

  //widget that returns listview of public posts
  Widget buildText(posts, userInfo) {
    return Scaffold(
        body: ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: posts.data?.length,
      itemBuilder: (context, int index) {
        return posts.data[index].public
            ? InkWell(
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
                splashColor: Colors.teal,
                child: Card(
                  // contains title of task, leading checkbox, and trailing delete and edit buttons
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4.0),
                          leading: GestureDetector(
                              child: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg'),
                              ),
                              onTap: posts.data[index].username ==
                                      userInfo.data.username
                                  ? () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(
                                                    selectedIndex: 3,
                                                  )));
                                    }
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileViewScreen(
                                                    username: posts
                                                        .data[index].username,
                                                  )));
                                    }),
                          title: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, top: 5.0),
                              child: Text("@" + posts.data[index].username,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(205, 255, 255, 255)))),
                          subtitle: Text(
                            posts.data[index].text,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        )),
                    postReact(posts.data[index].id, posts.data[index].username,
                        posts.data[index].public)
                  ]),
                ))
            : Container();
      },
    ));
  }

  // creates navigation left and right navigation buttons to see posts in next page
  Widget navPage() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    publicPosts = u.getPrev();
                  });
                },
                child: const Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                ),
                heroTag: null,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    publicPosts = u.getNext();
                  });
                },
                child: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                heroTag: null,
              )),
        )
      ],
    );
  }

  // creates reaction bar containing heart and comment icons
  Widget postReact(String id, String username, bool public) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const FavoriteWidget(),
        IconButton(
          onPressed: public
              ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullPostScreen(
                                id: id,
                                username: username,
                                selectedIndex: 0,
                              )));
                }
              : null,
          icon: const Icon(Icons.comment),
        ),
      ],
    );
  }
}
