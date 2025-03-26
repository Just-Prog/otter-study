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
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/images/default-course-bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _classController.name.value,
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "授课教师: ${_classController.teacher.value}",
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ])),
                bottom: TabBar(
                  tabs: const [
                    Tab(text: "章节"),
                    Tab(text: "活动"),
                  ],
                  controller: _tabController,
                  isScrollable: false,
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )),
        ];
      },
      body: Builder(builder: (ctx) {
        return TabBarView(
          controller: _tabController,
          children: [
            CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(ctx),
                ),
                SliverToBoxAdapter(
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _classController.chaptersList
                              .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: ExpansionTile(
                                                  title: Text(
                                                      "${e['sort']}.${f['sort']} ${f['name']}"),
                                                  children:
                                                      f['teachContentResList']
                                                          .map((g) => ListTile(
                                                                onTap:
                                                                    () async {
                                                                  await _classController
                                                                      .contentResHandler(
                                                                          g);
                                                                },
                                                                leading:
                                                                    Image.asset(
                                                                  g['type'] == 5
                                                                      ? extToIcons(g[
                                                                          'typeStr'])
                                                                      : type2Icons(
                                                                          g['type']
                                                                              .toString()),
                                                                  height: 24,
                                                                ),
                                                                title: Text(
                                                                    "${g['name']}"),
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
                        )))
              ],
            ),
            CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(ctx),
                ),
                SliverToBoxAdapter(
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _classController.activitiesList
                              .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 5),
                                        child: Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
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
                        )))
              ],
            ),
          ],
        );
      }),
    ));
  }
}
