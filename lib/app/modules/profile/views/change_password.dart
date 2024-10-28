import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
            child: Column(
          children: [
            SizedBox(
              height: 550.h,
              child: Stack(
                children: [
                  CustomAppBar(
                    myFunction: () {},
                    title: "Change Password",
                  ),
                  Positioned(
                    bottom: 0.h,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: changePasswordForm(),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    ));
  }

  Widget changePasswordForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          labelText: 'Old Password',
          onChanged: (value) {
            controller.oldPassword.value = value;
            controller.validatePassword(value);
          },
          errorText: controller.passwordError.value.isEmpty
              ? null
              : controller.passwordError.value,
          obscureText: true,
        ),
        SizedBox(height: 30.h),
        CustomTextField(
          labelText: 'New Password',
          onChanged: (value) {
            controller.newPassword.value = value;
            controller.validateNewPassword(value);
          },
          errorText: controller.newPasswordError.value.isEmpty
              ? null
              : controller.newPasswordError.value,
          obscureText: true,
        ),
        SizedBox(height: 30.h),
        CustomTextField(
          labelText: 'Confirm Password',
          onChanged: (value) {
            controller.confirmPassword.value = value;
            controller.validateConfirmPassword(
                value, controller.newPassword.value);
          },
          errorText: controller.confirmPasswordError.value.isEmpty
              ? null
              : controller.confirmPasswordError.value,
          obscureText: true,
        ),
        SizedBox(height: 30.h),
        Obx(
          () => JiffyDefaultButton(
            onPressed: () {
              bool isOldPasswordValid =
                  controller.validatePassword(controller.oldPassword.value);
              bool isNewPasswordValid =
                  controller.validateNewPassword(controller.newPassword.value);
              bool isConfirmPasswordValid = controller.validateConfirmPassword(
                  controller.confirmPassword.value,
                  controller.newPassword.value);

              if (isOldPasswordValid &&
                  isNewPasswordValid &&
                  isConfirmPasswordValid) {
                var data = {
                  'old_password': controller.oldPassword.value,
                  'password': controller.newPassword.value,
                  'password_confirmation': controller.confirmPassword.value,
                };
                controller.updatePassword(data);
                controller.oldPassword.value = '';
                controller.newPassword.value = '';
                controller.confirmPassword.value = '';
              }
            },
            width: 325.w,
            height: 64.w,
            btnText: 'Update Password',
            isloading: controller.isLoading.value,
          ),
        )
      ],
    );
  }
}
