import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:chasier/bluetooth_thermal/function_bluetooth.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/model/modelPengaturan.dart';
import 'package:chasier/pengaturan.dart';
import 'package:chasier/tesPrint.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingPrinter extends StatefulWidget {
  @override
  _SettingPrinterState createState() => _SettingPrinterState();
}

class _SettingPrinterState extends State<SettingPrinter> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  late int indeks;
  late int indeks2;
  String address1 = "";
  String address2 = "";
  String nama1 = "";
  String nama2 = "";
  int stat = 0;
  int stat2 = 0;
  String indek2ada = "belum";
  bool isConnected = false;
  bool isScanning = false;
  late Future<List> listDevices;
  @override
  void initState() {
    super.initState();
    namaController.text = namaToko;
    alamatController.text = alamat;
    kotaController.text = kota;
    teleponController.text = telepon;
    nama1 = namaPrinter1;
    nama2 = namaPrinter2;
    address1 = mac1;
    address2 = mac2;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {};
    return MaterialApp(
      home: Scaffold(
        backgroundColor: warnaBackgroundLight,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: warnaPrimerLight,
          title: const Text('Setting Printer'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                buildInputSetting(
                    nama: "Nama Toko", controller: namaController),
                buildInputSetting(nama: "Alamat", controller: alamatController),
                buildInputSetting(nama: "Kota", controller: kotaController),
                buildInputSetting(
                    nama: "Telepon", controller: teleponController),
                SizedBox(
                  height: 20,
                ),
                buildPrinter(context),
                SizedBox(
                  height: 20,
                ),
                buildPrinter2(context),
                SizedBox(
                  height: 20,
                ),
                Material(
                  color: warnaSekunder,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      data = {
                        'id': 1,
                        'nama': namaController.text,
                        'alamat': alamatController.text,
                        'kota': kotaController.text,
                        'telepon': teleponController.text,
                        'printerName1': nama1,
                        'printerAddress1': address1,
                        'printerName2': nama2,
                        'printerAddress2': address2,
                        'alamatIP': alamatIP
                      };
                      namaToko = namaController.text;
                      alamat = alamatController.text;
                      kota = kotaController.text;
                      telepon = teleponController.text;
                      namaPrinter1 = nama1;
                      mac1 = address1;
                      namaPrinter2 = nama2;
                      mac2 = address2;
                      PengaturanModel.simpanData(data);
                      Navigator.pop(context);
                    },
                    splashColor: warnaPrimer,
                    child: Container(
                        height: 50,
                        child: Center(
                          child: Text("Save",
                              style: TextStyle(
                                color: warnaTitleLight,
                              )),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material buildPrinter(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                listDevices = getBluetooth();
                showMyDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: warnaPrimerLight),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.print,
                      color: warnaPrimerLight,
                      size: 25,
                    ),
                    buildTeks(),
                    Icon(
                      Icons.settings_bluetooth,
                      color: warnaPrimerLight,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
                splashColor: Colors.white,
                onTap: () async {
                  isConnected = await setConnect(address1);
                  if (isConnected) {
                    List<int> bytes = await tesprint();
                    await BluetoothThermalPrinter.writeBytes(bytes);
                    Fluttertoast.showToast(msg: "Tes Sukses");
                  }
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: warnaPrimer,
                    ),
                    child: Center(
                        child: Text(
                      "Tes Printer 1",
                      style: TextStyle(color: warnaTitle),
                    )))),
          ],
        ));
  }

  Material buildPrinter2(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                listDevices = getBluetooth();
                showMyDialog2(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: warnaPrimer),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.print,
                      color: warnaPrimer,
                      size: 25,
                    ),
                    buildTeks2(),
                    Icon(
                      Icons.settings_bluetooth,
                      color: warnaPrimer,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
                splashColor: Colors.white,
                onTap: () async {
                  isConnected = await setConnect(address2);
                  if (isConnected) {
                    List<int> bytes = await tesprint();
                    await BluetoothThermalPrinter.writeBytes(bytes);
                    Fluttertoast.showToast(msg: "Tes Sukses");
                  }
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: warnaPrimer,
                    ),
                    child: Center(
                        child: Text(
                      "Tes Printer 2",
                      style: TextStyle(color: warnaTitle),
                    )))),
          ],
        ));
  }

  Widget buildTeks() {
    if (nama1.isEmpty) {
      return Text("Set Printer 1", style: TextStyle(color: warnaTeksLight));
    } else {
      return Text(
        nama1 + "(" + address1 + ")",
        style: TextStyle(color: warnaTeksLight),
      );
    }
  }

  Widget buildTeks2() {
    if (nama2.isEmpty) {
      return Text("Set Printer 2", style: TextStyle(color: warnaTeksLight));
    } else {
      return Text(
        nama2 + "(" + address2 + ")",
        style: TextStyle(color: warnaTeksLight),
      );
    }
  }

  TextField buildInputSetting({
    required String nama,
    required TextEditingController controller,
  }) {
    return TextField(
      style: TextStyle(color: warnaTeksLight),
      controller: controller,
      decoration: InputDecoration(
          labelText: nama,
          labelStyle: TextStyle(
              color: warnaTeksLight),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:  warnaPrimerLight)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color:  warnaSekunderLight,
          ))),
    );
  }

  void showMyDialog(BuildContext context) {
    //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);
    showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Card(
              child: Container(
                height: 200,
                child: FutureBuilder<List>(
                  future: listDevices,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      String select = snapshot.data[index];
                                      List list = select.split("#");
                                      setState(() {
                                        nama1 = list[0];
                                        address1 = list[1];
                                      });
                                      Navigator.pop(context);
                                    },
                                    subtitle: Text(snapshot.data[index]),
                                    leading: Icon(
                                      Icons.print_rounded,
                                      color: warnaPrimerLight,
                                    ),
                                  ),
                                ],
                              ));
                        },
                      );
                    } else {
                      return Center(
                        child: Text("Device not Found"),
                      );
                    }
                  },
                ),
              ),
            ));
      },
    );
  }

  void showMyDialog2(BuildContext context) {
    //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);
    showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Card(
              child: Container(
                height: 200,
                child: FutureBuilder<List>(
                    future: listDevices,
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        String select = snapshot.data[index];
                                        List list = select.split("#");
                                        setState(() {
                                          nama2 = list[0];
                                          address2 = list[1];
                                        });
                                        Navigator.pop(context);
                                      },
                                      subtitle: Text(snapshot.data[index]),
                                      leading: Icon(
                                        Icons.print_rounded,
                                        color: warnaPrimerLight,
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        );
                      } else {
                        return Center(
                          child: Text("Device not Found"),
                        );
                      }
                    }),
              ),
            ));
      },
    );
  }
}
