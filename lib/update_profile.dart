import 'package:flutter/material.dart';
import 'helper.dart';
import 'models/user_model.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({Key? key}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  TextEditingController _fname =
      TextEditingController(); //controller for getting new first name
  TextEditingController _lname =
      TextEditingController(); //controller for getting new last name
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; //used for validation of input

  Helper u = Helper();
  late Future<User> futureuser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
        ),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildTextField("First Name", _fname),
                  buildTextField("Last Name", _lname),
                  buildSaveButton()
                ],
              ),
            )
          ],
        ));
  }

  //creates textfield widget which accepts label and controller as parameter
  Widget buildTextField(String label, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            errorText: _validate ? 'Value can\'t be empty' : null),
        validator: (value) {
          //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return '$label cannot be blank.';
          }
          return null;
        },
      ),
    );
  }

  // creates save button
  Widget buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            snackBar(
              "Saving changes...",
            );
            if (_formKey.currentState!.validate()) {
              futureuser = u.updateUser("", "", _fname.text, _lname.text);
              futureuser.then((value) {
                if (value.success == true) {
                  snackBar("Changes saved.");
                  Navigator.pop(context);
                } else {
                  snackBar(value.message!);
                }
              });
            }
          }),
    );
  }

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    ));
  }
}
