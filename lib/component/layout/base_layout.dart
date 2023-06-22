import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomSheet;
  final Widget? bottomSheetNavigatorBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;


  const BaseLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomSheet,
    this.bottomSheetNavigatorBar,
    this.floatingActionButton,
    this.drawer,
    this.actions,
    this.automaticallyImplyLeading = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: drawer,
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: SafeArea(child: child),
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomSheetNavigatorBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar(){
    if(title == null){
      return null;
    }else{
      return AppBar(
        actions: actions,
        centerTitle: true,
        backgroundColor: Colors.white,
        // 액션버튼 자동 생성 방지
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: 0,
        title: Text(
          '${title!}',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}