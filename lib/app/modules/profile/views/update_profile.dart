import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For formatting date

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final ProfileController controller = Get.put(ProfileController());
  TextEditingController dobController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (controller.userModel.value.dob != null &&
        controller.userModel.value.dob!.isNotEmpty) {
      selectedDate = DateTime.parse(controller.userModel.value.dob!);
      dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    } else {
      selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280.h,
                  child: Stack(
                    children: [
                      CustomAppBar(
                        myFunction: () {},
                        title: "Edit Profile",
                      ),
                      Positioned(
                        bottom: 0.h,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: _buildProfileHeader(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                _buildUpdateInfoForm(),
                // SizedBox(height: 20.h),
                // MySecondDefaultButton(
                //   onPressed: () {
                //     Get.to(() => ChangePasswordScreen());
                //   },
                //   btnText: 'Change Password',
                // ),
              ],
            ),
          );
        }
      }),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                  padding: EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.black12),
                      shape: BoxShape.circle),
                  child: Icon(Icons.delete_forever,
                      color: Colors.white, size: 24.sp)),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300.w,
                      child: Text(
                          'Are you sure you want to delete your account?',
                          style: primaryTextStyle(
                              size: 18.sp.round(), weight: FontWeight.w600))),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        controller.deleteAccount();
                        Get.back();
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('Yes',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('No',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();

  onPickImage() async {
    imagesSourcesShowModel(
      context: context,
      onCameraPressed: () => _onCameraTapped(),
      onGalleryPressed: () => _onGalleryTapped(),
    );
  }

  _onCameraTapped() async {
    Navigator.pop(context);
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
    );
    if (!mounted) return;
    if (xImage != null) {
      avatarImageFile = File(xImage.path);
      controller.updatePhoto(avatarImageFile!.path);
    }
  }

  File? avatarImageFile;
  _onGalleryTapped() async {
    Navigator.pop(context);
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );
    if (!mounted) return;
    if (xImage != null) {
      avatarImageFile = File(xImage.path);
      controller.updatePhoto(avatarImageFile!.path);
    }
  }

  Widget _buildProfileHeader() {
    return Column(children: [
      SizedBox(
          width: 103.11.w,
          height: 108.97.h,
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000), // لون الظل
                        blurRadius: 20, // نصف قطر التمويه للظل
                        offset: Offset(0, 4), // انزياح الظل
                        spreadRadius: 0, // انتشار الظل
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48.r,
                    backgroundImage: controller.userModel.value.photo == null ||
                            controller.userModel.value.photo!.isEmpty
                        ? const AssetImage(
                            'assets/images/profile/profile_placeholder.png')
                        : null,
                    child: controller.userModel.value.photo == null ||
                            controller.userModel.value.photo!.isEmpty
                        ? null
                        : CachedNetworkImage(
                            imageUrl: controller.userModel.value.photo!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 48.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/profile/profile_placeholder.png'),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 22.r,
                                ),
                              ),
                            ),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 46.r,
                              backgroundImage: imageProvider,
                            ),
                          ),
                  )),
            ],
          )),
      SizedBox(
        height: 10.h,
      ),
      InkWell(
          onTap: () => onPickImage(),
          child: Container(
            width: 163.w,
            height: 34.h,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.00, 0.04),
                end: Alignment(-1, -0.04),
                colors: [
                  Color(0xFF20003D),
                  Color(0xFF6900CC),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(43),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x4C000000),
                  blurRadius: 30,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Update Your Photo',
                  style: primaryTextStyle(
                    color: Colors.white,
                    size: 14.sp.round(),
                    weight: FontWeight.w500,
                    letterSpacing: -0.41,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SvgPicture.asset(
                  'assets/images/profile/camera.svg',
                  width: 16.w,
                  height: 16.h,
                ),
              ],
            ),
          )),
    ]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        controller.userModel.value.dob = dobController.text;
      });
    }
  }

  BoxShadow customBoxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  );
  Widget _buildUpdateInfoForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              ShowUp(
                delay: 400,
                child: CustomTextField(
                  initialValue: controller.userModel.value.firstName,
                  labelText: 'First Name',
                  onChanged: (value) =>
                      controller.userModel.value.firstName = value,
                  errorText: controller.firstNameError.value.isEmpty
                      ? null
                      : controller.firstNameError.value,
                ),
              ),
              SizedBox(height: 20.h),
              ShowUp(
                delay: 400,
                child: CustomTextField(
                  initialValue: controller.userModel.value.lastName,
                  labelText: 'Last Name',
                  onChanged: (value) =>
                      controller.userModel.value.lastName = value,
                  errorText: controller.lastNameError.value.isEmpty
                      ? null
                      : controller.lastNameError.value,
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                initialValue:
                    controller.userModel.value.phone ?? '(+961) 123321',
                labelText: 'Phone',
                onChanged: (value) => controller.userModel.value.phone = value,
                errorText: controller.phoneError.value.isEmpty
                    ? null
                    : controller.phoneError.value,
              ),
              SizedBox(height: 20.h),
              ShowUp(
                  delay: 400,
                  child: Container(
                      height: 55.h,
                      width: 320.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [customBoxShadow],
                      ),
                      child: TextFormField(
                        controller: dobController,
                        readOnly: true,
                        style: secondaryTextStyle(
                          color: Colors.black,
                          size: 14.sp.round(),
                          weight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: primaryColor,
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
                          labelText: 'Date of Birth',
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                          ),
                        ),
                        onTap: () => _selectDate(context),
                      ))),
              SizedBox(height: 20.h),
              Container(
                  width: 324.w,
                  height: 52.h,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFF4141),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                        spreadRadius: -10,
                      )
                    ],
                  ),
                  child: InkWell(
                      onTap: () {
                        _showDeleteConfirmation(context, controller);
                      },
                      child: Center(
                        child: Text(
                          'Delete Account',
                          style: secondaryTextStyle(
                            color: Colors.white,
                            size: 14.sp.round(),
                            weight: FontWeight.w400,
                          ),
                        ),
                      ))),
              SizedBox(height: 40.h),
              InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CHANGEPASSWORD);
                  },
                  child: Container(
                      width: 181.w,
                      height: 64.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF6900CC)),
                          borderRadius: BorderRadius.circular(43),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x4C000000),
                            blurRadius: 150,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Change Password ',
                          style: primaryTextStyle(
                            color: Color(0xFF4F0099),
                            size: 18.sp.round(),
                            weight: FontWeight.w500,
                            letterSpacing: -0.41,
                          ),
                        ),
                      ))),
              SizedBox(height: 20.h),
              JiffyDefaultButton(
                onPressed: () {
                  bool isFirstNameValid = controller
                      .validateFirstName(controller.userModel.value.firstName!);
                  bool isLastNameValid = controller
                      .validateLastName(controller.userModel.value.lastName!);
                  // bool isPhoneValid = controller
                  //     .validatePhone(controller.userModel.value.phone!);
                  // bool isDobValid = controller.validateDob(dobController.text);

                  if (isFirstNameValid && isLastNameValid) {
                    var data = controller.userModel.value.toJson();
                    controller.updateUserProfile(data);
                  } else {
                    // Trigger UI updates to show error messages
                    setState(() {});
                  }
                },
                btnText: 'Update',
                isloading: controller.isLoading.value,
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
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
              SizedBox(height: 20.h),
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
              SizedBox(height: 20.h),
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
              SizedBox(height: 121.h),
              MySecondDefaultButton(
                onPressed: () {
                  bool isOldPasswordValid =
                      controller.validatePassword(controller.oldPassword.value);
                  bool isNewPasswordValid = controller
                      .validateNewPassword(controller.newPassword.value);
                  bool isConfirmPasswordValid =
                      controller.validateConfirmPassword(
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
                  } else {
                    // Trigger UI updates to show error messages
                    setState(() {});
                  }
                },
                isloading: controller.isLoading.value,
                btnText: 'Change Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
