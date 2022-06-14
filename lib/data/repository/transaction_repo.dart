import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class TransactionRepo {
  final DioClient dioClient;
  TransactionRepo({@required this.dioClient});

  Future<ApiResponse> getTransactionList() async {
    try {
      final Response response = await dioClient.get(AppConstants.TRANSACTIONS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e){
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getMonthTypeList() async {
    try {
      List<String> monthTypeList = [
        'All', 'January','February','March','April','May','June','July','August','September','October','November','December',
      ];
      Response response = Response(requestOptions: RequestOptions(path: ''), data: monthTypeList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
