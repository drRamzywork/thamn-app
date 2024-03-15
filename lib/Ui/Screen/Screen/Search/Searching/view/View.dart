import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Config/config.dart';
import '../../../../../../Core/core.dart';
import '../../../../../../UI/Widget/widget.dart';
import '../../../../../EmptyState/error.dart';
import '../controller/Controller.dart';

class SearchingView extends GetView<SearchingController> {
  const SearchingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(DeviseX.isLTR ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
          ),
        ),
        title: ContainerX(
          height: 50,
          child: Center(
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller.searchText,
                autofocus: true,
                onSubmitted: (_)=>controller.searchResults(),
                style: TextStyleX.titleSmall.copyWith(color: ColorX.greyDark),
                decoration: InputDecoration(
                    icon: GestureDetector(
                        onTap: controller.searchResults,
                        child: Icon(Iconsax.search_normal, color: ColorX.greyDark)),
                    border: InputBorder.none,
                  hintText: 'Search for anything'.tr,
                  isCollapsed: true
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await controller.searchingAutoComplete(pattern);
              },
              hideOnEmpty: true,
              hideOnError: true,
              itemBuilder: (context, result) {
                return Column(
                  children: [
                    ListTile(
                      title: TextX(result.name),
                    trailing: Icon(DeviseX.isLTR ? Iconsax.arrow_right_3 : Iconsax.arrow_left_3,size: 16,color: ColorX.greyDark),
                    ),
                    const Divider(endIndent: 20,indent: 20,)
                  ],
                );
              },
              onSuggestionSelected: (val) {
               controller.onTapSearchAutoComplete(val.id);
              },
            ),
          ),
        ),
      ),
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
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: StyleX.hPaddingApp, vertical: StyleX.vPaddingApp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.popularSearches.isNotEmpty)
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Iconsax.search_normal),
                      SizedBox(
                        width: 5,
                      ),
                      TextX('Popular Search Terms'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      ...controller.popularSearches.map(
                            (word) => GestureDetector(
                          onTap: () => controller.searchResults(word: word),
                          child: ContainerX(
                            radius: 50,
                            child: TextX(
                              word,
                              style: TextStyleX.titleSmall,
                              color: ColorX.greyDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(
                    width: 5,
                  ),
                  TextX('Search Recently'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                    () => Wrap(
                  spacing: 10,
                  children: [
                    ...controller.searchHistories.value.map(
                          (word) => ContainerX(
                        radius: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => controller.searchResults(word: word),
                              child: TextX(
                                word,
                                style: TextStyleX.titleSmall,
                                color: ColorX.greyDark,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkResponse(
                              onTap: () => controller
                                  .removeSearchHistory(word),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 3),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: ColorX.greyDark,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },),
    );
  }
}
