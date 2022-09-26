import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:adobe_xd/pinned.dart';
import 'package:animation_list/animation_list.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/ADS/AdDetails.dart';
import 'package:findout/Model/homeclass.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/ModelAppTheme/Sound.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/PageView/PageView1.dart';
import 'package:findout/api/master_api.dart';
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
import 'package:http/http.dart' as http;

class Ads extends StatefulWidget {
  List<SearchClass> search_list;
  AreaCities selectedarea;
  Cities selectedcity;
  MainCats main_cat;

  Ads(
    this.search_list,
    this.selectedarea,
    this.selectedcity,
    this.main_cat,
  );

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  late int tappedIndex;
  late bool clickMostWatched;
  late bool startListView;
  List<SearchClass> list = [];
  Sub? sub_cat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var findprov = Provider.of<FindoutProvider>(context, listen: false);
    findprov.get_adv(findprov.token, context);
    for (var j = 0; j < widget.main_cat.sub!.length; j++) {
      widget.main_cat.sub![j].checked = false;
    }
    list.addAll(widget.search_list);
    tappedIndex = 0;
    clickMostWatched = false;
    startListView = false;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        startListView = true;
      });
    });
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted)
      setState(() {
        // for (var j = 0; j <  widget.main_cat.sub!.length; j++) {
        //   widget.main_cat.sub![j].checked=false;
        // }
        // list.addAll(widget.search_list);
        list.clear();
        var findprov = Provider.of<FindoutProvider>(context, listen: false);
        search(findprov.token, widget.selectedarea, widget.selectedcity,
            widget.main_cat, sub_cat, context);
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    /// إضافة ايتم
    // savingmoney.add((savingmoney.length+1).toString());
    if (mounted)
      setState(() {
        // for (var j = 0; j <  widget.main_cat.sub!.length; j++) {
        //   widget.main_cat.sub![j].checked=false;
        // }
        // list.addAll(widget.search_list);
        list.clear();
        var findprov = Provider.of<FindoutProvider>(context, listen: false);
        search(findprov.token, widget.selectedarea, widget.selectedcity,
            widget.main_cat, sub_cat, context);
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var findprov = Provider.of<FindoutProvider>(context, listen: false);

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
            WidgetAppBar().AppBarAds(
                context,
                " ${widget.main_cat.title}" /*'entertainment'.tr()*/,
                true,
                list),
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
              height: 40.h,
              child: ListView.builder(
                itemCount: widget.main_cat.sub!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      if (kDebugMode) {
                        print(i);
                      }
                      //widget.main_cat.sub![i].id
                      setState(() {
                        for (var j = 0; j < widget.main_cat.sub!.length; j++) {
                          widget.main_cat.sub![j].checked = false;
                        }
                        widget.main_cat.sub![i].checked = true;
                        sub_cat = widget.main_cat.sub![i];
                        // tappedIndex = i;
                      });

                      list.clear();
                      print("aaa${list.length}");
                      for (var k = 0; k < widget.search_list.length; k++) {
                        print("aaa${list.length}");
                        print(
                            "aaabb${widget.search_list[k].mainCategory}////${widget.main_cat.sub![i].title}");
                        if (widget.search_list[k].subCategory ==
                            widget.main_cat.sub![i].title) {
                          setState(() {
                            list.add(widget.search_list[k]);
                            print("aaa${widget.search_list[k].title}");
                          });
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: widget.main_cat.sub![i].checked!
                              ? AppColors.blueW2Color
                              : AppColors.whiteColor,
                          // tappedIndex == i ? AppColors.blueW2Color : AppColors.whiteColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                          border: const Border(
                            top: BorderSide(
                              color: AppColors.blackColor,
                              width: .5,
                            ),
                            left: BorderSide(
                              color: AppColors.blackColor,
                              width: .5,
                            ),
                            right: BorderSide(
                              color: AppColors.blackColor,
                              width: .5,
                            ),
                            bottom: BorderSide(
                              color: AppColors.blackColor,
                              width: .5,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${widget.main_cat.sub![i].title}",
                            // "طبيعة واسترخاء",
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.sp,
                                color: AppColors.blackColor),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "مدينة ${widget.selectedcity.title}", //'مدينة جدة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickMostWatched = !clickMostWatched;
                        print(clickMostWatched);
                        if (clickMostWatched) {
                          list.sort((b, a) => a.counter!.compareTo(b.counter!));
                        } else {
                          list.sort((b, a) => a.is_special!.compareTo(b.is_special!));
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'mostWatched'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: clickMostWatched
                                ? AppColors.blueW2Color
                                : AppColors.gryColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        !clickMostWatched
                            ? Image.asset(
                                "assets/images/filter.png",
                                width: 16.w,
                                height: 14.h,
                              )
                            : Image.asset(
                                "assets/images/active_filter.png",
                                width: 16.w,
                                height: 14.h,
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            startListView
                ? Expanded(
                    child: AnimationList(
                      duration: 2000,
                      reBounceDepth: 30,
                      // children: data.map((item) {
                      //   return _buildTile(item['title'], item['backgroundColor']);
                      // }).toList()),
                      children: [
                        for (var i = 0; i < list.length; i++)
                          InkWell(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: AdDetails(list[i]),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            child: ItemsADS(list[i]),
                          )
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
   var AVGRating=(list.avgRates) ;
    double formattedDouble = double.parse(AVGRating!);
    var AVGRating2 = double.parse(formattedDouble.toStringAsFixed(1));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0,right: 8.0,left: 8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
        ),
        child: Center(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  list.images!.length == 0
                      ? Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image:
                                  AssetImage('assets/images/logo_app_bar.png'),
                              fit: BoxFit.contain,
                            ),
                            border: Border.all(
                                width: 0.3, color: const Color(0xffe8e8e8)),
                          ),
                        )
                      : Container(
                          width: 80.w,
                          height: 80.h,
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
                  Positioned(
                    left: 10.r,
                    top: 10.r,
                    child: Container(
                      // width: 20,
                      // height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.0),
                        // color: const Color(0xffffffff),
                      ),
                      child: Center(
                        child: LikeButton(
                          isLiked: list.favorite,
                          size: 17,
                          circleColor: const CircleColor(
                              start: Colors.red, end: Colors.red),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.red,
                            dotSecondaryColor: Colors.red,
                          ),
                          likeBuilder: (bool isLiked) {
                            return Center(
                              child: Icon(
                                Icons.favorite,
                                color: isLiked ? Colors.red : Colors.white,
                                size: 30,
                              ),
                            );
                          },
                          onTap: (bool isLiked) async {
                            PlaySound().play();
                            var findprov = Provider.of<FindoutProvider>(context,
                                listen: false);
                            setState(() {
                              widget
                                  .search_list[widget.search_list.indexWhere(
                                      (element) => element.id == list.id)]
                                  .favorite = !isLiked;

                              print(
                                  "xxx${widget.search_list[widget.search_list.indexWhere((element) => element.id == list.id)].title}");
                            });
                            findprov.addfav(
                                findprov.token, list.id!, 0, context);

                            return !isLiked;
                          },
                          // onLikeButtonTapped,
                          // likeCount: 665,
                          countBuilder:
                              (int? count, bool? isLiked, String? text) {
                            var color = isLiked! ? Colors.red : Colors.grey;
                            // Widget result;
                            // if (count == 0) {
                            //   result = Text(
                            //     "love",
                            //     style: TextStyle(color: color),
                            //   );
                            // } else
                            //   result = Text(
                            //     text!,
                            //     style: TextStyle(color: color),
                            //   );
                            // return result;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      SizedBox(
                        width: width / 2.5.w,
                      ),
                      SvgPicture.string(
                        '<svg viewBox="0.0 0.0 10.5 10.5" ><path transform="translate(0.0, 0.0)" d="M 5.253152847290039 0 C 2.352510929107666 0 0.001001358032226562 2.351531982421875 0.001001358032226562 5.252159595489502 C 0.001001358032226562 8.152682304382324 2.352475643157959 10.50442504882812 5.253082275390625 10.50442504882812 C 8.153690338134766 10.50442504882812 10.50540924072266 8.152682304382324 10.50540924072266 5.252159595489502 C 10.50540924072266 2.351531982421875 8.153724670410156 0 5.253152847290039 0 Z M 6.626634120941162 7.640212059020996 C 6.530834197998047 7.735939979553223 6.405307292938232 7.783805370330811 6.279920101165771 7.783805370330811 C 6.154498100280762 7.783805370330811 6.028900623321533 7.735939979553223 5.933206081390381 7.640141487121582 L 3.962060689926147 5.669110774993896 C 3.932718276977539 5.650308132171631 3.904671669006348 5.628704071044922 3.879146099090576 5.603074073791504 C 3.781245708465576 5.505067825317383 3.734010934829712 5.376215934753418 3.736391544342041 5.24788761138916 C 3.734115600585938 5.119489669799805 3.781245231628418 4.990531921386719 3.879146099090576 4.892631530761719 C 3.904846906661987 4.867035388946533 3.932718276977539 4.845396995544434 3.962060689926147 4.826594352722168 L 5.924382209777832 2.864282846450806 C 6.115911960601807 2.672929048538208 6.426490783691406 2.672858715057373 6.617950916290283 2.86438775062561 C 6.809480667114258 3.055811166763306 6.809480667114258 3.366318941116333 6.617950916290283 3.557952880859375 L 4.927972316741943 5.247922897338867 L 6.626668453216553 6.946681499481201 C 6.818129539489746 7.138175487518311 6.818129539489746 7.448682308197021 6.626634120941162 7.640212059020996 Z" fill="#5096ff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ],
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
                              list.counter.toString(), //   '100',
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
                              width: 10.w,
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
                              AVGRating2.toString() ,
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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    PlaySound().play();

    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget ItemsHorizantl(int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color:
              tappedIndex == i ? AppColors.blueW2Color : AppColors.whiteColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
          border: const Border(
            top: BorderSide(
              color: AppColors.blackColor,
              width: .5,
            ),
            left: BorderSide(
              color: AppColors.blackColor,
              width: .5,
            ),
            right: BorderSide(
              color: AppColors.blackColor,
              width: .5,
            ),
            bottom: BorderSide(
              color: AppColors.blackColor,
              width: .5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "طبيعة واسترخاء",
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                color: AppColors.blackColor),
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

  Future<dynamic> search(
      String token,
      AreaCities selectedarea,
      Cities selectedcity,
      MainCats main_cat,
      Sub? sub_cat,
      // int area,
      // int city,
      // int main_cat,
      BuildContext context) async {
    GF().loading();
    String? url;
    if (sub_cat == null) {
      url = MasterAPi.API_URL_SEARCH +
          "?area=${selectedarea.id}&city=${selectedcity.id}&cat=${main_cat.id}";
    } else {
      url = MasterAPi.API_URL_SEARCH +
          "?area=${selectedarea.id}&city=${selectedcity.id}&cat=${main_cat.id}&sub_cat=${sub_cat.id}";
    }

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
      print("aaa$url");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          setState(() {
            list.add(SearchClass.fromJson(item));
          });
        }

        GF().dismissLoading();

        // print("ddd${_markers.length}");
      }
    }).catchError((e) {
      print('eeee:${e.toString()}');
      GF().dismissLoading();
    });
  }
}
