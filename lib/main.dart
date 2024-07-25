import 'package:flutter/material.dart';
import 'package:project_try/models/token_model.dart';
import 'helper.dart';
import 'new_acc.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelloWorld',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _username =
      TextEditingController(); //controller for getting username
  TextEditingController _password =
      TextEditingController(); //controller for getting password
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; //used for validation of input
  bool _isObscure = true; //used for password input

  //create a Helper object to be able to access functions
  Helper u = Helper();
  late Future<Response> futureres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            child: const Text(
              'HelloWorld',
              style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            )),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildUsernameField(),
              buildPasswordField(),
              buildLoginButton(),
              const Text('OR',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
              buildCreateButton(),
            ],
          ),
        )
      ],
    ));
  }

  // creates "Create new account" button
  Widget buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: ElevatedButton(
        onPressed: () {
          //navigate to page for creating account
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateNewAccScreen()));
        },
        child: const Text("Create new account"),
      ),
    );
  }

  // creates text field for the username
  Widget buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: TextFormField(
        controller: _username,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Username',
            errorText: _validate ? 'Value can\'t be blank' : null),
        validator: (value) {
          //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return 'Please enter your username.';
          }
          return null;
        },
      ),
    );
  }

  // creates text field for the password
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
            return 'Please enter your password.';
          }
          return null;
        },
      ),
    );
  }

  // creates login button which navigates to home
  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: ElevatedButton(
          child: const Text('Log in'),
          onPressed: () {
            snackBar("Logging in...");
            if (_formKey.currentState!.validate()) {
              futureres = u.login(_username.text, _password.text);
              futureres.then((value) {
                if (value.success == true) {
                  snackBar("Logged in.");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                                selectedIndex: 0,
                              )));
                } else {
                  snackBar(value.message!);
                }
              });
              _username.clear();
              _password.clear();
            }
          }),
    );
  }

  // shows status when logging in
  void snackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
