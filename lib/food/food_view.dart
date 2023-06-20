import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/notice/mail_view.dart';
import 'package:http/http.dart' as http;

class FoodView extends StatefulWidget {
  const FoodView({Key? key}) : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  Future getFood() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/item');

    Map<String, String> headers = {
      'accept': 'application/json',
      "Content-Type": "application/json",
    };

    var response = await http.post(url, headers: headers);
    //var data = json.decode(response.body);
    //data = jsonDecode(utf8.decode(response.bodyBytes));
    print(response);
    return response;
  }

  Future<http.Response> fetchImage() {
    final url = 'https://munaap.kro.kr/api/pollution/v1/item?'; // API 엔드포인트 URL
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
                      Expanded(
                        child: ListView.separated(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 50,
                              height: 50,
                              child: Row(
                                children: [
                                  Image.network(
                                      'https://munaap.kro.kr/api/pollution/v1/item/1.png'),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('음식이름'),
                                      Text('대체링크'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
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
