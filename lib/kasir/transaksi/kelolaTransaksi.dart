import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/transaksi/confirmedTransaksi.dart';
import 'package:chasier/kasir/transaksi/unconfirmedTransaksi.dart';
import 'package:chasier/menu/menuList.dart';
import 'package:chasier/menuSetting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

final GlobalKey<ScaffoldState> scafKey = GlobalKey();

class KelolaTransaksi extends StatefulWidget {
  const KelolaTransaksi({Key? key}) : super(key: key);

  @override
  _KelolaTransaksiState createState() => _KelolaTransaksiState();
}

class _KelolaTransaksiState extends State<KelolaTransaksi>
    with SingleTickerProviderStateMixin {
  late TabController tabTransaksi;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    tabTransaksi = TabController(length: 2, vsync: this, initialIndex: 1);
    tabTransaksi.addListener(() {
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scafKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            leading: GestureDetector(
                onTap: () => scafKey.currentState!.openDrawer(),
                child: Icon(
                  LineIcons.bars,
                  color: textColor,
                )),
            iconTheme: IconThemeData(color: textColor),
            title: Text(
              "TRANSAKSI",
              style: TextStyle(
                  color: textBold, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            //elevation: 1,
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              showAdd(context);
            },
            child: Icon(
              LineIcons.plus,
              color: Colors.white,
            ),
          ),
          drawer: MenuSetting(),
          body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
            return Row(
              children: [
                RotatedBox(quarterTurns: -1, child: menu()),
                Expanded(
                  child: TabBarView(controller: tabTransaksi, children: [
                    ConfirmedTransaksi(),
                    UnconfirmedTransaksi(),
                  ]),
                ),
              ],
            );
          })),
    );
  }

  void showAdd(BuildContext context) {
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
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                        leading: Icon(
                          LineIcons.chair,
                          color: primaryColor,
                        ),
                        title: Text(
                          "Dine In",
                          style: TextStyle(color: textColor),
                        ),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(1, "baru", "", 1)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          LineIcons.motorcycle,
                          color: primaryColor,
                        ),
                        title:
                            Text("Go Food", style: TextStyle(color: textColor)),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(2, "baru", "", 1)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.motorcycle,
                          color: primaryColor,
                        ),
                        title: Text("Grab Food",
                            style: TextStyle(color: textColor)),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(3, "baru", "", 1)),
                          );
                        },
                      )
                    ],
                  )),
            ));
      },
    );
  }

  Widget menu() {
    return Container(
      child: TabBar(
        controller: tabTransaksi,
        labelColor: Colors.white,
        indicator: BoxDecoration(color: primaryColor),
        unselectedLabelColor: textColor,
        indicatorSize: TabBarIndicatorSize.tab,
        //indicatorPadding: EdgeInsets.symmetric(vertical: 10),
        tabs: [
          Tab(
            text: "Confirmed",
            // text: "Bayar",
          ),
          Tab(
            text: "Unconfirmed",
          ),
        ],
      ),
    );
  }
}
