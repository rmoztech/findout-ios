import 'dart:async';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:animation_list/animation_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/Model/searchclass.dart';
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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../Model/image_data.dart';

class AdDetailsToDetails extends StatefulWidget {
  SearchClass list;
  AdDetailsToDetails(this.list);

  @override
  State<AdDetailsToDetails> createState() => _AdDetailsToDetailsState();
}

class _AdDetailsToDetailsState extends State<AdDetailsToDetails> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            WidgetAppBar().AppBarAds(context, '${widget.list.title}', false),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          true, // set to false if you want to force a rating
                      builder: (context) => RatingDialog(
                        initialRating: 1.0,
                        // your app's name?
                        starSize: 25,
                        title: Text(
                          'rating'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // encourage your user to leave a high rating?
                        message: Text(
                          'rating2'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        // your app's logo?
                        image: widget.list.images!.length == 0
                            ? Container(
                                // width: 50,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(10.0, 10.0)),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/logo_app_bar.png'),
                                    fit: BoxFit.contain,
                                  ),
                                  border: Border.all(
                                      width: 0.5,
                                      color: const Color(0xffc8c8c8)),
                                ),
                              )
                            : Container(
                                // width: 50,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(10.0, 10.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.list.imagestring![0]),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      width: 0.5,
                                      color: const Color(0xffc8c8c8)),
                                ),
                              ),
                        submitButtonText: 'Submit'.tr(),
                        commentHint: 'comment'.tr(),
                        enableComment: false,
                        onCancelled: () => print('cancelled'),
                        onSubmitted: (response) {
                          print(
                              'rating: ${response.rating}, comment: ${response.comment}///////${widget.list.id}');

                          var findprov = Provider.of<FindoutProvider>(context,
                              listen: false);
                          print('rating: ${findprov.token}');
                          findprov.rate(
                              findprov.token,
                              widget.list.id.toString(),
                              response.rating,
                              "${response.comment}",
                              context);
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                    child: SvgPicture.string(
                      '<svg viewBox="-18.9 1.0 40.0 38.3" ><path transform="translate(-18.89, -0.05)" d="M 18.06942558288574 2.247632265090942 L 13.55793285369873 11.38910293579102 C 13.2442045211792 12.02490043640137 12.63761520385742 12.4654541015625 11.9359016418457 12.56724643707275 L 1.847413897514343 14.03325366973877 C 0.08020322024822235 14.29024219512939 -0.6248535513877869 16.46129417419434 0.6534149646759033 17.70702743530273 L 7.95340633392334 24.8226203918457 C 8.460710525512695 25.31740951538086 8.692668914794922 26.03080177307129 8.572518348693848 26.72918319702148 L 6.849523067474365 36.77679061889648 C 6.547478675842285 38.53650665283203 8.394794464111328 39.8781852722168 9.97511100769043 39.04798126220703 L 18.99809455871582 34.30451965332031 C 19.62554550170898 33.97494125366211 20.37565612792969 33.97494125366211 21.00310516357422 34.30451965332031 L 30.02609634399414 39.04798126220703 C 31.60641098022461 39.87902069091797 33.45373153686523 38.53650665283203 33.15168762207031 36.77679061889648 L 31.42869186401367 26.72918319702148 C 31.30854034423828 26.03080177307129 31.54050064086914 25.31740951538086 32.04780197143555 24.8226203918457 L 39.3477897644043 17.70702743530273 C 40.62606430053711 16.46045875549316 39.9210090637207 14.28940296173096 38.1537971496582 14.03325366973877 L 28.06530380249023 12.56724643707275 C 27.36359024047852 12.4654541015625 26.75699615478516 12.02490043640137 26.44326972961426 11.38910293579102 L 21.9317741394043 2.247632265090942 C 21.14244842529297 0.6464556455612183 18.85958099365234 0.6464556455612183 18.06942558288574 2.247632265090942 Z" fill="#ff8a15" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      allowDrawingOutsideViewBox: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            widget.list.images!.length == 0
                ? Container(
                    width: 97,
                    height: 97,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          const Radius.elliptical(9999.0, 9999.0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo_app_bar.png'),
                        fit: BoxFit.contain,
                      ),
                      border: Border.all(
                          width: 0.5, color: const Color(0xffc8c8c8)),
                    ),
                  )
                : Container(
                    width: 97,
                    height: 97,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          const Radius.elliptical(9999.0, 9999.0)),
                      image: DecorationImage(
                        image: NetworkImage(widget.list.images![0].image!),
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(
                          width: 0.5, color: const Color(0xffc8c8c8)),
                    ),
                  ),
            Text(
              widget.list.title.toString(), //     'فندق هيلتون',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.list.details == null
                  ? ""
                  : widget.list.details
                      .toString(), //      'لوريم ايبسوم دولار سيت أميت\nكونسيكتيتور أدايبا يسكينج أليايت,سيت دو أيوسمود تيمبور\nأنكايديديونتيوت لابوري ات دولار ماجنا أليكيوا\n يوت انيم أد مينيم فينايم,كيواس نوستريد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                color: AppColors.gryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ), 
            widget.list.about_place == null
                ? Container()
                : Container(
                    width: width.w,
                    // height: height.h,
                    decoration: const BoxDecoration(
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        'ماذا عن ${widget.list.title}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
            widget.list.about_place == null
                ? Container()
                : SizedBox(
                    height: 10.h,
                  ),
            widget.list.about_place == null
                ? Container()
                : HtmlWidget('${widget.list.about_place}'),
          ],
        ),
      ),
    );
  }

  final _dialog = RatingDialog(
    initialRating: 1.0,
    // your app's name?
    title: Text(
      'rating'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      'rating2'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.sp),
    ),
    // your app's logo?
    image: Container(
      // width: 50,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
        image: const DecorationImage(
          image: AssetImage('assets/images/img2.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(width: 0.5, color: const Color(0xffc8c8c8)),
      ),
    ),
    submitButtonText: 'Submit'.tr(),
    commentHint: 'comment'.tr(),
    enableComment: false,
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        // _rateAndReviewApp();
      }
    },
  );

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
