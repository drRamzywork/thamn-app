import 'package:get/get.dart';
import 'package:thamn/Data/data.dart';

import '../../../../../../Config/config.dart';

class StoreDetailsController extends GetxController {
  StoreX store=Get.arguments;
  List<FlyerX> flyers=[];

  getData()async{
    try{
      flyers= await DatabaseX.getAllByID(api: DBContactX.getFlyersByStore,fromJson: FlyerX.fromJson,id:store.id);
    }catch(e){
      return Future.error(e);
    }
  }

}