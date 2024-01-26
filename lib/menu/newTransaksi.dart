import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/menu/saveTransaksi.dart';
import 'package:chasier/model/modelTemp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class NewTransaksi extends StatefulWidget {
  final int priceId;
  final String status;
  final int id;
  NewTransaksi({
    required this.priceId,
    required this.status,
    required this.id,
  });

  @override
  _NewTransaksiState createState() => _NewTransaksiState();
}

class _NewTransaksiState extends State<NewTransaksi> {
  @override
  void initState() {
    TempBloc penjualanData = BlocProvider.of<TempBloc>(context);
    penjualanData.add(GetTemp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BlocBuilder<TempBloc, TempState>(builder: (context, state) {
            if (state is TempLoading) {
              return Center(child: Text("Belum Ada Transaksi"));
            } else {
              TempLoaded tempLoaded = state as TempLoaded;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            Text(
                              formatter.format(tempLoaded.total),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<TempModel>>(
                        future: tempLoaded.data,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text("Belum Ada Transaksi"));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border:
                                            Border.all(color: primaryColor)),
                                    //color: Colors.grey,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        iconTakeaway(
                                            snapshot.data![index].isTakeaway),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                    color: textBold,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${snapshot.data![index].qty.toString()} x ${formatter.format(snapshot.data![index].price)}',
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              Text(
                                                  "Varian : ${snapshot.data![index].varian}",
                                                  style: TextStyle(
                                                      color: textColor)),
                                              Text(
                                                  "Note : ${snapshot.data![index].note} ",
                                                  style: TextStyle(
                                                      color: textColor)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                            formatter.format(
                                                snapshot.data![index].total),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: textBold,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            TempBloc tempBloc =
                                                BlocProvider.of<TempBloc>(
                                                    context);
                                            tempBloc.add(HapusTemp(
                                                menuId: snapshot
                                                    .data![index].menuId));
                                          },
                                          child: SizedBox(
                                              height: 100,
                                              width: 50,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                              10,
                                                            ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color: primaryColor),
                                                child: Center(
                                                    child: Icon(
                                                        LineIcons
                                                            .alternateTrashAlt,
                                                        color: Colors.white)),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                              ),
                            );

                            // By default, show a loading spinner.
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                  ]);
            }
          }),
        ),
        CustomPrimaryButton(
            title: "Simpan",
            onpress: () {
              if (widget.status == "baru") {
                showDialog<void>(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SaveTransaksi(priceId: widget.priceId);
                    });
              } else {
                DetailPenjualanBloc detailBloc =
                    BlocProvider.of<DetailPenjualanBloc>(context);
                detailBloc.add(TambahPesanan(widget.id));
                Navigator.pop(context);
              }
            }),
        SizedBox(
          height: 10,
        ),
      ],
    ));
  }

  Container iconTakeaway(int status) {
    if (status == 1) {
      return Container(
        child: Icon(
          LineIcons.shoppingBag,
          color: primaryColor,
        ),
      );
    } else {
      return Container(
        child: Icon(LineIcons.utensilSpoon, color: primaryColor),
      );
    }
  }
}
