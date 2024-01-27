import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/bloc/blocSend.dart';
import 'package:chasier/bloc/blocTable.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/model/modelTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class SaveTransaksi extends StatefulWidget {
  final int priceId;
  SaveTransaksi({required this.priceId});

  @override
  _SaveTransaksiState createState() => _SaveTransaksiState();
}

class _SaveTransaksiState extends State<SaveTransaksi> {
  final TextEditingController namaController = TextEditingController();

  final TextEditingController mejaController = TextEditingController();

  int _tables = 1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 250,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atas Nama',
                  style:
                      TextStyle(color: textBold, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: namaController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                        hintText: "Nama", border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Meja',
                  style:
                      TextStyle(color: textBold, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<TablesBloc, TablesState>(builder: (context, state) {
                  if (state is TablesLoading) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text("Meja")));
                  } else if (state is TablesError) {
                    TablesError tablesError = state;
                    return Center(child: Text(tablesError.message));
                  } else {
                    TablesLoaded tablesLoaded = state as TablesLoaded;
                    return FutureBuilder<ParsingTable>(
                        future: tablesLoaded.data,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text("Meja"));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  hint: Text("Meja",
                                      style: TextStyle(color: textColor)),
                                  style: TextStyle(color: textColor),
                                  isExpanded: true,
                                  icon: Icon(LineIcons.angleDown,
                                      color: primaryColor),
                                  value: _tables,
                                  items: snapshot.data!.tables.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value.name),
                                      value: value.id,
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      _tables = value!;
                                      mejaController.text = _tables.toString();
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                        });
                  }
                }),

                // TextField(
                //   controller: mejaController,
                //   decoration: InputDecoration(hintText: "Meja"),
                // ),
                Spacer(),
                SizedBox(
                  height: 50,
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomPrimaryButton(
                            title: "Batal",
                            onpress: () {
                              Navigator.pop(context);
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomPrimaryButton(
                            title: "OK",
                            onpress: () {
                              SendBloc sendBloc =
                                  BlocProvider.of<SendBloc>(context);
                              if (widget.priceId == 2) {
                                sendBloc.add(SendData(
                                    tipe: "gofood",
                                    nama: namaController.text,
                                    meja: int.parse(mejaController.text)));
                              } else if (widget.priceId == 3) {
                                sendBloc.add(SendData(
                                    tipe: "grab",
                                    nama: namaController.text,
                                    meja: int.parse(mejaController.text)));
                              } else {
                                sendBloc.add(SendData(
                                    tipe: "cash",
                                    nama: namaController.text,
                                    meja: int.parse(mejaController.text)));
                              }

                              Future.delayed(Duration(milliseconds: 500), () {
                                PenjualanBloc penjualanData =
                                    BlocProvider.of<PenjualanBloc>(context);
                                penjualanData
                                    .add(PenjualanRefresh("unpaid", 0, ""));
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Container buildTombolOk(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Batal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )))),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: warnaSekunder,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyle(color: warnaTitle),
                          ),
                        ),
                      )))),
        ],
      ),
    );
  }
}
