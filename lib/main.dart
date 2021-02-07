import 'package:flutter/material.dart';
import 'package:wordpress_image_upload/pages/upload_page.dart';

import 'pages/login_page.dart';
import 'service/shared_service.dart';

Widget _defaultHome = new LoginPage();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set default home.

  // Get result of the login function.
  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = new UploadPage();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordpress Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Nunito-Regular',
        primaryColor:
            Colors.redAccent, //Changing this will change the color of the TabBar
        accentColor: Colors.cyan[600],
      ),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => new UploadPage(),          
          '/login': (BuildContext context) => new LoginPage(),
        },
    );
  }
}