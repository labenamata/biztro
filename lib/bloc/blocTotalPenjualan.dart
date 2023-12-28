import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelTotalPenjualan.dart';

class TotalPenjualanEvent {}

abstract class TotalPenjualanState {}

class TotalPenjualanLoaded extends TotalPenjualanState {
  //String status;
  Future<ParsingTotalPenjualan> data;
  TotalPenjualanLoaded(this.data);
}

class TotalPenjualanLoading extends TotalPenjualanState {}

class TotalPenjualanError extends TotalPenjualanState {
  String message;
  TotalPenjualanError({required this.message});
}

class GetTotalPenjualan extends TotalPenjualanEvent {
  String tanggal;
  GetTotalPenjualan(this.tanggal);
}

class TotalPenjualanBloc
    extends Bloc<TotalPenjualanEvent, TotalPenjualanState> {
  TotalPenjualanBloc(TotalPenjualanState initialState) : super(initialState) {
    on<GetTotalPenjualan>(_getTotalPenjualan);
  }

  // Stream<TotalPenjualanState> mapEventToState(
  //     TotalPenjualanEvent event) async* {
  //   Future<ParsingTotalPenjualan> totalPenjualan;
  //   String message = "";
  //   if (event is GetTotalPenjualan) {
  //     yield TotalPenjualanLoading();
  //     totalPenjualan = ParsingTotalPenjualan.getTotal(event.tanggal);
  //     await totalPenjualan.then((value) => message = value.message);
  //     if (message == "sukses") {
  //       yield TotalPenjualanLoaded(totalPenjualan);
  //     } else {
  //       yield TotalPenjualanError(message: message);
  //     }
  //   }
  // }

  Future<void> _getTotalPenjualan(
      GetTotalPenjualan event, Emitter<TotalPenjualanState> emit) async {
    Future<ParsingTotalPenjualan> totalPenjualan;
    String message = "";

    emit(TotalPenjualanLoading());
    totalPenjualan = ParsingTotalPenjualan.getTotal(event.tanggal);
    await totalPenjualan.then((value) => message = value.message);
    if (message == "sukses") {
      emit(TotalPenjualanLoaded(totalPenjualan));
    } else {
      emit(TotalPenjualanError(message: message));
    }
  }
}
