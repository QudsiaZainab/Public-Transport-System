import 'package:flutter/material.dart';
import 'Settings.dart';
import 'Routes.dart';
import 'DriverAccount.dart';
import 'JourneyPlanner.dart';
import 'RateApp.dart';
import 'Map.dart';
import 'SplashScreen.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/navpic.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              HoverableRoutesButton(
                imagePath: 'assets/images/nearby grey.jpeg',
                label: 'Nearby',
              ),
              HoverableRoutesButton(
                imagePath: 'assets/images/routes grey.jpeg',
                label: 'Routes',
              ),
              HoverableRoutesButton(
                imagePath: 'assets/images/favourites grey.jpeg',
                label: 'Favorites',
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(height: 5),
          ListTile(
            leading: Image.asset(
              'assets/images/journey grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Journey Planner'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JourneyPlanner(),
                ),
              );
            },
          ),
          ListTile(
            leading: Container(
              width: 30, // Width set karein
              height: 30, // Height set karein
              child: Icon(Icons.map,
                  size: 30), // Icon widget ko size property ke sath set karein
            ),
            title: Text('Show Map'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Map(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/settings grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Settings'),
            onTap: () {
              // Navigate to a new page here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/rate app grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Rate this app'),
            onTap: () {
              // Handle the tap on the "Driver View" button
              // Add your functionality here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RateApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/remove ad grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Remove ads'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/van grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Transport Lists'),
            onTap: () => null,
          ),
          Divider(),
          // ListTile(
          //   title: Text('Go to our website'),
          //   leading: Icon(Icons.public),
          //   onTap: () => null,
          // ),
          // Divider(), // Add a divider before the custom button
          ListTile(
            leading:
                Icon(Icons.drive_eta), // Change the icon to your preference
            title: Text(
              'Driver View',
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
            tileColor: Colors.red, // Set the background color to red
            onTap: () {
              // Handle the tap on the "Driver View" button
              // Add your functionality here
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DriverAccount(),
                ),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class HoverableRoutesButton extends StatefulWidget {
  final String imagePath;
  final String label;

  const HoverableRoutesButton({
    required this.imagePath,
    required this.label,
  });

  @override
  _HoverableRoutesButtonState createState() => _HoverableRoutesButtonState();
}

class _HoverableRoutesButtonState extends State<HoverableRoutesButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: InkWell(
          onTap: () {
            // Add your button's functionality here
            // For example, you can navigate to a new screen:
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Routes()));
          },
          child: Container(
            color: isHovered
                ? Colors.blue
                : Colors.transparent, // Change background color on hover
            child: Column(
              children: [
                Image.asset(
                  widget.imagePath,
                  width: 20, // Set the width of the image as needed
                  height: 20, // Set the height of the image as needed
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.black, // Set the text color to gray
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
