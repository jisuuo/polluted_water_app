import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:http/http.dart' as http;

class ProcessView extends StatefulWidget {
  const ProcessView({Key? key}) : super(key: key);

  @override
  State<ProcessView> createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '후쿠시마 오염수 현황',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 300,
            height: 300,
            child: Image.network(
              'https://i.namu.wiki/i/O9YoCSuRviChM9fPpPosxt4pg7iPrlfD7s_Uf1DTy4uLsc4uirdSetCwyNrG1Z3veGEX6nWf4lfPfavpN3GoLmkxNLFAKBZpQcNZdb6fEQKLIuRY2EKWkhNNz8hIIw_IV2fK2r2Mmg2A42woFRF8hA.webp',
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: FutureBuilder(
                future: getProcess(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          //color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(item['mainTitle'])),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 5),
                    itemCount: 5,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
