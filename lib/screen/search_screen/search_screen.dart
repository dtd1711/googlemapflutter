import 'package:flutter/material.dart';
import 'package:google_map_app/blocs/place_bloc.dart';
import 'package:google_map_app/model/place.dart';

class SearchScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen>{

  var _addressController = TextEditingController();

  var placeBloc = PlaceBloc();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: Center(
                          child: Icon(Icons.location_on),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 60,
                        child: Center(
                          child: FlatButton(
                              onPressed: () {
                                _addressController.text = "";
                              },
                              child: Icon(Icons.close)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: TextField(
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (str) {
                            placeBloc.search(str);
                          },
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff323643)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: StreamBuilder(
                    stream: placeBloc.placeStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data.toString());
                        if (snapshot.data == "start") {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        print(snapshot.data.toString());
                        List<PlaceItemRes> places = snapshot.data;
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(places.elementAt(index).name == null ? '' : places.elementAt(index).name),
                                subtitle: Text(places.elementAt(index).address == null ? '' : places.elementAt(index).address),
                                onTap: (){
                                  Navigator.pop(context,places.elementAt(index));
                                },    
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Color(0xfff5f5f5),
                                ),
                            itemCount: places.length);
                      } else {
                        return Container();
                      }
                    }),
              )
            ) 
          ],
        ),
      ),
    );
  }

}