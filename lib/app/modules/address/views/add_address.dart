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

class AddAddress extends GetView<AddressController> {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'All Addresses',
            svgPath: "assets/images/notification.svg",

          ),
          Padding(
            padding: EdgeInsets.only(top: 160.h),
            child: _buildAddressFields(context),
          ),
        ],
      ),

      floatingActionButton: Obx(() {
        Get.put(AddressController());
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
                controller.addAddress();
                controller.validateField(
                    controller.label.value, controller.labelError);
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
                Expanded(child: CustomTextField(

                    labelText: "Apartment", onChanged: (value) {
                  controller.apartment.value = value;


                })),
                SizedBox(width: kDefaultPadding * 0.8,),
                Expanded(child: Container(

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



                          labelText: "State*", onChanged: (value) {
                        controller.state.value = value;
                      })),
                  SizedBox(width: kDefaultPadding * 0.8,),

                  Expanded(
                      child: CustomTextField(

                          errorText: controller.cityError.value,



                          labelText: "City", onChanged: (value) {
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


                      labelText:controller.address.value == "" ? "Address*" : controller.address.value, onChanged: (value) {
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

                    labelText: "Flat", onChanged: (value) {


                })),
                SizedBox(width: kDefaultPadding * 0.7,),
                Expanded(child: CustomTextField(
                    errorText: controller.floorError.value,

                    labelText: "Floor", onChanged: (value) {
                  controller.floor.value = value;
                })),
                SizedBox(width: kDefaultPadding * 0.7,),
                Expanded(child: CustomTextField(
                    errorText: controller.buildingError.value,

                    labelText: "Building", onChanged: (value) {
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

                      labelText: "Phone*",
                      onChanged: (value) {
                        controller.phone.value = value;
                      })),

                ],
              );
            }),
            SizedBox(height: kDefaultPadding,),

            WorkHomeSwitcher()
          ],
        ),
      ),
    );
  }


}


class WorkHomeSwitcher extends StatefulWidget {
  @override
  _WorkHomeSwitcherState createState() => _WorkHomeSwitcherState();
}

class _WorkHomeSwitcherState extends State<WorkHomeSwitcher> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30),
      isSelected: isSelected,
      onPressed: (int index) {
       AddressController myAddressController = Get.find<AddressController>();
       myAddressController.label.value = index == 1 ? "Home" : "Work";
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });
      },
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Work'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Home'),
        ),
      ],
    );
  }
}