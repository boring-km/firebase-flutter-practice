import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  Image? _image;
  File? _imageFileToUpload;
  List<Widget> imageWidgetList = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _setImageListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => setImage(),
                child: Text('지정된 이미지 불러오기')
            ),
            _image != null ? _image! : Text('이미지 아직 없음'),
            ElevatedButton(
                onPressed: () => uploadImage(context),
                child: Text('이미지 선택하여 업로드 하기')
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              // 컨테이너의 높이를 200으로 설정
              height: 300.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: imageWidgetList //_getImageListView(),
              ),
            )
          ],
        ),
      )
    );
  }

  void setImage() async {
    final String url = await getImageURL('1.JPG');
    setState(() {
      _image = Image.network(
        url,
      );
    });
  }

  Future<String> getImageURL(String fileName) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images/')
        .child('$fileName');
    return await ref.getDownloadURL();
  }

  void uploadImage(BuildContext context) async {
    await pickImage();
    if (_imageFileToUpload != null) {
      String fileName = basename(_imageFileToUpload!.path);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFileToUpload!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
    }
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null)
        _imageFileToUpload = File(pickedFile.path);
    });
  }

  void _setImageListView() async {

    List<String> array = ['8e9b91f2-ce29-45c4-9e39-f1cec69c40c82569833236582256695.jpg',
      'a5745cf5-383c-450f-802d-351bcd8d15542635813873004162341.jpg',
      'image_picker8328229604370210524.jpg'];

    List<Widget> imageCardList = [];
    for (var path in array) {
      final url = await getImageURL(path);
      var widget = Container(
        height: 300,
        child: Column(
          children: [
            Image.network(url, height: 200,),
            Text('제목'),
            Text('작성자')
          ],
        ),
      );
      imageCardList.add(widget);
    }
    setState(() {
      imageWidgetList = imageCardList;
    });
  }
}
