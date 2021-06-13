import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A StatefulWidget which keeps track of the current uploaded files.
class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  FirebaseImage? _image;
  File? _imageFileToUpload;
  final picker = ImagePicker();

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
            _image != null ? Image(
              image: _image!,
              width: 300,
            ) : Text('이미지 아직 없음'),
            ElevatedButton(
                onPressed: () => uploadImage(context),
                child: Text('이미지 선택하여 업로드 하기')
            )
          ],
        ),
      )
    );
  }

  void setImage() {
    setState(() {
      _image = FirebaseImage('gs://eco-flutter-study.appspot.com/images/1.JPG');
    });
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
}
