import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class StartApp extends StatefulWidget {
  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  double opacity = 0.0;
  String _message = '';
  StreamSubscription? subscription;
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');
  final _controller = LoadingButtonController();

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
      });
    }).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 1900), () async {
        bool _isConnected =
            await SimpleConnectionChecker.isConnectedToInternet();
        if (_isConnected) {
        } else {
          GF().dismissLoading();
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
    return Scaffold(
        body: Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(),
            flex: 5,
          ),
          // SizedBox(
          //   height: 200.h,
          // ),
          Expanded(
            child: Column(
              children: [
                Hero(
                    tag: 'logo',
                    flightShuttleBuilder: _flightShuttleBuilder,
                    child: Image.asset(
                      "assets/images/logo_w.png",
                      width: 128.w,
                      height: 155.h,
                    )),
                SizedBox(
                  height: 11.h,
                ),
                Text(
                  'text1'.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.sp,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            flex: 6,
          ),

          // SizedBox(
          //   height: 0.h,
          // ),
          Expanded(
            flex: 3,
            child: AvatarGlow(
              glowColor: Colors.white,
              endRadius: 90.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Container(
                width: 50,
                height: 50,
                child: LoadingButton(
                  color: AppColors.blueDColor,
                  onSubmit: () {
                    _controller.startLoadingAnimation();
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        _controller.moveToScreen(
                          context: context,
                          page: NavigationBottomBarUser(),
                          stopAnimation: true,
                          navigationCallback: (route) =>
                              Navigator.of(context).pushReplacement(route),
                        );
                      });
                    });
                  },
                  controller: _controller,
                  errorColor: Colors.red,
                  transitionDuration: const Duration(seconds: 1),
                  child: Image.asset(
                    "assets/images/ic_start_app.png",
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
              ),
            ),
          )
        ],
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
