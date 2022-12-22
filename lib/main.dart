import 'dart:convert';
import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'webview.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String qrCodeResult;
  late String jsonData;

  bool backCamera = true;
  StreamSubscription? connection;
  bool isoffline = true;
  @override
  void initState() {
         
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
          print('checker');
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      }
    });
    connectionCheck();
    super.initState();
    
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  Future<http.Response> createRating(String Hash) {
    return http.get(
      Uri.parse('https://zozain.com/qr_scaning.php?json_hash=' + Hash),
    );
  }

  connectionCheck() {
    var result = Connectivity().checkConnectivity();
    print('Checked');
      // ignore: unrelated_type_equality_checks
      if(result == ConnectivityResult.mobile) {
            setState(() {
          isoffline = false;
        });
      // ignore: unrelated_type_equality_checks
      }else if(result == ConnectivityResult.wifi) {
          setState(() {
          isoffline = false;
        });
      // ignore: unrelated_type_equality_checks
      }else if(result == ConnectivityResult.ethernet){
          setState(() {
          isoffline = false;
        });
      // ignore: unrelated_type_equality_checks
      }else if(result == ConnectivityResult.none){
          setState(() {
          isoffline = true;
        });
      }
      return isoffline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ZOZAIN QR"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                child: IconButton(
                  icon: Icon(MaterialCommunityIcons.qrcode_scan),
                  iconSize: 200,
                  onPressed: connectionCheck() ? null :  () async {
                    ScanResult codeSanner = await BarcodeScanner.scan(
                      options: const ScanOptions(
                        useCamera: -1,
                      ),
                    ); //barcode scnner
                    setState(() {
                      var qrCodeResultNew = codeSanner.rawContent;
                      if (isoffline==true){
                              Fluttertoast.showToast(
                              msg: "Incorect QR Code",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Wait for loading..",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      createRating(qrCodeResultNew).then((response) {
                        var jsonResponse = json.decode(response.body);
                        var success = jsonResponse['success'];
                        var jsonData = jsonResponse['websites'];
                        print(jsonData);
                        if (success == true) {
                          
                          // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>GenerateWebView(jsonData)));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  new GenerateWebView(jsonData),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Incorect QR Code",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                      }
                    });
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.all(10),
                child: Text(
                    "Please Scan the QR Code",
                    textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                width: double.infinity,
                height: 20,
                color: isoffline ? Colors.red : Colors.lightGreen,
                padding: EdgeInsets.all(10),
                child: Text(
                  isoffline ? "Device is Offline" : "Device is Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              )
            ],
          ),
        ));
  }
}

int camera = 1;
