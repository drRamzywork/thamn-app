import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../Config/config.dart';
import '../../../../../EmptyState/error.dart';
import '../controller/Controller.dart';
import 'Sections/categoriesSection.dart';
import 'Sections/mostDiscountedSection.dart';
import 'Sections/myInterestsSection.dart';
import 'Sections/offersBookSection.dart';
import 'Sections/productsSection.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: ErrorView(
                error: snapshot.error.toString(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: StyleX.vPaddingApp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategoriesSection(),
                Center(
                  child: SizedBox(
                    height: 35.0,
                    child: TabBar(
                      indicatorColor: context.isDarkMode
                          ? ColorX.secondary
                          : ColorX.primary,
                      dividerColor: Colors.transparent,
                      labelColor: context.isDarkMode
                          ? ColorX.secondary
                          : ColorX.primary,
                      unselectedLabelColor: ColorX.greyDark,
                      padding: EdgeInsets.zero,
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'Offers Book'.tr),
                        Tab(text: 'Products'.tr),
                        Tab(text: 'Most Discounted'.tr),
                        Tab(text: 'My Interests'.tr),
                      ],
                      controller: controller.tabController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: const [
                      OffersBookSection(),
                      ProductsSection(),
                      MostDiscountedSection(),
                      MyInterestsSection()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
