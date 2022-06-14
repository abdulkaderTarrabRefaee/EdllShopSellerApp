import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/error_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/repository/auth_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({@required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for login section
  String _loginErrorMessage = '';

  String get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login({String emailAddress, String password}) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(emailAddress: emailAddress, password: password);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      String token = map["token"];
      authRepo.saveUserToken(token);
      responseModel = ResponseModel(true, '');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false , errorMessage);
    }
    notifyListeners();
    return responseModel;
  }

  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  // for Remember Me Section
  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authRepo.getUserEmail() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }
}
