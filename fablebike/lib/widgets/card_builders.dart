import 'package:fablebike/models/route.dart';
import 'package:fablebike/models/user.dart';
import 'package:fablebike/pages/map.dart';
import 'package:fablebike/pages/objective.dart';
import 'package:fablebike/services/database_service.dart';
import 'package:fablebike/services/route_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  static Widget buildSmallObjectiveCard(BuildContext context, Objective objective) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: InkWell(
            onTap: () {
              var objectiveInfo = new ObjectiveInfo(objective: objective, fromRoute: ModalRoute.of(context).settings.name);
              Navigator.of(context).pushNamed(ObjectiveScreen.route, arguments: objectiveInfo);
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 4))]),
                width: 0.3 * width,
                height: 0.275 * height,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: ClipRRect(
                                  child: Image.asset(
                                    'assets/images/bisericalemn_000.jpg',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                )),
                            flex: 2),
                        Container(
                            height: 1 / 10 * height,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(objective.name, style: Theme.of(context).textTheme.headline4)))
                      ],
                    ),
                    Positioned(
                        child: Image.asset(
                          'assets/icons/church_marker.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                        top: height * 0.1375,
                        left: width * 0.1),
                  ],
                ))));
  }

  static buildLargeObjectiveCard(BuildContext context, Objective objective) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    var user = Provider.of<AuthenticatedUser>(context);
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
                                        objective.name,
                                        style: Theme.of(context).textTheme.bodyText1,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3),
                                          child: Container(
                                              child: OutlinedButton(
                                                  onPressed: () async {},
                                                  style: OutlinedButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                      textStyle: TextStyle(fontSize: 14),
                                                      primary: Theme.of(context).primaryColor,
                                                      side: BorderSide(style: BorderStyle.solid, color: Theme.of(context).primaryColor, width: 1),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                                                  child: Text('Rute')))))
                                ]),
                                Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Loredsadasdasm ipsum dolor sit amet, onsectetur adipiscing elit. Curabitur risus ligula",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3),
                                          child: Container(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                var objectiveInfo = new ObjectiveInfo(objective: objective, fromRoute: ModalRoute.of(context).settings.name);
                                                Navigator.of(context).pushNamed(ObjectiveScreen.route, arguments: objectiveInfo);
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

  static buildNearestObjectiveButton(BuildContext context) {
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
                  child: Text('Vezi toate obiectivele pe harta'),
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
            child: Column(children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 3,
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
                                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0)),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Container(
                                child: buildRouteStats(context, route),
                              ))
                        ],
                      )),
                  flex: 1)
            ])));
  }

  static buildRouteStats(BuildContext context, BikeRoute route) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () async {},
                        child: Column(
                          children: [
                            Text('Distanta', style: Theme.of(context).textTheme.bodyText2),
                            SizedBox(height: 3),
                            Text(route.distance.toString() + ' KM', style: Theme.of(context).textTheme.bodyText1)
                          ],
                        )),
                    flex: 1),
                Expanded(
                    child: InkWell(
                        onTap: () async {},
                        child: Column(
                          children: [
                            Text('Puncte Interes', style: Theme.of(context).textTheme.bodyText2),
                            SizedBox(height: 3),
                            Text('0', style: Theme.of(context).textTheme.bodyText1)
                          ],
                        )),
                    flex: 1),
                Expanded(
                    child: InkWell(
                        onTap: () async {},
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  var db = context.read<DatabaseService>();
                                  var database = await db.database;
                                  var routes = await database.query('route', where: 'id = ?', whereArgs: [route.id]);

                                  var coords = await database.query('coord', where: 'route_id = ?', whereArgs: [route.id]);

                                  var objToRoutes = await database.query('objectivetoroute', where: 'route_id = ?', whereArgs: [route.id]);

                                  List<Objective> objectives = [];
                                  for (var i = 0; i < objToRoutes.length; i++) {
                                    var objRow = await database.query('objective', where: 'id = ?', whereArgs: [objToRoutes[i]['objective_id']]);
                                    if (objRow.length > 1 || objRow.length == 0) continue;
                                    objectives.add(Objective.fromJson(objRow.first));
                                  }

                                  var bikeRoute = new BikeRoute.fromJson(routes.first);
                                  bikeRoute.coordinates = List.generate(coords.length, (i) {
                                    return Coordinates.fromJson(coords[i]);
                                  });
                                  bikeRoute.rtsCoordinates = List.generate(coords.length, (i) => bikeRoute.coordinates[i].toLatLng());
                                  bikeRoute.elevationPoints = List.generate(coords.length, (i) => bikeRoute.coordinates[i].toElevationPoint());
                                  bikeRoute.objectives = objectives;

                                  var serverRoute = await RouteService().getRoute(route_id: bikeRoute.id);

                                  if (serverRoute != null) {
                                    database.update('route', {'rating': serverRoute.rating, 'rating_count': serverRoute.ratingCount},
                                        where: 'id = ?', whereArgs: [bikeRoute.id]);
                                    bikeRoute.rating = serverRoute.rating;
                                    bikeRoute.ratingCount = serverRoute.ratingCount;
                                  }

                                  Navigator.pushNamed(context, MapScreen.route, arguments: bikeRoute);
                                } on Exception catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Detalii'),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                            ),
                          ],
                        )),
                    flex: 1)
              ],
            )
          ],
        ));
  }
}
