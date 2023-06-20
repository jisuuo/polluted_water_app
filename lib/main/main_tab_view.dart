import 'package:flutter/material.dart';
import 'package:polluted_water_app/article/article_view.dart';
import 'package:polluted_water_app/component/layout/base_layout.dart';
import 'package:polluted_water_app/food/food_view.dart';
import 'package:polluted_water_app/main/main_view.dart';
import 'package:polluted_water_app/main/process_view.dart';
import 'package:polluted_water_app/notice/ex.dart';
import 'package:polluted_water_app/notice/notice_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  int index = 0;

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
    return BaseLayout(
      child: TabBarView(
        controller: tabController,
        children: [
          ProcessView(),
          //MainView(),
          FoodView(),
          ArticleView(),
          NoticeView(),
        ],
      ),
      bottomSheetNavigatorBar: BottomNavigationBar(
        // bottomNavigatorBar 4개 이상 추가할 때 설정해야하는 요소
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          tabController.animateTo(index);
        },
        currentIndex: index,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: '현황',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.no_food),
            label: '식품',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'article',
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
