


import 'dart:async';
import 'dart:convert';

import 'package:airportapp/core/api/public_http_client.dart';
import 'package:airportapp/core/entities/response_model.dart';
import 'package:airportapp/core/models/map_model.dart';
import 'package:dio/dio.dart';

class HomeProvider {

  final PublicHttpClient publicHttpClient= PublicHttpClient();
  final mapStream = StreamController<Data>();

  Future<Data> getMap() async {
    var response= await publicHttpClient.get('/api/get_map_pins/');
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    //print(body.data.toString());
    mapStream.sink.add(Data.fromJson(body.data));
    return Data.fromJson(body.data);
  }


  Future<bool> setPoint(PinModel pin, double lat, double long, double accuracy) async {
    var formData = FormData.fromMap({
      'tmap_pin': '${pin.id}',
      'lat': '$lat',
      'lon': '$long',
      'accuracy': '$accuracy'
    });

    var response = await publicHttpClient.post(
      '/api/set_point/',
      body: formData,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.message == "Point saved" ? true : false;
  }

  dispose(){
    mapStream?.close();
  }


}