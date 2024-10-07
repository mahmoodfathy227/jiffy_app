import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart' hide FormData;
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../main.dart';
import '../../global/widget/widget.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<CustomSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CustomSearchController());
    return Scaffold(

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                customSearchBar(),

                Obx(() {
                  return AnimatedPadding(
                    padding: EdgeInsets.only(top:
                        customSearchController.isExpanded.value ? 260.h :

                    200.h
                    ),
                    duration: Duration(milliseconds: 400),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          SizedBox(height: 25.h,),
                          _buildProductGrid(context),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),


    );
  }

  customSearchBar() {
    return Obx(() {
      return AnimatedContainer(
          duration: Duration(milliseconds: 200),

          height: customSearchController.isExpanded.value ? 260.h : 195.h,

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),

          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 22,
                                offset: Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ]
                        ),
                        child: SvgPicture.asset(
                          "assets/images/back_btn.svg",
                          width: 78.h,
                          fit: BoxFit.cover,

                        ),
                      ),
                    ),

                    customSearchField(),

                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 22,
                              offset: Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ]
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/filter.svg",
                        width: 78.h,
                        fit: BoxFit.cover,

                      ),
                    ),
                  ],
                ),

                Obx(() {
                  return Container(

                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
                    child: AnimatedPadding(

                      padding: EdgeInsets.only(
                          left: customSearchController.isExpanded.value
                              ? 15.w
                              : 4.w,
                          top: customSearchController.isExpanded.value
                              ? 15.h
                              : 4.h
                      ),
                      duration: const Duration(milliseconds: 250),
                      child: SizedBox(

                          height: 85.h,

                          child:
                          CategoryScroll()

                      ),
                    ),
                  );
                }),
                Obx(() {
                  return
                    customSearchController.isExpanded.value ?

                    FadeInFilterBar() :
                    SizedBox();
                })


              ],
            ),
          )
      );
    });
  }


  _buildProductGrid(BuildContext context) {
    return Obx(() {
      return AnimatedPadding(

        padding: EdgeInsets.symmetric(horizontal: 20.w),
        duration: Duration(milliseconds: 600),
        child:
        customSearchController.isProductsLoading.value ?
        Skeletonizer(

          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              // width / height: fixed for *all* items
              childAspectRatio: (1 / 1.8),
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return placeHolderProductCard();
            },
          ),
        )
            :

        GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            // width / height: fixed for *all* items
            childAspectRatio: (1 / 1.8),
          ),
          itemCount: customSearchController.filteredProducts.length,
          itemBuilder: (context, index) {
            return globalProductCard(
                customSearchController.filteredProducts[index], index);
          },
        ),
      );
    });
  }


}

class FadeInFilterBar extends StatefulWidget {
  @override
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInFilterBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(top: 15.h),
      duration: Duration(milliseconds: 200),
      child: Center(
        child: FadeTransition(
          opacity: _animation,
          child: SizedBox(
            height: 50.h,
            child: ListView(

              scrollDirection: Axis.horizontal,


              children: [
                SizedBox(width: 30.w,),
                MyDefaultButton(
                  onPressed: () {
                    customSearchController.reset();
                  },
                  isloading: false,
                  borderRadius: 30.r,
                  height: 40.h,
                  btnWidth: 75,
                  btnText: 'Clear',
                  isSecondaryTextStyle: false,


                ),
                SizedBox(width: 10.w,),

                _buildPriceFilter(),
                SizedBox(width: 10.w,),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (itemBuilder, index) =>
                          filterItem(context, index),
                      separatorBuilder: (itemBuilder, index) =>
                          SizedBox(width: 20.w,),
                      itemCount: customSearchController.filterItems.length),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  filterItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // search in products based on filter item

// convert the string to snake case
        String convertToUnderscore(String input) {
          List<String> words = customSearchController.filterItems[index]
              .toLowerCase()
              .split(' ');
          String result = '';
          for (var i = 0; i < words.length; i++) {
            if (i > 0) {
              result += '_';
            }
            result += words[i];
          }

          return result;
        }

        print("filter items is ${convertToUnderscore(
            customSearchController.filterItems[index])}");
        Map<String, dynamic> bodyRequest = {
          'orderBy': convertToUnderscore(
              customSearchController.filterItems[index]),
        };
        customSearchController.selectFilter(
            customSearchController.filterItems[index]);
        customSearchController.getProducts(bodyRequest);
      },
      child: Obx(() {
        return Text(customSearchController.filterItems[index], style:
        primaryTextStyle(
          color: customSearchController.selectedFilter.value ==
              customSearchController.filterItems[index]
              ? primaryColor
              : Colors.grey[300],
          size: 15.sp.round(),
        ),);
      }),
    );
  }

