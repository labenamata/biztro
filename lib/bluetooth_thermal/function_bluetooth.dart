import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

Future<List> getBluetooth() async {
  final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
  print("Print $bluetooths");
  return bluetooths!;
}

Future<bool> setConnect(String mac) async {
  await BluetoothThermalPrinter.connect(mac);
  String? result = await BluetoothThermalPrinter.connectionStatus;
  print("state connected $result");
  if (result! == "true") {
    return true;
  } else {
    return false;
  }
}
