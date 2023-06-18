import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  List<File> _selectedImages = [];

  Future<void> _openImagePicker() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _selectedImages = pickedImages.map((XFile image) => File(image.path)).toList();
      });
    }
  }

  Future<void> _uploadImagesToServer() async {
    // 서버에 이미지 업로드 로직을 구현합니다.
    // _selectedImages 리스트에 선택된 이미지 파일들이 있습니다.
    // 이를 서버로 전송하는 코드를 작성하세요.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앨범 사진 선택'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _openImagePicker,
            child: Text('앨범 열기'),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: _selectedImages.map((File image) {
                return Image.file(image);
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _uploadImagesToServer,
            child: Text('서버에 전송'),
          ),
        ],
      ),
    );
  }
}
