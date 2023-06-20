import 'package:flutter/material.dart';
class ArticleCard extends StatelessWidget {
  final String title;
  final String description;

  const ArticleCard({required this.title, required this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(description),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('클릭 시 원문 기사로 이동합니다'),
                  Icon(Icons.arrow_circle_right, size: 15,),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
