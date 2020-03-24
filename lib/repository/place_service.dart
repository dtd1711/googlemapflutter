import 'dart:convert';

import 'package:google_map_app/configs/google_place_config.dart';
import 'package:google_map_app/model/place.dart';
import 'package:http/http.dart' as http;

class PlaceService {

  static Future<List<PlaceItemRes>> searchPlace(String keyword) async{

    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            PlaceConfig.kGoogleApiKey +
            "&language=vi&region=VN&query=" +
            Uri.encodeQueryComponent(keyword);

    var res = await http.get(url);

    if(res.statusCode == 200) {
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return List();
    }

  }

}