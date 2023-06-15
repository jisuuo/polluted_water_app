import 'package:flutter/material.dart';
import 'package:polluted_water_app/food/food_view.dart';
import 'package:polluted_water_app/main/home_view.dart';
import 'package:polluted_water_app/notice/notice_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> with TickerProviderStateMixin {
  int index = 0;

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(tabListener);
  }

  tabListener() {
    setState(() {
      index = tabController.index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.removeListener(tabListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [
          HomeView(),
          FoodView(),
          NoticeView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // bottomNavigatorBar 4개 이상 추가할 때 설정해야하는 요소
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          tabController.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.no_food),
            label: 'food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Notice',
          ),
        ],
      ),
    );
  }
}
