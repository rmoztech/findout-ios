import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:animation_list/animation_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/AdDetailsToDetails.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/PageView/PageView1.dart';
import 'package:findout/api/webpage.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Events/map.dart';
import '../Model/image_data.dart';
import '../api/master_api.dart';
import 'package:http/http.dart' as http;

class AdDetailsID extends StatefulWidget {
  int id;

  AdDetailsID(this.id);

  @override
  State<AdDetailsID> createState() => _AdDetailsIDState();
}

class _AdDetailsIDState extends State<AdDetailsID> {
  late List<SearchClass> list = [];
  @override
  void initState() {
    super.initState();
    var findprov = Provider.of<FindoutProvider>(context, listen: false);

    search_id(findprov.token, widget.id, context);
    if (findprov.token == "") {
    } else {
      findprov.add_counter(findprov.token, widget.id);
    }
  }

  Future<dynamic> search_id(String token, int id, BuildContext context) async {
    String url = MasterAPi.API_URL_SEARCH + "?id=${id}";
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      print("ssshhh2${response.statusCode}");
      print("ssshhh${response.body}");
      list.clear();
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          setState(() {
            list.add(SearchClass.fromJson(item));
          });
        }
      }
    }).catchError((e) {
      print('eeee:${e.toString()}');
    });
  }

  void showDialogMap() {
    double height = MediaQuery.of(context).size.height;
    showCupertinoModalBottomSheet(
      expand: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(list[0].location!.lat!),
                double.parse(list[0].location!.long!)),
            zoom: 14),
        markers: [
          Marker(
              markerId: MarkerId('${list[0].id}'),
              infoWindow: InfoWindow(
                title: list[0].title.toString(),
              ),
              position: LatLng(double.parse(list[0].location!.lat!),
                  double.parse(list[0].location!.long!)))
        ].toSet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: list.length == 0
          ? Container(
              height: height,
              child: Center(child: Text("NoData".tr())),
            )
          : ListView(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                WidgetAppBar().AppBarAds(context, '${list[0].title}', false),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              true, // set to false if you want to force a rating
                          builder: (context) => RatingDialog(
                            initialRating: 1.0,
                            starSize: 25,
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
                            image: list[0].images!.length == 0
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
                                            list[0].imagestring![0]),
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
                              // print('rating: ${response.rating}, comment: ${response.comment}///////${widget.list.id}');

                              var findprov = Provider.of<FindoutProvider>(
                                  context,
                                  listen: false);
                              print('rating: ${findprov.token}');
                              findprov.rate(
                                  findprov.token,
                                  list[0].id.toString(),
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
                list[0].images!.length == 0
                    ? Container(
                        margin: EdgeInsets.all(8),
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/logo_app_bar.png'),
                              fit: BoxFit.contain),
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                const Radius.elliptical(9999.0, 9999.0)),
                            image: DecorationImage(
                              image: NetworkImage(list[0].images![0].image!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                                width: 0.5, color: const Color(0xffc8c8c8)),
                          ),
                        ),
                      ),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    list[0].title.toString(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                list[0].details == null
                    ? Text(" ")
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: list[0].details!.length > 170
                                  ? list[0].details!.substring(0, 170) + "..."
                                  : list[0].details,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.sp,
                                color: AppColors.gryColor,
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  pushNewScreen(
                                    context,
                                    screen: AdDetailsToDetails(list[0]),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Text(
                                  'more'.tr(), // 'read more!',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),

                // Row(
                //   children: [
                //     Text(
                //       widget.list.details == null ? "" : widget.list.details.toString(),
                //       //   'لوريم ايبسوم دولار سيت أميت\nكونسيكتيتور أدايبا يسكينج أليايت,سيت دو أيوسمود تيمبور\nأنكايديديونتيوت لابوري ات دولار ماجنا أليكيوا\n يوت انيم أد مينيم فينايم,كيواس نوستريد',
                //       maxLines: 3,
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(
                //         fontFamily: 'Cairo',
                //         fontSize: 12.sp,
                //         color: AppColors.gryColor,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: width.w,
                  height: 50.h,
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        list[0].phone == null
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  launch("tel:${list[0].phone}");
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(9999.0, 9999.0)),
                                    color: Color(0xff00d547),
                                  ),
                                  child: Center(
                                    child: SvgPicture.string(
                                      '<svg viewBox="386.2 269.2 13.6 13.5" ><path transform="translate(386.22, 269.22)" d="M 13.4059476852417 10.28001022338867 C 12.90149211883545 9.32636833190918 11.1497163772583 8.292337417602539 11.07259082794189 8.247117042541504 C 10.84749507904053 8.118993759155273 10.61260223388672 8.051163673400879 10.39278125762939 8.051163673400879 C 10.06594181060791 8.051163673400879 9.798388481140137 8.200892448425293 9.636350631713867 8.473217964172363 C 9.38010311126709 8.779709815979004 9.06230640411377 9.13795280456543 8.985180854797363 9.193472862243652 C 8.388276100158691 9.598443984985352 7.921002388000488 9.552470207214355 7.403986930847168 9.035453796386719 L 4.518445491790771 6.149657726287842 C 4.004694938659668 5.635907173156738 3.957464933395386 5.162854671478271 4.359672546386719 4.569215774536133 C 4.415946483612061 4.491588115692139 4.774189472198486 4.173540115356445 5.080681324005127 3.917042255401611 C 5.276132106781006 3.800726175308228 5.410284996032715 3.627885103225708 5.469070911407471 3.415853261947632 C 5.547202110290527 3.133729934692383 5.48967170715332 2.801864862442017 5.30527400970459 2.478541612625122 C 5.261812210083008 2.404179573059082 4.227277278900146 0.6521531939506531 3.274139404296875 0.1479492634534836 C 3.09627366065979 0.05374078452587128 2.895797729492188 0.003998696804046631 2.694819688796997 0.003998696804046631 C 2.363708257675171 0.003998696804046631 2.052192211151123 0.1331271231174469 1.818052530288696 0.3670153617858887 L 1.180450320243835 1.004367470741272 C 0.1720426827669144 2.012523889541626 -0.1929837912321091 3.155335664749146 0.09491730481386185 4.400897026062012 C 0.3350861370563507 5.438948631286621 1.034992337226868 6.543575286865234 2.175542831420898 7.683875560760498 L 5.869771480560303 11.3781042098999 C 7.313296794891357 12.82162761688232 8.689494132995605 13.55369091033936 9.960177421569824 13.55369091033936 C 9.960177421569824 13.55369091033936 9.960177421569824 13.55369091033936 9.960428237915039 13.55369091033936 C 10.89497756958008 13.55369091033936 11.76621723175049 13.15650749206543 12.54927825927734 12.37344646453857 L 13.18663024902344 11.73609638214111 C 13.57401466369629 11.34896183013916 13.66194343566895 10.76361274719238 13.4059476852417 10.28001022338867 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 5.w,
                        ),
                        list[0].location == null
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapDetails(
                                        lat: double.parse(
                                            list[0].location!.lat!),
                                        long: double.parse(
                                            list[0].location!.long!),
                                        id: '${list[0].id}',
                                        title: '${list[0].title}',
                                      ),
                                    ),
                                  );
                                  // showDialogMap();
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(9999.0, 9999.0)),
                                    color: Color(0xff00b1ff),
                                  ),
                                  child: Center(
                                    child: SvgPicture.string(
                                      '<svg viewBox="96.0 32.0 9.4 13.1" ><path  d="M 100.6825866699219 32 C 98.10072326660156 32 96 34.00912094116211 96 36.47772216796875 C 96 37.65334320068359 96.53585815429688 39.21674346923828 97.59266662597656 41.12460327148438 C 98.44137573242188 42.65639495849609 99.42326354980469 44.04156494140625 99.9339599609375 44.73078155517578 C 100.1089782714844 44.96962738037109 100.3873596191406 45.11075592041016 100.6834564208984 45.11075592041016 C 100.9795684814453 45.11075592041016 101.2579498291016 44.96962738037109 101.4329681396484 44.73078155517578 C 101.9427871704102 44.04156494140625 102.9255447387695 42.65639495849609 103.7742614746094 41.12460327148438 C 104.8293075561523 39.21732711791992 105.3651733398438 37.6539306640625 105.3651733398438 36.47772216796875 C 105.3651733398438 34.00912094116211 103.2644424438477 32 100.6825866699219 32 Z M 100.6825866699219 38.55562210083008 C 99.64813232421875 38.55562210083008 98.80954742431641 37.71703338623047 98.80954742431641 36.68258666992188 C 98.80954742431641 35.64813613891602 99.64813232421875 34.80955123901367 100.6825866699219 34.80955123901367 C 101.7170333862305 34.80955123901367 102.5556182861328 35.64813613891602 102.5556182861328 36.68258666992188 C 102.5544891357422 37.71656799316406 101.7165679931641 38.55449295043945 100.6825866699219 38.55561828613281 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 5.w,
                        ),
                        (list[0].timeIn == null && list[0].timeOut == null)
                            ? Container()
                            : SvgPicture.string(
                                '<svg viewBox="0.0 0.0 13.0 13.0" ><path  d="M 6.499969482421875 0 C 2.907472848892212 0 0 2.907138109207153 0 6.499969482421875 C 0 10.09249305725098 2.907138109207153 12.99993896484375 6.499969482421875 12.99993896484375 C 10.09252166748047 12.99993896484375 12.99993896484375 10.09280014038086 12.99993896484375 6.499969482421875 C 12.99993896484375 2.907417058944702 10.09280014038086 0 6.499969482421875 0 Z M 6.820219993591309 6.769309043884277 L 5.048464298248291 8.875792503356934 C 4.899692535400391 9.052655220031738 4.63568115234375 9.075419425964355 4.458874225616455 8.926675796508789 C 4.282011032104492 8.777904510498047 4.259220123291016 8.513948440551758 4.4079909324646 8.337084770202637 L 6.081522941589355 6.347375392913818 L 6.081522941589355 1.618771314620972 C 6.081522941589355 1.387677669525146 6.268875598907471 1.200325608253479 6.499968528747559 1.200325608253479 C 6.731062412261963 1.200325608253479 6.91841459274292 1.387677669525146 6.91841459274292 1.618771314620972 L 6.91841459274292 6.499969482421875 L 6.91841459274292 6.499969482421875 C 6.918415069580078 6.598498821258545 6.883628368377686 6.693904399871826 6.820219993591309 6.769309043884277 Z" fill="#5096ff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          list[0].timeIn == null ? "" : 'Access'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.gryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          list[0].timeIn == null ? "" : '${list[0].timeIn}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.blueW2Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          list[0].timeIn == null
                              ? ""
                              : list[0].timeOutAmPm == "am"
                                  ? 'AM'.tr()
                                  : 'PM'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          list[0].timeOut == null ? "" : 'Exit'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.gryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          list[0].timeOut == null ? "" : '${list[0].timeOut}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.blueW2Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          list[0].timeOut == null
                              ? ""
                              : list[0].timeOutAmPm == "am"
                                  ? 'AM'.tr()
                                  : 'PM'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 8.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 5.h,
                        ),
                        Text(
                          double.parse(list[0].avgRates!).toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SvgPicture.string(
                          '<svg viewBox="-18.9 1.0 10.9 10.4" ><path transform="translate(-18.89, -0.05)" d="M 4.911372184753418 1.373127222061157 L 3.685233116149902 3.857607126235962 C 3.59996771812439 4.030405044555664 3.435107946395874 4.150138854980469 3.24439525604248 4.177804470062256 L 0.5025340914726257 4.576237678527832 C 0.02223941311240196 4.646082401275635 -0.1693817526102066 5.236133575439453 0.1780275851488113 5.574700355529785 L 2.162027835845947 7.508584499359131 C 2.299903631210327 7.643058300018311 2.362945318222046 7.836945056915283 2.330290794372559 8.026751518249512 L 1.862012982368469 10.75750255584717 C 1.77992308139801 11.23576068878174 2.281988859176636 11.60040283203125 2.711489200592041 11.37476921081543 L 5.163766384124756 10.08558559417725 C 5.334296226501465 9.996012687683105 5.538162231445312 9.996012687683105 5.708691120147705 10.08558559417725 L 8.160970687866211 11.37476921081543 C 8.590470314025879 11.60062980651855 9.092536926269531 11.23576068878174 9.010446548461914 10.75750255584717 L 8.542169570922852 8.026751518249512 C 8.509513854980469 7.836945056915283 8.572556495666504 7.643058300018311 8.710432052612305 7.508584499359131 L 10.69443130493164 5.574700355529785 C 11.04184246063232 5.23590612411499 10.85022163391113 4.645854473114014 10.36992645263672 4.576237678527832 L 7.628064155578613 4.177804470062256 C 7.437350749969482 4.150138854980469 7.272490501403809 4.030405044555664 7.187225341796875 3.857607126235962 L 5.961085796356201 1.373127222061157 C 5.746561527252197 0.9379575848579407 5.126121520996094 0.9379575848579407 4.911372184753418 1.373127222061157 Z" fill="#ed8a19" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          '${list[0].counter}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SvgPicture.string(
                          '<svg viewBox="0.0 0.0 16.4 10.4" ><path transform="translate(0.0, -54.53)" d="M 16.22719383239746 59.32034301757812 C 16.08174514770508 59.12474060058594 12.61443996429443 54.53000640869141 8.181120872497559 54.53000640869141 C 3.747749328613281 54.53000640869141 0.2804984152317047 59.12474060058594 0.1350497603416443 59.32034301757812 C -0.04502452909946442 59.56251525878906 -0.04502452909946442 59.89408874511719 0.1350497603416443 60.13626098632812 C 0.280498594045639 60.33186340332031 3.747748851776123 64.92656707763672 8.181120872497559 64.92656707763672 C 12.61443996429443 64.92656707763672 16.08174514770508 60.33186340332031 16.22719383239746 60.13626098632812 C 16.40726470947266 59.89414978027344 16.40726470947266 59.56251525878906 16.22719383239746 59.32034301757812 Z M 8.181120872497559 62.46628570556641 C 6.671384811401367 62.46628570556641 5.443138599395752 61.23804473876953 5.443138599395752 59.72831726074219 C 5.443138599395752 58.218505859375 6.671384811401367 56.99027252197266 8.181120872497559 56.99027252197266 C 9.690911293029785 56.99027252197266 10.91915988922119 58.218505859375 10.91915988922119 59.72831726074219 C 10.91915988922119 61.23804473876953 9.690857887268066 62.46628570556641 8.181120872497559 62.46628570556641 Z" fill="#5096ff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                (list[0].instagram == null &&
                        list[0].twitter == null &&
                        list[0].facebook == null)
                    ? Container()
                    : Container(
                        width: width.w,
                        height: 70.h,
                        decoration: const BoxDecoration(
                          color: Color(0xffffffff),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              list[0].facebook == null
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 2000),
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return WebPage(
                                                  list[0].facebook.toString());
                                            },
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/images/facebook.png",
                                        width: 30.w,
                                        height: 30.h,
                                      )),
                              SizedBox(
                                width: 10.h,
                              ),
                              list[0].instagram == null
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 2000),
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return WebPage(
                                                  list[0].instagram.toString());
                                            },
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/images/instagram.png",
                                        width: 30.w,
                                        height: 30.h,
                                      )),
                              SizedBox(
                                width: 10.h,
                              ),
                              list[0].twitter == null
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 2000),
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return WebPage(
                                                  list[0].twitter.toString());
                                            },
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/images/twitter.png",
                                        width: 30.w,
                                        height: 30.h,
                                      )),
                            ],
                          ),
                        ),
                      ),
                PinterestGrid(list[0]),
              ],
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
          image: AssetImage('assets/images/logo_app_bar.png'),
          fit: BoxFit.contain,
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

