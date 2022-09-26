import 'dart:async';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:animation_list/animation_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/AdDetailsToDetails.dart';
import 'package:findout/Events/EventDetails.dart';
import 'package:findout/Events/EventsNow.dart';
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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../Model/image_data.dart';

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          WidgetAppBar().AppBarAds(context, 'importantEvents'.tr(), false),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CURRENTEVENTS'.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: (){
                    pushNewScreen(
                      context,
                      screen:  EventsNow(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Row(
                    children: [
                      AvatarGlow(
                        glowColor: AppColors.orangeColor,
                        endRadius: 16.0,
                        animate: true,
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        showTwoGlows: true,
                        child: Image.asset(
                          "assets/images/ic_event.png",
                          width: 16.w,
                          height: 12.h,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'EventsAvailableNow'.tr(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.sp,
                          color: AppColors.orangeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(child:
          Consumer<FindoutProvider>(
            builder: (context, findprov, child) =>StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: findprov.events_list.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen:  EventDetails( findprov.events_list[index]),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Stack(
                  children: [
                    findprov.events_list[index].imagestring!.length==0?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset('assets/images/logo_app_bar.png', fit: BoxFit.contain),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(findprov.events_list[index].imagestring![0], fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: width.w,
                        height: 70.h,
                        color: Colors.black.withOpacity(.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                findprov.events_list[index].title.toString(),//  'منظر طبيعي',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12.sp,
                                  color: AppColors.whiteColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/ic_loca.png",
                                    width: 5.w,
                                    height: 8.h,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    findprov.events_list[index].city.toString(),//   'جدة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 10.sp,
                                      color: const Color(0xffe8e8e8),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
          ),),
        ],
      ),
    );
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

class PinterestGridEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Consumer<FindoutProvider>(
      builder: (context, findprov, child) =>StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: imageList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            // pushNewScreen(
            //   context,
            //   screen:  EventDetails(),
            //   withNavBar: false, // OPTIONAL VALUE. True by default.
            //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
            // );
          },
          child: ImageCard(
            imageData: imageList[index],
          ),
        ),
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({required this.imageData});

  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(imageData.imageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: width.w,
            height: 70.h,
            color: Colors.black.withOpacity(.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'منظر طبيعي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.sp,
                      color: AppColors.whiteColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/ic_loca.png",
                        width: 5.w,
                        height: 8.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'جدة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10.sp,
                          color: const Color(0xffe8e8e8),
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
