import 'package:flutter/material.dart';
import 'helper.dart';
import 'models/user_model.dart';

class UpdatePwScreen extends StatefulWidget {
  const UpdatePwScreen({Key? key}) : super(key: key);

  @override
  _UpdatePwScreenState createState() => _UpdatePwScreenState();
}

class _UpdatePwScreenState extends State<UpdatePwScreen> {
  TextEditingController _oldpw =
      TextEditingController(); //controller for getting old password
  TextEditingController _newpw =
      TextEditingController(); //controller for getting new password
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; //used for validation of input
  bool _isObscureold = true; //used for old password input
  bool _isObscurenew = true; //used for new password input

  Helper u = Helper();
  late Future<User> futureuser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change password'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildOldPasswordField(),
                  buildNewPasswordField(),
                  buildUpdateButton()
                ],
              ),
            )
          ],
        ));
  }

  // creates textfield for old password
  Widget buildOldPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, bottom: 10.0, top: 20.0),
      child: TextFormField(
        controller: _oldpw,
        obscureText: _isObscureold,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Current password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureold ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscureold = !_isObscureold;
                });
              },
            ),
            errorText: _validate ? 'Value can\'t be blank' : null),
        validator: (value) {
          //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return 'Please enter your current password.';
          }
          return null;
        },
      ),
    );
  }

  // creates textfield for new password
  Widget buildNewPasswordField() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10),
      child: TextFormField(
        controller: _newpw,
        obscureText: _isObscurenew,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'New password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscurenew ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscurenew = !_isObscurenew;
                });
              },
            ),
            errorText: _validate ? 'Value can\'t be blank' : null),
        validator: (value) {
          //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return 'Password cannot be blank.';
          }
          if (value.length < 8) {
            return 'Your password must be at least 8 characters.';
          }
          return null;
        },
      ),
    );
  }

  // creates update button
  Widget buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: ElevatedButton(
          child: const Text('Update password'),
          onPressed: () {
            snackBar(
              "Updating password...",
            );
            if (_formKey.currentState!.validate()) {
              futureuser = u.updateUser(_oldpw.text, _newpw.text, "", "");
              futureuser.then((value) {
                if (value.success == true) {
                  snackBar("Password updated.");
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
