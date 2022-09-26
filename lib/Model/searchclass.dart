import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SearchClass {
  int? id;
  String? title;
  String? details;
  int? counter;
  bool? favorite;
  Location? location;
  String? mainCategory;
  String? subCategory;
  String? area;
  String? city;
  String? timeIn;
  String? timeOut;
  String? phone;
  String? facebook;
  String? twitter;
  String? instagram;
  bool? eventNow;
  List<Images>? images=[];
  List<String>? imagestring=[];
  String? avgRates;
  List<Rates>? rates=[];
  List<StoryItem>? storyItems=[];
  String? about_place;
  final StoryController storyController = StoryController();
  int? is_special;


  SearchClass(
      {this.id,
        this.title,
        this.details,
        this.counter,
        this.favorite,
        this.location,
        this.mainCategory,
        this.subCategory,
        this.area,
        this.city,
        this.timeIn,
        this.timeOut,
        this.phone,
        this.facebook,
        this.twitter,
        this.instagram,
        this.eventNow,
        this.images,
        this.imagestring,
        this.avgRates,
        this.rates,
        this.storyItems,
        this.about_place,
        this.is_special,
      });

  SearchClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    details = json['details'];
    counter = json['counter'];
    favorite = json['favorite'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    mainCategory = json['Main_Category'];
    subCategory = json['Sub_Category'];
    area = json['Area'];
    city = json['City'];
    timeIn = json['time_in'];
    timeOut = json['time_out'];
    phone = json['phone'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    eventNow = json['event_now'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
        imagestring!.add(new Images.fromJson(v).image!);
        storyItems!.add(
          StoryItem.pageImage(
            url: new Images.fromJson(v).image!,
            caption: json['title'].toString(),
            controller: storyController,
          ),);
      });
    }else{
      images=[];
      imagestring=[];
      storyItems=[];
    }
    json['avg_rates']==null?avgRates ="0":avgRates = json['avg_rates'];
    if (json['rates'] != null) {
      rates = <Rates>[];
      json['rates'].forEach((v) {
        rates!.add(new Rates.fromJson(v));
      });
    }else{
      rates = [];
    }
    about_place = json['about_place'];
    json['is_special']==null? is_special = 0:is_special = json['is_special'];
  }

}
class Rates {
  int? id;
  String? comment;
  int? rate;

  Rates({this.id, this.comment, this.rate});

  Rates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rate'] = this.rate;
    return data;
  }
}
class Location {
  String? lat;
  String? long;

  Location({this.lat, this.long});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}