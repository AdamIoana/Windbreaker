import 'dart:ui';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:fablebike/bloc/objective_bloc.dart';
import 'package:fablebike/models/user.dart';
import 'package:fablebike/pages/objective.dart';
import 'package:fablebike/services/database_service.dart';
import 'package:fablebike/services/objective_service.dart';
import 'package:fablebike/widgets/card_builder.dart';
import 'package:fablebike/widgets/shimmer_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fablebike/models/route.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

class ObjectivesScreen extends StatefulWidget {
  static const route = '/bookmarks';
  ObjectivesScreen({Key key}) : super(key: key);

  @override
  _ObjectivesScreen createState() => _ObjectivesScreen();
}

class _ObjectivesScreen extends State<ObjectivesScreen> {
  TextEditingController searchController = TextEditingController();
  final _bloc = ObjectiveBloc();
  AuthenticatedUser _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthenticatedUser>();
    _bloc.objectiveEventSync.add(ObjectiveBlocEvent(eventType: ObjectiveEventType.ObjectiveInitializeEvent, args: {'user_id': _user.id}));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double smallDivider = 10.0;
    double bigDivider = 20.0;
    var user = Provider.of<AuthenticatedUser>(context);
    return ColorfulSafeArea(
        overflowRules: OverflowRules.all(true),
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Column(children: [
                          CardBuilder.buildProfileBar(context, 'Obiective', '35 obiective'),
                          SizedBox(height: bigDivider),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Material(
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (context) {
                                          _bloc.objectiveEventSync.add(ObjectiveBlocEvent(
                                              eventType: ObjectiveEventType.ObjectiveSearchEvent, args: {'search_query': searchController.text}));
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.search),
                                            fillColor: Colors.white,
                                            hintStyle: TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor.withOpacity(0.5)),
                                            filled: true,
                                            contentPadding: EdgeInsets.all(0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none, borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                                            hintText: 'Cauta obiectiv...'),
                                      ),
                                      shadowColor: Theme.of(context).accentColor.withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
                                      elevation: 10.0,
                                    ),
                                    flex: 1)
                              ],
                            ),
                            height: 48,
                            width: 999,
                          ),
                          SizedBox(height: bigDivider),
                          Row(children: [
                            Text(
                              "Obiective populare",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.start,
                            )
                          ]),
                          SizedBox(height: smallDivider),
                          StreamBuilder<List<Objective>>(
                            builder: (BuildContext context, AsyncSnapshot<List<Objective>> snapshot) {
                              if (snapshot.hasData && snapshot.data != null && snapshot.data.length > 0) {
                                var objectives = snapshot.data;
                                return Column(
                                  children: [
                                    for (var i = 0; i < objectives.length; i++)
                                      InkWell(
                                        child: CardBuilder.buildlargeObjectiveCard(context, objectives[i], bookmarkCallback: (id) {
                                          _bloc.objectiveEventSync.add(
                                              ObjectiveBlocEvent(eventType: ObjectiveEventType.ObjectiveToggleBookmark, args: {'id': id, 'user_id': user.id}));
                                        }),
                                        onTap: () async {
                                          try {
                                            var objective = snapshot.data[i];
                                            Loader.show(context, progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor));
                                            var database = await DatabaseService().database;
                                            var serverObjective = await ObjectiveService().getObjective(objective_id: objective.id);

                                            if (serverObjective != null) {
                                              await database.update(
                                                  'objective', {'rating': serverObjective.rating, 'rating_count': serverObjective.ratingCount},
                                                  where: 'id = ?', whereArgs: [objective.id]);
                                              objective.rating = serverObjective.rating;
                                              objective.ratingCount = serverObjective.ratingCount;
                                              objective.userRating = serverObjective.userRating;
                                            }

                                            var objectiveInfo = new ObjectiveInfo(objective: objective, fromRoute: ModalRoute.of(context).settings.name);
                                            Navigator.of(context).pushNamed(ObjectiveScreen.route, arguments: objectiveInfo).then((newRating) {
                                              if (newRating != null)
                                                _bloc.objectiveEventSync.add(ObjectiveBlocEvent(
                                                    eventType: ObjectiveEventType.ObjectiveRateEvent, args: {'id': objective.id, 'rating': newRating}));
                                              _bloc.objectiveEventSync.add(ObjectiveBlocEvent(
                                                  eventType: ObjectiveEventType.ObjectiveSearchEvent, args: {'search_query': searchController.text}));
                                            });

                                            Loader.hide();
                                          } on Exception catch (e) {
                                            Loader.hide();
                                          }
                                        },
                                      ),
                                  ],
                                );
                              } else {
                                return Column(children: [for (var i = 0; i < 5; i++) ShimmerCardBuilder.buildlargeObjectiveCard(context)]);
                              }
                            },
                            initialData: [],
                            stream: _bloc.output,
                          ),
                        ]))))));
  }
}