class PinterestGrid extends StatelessWidget {
  SearchClass list;

  PinterestGrid(this.list);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: list.imagestring!.length + 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return index == 0
            ? InkWell(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: AdDetailsToDetails(list),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.string(
                            '<svg viewBox="0.0 0.0 41.9 41.9" ><path  d="M 41.17804336547852 0 L 0.6979329586029053 0 C 0.3126739859580994 0 0 0.3119760155677795 0 0.6979329586029053 L 0 41.17804336547852 C 0 41.56400299072266 0.3126739859580994 41.8759765625 0.6979329586029053 41.8759765625 L 41.17804336547852 41.8759765625 C 41.56330108642578 41.8759765625 41.8759765625 41.56400299072266 41.8759765625 41.17804336547852 L 41.8759765625 0.6979329586029053 C 41.8759765625 0.3119760155677795 41.56330108642578 0 41.17804336547852 0 Z M 13.04157543182373 35.47453689575195 L 10.42013931274414 34.09611892700195 L 7.798702716827393 35.47453689575195 L 8.299120903015137 32.55508422851562 L 6.178102016448975 30.48710632324219 L 9.109420776367188 30.06136703491211 L 10.42013835906982 27.4050350189209 L 11.73085594177246 30.06136703491211 L 14.66217517852783 30.48710632324219 L 12.54115676879883 32.55508422851562 L 13.04157543182373 35.47453689575195 Z M 12.54045963287354 21.77690315246582 L 13.04087829589844 24.69635581970215 L 10.41944217681885 23.31793975830078 L 7.798005104064941 24.69635581970215 L 8.298422813415527 21.77690315246582 L 6.177404403686523 19.70892715454102 L 9.108722686767578 19.28318786621094 L 10.41944122314453 16.62685585021973 L 11.73015880584717 19.28318786621094 L 14.66147804260254 19.70892715454102 L 12.54045963287354 21.77690315246582 Z M 12.54045963287354 11.24998092651367 L 13.04087829589844 14.16943454742432 L 10.41944217681885 12.79101753234863 L 7.798005104064941 14.16943454742432 L 8.298422813415527 11.24998092651367 L 6.177404403686523 9.182005882263184 L 9.108722686767578 8.756266593933105 L 10.41944122314453 6.099934101104736 L 11.73015880584717 8.756266593933105 L 14.66147804260254 9.182005882263184 L 12.54045963287354 11.24998092651367 Z M 32.80284881591797 33.50078201293945 L 16.05245780944824 33.50078201293945 L 16.05245780944824 30.70904922485352 L 32.80284881591797 30.70904922485352 L 32.80284881591797 33.50078201293945 Z M 32.80284881591797 23.03178787231445 L 16.05245780944824 23.03178787231445 L 16.05245780944824 20.24005508422852 L 32.80284881591797 20.24005508422852 L 32.80284881591797 23.03178787231445 Z M 32.80284881591797 12.56279373168945 L 16.05245780944824 12.56279373168945 L 16.05245780944824 9.771060943603516 L 32.80284881591797 9.771060943603516 L 32.80284881591797 12.56279373168945 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            'detals'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      )),
                      color: AppColors.orangeColor,
                      height: 128,
                    ),
                  ),
                ),
              )
            : index == list.imagestring!.length
                ? InkWell(
                    onTap: () {
                      ImageViewer.showImageSlider(
                        images: list.imagestring!,
                        startingPosition: 0,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        list.imagestring![0],
                        fit: BoxFit.cover,
                        height: 180,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      ImageViewer.showImageSlider(
                        images: list.imagestring!,
                        startingPosition: index,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(list.imagestring![index],
                          height: 180, fit: BoxFit.cover),
                    ),
                  );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({required this.imageData});

  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(imageData.imageUrl, fit: BoxFit.cover),
    );
  }
}
