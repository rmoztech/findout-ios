class HomeClass {
  List<Ads1>? ads;
  List<AreaCities>? areaCities;
  List<MainCats>? mainCats;

  HomeClass({this.ads, this.areaCities, this.mainCats});

  HomeClass.fromJson(Map<String, dynamic> json) {
    if (json['ads'] != null) {
      ads = <Ads1>[];
      json['ads'].forEach((v) {
        ads!.add(new Ads1.fromJson(v));
      });
    }
    if (json['area_cities'] != null) {
      areaCities = <AreaCities>[];
      json['area_cities'].forEach((v) {
        areaCities!.add(new AreaCities.fromJson(v));
      });
    }
    if (json['main_cats'] != null) {
      mainCats = <MainCats>[];
      json['main_cats'].forEach((v) {
        mainCats!.add(new MainCats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ads != null) {
      data['ads'] = this.ads!.map((v) => v.toJson()).toList();
    }
    if (this.areaCities != null) {
      data['area_cities'] = this.areaCities!.map((v) => v.toJson()).toList();
    }
    if (this.mainCats != null) {
      data['main_cats'] = this.mainCats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads1 {
  int? id;
  String? title;
  String? details;
  String? link;
  String? image;
  int? service_id;
  Ads1(
      {this.id,
      this.title,
      this.details,
      this.link,
      this.image,
      this.service_id});

  Ads1.fromJson(Map<String, dynamic> json) {
    id =int.parse(json['id'].toString()) ;
    title = json['title'];
    details = json['details'];
    link = json['link'];
    image = json['image'];
    service_id =int.parse( json['service_id'].toString());
    // service_id = int.parse(json['service_id']) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['details'] = this.details;
    data['link'] = this.link;
    data['image'] = this.image;
    data['service_id'] = this.service_id;

    return data;
  }
}

class AreaCities {
  int? id;
  String? title;
  List<Cities>? cities;

  AreaCities({this.id, this.title, this.cities});

  AreaCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int? id;
  int? area;
  String? title;

  Cities({this.id, this.area, this.title});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area'] = this.area;
    data['title'] = this.title;
    return data;
  }
}

class MainCats {
  int? id;
  String? title;
  List<Sub>? sub;
  int? serviceCount;

  MainCats({this.id, this.title, this.sub, this.serviceCount});

  MainCats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['sub'] != null) {
      sub = <Sub>[];
      json['sub'].forEach((v) {
        sub!.add(new Sub.fromJson(v));
      });
    }
    serviceCount = json['service_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.sub != null) {
      data['sub'] = this.sub!.map((v) => v.toJson()).toList();
    }
    data['service_count'] = this.serviceCount;
    return data;
  }
}

class Sub {
  int? id;
  int? mainCategory;
  String? title;
  bool? checked;

  Sub({this.id, this.mainCategory, this.title, this.checked});

  Sub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainCategory = json['main_category'];
    title = json['title'];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_category'] = this.mainCategory;
    data['title'] = this.title;
    return data;
  }
}
