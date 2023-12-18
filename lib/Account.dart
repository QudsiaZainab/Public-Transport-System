import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'mongodb.dart';

void main() async{
  runApp(Account());
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTS',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'PTS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    LoginPage(),
    SignUpPage(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child:Center(
        child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Sign Up',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  // final Function(String) onLogin;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneNumberInvalid = false;
  bool isRegistered = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.0),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(),
              ),
            ),
            if(!isRegistered)
              Text(
                '*This phone number is not valid.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Check if the phone number is registered
                String phoneNo = _phoneController.text;
                isRegistered = await MongoDatabase.checkPhoneNumberRegistration(phoneNo);
                setState(() {});

                if (isRegistered) {
                  print("loggedin successfully");
                  // Phone number is registered, navigate to the main page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlutterApp(), // Replace YourMainPage with the actual name of your main page
                    ),
                  );
                }
                else{
                  _isPhoneNumberInvalid = true;
                  print("invalid phone number");
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String phoneNo;
  bool isPhoneNumberRegistered = false;
  bool isPhoneNumberValid = true;
  bool isNameValid = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 50.0),
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            if(!isNameValid)
              Text(
                '*Invalid Name. Your name should include alphabets and underscores only.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                phoneNo = value;
              },
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(),
              ),
            ),
            if(!isPhoneNumberValid)
              Text(
                '*This phone number is not valid.',
                style: TextStyle(color: Colors.red),
              ),
            // Display error message if phone number is already registered
            if (isPhoneNumberRegistered)
              Text(
                '*This phone number is already registered.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Check if the phone number is already registered
                isPhoneNumberRegistered = await MongoDatabase.checkPhoneNumberRegistration(phoneNo);
                setState(() {});
                isPhoneNumberValid = checkPhoneNumberValid(phoneNo);
                setState(() {});
                isNameValid = checkValidName(name);
                setState(() {});

                if (!isNameValid)
                  {
                    print('invalid name');
                  }
                else if (!isPhoneNumberValid)
                  {
                    print('This phone number is not valid.');
                  }
                else if(isPhoneNumberRegistered) {
                  // Phone number is already registered
                  // Handle this case (show an error message, etc.)
                  print('Phone number is already registered.');
                } else {
                  // Phone number is not registered, proceed with signup
                  MongoDatabase.signup(name, phoneNo);
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

bool checkPhoneNumberValid(String phoneNo) {
  // Remove any spaces from the input
  String formattedPhoneNo = phoneNo.replaceAll(" ", "");
  RegExp pattern = RegExp(r'^\+?\d+$');

  // Check if the phone number starts with either +92 or 0
  if (formattedPhoneNo.startsWith("+92") && formattedPhoneNo.length == 13) {
    // Phone number is valid if it starts with +92 and has 13 digits
    return pattern.hasMatch(formattedPhoneNo);
  } else if (formattedPhoneNo.startsWith("03") && formattedPhoneNo.length == 11) {
    // Phone number is valid if it starts with 0 and has 11 digits
    return pattern.hasMatch(formattedPhoneNo);
  } else {
    // Phone number is not valid
    return false;
  }
}

bool checkValidName(String name) {
  // Define a regular expression pattern for a valid name
  RegExp pattern = RegExp(r'^[a-zA-Z_]{2,}$');

  // Check if the name matches the pattern
  return pattern.hasMatch(name);
}