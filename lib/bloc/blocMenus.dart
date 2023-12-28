import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelMenu.dart';
import 'package:equatable/equatable.dart';

class MenusEvent {}

abstract class MenusState extends Equatable {}

class MenusLoaded extends MenusState {
  //String status;
  final Future<ParsingMenu> data;
  MenusLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class MenusLoading extends MenusState {
  final String message;
  MenusLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class MenusError extends MenusState {
  final String message;
  MenusError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetMenu extends MenusEvent {
  String name;
  GetMenu(this.name);
}

class UpdateStok extends MenusEvent {
  int id;
  int stok;
  int visible;
  UpdateStok({required this.id, required this.stok, required this.visible});
}

class MenusBloc extends Bloc<MenusEvent, MenusState> {
  MenusBloc(MenusState initialState) : super(initialState) {
    on<GetMenu>(_getMenu);
    on<UpdateStok>(_updateStok);
  }

  // if (event is GetMenu) {
  //   yield MenusLoading();
  //   menus = ParsingMenu.getMenu(event.name);
  //   await menus.then((value) => message = value.message);
  //   if (message == "sukses") {
  //     yield MenusLoaded(menus);
  //   } else {
  //     yield MenusError(message: message);
  //   }
  // }
  // if (event is UpdateStok) {
  //   yield MenusLoading();
  //   Future<String?> pesan =
  //       ParsingMenu.updateStok(event.id, event.stok, event.visible);
  //   await pesan.then((value) => status = value);
  //   if (status == "sukses") {
  //     menus = ParsingMenu.getMenu("");
  //     await menus.then((value) => message = value.message);
  //     if (message == "sukses") {
  //       yield MenusLoaded(menus);
  //     } else {
  //       yield MenusError(message: message);
  //     }
  //   }
  // }

  Future<void> _getMenu(GetMenu event, Emitter<MenusState> emit) async {
    Future<ParsingMenu> menus;
    String message = "";
    emit(MenusLoading(''));
    menus = ParsingMenu.getMenu(event.name);
    await menus.then((value) => message = value.message);
    if (message == "sukses") {
      emit(MenusLoaded(menus));
    } else {
      emit(MenusError(message: message));
    }
  }

  Future<void> _updateStok(UpdateStok event, Emitter<MenusState> emit) async {
    Future<ParsingMenu> menus;
    String message = "";
    String? status = "";
    emit(MenusLoading(''));
    Future<String?> pesan =
        ParsingMenu.updateStok(event.id, event.stok, event.visible);
    await pesan.then((value) => status = value);
    if (status == "sukses") {
      menus = ParsingMenu.getMenu("");
      await menus.then((value) => message = value.message);
      if (message == "sukses") {
        emit(MenusLoaded(menus));
      } else {
        emit(MenusError(message: message));
      }
    }
  }
}
