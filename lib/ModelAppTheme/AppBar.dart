import 'package:findout/ADS/MapView.dart';
import 'package:findout/Events/Events.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class WidgetAppBar{
  Widget AppBarHome(BuildContext context,bool show){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        show?  InkWell(
            onTap: () {
              pushNewScreen(
                context,
                screen:  Events(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Image.asset(
              "assets/images/events.png",
              width: 30.w,
              height: 30.h,
            ),
          ):SizedBox(width: 20.w,),
          Image.asset(
            "assets/images/logo_app_bar.png",
            width: 38.w,
            height: 46.h,
          ),
          SizedBox(width: 20.w,),
        ],
      ),
    );
  }




  Widget AppBarAds(BuildContext context,String txt,bool show, [List<SearchClass>? list]){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          show?   InkWell(
            onTap: () {
              pushNewScreen(
                context,
                screen: MapView(list!),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Image.asset(
              "assets/images/map.png",
              width: 27.w,
              height: 27.h,
            ),
          ):SizedBox(width: 20.w,),
          Text(
          txt,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: AppColors.blackColor,
            ),
          ),
          translator.currentLanguage == 'ar'
              ? InkWell(
            onTap: (){
              Navigator.pop(context);
            },
                child: SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: Center(
                    child: Row(
            children: [
                    Text(
                        'back'.tr(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          color: AppColors.blackColor,
                        ),
                      ),

                    Image.asset("assets/images/back.png")
            ],
          ),
                  ),
                ),
              )
              :  InkWell(
            onTap: (){
              Navigator.pop(context);
            },
                child: SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: Center(
                    child: Row(
            children: [
                    Image.asset("assets/images/back.png"),
                     Text(
                        'back'.tr(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          color: AppColors.blackColor,
                        ),
                        textAlign: TextAlign.left,
                      ),

            ],
          ),
                  ),
                ),
              ),


        ],
      ),
    );
  }

}
