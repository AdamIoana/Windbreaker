import 'package:fablebike/models/route.dart';
import 'package:fablebike/pages/poi_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBuilder {
  static Widget buildAnnouncementBanner(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),
          height: 0.2 * height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10.0),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Anunt Important',
                              style: Theme.of(context).textTheme.headline1,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Anunt Important',
                              style: Theme.of(context).textTheme.headline2,
                            ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(flex: 2, child: SizedBox(width: 1)),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Detalii'),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(64, 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                                )))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  static Widget buildSmallPOICard(BuildContext context, PointOfInterest poi) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: InkWell(
            onTap: () {
              var poiInfo = new POIInfo(poi: poi, fromRoute: ModalRoute.of(context).settings.name);
              Navigator.of(context).pushNamed(POIScreen.route, arguments: poiInfo);
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                width: 0.3 * width,
                height: 0.275 * height,
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: ClipRRect(
                              child: Image.asset('assets/images/bisericalemn_000.jpg', fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(18 + .0),
                            )),
                        flex: 2),
                    Container(
                        height: 1 / 10 * height,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                            child: Text('fasfafasfasfasfasfasfafasfasfafasfafasfasfasfasfasfafasfasfa', style: Theme.of(context).textTheme.bodyText2)))
                  ],
                ))));
  }

  static buildLargePOICard(BuildContext context, PointOfInterest poi) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: InkWell(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                height: height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: ClipRRect(
                              child: Image.asset('assets/images/bisericalemn_000.jpg', fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(18 + .0),
                            )),
                        flex: 1),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                            child: Column(
                              children: [
                                Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        poi.name,
                                        style: Theme.of(context).textTheme.bodyText1,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3),
                                          child: Container(
                                              child: OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                                textStyle: TextStyle(fontSize: 14),
                                                primary: Theme.of(context).primaryColor,
                                                side: BorderSide(style: BorderStyle.solid, color: Theme.of(context).primaryColor, width: 1),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                                            child: !poi.is_bookmarked ? Text('Salveaza') : Text('Sterge'),
                                          ))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Lorem ipsum dolor sit amet, onsectetur adipiscing elit. Curabitur risus ligula",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3),
                                          child: Container(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                var poiInfo = new POIInfo(poi: poi, fromRoute: ModalRoute.of(context).settings.name);
                                                Navigator.of(context).pushNamed(POIScreen.route, arguments: poiInfo);
                                              },
                                              child: Text('Detalii'),
                                              style: ElevatedButton.styleFrom(
                                                  textStyle: TextStyle(fontSize: 14.0),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                                            ),
                                          )))
                                ])
                              ],
                            )),
                        flex: 1)
                  ],
                ))));
  }

  static buildNearestPoiButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Container(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(style: BorderStyle.solid, color: Theme.of(context).primaryColor, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                  child: Text('Salveaza'),
                )
              ],
            )));
  }

  static buildRouteCard(BuildContext context, BikeRoute route) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
            height: height * 0.3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: ClipRRect(
                                        child: Image.asset('assets/images/bisericalemn_000.jpg', fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      flex: 1),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                        child: Container(
                                            width: 3,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                route.name,
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                route.description,
                                                style: Theme.of(context).textTheme.bodyText2,
                                              )
                                            ])),
                                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 1,
                            child: Text(''),
                          )
                        ],
                      )),
                  flex: 1)
            ])));
  }
}
