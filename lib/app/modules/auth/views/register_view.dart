
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/config/configs.dart';
import '../../global/config/helpers.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import '../../help/views/help_view.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController controller = Get.put(AuthController());
  bool isCompany = false;
String randomId = "123";

  @override
  Widget build(BuildContext context) {

    Widget registerForm(BuildContext context) {
      return Obx(() {
        return Column(

          children: [


            ShowUp(

              delay: 200,
              child: SizedBox(
                width: 326.w,
                child: Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(
                      weight: FontWeight.w800,
                      size: 30.sp.round(),
                      color: primaryColor
                  ),


                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 55.h,
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(35),
                ),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isCompany = false;
                          randomId = Random().nextInt(10000).toString();
                          controller.setUser("user");
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          gradient:
                          !isCompany ?

                          const LinearGradient(
                            colors: [
                              Color(0xFF6900CC), // Starting color (dark purple)
                              Color(0xFF20003D), // Ending color (light purple)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ) : null, // Dark purple background
                          borderRadius: BorderRadius.all(
                            Radius.circular(35),
                          ),
                        ),
                        child: Text(
                          'Individual',
                          style: primaryTextStyle(
                              size: 16.sp.round(),
                              weight: !isCompany ? FontWeight.w900 : FontWeight
                                  .w300,
                              color: !isCompany ? Colors.white : primaryColor
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isCompany = true;
                          randomId = Random().nextInt(10000).toString();
                          controller.setUser("dealer");
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          gradient:
                          isCompany ?

                          const LinearGradient(
                            colors: [
                              Color(0xFF6900CC), // Starting color (dark purple)
                              Color(0xFF20003D), // Ending color (light purple)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ) : null,
                          // Light purple background
                          borderRadius: BorderRadius.all(
                            Radius.circular(35),
                          ),
                        ),
                        child: Text(
                            'Company',
                            style: primaryTextStyle(
                                size: 16.sp.round(),
                                weight: isCompany ? FontWeight.w900 : FontWeight
                                    .w300,
                                color: !isCompany ? primaryColor : Colors.white
                            )

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 41.h),
         buildRegisterFields(context),

          ],
        );
      });
    }

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowUp(
                    delay: 200,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: GestureDetector(
                            onTap: (){
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 20,
                                    offset:
                                    Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/images/back_btn.svg",
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width / 5),
                        SvgPicture.asset(
                          LOGO,
                          width: 41.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(()=> const HelpView());
                          },
                          child: ConstrainedBox(

                              constraints: BoxConstraints(

                                  maxWidth: 100.w,
                                  maxHeight: 50.h
                              ),
                              child: Container(

                                width: 80.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    color:   Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ]
                                ),
                                child: Row(

                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/help.svg',
                                        width: 20.w,
                                        height: 20.h,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 5.w,),
                                      Text("Help",
                                        style: secondaryTextStyle(
                                          weight: FontWeight.w500,
                                          size: 12.sp.round(),
                                        ),
                                      )

                                    ]),
                              )


                          ),
                        ),
                        SizedBox(width: 10.w,)
                      ],
                    )),

                registerForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRegisterFields(BuildContext context) {
    return Column(
      key: Key(randomId),
      children: [
        SizedBox(
            width: 310.w,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 2,
                      child: ShowUp(
                        delay: 400,
                        child: CustomTextField(
                          labelText: 'First Name',
                          onChanged: (value) =>
                          controller.firstName.value = value,
                          errorText:  controller.firstNameError.value,
                        ),
                      )),
                  SizedBox(width: 20.w),
                  Flexible(
                      flex: 2,
                      child: ShowUp(
                        delay: 400,
                        child: CustomTextField(
                          labelText: 'Last Name',
                          onChanged: (value) =>
                          controller.lastName.value = value,
                          errorText: controller.lastNameError.value,
                        ),
                      ))
                ])),
    SizedBox(height: 25.h),
        isCompany
            ? ShowUp(
          delay: 600,
          child: CustomTextField(

            labelText: 'Company Name',
            onChanged: (value) => controller.company.value = value,
            errorText: controller.companyError.value ,
          ),
        ) :
        const SizedBox(),


        isCompany
            ?         SizedBox(height: 20.h) :
        SizedBox()
        ,
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Your Email',
            onChanged: (value) => controller.email.value = value,
            errorText: controller.emailError.value ,
          ),
        ),
        SizedBox(height: 25.h),
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Password',
            onChanged: (value) => controller.password.value = value,
            errorText: controller.passwordError.value ,
            obscureText: true,
          ),
        ),
        SizedBox(height: 25.h),
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Confirm Password',
            onChanged: (value) => controller.confirmPassword.value = value,
            errorText: controller.confirmPasswordError.value ,
            obscureText: true,
          ),
        ),
        SizedBox(height: 25.h),
     ShowUp(
          delay: 800,
          child: MyDefaultButton(
            errorText: controller.errorMessage.value,
            isloading: controller.isLoading.value,
            btnText: 'Sign up',
            onPressed: () => controller.register(),
          ),
        ),
        SizedBox(height: 15.h),
        ShowUp(
          delay: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                textAlign: TextAlign.center,
                style: primaryTextStyle(
                  color: Color(0xFF555662),
                  size: 13.sp.round(),
                  weight: FontWeight.w400,


                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.clearFields();
                  Get.to(() => LoginView());
                },
                child: Text(
                  'Log in',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(
                    color: primaryColor,
                    size: 13.sp.round(),
                    weight: FontWeight.w400,

                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 25.h),

        Row(
          children: [

            Expanded(
              child: Container(
                height: 1,

                color: Colors.grey[300],
              ),
            ),
            SizedBox(width: 10.w,),
            Text("Sign up with", style: primaryTextStyle(
                weight: FontWeight.w400,
                size: 16.sp.round(),
                color: Color(0xff10001F)
            ),),
            SizedBox(width: 10.w,),
            Expanded(
              child: Container(
                height: 1,

                color: Colors.grey[300],
              ),
            )
          ],
        ),
        SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width - 60.w,
          height: 80.h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 55.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/facebook.svg", color: Colors.blue,),
                        SizedBox(width: 10.w,),
                        Text("Facebook",
                          style: primaryTextStyle(color: Colors.black,
                              size: 15.sp.round(), weight: FontWeight.w300
                          ),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 55.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/google.svg"),
                        SizedBox(width: 10.w,),
                        Text("Google", style: primaryTextStyle(
                            color: Colors.black,
                            size: 15.sp.round(), weight: FontWeight.w300),),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        )

      ],
    );
  }

}
