import 'dart:async';

import 'package:airportapp/core/models/map_model.dart';
import 'package:airportapp/provider/home_provider.dart';
import 'package:airportapp/shared/component/info_alert_dialog.dart';
import 'package:airportapp/shared/spaces.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:photo_view/photo_view.dart';

import '../main.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<Position> positionStream;
  HomeProvider provider= HomeProvider();
  Position currentPosition;
  Data data;
  bool isLoading= false;


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    provider.getMap();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    provider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          body:  StreamBuilder<Data>(
            stream: provider.mapStream.stream,
            builder: (context, AsyncSnapshot<Data> snapshot){

              if(snapshot.hasData && snapshot.data!=null){
                data= snapshot.data;
                return Stack(
                  children: [
                    PhotoView(
                      imageProvider:
                      CachedNetworkImageProvider('$urlBase/${data.map.image}'),
                    ),

                    _buildLocation(),

                    _buildPins(data.pins)
                  ],
                );
              }
              return Container();
            },

          ),
        ),
      ),
    );
  }

  Future getCurrentLocation() async  {
    LocationPermission  permission= await Geolocator.requestPermission();
    if (permission == LocationPermission.denied)
      throw Exception('Error getCurrentPosition, location service denied');


    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      positionStream = Geolocator.getPositionStream().listen(
              (Position position) {
                setState(() {
                  currentPosition= position;
                });
            //print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString()  + ', '+ position.accuracy.toString());
          });


    } else {
      throw Exception(
          'Error getCurrentPosition, location service not enabled');
    }

  }

  Widget btn(PinModel pin){
    double size = 50.0;

    return InkResponse(
      onTap: (){
        showInfoDialog('¿Estas en ${pin.name}?', onConfirm: ()=>onConfirm(pin), confirmTitle: 'SI', cancelTitle: 'NO', cancelAction: true);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            color: pin.isSet ? Colors.green : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            //padding: const EdgeInsets.all(15.0),
            child: Text(pin.name),
          ),
        ),
      ),
    );



    /*return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: RoundedButton(
            color: Colors.red,
            title: name,
            minWidth: 50,
            height: 40,
            style:TextStyle(fontWeight: FontWeight.bold,  color: Colors.white),
            onPressed: () {}
        )
    );*/
  }

  Widget _buildLocation() {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.grey,
            child: Text('Latitude: ${currentPosition!=null ? currentPosition?.latitude : ''}')),
        Spaces.verticalSmallest(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.grey,
            child: Text('Longitud: ${currentPosition!=null ? currentPosition?.longitude : ''}')),
        Spaces.verticalSmallest(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.grey,
            child: Text('Precision: ${currentPosition!=null ? currentPosition?.accuracy : ''}')),
        Spaces.verticalSmallest()
      ],
    );
  }


  void showInfoDialog(
      String message, {
        String confirmTitle,
        String cancelTitle,
        bool cancelAction = false,
        Function onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        cancelAction: cancelAction,
        onConfirm: () {
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  Widget _buildPins(List<PinModel> list) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(list.length, (index) {
          return btn(list[index]);
        }),
      ),
    );
  }

  onConfirm(PinModel pin) async {
    setState(() {
      isLoading= true;
    });

    var result= await provider.setPoint(pin, currentPosition.latitude, currentPosition.longitude, currentPosition.accuracy);
    await provider.getMap();
    print('set point $result');

    setState(() {
      isLoading= false;
    });
  }


}
