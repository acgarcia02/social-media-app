import 'package:flutter/material.dart';
import 'package:project_try/home.dart';
import 'helper.dart';
import "models/single_post_model.dart";

class EditPostScreen extends StatefulWidget {
  const EditPostScreen(
      {Key? key, required this.id, required this.text, required this.public})
      : super(key: key);

  final String id;
  final String text;
  final bool public;

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _text =
      TextEditingController(); //controller for getting old password
  bool isNotEmpty = false;
  final _formKey = GlobalKey<FormState>();

  Helper u = Helper();
  late Future<Post> myPost;
  late bool isPrivate;

  @override
  void initState() {
    super.initState();
    myPost = u.getSinglePost(widget.id);

    _text.text = widget.text;
    isPrivate = !widget.public;

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
    return Scaffold(
        appBar: AppBar(title: const Text("Edit post")),
        body: Column(
          children: [buildPostField(), buildSaveButton()],
        ));
  }

  // creaetes text field for editing content of post
  Widget buildPostField() {
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _text,
                style: const TextStyle(fontSize: 18),
                maxLines: 10,
                autofocus: true,
                scrollPadding: const EdgeInsets.all(20.0),
              ))),
      Row(children: [
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
          child: const Text('Save'),
          onPressed: isNotEmpty ? () => submit() : null),
    );
  }

  // calls updatePost() to update text of post and navigates back to homepage
  void submit() {
    snackBar("Saving changes...");
    myPost = u.updatePost(widget.id, _text.text, !isPrivate);
    myPost.then((value) {
      if (value.success == true) {
        snackBar("Changes saved.");
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen(selectedIndex: 0)));
      } else {
        snackBar(value.message!);
      }
    });
  }

  // shows snacbar containing status
  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    ));
  }
}
