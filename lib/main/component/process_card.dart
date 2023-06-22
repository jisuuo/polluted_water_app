import 'package:flutter/material.dart';
class ProcessCard extends StatelessWidget {
  final String mainDate;
  final String mainTitle;

  const ProcessCard({required this.mainDate, required this.mainTitle, Key? key})
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
                mainDate,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(mainTitle),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
