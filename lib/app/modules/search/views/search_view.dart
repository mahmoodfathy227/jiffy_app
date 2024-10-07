import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../global/widget/widget.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<CustomSearchController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            customSearchBar(),
            _buildCategoryScroll(context),
            _buildFilterScroll(context),
            _buildProductList(context),

          ],
        ),
      ),



    );
  }

  _buildCategoryScroll(BuildContext context) {


  }

  _buildFilterScroll(BuildContext context) {}

  _buildProductList(BuildContext context) {}


}
