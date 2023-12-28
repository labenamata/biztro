import 'dart:typed_data';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'pengaturan.dart' as pengaturan;

Future<List<int>> struk(
    {required id,
    required String name,
    required String tanggal,
    required int total,
    required String tipe,
    required Future<ParsingPenjualan> detailPenjualan,
    required int bayar,
    required int kembali}) async {
  List<int> bytes = [];
  final profile = await CapabilityProfile.load();
  final Generator ticket = Generator(PaperSize.mm58, profile);
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  final numberFormatter = new NumberFormat("#,###", "id_ID");
  final String timestamp = formatter.format(now);

  // final ByteData data = await rootBundle.load('assets/rabbit.jpg');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final Image gambar = decodeImage(bytes);
  // ticket.image(gambar);
  await detailPenjualan.then((data) {
    bytes += ticket.text(
      pengaturan.namaToko,
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += ticket.text(
      "Dining & Coffe",
      styles: PosStyles(
        align: PosAlign.center,
        // height: PosTextSize.,
        // width: PosTextSize.size1,
      ),
    );

    bytes += ticket.text(pengaturan.alamat,
        styles: PosStyles(align: PosAlign.center));
    bytes +=
        ticket.text(pengaturan.kota, styles: PosStyles(align: PosAlign.center));
    bytes += ticket.text(pengaturan.telepon,
        styles: PosStyles(align: PosAlign.center));
    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: "Kasir", width: 6),
      PosColumn(
          text: pengaturan.kasir,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.row([
      PosColumn(text: "Customer", width: 6),
      PosColumn(
          text: data.dataPenjualan[0].name,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.row([
      PosColumn(text: id.toString(), width: 6),
      PosColumn(
          text: tanggal, width: 6, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.hr();
    data.dataPenjualan[0].groupDetails.forEach((value) {
      var jumlahTotal = value.qty * value.menu.price;
      bytes += ticket.row([
        PosColumn(
            text: value.menu.name,
            width: 12,
            styles: PosStyles(align: PosAlign.left)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: "Variant : " + value.varian.name,
            width: 12,
            styles: PosStyles(align: PosAlign.left)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: value.qty.toString(),
            width: 1,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: " x " + numberFormatter.format(value.menu.price),
            width: 5,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: " = ", width: 3, styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: numberFormatter.format(jumlahTotal),
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });
    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
          text: 'SubTotal',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].subtotal),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'PB1',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].ppn),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Diskon',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].diskon),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Total Bayar',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].total),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);

    bytes += ticket.hr(ch: '=', linesAfter: 1);
    if (tipe == "cash") {
      bytes += ticket.row([
        PosColumn(
            text: 'Cash',
            width: 7,
            styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
        PosColumn(
            text: numberFormatter.format(bayar),
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      ]);
    } else {
      bytes += ticket.row([
        PosColumn(
            text: tipe,
            width: 12,
            styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
      ]);
    }

    bytes += ticket.row([
      PosColumn(
          text: 'Change',
          width: 7,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
      PosColumn(
          text: numberFormatter.format(kembali),
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += ticket.cut();
  });

  return bytes;
}

decodeImage(Uint8List bytes) {}
