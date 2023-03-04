import 'package:findout/Events/map.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';

import 'package:findout/api/webpage.dart';
import 'package:findout/provider/findout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  SearchClass events_list;

  EventDetails(this.events_list);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  void initState() {
    super.initState();
    var findprov = Provider.of<FindoutProvider>(context, listen: false);
    findprov.get_adv(findprov.token, context);
    if (findprov.token == "") {
    } else {
      findprov.add_counter(findprov.token, widget.events_list.id!);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            WidgetAppBar()
                .AppBarAds(context, widget.events_list.title.toString(), false),
            widget.events_list.imagestring!.length == 0
                ? Consumer<FindoutProvider>(
                    builder: (context, findprov, child) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: findprov.itemList.length == 0
                          ? Container(
                              height: 200,
                            )
                          : CustomCarouselSlider(
                              items: findprov.itemList,
                              height: height,
                              subHeight: height,
                              width: width,
                              autoplay: true,
                              showText: false,
                              showSubBackground: false,
                              indicatorShape: BoxShape.circle,
                              selectedDotColor: AppColors.blueWColor,
                              unselectedDotColor: Colors.white,
                            ),
                    ),
                  )
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.events_list.imagestring!.length,
                      itemBuilder: (BuildContext context, int index) {
                        //  Map furniture = furnitures[index];

                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                              onTap: () {
                                ImageViewer.showImageSlider(
                                  images: widget.events_list.imagestring!,
                                  startingPosition: index,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  widget.events_list.imagestring![index],
                                  fit: BoxFit.fill,
                                ),
                              )),
                        );
                      },
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  widget.events_list.counter.toString(),
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
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            SizedBox(
              width: 20.w,
            ),
            Container(
              color: AppColors.whiteColor,
              width: width,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.events_list.phone == null
                            ? Container()
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launch("tel:${widget.events_list.phone}");
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
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
                                ],
                              ),
                        SizedBox(
                          width: 20.w,
                        ),
                        widget.events_list.location == null
                            ? Container()
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapDetails(
                                            lat: double.parse(widget
                                                .events_list.location!.lat!),
                                            long: double.parse(widget
                                                .events_list.location!.long!), id: '${widget.events_list.id}', title: '${widget.events_list.title}',
                                          ),
                                        ),
                                      );
                                      // showDialogMap();
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
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
                                ],
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    (widget.events_list.facebook == null &&
                            widget.events_list.twitter == null &&
                            widget.events_list.instagram == null)
                        ? Container()
                        : Container(
                            width: width.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xffe8e8e8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    widget.events_list.facebook == null
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 2000),
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return WebPage(widget
                                                        .events_list.facebook
                                                        .toString());
                                                  },
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              "assets/images/facebook.png",
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                          ),
                                    widget.events_list.facebook == null
                                        ? Container()
                                        : SizedBox(
                                            width: 20.h,
                                          ),
                                    widget.events_list.facebook == null
                                        ? Container()
                                        : SvgPicture.string(
                                            '<svg viewBox="259.8 507.4 1.0 23.0" ><path transform="translate(259.84, 507.38)" d="M 0 0 L 0 23" fill="none" stroke="#717171" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                    widget.events_list.facebook == null
                                        ? Container()
                                        : SizedBox(
                                            width: 20.h,
                                          ),
                                    widget.events_list.instagram == null
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 2000),
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return WebPage(widget
                                                        .events_list.instagram
                                                        .toString());
                                                  },
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              "assets/images/instagram.png",
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                          ),
                                    widget.events_list.instagram == null
                                        ? Container()
                                        : SizedBox(
                                            width: 20.h,
                                          ),
                                    widget.events_list.instagram == null
                                        ? Container()
                                        : SvgPicture.string(
                                            '<svg viewBox="259.8 507.4 1.0 23.0" ><path transform="translate(259.84, 507.38)" d="M 0 0 L 0 23" fill="none" stroke="#717171" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>',
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                    widget.events_list.instagram == null
                                        ? Container()
                                        : SizedBox(
                                            width: 20.h,
                                          ),
                                    widget.events_list.twitter == null
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 2000),
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return WebPage(widget
                                                        .events_list.twitter
                                                        .toString());
                                                  },
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              "assets/images/twitter.png",
                                              width: 30.w,
                                              height: 30.h,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    widget.events_list.about_place == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                HtmlWidget('${widget.events_list.about_place}'),
                          ),
                  ],
                ),
              ),
            ),
          ],
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

  void showDialogMap() {
    double height = MediaQuery.of(context).size.height;
    showCupertinoModalBottomSheet(
      expand: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(widget.events_list.location!.lat!),
                double.parse(widget.events_list.location!.long!)),
            zoom: 14),
        markers: [
          Marker(
              markerId: MarkerId('${widget.events_list.id}'),
              infoWindow: InfoWindow(
                title: widget.events_list.title.toString(),
              ),
              position: LatLng(double.parse(widget.events_list.location!.lat!),
                  double.parse(widget.events_list.location!.long!)))
        ].toSet(),
      ),
    );
  }
}
