import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:findout/ADS/Ads.dart';
import 'package:findout/Model/homeclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';

import 'package:findout/provider/findout_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

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
  final List<Cities> CityItems = [];
  late String sv;
  AreaCities? selectedValue;
  Cities? selectedValue2;
  int touchedIndex = -1;

  final _controller = LoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<FindoutProvider>(
        builder: (context, findprov, child) => SingleChildScrollView(
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
              SizedBox(
                height: 10.h,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black45,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 30.0.h,
                      width: 240.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<AreaCities>(
                          items: findprov.cities_list
                              .map((item) => DropdownMenuItem<AreaCities>(
                                    value: item,
                                    child: Text(
                                      item.title!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ))
                              .toList(),
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
                              touchedIndex = -1;
                              findprov.redrawchart(
                                  findprov.main_cat_list, touchedIndex);
                              selectedValue = value as AreaCities?;
                              CityItems.clear();
                              CityItems.addAll(selectedValue!.cities!);
                              selectedValue2 = null;
                            });
                            setState(() {});
                          },
                        ),
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

              // ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black45,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 30.0.h,
                      width: 240.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<Cities>(
                          items: CityItems.map((Cities value) {
                            return DropdownMenuItem<Cities>(
                              value: value,
                              child: Text(value.title!),
                            );
                          }).toList(),
                          value: selectedValue2 == null ? null : selectedValue2,
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
                            setState(
                              () {
                                touchedIndex = -1;

                                findprov.redrawchart(
                                    findprov.main_cat_list, touchedIndex);
                                selectedValue2 = v;

                                findprov.searchcountWithoutCat(
                                  token: findprov.token,
                                  selectedarea: selectedValue!,
                                  selectedcity: selectedValue2!,
                                  context: context,
                                );
                              },
                            );
                          },
                        ),
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

              // SizedBox(
              //   height: 10.h,
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20).r,
                child: AspectRatio(
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
                                  // touchedIndex = -1;
                                  return;
                                }

                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;

                                if (kDebugMode) {
                                  print('touchedIndex      :$touchedIndex');
                                }

                                findprov.redrawchart(
                                    findprov.main_cat_list, touchedIndex);

                                findprov.searchcount(
                                    token: findprov.token,
                                    selectedarea: selectedValue!,
                                    selectedcity: selectedValue2!,
                                    main_cat:
                                        findprov.main_cat_list[touchedIndex],
                                    context: context);
                                setState(() {});
                              });
                            }),
                            borderData: FlBorderData(
                              show: true,
                            ),
                            sectionsSpace: 25,
                            centerSpaceRadius: 70,
                            sections: findprov
                                .pieChartsectionList, //showingSections(),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: LoadingButton(
                              color: AppColors.whiteColor,
                              onSubmit: () {
                                print('touchedIndex      :$touchedIndex');
                                print('selectedValue2      :$selectedValue2');

                                if (selectedValue2 == null ||
                                    touchedIndex == -1) {
                                  GF().ToastMessage(
                                      context,
                                      "CompleteData".tr(),
                                      const Icon(Icons.info));

                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    _controller.stopLoadingAnimation();
                                  });
                                } else {
                                  GF().loading();

                                  _controller.startLoadingAnimation();
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      _controller.stopLoadingAnimation();
                                      GF().dismissLoading();

                                      setState(
                                        () {
                                          _controller.moveToScreen(
                                            context: context,
                                            page: Ads(
                                                findprov.search_list,
                                                selectedValue!,
                                                selectedValue2!,
                                                findprov.main_cat_list[
                                                    touchedIndex]),
                                            stopAnimation: true,
                                            navigationCallback: (route) {
                                              Navigator.of(context).push(route);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
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
                                                "${findprov.search_list.length}",
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 16.sp,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${findprov.search_list.length}",
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
