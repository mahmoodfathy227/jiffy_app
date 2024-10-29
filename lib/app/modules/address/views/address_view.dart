import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/add_address.dart';
import 'package:jiffy/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:jiffy/app/modules/checkout/views/payment_method.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';

import '../../global/config/helpers.dart';
import '../controllers/address_controller.dart';
import 'edit_address.dart';

class AddressView extends GetView<AddressController> {
  AddressView({super.key, this.isFromCheckout = false,});

  final bool isFromCheckout;


  @override
  Widget build(BuildContext context) {
    print("idFromCheckout $isFromCheckout");
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
            padding: EdgeInsets.only(top: 160.h),
            child: Obx(() {
              return
                controller.isLoading.value ?
                const Center(child: CircularProgressIndicator(),)

                    :
                controller.addressList.isEmpty ?
                _buildEmptyAddressView(context) :
                _buildAddressListView(context)


              ;
            }),
          ),
        ],
      ),

      floatingActionButton: buildFloatingButton(


        buttonName: isFromCheckout ?
        controller.addressList.isEmpty ?
        'Add New Address' :
        'Select Address' :

        'Select Address',
        context: context,
        onPressed: () {
          if (controller.addressList.isEmpty) {
            Get.to(()=>const AddAddress() );

          } else {
            var defaultAddressId = controller.addressList.where( (address) => address.isDefault == 1).first;
            CheckoutController checkoutController = Get.put(CheckoutController());
            checkoutController.assignDefaultAddress(defaultAddressId.id.toString());
            Get.to(()=>const PaymentMethod() );

          }
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

  _buildAddressListView(context) {
    return SizedBox(
      height: MediaQuery
          .sizeOf(context)
          .height - 300.h,
      child: SingleChildScrollView(
        child: Column(

          children: [

            Text("Your Default Address", style: primaryTextStyle(
                weight: FontWeight.w400,
                size: 18.sp.round(),
                color: secondaryPrimaryColor
            )),
            SizedBox(height: 20.h,),
            Obx(() {
              return ListView.separated(

                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      AddressCard(
                        address: controller.addressList[index],
                        context: context,
                      ),
                  separatorBuilder: (context, index) =>
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        height: 0.2,
                        color: primaryColor,
                      ),
                  itemCount: controller.addressList.length
              );
            }),

            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  AddressCard({required Address address, context}) {
    return GestureDetector(
      onTap: () {
        controller.setDefaultAddress(address.id);
      },
      child: Container(

          height: 130.h,
          width: MediaQuery
              .of(context)
              .size
              .width - 30.w,
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
                SvgPicture.asset(
                    address.isDefault == 1
                        ? "assets/images/address/address_selected.svg"
                        :
                    "assets/images/address/address_not_selected.svg"),

                SizedBox(width: 20.w,),
                SvgPicture.asset("assets/images/address/home_address.svg"),
                SizedBox(width: 20.w,),

                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address.label ?? "Home", style: primaryTextStyle(
                            weight: FontWeight.w700,
                            size: 20.sp.round()
                        )),

                        Row(
                          children: [
                            AutoSizeText(address.address ?? "Address",
                                style: primaryTextStyle(
                                    weight: FontWeight.w400,
                                    size: 12.sp.round(),
                                    color: accentGreyishColor
                                )
                            ),

                            Spacer(),
                            SizedBox(width: 15.w,),
                            GestureDetector(
                                onTap: () {
                                  _showDeleteDialog(context, address);
                                },
                                child: Icon(
                                  Icons.delete, color: primaryColor,)),
                            SizedBox(width: 15.w,),
                            GestureDetector(
                              onTap: () {
                                Get.to(EditAddress(address));
                              },
                              child: SvgPicture.asset(
                                "assets/images/address/edit.svg",
                                width: 30.w,
                                height: 30.h,
                                fit: BoxFit.cover,

                              ),
                            ),


                          ],
                        ),

                        Row(
                          children: [
                            Text("Phone: ", style: primaryTextStyle(
                                weight: FontWeight.w400,
                                size: 12.sp.round(),
                                color: accentGreyishColor
                            )),
                            Text(address.phone ?? "Phone",
                                style: primaryTextStyle(
                                    weight: FontWeight.w500,
                                    size: 12.sp.round(),
                                    color: Colors.black
                                )),
                          ],
                        )
                      ]
                  ),
                ),
              ])),
    );
  }

  void _showDeleteDialog(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the delete action
                controller.deleteAddress(address.id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
