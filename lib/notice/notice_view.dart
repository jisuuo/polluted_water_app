import 'package:flutter/material.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/notice/mail_view.dart';

class NoticeView extends StatelessWidget {
  const NoticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: '공지사항',
      child: Container(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('클릭')));
              },
              title: Text('공지사항'),
              subtitle: Text('공지사항입니다'),
            );
          },
        ),
      ),
    );
  }
}
