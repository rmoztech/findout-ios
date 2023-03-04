// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:findout/ADS/AdDetails_id.dart';
import 'package:findout/ADS/Ads.dart';
import 'package:findout/Model/homeclass.dart';
import 'package:findout/Model/searchclass.dart';
import 'package:findout/ModelAppTheme/GF.dart';
import 'package:findout/NavigationBottomBar.dart';
import 'package:findout/api/master_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import '../ModelAppTheme/Colors.dart';

class FindoutProvider with ChangeNotifier {
  late String _token = "";
  late String _facebook = "";
  late String _twitter = "";
  late String _instagram = "";

  late List<Ads1> _ads_list = [];
  late List<AreaCities> _cities_list = [];
  late List<MainCats> _main_cat_list = [];
  late List<CarouselItem> _itemList = [];
  late List<CarouselItem> _itemListAds = [];

  late List<PieChartSectionData> _pieChartsectionList = [];
  late List<SearchClass> _search_list = [];
  late List<SearchClass> _search_list_id = [];

  late List<SearchClass> _fav_list = [];
  late List<SearchClass> _events_list = [];
  late List<SearchClass> _events_now_list = [];

  bool _load_login = false;
  List<SearchClass> get search_list_id => _search_list_id;

  List<Ads1> get ads_list => _ads_list;

  List<AreaCities> get cities_list => _cities_list;

  List<MainCats> get main_cat_list => _main_cat_list;

  List<CarouselItem> get itemList => _itemList;
  List<CarouselItem> get itemListAds => _itemListAds;

  List<PieChartSectionData> get pieChartsectionList => _pieChartsectionList;

  List<SearchClass> get search_list => _search_list;

  List<SearchClass> get fav_list => _fav_list;

  List<SearchClass> get events_list => _events_list;

  List<SearchClass> get events_now_list => _events_now_list;

  String get token => _token;

  String get facebook => _facebook;

  String get twitter => _twitter;

  String get instagram => _instagram;

