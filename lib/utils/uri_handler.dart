import 'dart:io';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void UriHandler(String uriString){
  if(Platform.isAndroid){
    Get.toNamed("/webview", parameters: {
      'url': uriString
    });
  }else{
    launchUrl(Uri.parse(uriString));
  }
  return;
}