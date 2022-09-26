import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/Ads.dart';
import 'package:findout/Model/homeclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/PageView/PageView1.dart';
import 'package:findout/internet.dart';
import 'package:findout/provider/findout_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState() {
    initPlatformState();

    super.initState();
    var findprov = Provider.of<FindoutProvider>(context, listen: false);
    findprov.get_adv(findprov.token, context);

    // sv=findprov.cities_list[0].cities![0].title!;
  }

  var _systemV;

  Future<void> initPlatformState() async {
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _systemV = iosInfo.name;
      if (kDebugMode) {
        print('Running on ${iosInfo.name}');
      }
    }
  }

  final List<String> RegionItems = [
    'Male',
    'Female',
  ];
  final List<Cities> CityItems = [
    // 'Male',
    // 'Female',
  ];
  late String sv;
  AreaCities? selectedValue;
  Cities? selectedValue2;
  int touchedIndex = -1;
  final _formKey = GlobalKey<FormState>();
  List<CarouselItem> itemList = [
    CarouselItem(
      image: const NetworkImage(
        'https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200',
      ),
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            Colors.blueAccent.withOpacity(1),
            Colors.black.withOpacity(.3),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      title:
          'Push your creativity to its limits by reimagining this classic puzzle!',
      titleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      leftSubtitle: '\$51,046 in prizes',
      rightSubtitle: '4882 participants',
      rightSubtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
      onImageTap: (i) {},
    ),
    CarouselItem(
      image: const NetworkImage(
        'https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200',
      ),
      title: '@coskuncay published flutter_custom_carousel_slider!',
      titleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      leftSubtitle: '11 Feb 2022',
      rightSubtitle: 'v1.0.0',
      onImageTap: (i) {},
    ),
  ];
  final _controller = LoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:  Consumer<FindoutProvider>(
          builder: (context, findprov, child) =>
              SingleChildScrollView(
                child: Column(
            children: [
                SizedBox(
                  height: 5.h,
                ),
                _systemV == "iPhone 13 Pro Max" ||
                        _systemV == "iPhone 13 Pro" ||
                        _systemV == "iPhone 13 mini" ||
                        _systemV == "iPhone 13" ||
                        _systemV == "iPhone 12" ||
                        _systemV == "iPhone 12 mini" ||
                        _systemV == "iPhone 12 Pro" ||
                        _systemV == "iPhone 12 Pro Max" ||
                        _systemV == "iPhone 11" ||
                        _systemV == "iPhone 11 Pro" ||
                        _systemV == "iPhone 11 Pro Max"
                    ? SizedBox(
                        height: 15.h,
                      )
                    : Container(),
                WidgetAppBar().AppBarHome(context, true),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: findprov.itemList.length == 0
                      ? Container(
                          height: 200,
                        )
                      : CustomCarouselSlider(
                          items: findprov.itemList,
                          height: 200,
                          subHeight: 50,
                          width: width,
                          autoplay: true,
                          showText: false,
                          showSubBackground: false,
                          indicatorShape: BoxShape.circle,
                          selectedDotColor: AppColors.blueWColor,
                          unselectedDotColor: Colors.white,
                        ),
                ),
                SizedBox(height: 10.h,),
                // Padding(
                //   padding: const EdgeInsets.only(left: 25.0, right: 25),
                //   child: Row(
                //     children: [
                //       Text(
                //         'chose'.tr(),
                //         style: TextStyle(
                //           fontFamily: 'Cairo',
                //           fontSize: 14.sp,
                //           color: AppColors.blackColor,
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(15.0),
                        // padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color:Colors.black45,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30.0.h,
                        width: 240.w,
                        child: DropdownButton<AreaCities>(
                          items: findprov.cities_list.map((item) => DropdownMenuItem<AreaCities>(
                            value: item,
                            child: Text(
                              item.title!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          )).toList(),
                          value: selectedValue,
                          isExpanded: true,
                          hint: Center(
                            child: Text(
                              'chose'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.blueW2Color,
                          ),
                          iconSize: 30,
                          elevation: 16,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          underline: Container(
                            height: 0,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as AreaCities?;
                              CityItems.clear();
                              CityItems.addAll(selectedValue!.cities!);
                              selectedValue2=selectedValue!.cities![0];
                              print(selectedValue2!.title.toString());
                            });
                            setState(() {
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Image.asset(
                          "assets/images/right.png",
                          width: 15.w,
                          height: 15.h,
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 25.0, right: 25),
                //   child: Row(
                //     children: [
                //       Text(
                //         'chose2'.tr(),
                //         style: TextStyle(
                //           fontFamily: 'Cairo',
                //           fontSize: 14.sp,
                //           color: AppColors.blackColor,
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.h,),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(15.0),
                        // padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color:Colors.black45,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30.0.h,
                        width: 240.w,
                        child: DropdownButton<Cities>(
                          items: CityItems.map((Cities value) {
                            return DropdownMenuItem<Cities>(
                              value: value,
                              child: Text(value.title!),
                            );
                          }).toList(),
                          value: selectedValue2,
                          isExpanded: true,
                          hint: Center(
                            child: Text(
                              'chose2'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.blueW2Color,
                          ),
                          iconSize: 30,
                          elevation: 16,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          underline: Container(
                            height: 0,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (v) {
                            print("nnnn"+v.toString());
                            setState(() {
                              selectedValue2 = v;
                            });
                          },
                        ),
                      ),


                      SizedBox(
                        width: 15.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Image.asset(
                          "assets/images/right.png",
                          width: 15.w,
                          height: 15.h,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10.w,),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'chose2'.tr(),
                //         style: TextStyle(
                //           fontFamily: 'Cairo',
                //           fontSize: 14.sp,
                //           color: AppColors.blackColor,
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                //   child: Row(
                //          children: [
                //            SizedBox(
                //              height: 70.0,
                //              width: width/1.2,
                //              child: DropdownButtonFormField2(
                //                decoration: InputDecoration(
                //                  //Add isDense true and zero Padding.
                //                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                //                  isDense: true,
                //                  contentPadding: EdgeInsets.zero,
                //                  border: OutlineInputBorder(
                //                    borderRadius: BorderRadius.circular(10),
                //                  ),
                //                  //Add more decoration as you want here
                //                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                //                ),
                //                isExpanded: true,
                //                hint: Center(
                //                  child: Text(
                //                    'chose2'.tr(),
                //                    style: TextStyle(
                //                      fontSize: 14.sp,
                //                      fontFamily: 'Cairo',
                //                    ),
                //                  ),
                //                ),
                //                icon: const Icon(
                //                  Icons.arrow_drop_down,
                //                  color: AppColors.blueW2Color,
                //                ),
                //                iconSize: 30,
                //                buttonHeight: 40,
                //                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                //                dropdownDecoration: BoxDecoration(
                //                  color: AppColors.whiteColor,
                //                  borderRadius: BorderRadius.circular(10),
                //                ),
                //                items: CityItems.map((item) => DropdownMenuItem<Cities>(
                //                  //_value1.isNotEmpty ? _value1 : null,
                //                      value: item,
                //                      child: Text(
                //                        item.title!,
                //                        style: const TextStyle(
                //                          fontSize: 14,
                //                          fontFamily: 'Cairo',
                //                        ),
                //                      ),
                //                    )).toList(),
                //                validator: (value) {
                //                  if (value == null) {
                //                    return 'chose2'.tr();
                //                  }
                //                },
                //                onChanged: (value) {
                //                  selectedValue2 = value as Cities? ;
                //                  //Do something when changing the item if you want.
                //                },
                //                onSaved: (value) {
                //                  // selectedValue2 = value.toString();
                //                },
                //              ),
                //            ),
                //            SizedBox(width: 15.w,),
                //
                //            Padding(
                //              padding: const EdgeInsets.only(bottom: 20.0),
                //              child: Image.asset("assets/images/right.png",width: 15.w,height: 15.h,),
                //            ),
                //          ],
                //        ),
                // ),
                SizedBox(height: 10.h,),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                                if (kDebugMode) {
                                  print(touchedIndex);
                                }
                                findprov.redrawchart(
                                    findprov.main_cat_list, touchedIndex);
                                findprov.searchcount(
                                    findprov.token,
                                    selectedValue!,
                                    selectedValue2!,
                                    findprov.main_cat_list[touchedIndex],
                                    context);
                                setState(() {});
                              });
                            }),
                            borderData: FlBorderData(
                              show: true,
                            ),
                            sectionsSpace: 25,
                            centerSpaceRadius: 70,
                            sections:
                                findprov.pieChartsectionList, //showingSections(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100.r,
                        right: 140.r,
                        child: Container(
                          width: 90,
                          height: 90,
                          child: Center(
                            child: LoadingButton(
                              color: AppColors.whiteColor,
                              onSubmit: () {
                                if (selectedValue2 == null ||
                                    touchedIndex == -1) {
                                  GF().ToastMessage(context, "CompleteData".tr(),
                                      const Icon(Icons.info));

                                  Future.delayed(const Duration(seconds: 1), () {
                                    _controller.stopLoadingAnimation();
                                  });

                                  // _controller.stopLoadingAnimation();

                                } else {
                                  _controller.startLoadingAnimation();
                                  Future.delayed(const Duration(seconds: 2), () {
                                    //  var authprov = Provider.of<AuthProvider>(context, listen: false);
                                    _controller.stopLoadingAnimation();
                                    // findprov.search(findprov.token,selectedValue!,selectedValue2!,
                                    //     findprov.main_cat_list[touchedIndex],_controller,context);

                                    setState(() {
                                      _controller.moveToScreen(
                                          context: context,
                                          page: Ads(
                                              findprov.search_list,
                                              selectedValue!,
                                              selectedValue2!,
                                              findprov
                                                  .main_cat_list[touchedIndex]),
                                          stopAnimation: true,
                                          navigationCallback: (route) {
                                            Navigator.of(context).push(route);
                                            // Future.delayed(const Duration(milliseconds: 200), () {
                                            //   setState(() {
                                            //     pushNewScreen(
                                            //       context,
                                            //       screen:  Ads(),
                                            //       customPageRoute: route,
                                            //       withNavBar: false, // OPTIONAL VALUE. True by default.
                                            //       pageTransitionAnimation: PageTransitionAnimation.scale,
                                            //     );
                                            //   });
                                            // });
                                          }
                                          // Navigator.of(context).push(route),
                                          );
                                      // _controller.moveToScreen(
                                      //
                                      //   context: context,
                                      //
                                      //   page: Ads(),
                                      //
                                      //   stopAnimation: true,
                                      //
                                      //   navigationCallback: (route) {
                                      //     Navigator.of(context).push(route);
                                      //     // Future.delayed(const Duration(milliseconds: 200), () {
                                      //     //   setState(() {
                                      //     //     pushNewScreen(
                                      //     //       context,
                                      //     //       screen:  Ads(),
                                      //     //       customPageRoute: route,
                                      //     //       withNavBar: false, // OPTIONAL VALUE. True by default.
                                      //     //       pageTransitionAnimation: PageTransitionAnimation.scale,
                                      //     //     );
                                      //     //   });
                                      //     // });
                                      //
                                      //   }
                                      //       // Navigator.of(context).push(route),
                                      // );
                                    });
                                  });
                                }
                              },
                              controller: _controller,
                              errorColor: Colors.red,
                              transitionDuration: const Duration(seconds: 1),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    translator.currentLanguage == 'ar'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/images/ic_go.png",
                                                width: 14.w,
                                                height: 12.h,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                // touchedIndex == 0
                                                //     ? '168'
                                                //     : touchedIndex == 1
                                                //         ? '100'
                                                //         : "200",
                                                ///////////////////////////////////////////////////////
                                                // touchedIndex==-1?"0":   "${findprov.main_cat_list[touchedIndex].serviceCount}",
                                                "${findprov.search_list.length}",
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 16.sp,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // touchedIndex == 0
                                                //     ? '168'
                                                //     : touchedIndex == 1
                                                //         ? '100'
                                                //         : "200",
                                                touchedIndex == -1
                                                    ? "0"
                                                    : "${findprov.main_cat_list[touchedIndex].serviceCount}",
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 16.sp,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Image.asset(
                                                "assets/images/ic_go.png",
                                                width: 14.w,
                                                height: 12.h,
                                              ),
                                            ],
                                          ),
                                    Text(
                                      'placesAvailable'.tr(),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 7.sp,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.grey,
                            //       blurRadius: 10.0,
                            //       blurStyle: BlurStyle.outer,
                            //       spreadRadius: 3.0,
                            //       offset: Offset(1.0, 1.0))
                            // ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
              ),
        ),

    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12.0 : 8.0;
      final radius = isTouched ? 60.0 : 60.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 0
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'entertainment'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );
        case 1:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 1
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'RestaurantsCafes'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );
        case 2:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 2
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'ResortsHotels'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );

        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> showingSections1() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12.0 : 10.0;
      final radius = isTouched ? 40.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 0
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'entertainment'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );
        case 1:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 1
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'RestaurantsCafes'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );
        case 2:
          return PieChartSectionData(
            borderSide: const BorderSide(width: 0.2, color: Colors.grey),
            color: touchedIndex == 2
                ? AppColors.blueW2Color
                : AppColors.whiteColor,
            value: 33.33,
            title: 'ResortsHotels'.tr(),
            radius: radius,
            titleStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          );

        default:
          throw Error();
      }
    });
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
