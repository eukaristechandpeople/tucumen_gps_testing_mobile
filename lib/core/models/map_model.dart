

class Data {
  Data({
    this.map,
    this.pins,
  });

  MapModel map;
  List<PinModel> pins;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    map: MapModel.fromJson(json["map"]),
    pins: List<PinModel>.from(json["pins"].map((x) => PinModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "map": map.toJson(),
    "pins": List<dynamic>.from(pins.map((x) => x.toJson())),
  };
}


class MapModel {
  MapModel({
    this.id,
    this.created,
    this.lastModified,
    this.name,
    this.image,
    this.isActive,
  });

  int id;
  String created;
  String lastModified;
  String name;
  String image;
  bool isActive;

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
    id: json["id"],
    created: json["created"],
    lastModified: json["last_modified"],
    name: json["name"],
    image: json["image"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created": created,
    "last_modified": lastModified,
    "name": name,
    "image": image,
    "is_active": isActive,
  };
}


class PinModel {
  PinModel({
    this.id,
    this.created,
    this.lastModified,
    this.name,
    this.tmapId,
    this.expectedLat,
    this.expectedLon,
    this.isSet,
  });

  int id;
  String created;
  String lastModified;
  String name;
  int tmapId;
  double expectedLat;
  double expectedLon;
  bool isSet;

  factory PinModel.fromJson(Map<String, dynamic> json) => PinModel(
    id: json["id"],
    created: json["created"],
    lastModified: json["last_modified"],
    name: json["name"],
    tmapId: json["tmap_id"],
    expectedLat: json["expected_lat"].toDouble(),
    expectedLon: json["expected_lon"].toDouble(),
    isSet: json["is_set"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created": created,
    "last_modified": lastModified,
    "name": name,
    "tmap_id": tmapId,
    "expected_lat": expectedLat,
    "expected_lon": expectedLon,
    "is_set": isSet,
  };
}
