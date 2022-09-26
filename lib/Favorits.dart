import 'dart:async';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:animation_list/animation_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/AdDetails.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/ModelAppTheme/Sound.dart';
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
import 'package:like_button/like_button.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class Favorits extends StatefulWidget {
  @override
  State<Favorits> createState() => _FavoritsState();
}

class _FavoritsState extends State<Favorits> {
  late bool startListView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startListView = false;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        startListView = true;
      });
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      setState(() {
        var findprov = Provider.of<FindoutProvider>(context, listen: false);

        findprov.get_fav_properties(findprov.token);
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      setState(() {
        var findprov = Provider.of<FindoutProvider>(context, listen: false);

        findprov.get_fav_properties(findprov.token);
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 200.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            WidgetAppBar().AppBarAds(context, 'fav'.tr(), false),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                children: [
                  Text(
                    'myFavourite'.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            startListView
                ? Expanded(
                    child: Consumer<FindoutProvider>(
                      builder: (context, findprov, child) => AnimationList(
                        duration: 2000,
                        reBounceDepth: 30,
                        // children: data.map((item) {
                        //   return _buildTile(item['title'], item['backgroundColor']);
                        // }).toList()),
                        children: [
                          for (var i = 0; i < findprov.fav_list.length; i++)
                            InkWell(
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: AdDetails(findprov.fav_list[i]),
                                  withNavBar: false,
                                  // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: ItemsADS(findprov.fav_list[i]),
                            ),
                          // InkWell(
                          //   onTap: () {
                          //         pushNewScreen(
                          //           context,
                          //           screen:  AdDetails(),
                          //           withNavBar: false, // OPTIONAL VALUE. True by default.
                          //           pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          //         );
                          //   },
                          //   child: ItemsADS(),
                          // ),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                          // ItemsADS(),
                        ],
                      ),
                    ),
                  )
                : const Center(child: CupertinoActivityIndicator()),
          ],
        ),
      ),
    );
  }

  Widget ItemsADS(SearchClass list) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
        ),
        child: Center(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              list.images!.length == 0
                  ? Container(
                      width: 90.w,
                      height: 102.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo_app_bar.png'),
                          fit: BoxFit.contain,
                        ),
                        border: Border.all(
                            width: 0.3, color: const Color(0xffe8e8e8)),
                      ),
                    )
                  : Container(
                      width: 90.w,
                      height: 102.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: NetworkImage(list.images![0].image!),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                            width: 0.3, color: const Color(0xffe8e8e8)),
                      ),
                    ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width / 1.5.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list.title.toString(), //   'منظر طبيعي',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(
                        //   width: width / 2.5.w,
                        // ),
                        // Adobe XD layer: 'XMLID_2_' (shape)
                        InkWell(
                          onTap: () {
                            showDialogDelFav(list.id!);
                            // GF().loading();
                            // Future.delayed(const Duration(seconds: 3), () {
                            //   setState(() {
                            //     GF().dismissLoading();
                            //     GF().ToastMessage(context, "deleted".tr(), const Icon(Icons.done));
                            //     PlaySound().play();
                            //
                            //   });
                            // });
                          },
                          child: Container(
                             height: 20,width: 20,
                            child: SvgPicture.string(
                              '<svg viewBox="16.7 448.2 10.5 14.8" ><path transform="translate(-34.57, 448.19)" d="M 61.42341995239258 5.243367195129395 L 59.68603134155273 4.523697853088379 L 60.40570068359375 2.786310434341431 C 60.53818130493164 2.466448068618774 60.38631057739258 2.099780559539795 60.06644439697266 1.967263698577881 L 55.43333435058594 0.04821464419364929 C 55.1135139465332 -0.08426038175821304 54.74680328369141 0.06760530173778534 54.61432647705078 0.3874677121639252 L 53.89465713500977 2.124854564666748 L 52.15727233886719 1.405185103416443 C 51.83740997314453 1.272710204124451 51.47074127197266 1.424575686454773 51.33822631835938 1.744438171386719 C 51.20574951171875 2.064300537109375 51.35761260986328 2.430968046188354 51.6774787902832 2.563484668731689 L 53.99403381347656 3.523030519485474 L 58.03213882446289 5.195642948150635 L 52.78934860229492 5.195642948150635 C 52.44316101074219 5.195642948150635 52.16249465942383 5.476305961608887 52.16249465942383 5.82249641418457 L 52.16249465942383 14.18053913116455 C 52.16249465942383 14.52673053741455 52.44316101074219 14.80739498138428 52.78934860229492 14.80739498138428 L 60.31158828735352 14.80739498138428 C 60.65777587890625 14.80739498138428 60.93844223022461 14.52673053741455 60.93844223022461 14.18053913116455 L 60.93844223022461 6.399494647979736 L 60.94366455078125 6.401667594909668 C 61.0221061706543 6.434138298034668 61.10335159301758 6.449559211730957 61.18328857421875 6.449559211730957 C 61.42926788330078 6.449559211730957 61.66271209716797 6.303836822509766 61.76267242431641 6.062414169311523 C 61.89514541625977 5.742552280426025 61.74327850341797 5.375842571258545 61.42341995239258 5.243367195129395 Z M 55.05295562744141 2.60460638999939 L 55.53271102905273 1.446348547935486 L 59.00748443603516 2.885645627975464 L 58.52773284912109 4.043904781341553 L 56.79034423828125 3.324275970458984 L 55.05295562744141 2.60460638999939 Z" fill="#ff5e5e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 160.w,
                        child: Text(
                          list.details == null ? "" : list.details.toString(),
                          //  'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا يسكينج أليايت,سيت دو أيوسمود تيمبور',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: AppColors.gryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              list.counter.toString(), //    '100',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 8.sp,
                                color: AppColors.orangeColor,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Image.asset(
                              "assets/images/eye.png",
                              width: 8.w,
                              height: 7.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            SvgPicture.string(
                              '<svg viewBox="35.3 518.0 1.0 6.0" ><path transform="translate(35.35, 518.0)" d="M 0 0 L 0 6" fill="none" stroke="#bcbcbc" stroke-width="0.5299999713897705" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                                double.parse(list.avgRates!).toStringAsFixed(1),// list.avgRates.toString(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10.sp,
                                color: AppColors.orangeColor,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            SvgPicture.string(
                              '<svg viewBox="-18.9 1.0 8.6 8.3" ><path transform="translate(-18.89, -0.05)" d="M 3.898473501205444 1.305808424949646 L 2.925238609313965 3.277837038040161 C 2.857560157775879 3.414993524551392 2.726704597473145 3.51003098487854 2.575328350067139 3.531990528106689 L 0.3990060091018677 3.848242282867432 C 0.01777739636600018 3.903680801391602 -0.1343197971582413 4.372027397155762 0.1414325535297394 4.640760898590088 L 1.716210961341858 6.175760269165039 C 1.825648427009583 6.282497882843018 1.875687122344971 6.436393260955811 1.849767923355103 6.587049961090088 L 1.478077411651611 8.75455379486084 C 1.412919521331787 9.13416576385498 1.811428785324097 9.423596382141113 2.152340173721313 9.244502067565918 L 4.098808288574219 8.221226692199707 C 4.234164237976074 8.150129318237305 4.395980834960938 8.150129318237305 4.531336307525635 8.221226692199707 L 6.477806091308594 9.244502067565918 C 6.818716526031494 9.423776626586914 7.217226505279541 9.13416576385498 7.152068138122559 8.75455379486084 L 6.780378818511963 6.587049961090088 C 6.754458427429199 6.436393260955811 6.804497718811035 6.282497882843018 6.91393518447876 6.175760269165039 L 8.488713264465332 4.640760898590088 C 8.764466285705566 4.371847152709961 8.612369537353516 3.903500080108643 8.23114013671875 3.848242282867432 L 6.054817676544189 3.531990528106689 C 5.903440952301025 3.51003098487854 5.772584915161133 3.414993524551392 5.704906940460205 3.277837038040161 L 4.731671810150146 1.305808424949646 C 4.561395645141602 0.9603972434997559 4.068928241729736 0.9603972434997559 3.898473501205444 1.305808424949646 Z" fill="#ed8a19" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
  void showDialogDelFav(int place_id) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (thisLowerContext, innerSetState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 250.h,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: ListView(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'DeletFav'.tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "DeletFavInfo".tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              var findprov = Provider.of<FindoutProvider>(
                                  context,
                                  listen: false);

                              await findprov
                                  .addfav(findprov.token, place_id, 1,
                                  context)
                                  .then((v) {
                                // setState(() {
                                //   finshloading = false;
                                //
                                // });
                              }).whenComplete(() {
                                // Navigator.pop(this.context);
                              }).catchError((e) {
                                //  showSnackMsg(e.toString());
                                print('ErrorRegCompany:$e');
                              }).then((v) {});
                            },
                            child: Container(
                              width: 109.w,
                              height: 31.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23.0),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  'ok'.tr(),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 10.sp,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Text(
                                'skip',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12.sp,
                                  color: AppColors.orangeColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
