import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app/providers/app/app_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  GlobalKey<FormState> _formKey;
  bool _isLoading;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _isLoading = false;
  }

  void login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        AppProvider appProvider = Provider.of<AppProvider>(context);
        appProvider.appConfig.checkAuth();
        Navigator.pushNamedAndRemoveUntil(context, 'home', (Route) => false);
      } catch (error) {
        print(error.message);
        setState(() {
          _message = error.message;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log in',
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          child: ListView(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (value) {
                          _email = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill email address';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Enter email address',
                        ),
                      ),
                      TextFormField(
                        onSaved: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill password';
                          } else
                            return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Enter password',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(_message),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: RaisedButton(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.02),
                          onPressed: login,
                          child: Text('Login'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
