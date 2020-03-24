import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_map_app/model/coffee_shop.dart';
import 'get_marker_icon.dart';

class GoogleMapSection extends StatefulWidget {
  final Position curentPosition;

  GoogleMapSection({Key key,this.curentPosition}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GoogleMapSectionState();
  }

}

class GoogleMapSectionState extends State<GoogleMapSection>{

  BitmapDescriptor myMarker;

  GoogleMapController _mapController;

  Position currentPosition;

  List<Marker> allMarker = [];

  @override
  void initState() {
    super.initState();
    currentPosition = widget.curentPosition;
    setMarker();
  }

  void setMarker() async{

    Uint8List markerIcon = await getBytesFromAsset("assets/bk_logo.png", 100);
    myMarker = BitmapDescriptor.fromBytes(markerIcon);
    
  }

  List<Marker> setMyMarker(List<Coffee> coffees){
    return coffees.map( (element) => Marker(
      markerId: MarkerId(element.shopName),
      infoWindow: InfoWindow(
        title: element.shopName,
        snippet: element.address
      ),
      position: element.locationCoords,
      icon: myMarker,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {

    coffeeShops.forEach(
      (element) {
        allMarker.add(
          Marker(
            markerId: MarkerId(element.shopName),
            infoWindow: InfoWindow(
              title: element.shopName,
              snippet: element.address
            ),
            position: element.locationCoords,
            icon: myMarker,
          ),
        );
      }
    );

    allMarker.add(
      Marker(
        markerId: MarkerId("current"),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        draggable: true
      )
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 20.0
      ),
      onMapCreated: (controller){
        setState(() {
          _mapController = controller;
          _setStyle(_mapController);
        });
      },
      markers: Set.from(allMarker),
    );
  }

  moveCamera(LatLng latLng)  async{
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng,zoom: 20.0)
      )
    );
    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: 50, y: 50);
    LatLng result = await _mapController.getLatLng(screenCoordinate);
    print('lat: '+ result.latitude.toString() + ' lng: ' + result.longitude.toString());
    
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }
}
