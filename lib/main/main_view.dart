import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:http/http.dart' as http;
import 'package:polluted_water_app/notice/ex.dart';
import 'package:polluted_water_app/notice/mail_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Future<List> getProcess() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/main');

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProcess();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: '오염수 방류 진행과정',
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FutureBuilder(
          future: getProcess(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    //color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        item['insertDate'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item['mainTitle'])),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Icon(Icons.arrow_circle_down_rounded),
              ),
              itemCount: 5,
            );
          },
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
