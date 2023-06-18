import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:http/http.dart' as http;

class MailView extends StatefulWidget {
  const MailView({Key? key}) : super(key: key);

  @override
  State<MailView> createState() => _MailViewState();
}

class _MailViewState extends State<MailView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  var title = '';
  var content = '';

  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  List<File> _selectedImages = [];
  late FormData _formData;

  Future<void> _openImagePicker() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((XFile image) => File(image.path)).toList();
      });
    }
  }

  Future<void> uploadImagesToServer(List<File> images) async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/report');

    var request = http.MultipartRequest('POST', url);

    for (var image in images) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile('images', stream, length, filename: image.path);
      request.files.add(multipartFile);
    }

    // 추가 필드 추가
    request.fields['title'] = title;
    request.fields['content'] = content;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('이미지 업로드 성공');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이미지 업로드 성공')));
    } else {
      print('이미지 업로드 실패: ${response.statusCode}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이미지 업로드 실패')));
    }
  }

  Future<void> getSend() async {
    String url = 'https://munaap.kro.kr/api/pollution/v1/report';

    Map<String, String> headers = {
      'accept': 'application/json',
      "Content-Type": "application/json",
    };

    http.Response resp = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({
        'title': title,
        'content': content,
        'thumbnail': imageFile,
      }),
    );
    //https://freecatz.tistory.com/130
    if (resp.statusCode == 200) {
      print(utf8.decode(resp.bodyBytes)); // 한글이 깨지는 문제를 해결
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입 완료되었습니다.'),
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Center(child: Text('제보가 완료되었습니다!'))));
    } else {
      print(utf8.decode(resp.bodyBytes)); // 한글이 깨지는 문제를 해결
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('입력사항 확인해주세요')),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: '제보하기',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('제보해주신 내용 토대로 확인 후 업로드하여 공유해드리겠습니다.'),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('제목'),
                          TextFormField(
                            onChanged: (value) {
                              title = value;
                              print(title);
                            },
                            decoration: InputDecoration(
                              hintText: '제목',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('문의 내용'),
                          TextFormField(
                            onChanged: (value) {
                              content = value;
                              print(content);
                            },
                            decoration: InputDecoration(
                              hintText: '문의에 관한 세부 내용을 입력해주세요',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('첨부파일'),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _openImagePicker,
                                child: Text('앨범 열기'),
                              ),
                            ],
                          ),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 3,
                              children: _selectedImages.map((File image) {
                                return Image.file(image);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  uploadImagesToServer(_selectedImages);
                },
                child: Text(
                  '제보하기',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
