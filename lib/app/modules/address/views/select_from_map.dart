import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/add_address.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';

import '../../global/config/helpers.dart';
import '../controllers/address_controller.dart';

class SelectFromMap extends GetView<AddressController> {
  const SelectFromMap({super.key});

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.put(AddressController());
    addressController.getPermission();
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [


              Padding(
                padding:  EdgeInsets.only(top: 110.h),
                child: Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      child: InkWell(
                          onTap: () {
                            controller.getCurrentLocation(context);
                          },
                          child: SizedBox(

                              child: Stack(children: [
                                Obx(() =>
                                    GoogleMap(
                                      onMapCreated: controller.onMapCreated,
                                      onTap: (LatLng latLng) {
                                        controller.addMarker(latLng);
                                      },
                                      initialCameraPosition:
                                      controller.kGooglePlex.value,
                                      markers:
                                      controller.markers.values.toSet(),
                                      myLocationEnabled: true,

                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      mapType: MapType.normal,

                                    ),),
                                Align(
                                    alignment: Alignment.bottomCenter,

                                    child: Container(
                                      margin: EdgeInsets.all(5.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(44.r),
                                        color: const Color(0xffF8F2FE),
                                      ),
                                      alignment: Alignment.center,

                                        width:MediaQuery.of(context).size.width,
                                        height: 220.h,

                                        child: Container(
                                          padding: EdgeInsets.all(15.w),


                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(44.r),

                                            color: const Color(0xffF8F2FE),
                                          ),
                                          child: Obx(() {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [
                                                SizedBox(height: 10.h,),
                                                Row(

                                                  children: [
                                                    Icon(Icons.location_on_rounded, color: primaryColor,
                                                      size: 30.h,),
                                                    SizedBox(width: 10.w,),
                                                    Expanded(
                                                      child: AutoSizeText(controller.addressPlace.value, style: secondaryTextStyle(
                                                          size: 15.sp.round(),
                                                          color: primaryColor,
                                                        weight: FontWeight.w500
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w,),


                                                  ],
                                                ),
                                                SizedBox(height: 10.h,),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(left: 40.w),
                                                    child: Text(controller.addressGoventmant.value, style: secondaryTextStyle(
                                                        size: 10.sp.round(),
                                                        color: greyishColor
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(height: 10.h,),
                                                buildFloatingButton(

                                                  buttonName: 'Use Your Current Location', context: context,
                                                  onPressed: () {
                                                    controller.getCurrentLocation(context);

                                                  },

                                                ),

                                              ],
                                            );
                                          }),
                                        ),)),
                              ])))),
                ),
              ),
              CustomAppBar(title: 'Map',
                svgPath: "assets/images/notification.svg",
                myFunction: () {},
              ),
            ],
          ),
        ),
      ),

//       floatingActionButton: Container(
//         padding: EdgeInsets.all(15.w),
//         height: 180.h,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         decoration: BoxDecoration(
//
//           borderRadius: BorderRadius.circular(14.r),
//           color: greyishColor,
//         ),
//         child: Obx(() {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//
//               Row(
//                 children: [
//                   Icon(Icons.not_listed_location_outlined, color: primaryColor,
//                     size: 30.h,),
//                   SizedBox(width: 10.w,),
//                   AutoSizeText(controller.addressPlace.value, style: primaryTextStyle(
//                       size: 18.sp.round(),
//                       color: primaryColor
//                   ),),
//                   SizedBox(width: 10.w,),
//
//                   buildFloatingButton(
//
//                     buttonName: 'Use Your Current Location', context: context,
//                     onPressed: () {
// controller.getCurrentLocation(context);
//
//                     },
//
//                   ),
//                 ],
//               ),
//
//             ],
//           );
//         }),
//       ),
//
//
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }


}
