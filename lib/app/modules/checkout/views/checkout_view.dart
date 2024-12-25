import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/controllers/address_controller.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../address/model/address_model.dart';
import '../../address/views/address_view.dart';
import '../../global/config/helpers.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
   AddressController addressController = Get.put(AddressController());
   addressController.changeAddressStatus(true);
    return Scaffold(
body: AddressView(isFromAddress: false,),

    );
  }

}
