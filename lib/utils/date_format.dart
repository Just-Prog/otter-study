import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

String FormatedDate(DateTime v){
  return dateFormat.format(v);
}