import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:moawen/model/ads_model.dart';
import 'package:moawen/model/status.dart';
import 'package:moawen/postmodel.dart';
import 'package:path/path.dart';

class ADSAdd extends StatefulWidget {
  const ADSAdd({super.key});

  @override
  State<StatefulWidget> createState() => _ADSAddState();
}

class _ADSAddState extends State<ADSAdd> {
  static const String _title = 'Add Request';
  final TextEditingController _infoController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  late String _date = "Not set";

  // Initial Selected Value
  late String dropdownValue = 'choose ads period';
  late String _selectedPeriod = 'choose ads period';
  late int _selectedPeriodIndex = -1;
  List<String> periodList = [
    'choose ads period',
    '12am - 4am',
    '4am  - 8am',
    '8am  - 12am',
    '12pm - 4am',
    '4pm  - 8pm',
    '8pm  - 12pm'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 247, 246),
      appBar: AppBar(
        title: const Center(
          child: Text(_title),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 26,
        ),
        backgroundColor: const Color(0XFF2F6968),
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0XFF2F6968),
                        child: _photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _photo!,
                                  width: 250,
                                  height: 150,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _infoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Write here your ads text',
                      ),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose Ads Date:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.black38))),
                      ),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(5.0)),
                      //elevation: 4.0,
                      //color: Colors.white,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: const DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            //maxTime: DateTime(2022, 12, 31),
                            onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " $_date",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton(
                        style: Theme.of(context).textTheme.headline5,
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: _selectedPeriod,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: periodList
                            .map((String item) => DropdownMenuItem(
                                value: item, child: Text(item)))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPeriod = newValue!;
                            _selectedPeriodIndex = periodList.indexOf(newValue);
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: 'Price : ',
                            style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: _getTextPrice(),
                                  style: const TextStyle(
                                      color: Colors.blueAccent, fontSize: 20))
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () {
                            saveRecord(context);
                          },
                          child: const Text(
                            "Send",
                            style: TextStyle(fontSize: 22),
                          ), //   child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //void _showPicker(BuildContext context) {}

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  late String imageUrl = '';

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print('error occurred');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  //void imgFromGallery() {}
  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future saveRecord(BuildContext context) async {
    if (_selectedPeriod.isEmpty || _selectedPeriod == dropdownValue) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(showSnackBar("Select Period", Colors.red));
      return;
    }

    if (_infoController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(showSnackBar("Insert your ads info.", Colors.red));
      return;
    }
    if (_photo == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(showSnackBar("Select Image for your ads.", Colors.red));
      return;
    }

    if (_date == 'Not set') {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(showSnackBar("Select Date for your ads.", Colors.cyan));
      return;
    }

    await uploadFile();

    final CollectionReference collectionAds =
        FirebaseFirestore.instance.collection('Ads');

    String docId = collectionAds.doc().id;
    String description = _infoController.text;
    double price = 100.0;
    //String userId = _auth.currentUser!.uid;
    String userId = CatchHelper.uid!;
    StatusEnum status = StatusEnum.inProgress;
    bool paying = false;

    print(userId);

    final adsModel = ADSModel(
        id: docId,
        description: description,
        imageUrl: imageUrl,
        period: _selectedPeriod,
        price: price,
        userId: userId,
        status: status,
        paying: paying);

    await collectionAds.add(adsModel.toJson());

    print("Save Data ");

    const snackDemo = SnackBar(
      content: Text('Saving Record Successfully'),
      backgroundColor: Colors.blueAccent,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackDemo);
    Navigator.of(context).pop();
  }

  showSnackBar(String text, Color color) {
    return SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      backgroundColor: color,
    );
  }

  String _getTextPrice() {
    String price = '';
    print(_selectedPeriodIndex);
    switch (_selectedPeriodIndex) {
      case 1:
        price = '100';
        break;
      case 2:
        price = '120';
        break;
      case 3:
        price = '140';
        break;
      case 4:
        price = '150';
        break;
      case 5:
        price = '80';
        break;
    }
    return '$price SAR';
  }
}
