


import 'dart:convert';

import 'package:airportapp/core/api/public_http_client.dart';
import 'package:airportapp/core/entities/response_model.dart';
import 'package:airportapp/core/models/map_model.dart';

class HomeProvider {

  final PublicHttpClient publicHttpClient= PublicHttpClient();


  Future<Data> getMap() async {
    var response= await publicHttpClient.get('/api/get_map_pins/');
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    //print(body.data.toString());
    return Data.fromJson(body.data);
  }


  Future<bool> setPoint(PinModel pin, double lat, double long, double accuracy) async {
    var payload = json.encode(
      {
        'tmap_pin': '${pin.id}',
        'lat': '$lat',
        'lon': long,
        'accuracy': accuracy
      }
    );

    var response = await publicHttpClient.post(
      '/api/set_point/',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.data['message'] == "Point saved" ? true : false;
  }


}