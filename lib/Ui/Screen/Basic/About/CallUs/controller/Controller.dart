import 'package:get/get.dart';

import '../../../../../../Data/data.dart';

class CallUsController extends GetxController {
  late String callUsEmail;
  late String callUsPhone;
  getData()async{
    try{
      await DatabaseX.getCallUs().then((value){
        callUsEmail=value.$1;
        callUsPhone=value.$2;
      });
    }catch(e){
      return Future.error(e);
    }
  }
}