import 'dart:convert';

abstract class MasterAPi{

/*

https://findout.vision.com.sa/test/public/admin/
user:admin         password:123456
https://www.getpostman.com/collections/36543aea35fee5a66ef5
https://findout.vision.com.sa/test/public/api/

eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiOWIxODIyOGNmZDNjMTQ4YjUxM2MwYWI2NDFjZjNkNDFlZjc3NzJhNDk3ZmNhZTJhNGE5ODA1ZTg5ZmE4NmE0OTQ3MWViNmMyYTVjMGY0ZDgiLCJpYXQiOjE2NTk5NjM1ODAuNjk5ODM3OTIzMDQ5OTI2NzU3ODEyNSwibmJmIjoxNjU5OTYzNTgwLjY5OTg0MTk3NjE2NTc3MTQ4NDM3NSwiZXhwIjoxNjkxNDk5NTgwLjY5NDE2MzA4NDAzMDE1MTM2NzE4NzUsInN1YiI6IjMiLCJzY29wZXMiOltdfQ.HyQvJRTBKmwgRKYhL6gwO05GnB-y2ai6CYxX3aHKgIMagP6Ym4gRcBTDBPUg6G-oP7gX_4SwaX-Q3Q90EW4hjQ

*/

  Map<String,String> headers = {
    'accept' : 'application/json',
    'Content-Type' : 'application/json',
  };

  static String URL_1 = 'https://findout.vision.com.sa/test/public/';
  static String URL_IMAGE_DEFAULT = '${URL_1}default.png';
  static String BASE_URL =URL_1+ 'api/';
  static String API_URL_USER_REGESTER =  BASE_URL + 'register';
  static String API_URL_GET_HOME =  BASE_URL + 'home';
  static String API_URL_SEARCH =  BASE_URL + 'All-Service';
  static String API_URL_ADD_PLACE =  BASE_URL + 'add_place';
  static String API_URL_GET_FAV =  BASE_URL + 'services_favorite';
  static String API_URL_POST_FAV =  BASE_URL + 'add_to_favorite';
  static String API_URL_ADD_RATE1 =  BASE_URL + 'add_rate';
  static String API_URL_GET_DV =  BASE_URL + 'ads';
  static String API_URL_GET_CITY_AREA =  BASE_URL + 'area_cities';
  static String API_URL_ADD_COUNT =  BASE_URL + 'counter_service/';
  static String API_UPDATE_FCM_TOKEN=  BASE_URL + 'update_fcm_token';



  static String API_CONTACT=  BASE_URL + 'contact';
  static String API_POLICY=  BASE_URL + 'policy';
  static String API_TERMS=  BASE_URL + 'Terms';
  static String API_ABOUT=  BASE_URL + 'about_app';
  static String API_SOCIALS=  BASE_URL + 'social';

}













