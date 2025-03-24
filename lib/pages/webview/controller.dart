import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController{
  String url = '';
  late final WebViewController viewCtl = WebViewController();

  @override
  void onInit() {
    url = Get.parameters['url']!;
    viewCtl
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (_){
          if(_.url.startsWith("weixin://")){
            launchUrl(Uri.parse(_.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }
      ))
      ..loadRequest(Uri.parse(url));
    super.onInit();
  }
}