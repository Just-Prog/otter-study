import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:otter_study/pages/login/controller/index.dart';
import 'package:otter_study/pages/main/index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../utils/uri_handler.dart';
import '../../utils/date_format.dart';

import './controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final userController = Get.put(UserController());
    final mainController = Get.put(MainController());
    final credentialController = Get.put(CredentialController());
    // carouselData.value = await fetchCarousel();
    // newsData.value = await fetchNews();
    return Scaffold(
      body: EasyRefresh(
          controller: homeController.refreshController,
          onRefresh: () async {
            homeController.newsPage = 1;
            homeController.carouselData.value =
                await homeController.fetchCarousel();
            homeController.newsData.value = await homeController.fetchNews();
            homeController.refreshController.finishRefresh();
            homeController.refreshController.resetFooter();
          },
          onLoad: () async {
            homeController.newsPage++;
            homeController.carouselData
                .addAll(await homeController.fetchCarousel());
            homeController.newsData.addAll(await homeController.fetchNews());
            homeController.refreshController.finishLoad(
                homeController.hasMore.value
                    ? IndicatorResult.success
                    : IndicatorResult.noMore);
          },
          refreshOnStart: true,
          header: const MaterialHeader(),
          footer: const MaterialFooter(),
          child: Obx(() => CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (credentialController.isLoggedIn.value) ...[
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    userController
                                        .selectTenant(context)
                                        .then((_) {
                                      if (_ != null) {
                                        Get.offAllNamed("/");
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text("${userController.tenantName}"),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ))
                            ],
                          )
                        ],
                        CarouselSlider(
                            disableGesture: true,
                            items: homeController.carouselData.map((e) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: InkWell(
                                        onTap: () {
                                          int type = e['resourceType'];
                                          String url = "";
                                          if (type == 3) {
                                            url = "${e['resourceValue']}";
                                          } else if (type == 1) {
                                            url =
                                                "https://edu.goktech.cn/news/detail?id=${e['resourceValue']}";
                                          } else {
                                            Get.snackbar("暂未实现", "暂未实现",
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                            return;
                                          }
                                          UriHandler(url);
                                        },
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CachedNetworkImage(
                                                width: double.infinity,
                                                imageUrl: "${e['coverUrl']}",
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                        width: double.infinity,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            Icon(Icons.error)),
                                              ),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            200, 0, 0, 0),
                                                        Color.fromARGB(
                                                            0, 0, 0, 0)
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    '${e['title']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ));
                            }).toList(),
                            options: CarouselOptions(
                                aspectRatio: 2.5,
                                viewportFraction: 1,
                                autoPlay: true,
                                clipBehavior: Clip.antiAlias)),
                        Padding(
                            padding: EdgeInsets.all(16.5),
                            child: Text("资讯",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    sliver: Obx(() {
                      return SliverWaterfallFlow(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int idx) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    6), // Set the border radius here
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  Map<String, dynamic> target =
                                      homeController.newsData[idx];
                                  int type = target['contentType'];
                                  String content = target['content'].toString();
                                  if (type == 1) {
                                    UriHandler(content);
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (homeController.newsData[idx]
                                            ['coverUrl'] !=
                                        "") ...[
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${homeController.newsData[idx]['coverUrl']}",
                                      ),
                                    ],
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 11.5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${homeController.newsData[idx]['title']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              FormatedDate(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      int.parse(homeController
                                                                  .newsData[idx]
                                                              ['createdTime']) *
                                                          1000)),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }, childCount: homeController.newsData.length),
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width /
                                        MediaQuery.of(context).size.height <=
                                    1.2
                                ? 2
                                : 4,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ));
                    }),
                  ),
                ],
              ))),
    );
  }
}
