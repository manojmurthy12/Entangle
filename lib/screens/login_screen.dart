import 'package:entangle/utilities/AuthCredentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

String email, password;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;

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
              onSaved: (input) {
                email = input;
                setState(() {
                  if (userEmail != email && _rememberMe) setEmail(email);
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
              onSaved: (input) {
                password = input;
                setState(() {
                  if (userEmail != password && _rememberMe)
                    setPassword(password);
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
            SignIn(email, password);
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
                    vertical: 120.0,
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
                        key: formKey,
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
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        Firebase.initializeApp();
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        checkPersistence();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirstScreen(),
          ),
        );
        message = 'Logging in';
      } catch (e) {
        print(e.code);
        setState(() {
          if (e.code == 'too-many-requests')
            message = 'Too many attempts,try again later.';
          if (e.code == 'wrong-password')
            message = 'Password and the mail address didn\'t match.';
          if (e.code == 'network-request-failed')
            message = 'Please connect to the internet.';
          if (e.code == 'user-not-found')
            message = 'You are not a Registered user';
          if (e.code == 'invalid-email')
            message = 'Enter the correct email-address.';
          else
            message = 'ERROR, try again later';
        });
      }
    }
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
    } catch (error) {
      print(error);
    }
  }
}

class forgot_password extends StatefulWidget {
  @override
  _forgot_passwordState createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  String _email, _message = '';
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
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: maincolor,
                content: Text(_message),
              ),
            );
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
        setState(() {
          _message = 'A link has been sent to your email';
        });
      } catch (e) {
        print(e.code);
        setState(() {
          if (e.code == 'network-request-failed')
            _message = 'Please connect to the internet.';
          if (e.code == 'user-not-found')
            _message = 'You are not a Registered user';
          if (e.code == 'invalid-email')
            _message = 'Enter the correct email-address.';
          else
            _message = 'ERROR, try again later.';
        });
      }
    }
  }
}
