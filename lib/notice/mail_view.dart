import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:polluted_water_app/mail/model/data_model.dart';

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




  Future<void> uploadImagesToServer(
      List<File> images, String title, String content) async {

    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/report');
    var request = http.MultipartRequest('POST', url);

    for (var image in images) {
      var resizedImage = await  compressImage(image); // 이미지 리사이징
      var stream =
          http.ByteStream(Stream.fromIterable([resizedImage!.toList()]));

      var length = resizedImage.length;

      var multipartFile = http.MultipartFile(
        'thumbnail',
        stream,
        length,
        filename: image.path,
        contentType: MediaType.parse('multipart/form-data'),
      );

      request.files.add(multipartFile);
    }

    // 데이터 직렬화
    var dataMap = {
      "title": title,
      "content": content,
    };

    var jsonData = json.encode(dataMap);
    print(jsonData);

    //request.headers['Content-Type'] = 'application/json';
    request.fields['data'] = jsonData;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('이미지 업로드 성공');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이미지 업로드 성공')));
    } else {
      print('이미지 업로드 실패: ${response.statusCode}');
      print('에러 메시지: ${response.reasonPhrase}');

      // 에러 응답 본문 출력
      await response.stream.transform(utf8.decoder).forEach(print);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('이미지 업로드 실패')));
    }
  }

  Future<Uint8List?> compressImage(File imageFile) async {
    var compressedImage = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: 10, // 리사이징된 이미지의 품질 설정
    );
    return compressedImage;
  }

  // Future<void> getSend() async {
  //   String url = 'https://munaap.kro.kr/api/pollution/v1/report';
  //
  //   Map<String, String> headers = {
  //     'accept': 'application/json',
  //     "Content-Type": "application/json",
  //   };
  //
  //   http.Response resp = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: json.encode({
  //       'title': title,
  //       'content': content,
  //       'thumbnail': imageFile,
  //     }),
  //   );
  //   //https://freecatz.tistory.com/130
  //   if (resp.statusCode == 200) {
  //     print(utf8.decode(resp.bodyBytes)); // 한글이 깨지는 문제를 해결
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('회원가입 완료되었습니다.'),
  //       ),
  //     );
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Center(child: Text('제보가 완료되었습니다!'))));
  //   } else {
  //     print(utf8.decode(resp.bodyBytes)); // 한글이 깨지는 문제를 해결
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Center(child: Text('입력사항 확인해주세요')),
  //       ),
  //     );
  //   }
  // }

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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '* 제보해주신 내용 토대로 확인 후 업로드하여드 공유해드리겠습니다.',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
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
                  uploadImagesToServer(_selectedImages, title, content);
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
