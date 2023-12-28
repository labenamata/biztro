import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bluetooth_thermal/function_bluetooth.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'print.dart';
import 'pengaturan.dart' as pengaturan;

class StatusPage extends StatefulWidget {
  final int id;
  final String name;
  final String tanggal;
  final int total;
  final int bayar;
  final int kembali;
  final String priceType;

  StatusPage(
      {required this.bayar,
      required this.kembali,
      required this.id,
      required this.name,
      required this.tanggal,
      required this.priceType,
      required this.total});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  int indeks = 0;
  @override
  void initState() {
    //initPrinter();
    DetailPenjualanBloc detailBloc =
        BlocProvider.of<DetailPenjualanBloc>(context);
    detailBloc.add(DetailCari(widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaBackgroundLight,
      body: ColorfulSafeArea(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: buildSukses()),
              VerticalDivider(
                width: 20,
                thickness: 2,
                color: warnaPrimerLight,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    buildCetakPrinter(context),
                    SizedBox(
                      height: 20,
                    ),
                    buildKembali(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Material buildCetakPrinter(BuildContext context) {
    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: BlocBuilder<DetailPenjualanBloc, DetailState>(
            builder: (context, state) {
          if (state is DetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: warnaPrimer,
              ),
            );
          } else if (state is DetailError) {
            DetailError err = state;
            Fluttertoast.showToast(msg: err.message);
            return Center(
              child: Icon(
                Icons.error,
                color: warnaPrimer,
              ),
            );
          } else {
            DetailLoaded detailLoaded = state as DetailLoaded;
            return InkWell(
              splashColor: warnaPrimerLight,
              onTap: () {
                if (pengaturan.namaPrinter1 != "test") {
                  cetakPrinter(
                      tipe: widget.priceType,
                      id: widget.id,
                      name: widget.name,
                      tanggal: widget.tanggal,
                      total: widget.total,
                      printerAddress: pengaturan.mac1,
                      detailPenjualan: detailLoaded.detailPenjualan,
                      bayar: widget.bayar,
                      kembali: widget.kembali);
                } else {
                  Fluttertoast.showToast(msg: "Printer belum di setting");
                }
              },
              child: Container(
                //width: double.infinity,
                height: 70,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: warnaPrimerLight),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Icon(
                      Icons.print,
                      color: warnaPrimerLight,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cetak Struk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: warnaTeksLight,
                          ),
                        ),
                        pengaturan.namaPrinter1 != "test"
                            ? Text(pengaturan.namaPrinter1,
                                style: TextStyle(color: warnaPrimerLight))
                            : Text("Printer belum di setting",
                                style: TextStyle(
                                  color: warnaPrimerLight,
                                ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }));
  }

  Material buildKembali(BuildContext context) {
    return Material(
      color: theme == "dark" ? warnaSekunderDark : warnaSekunderLight,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        splashColor: warnaPrimerLight,
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Container(
          //width: double.infinity,
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: warnaPrimerLight),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: warnaTeksLight,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Kembali",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: warnaTeksLight,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildSukses() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
          child: Icon(
            Icons.check,
            size: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Sukses",
          style: TextStyle(
              color: Colors.grey, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Transaksi Berhasil Disimpan",
          style: TextStyle(
              color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void initPrinter() {
    print('init printer');

    // _printerManager.startScan(Duration(seconds: 2));
    // _printerManager.scanResults.listen((event) {
    //   if (!mounted) return;
    //   setState(() => _devices = event);

    //   if (_devices.isEmpty)
    //     setState(() {
    //       _devicesMsg = 'No devices';
    //     });
    // });
  }

  // void showDeviceList(BuildContext context) {
  //   //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);

  //   showDialog<void>(
  //     context: context,
  //     //barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         child: Card(
  //           child: Container(
  //               padding: EdgeInsets.all(20),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   _devices.isNotEmpty
  //                       ? ListView.builder(
  //                           shrinkWrap: true,
  //                           itemCount: _devices.length,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             return ListTile(
  //                               onTap: () {
  //                                 setState(() {
  //                                   indeks = index;
  //                                 });

  //                                 Navigator.pop(context);
  //                               },
  //                               leading: Icon(
  //                                 Icons.print_rounded,
  //                                 color: theme == "dark"
  //                                     ? warnaPrimerDark
  //                                     : warnaPrimerLight,
  //                               ),
  //                               title: Text(_devices[index].name),
  //                             );
  //                           })
  //                       : Center(
  //                           child: Text(_devicesMsg),
  //                         ),
  //                 ],
  //               )),
  //         ),
  //       );
  //     },
  //   );
  // }

  void cetakPrinter(
      {required int id,
      required String name,
      required String tipe,
      required String tanggal,
      required int total,
      required String printerAddress,
      required Future<ParsingPenjualan> detailPenjualan,
      required int bayar,
      required int kembali}) async {
    BluetoothThermalPrinter.connect(printerAddress);
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == 'true') {
      List<int> bytes = await struk(
          id: id,
          tipe: tipe,
          name: name,
          tanggal: tanggal,
          total: total,
          detailPenjualan: detailPenjualan,
          bayar: bayar,
          kembali: kembali);
      await BluetoothThermalPrinter.writeBytes(bytes);
      Fluttertoast.showToast(msg: "Cetak Struk Sukses");
    }
  }

  void showMyDialog(BuildContext context) {
    //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);

    showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Future.delayed(new Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Printing..")
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
