import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/pesanan/kelolaPesanan.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class UnconfirmedTransaksi extends StatefulWidget {
  const UnconfirmedTransaksi({Key? key}) : super(key: key);

  @override
  _UnconfirmedTransaksiState createState() => _UnconfirmedTransaksiState();
}

class _UnconfirmedTransaksiState extends State<UnconfirmedTransaksi> {
  late Future<ParsingPenjualan> futurePenjualan;

  @override
  void initState() {
    PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);
    penjualanData.add(PenjualanRefresh("unpaid", 0, ""));
    DetailPenjualanBloc detailBloc =
        BlocProvider.of<DetailPenjualanBloc>(context);
    detailBloc.add(DetailUni());
    super.initState();
    //futurePenjualan = ParsingPenjualan.getPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: warnaPrimerLight,
      onRefresh: () async {
        PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);

        return penjualanData.add(PenjualanRefresh("unpaid", 0, ""));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            buildCari(),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<PenjualanBloc, PenjualanState>(
                builder: (context, state) {
              if (state is PenjualanKosong) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is PenjualanError) {
                PenjualanError penjualanError = state;
                Future.delayed(Duration(seconds: 1), () {
                  return ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar(penjualanError.message));
                });
                return Center(
                  child: Icon(Icons.error),
                );
              } else {
                PenjualanLoaded penjualanLoaded = state as PenjualanLoaded;
                return FutureBuilder<ParsingPenjualan>(
                    future: penjualanLoaded.penjualan,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: warnaPrimerLight,
                        )));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        var newFormat = DateFormat("dd-MMM-yyyy HH:mm");

                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8),
                            itemCount: snapshot.data!.dataPenjualan.length < 10
                                ? 10
                                : snapshot.data!.dataPenjualan.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index + 1 <=
                                  snapshot.data!.dataPenjualan.length) {
                                var date = DateTime.parse(snapshot
                                    .data!.dataPenjualan[index].time
                                    .toString());
                                var tanggal = newFormat.format(date);
                                return pesanan(
                                  id: snapshot.data!.dataPenjualan[index].id,
                                  nama: snapshot.data!.dataPenjualan[index].name
                                      .toUpperCase(),
                                  meja: snapshot
                                      .data!.dataPenjualan[index].table.name,
                                  total:
                                      snapshot.data!.dataPenjualan[index].total,
                                  tanggal: tanggal,
                                  ppn: snapshot.data!.dataPenjualan[index].ppn,
                                  subtotal: snapshot
                                      .data!.dataPenjualan[index].subtotal,
                                );
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      //border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                );
                              }
                            },
                          ),
                        );
                      }

                      // By default, show a loading spinner.
                    });
              }
            }),
          ],
        ),
      ),
    );
  }

  SnackBar snackBar(String mesg) {
    return SnackBar(
      content: Text(mesg),
    );
  }

  Container buildCari() {
    TextEditingController cariController = TextEditingController();
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: cariController,
              cursorColor: primaryColor,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  hintText: "Nama Pelanggan",
                  hintStyle: TextStyle(color: textColor),
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: primaryColor,
                  )),
              onChanged: (value) {
                Future.delayed(Duration(seconds: 1), () {
                  PenjualanBloc penjualanData =
                      BlocProvider.of<PenjualanBloc>(context);
                  penjualanData
                      .add(PenjualanRefresh("unpaid", 0, cariController.text));
                });
              },
            ),
          ),
          // SizedBox(
          //   width: 16,
          // ),
          // SizedBox(
          //     width: 100,
          //     child: CustomPrimaryButton(
          //         title: "Cari",
          //         onpress: () {
          //           PenjualanBloc penjualanData =
          //               BlocProvider.of<PenjualanBloc>(context);
          //           penjualanData.add(
          //               PenjualanRefresh("unpaid", 0, cariController.text));
          //         })),
        ],
      ),
    );
  }

  Widget pesanan(
      {required int id,
      required String nama,
      required String meja,
      required int total,
      required int subtotal,
      required int ppn,
      required String tanggal}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          DetailPenjualanBloc detailBloc =
              BlocProvider.of<DetailPenjualanBloc>(context);
          detailBloc.add(DetailCari(id));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KelolaPesanan(
                        id: id,
                        name: nama,
                        meja: meja,
                        total: total,
                        subtotal: subtotal,
                        ppn: ppn,
                        tanggal: tanggal,
                      )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              //border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tanggal,
                style: TextStyle(fontSize: 12, color: textColor),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nama,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textBold),
                  ),
                  Text(
                    meja,
                    style: TextStyle(fontSize: 14, color: textBold),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "IDR " + formatter.format(total),
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: textBold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
