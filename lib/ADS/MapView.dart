import 'dart:async';

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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MapView extends StatefulWidget {
  List<SearchClass> list;
  MapView(this.list);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static LatLng _center = const LatLng(24.774265, 46.738586);
  LatLng _lastMapPostion = _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  late bool isLocationEnabled;
  late BuildContext _context;

  late String _currentAddress = "";
  late LatLng _myLoc = LatLng(24.774265, 46.738586);
  late BitmapDescriptor customIcon;
  // Set<Marker> markers = Set.from([]);
  final ScrollController _controllerList = ScrollController();
  late PageController _pageController;

  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 0.5;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String Address = "EnterAddress".tr();
  Future<void> animateToChange({required int index}) async {
    final c = await _controller.future;
    final p = CameraPosition(
        target: LatLng(
            double.parse(widget.list[index].location!.lat.toString()),
            double.parse(widget.list[index].location!.long.toString())),
        zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _getCurrentPosition1();
    for (var i = 0; i < widget.list.length; i++) {
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(
              widget.list[i].id.toString(),
            ),
            // icon: bitmapDescriptor,
            onTap: () {
          
         
             _pageController.animateToPage(widget.list
                  .indexWhere((element) => element.id == widget.list[i].id),duration: Duration(milliseconds: 500), curve: Curves.ease);

            },
            //for marker
            infoWindow: InfoWindow(
              title: widget.list[i].title.toString(),
              onTap: () {
                pushNewScreen(
                  context,
                  screen: AdDetails(widget.list[i]),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
            position: LatLng(
                double.parse(widget.list[i].location!.lat.toString()),
                double.parse(widget.list[i].location!.long.toString()))));
      });
    }
  }

  var maptype = MapType.normal;

  // _updateLocation(int index) async {
  //   _myLoc = LatLng(double.parse(widget.list[index].location!.lat.toString()),
  //       double.parse(widget.list[index].location!.lat.toString()));
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: _currentMapType,
                initialCameraPosition: CameraPosition(
                    target: _myLoc != null ? _myLoc : _center, zoom: 8.0),
                onMapCreated: _onMapCreated,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                // myLocationEnabled = false,
              )),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                WidgetAppBar().AppBarAds(context, 'Map'.tr(), false),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: height / 4.h,
                    child: PageView.builder(
                      // controller: _controllerList,
                      itemCount: widget.list.length,
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          animateToChange(index: page);
                        });
                      },
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: AdDetails(widget.list[i]),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: ItemsADS(widget.list[i]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ItemsADS(SearchClass list) {
    final width = MediaQuery.of(context).size.width;
    var AVGRating = (list.avgRates);
    double formattedDouble = double.parse(AVGRating!);
    var AVGRating2 = double.parse(formattedDouble.toStringAsFixed(1));
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  list.imagestring!.length == 0
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
                              image: NetworkImage(list.imagestring![0]),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.0),
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
                                  .list[widget.list.indexWhere(
                                      (element) => element.id == list.id)]
                                  .favorite = !isLiked;

                              print(
                                  "xxx${widget.list[widget.list.indexWhere((element) => element.id == list.id)].title}");
                            });
                            findprov.addfav(
                                findprov.token, list.id!, 0, context);

                            return !isLiked;
                          }, // onLikeButtonTapped,

                          countBuilder:
                              (int? count, bool? isLiked, String? text) {
                            var color = isLiked! ? Colors.red : Colors.grey;
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
                  SizedBox(
                    width: width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            list.title.toString(),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SvgPicture.string(
                          '<svg viewBox="96.0 32.0 10.8 15.1" ><path  d="M 101.3882293701172 32 C 98.41728973388672 32 96 34.3118896484375 96 37.15249252319336 C 96 38.50527954101562 96.61661529541016 40.30427551269531 97.83267211914062 42.4996452331543 C 98.80928802490234 44.26226806640625 99.93913269042969 45.85617446899414 100.5267944335938 46.64925765991211 C 100.7281875610352 46.92409133911133 101.0485153198242 47.08648681640625 101.3892364501953 47.08648681640625 C 101.7299728393555 47.08648681640625 102.0503005981445 46.92409133911133 102.2517013549805 46.64925765991211 C 102.8383407592773 45.85617446899414 103.9692001342773 44.26226806640625 104.9458084106445 42.4996452331543 C 106.1598510742188 40.30494689941406 106.7764587402344 38.50595474243164 106.7764587402344 37.15249252319336 C 106.7764587402344 34.3118896484375 104.3591613769531 32 101.3882293701172 32 Z M 101.3882293701172 39.54352188110352 C 100.1978988647461 39.54352188110352 99.23293304443359 38.57856750488281 99.23293304443359 37.38822937011719 C 99.23293304443359 36.19789505004883 100.1978988647461 35.23294067382812 101.3882293701172 35.23294067382812 C 102.5785675048828 35.23294067382812 103.5435256958008 36.19789505004883 103.5435256958008 37.38822937011719 C 103.5422286987305 38.57802963256836 102.5780258178711 39.54222869873047 101.3882293701172 39.54352188110352 Z" fill="#ff8a15" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          list.details == null
                              ? ""
                              : list.details
                                  .toString(), //   'لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور أدايبا يسكينج أليايت,سيت دو أيوسمود تيمبور',
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
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                      AVGRating2.toString(),
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

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    Future.delayed(const Duration(milliseconds: 2500), () {
      _getCurrentPosition1();
    });
  }

  _getCurrentPosition1() async {


    _myLoc = LatLng(double.parse(widget.list[0].location!.lat.toString()),
        double.parse(widget.list[0].location!.long.toString()));

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(double.parse(widget.list[0].location!.lat.toString()),
              double.parse(widget.list[0].location!.long.toString())),
          zoom: 15.0),
    ));
  }

  Future<void> GetAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    setState(() {});
  }

  void _onAddMarker(BuildContext context) async {
    await GetAddressFromLatLong(_myLoc);

    Map<String, dynamic> sendData = Map();
    sendData["loc_latLng"] = _myLoc;
    sendData["loc_name"] = Address;
    Navigator.pop(context, sendData);
  }
}
