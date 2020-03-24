
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_app/model/coffee_shop.dart';
import 'package:google_map_app/screen/search_screen/search_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'component/google_map_section.dart';
import 'component/shop_element_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  String searchAddress;
  final googleMapKey = GlobalKey<GoogleMapSectionState>();
  var textControler = TextEditingController();
  Position _currentPosition;

  @override
  void initState(){
    super.initState();
    _setCurrentPosition();
  }

  void _setCurrentPosition() async{
      _currentPosition = await Geolocator().getCurrentPosition();
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[

          FutureBuilder(
            future: Geolocator().getCurrentPosition(),
            builder: (context,snapshot) {
              if(snapshot.hasError){
                print(snapshot.error);
              }
              if(snapshot.hasData){
                return GoogleMapSection(
                  key: googleMapKey,
                  curentPosition: snapshot.data,
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
          Positioned(
            top: 30.0,
            left: 25,
            right: 25,
            child: Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: TextField(
                controller: textControler,
                onTap: () async{
                  // Prediction p = await PlacesAutocomplete.show(
                  //   context: context, 
                  //   apiKey: kGoogleApiKey,
                  //   language: "vi",
                  //   components: [Component(Component.country,"vn")],
                  // );
                  // displayPrediction(p);
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                  googleMapKey.currentState.moveCamera(LatLng(result.lat,result.lng));
                },
              )
            )
          ),
          Positioned(
            bottom: 220.0,
            right: 20.0,
            child: GestureDetector(
              onTap: (){
                googleMapKey.currentState.moveCamera(LatLng(_currentPosition.latitude,_currentPosition.longitude));
              },
              child: Icon(
                Icons.gps_fixed,
                size: 32.0,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            child: ShopList(coffeeShops)
          )
        ],
      )
    );
  }

 

  void displayPrediction(Prediction p) async{
     if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      googleMapKey.currentState.moveCamera(LatLng(lat, lng));
    }
  }

}

const kGoogleApiKey = "AIzaSyBhFXoJQ0c6E5Uo1LVJOW6YWgtDvZPJBUw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);