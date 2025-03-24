import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/pages/login/controller/index.dart';

import 'controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final _mainController = Get.put(MainController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OtterStudy",
            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (MediaQuery.of(context).orientation == Orientation.landscape) ...[
            Obx(() => NavigationRail(
                  destinations: _mainController.bottomNavItems.map((e) {
                    return NavigationRailDestination(
                        icon: e['icon'],
                        label: Text(e['label'] ?? "undefined"));
                  }).toList(),
                  selectedIndex: _mainController.pageIdx.value,
                  onDestinationSelected: (v) {
                    _mainController.pageIdx.value = v;
                    _mainController.pageCtl.jumpToPage(v);
                    setState(() {});
                  },
                  labelType: NavigationRailLabelType.selected,
                ))
          ],
          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _mainController.pageCtl,
            children: _mainController.pages,
          ))
        ],
      ),
      bottomNavigationBar:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? Obx(() => BottomNavigationBar(
                  currentIndex: _mainController.pageIdx.value,
                  onTap: (v) {
                    _mainController.pageIdx.value = v;
                    _mainController.pageCtl.animateToPage(v,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                    setState(() {});
                  },
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  items: _mainController.bottomNavItems.map((e) {
                    return BottomNavigationBarItem(
                        icon: Badge(
                            label: Text(e['count'].toString()),
                            // padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                            child: e['icon'],
                            isLabelVisible: e['showBadge']),
                        label: e['label']);
                  }).toList()))
              : null,
    );
  }
}
