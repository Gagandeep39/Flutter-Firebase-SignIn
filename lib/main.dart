import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase SignIn Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase SignIn Demon"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              textColor: Colors.blue,
              splashColor: Colors.blue[200],
            borderSide: BorderSide(color: Colors.blue),
              child: Text("Google Sign In"),
              onPressed: () => _googleSignInFunction(),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              )
            ),
            OutlineButton(
              textColor: Colors.yellow[900],
              splashColor: Colors.yellow[700],
              highlightedBorderColor: Colors.yellow[900],
              borderSide: BorderSide(color: Colors.yellow[700]),
              child: Text("Google Sign Out"),
              onPressed: () => _googleSignOutFunction(),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              )
            ),
            OutlineButton(
              textColor: Colors.red,
              color: Colors.red,
              splashColor: Colors.red[100],
              borderSide: BorderSide(color: Colors.red),
              highlightedBorderColor: Colors.red[100],
              child: Text("Email Sign-In"),
              onPressed: () {_signInWithEmail(context);},

              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              )
            ),

            OutlineButton(
              textColor: Colors.red,
              color: Colors.red,
              splashColor: Colors.red[100],
              borderSide: BorderSide(color: Colors.red),
              highlightedBorderColor: Colors.red[100],
              child: Text("Email Sign-Out"),
              onPressed: () {_emailSignOut();},
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              )
            ),
            OutlineButton(
              color: Colors.green,
              textColor: Colors.green,
              splashColor: Colors.green[100],
              highlightedBorderColor: Colors.green,
              borderSide: BorderSide(color: Colors.green),
              child: Text("Create Email Account"),
              onPressed: () {_createUser();},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
              ),
            ),

            //make sure to add <uses-permission android:name="android.permission.INTERNET" /> in android.manifest
            Image.network(_imageUrl == null || _imageUrl.isEmpty ? "https://picsum.photos/250?image=9" : _imageUrl),
          ],
        ),
      )
    );
  }

  Future<FirebaseUser> _googleSignInFunction() async{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();



      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      FirebaseUser user = await _auth.signInWithCredential(credential);
      print("User: ${user.displayName}");
      setState(() {
        _imageUrl = user.photoUrl;
      });
      return user;

  }

  void _createUser() async{
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: "singh.gagandeep3911@gmail.com", password: "123456").then((newUser){
      print("User: ${newUser.displayName}");  //response from server i.e name of new user (will be null)
      print("Email: ${newUser.email}");  //response from server i.e email of new user (will be null)
    });
    print(user.displayName);
  }

  _googleSignOutFunction() {
    setState(() {

      _googleSignIn.signOut();
      _imageUrl = "";
    });
  }

  void _signInWithEmail(BuildContext context) {
    _auth.signInWithEmailAndPassword(email: "singh.gagandeep3911@gmail.com", password: "123456")
    .catchError((error){
    })
      .then((newUser){
        print(newUser);
    });


  }

  void _emailSignOut() {
    _auth.signOut(); //same as google singout
    print("same as google sign out");
  }
}

