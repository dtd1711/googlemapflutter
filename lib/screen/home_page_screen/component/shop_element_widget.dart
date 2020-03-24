import 'package:flutter/material.dart';
import 'package:google_map_app/model/coffee_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class ShopList extends StatelessWidget {
  final List<Coffee> shopList;

  ShopList(this.shopList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("shop").snapshots(),
        builder: (context,snapchot){
          if(!snapchot.hasData) return Text("Loading ...");
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapchot.data.documents.length,
            itemBuilder: (context,index){
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 0,
                  right: index == shopList.length -1 ? 16.0 : 8.0
                ),
                child: ShopElement(
                  Coffee(
                    shopName: snapchot.data.documents[index]['name'],
                    address: snapchot.data.documents[index]['address'],
                    description: snapchot.data.documents[index]['description'],
                    thumbNail: snapchot.data.documents[index]['thumbNail'],
                    locationCoords: LatLng(
                      snapchot.data.documents[index]['locationCoords'].latitude,
                      snapchot.data.documents[index]['locationCoords'].longitude
                    )
                  )
                ),
              );
            }
          );
        }
      )
      ,
    );
  }
}

class ShopElement extends StatelessWidget {
  final Coffee element;

  ShopElement(this.element);

  @override
  Widget build(BuildContext context) {
    double widthImg = 180.0;
    double heightImg = 120.0;
    return GestureDetector(
      onTap: (){
        _openMap(element.locationCoords);
      },
      child: Container(
        width: widthImg,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
              child: Image.network(element.thumbNail,width: widthImg,height: heightImg,fit: BoxFit.cover,),
            ),
            Text(
              element.shopName,
              style: TextStyle(
                height: 2.0,
                fontSize: 16.0
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              element.address,
              style: TextStyle(
                height: 1.5,
                fontSize: 14.0
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
  void _openMap(LatLng latLng) async{
    String url = 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    if(await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not launch $url';
    }
  }
}