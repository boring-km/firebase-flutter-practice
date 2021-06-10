import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:toast/toast.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();

}

class _SecondPageState extends State<SecondPage> {

  MySqlConnection conn = null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("두번째 화면"),
                ElevatedButton(
                    onPressed: () {
                      _callMariaDB(context);
                    },
                    child: Text("지정된 데이터 mariadb에서 호출")
                )
              ],
            ),
          )
        ),
        onWillPop: null);
  }

  void _callMariaDB(BuildContext context) async {
    var settings = new ConnectionSettings(
      host: '192.168.35.3',
      port: 3306,
      user: 'root',
      password: '1234',
      db: 'testdb'
    );
    conn = await MySqlConnection.connect(settings);
    var userId = 2;
    var sql = 'select * from User where userId = $userId';
    var results = await conn.query(sql);
    for (var data in results) {
      Toast.show('userId: ${data[0]}, email: ${data[1]}', context);
    }
  }

}