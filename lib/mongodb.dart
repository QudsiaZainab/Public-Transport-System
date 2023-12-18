import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase{
  static insertRoutes() async{
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(ROUTES_COLLECTION_NAME);
    await collection.insertOne({
      "email" : "email",
      "password" : "password",
    });
    print(await collection.find().toList());
  }

  static Future<String> getNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      final collection = db.collection(DRIVER_COLLECTION_NAME);

      // Search for a document with the provided phone number
      final document = await collection.findOne(where.eq('phone_no', phoneNumber));

      await db.close();

      // If the document is found, return the associated name, otherwise return a default value (empty string in this case)
      return document?['name'] as String;
    } catch (e) {
      print('Error getting name for phone number: $e');
      return ''; // Handle the error as needed or provide a default value
    }
  }


  static driverSignup(String name, String phoneNo) async{
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(DRIVER_COLLECTION_NAME);
    if (phoneNo.startsWith("+92")) {
      phoneNo = phoneNo.replaceFirst("+92", "0");
    }
    await collection.insertOne({
      "name" : name,
      "phone_no" : phoneNo,
    });
    print(await collection.find().toList());
  }

  static signup(String name, String phoneNo) async{
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME);
    if (phoneNo.startsWith("+92")) {
      phoneNo = phoneNo.replaceFirst("+92", "0");
    }
    await collection.insertOne({
      "name" : name,
      "phone_no" : phoneNo,
    });
    print(await collection.find().toList());
  }

  static Future<bool> checkPhoneNumberRegistration(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      // Search for a document with the provided phone number
      final count = await db.collection(COLLECTION_NAME).count(where.eq('phone_no', phoneNumber));

      await db.close();

      // If count is greater than 0, phone number is already registered
      return count > 0;
    } catch (e) {
      print('Error checking phone number registration: $e');
      return false; // Handle the error as needed
    }
  }

  static Future<bool> checkDriverPhoneNumberRegistration(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      // Search for a document with the provided phone number
      final count = await db.collection(DRIVER_COLLECTION_NAME).count(where.eq('phone_no', phoneNumber));

      await db.close();

      // If count is greater than 0, phone number is already registered
      return count > 0;
    } catch (e) {
      print('Error checking phone number registration: $e');
      return false; // Handle the error as needed
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      // Replace 'your_collection_name' with the actual name of your collection
      final collection = db.collection('routes');

      // Fetch all documents in the collection
      final List<Map<String, dynamic>> data = await collection.find().toList();

      await db.close();
      print(data);
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Handle the error as needed
    }


  }


  static Future<String> getVanNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driverCollection = db.collection('drivers');

      // Search for a document with the provided phone number
      final driverDocument = await driverCollection.findOne(where.eq('phone_no', phoneNumber));


      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Fetch van name based on driver ID from the associated collection
        final vanRouteCollection = db.collection('routes');
        final vanDocument = await vanRouteCollection.findOne(where.eq('driver', driverId));
        // print(vanDocument);

        if (vanDocument != null) {
          return vanDocument['vehicleNo'] as String;
        }
      }

      await db.close();
      return ''; // Return empty string if not found
    } catch (e) {
      print('Error getting van name for phone number: $e');
      return ''; // Handle the error as needed
    }
  }

  static Future<String> getRouteNameForPhoneNumber(String phoneNumber) async {

    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driverCollection = db.collection('drivers');

      // Search for a document with the provided phone number
      final driverDocument = await driverCollection.findOne(where.eq('phone_no', phoneNumber));
      // print(driverDocument);

      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Fetch route name based on driver ID from the associated collection
        final vanRouteCollection = db.collection('routes');
        final routeDocument = await vanRouteCollection.findOne(where.eq('driver', driverId));



        if (routeDocument != null) {
          return routeDocument['route_name'] as String;
        }
      }


      await db.close();
      return ''; // Return empty string if not found
    } catch (e) {
      print('Error getting route name for phone number: $e');
      return ''; // Handle the error as needed
    }
  }


  static Future<void> addVehicle(
      String vehicleName, String driverContactNo, double latitude, double longitude) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final vehiclesCollection = db.collection('vehicles');

      // Insert vehicle information into the collection
      await vehiclesCollection.insertOne({
        'vehicle_name': vehicleName,
        'driver_contact_no': driverContactNo,
        'location': {'type': 'Point', 'coordinates': [longitude, latitude]},
      });

      await db.close();
    } catch (e) {
      print('Error adding vehicle: $e');
      // Handle the error as needed
    }
  }


  static Future<void> updateDriverLocation(
      String driverContactNo,
      double latitude,
      double longitude,
      ) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driversCollection = db.collection(DRIVER_COLLECTION_NAME);

      // Find the driver document with the provided phone number
      final driverDocument = await driversCollection.findOne(where.eq('phone_no', driverContactNo));

      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Update the driver's location in the drivers collection
        await driversCollection.update(
          where.eq('phone_no', driverContactNo),
          modify.set('location', {'type': 'Point', 'coordinates': [longitude, latitude]}),
        );

        // Print or handle success if needed
        print('Driver location updated successfully');
      } else {
        print('Driver not found with phone number: $driverContactNo');
      }

      await db.close();
    } catch (e) {
      print('Error updating driver location: $e');
      // Handle the error as needed
    }
  }

  static Future<String> getVehicleNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final collection = db.collection('vehicles');

      // Search for a document with the provided phone number
      final document = await collection.findOne(
        where.eq('driver_contact_no', phoneNumber),
      );

      await db.close();

      // If the document is found, return the associated vehicle name, otherwise return a default value (empty string in this case)
      return document?['vehicle_name'] as String;
    } catch (e) {
      print('Error getting vehicle name for phone number: $e');
      return ''; // Handle the error as needed or provide a default value
    }
  }

}