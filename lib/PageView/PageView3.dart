import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/PageView/StartApp.dart';
import 'package:findout/internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class PageView3 extends StatefulWidget {
  @override
  State<PageView3> createState() => _PageView3State();
}

class _PageView3State extends State<PageView3> {
  double opacity = 0.0;
  String _message = '';
  StreamSubscription? subscription;
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opacity = 1.0;
        // changeOpacity();
      });
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 1900), () async {
        bool _isConnected =
            await SimpleConnectionChecker.isConnectedToInternet();
        print(_isConnected);
        if (_isConnected) {
          // Navigator.pushReplacement(
          //   context,
          //   PageTransition(
          //     type: PageTransitionType.leftToRight,
          //     child: internet(),
          //   ),
          // );
        } else {
          GF().ToastMessage(
              context, _message, const Icon(Icons.wifi_off_rounded));
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: internet(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blueWColor,
            AppColors.blueDColor,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(

              children: [
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
                          translator.setNewLanguage(
                            context,
                            newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
                            remember: true,
                            restart: true,
                          );
                        },
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 40.8,
                            height: 40.8,
                            decoration:  const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'buttonTitle2'.tr(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                    tag: 'logo',
                    flightShuttleBuilder: _flightShuttleBuilder,
                    child: Image.asset(
                      "assets/images/logo_w.png",
                      width: 128.w,
                      height: 155.h,
                    ),),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'text5'.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: 15.h,
                ),

                Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: width.w,
                        height: 110.h,
                        decoration:  const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0)),

                        ),
                      ),
                    ),
                    Hero(
                      tag: 'page1',
                      flightShuttleBuilder: _flightShuttleBuilder,
                      child: Image.asset(
                        "assets/images/page_view3.png",
                        width: width.w,
                        height: 250.h,
                      ),),
                  ],
                ),
                SizedBox(height: 60.h,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: StartApp(),
                            ),
                          );
                        },
                        child: Text(
                          'next'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            color: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DotsIndicator(
                        dotsCount: 3,
                        position: 2.0,
                        decorator: DotsDecorator(
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: StartApp(),
                            ),
                          );
                        },
                        child: Text(
                          'skip'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            color: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
      ),


    ));
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
