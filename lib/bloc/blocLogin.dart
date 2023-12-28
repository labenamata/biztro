import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelLogin.dart';
import 'package:chasier/token.dart' as token;

class LoginEvent {}

abstract class LoginState {}

class LoginUn extends LoginState {}

class LoginMasuk extends LoginEvent {
  String username;
  String password;
  LoginMasuk({required this.username, required this.password});
}

class LoginLoading extends LoginState {}

class LoginFailed extends LoginState {
  String message;
  LoginFailed(this.message);
}

class LoginLoaded extends LoginState {
  Future<ParsingLogin> dataLogin;
  LoginLoaded(this.dataLogin);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState) {
    on<LoginMasuk>(_loginMasuk);
  }

  Future<void> _loginMasuk(
      LoginMasuk event, Emitter<LoginState> emit) async {
    Future<ParsingLogin> dataLogin;
    String message = "";
    emit(LoginLoading());
    dataLogin = ParsingLogin.loginMasuk(event.username, event.password);
    await dataLogin.then((value) {
      message = value.message;
    });
    if (message == "sukses") {
      await dataLogin.then((value) {
        token.accessToken = value.accessToken;
      });
      emit(LoginLoaded(dataLogin));
    } else {
      emit(LoginFailed(message));
    }
  }
}
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   LoginBloc(LoginState initialState) : super(initialState);
//   //LoginState get initialState => PenjualanAwal();
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     Future<ParsingLogin> dataLogin;
//     String message = "";

//     if (event is LoginMasuk) {
//       yield LoginLoading();
//       dataLogin = ParsingLogin.loginMasuk(event.username, event.password);
//       await dataLogin.then((value) {
//         message = value.message;
//       });
//       if (message == "sukses") {
//         await dataLogin.then((value) {
//           token.accessToken = value.accessToken;
//         });
//         yield LoginLoaded(dataLogin);
//       } else {
//         yield LoginFailed(message);
//       }
//     }
//   }
// }
