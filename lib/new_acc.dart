import 'package:flutter/material.dart';
import 'package:project_try/models/user_model.dart';
import 'helper.dart';

class CreateNewAccScreen extends StatefulWidget {
  const CreateNewAccScreen({Key? key}) : super(key: key);

  @override
  _CreateNewAccScreenState createState() => _CreateNewAccScreenState();
}

class _CreateNewAccScreenState extends State<CreateNewAccScreen> {
  final TextEditingController _username =
      TextEditingController(); //controller for getting username
  final TextEditingController _password =
      TextEditingController(); //controller for getting password
  final TextEditingController _fname =
      TextEditingController(); //controller for getting user's first name
  final TextEditingController _lname =
      TextEditingController(); //controller for getting user's last name
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; //used for validation of input
  bool _isObscure = true; //used for password input

  //create a Helper object to be able to access functions
  Helper u = Helper();
  late Future<User> futureuser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: const Text(
              'HelloWorld',
              style: TextStyle(color: Colors.cyanAccent),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 30, left: 20, bottom: 15),
                child: const Text(
                  'Create your account',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildInputField('First Name', _fname),
                  buildInputField('Last Name', _lname),
                  buildInputField('Username', _username),
                  buildPasswordField(),
                  buildSignupButton()
                ],
              ),
            ),
          ],
        )));
  }

  //creates textfield widget which accepts label and controller as parameter
  Widget buildInputField(String label, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: label,
            errorText: _validate ? 'Value can\'t be blank' : null),
        validator: (value) {
          //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return '$label cannot be blank.';
          }
          if (label == 'Username' && value.length < 4) {
            return 'Username must be at least 4 characters.';
          } // id username already exists
          return null; //if input is valid
        },
      ),
    );
  }

  // creates textfield for password which should be obscured
  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: TextFormField(
        controller: _password,
        obscureText: _isObscure,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
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

// creates signup button
  Widget buildSignupButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: ElevatedButton(
          child: const Text('Sign up'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              //get response using signup() function
              snackBar("Creating account");
              futureuser = u.signup(
                  _username.text, _password.text, _fname.text, _lname.text);
              futureuser.then((value) {
                //success = value.success;

                if (value.success == true) {
                  snackBar("Successfully created account. Please sign in.");
                } else {
                  snackBar("Unable to sign-up.");
                }
              });

              //clear text on controllers after successful insert of data to database
              _username.clear();
              _fname.clear();
              _lname.clear();
              _password.clear();
            }
          }),
    );
  }

  // shows snackbar
  void snackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
