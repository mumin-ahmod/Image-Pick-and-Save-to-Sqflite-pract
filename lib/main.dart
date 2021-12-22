import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_storing_pract/database.dart';
import 'package:image_storing_pract/profile_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ImagePickerPage(),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}


class _ImagePickerPageState extends State<ImagePickerPage> {


  Future<String> pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    var imageBytes = await image!.readAsBytes();

    print("IMAGE PICKED: ${image.path}");

    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  List<ProfileModel> pList = [];

  String? byte64String;

  @override
  initState() {
    DatabaseHelper.getAllProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Pick"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text("INPUT IMAGE"),

            ElevatedButton(onPressed: () async{
             byte64String = await pickImage();

             print("BYTE 64 STRING: $byte64String");
            }, child: Text("Pick Image")),

            const SizedBox(height: 30,),

            ElevatedButton(onPressed: () async{

             await DatabaseHelper.insertProfile(ProfileModel(name: "Murad", image64bit: byte64String).toMap());

              pList = await DatabaseHelper.getAllProfile();
              setState(() {

              });

              print(pList[0].id);
             print(pList[0].name);
             print(pList[0].image64bit);
            }, child: const Text("Save Profile")),

           Flexible(
             child: ListView.builder(

               shrinkWrap: true,
                 itemCount: pList.isNotEmpty ?  pList.length : 1,
                 itemBuilder: (context, index){

                   return SizedBox(

                     height: 300,
                     width: double.infinity,
                     child: Card(
                       color: Colors.black54,

                       child: pList.isNotEmpty ? Image.memory(const Base64Decoder().convert(pList[index].image64bit!)) : Text("No Profile"),

                     ),
                   );

             }
             ),
           ),

          ],
        ),
      ),
    );
  }
}
