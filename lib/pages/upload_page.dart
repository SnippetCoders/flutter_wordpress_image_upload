import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_image_upload/service/shared_service.dart';
import '../service/api_service.dart';
import '../utils/form_helper.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String status = "";
  String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordpress Media Upload'),
        elevation: 0,
        actions: [
          IconButton(
            icon: new Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              SharedService.logout(context);
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormHelper.picPicker(fileName, (file) async {
              setState(() {
                fileName = file.path.toString();
              });
              var res = await APIServices.uploadImage(file);
              setState(() {
                status = res ? "Uploaded" : "Failed";
              });
            }),
            SizedBox(height: 10),
            Visibility(
              child: CircularProgressIndicator(),
              visible: status == "" && fileName != null,
            ),
            Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),
            )
          ],
        ),
      ),
    );
  }
}
