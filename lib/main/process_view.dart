import 'dart:convert';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/notice/mail_view.dart';
import 'package:http/http.dart' as http;

class ProcessView extends StatefulWidget {
  const ProcessView({super.key});

  @override
  State<ProcessView> createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView>
    with TickerProviderStateMixin {

  Future<List> getProcess() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/main');

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
    getProcess();
  }


  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Process',
      child: const Center(
        child: StepperExample(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.mail,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MailView(),
            ),
          );
        },
      ),
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {

  Future<List> getProcess() async {
    var url = Uri.parse('https://munaap.kro.kr/api/pollution/v1/main');

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
    getProcess();
  }


  List<StepperData> stepperData = [
    StepperData(
        title: StepperText(
          "Order Placed",
          textStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
        subtitle: StepperText("Your order has been placed"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: const Icon(Icons.looks_one, color: Colors.white),
        )),
    StepperData(
        title: StepperText("Preparing"),
        subtitle: StepperText("Your order is being prepared"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Center(child: Text('1'))
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: getProcess(),
          builder: (context, snapshot) {
            return Column(
              children: [
                AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                  iconWidth: 40,
                  iconHeight: 40,
                  activeBarColor: Colors.redAccent,
                  inActiveBarColor: Colors.grey,
                  verticalGap: 30,
                  activeIndex: 2,
                  barThickness: 8,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
