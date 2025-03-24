import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otter_study/utils/goktech_assets.dart';
import 'package:otter_study/pages/class/index.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassState();
}

class _ClassState extends State<ClassPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _classController = Get.put(ClassController());
    return Scaffold(
      appBar: AppBar(
        title: Text("课程"),
        bottom: TabBar(
          tabs: [
            Tab(
              text: "章节",
            ),
            Tab(
              text: "活动",
            )
          ],
          controller: _tabController,
        ),
      ),
      body: SafeArea(
        child: TabBarView(controller: _tabController, children: [
          Obx(() => SingleChildScrollView(
                child: Column(
                  children: _classController.chaptersList
                      .map((e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                child: Text(
                                  "第${e['sort']}章 ${e['name']}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Column(
                                children: e['chapterDetailEntityList']
                                    .map((f) => Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          title: Text(
                                              "${e['sort']}.${f['sort']} ${f['name']}"),
                                          children: f['teachContentResList']
                                              .map((g) => ListTile(
                                                    onTap: () async {
                                                      await _classController
                                                          .contentResHandler(g);
                                                    },
                                                    leading: Image.asset(
                                                      g['type'] == 5
                                                          ? extToIcons(
                                                              g['typeStr'])
                                                          : type2Icons(g['type']
                                                              .toString()),
                                                      height: 24,
                                                    ),
                                                    title: Text("${g['name']}"),
                                                  ))
                                              .cast<Widget>()
                                              .toList(),
                                        )))
                                    .cast<Widget>()
                                    .toList(),
                              )
                            ],
                          )))
                      .toList(),
                ),
              )),
          Obx(() => SingleChildScrollView(
                child: Column(
                  children: _classController.activitiesList
                      .map((e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(e['time']))),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              for (var i in e['data']) ...[
                                ListTile(
                                    leading: Image.asset(
                                      type2Icons(i['type'].toString()),
                                      height: 24,
                                    ),
                                    title: Text("${i['name']}"),
                                    onTap: () async {
                                      await _classController
                                          .contentResHandler(i);
                                    })
                              ]
                            ],
                          )))
                      .toList(),
                ),
              ))
        ]),
      ),
    );
  }
}
