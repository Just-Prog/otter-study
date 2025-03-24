import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/common/index.dart';
import 'package:otter_study/pages/login/controller/credential_controller.dart';

import './index.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<StatefulWidget> createState() => _learningState();
}

class _learningState extends State<LearningPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _credentialController = Get.put(CredentialController());
    return Scaffold(
        appBar: TabBar(controller: _tabController, tabs: [
          Tab(
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text("动态"),
              ),
            ),
          ),
          Tab(
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text("成长"),
              ),
            ),
          ),
          Tab(
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text("班课"),
              ),
            ),
          ),
          Tab(
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text("考试"),
              ),
            ),
          ),
        ]),
        body: Obx(
          () {
            if (_credentialController.isLoggedIn.value) {
              return TabBarView(controller: _tabController, children: [
                DynamicView(),
                GrowingView(),
                ClassesListView(),
                ExamListView()
              ]);
            }
            return Center(
              child: Text("请登录"),
            );
          },
        )
        // body: TabBarView(controller: _tabController, children: [
        //   DynamicView(),
        //   GrowingView(),
        //   ClassesListView(),
        //   ExamListView()
        // ]),
        );
  }
}
