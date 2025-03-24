import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:otter_study/http/index.dart';
import 'package:otter_study/pages/login/controller/index.dart';

class HomeController extends GetxController {
  RxList carouselData = [].obs;
  RxList newsData = [].obs;
  int newsPage = 1;
  RxBool hasMore = false.obs;
  late EasyRefreshController refreshController;
  final _userController = Get.put(UserController());

  fetchCarousel() async {
    final resp = await Request().get(Api.homePageCarousels, params: {
      "exclusiveTenantId": _userController.tenantId.value == "-1"
          ? ""
          : _userController.tenantId.value
    });
    List<dynamic> list = resp.data;
    return list;
  }

  fetchNews() async {
    final resp = await Request().get(Api.homePageNewsUrl, params: {
      "exclusiveTenantId": _userController.tenantId.value == "-1"
          ? ""
          : _userController.tenantId.value,
      "pageNo": newsPage,
      "pageSize": 30
    });
    hasMore.value = resp.data['more'];
    List<dynamic> list = resp.data['list'];
    return list;
  }

  @override
  void onInit() async {
    // carouselData.value = await fetchCarousel();
    // newsData.value = await fetchNews();
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    super.onInit();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
