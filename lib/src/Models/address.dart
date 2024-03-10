import 'dart:convert';
import 'dart:ffi';

Adress adressFromJson(String str) => Adress.fromJson(json.decode(str));

String adressToJson(Adress data) => json.encode(data.toJson());

class Adress {
  dynamic id;
  String idUser;
  String address;
  String neighborhood;
  double lat;
  double lng;
  List<Adress> toList = [];
  Adress({
    this.id,
    this.idUser,
    this.address,
    this.neighborhood,
    this.lat,
    this.lng,
  });

  factory Adress.fromJson(Map<String, dynamic> json) => Adress(
  
        id: json['id'] is int ? json['id'] = 'Hola' : json['id'],
        idUser: json["id_user"],
        address: json["address"],
        neighborhood: json["neighborhood"],
        lat: json["lat"] is Double
            ? double.tryParse(json["lat"]) ?? 0.0
            : double.tryParse(json["lat"].toString()),
        lng: json["lng"] is Double
            ? double.tryParse(json["lng"]) ?? 0.0
            : double.tryParse(json["lng"].toString()),
      );


  /*LISTAR INFORMACION*/
  Adress.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((element) {
      print('Elemento mapeado ${element}');
      Adress address = Adress.fromJson(element);
      toList.add(address);
    });
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "address": address,
        "neighborhood": neighborhood,
        "lat": lat,
        "lng": lng,
      };
}
