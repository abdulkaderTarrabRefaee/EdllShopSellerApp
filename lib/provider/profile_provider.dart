import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/error_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/data/repository/profile_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({@required this.profileRepo});

  SellerModel _userInfoModel;
  SellerModel get userInfoModel => _userInfoModel;

  Future<ResponseModel> getSellerInfo(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await profileRepo.getSellerInfo();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _userInfoModel = SellerModel.fromJson(apiResponse.response.data);
     // print('------${_userInfoModel.toJson()}');
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(SellerModel updateUserModel, SellerBody seller, File file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo.updateProfile(updateUserModel, seller, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = 'Success';
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateBalance(String balance) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.updateBalance(balance);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response.data);
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
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

}
