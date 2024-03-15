import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../../../../Config/config.dart';
import '../../../../../../Widget/widget.dart';
import '../../controller/Controller.dart';

class AddToCartSection extends GetView<ProductDetailsController> {
  const AddToCartSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ContainerX(
              isBorder: true,
              borderColor: ColorX.greyDark.shade50,
              color: Colors.white,
              child: Column(
                children: [
                  ImageNetworkX(
                    imageUrl: controller.product.image,
                    height: 140,
                    width: 140,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10,),
                  CardProductUnitPriceX(
                      pricePerQuantity: controller.product.pricePerQuantity,
                      currency: controller.product.currency,
                      unit: controller.product.unit),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteNameX.storeDetails,
                              arguments: controller.product.store),
                          child: ContainerCardX(
                            height: 38,
                            width: 38,
                            radius: 50,
                            child: ImageNetworkX(
                              imageUrl: controller.product.store?.logo ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextX(controller.product.validTo,
                            style: TextStyleX.titleSmall, color: ColorX.danger),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ContainerX(
                    isBorder: true,
                    padding: EdgeInsets.zero,
                    width: 140,
                    height: 70,
                    child: NumberFieldX(
                      onChanged: (val) => controller.quantity = val,
                      margin: EdgeInsets.zero,
                      value: controller.quantity,
                      decimals: 0,
                      min: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      bottomSheetX(
                        title: 'Add Note',
                        child: Column(
                          children: [
                            ContainerX(
                                isBorder: true,
                                child: TextFieldX(
                                    controller: controller.note,
                                    hint: '+ ${'Add Note'.tr}')),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonX(
                              onTap: () => Get.back(),
                              text: 'ok',
                            )
                          ],
                        ),
                      );
                    },
                    child: ContainerX(
                      isBorder: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 10),
                      color: ColorX.secondary.withOpacity(0.15),
                      child: TextX(
                        '+ ${'Add Note'.tr}',
                        style: TextStyleX.titleSmall,
                        color: context.isDarkMode ? Colors.white : ColorX.primary,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        ButtonX(
          onTap: controller.addToList,
          text: 'Add To List',
        )
      ],
    );
  }
}
