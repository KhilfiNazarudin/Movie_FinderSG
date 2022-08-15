import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
class storageFile {

  
  FirebaseStorage storage = FirebaseStorage(
    storageBucket: "gs://cpmad-project-ce300.appspot.com");

  Future<String> uploadFile(File file,String uid) async {
    var userId = uid;
    var storageRef = storage.ref().child('user/profile/${userId}');
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask.whenComplete(() => null);
    var downloadUrl = await completedTask.ref.getDownloadURL().whenComplete(() => null);
    return downloadUrl;
  }

  



















}