  FindoutProvider() {}
  Future<dynamic> add_counter(String token, int id) async {
    String url = MasterAPi.API_URL_ADD_COUNT + id.toString();
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        print("count $body");
      }
    }).catchError((e) {
      print('eeee:${e.toString()}');
      notifyListeners();
    });
  }

  Future<dynamic> regester(BuildContext context) async {
    String url = MasterAPi.API_URL_USER_REGESTER;

    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (body['success']) {
          _token = body['data'].toString();
          notifyListeners();
          getToken(_token);
          get_city_area(_token);
          get_home(_token);
          events(_token, 4);
          get_fav_properties(_token);
          socials(_token);
          saveUserTosharedPref(_token);
        } else {
          notifyListeners();
        }
      }
    }).catchError((e) {
      print('catchError regester    :${e.toString()}');

      notifyListeners();
    });
  }

  getToken(String access_token) async {
    var tokenFirebaseMessaging = (await FirebaseMessaging.instance.getToken())!;

    Token(access_token, tokenFirebaseMessaging);
  }

  Future<dynamic> Token(String access_token, token) async {
    String url = MasterAPi.API_UPDATE_FCM_TOKEN;
    var headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': 'en',
      'Content-Type': 'appilcation/json',
      'Accept': 'appilcation/json',
      'Authorization': 'Bearer $access_token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({'token': '$token'});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> savetoken(String token) async {
    _token = token;
    notifyListeners();
    get_city_area(_token);
    get_home(_token);
    events(_token, 4);
    get_fav_properties(_token);
    socials(_token);
    saveUserTosharedPref(_token);
  }

  Future<void> saveUserTosharedPref(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<dynamic> get_adv(String token, BuildContext context) async {
    String url = MasterAPi.API_URL_GET_DV;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      // print("****************************");

      // print("response.statusCode   ${response.statusCode}");
      // print("response.body    ${response.body}");
      // print("****************************");

      _ads_list.clear();
      _itemList.clear();

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          // print('item');

          // print(item);
          _ads_list.add(Ads1.fromJson(item));

          if (item['city_id'] == null) {
            _itemList.add(
              CarouselItem(
                image: NetworkImage(
                  Ads1.fromJson(item).image!,
                ),
                title: Ads1.fromJson(item).title,
                titleTextStyle: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Raleway',
                  color: Colors.white,
                ),
                onImageTap: (i) {
                  if (Ads1.fromJson(item).service_id == null) {
                  } else {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 2000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          // return AdDetailsID(int.parse(Ads1.fromJson(item).service_id!.toString())

                          return AdDetailsID(Ads1.fromJson(item).service_id!);
                        },
                      ),
                    );
                  }
                },
              ),
            );
            notifyListeners();
          }
        }
      }
    }).catchError((e) {
      print('catchError get_adv     :${e.toString()}');
      notifyListeners();
    });
  }

  Future<dynamic> get_advInCity(
      String token, Cities selectedcity, BuildContext context) async {
    String url = MasterAPi.API_URL_GET_DV;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _ads_list.clear();
      _itemListAds.clear();
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          _ads_list.add(Ads1.fromJson(item));
          if (item['city_id'] != null) {
            if (selectedcity.id == int.parse(item['city_id'].toString())) {
              _itemListAds.add(
                CarouselItem(
                  image: NetworkImage(
                    Ads1.fromJson(item).image!,
                  ),
                  title: Ads1.fromJson(item).title,
                  titleTextStyle: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'Raleway',
                    color: Colors.white,
                  ),
                  onImageTap: (i) {
                    if (Ads1.fromJson(item).service_id == null) {
                    } else {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 2000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return AdDetailsID(Ads1.fromJson(item).service_id!);
                          },
                        ),
                      );
                    }
                  },
                ),
              );
            }
          }
          notifyListeners();
        }
      }
    }).catchError((e) {
      print('catchError get_adv ggg    :${e.toString()}');
      notifyListeners();
    });
  }

  Future<dynamic> get_city_area(
    String token,
  ) async {
    String url = MasterAPi.API_URL_GET_CITY_AREA;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _cities_list.clear();

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          _cities_list.add(AreaCities.fromJson(item));

          notifyListeners();
        }
      }
    }).catchError((e) {
      print('catchError get_city_area    :${e.toString()}');
      notifyListeners();
    });
  }

  Future<dynamic> get_home(
    String token,
  ) async {
    String url = MasterAPi.API_URL_GET_HOME;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _main_cat_list.clear();

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        for (var item in body["data"]) {
          print('item item item item item item ');

          print(item);
          if (MainCats.fromJson(item).id == 4) {
          } else {
            _main_cat_list.add(MainCats.fromJson(item));
            if (MainCats.fromJson(item).id == 1) {
              _pieChartsectionList.add(
                PieChartSectionData(
                  borderSide: const BorderSide(width: 0.2, color: Colors.grey),
                  color: AppColors.whiteColor,
                  value: 33.33,
                  showTitle: false,
                  radius: 72.r,
                  badgeWidget: RotationTransition(
                    turns: AlwaysStoppedAnimation((30 / 360) * -1),
                    child: Text(
                      MainCats.fromJson(item).title.toString(),
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: AppColors.blackColor),
                    ),
                  ),
                  titleStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              );
            }
            if (MainCats.fromJson(item).id == 2) {
              _pieChartsectionList.add(
                PieChartSectionData(
                  borderSide: const BorderSide(width: 0.2, color: Colors.grey),
                  color: AppColors.whiteColor,
                  value: 33.33,
                  showTitle: false,
                  radius: 72.r,
                  badgeWidget: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      MainCats.fromJson(item).title.toString(),
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: AppColors.blackColor),
                    ),
                  ),
                  titleStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              );
            }
            if (MainCats.fromJson(item).id == 3) {
              _pieChartsectionList.add(
                PieChartSectionData(
                  borderSide: const BorderSide(width: 0.2, color: Colors.grey),
                  color: AppColors.whiteColor,
                  value: 33.33,
                  showTitle: false,
                  radius: 72.r,
                  badgeWidget: RotationTransition(
                    turns: AlwaysStoppedAnimation((30 / 360)),
                    child: Text(
                      MainCats.fromJson(item).title.toString(),
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: AppColors.blackColor),
                    ),
                  ),
                  titleStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              );
            }
            notifyListeners();
          }
        }
      }
    }).catchError((e) {
      notifyListeners();
    });
  }

  Future<dynamic> redrawchart(
    List<MainCats> list,
    int touchedIndex,
  ) async {
    _pieChartsectionList.clear();
    for (var i = 0; i < list.length; i++) {
      if (i == touchedIndex) {
        if (list[i].id == 2) {
          _pieChartsectionList.add(
            PieChartSectionData(
              borderSide: const BorderSide(width: 0.2, color: Colors.grey),
              color: AppColors.blueW2Color,
              value: 33.33,
              showTitle: false,
              badgeWidget: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  list[i].title.toString(),
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor),
                ),
              ),
              radius: 70,
              titleStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.whiteColor),
            ),
          );
        } else {
          _pieChartsectionList.add(
            PieChartSectionData(
              borderSide: const BorderSide(width: 0.2, color: Colors.grey),
              color: AppColors.blueW2Color,
              value: 33.33,
              showTitle: false,
              badgeWidget: list[i].id == 1
                  ? RotationTransition(
                      turns: AlwaysStoppedAnimation((30 / 360) * -1),
                      child: Text(
                        list[i].title.toString(),
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor),
                      ),
                    )
                  : list[i].id == 3
                      ? RotationTransition(
                          turns: AlwaysStoppedAnimation((30 / 360)),
                          child: Text(
                            list[i].title.toString(),
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                          ),
                        )
                      : Text(
                          list[i].title.toString(),
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor),
                        ),
              radius: 70,
              titleStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor),
            ),
          );
        }
      } else {
        if (list[i].id == 1) {
          _pieChartsectionList.add(
            PieChartSectionData(
              borderSide: const BorderSide(width: 0.2, color: Colors.grey),
              color: AppColors.whiteColor,
              value: 33.33,
              showTitle: false,
              radius: 70,
              badgeWidget: RotationTransition(
                turns: AlwaysStoppedAnimation((15 / 360) * -1),
                child: Text(
                  list[i].title.toString(),
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              ),
              titleStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: AppColors.blackColor),
            ),
          );
        }
        if (list[i].id == 2) {
          _pieChartsectionList.add(
            PieChartSectionData(
              borderSide: const BorderSide(width: 0.2, color: Colors.grey),
              color: AppColors.whiteColor,
              value: 33.33,
              showTitle: false,
              radius: 70,
              badgeWidget: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  list[i].title.toString(),
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              ),
              titleStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: AppColors.blackColor),
            ),
          );
        }
        if (list[i].id == 3) {
          _pieChartsectionList.add(
            PieChartSectionData(
              borderSide: const BorderSide(width: 0.2, color: Colors.grey),
              color: AppColors.whiteColor,
              value: 33.33,
              showTitle: false,
              radius: 70,
              badgeWidget: RotationTransition(
                turns: AlwaysStoppedAnimation((15 / 360)),
                child: Text(
                  list[i].title.toString(),
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      color: AppColors.blackColor),
                ),
              ),
              titleStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: AppColors.blackColor),
            ),
          );
        }
      }

      notifyListeners();
    }
    notifyListeners();
  }

  Future<dynamic> searchcount(
      {String? token,
      AreaCities? selectedarea,
      Cities? selectedcity,
      MainCats? main_cat,
      BuildContext? context}) async {
    GF().loading();

    String url = MasterAPi.API_URL_SEARCH +
        "?area=${selectedarea!.id}&city=${selectedcity!.id}&cat=${main_cat!.id}";
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _search_list.clear();
      notifyListeners();
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        //  for (var item in body["data"]) {
        //         print(item);
        //       }
        for (var item in body["data"]) {
          _search_list.add(SearchClass.fromJson(item));
          _search_list.sort((b, a) => a.is_special!.compareTo(b.is_special!));

          notifyListeners();
        }

        GF().dismissLoading();
      }
    }).catchError((e) {
      print('catchError searchcount    :${e.toString()}');
      GF().dismissLoading();

      notifyListeners();
    });
  }

  Future<dynamic> searchcountWithoutCat(
      {String? token,
      AreaCities? selectedarea,
      Cities? selectedcity,
      BuildContext? context}) async {
    // print('selectedcity!.id');
    // print(selectedcity!.id);
    // print('selectedarea!.id');
    // print(selectedarea!.id);

    String url = MasterAPi.API_URL_SEARCH +
        "?area=${selectedarea!.id}&city=${selectedcity!.id}";
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    _search_list.clear();
    notifyListeners();
    int i = 0;

    for (var i = 1; i <= 3; i++) {
      // print(url + '&cat=$i');
      http.get(Uri.parse(url + '&cat=$i'), headers: headers).then((response) {
        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);

          // print(response.body);

          // for (var item in body["data"]) {
          //   print("------------ $i");
          //   print(item['title']);
          //   print(item['avg_rates']);

          //   i++;
          // }
          for (var item in body["data"]) {
            _search_list.add(SearchClass.fromJson(item));

            _search_list.sort((b, a) => a.is_special!.compareTo(b.is_special!));
            notifyListeners();
          }
        }
      }).catchError((e) {
        print('catchError searchcountWithoutCat  :${e.toString()}');

        notifyListeners();
      });
    }
  }

  Future<dynamic> events(
    String token,
    int main_cat,
  ) async {
    // GF().loading();

    String url = MasterAPi.API_URL_SEARCH + "?cat=${main_cat}";
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _events_list.clear();
      _events_now_list.clear();

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          if (SearchClass.fromJson(item).eventNow!) {
            _events_now_list.add(SearchClass.fromJson(item));
            _events_now_list
                .sort((b, a) => a.is_special!.compareTo(b.is_special!));
          }
          _events_list.add(SearchClass.fromJson(item));
          _events_list.sort((b, a) => a.is_special!.compareTo(b.is_special!));

          notifyListeners();
        }
      }
    }).catchError((e) {
      print('catchError events    :${e.toString()}');

      notifyListeners();
    });
  }

  Future<dynamic> addplace(
      String token,
      AreaCities selectedarea,
      Cities selectedcity,
      List<Asset> images,
      String title,
      String Description,
      String Phone,
      String Web,
      String Facebook,
      String Twitter,
      String Instagram,
      String Lat,
      String lng,
      String txtAM,
      String txtPM,
      BuildContext context) async {
    GF().loading();
    String url = MasterAPi.API_URL_ADD_PLACE;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var map = Map<String, dynamic>();

    for (var i = 0; i < images.length; i++) {
      ByteData byteData = await images[i].getByteData(quality: 20);
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(imageData,
          filename: images[i].name, contentType: MediaType('image', 'jpg'));
      map['image[$i]'] = multipartFile;
    }

    map['title'] = title;
    map['area'] = selectedarea.id.toString();
    map['city'] = selectedcity.id.toString();
    if (Phone == "") {
    } else {
      map['phone'] = Phone;
    }

    if (Web == "") {
    } else {
      map['website'] = Web;
    }

    if (Facebook == "") {
    } else {
      map['facebook'] = Facebook;
    }
    if (Twitter == "") {
    } else {
      map['twitter'] = Twitter;
    }
    if (Instagram == "") {
    } else {
      map['instagram'] = Instagram;
    }
    map['address'] = "price_consult";

    if (txtAM == "") {
    } else {
      map['time_in'] = txtAM;
    }
    if (txtPM == "") {
    } else {
      map['time_out'] = txtPM;
    }
    if (Description == "") {
    } else {
      map['details'] = Description;
    }

    FormData formData = FormData.fromMap(map);
    var dio = Dio();
    var response = await dio
        .post(
      url,
      data: formData,
      options: Options(
        headers: headers,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var body = (response.data);
        _load_login = false;
        notifyListeners();
        if (body['success']) {
          GF().dismissLoading();
          showDialogCompleted(
              context,
              'YourRequestHasBeenSuccessfullySent'.tr(),
              'YourRequestUnderReview'.tr(),
              0);
        } else {
          GF().dismissLoading();
          GF().ToastMessage(context, "Problem".tr(), const Icon(Icons.info));
        }
      } else {
        GF().dismissLoading();
        GF().ToastMessage(context, "Problem".tr(), const Icon(Icons.info));
      }
    }).catchError((e) {
      GF().dismissLoading();
      print("catchError addplace    $e");
      GF().ToastMessage(context, "Problem".tr(), const Icon(Icons.info));
    });
  }

  void showDialogCompleted(BuildContext context, String txt1, txt2, int i) {
    BuildContext dialogContext;
    showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 250.h,
            child: Center(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/check.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        txt1,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      txt2,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.gryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30.0, left: 70, right: 70),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          if (i == 0) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 2000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return NavigationBottomBarUser();
                                },
                              ),
                            );
                          } else if (i == 1) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 2000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return NavigationBottomBarUser();
                                },
                              ),
                            );
                          } else {}
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: AppColors.blueWColor,
                          ),
                          child: Center(
                            child: Text(
                              'Home'.tr(),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                color: AppColors.whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  Future<dynamic> get_fav_properties(
    String token,
  ) async {
    String url = MasterAPi.API_URL_GET_FAV;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      _fav_list.clear();
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        for (var item in body["data"]) {
          _fav_list.add(SearchClass.fromJson(item));
          _fav_list.sort((b, a) => a.is_special!.compareTo(b.is_special!));

          notifyListeners();
        }
      }
    }).catchError((e) {
      print('catchError get_fav_properties   :${e.toString()}');
      notifyListeners();
    });
  }

  Future<dynamic> addfav(
      String token, int property, int k, BuildContext context) async {
    GF().loading();
    String url = MasterAPi.API_URL_POST_FAV;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    http.post(Uri.parse(url), headers: headers, body: {
      "service": property.toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success']) {
          GF().dismissLoading();
          GF().ToastMessage(context, body['message'], const Icon(Icons.done));
          if (k == 1) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          get_fav_properties(token);
        } else {
          GF().dismissLoading();
        }
      } else {}
    }).catchError((e) {
      GF().dismissLoading();
      print('catchError addfav   :${e.toString()}');
    });
  }

  Future<dynamic> rate(String token, String service, double rate,
      String comment, BuildContext context) async {
    GF().loading();
    String url = MasterAPi.API_URL_ADD_RATE1;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    http.post(Uri.parse(url), headers: headers, body: {
      "service": service.toString(),
      "rate": rate.toStringAsFixed(0),
      "comment": comment.toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        notifyListeners();
        if (body['success']) {
          GF().dismissLoading();
          GF().ToastMessage(
              context, body['message'].toString(), Icon(Icons.done));
        } else {
          GF().dismissLoading();
          GF().ToastMessage(
              context, body['message'].toString(), Icon(Icons.info));
        }
      } else {
        GF().dismissLoading();
        GF().ToastMessage(context, "Problem".tr(), const Icon(Icons.info));
      }
    }).catchError((e) {
      print('catchError rate    :${e.toString()}');

      GF().dismissLoading();
      GF().ToastMessage(context, "Problem".tr(), const Icon(Icons.info));
    });
  }

  Future<dynamic> support(String token, BuildContext context) async {
    GF().loading();
    String url = MasterAPi.API_CONTACT;
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (body['success']) {
          GF().dismissLoading();
          showDialogSupport(context, body['data']['address'],
              body['data']['phone'], body['data']['email']);
        } else {
          GF().dismissLoading();

          notifyListeners();
        }
      }
    }).catchError((e) {
      GF().dismissLoading();
      print('catchError  support    :${e.toString()}');

      notifyListeners();
    });
  }

  Future<dynamic> about(String token, BuildContext context) async {
    String url = MasterAPi.API_ABOUT;
    GF().loading();
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      print("aaattt${response.statusCode}");
      print("aaattt${response.body}");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (body['success']) {
          GF().dismissLoading();
          showDialogabout(context, body['data']['title'],
              body['data']['details'], body['data']['image']);
        } else {
          GF().dismissLoading();

          notifyListeners();
        }
      }
    }).catchError((e) {
      GF().dismissLoading();
      print('catchError about    :${e.toString()}');

      notifyListeners();
    });
  }

  Future<dynamic> socials(String token) async {
    String url = MasterAPi.API_SOCIALS;
    GF().loading();
    Map<String, String> headers = {
      'x-api-key': 'mwDA9w',
      'Content-Language': translator.currentLanguage == 'ar' ? 'ar' : 'en',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    http.get(Uri.parse(url), headers: headers).then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (body['success']) {
          GF().dismissLoading();

          _facebook = body['data'][0]['link'].toString();
          _twitter = body['data'][1]['link'].toString();
          _instagram = body['data'][2]['link'].toString();
          notifyListeners();
        } else {
          GF().dismissLoading();
        }
      }
    }).catchError((e) {
      GF().dismissLoading();
      print('catchError socials    :${e.toString()}');

      notifyListeners();
    });
  }

  void showDialogSupport(context, address, phone, email) {
    showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                height: 350,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'call'.tr(),
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontSize: 15,
                                    color: Color(0xff014E50),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/ic_call.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                final url = "https://wa.me/${phone}";
                                await launch(url);
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13.0),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.0, color: Colors.grey),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/whatsapp.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Whatsapp'.tr(),
                                        style: TextStyle(
                                          fontFamily: 'Almarai',
                                          fontSize: 15,
                                          color: Color(0xff014E50),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: .5, height: 200, color: Colors.grey),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final url =
                                    'mailto:${email}?subject=${Uri.encodeFull("subject")}&body=${Uri.encodeFull("body")}';
                                await launch(url);
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13.0),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.0, color: Colors.grey),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/mail.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'E-mail'.tr(),
                                        style: TextStyle(
                                          fontFamily: 'Almarai',
                                          fontSize: 15,
                                          color: Color(0xff014E50),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${address}',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 15,
                              color: Color(0xff014E50),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
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

  void showDialogabout(context, title, text, image) {
    showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                height: 350,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'about'.tr(),
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontSize: 15,
                                    color: Color(0xff014E50),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/about.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title.toString(),
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 15,
                              color: Color(0xff014E50),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text.toString(),
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 15,
                              color: Color(0xff014E50),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
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
