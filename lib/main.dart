import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  File? _selectedImage;
  File? _croppedImage;

  Future<void> pickAndCrop() async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _selectedImage!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square
        ],
        uiSettings: [
          AndroidUiSettings(
              lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Edit Photo',
            aspectRatioLockEnabled: true
          ),
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if(croppedFile != null){
        setState(() {
          _croppedImage = File(croppedFile.path);
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Cropper Example"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: _croppedImage != null
                  ? Image.file(
                _croppedImage!,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.add),

            ),
            ElevatedButton(
                onPressed: (){
                  pickAndCrop();
                },
                child: const Text("Pick Image"),
            ),
          ],
        ),
      ),
    );
  }
}