  _buildPriceFilter() {
    return Obx(() {
      return Row(
        children: [
          Text('Price', style: secondaryTextStyle(),),
          SizedBox(width: 5.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Adjust as needed
            children: [
              GestureDetector(
                onTap: () {
                  // search in products based on asc price


                  Map<String, dynamic> bodyRequest = {
                    'orderBy': 'high-low',
                  };
                  customSearchController.isHighToLowFilter.toggle();
                  customSearchController.getProducts(bodyRequest);
                },
                child: Icon(Icons.keyboard_arrow_up_outlined, size: 20,
                  color: customSearchController.isHighToLowFilter.value
                      ? primaryColor
                      : Colors.grey[300],),
              ),
              GestureDetector(
                onTap: () {
                  // search in products based on desc price


                  Map<String, dynamic> bodyRequest = {
                    'orderBy': 'low-high',
                  };
                  customSearchController.isHighToLowFilter.toggle();
                  customSearchController.getProducts(bodyRequest);
                },
                child: Icon(Icons.keyboard_arrow_down_outlined, size: 20,
                  color: customSearchController.isHighToLowFilter.value
                      ? Colors.grey[300]
                      : primaryColor,),
              ),

            ],
          )
        ],
      );
    });
  }
}

class CategoryScroll extends StatefulWidget {
  @override
  _ScaleTransitionDemoState createState() => _ScaleTransitionDemoState();
}

class _ScaleTransitionDemoState extends State<CategoryScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.7, end:
    1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCirc,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(

          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              _buildSingleCategoty(context, index),
          separatorBuilder: (context, index) =>
              SizedBox(height: 5.w,),
          itemCount: customSearchController.categories.length);
    });
  }

  _buildSingleCategoty(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // search in products based on category
        //toggle the value of selected Category

        if (customSearchController.isExpanded.value) {
          customSearchController.isExpanded.toggle();
          print("the value is 1 {${customSearchController.isExpanded.value}}");
        } else {
          customSearchController.isExpanded.toggle();
          print("the value is  2{${customSearchController.isExpanded.value}}");
          var bodyRequest = {
            "category_ids[0]": customSearchController.categories[index].id
                .toString(),
          };
          print("cat id is ${customSearchController.categories[index].id}");
          customSearchController.toggleSelectedCategory(
              customSearchController.categories[index].name);
          customSearchController.getProducts(bodyRequest);
        }
      },
      child: SizedBox(

        width: customSearchController.isExpanded.value ? 175.w : 160.w,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [

                      ClipOval(

                        child: AnimatedContainer(

                          // 3. pass the state variables as arguments
                          width: customSearchController.isExpanded.value
                              ? 65.h
                              : 55
                              .h,
                          height: customSearchController.isExpanded.value
                              ? 65.h
                              : 55
                              .h,
                          duration: const Duration(milliseconds: 250),
                          child: CachedNetworkImage(
                            imageUrl: customSearchController.categories[index]
                                .image!,

                            fit: BoxFit.cover,
                          ),
                        ),


                      ),

                      SizedBox(width: 5.w,),

                      AnimatedContainer(
                        // 3. pass the state variables as arguments
                        width: customSearchController.isExpanded.value
                            ? 90.w
                            : 80.w,
                        duration: Duration(milliseconds: 250),
                        child: SizedBox(

                          child: Text(
                            customSearchController.categories[index].name!,
                            style: secondaryTextStyle(
                                size: 13.sp.round(),
                                color:
                                customSearchController.categories[index].name ==
                                    customSearchController.selectedCategory
                                        .value ?
                                primaryColor :
                                Colors.grey
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    ],
                  ),
                  customSearchController.selectedCategory.value ==
                      customSearchController.categories[index].name ?
                  Container(
                    width: 4.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor
                    ),
                  ) :
                  SizedBox()
                  ,
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}