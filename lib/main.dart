import 'package:biosns/firebase.dart';
import 'package:biosns/next.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _data = "test";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser currentUser;
  String name = "";
  String email = "";
  String url = "";

  Future<String> signIn() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    setState(() {
      email = user.email;
      url = user.photoUrl;
      name = user.displayName;
    });

    return '유저: $user';
  }

  void signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    setState(() {
      email = "";
      url = "";
      name = "";
    });

    Toast.show("로그인 성공", context, duration: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('addTest'),
              onPressed: () {
                FirebaseImpl.addTest("진강민");
              },
            ),
            Text(_data),
            ElevatedButton(
              child: Text('getTest'),
              onPressed: () async {
                _data = await FirebaseImpl.readTest();
                setState(() {});
              },
            ),
            email == "" ? Container(): Column(
              children: <Widget>[
                Image.network(url),
                Text(name),
                Text(email),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (email == "") {
                  signIn();
                } else {
                  signOut();
                }
              },
              child: Container(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.subdirectory_arrow_right),
                    Text(email == "" ? 'Google Login' : "Google Logout")
                  ],
                ),
              ),
            ),
            ElevatedButton(
                child: Text("다음 화면"),
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => SecondPage()));
                }
            )
          ],
        ),
      ),
    );
  }
}
