import 'dart:async';
import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:polluted_water_app/article/component/article_card.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/notice/mail_view.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/html_parser.dart' as parser;

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>
    with TickerProviderStateMixin {
  Timer? timer;

  final List<String> imgList = [];

  Future<List> getArticle() async {
    var url = Uri.parse('https://openapi.naver.com/v1/search/news.json?');

    int myNumber = 10;
    Iterable<dynamic> myIterable = [myNumber];

    Map<String, String> headers = {
      'accept': 'application/json',
      "Content-Type": "application/json",
      'X-Naver-Client-Id': 'Z3bUedltT2PqNIx5U27T',
      'X-Naver-Client-Secret': 'YaxedP3P0y',
    };

    var queryParams = {
      'query': '후쿠시마',
      //'display': 5,
      //'start': 1,
      'sort': 'sim'
    };

    // uri queryParameter 대입
    var uri = url.replace(queryParameters: queryParams);
    print(uri);

    var response = await http.get(uri, headers: headers);
    //print('response : ${response}');

    // replacAll 통해 html 태그 제거
    // HTML 태그 및 HTML 엔터티 제거를 위한 정규식
    final RegExp htmlRegExp = RegExp(r'<[^>]*>');
    final RegExp entityRegExp = RegExp(r'&(quot|#34|apos|#39);');

    var data = json.decode(
        response.body.replaceAll(htmlRegExp, '').replaceAll(entityRegExp, ''));

    //print(response);
    //print(response);
    //print(data['items']);
    return data['items'];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //print(data);
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => MainScreen(),
      // ));
      // 데이터 처리
      //print(data['items'][0]['title']);
      //print(data);
      return data;
    } else {
      print('요청이 실패했습니다. 상태 코드: ${response.statusCode}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Center(child: Text('아이디 및 비밀번호 입력이 잘못되었습니다.')),
      //   ),
      // );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArticle();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentDay = DateFormat('yyyy/MM/dd')
        .format(DateTime.parse(now.toString()))
        .toString();
    print(currentDay);

    return BaseLayout(
      child: FutureBuilder(
        future: getArticle(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '유효한 링크·정보',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        child:
                                        Image.network(
                                          'https://munaap.kro.kr/api/pollution/v1/item/1.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text('제목'),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Swiper(
                  autoplay: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        String selectedUrl = item['link'];
                        print(selectedUrl);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(url: selectedUrl),
                          ),
                        );
                        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이동')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Container(
                            child: ArticleCard(
                              title: item['title'],
                              description: item['description'],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
            ],
          );
        },
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

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
