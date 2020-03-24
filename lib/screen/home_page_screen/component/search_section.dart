import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import './google_map_section.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';
const kGoogleApiKey = "AIzaSyBhFXoJQ0c6E5Uo1LVJOW6YWgtDvZPJBUw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchSection extends PlacesAutocompleteWidget {
  final Function moveCamera;

  SearchSection({this.moveCamera}) : super(
    apiKey: kGoogleApiKey,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [Component(Component.country, "uk")]
  );

  @override
  State<PlacesAutocompleteWidget> createState() => SearchSectionState(moveCamera);
}

class SearchSectionState extends PlacesAutocompleteState {
  Function moveCamera;
  SearchSectionState(this.moveCamera);
  final googleMapKey = GlobalKey<GoogleMapSectionState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 50.0,
          child: PlacesAutocompleteField(
            apiKey: kGoogleApiKey,
            mode: Mode.overlay,
          ),
        ),
        PlacesAutocompleteResult(
          onTap: (p){
            searchAndNavigate(p);
          },
        )
      ],
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
  }

  searchAndNavigate(Prediction p) async{
    if(p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      moveCamera(LatLng(lat,lng));
    }
  }

}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}