import 'package:flutter/material.dart';
import 'package:project_try/edit_post.dart';
import 'package:project_try/home.dart';
import 'package:project_try/models/comments_model.dart';
import 'models/single_comment_model.dart';
import 'profile_view.dart';
import 'widgets/like_widget.dart';
import 'widgets/profile_widgets.dart';
import 'helper.dart';
import "models/single_post_model.dart";
import 'models/user_model.dart';

class FullPostScreen extends StatefulWidget {
  const FullPostScreen(
      {Key? key,
      required this.id,
      required this.username,
      required this.selectedIndex})
      : super(key: key);

  final String id;
  final String username;
  final int selectedIndex;

  @override
  _FullPostScreenState createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  Helper u = Helper();
  late Future<Post> selectedPost;
  late Future<User> selectedUser;
  late Future<User> myUser;
  late Future<Comments> postComments;
  late Future<Comment> newComment;

  bool isNotEmpty = false;
  final TextEditingController _comment = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedPost = u.getSinglePost(widget.id);
    selectedUser = u.fetchUser(widget.username);
    myUser = u.fetchCurrent();
    postComments = u.getComments(widget.id);

    _comment.addListener(() {
      setState(() {
        isNotEmpty = _comment.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
        ),
      ),
      body: postPage(),
    );
  }

  // creates view of single selected post
  Widget postPage() {
    return Container(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder(
            future:
                Future.wait([selectedPost, selectedUser, myUser, postComments]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return buildPost(snapshot.data![0], snapshot.data![1],
                    snapshot.data![2], snapshot.data![3]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        value: null, strokeWidth: 7.0));
              }
            }));
  }

  // creates list view of the details of the user, content of the post, reaction bar, comment text field, and list of comments for post
  Widget buildPost(selectedPost, selectedUser, myUser, postComments) {
    return ListView(
      children: [
        Column(
          children: [
            ListTile(
              leading: GestureDetector(
                  child: avatar(),
                  onTap: selectedPost.data.username == myUser.data.username
                      ? () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen(
                                        selectedIndex: 3,
                                      )));
                        }
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileViewScreen(
                                        username: selectedPost.data.username,
                                      )));
                        }),
              title: Text(selectedUser.data.firstName +
                  " " +
                  selectedUser.data.lastName),
              subtitle: Text("@" + selectedUser.data.username),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 22.0),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedPost.data.text,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),
            selectedPost.data.username == myUser.data.username
                ? postReactExtended(selectedPost, myUser)
                : postReact(),
            const Divider(),
            buildCommentField(),
            buildCommentSection(postComments, myUser)
          ],
        )
      ],
    );
  }

  // creates reaction bar if the post is the current user's post
  Widget postReactExtended(selectedPost, myUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const FavoriteWidget(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.comment),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPostScreen(
                          id: widget.id,
                          text: selectedPost.data.text,
                          public: selectedPost.data.public,
                        )));
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Deleting post..."),
              duration: Duration(seconds: 2),
            ));
            var success = u.deletePost(widget.id);
            success.then((value) {
              if (value == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Post deleted."),
                  duration: Duration(seconds: 2),
                ));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              selectedIndex: widget.selectedIndex,
                            )));
              }
            });
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  // creates text field for comments
  Widget buildCommentField() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _comment,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: "Write a comment",
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    color: isNotEmpty ? Colors.teal : Colors.grey,
                    onPressed: isNotEmpty ? () => send() : null),
              ),
            ),
          ),
        ));
  }

  // sends comment to server through newComment() which has the post id and comment content as parameters
  void send() {
    snackBar("Posting comment...");
    newComment = u.newComment(widget.id, _comment.text);
    newComment.then((value) {
      if (value.success == true) {
        snackBar("Comment posted.");
        _comment.clear();
        setState(() {
          postComments = u.getComments(widget.id);
        });
      } else {
        snackBar(value.message!);
      }
    });
  }

  // creates a list view of all the comments for the selected post
  Widget buildCommentSection(postComments, myUser) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: postComments.data.length,
      itemBuilder: (context, int index) {
        return Center(
          child: ListTile(
            leading: GestureDetector(
                child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-11.jpg')),
                onTap: postComments.data[index].username == myUser.data.username
                    ? () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                      selectedIndex: 3,
                                    )));
                      }
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileViewScreen(
                                      username:
                                          postComments.data[index].username,
                                    )));
                      }),
            title: Text("@" + postComments.data[index].username,
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(205, 255, 255, 255))),
            subtitle: Text(postComments.data[index].text,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            trailing: postComments.data[index].username == myUser.data.username
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      snackBar("Deleting commment...");
                      var success = u.deleteComment(
                          widget.id, postComments.data[index].id);
                      success.then((value) {
                        if (value == true) {
                          snackBar("Comment deleted.");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => widget));
                        }
                      });
                    },
                  )
                : null,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  // creates reaction bar if the post is created by another user
  Widget postReact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        FavoriteWidget(),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.comment),
        ),
      ],
    );
  }

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    ));
  }
}
