class AddressApiResponse {
  String? status;
  String? message;
  Data? data;

  AddressApiResponse({this.status, this.message, this.data});

  AddressApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Addresses>? addresses;

  Data({this.addresses});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
  String? label;
  String? country;
  String? state;
  String? city;
  String? phone;
  String? address;
  String? building;
  String? floor;
  String? apartment;
  double? longitude;
  double? latitude;
  int? isDefault;

  Addresses(
      {this.id,
        this.label,
        this.country,
        this.state,
        this.city,
        this.phone,
        this.address,
        this.building,
        this.floor,
        this.apartment,
        this.longitude,
        this.latitude,
        this.isDefault});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    phone = json['phone'];
    address = json['address'];
    building = json['building'];
    floor = json['floor'];
    apartment = json['apartment'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['building'] = this.building;
    data['floor'] = this.floor;
    data['apartment'] = this.apartment;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['is_default'] = this.isDefault;
    return data;
  }
}
