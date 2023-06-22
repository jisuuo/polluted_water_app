import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/notice/mail_view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class FoodView extends StatefulWidget {
  const FoodView({Key? key}) : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  var ip = 'https://munaap.kro.kr/api/pollution/v1/item';

  Future getFood() async {
    var url = 'https://munaap.kro.kr/api/pollution/v1/item'; // API의 URL
    var response = await http.get(Uri.parse(url)); // API에 GET 요청 보내기

    if (response.statusCode == 200) {
      var document = parser.parse(response.body); // HTML 문서 파싱

      var linkElements = document.querySelectorAll('a'); // 모든 a 태그 선택

      List<Map<String, String>> links = [];

      for (var linkElement in linkElements) {
        var href = linkElement.attributes['href']; // href 속성 값
        var title = linkElement.text; // 텍스트 내용
        var decodedText = utf8.decode(latin1.encode(title));
        //print(decodedText); // 변환된 텍스트 출력

        links.add({
          'title': decodedText,
          'href': href.toString(),
        });
      }
      //print(links);
      return links;
      print(links);

      // links 리스트 출력 또는 추가 작업 수행
      for (var link in links) {
        // print('Title: ${link['title']}');
        // print('Href: ${link['href']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }

    //   print(document.body);
    //
    //   // 필요한 데이터 추출
    //   var titleElement = document.querySelector('body');
    //   var title = titleElement?.text;
    //
    //   print('Title: $title');
    // } else {
    //   print('Error: ${response.statusCode}');

    // var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/item');
    //
    // Map<String, String> headers = {
    //   'accept': 'application/json',
    //   "Content-Type": "application/json",
    // };
    //
    // var response = await http.post(url, headers: headers);
    // var data = json.decode(response.body);
    // data = jsonDecode(utf8.decode(response.bodyBytes));
    // //print(response);
    // return response;
  }

  Future getContent() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/item');

    Map<String, String> headers = {
      'accept': 'application/json',
      "Content-Type": "application/json",
    };

    var response = await http.post(url, headers: headers);
    var data = json.decode(response.body);
    data = jsonDecode(utf8.decode(response.bodyBytes));
    print(response);
    return response;
  }


  Future<http.Response> fetchImage() {
    final url = 'https://munaap.kro.kr/api/pollution/v1/item'; // API 엔드포인트 URL
    return http.post(Uri.parse(url));
  }

  Future<Uint8List?> getImageBytes() async {
    final response = await fetchImage();
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Uint8List stringToUnit8List(String input) {
    List<int> decodedBytes = base64Decode(input);
    return Uint8List.fromList(decodedBytes);
  }

  //http://$ip${item['thumbUrl']}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFood();
    //fetchImage();
    //getImageBytes();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getFood(),
                builder: (context, snapshot) {
                  //print('a : ${snapshot.data}');
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('통신오류입니다. 잠시만 기다려주세요'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('대체 가능한 식품 및 업체를 제보해주시면 \n검토 후 반영하겠습니다.'),
                      ),
                      const SizedBox(height : 20),
                      Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data.length - 1,
                          itemBuilder: (context, index) {
                            final item = snapshot.data[index + 1];
                            //print(snapshot.data);
                            return Container(
                              width: 50,
                              height: 50,
                              child: Row(
                                children: [
                                  Image.network('$ip/${item['title']}', width: 50, height: 50, fit: BoxFit.fill,),
                                  const SizedBox(width: 10),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'].replaceAll('.png', ''),
                                        ),
                                        Text('대체링크'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mail),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MailView(),
            ),
          );
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}

class MyImageWidget extends StatelessWidget {
  final Uint8List? imageBytes;

  MyImageWidget(this.imageBytes);

  @override
  Widget build(BuildContext context) {
    return imageBytes != null
        ? Image.memory(
            imageBytes!,
            fit: BoxFit.contain,
          )
        : CircularProgressIndicator();
  }
}
