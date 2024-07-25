import 'package:flutter/material.dart';
import 'helper.dart';
import "models/single_post_model.dart";

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _text =
      TextEditingController(); //controller for getting old password
  bool isNotEmpty = false;
  bool isPrivate = false;

  final _formKey = GlobalKey<FormState>();

  Helper u = Helper();
  late Future<Post> myPost;

  @override
  void initState() {
    super.initState();
    //initialize todo list by getting data from the network using fetchTask()
    _text.addListener(() {
      setState(() {
        isNotEmpty = _text.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buildPostField(), buildSaveButton()],
    );
  }

  // contains the text field for the content of post and checkbox for privacy
  Widget buildPostField() {
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          // creates textield for the content of the post
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _text,
                decoration: const InputDecoration.collapsed(
                  hintText: "What's happening?",
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 10,
                autofocus: true,
                scrollPadding: const EdgeInsets.all(20.0),
              ))),
      Row(children: [
        // creates checkbox for selecting privacy of tweet
        Checkbox(
            value: isPrivate,
            onChanged: (value) {
              setState(() {
                isPrivate = !isPrivate;
              });
            }),
        const Text("Private")
      ])
    ]));
  }

  // creates save button
  Widget buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: ElevatedButton(
          child: const Text('Post'),
          onPressed: isNotEmpty ? () => submit() : null),
    );
  }

  // sends post to server through newPost()
  void submit() {
    snackBar("Sending post...");
    myPost = u.newPost(_text.text, !isPrivate);
    myPost.then((value) {
      if (value.success == true) {
        snackBar("Post sent.");
        setState(() {
          isPrivate = false;
          _text.clear();
        });
      } else {
        snackBar(value.message!);
      }
    });
  }

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    ));
  }
}
