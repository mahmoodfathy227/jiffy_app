
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/add_address.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';

import '../../global/config/helpers.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

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
            child: Obx(() {
              return
                controller.addressState.value == "empty" ?
                _buildEmptyAddressView(context) :
                _buildAddressListView()


              ;
            }),
          ),
        ],
      ),

      floatingActionButton: buildFloatingButton(

        buttonName: 'Add New Address', context: context,
        onPressed: () {

          print("pressed");
          Get.to(const AddAddress());
        },

      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  _buildEmptyAddressView(context) {
    return Center(
      child: Column(


        children: [

          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height / 7,),
          Image.asset(
            "assets/images/address/empty_address.gif", height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,),
          SizedBox(height: 11.h,),

          Text("Your address book is empty",
            style: secondaryTextStyle(size: 22.sp.round(),
                weight: FontWeight.w700,
                color: Colors.black
            ),),
          SizedBox(height: 10.h,),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 100.w,
            child: Text(
              "Add your preferred delivery address to help us serve you better",
              textAlign: TextAlign.center,
              style: secondaryTextStyle(size: 14.sp.round(),

                  weight: FontWeight.w400, color: greyishColor),),
          ),


        ],
      ),
    );
  }

  _buildAddressListView() {
    return Column(

      children: [

        Text("Your Default Address", style: primaryTextStyle(
            weight: FontWeight.w400,
            size: 18.sp.round(),
          color: secondaryPrimaryColor
        )),
        SizedBox(height: 20.h,),
        Obx(() {
          return ListView.separated(
            shrinkWrap: true,
              itemBuilder: (context, index) => AddressCard(
                address: controller.addressList[index],
                context: context,
              ),
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                height: 0.2,
                color: primaryColor,
              ),
              itemCount: controller.addressList.length
          );
        })
      ],
    );
  }

  AddressCard({required Address address, context}) {
    return Container(

      height: 120.h,
      width: MediaQuery.of(context).size.width - 30.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          customBoxShadow
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         SvgPicture.asset("assets/images/address/address_not_selected.svg"),
SizedBox(width: 20.w,),
          SvgPicture.asset("assets/images/address/home_address.svg"),
          SizedBox(width: 20.w,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.label, style: primaryTextStyle(
                    weight: FontWeight.w700,
                    size: 20.sp.round()
                )),

                Row(
                  children: [
                    AutoSizeText(address.address,
                        style: primaryTextStyle(
                            weight: FontWeight.w400,
                            size: 12.sp.round(),
                            color: accentGreyishColor
                        )
                    ),

Spacer(),

                    SvgPicture.asset("assets/images/address/edit.svg",
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.cover,

                    )
                  ],
                ),

                Row(
                  children: [
                    Text("Phone: ", style: primaryTextStyle(
                        weight: FontWeight.w400,
                        size: 12.sp.round(),
                      color: accentGreyishColor
                    )),
                    Text(address.phone, style: primaryTextStyle(
                        weight: FontWeight.w500,
                        size: 12.sp.round(),
                      color: Colors.black
                    )),
                  ],
                )
                ]
                ),
          ),
   ] ));
  }
}
