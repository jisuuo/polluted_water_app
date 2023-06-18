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
    var data = json.decode(response.body);
    data = jsonDecode(utf8.decode(response.bodyBytes));
    //print(data);
    return data['data'];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFood();
    fetchImage();
    getImageBytes();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Food',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getFood(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('통신오류입니다. 잠시만 기다려주세요'),
                    );
                  }
                  return GridView.builder(
                    itemCount: 2,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      print(item['itemImage']);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.memory(stringToUnit8List(item['itemImage'])),
                            Text(item['itemTitle']),
                          ],
                        ),
                      );
                    },
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
