import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<List<int>> tesprint() async {
  List<int> bytes = [];
  final profile = await CapabilityProfile.load();
  final Generator ticket = Generator(PaperSize.mm58, profile);
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  final String timestamp = formatter.format(now);
  bytes += ticket.text(
    "TEST PRINT",
    styles: PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
  );

  bytes += ticket.text(timestamp, styles: PosStyles(align: PosAlign.center));
  bytes += ticket.text(
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
      styles: PosStyles(align: PosAlign.left));

  bytes += ticket.cut();

  return bytes;
}

decodeImage(Uint8List bytes) {}
