import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/select_from_map.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';

import '../../global/config/helpers.dart';
import '../controllers/address_controller.dart';
import 'add_address.dart';

class EditAddress extends GetView<AddressController> {
  const EditAddress(this.addressToUpdate, {super.key});
final Address addressToUpdate ;
  @override
  Widget build(BuildContext context) {
    print("edited address id ${addressToUpdate.id}");
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'Edit Address',
            svgPath: "assets/images/notification.svg",
            isAddress: true,

          ),
          Padding(
            padding: EdgeInsets.only(top: 160.h),
            child: _buildAddressFields(context),
          ),
        ],
      ),

      floatingActionButton: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildFloatingButton(

                buttonName: 'Select on Map', context: context,
                onPressed: () {
                  Get.to(SelectFromMap());
                },
                isPlainBackground: true


            ),

            buildFloatingButton(

              buttonName: 'Save Address', context: context,
              isLoading: controller.isLoading.value,
              onPressed: () {
                controller.updateAddress(addressToUpdate);

              },

            ),
          ],
        );
      }),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  _buildAddressFields(context) {
    return Padding(

      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: SingleChildScrollView(
        child: Column(


          children: [
            //apartment and country
            Row(
              children: [
                Expanded(
                    child: CustomTextField(
                    height: 60.h,
                    labelText:
                    addressToUpdate.apartment??
                        'apartment', onChanged: (value) {
controller.apartment.value = value;
                })),
                SizedBox(width: kDefaultPadding * 0.8,),
                Expanded(child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        customBoxShadow
                      ],
                    ),

                    child: Obx(() =>
                        InputDecorator(
                          decoration: InputDecoration(

                            filled: true,
                            fillColor:


                            Colors.white,


                            enabledBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10),

                              borderSide: const BorderSide(

                                color:

                                Colors.white,
                                width: 1,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10),

                              borderSide: BorderSide(
                                color:

                                primaryColor
                                ,
                                width: 1,
                              ),
                            ),

                            hintStyle: secondaryTextStyle(
                              color: Colors.black,
                              size: 14.sp.round(),
                              weight: FontWeight.w400,
                              height: 1,
                            ),


                            helperStyle: secondaryTextStyle(

                              color: Colors.red,
                              size: 12.sp.round(),
                              weight: FontWeight.w400,
                              height: 1,

                            ),


                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              underline: Container(
                                height: 1,
                                color: const Color(0xFFA6AAC3),
                              ),
                              isDense: true,
                              icon: SvgPicture.asset(
                                  "assets/images/address/arrow-down.svg"),
                              value: controller.selectedCountry.value,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                controller.selectedCountry.value = newValue!;
                                print("new value ${controller.selectedCountry.value}");
                                print("new value 2 ${newValue}");

                              },
                              items: controller.countriesList
                                  .map<DropdownMenuItem<String>>(
                                      (Country country) {
                                    return DropdownMenuItem<String>(
                                      value: country.name,
                                      child: Text(
                                        country.name ?? "",
                                        style: primaryTextStyle(
                                          color: greyishColor,
                                          size: 14.sp.round(),
                                          weight: FontWeight.w400,
                                          height: 1,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ))),)
              ],
            ),
            SizedBox(height: kDefaultPadding,),
            //state and city
            Obx(() {
              return Row(
                children: [
                  Expanded(
                      child: CustomTextField(

                          height: 60.h,

                          labelText: addressToUpdate.state ?? "State", onChanged: (value) {
                        controller.state.value = value;
                      })),
                  SizedBox(width: kDefaultPadding * 0.8,),

                  Expanded(
                      child: CustomTextField(

                          errorText: controller.cityError.value,
                          height: 60.h,
                          labelText: addressToUpdate.city ?? "City", onChanged: (value) {
                        controller.city.value = value;
                      })),
                ],
              );
            }),
            SizedBox(height: kDefaultPadding,),
            //Address

            Obx(() {
              return Row(
                children: [
                  Expanded(child: CustomTextField(
                      customTextEditingController: controller.addressTextEditingController.value,
                      errorText: controller.addressError.value,
                      height: 60.h,
                      labelText: addressToUpdate.address ?? "Address", onChanged: (value) {
                    controller.address.value = value;
                  })),

                ],
              );
            }),
            SizedBox(height: kDefaultPadding,),
            //Flat Floor Building

            Row(
              children: [
                Expanded(child: CustomTextField(
                    errorText: controller.floorError.value,
                    height: 60.h,
                    labelText: addressToUpdate.floor ?? "Floor", onChanged: (value) {


                })),
                SizedBox(width: kDefaultPadding * 0.7,),
                Expanded(child: CustomTextField(

                    errorText: controller.floorError.value,
                    height: 60.h,
                    labelText: addressToUpdate.floor ?? "Floor", onChanged: (value) {
                  controller.floor.value = value;
                })),
                SizedBox(width: kDefaultPadding * 0.7,),
                Expanded(child: CustomTextField(
                    errorText: controller.buildingError.value,
                    height: 60.h,
                    labelText: addressToUpdate.building ?? "Building", onChanged: (value) {
                  controller.building.value = value;
                })),


              ],

            ),

            SizedBox(height: kDefaultPadding,),
            //Phone
            Obx(() {
              return Row(
                children: [
                  Expanded(child: CustomTextField(
                      keyboardType: TextInputType.number,
                      errorText: controller.phoneError.value,
                      height: 60.h,
                      labelText: addressToUpdate.phone ?? "Phone",
                      onChanged: (value) {
                        controller.phone.value = value;
                      })),

                ],
              );
            }),

            SizedBox(height: kDefaultPadding,),

            WorkHomeSwitcher(),
          ],
        ),
      ),
    );
  }


}
