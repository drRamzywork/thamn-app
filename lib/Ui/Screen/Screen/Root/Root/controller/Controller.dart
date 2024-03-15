import 'package:get/get.dart';
import '../../../../../../Core/core.dart';
import '../../../Basket/ActiveBasket/view/View.dart';
import '../../Home/view/View.dart';
import '../../Profile/Profile/view/View.dart';

class RootController extends GetxController {
  AppControllerX app=Get.find();
  RxInt indexSelected = 0.obs;

  onItemSelected(int index) {
    indexSelected.value=index;
  }

  pageRoot() {
    switch (indexSelected.value) {
      case 0:
        return const HomeView();
      case 1:
        return const ActiveBasketView();
      case 2:
        return const ProfileView();
    }
  }
}