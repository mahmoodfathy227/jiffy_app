
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
  const AddAddress ({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddressController());
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'All Addresses',
            svgPath: "assets/images/notification.svg",

          ),
          Padding(
            padding:  EdgeInsets.only(top: 160.h),
            child:      _buildAddressFields(context),
          ),
        ],
      ),

      floatingActionButton: Column(
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
            onPressed: () {},

          ),
        ],
      ),
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
                  height: 60.h,
                    labelText: "Apartment", onChanged: (value) {

                })),
                SizedBox(width:  kDefaultPadding * 0.8,),
                Expanded(child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        customBoxShadow
                      ],
                    ),

                    child: Obx(() => InputDecorator(
                      decoration: InputDecoration(

                        filled: true,
                        fillColor:


                        Colors.white ,



                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(10),

                          borderSide:  const BorderSide(

                            color:

                            Colors.white,
                            width: 1,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(10),

                          borderSide:  BorderSide(
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
                        // label:
                        // FittedBox(
                        //   child: Container(
                        //
                        //     width: 250.w,
                        //     height: 40.h,
                        //     color: Colors.transparent,
                        //     child:  Align(
                        //       alignment: Alignment.centerLeft,
                        //       child:
                        //
                        //       Align(
                        //         alignment:
                        //
                        //         Alignment.centerLeft,
                        //         child: AutoSizeText(
                        //
                        //
                        //           widget.labelText,
                        //           style:  secondaryTextStyle(
                        //             size:  8.sp.round(),
                        //
                        //             color:
                        //
                        //             widget.errorText.isNotEmpty?
                        //             Colors.red
                        //                 :
                        //             !isValueEmpty?
                        //             primaryColor
                        //                 :
                        //
                        //             Colors.grey[300]
                        //             ,
                        //             weight: FontWeight.w400,
                        //
                        //           ), // Set an initial font size
                        //           maxLines: 2, // Adjust as needed
                        //         ),
                        //       ),
                        //
                        //
                        //     ),
                        //   ),
                        // ),







                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            color: const Color(0xFFA6AAC3),
                          ),
                          isDense: true,
                          icon: SvgPicture.asset("assets/images/address/arrow-down.svg") ,
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
            Row(
              children: [
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "State*", onChanged: (value) {

                })),
                SizedBox(width: kDefaultPadding * 0.8,),
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "City", onChanged: (value) {

                })),
              ],
            ),
            SizedBox(height: kDefaultPadding,),
            //Address

            Row(
              children: [
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "Address*", onChanged: (value) {

                })),

              ],
            ),
            SizedBox(height: kDefaultPadding,),
            //Flat Floor Building

            Row(
              children: [
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "Flat", onChanged: (value) {

                })),
                SizedBox(width: kDefaultPadding*0.7,),
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "Floor", onChanged: (value) {

                })),
                SizedBox(width: kDefaultPadding*0.7,),
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "Building", onChanged: (value) {

                })),


              ],

            ),

            SizedBox(height: kDefaultPadding,),
            //Phone
            Row(
              children: [
                Expanded(child: CustomTextField(
                    height: 60.h,
                    labelText: "Phone*", onChanged: (value) {

                })),

              ],
            ),
          ],
        ),
      ),
    );
  }




}
