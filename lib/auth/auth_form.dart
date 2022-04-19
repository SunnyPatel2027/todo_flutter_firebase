import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLogin = false;

  StartAuth() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String _email, String _password, String _username) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential;
    try {
      if (!isLogin) {
        credential = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        credential = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String uid = credential.user!.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set({'username': _username, 'email': _email});
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
            key: _formkey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/login.png",
                    width: 50 * 4,
                  ),
                  isLogin
                      ? TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(),
                              ),
                              labelText: "Enter Username"),
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'username is not valid.';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 13,
                  ),
                  isLogin
                      ? TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(),
                              ),
                              labelText: "Enter Email"),
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('email'),
                          validator: (value) {
                            if (value.toString().isEmpty ||
                                !value.toString().contains("@")) {
                              return 'email is not valid.';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        )
                      : TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(),
                              ),
                              labelText: "Enter Email"),
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('email'),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Enter email.';
                            } else if (!value.toString().contains("@")) {
                              return 'wrong email.';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                  SizedBox(
                    height: 13,
                  ),
                  isLogin
                      ? TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(),
                              ),
                              labelText: "Enter Password"),
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'password is not valid.';
                            } else if (value.toString().length <= 6) {
                              return "Password is to small";
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        )
                      : TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(),
                              ),
                              labelText: "Enter Password"),
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Enter password';
                            } else if (value.toString().length <= 6) {
                              return "wrong Password.";
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                  SizedBox(height: 15),
                  Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            StartAuth();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple)),
                          child: isLogin
                              ? Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? Text("have an account? Log In")
                          : Text("Don't have an account? SignUp")),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: ()async{
                      await signInWithGoogle();
                      setState(() {

                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Image.asset(
                            "assets/images/google.png",
                            height: 30,
                          ),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.purple,width: 4),
                            ),
                          ),
                          Text("   Login with google acount"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
