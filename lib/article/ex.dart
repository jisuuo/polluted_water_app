import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Swiper 예시'),
        ),
        body: Swiper(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
          pagination: SwiperPagination(), // 페이지 표시기 사용
          control: SwiperControl(), // 이전/다음 버튼 사용
        ),
      ),
    );
  }
}