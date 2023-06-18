import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:http/http.dart' as http;

class NoticeView extends StatefulWidget {
  const NoticeView({Key? key}) : super(key: key);

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();

  Future getNotice() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/notice');

    Map<String, String> headers = {
      'accept': 'application/json',
      "Content-Type": "application/json",
    };

    var response = await http.post(url, headers: headers);

    var data = json.decode(response.body);
    data = jsonDecode(utf8.decode(response.bodyBytes));

    print(data);

    return data['data'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotice();
  }

  @override
  Widget build(BuildContext context) {

    return BaseLayout(
      title: '공지사항',
      child: Container(
        child: FutureBuilder(
          future: getNotice(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('통신오류입니다. 잠시만 기다려주세요'),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.black,),
              itemCount: 2,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];

                return ExpansionTileCard(
                  title: Text(item['noticeTitle']),
                  subtitle: Text(item['insertDate']),
                  children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          item['noticeContent'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
