import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fablebike/models/user.dart';
import 'package:fablebike/pages/sections/comments_section.dart';
import 'package:fablebike/services/route_service.dart';
import 'package:fablebike/widgets/carousel.dart';
import 'package:fablebike/widgets/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fablebike/models/route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

LatLng myLocation = LatLng(46.45447, 27.72501);

class MapScreen extends StatelessWidget {
  static const route = '/map';

  final BikeRoute bikeRoute;

  const MapScreen({
    Key key,
    @required this.bikeRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapWidget(bikeRoute: bikeRoute);
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key key,
    @required this.bikeRoute,
  }) : super(key: key);

  final BikeRoute bikeRoute;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final ScrollController listViewController = ScrollController();
  bool isLoading = false;
  String currentRoute = "poi";
  double rotation = 0;
  double size = 12.0;
  bool init = false;
  MapController mapController;
  double kmTraveled = 0;
  var hoverPoint = LatLng(0, 0);
  var currentTab = 'poi';
  LatLng center = LatLng(0, 0);

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    this.setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      this.setState(() {
        _connectionStatus = result;
      });
    });
  }

  void goToPoint(LatLng dest) {
    final latTween = Tween<double>(begin: mapController.center.latitude, end: dest.latitude);
    final longTween = Tween<double>(begin: mapController.center.longitude, end: dest.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: 13.0);

    var controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(LatLng(latTween.evaluate(animation), longTween.evaluate(animation)), zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  LatLng getcenter() {
    var l = widget.bikeRoute.rtsCoordinates.length;
    LatLng value = LatLng(0, 0);
    for (var i = 0; i < widget.bikeRoute.rtsCoordinates.length; i++) {
      value.latitude += widget.bikeRoute.rtsCoordinates[i].latitude / l;
      value.longitude += widget.bikeRoute.rtsCoordinates[i].longitude / l;
    }
    return value;
  }

  /* Future<double> getKmTraveled() async {
    double km = 0;
    for (var i = 0; i < widget.bikeRoute.rtsCoordinates.length - 1; i++) {
      var distanceToUser = mapMath.calculateDistance(
          widget.bikeRoute.rtsCoordinates[i].latitude, widget.bikeRoute.rtsCoordinates[i].longitude, myLocation.latitude, myLocation.longitude);

      if (distanceToUser > 2) {
        km += mapMath.calculateDistance(widget.bikeRoute.rtsCoordinates[i].latitude, widget.bikeRoute.rtsCoordinates[i].longitude,
            widget.bikeRoute.rtsCoordinates[i + 1].latitude, widget.bikeRoute.rtsCoordinates[i + 1].longitude);
      } else {
        i = 9999;
      }
    }
    kmTraveled = km;
    return km;
  } */

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    double smallPadding = height * 0.0125;
    double bigPadding = height * 0.05;
    var user = Provider.of<AuthenticatedUser>(context);

    if (widget.bikeRoute == null) {
      Navigator.of(context).pop();
      return Text('');
    }

    var markers = <Marker>[];
    markers.add(Marker(
        width: 36,
        height: 36,
        builder: (ctx) =>
            Transform.rotate(angle: -this.rotation * 3.14159 / 180, child: Container(child: Image(image: AssetImage('assets/icons/ruin_ppin.png')))),
        point: hoverPoint));
    for (var i = 0; i < widget.bikeRoute.objectives.length; i++) {
      markers.add(Marker(
          width: 24,
          height: 24,
          builder: (ctx) => Transform.rotate(
              angle: -this.rotation * 3.14159 / 180,
              child: Container(child: Image(image: AssetImage('assets/icons/' + widget.bikeRoute.objectives[i].icon + '_pin.png')))),
          point: widget.bikeRoute.objectives[i].coords));
    }
    return ColorfulSafeArea(
        overflowRules: OverflowRules.all(true),
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Scaffold(
            bottomSheet: GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                  height: height * 0.025,
                  width: width,
                  child: Center(
                    child: Container(
                      width: width / 2,
                      height: height * 0.01,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                    ),
                  )),
              onVerticalDragEnd: (v) {
                _buildBottomSheet(context, widget.bikeRoute);
              },
            ),
            appBar: AppBar(
              title: Text(
                widget.bikeRoute.name,
                style: Theme.of(context).textTheme.headline3,
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              shadowColor: Colors.white54,
              backgroundColor: Colors.white,
            ),
            body: Container(
              height: height,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18.0)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                          child: ClipRRect(
                            child: Stack(
                              children: [
                                FlutterMap(
                                  mapController: mapController,
                                  options: MapOptions(
                                      center: widget.bikeRoute.center,
                                      minZoom: 10.0,
                                      maxZoom: 13.0,
                                      zoom: 10.0,
                                      swPanBoundary: LatLng(46.2318, 27.3077),
                                      nePanBoundary: LatLng(46.9708, 28.1942),
                                      plugins: [LocationMarkerPlugin()]),
                                  layers: [
                                    TileLayerOptions(
                                      tileProvider: AssetTileProvider(),
                                      maxZoom: 13.0,
                                      urlTemplate: 'assets/map/{z}/{x}/{y}.png',
                                    ),
                                    PolylineLayerOptions(
                                      polylines: [
                                        Polyline(points: widget.bikeRoute.rtsCoordinates, strokeWidth: 8, color: Colors.blue),
                                      ],
                                    ),
                                    LocationMarkerLayerOptions(),
                                    MarkerLayerOptions(markers: markers),
                                  ],
                                ),
                                Positioned(
                                    left: 15,
                                    bottom: 15,
                                    child: Container(
                                      height: height * 0.075,
                                      width: width * 0.4,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                child: InkWell(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                          color: Colors.white70,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 1, offset: Offset(0, 6))
                                                          ]),
                                                      child: Center(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.star),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(widget.bikeRoute.rating.toStringAsPrecision(2), style: Theme.of(context).textTheme.headline5),
                                                          ],
                                                        ),
                                                      )),
                                                  onTap: () async {
                                                    var rating = await showDialog(context: context, builder: (_) => RatingDialog());
                                                    var newRating = await RouteService().rateRoute(rating: rating, route_id: widget.bikeRoute.id);
                                                    setState(() {
                                                      if (newRating != null && newRating != 0.0) widget.bikeRoute.rating = newRating;
                                                    });
                                                  },
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                child: InkWell(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                          color: Colors.white70,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 1, offset: Offset(0, 6))
                                                          ]),
                                                      child: Center(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.forum),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(widget.bikeRoute.distance.toStringAsPrecision(2),
                                                                style: Theme.of(context).textTheme.headline5),
                                                          ],
                                                        ),
                                                      )),
                                                  onTap: () {
                                                    _buildBottomSheet(context, widget.bikeRoute);
                                                  },
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                              )),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    child: Container(
                                        height: height * 0.075,
                                        width: width * 0.275,
                                        child: Column(children: [
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                        color: Colors.white70,
                                                        boxShadow: [
                                                          BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 1, offset: Offset(0, 6))
                                                        ]),
                                                    child: Center(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image(image: AssetImage('assets/icons/dt.png'), height: 32),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(widget.bikeRoute.distance.toStringAsPrecision(2) + ' KM',
                                                              style: Theme.of(context).textTheme.headline5),
                                                        ],
                                                      ),
                                                    )),
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                              )),
                                        ])),
                                    bottom: 15,
                                    right: 15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        flex: 1),
                    SizedBox(height: bigPadding * 0.25),
                    Expanded(
                      child: Container(
                          child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            currentTab = 'poi';
                                          });
                                        },
                                        child: Text(
                                          'Puncte Interes',
                                          style: TextStyle(color: currentTab != 'poi' ? Theme.of(context).primaryColor : Colors.white),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: currentTab == 'poi' ? Theme.of(context).primaryColor : Colors.white,
                                            textStyle: TextStyle(fontSize: 14.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), bottomLeft: Radius.circular(16.0)))),
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            currentTab = 'elev';
                                          });
                                        },
                                        child: Text('Elevatie', style: TextStyle(color: currentTab != 'elev' ? Theme.of(context).primaryColor : Colors.white)),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: currentTab == 'elev' ? Theme.of(context).primaryColor : Colors.white,
                                            textStyle: TextStyle(fontSize: 14.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(16.0), bottomRight: Radius.circular(16.0)))),
                                      ),
                                      flex: 1),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: smallPadding),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Row(children: [
                              currentTab == 'poi' ? Icon(Icons.place) : Icon(Icons.equalizer_rounded),
                              SizedBox(width: 5),
                              Text(
                                currentTab == 'poi' ? 'Obiectivele de pe aceasta ruta' : 'Graficul de elevatie al rutei',
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.start,
                              )
                            ]),
                          ),
                          SizedBox(height: smallPadding),
                          currentTab == 'poi'
                              ? Column(
                                  children: [
                                    Carousel(
                                        objectives: widget.bikeRoute.objectives,
                                        context: context,
                                        onItemChanged: (int index) {
                                          goToPoint(widget.bikeRoute.objectives[index].coords);
                                        })
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ClipRRect(
                                        child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18.0)), color: Colors.white, boxShadow: [
                                              BoxShadow(color: Colors.black.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))
                                            ]),
                                            height: height * 0.275,
                                            child: Padding(
                                              child: NotificationListener<ElevationHoverNotification>(
                                                onNotification: (ElevationHoverNotification notification) {
                                                  setState(() {
                                                    hoverPoint = notification.position;
                                                  });
                                                  return true;
                                                },
                                                child: Elevation(
                                                  widget.bikeRoute.elevationPoints,
                                                  color: Theme.of(context).primaryColor,
                                                  elevationGradientColors: ElevationGradientColors(
                                                      gt10: Color.fromRGBO(186, 150, 51, 1),
                                                      gt20: Color.fromRGBO(234, 120, 85, 1),
                                                      gt30: Color.fromRGBO(255, 61, 0, 1)),
                                                ),
                                              ),
                                              padding: EdgeInsets.all(24),
                                            )),
                                        borderRadius: BorderRadius.circular(20.0)),
                                  ],
                                )
                        ],
                      )),
                      flex: 1,
                    )
                  ])),
            )));
  }
}

_buildBottomSheet(BuildContext context, BikeRoute bikeRoute) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white.withOpacity(0),
      builder: (context) {
        return CommentSection(
          canPost: true,
          route_id: bikeRoute.id,
        );
      });
}
