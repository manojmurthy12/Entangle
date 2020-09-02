import 'package:entangle/utilities/AuthCredentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:entangle/utilities/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:entangle/screens/login_screen.dart';
import '../main.dart';

final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _rememberMe = false;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Builder(builder: (BuildContext context) {
            return TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: maincolor,
                      content: Text('Please enter an email'),
                    ),
                  );
                }
                ;
              },
              onSaved: (input) => email = input,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Builder(builder: (BuildContext context) {
            return TextFormField(
              validator: (input) {
                if (input.length < 6) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: maincolor,
                      content: Text(
                          'Your password needs to be atleast 6 characters'),
                    ),
                  );
                }
              },
              onSaved: (input) => password = input,
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(builder: (BuildContext context) {
        return RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: maincolor,
                content: Text(message),
              ),
            );
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'Register',
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSigninBtn() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      maincolor,
                      maincolor2,
                    ],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: formKey2,
                        child: Column(
                          children: [
                            _buildEmailTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPasswordTF(),
                          ],
                        ),
                      ),
                      _buildRegisterBtn(),
                      _buildSigninBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    final formState = formKey2.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        Firebase.initializeApp();
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        userCredential.user.sendEmailVerification();
        Navigator.pop(context);
        message = 'registering';
        //Navigator.of(context).pop();
      } catch (e) {
        print(e.message);
        setState(() {
          if (e.code == 'email-already-in-use')
            message = 'The email is already in use.';
          if (e.code == 'network-request-failed')
            message = 'Please connect to the internet.';
          if (e.code == 'invalid-email')
            message = 'Enter the correct email-address.';
          else
            message = 'ERROR, try again later';
        });
      }
    } else
      message = 'An error occured, Try again';
  }
}
