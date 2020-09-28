import 'package:entangle/utilities/AuthCredentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:entangle/utilities/constants.dart';
import 'package:entangle/preferences.dart';
import 'package:entangle/screens/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:entangle/main.dart';
import 'signup_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
String _message = null;
String _message3 = null;
bool _rememberMe = true;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

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
                if (!input.contains('@') || input.isEmpty) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: maincolor,
                      content: Text('Enter a valid email address'),
                    ),
                  );
                }
              },
              onSaved: (input) {
                setState(() {
                  _email = input.trim();
                });
              },
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
            return Container(
              child: TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    //return 'Your password needs to be atleast 6 characters';
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: maincolor,
                        content: Text(
                            'Your password needs to be atleast 6 characters'),
                      ),
                    );
                  }
                },
                onSaved: (input) {
                  setState(() {
                    _password = input.trim();
                  });
                },
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
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => forgot_password())),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(builder: (BuildContext context) {
        return RaisedButton(
          elevation: 5.0,
          onPressed: () {
            if (_rememberMe) {
              setEmail(_email);
              setPassword(_password);
            }
            SignIn(_email, _password);
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'LOGIN',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {
              SignInwithGoogle();
              print('Login with Google');
            },
            AssetImage(
              'images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
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
                    vertical: 150,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
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
                      _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
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

  Future<void> SignIn(String email, String password) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        Firebase.initializeApp();
        UserCredential user = await auth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((value) {
          if (_rememberMe) {
            setEmail(_email);
            setPassword(_password);
          }
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FirstScreen(),
          ),
        );
        //_message = 'Logging in';
      } catch (e) {
        print(e.message);
        _message = e.message;
        if (e.message.toString() != 'Given String is empty or null')
          _showDialog();
      }
    } else {}
  }

  Future<bool> checkPersistence() async {
    if (userEmail != null && userPassword != null)
      SignIn(userEmail, userPassword);
  }

  Future<bool> SignInwithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await auth.signInWithCredential(authCredential);
        print(auth.currentUser.email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirstScreen(),
          ),
        );
      } else {
        return Future.value(false);
      }
      //Navigator.push(context,MaterialPageRoute(builder: (context) => FirstScreen(),),);
    } catch (e) {
      _message = e.message;
      _showDialog();
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            _message,
            style: TextStyle(fontFamily: mainfont, fontSize: 15),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                _message = null;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class forgot_password extends StatefulWidget {
  @override
  _forgot_passwordState createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              onSaved: (input) => _email = input,
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

  Widget _buildSendLinkBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(builder: (BuildContext context) {
        return RaisedButton(
          elevation: 5.0,
          onPressed: () {
            sendforgotLink();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'Reset password',
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

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                        'Forgot password',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEmailTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                      _buildSendLinkBtn(),
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

  Future<Builder> sendforgotLink() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        Firebase.initializeApp();
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        _message3 = 'A link has been sent to your email';
        _showDialog();
      } catch (e) {
        print(e.code);
        _message3 = e.message;
        if (e.message.toString() != 'Given String is empty or null')
          _showDialog();
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            _message3,
            style: TextStyle(fontFamily: mainfont, fontSize: 15),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
