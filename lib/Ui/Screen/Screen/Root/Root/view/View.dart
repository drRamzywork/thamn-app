import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Config/config.dart';
import '../../../../../../UI/Widget/widget.dart';
import '../../../../../EmptyState/error.dart';
import '../../../../Basic/SideMenu/view/View.dart';
import '../controller/Controller.dart';

class RootView extends GetView<RootController> {
  const RootView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.app.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error.toString(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              appBar: AppBarRootX(
                title: Obx(() {
                  if(controller.indexSelected.value==0){
                    return GestureDetector(
                      onTap: () => Get.toNamed(RouteNameX.searching),
                      child: ContainerX(
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            Icon(Iconsax.search_normal_1, color: ColorX.greyDark),
                            const SizedBox(
                              width: 20.0,
                            ),
                            TextX(
                              'Search for anything',
                              style: TextStyleX.titleSmall,
                              color: ColorX.greyDark,
                            )
                          ],
                        ),
                      ),
                    );
                  }else if(controller.indexSelected.value==1){
                    return const TextX('My Basket');
                  }else{
                    return const TextX('Profile');
                  }
                }),
              ),
              drawer: const SideMenuView(),
              endDrawer: const SideMenuView(),
              body: Obx(() => controller.pageRoot()),
              bottomNavigationBar: Obx(() => CustomNavigationBar(
                    iconSize: 27.0,
                    selectedColor: ColorX.primary,
                    strokeColor: ColorX.secondary,
                    unSelectedColor: ColorX.greyDark,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 4.0,
                    items: [
                      CustomNavigationBarItem(
                        icon: const Icon(Iconsax.home),
                        selectedIcon: const Icon(Iconsax.home_15),
                      ),
                      CustomNavigationBarItem(
                        icon: const Icon(Iconsax.bag_happy),
                        selectedIcon: const Padding(
                          // padding for fix icon position
                          padding: EdgeInsets.only(left: 27),
                          child: Icon(Iconsax.bag_happy5),
                        ),
                      ),
                      CustomNavigationBarItem(
                        icon: const Icon(Iconsax.profile_circle),
                        selectedIcon: const Icon(Iconsax.profile_circle5),
                      ),
                    ],
                    currentIndex: controller.indexSelected.value,
                    onTap: controller.onItemSelected,
                  )));
        },
      ),
    );
  }
}
