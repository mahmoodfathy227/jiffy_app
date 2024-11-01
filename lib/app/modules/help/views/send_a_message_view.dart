import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/app/modules/global/config/helpers.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import '../controllers/help_controller.dart';

class SendAMessageView extends GetView<HelpController> {
  const SendAMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomAppBar(
              myFunction: () {},
              svgPath: "assets/images/notification.svg",
              title: 'Send a Message',
              isHelp: true,

            ),

            ShowUp(
              child: Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: Container(

                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 50.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffFFFFFF),
                        blurRadius: 100,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                        blurStyle: BlurStyle.inner,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),

                  ),
                  child: Column(
                    children: [
                      SizedBox(height: kDefaultPadding,),
                      Text("Contact Us",
                        style: secondaryTextStyle(
                            color: primaryColor,
                            weight: FontWeight.w700,
                            size: 22.sp.round()),),

                      SizedBox(height: kDefaultPadding * 2,),
                      CustomTextField(
                        labelText: "Name",
                        onChanged: (v) {},
customTextEditingController: controller.name,




                      ),
                      userToken == null ?
                      const SizedBox() :   SizedBox(height: 20.h,),
                      Obx(() {
                        return

                          userToken == null ?
                              const SizedBox():
                          Row(
                          children: [
                            Checkbox(value: controller.emailStatus.value,
                              onChanged: (v) {
                                controller.changeEmailStatus(v!);
                              },

                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),),

                            ),
                            Text(
                                "Use Your Email", style: secondaryTextStyle(
                                weight: FontWeight.w400,
                                size: 14.sp.round(),
                                color: Colors.black
                            ))
                          ],
                        );
                      }),
                      SizedBox(height: kDefaultPadding,),
                      Obx(() {
                        return
                          !controller.emailStatus.value ?


                          CustomTextField(
                            initialValue: "",
                              customTextEditingController: controller.email,
                              labelText: "Email", onChanged: (v) {})
                              :
                          SizedBox()
                        ;
                      }),
                      SizedBox(height: kDefaultPadding),
                      CustomTextField(
                        initialValue: "",
                        customTextEditingController: controller.message,

                        labelText: "Write your message",
                        maxLines: 4,
                        onChanged: (v) {},
                        height: 120.h,

                      ),

                      SizedBox(height: kDefaultPadding * 2,),
                      //    Flexible(
                      //      child: Image.asset(
                      //        "assets/images/help/add_attachment.png",
                      // width: 320.w,
                      //        height: 125.h,
                      //        fit: BoxFit.fitHeight,
                      //      ),
                      //    ),
                      // Usage:
                      GestureDetector(
                        onTap: () {
                          _showPicker(context: context);
                        },
                        child: Container(
                          width: 350.w,
                          height: 100.h,
                          child: DottedBorder(

                            color: Colors.black,
                            radius: Radius.circular(12.r),
                            padding: EdgeInsets.all(8),
                            borderType: BorderType.RRect,
                            dashPattern: [
                              10,
                            ],
                            strokeWidth: 1.5,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/help/arrow.gif",
                                    height: 35.h, width: 35.w,),
                                  SizedBox(height: 10.h,),

                                  Text("Add Attachments",
                                      style: secondaryTextStyle(
                                        size: 12.sp.round(),

                                        weight: FontWeight.w400,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return
                          controller.galleryFiles.isNotEmpty ?
                          SizedBox(height: 10.h,)
                              :
                          const SizedBox();
                      }),
                      Obx(() {
                        return
                          controller.galleryFiles.isNotEmpty ?

                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              height: 50,

                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.galleryFiles.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 5.h

                                        ),
                                        decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(
                                              12.r),

                                          color: greyishColor,
                                        ),
                                        width: 100.w,
                                        height: 50.h,
                                        child: Row(
                                          children: [

                                            Image.file(File(controller
                                                .galleryFiles[index]!.path),
                                              width: 50.w, height: 50.h,),
                                            const Spacer(),
                                            IconButton(onPressed: () {
                                              controller.removeFile(controller
                                                  .galleryFiles[index]);
                                            },
                                              icon: Icon(Icons.close,
                                                color: Colors.white,),)
                                          ],
                                        )
                                    )

                                  ;
                                },


                              ),
                            ),
                          )
                              : SizedBox();
                      }),

                      SizedBox(height:


                      controller.emailStatus.value ?

                      kDefaultPadding * 4
                          :

                      kDefaultPadding * 2
                        ,),


                      Obx(() {
                        return

                          controller.errorMessage.value.isEmpty?
                              SizedBox()
                          :
                          Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(controller.errorMessage.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: errorTextStyle),
                        );
                      }),
                      Obx(() {
                        return


                          MyDefaultButton(
                            onPressed: () => controller.sendTicket(),
                            isloading: controller.isLoading.value,
                            btnText: "Send",
                            isSecondaryTextStyle: true,
                            borderRadius: 30.sp,
                            btnWidth: 170,
                            height: 60.h,
                            iconPadding: 15,
                            Icon: "assets/images/help/send.svg",

                          );
                      }),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  controller.getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  controller.getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}




