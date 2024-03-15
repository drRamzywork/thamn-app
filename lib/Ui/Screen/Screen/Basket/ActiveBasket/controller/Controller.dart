import 'package:get/get.dart';
import 'package:thamn/UI/Widget/widget.dart';
import '../../../../../../Config/config.dart';
import '../../../../../../Core/core.dart';
import '../../../../../../Data/data.dart';

class ActiveBasketController extends GetxController {
  RxBool isAllowEditShareOrder=true.obs;
  late BasketX basket;
  List<UserX> users= [];
  get isRoot=>Get.currentRoute == RouteNameX.root;
  getData() async{
    try{
      basket=await DatabaseX.getObject<BasketX>(api: DBContactX.getActiveBasket, fromJson: BasketX.fromJson);
    }catch(e){
      return Future.error(e);
    }
  }

  saveBasket() async{
    try{
      AlertDialogX.loading();
      await DatabaseX.postObject(api: DBContactX.postSaveActiveBasket);
      Get.back();
      basket.totalPriceByStore={};
      basket.productsBasket=[];
      update();
      ToastX.success();
    }catch(e){
      return ToastX.error(message: e);
    }
  }

  changeDoneProductBasket(bool val,int productBasketID)async{
    basket.productsBasket.firstWhere((x) => x.id==productBasketID).isDone=val;
    update();
    try{
      await DatabaseX.postObject(api: DBContactX.postChangeDoneProductInBasket,body: DBContactX.bodyChangeDoneProductInBasket(id: productBasketID));
    }catch(e){
      return Future.error(e);
    }
  }
  removeProductBasket(int productBasketID)async{
    var product= basket.productsBasket.firstWhere((productBasket) => productBasket.id==productBasketID);
    basket.totalPrice-=product.product.currentPrice*product.quantity;
    basket.totalPriceByStore[product.product.storeID]=basket.totalPriceByStore[product.product.storeID]!-product.product.currentPrice*product.quantity;
    if(basket.totalPriceByStore[product.product.storeID]==0){
      basket.totalPriceByStore.remove(product.product.storeID);
    }
    basket.productsBasket.removeWhere((productBasket) => productBasket.id==productBasketID);
    update();
    try{
      await DatabaseX.removeObjectByID(api: DBContactX.deleteProductInActiveBasket, id: productBasketID);
    }catch(e){
      return Future.error(e);
    }
  }
  onAddQuantityProductBasket(int productBasketID)async{
    var index=basket.productsBasket.indexWhere((x) => x.id==productBasketID);
    if(basket.productsBasket[index].quantity<100) {
      basket.productsBasket[index].quantity++;
      basket.totalPrice+=basket.productsBasket[index].product.currentPrice;
      basket.totalPriceByStore[basket.productsBasket[index].product.storeID]=basket.totalPriceByStore[basket.productsBasket[index].product.storeID]!+basket.productsBasket[index].product.currentPrice;
      update();
      try{
        await DatabaseX.updateObject(api: DBContactX.deleteProductInActiveBasket, id: productBasketID, body: DBContactX.bodyQuantityProductInBasket(quantity: basket.productsBasket[index].quantity));
      }catch(e){
        return Future.error(e);
      }
    }
  }
  onMinusQuantityProductsBasket(int productBasketID)async{
    var index=basket.productsBasket.indexWhere((x) => x.id==productBasketID);
    if(basket.productsBasket[index].quantity>1) {
      basket.productsBasket[index].quantity--;
      basket.totalPrice-=basket.productsBasket[index].product.currentPrice;
      basket.totalPriceByStore[basket.productsBasket[index].product.storeID]=basket.totalPriceByStore[basket.productsBasket[index].product.storeID]!-basket.productsBasket[index].product.currentPrice;
      update();
      try{
        await DatabaseX.updateObject(api: DBContactX.deleteProductInActiveBasket, id: productBasketID, body: DBContactX.bodyQuantityProductInBasket(quantity: basket.productsBasket[index].quantity));
      }catch(e){
        return Future.error(e);
      }
    }
  }

}