
import 'dart:async';

import 'package:google_map_app/repository/place_service.dart';

class PlaceBloc {

  var _placeController = StreamController();

  Stream get placeStream => _placeController.stream;

  void search(String keyword){
    PlaceService.searchPlace(keyword).then(
      (res){
        _placeController.sink.add(res);
      }
    );
  }

  dispose(){
    _placeController.close();
  }

}