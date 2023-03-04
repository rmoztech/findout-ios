import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findout/Model/homeclass.dart';
import 'package:findout/ModelAppTheme/AppBar.dart';
import 'package:findout/ModelAppTheme/Colors.dart';
import 'package:findout/ModelAppTheme/GF.dart';

import 'package:findout/cur_loc.dart';
import 'package:findout/provider/findout_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';


class AddPlace extends StatefulWidget {
  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {

  late LatLng fromPlace, toPlace ;
  late String fromPlaceLat ="0.0", fromPlaceLng="0.0" , fPlaceName ;
  Map <String , dynamic > sendData = Map();
  String address=  'currentLocation'.tr();

  @override
  void initState() {


    super.initState();


  }
  TextEditingController ControllertxtName = TextEditingController();
  TextEditingController ControllertxtDescription = TextEditingController();
  TextEditingController ControllertxtPhone = TextEditingController();
  TextEditingController ControllertxtWeb = TextEditingController();
  TextEditingController ControllertxtFacebook = TextEditingController();
  TextEditingController ControllertxtTwitter = TextEditingController();
  TextEditingController ControllertxtInstagram = TextEditingController();
  TextEditingController ControllertxtArea = TextEditingController();
  TextEditingController ControllertxtCity = TextEditingController();
  TextEditingController ControllertxtLat = TextEditingController();
  TextEditingController ControllertxtLong = TextEditingController();
  TextEditingController ControllertxtAM = TextEditingController();
  TextEditingController ControllertxtPM = TextEditingController();

  final List<Cities> CityItems = [];
  AreaCities? selectedValue;
  Cities? selectedValue2;
  String _error = 'No Error Dectected';
  int picno = 0;


  List<Asset> images = <Asset>[];
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: 'appTitle'.tr(),
          doneButtonTitle: "continue".tr(),
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#FF8A15",
          actionBarTitle: 'appTitle'.tr(),
          allViewTitle: 'AllPhotos'.tr(),
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var findprov = Provider.of<FindoutProvider>(context, listen: false);

    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0,left: 15),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              WidgetAppBar().AppBarAds(context, 'add'.tr(), false),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: loadAssets,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: const Color(0xffffffff),
                    border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                  ),
                  child: Center(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        images.length == 0?  SvgPicture.string(
                          '<svg viewBox="188.6 176.1 50.9 34.8" ><path transform="translate(188.56, 139.79)" d="M 29.34644889831543 59.40786361694336 L 21.53656768798828 59.40786361694336 L 21.53656768798828 51.59820556640625 L 29.34644889831543 51.59820556640625 L 29.34644889831543 59.40786361694336 Z M 13.12339401245117 39.88382720947266 L 50.88301467895508 39.88382720947266 L 50.88301467895508 71.12223815917969 L 0 71.12223815917969 L 0 39.88382720947266 L 3.887241363525391 39.88382720947266 L 3.887241363525391 36.30099868774414 L 13.12339401245117 36.30099868774414 L 13.12339401245117 39.88382720947266 Z M 36.79351043701172 46.40547943115234 L 46.85750579833984 46.40547943115234 L 46.85750579833984 43.26533508300781 L 36.79351043701172 43.26533508300781 L 36.79351043701172 46.40547943115234 Z M 14.57245445251465 55.50270080566406 C 14.57245445251465 61.50601196289062 19.43864059448242 66.37197113037109 25.44150733947754 66.37197113037109 C 31.44437789916992 66.37197113037109 36.31056594848633 61.50601196289062 36.31056594848633 55.50270462036133 C 36.31056594848633 49.5004997253418 31.44437789916992 44.63386917114258 25.44150733947754 44.63386917114258 C 19.43863868713379 44.63386917114258 14.57245445251465 49.50049591064453 14.57245445251465 55.50270080566406 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ): Container(height:85,child: buildGridView()),
                        Text(
                          'ChoosePicture'.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: AppColors.blackColor,
                          ),
                        )
                      ],
                    ),
                  ),
                )
                  ,
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'nameOfThePlace'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'nameOfThePlace'.tr(),
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'DescriptionOfThePlace'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  maxLength: 36,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtDescription,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'DescriptionOfThePlace'.tr(),
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'MobileNumber'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: Row(
                  children: [
                    Text(
                      '+966',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 10.w,),
                    SizedBox(
                      width: width/1.3.w,
                      height: 40.h,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: ControllertxtPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'MobileNumber'.tr(),
                          border: InputBorder.none,
                          labelStyle: const TextStyle(
                            fontSize: 8.932700157165527,
                          ),
                          hintStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'website'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtWeb,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'website'.tr(),
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left:8 ),
                child: Row(
                  children: [
                    Text(
                      'account'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtFacebook,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Facebook',
                    border: InputBorder.none,
                    labelStyle: const TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle:  TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtTwitter,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Twitter',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: width.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: const Color(0xffffffff),
                  border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: ControllertxtInstagram,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Instagram',
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      fontSize: 8.932700157165527,
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'Address'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
             
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      height: 70.0,
                      width: width/2.2,
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                         
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                          ),


                        ),
                        isExpanded: true,
                        hint: Center(
                          child: Text(
                            'chose'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.blueWColor,
                        ),
                        iconSize: 0,
                        buttonHeight: 40,
                        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        items: findprov.cities_list.map((item) => DropdownMenuItem<AreaCities>(
                          value: item,
                          child: Text(
                            item.title!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        )).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'chose'.tr();
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as AreaCities?;
                            CityItems.clear();
                            CityItems.addAll(selectedValue!.cities!);
                            selectedValue2=selectedValue!.cities![0];


                          });
                          setState(() {




                          });

                        },
                        onSaved: (value) {
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.black45,),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40.0,
                    width: width/2.2,
                    child: DropdownButton<Cities>(
                      items: CityItems.map((Cities value) {
                        return DropdownMenuItem<Cities>(
                          value: value,
                          child: Text(value.title!),
                        );
                      }).toList(),
                      value: selectedValue2,
                      isExpanded: true,
                      hint: Center(
                        child: Text(
                          'chose2'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.blueW2Color,
                      ),
                      iconSize: 0,
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (v) {
                        setState(() {
                          selectedValue2 = v;
                        });
                      },
                    ),
                  ),
                ],
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    sendData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CurrentLocation2()),
                    );
                    setState(() {
                      fromPlace = sendData["loc_latLng"];
                      fromPlaceLat = fromPlace.latitude.toString();
                      fromPlaceLng = fromPlace.longitude.toString();
                      fPlaceName = sendData["loc_name"];
                      address=fPlaceName;
                
                    });

                  },
                  child: Container(
                    width: width.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border:
                      Border.all(width: 1.0, color: AppColors.blackColor),
                    ),
                    child:Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              child: Text(
                                address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14.sp,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Icon(
                              Icons.location_on_rounded,
                              color: Colors.black,
                              size: 36.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 30.h,
              ),


              Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8),
                child: Row(
                  children: [
                    Text(
                      'timesOfWork'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width/2.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: const Color(0xffffffff),
                      border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: ControllertxtAM,
                      keyboardType: TextInputType.datetime,
                      decoration:  const InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          fontSize: 8.932700157165527,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width/2.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: const Color(0xffffffff),
                      border: Border.all(width: 1.0, color: const Color(0xffe8e8e8)),
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: ControllertxtPM,
                      keyboardType: TextInputType.datetime,
                      decoration:  const InputDecoration(

                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          fontSize: 8.932700157165527,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100.h,
              ),

              InkWell(
                onTap: (){
                  if(selectedValue2==null||ControllertxtName.text.isEmpty||images.length==0){
                    GF().ToastMessage(context, "CompleteData".tr(), const Icon(Icons.info));
                  }else{
                    findprov.addplace(findprov.token,selectedValue!,selectedValue2!,images,
                        ControllertxtName.text,
                        ControllertxtDescription.text.isEmpty?"":   ControllertxtDescription.text,
                        ControllertxtPhone.text.isEmpty?"":     "966"+ControllertxtPhone.text,
                        ControllertxtWeb.text.isEmpty?"":     ControllertxtWeb.text,
                        ControllertxtFacebook.text.isEmpty?"":    ControllertxtFacebook.text,
                        ControllertxtTwitter.text.isEmpty?"":    ControllertxtTwitter.text,
                        ControllertxtInstagram.text.isEmpty?"":    ControllertxtInstagram.text,
                        fromPlaceLat==null?"":  fromPlaceLat,
                        fromPlaceLng==null?"": fromPlaceLng,
                        ControllertxtAM.text.isEmpty?"":   ControllertxtAM.text,
                        ControllertxtPM.text.isEmpty?"":   ControllertxtPM.text,
                        context);
                  }
                },
                child: Container(
                  width: 200.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: AppColors.orangeColor,
                  ),
                  child: Center(
                    child: Text(
                      'submit'.tr(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
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
}
