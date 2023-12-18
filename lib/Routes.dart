import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mongodb.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

class PlaceIdToLocationNameConverter {
  final GoogleMapsPlaces _places =
  GoogleMapsPlaces(apiKey: 'AIzaSyA4kFE1fIOPQA8IU2IpKjtPA0asWWa3ms0');

  Future<String> convertPlaceIdToLocationName(String placeId) async {
    PlacesDetailsResponse details =
    await _places.getDetailsByPlaceId(placeId);
    if (details.isOkay) {
      return details.result.name;
    } else {
      // Handle the error
      return 'Error retrieving location name';
    }
  }
}

void main() {
  runApp(Routes());
}

class Routes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedRoute;
  List<String> routes = [];
  Map<String, List<String>> stops = {};
  Map<String, List<String>> vehicles = {};
  Map<String, List<String>> drivers = {};
  Set<String> uniqueRoutes = {};
  final PlaceIdToLocationNameConverter converter =
  PlaceIdToLocationNameConverter();

  @override
  void initState() {
    super.initState();
    // Call fetchData function to populate the 'routes', 'stops', and 'vehicles' lists
    fetchData();
  }

  // Assuming MongoDatabase.getData() returns a Future<List<Map<String, dynamic>>>
  Future<void> fetchData() async {
    try {
      // Fetch data from the backend
      var data = await MongoDatabase.getData();

      // Extract 'route_name' values from the data and update the 'routes' list
      setState(() {
        uniqueRoutes =
            data.map((entry) => entry['route_name'].toString()).toSet();
        routes = uniqueRoutes.toList(); // Convert set to list for use in the UI
      });

      // Extract 'stop_name' values for each route and update the 'stops' map
      for (var route in routes) {
        stops[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
          return entry['stop'].toString();
        })
            .toList();
      }

      for (var route in routes) {
        drivers[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
          return entry['driver'].toString();
        })
            .toList();
      }

      // Extract 'vehicle_name' values for each route and update the 'vehicles' map
      for (var route in routes) {
        vehicles[route] = data
            .where((entry) => entry['route_name'] == route)
            .map((entry) {
          return entry['vehicleNo'].toString();
        })
            .toList();
      }
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routes'),
      ),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(routes[index]),
            children: [
              // Expansion tile for stops
              Padding(
                padding: const EdgeInsets.only(left: 0.0), // Adjust the left padding as needed
                child: ExpansionTile(
                  title: Text('Stops'),
                  children: stops[routes[index]]?.map((stop) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0.0), // Adjust the left padding as needed
                      child: ExpansionTile(
                        title: Text('Stop Name: $stop'),
                        children: [
                          // Expansion tile for vehicles
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0), // Adjust the left padding as needed
                            child: ExpansionTile(
                              title: Text('Vehicles'),
                              children: vehicles[routes[index]]?.map((vehicle) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0.0), // Adjust the left padding as needed
                                  child: ListTile(
                                    title: Text('Vehicle Name: $vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      // Handle vehicle tap if needed
                                    },
                                  ),
                                );
                              }).toSet().toList() ?? [], // Ensure unique vehicle names
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList() ?? [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}