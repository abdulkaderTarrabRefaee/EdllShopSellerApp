import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/transaction_model.dart';
import 'package:sixvalley_vendor_app/data/repository/transaction_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepo transactionRepo;

  TransactionProvider({@required this.transactionRepo});

  List<TransactionModel> _transactionList;
  List<TransactionModel> _allTransactionList;
  List<TransactionModel> get transactionList => _transactionList;


  String _chooseMonth = '';
  List<String>  _monthItemList = [];

  String get chooseMonth => _chooseMonth;
  List<String> get monthItemList => _monthItemList;



  Future<void> getTransactionList(BuildContext context) async {
    ApiResponse apiResponse = await transactionRepo.getTransactionList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _transactionList = [];
      _allTransactionList = [];
      apiResponse.response.data.forEach((transaction) {
        _transactionList.add(TransactionModel.fromJson(transaction));
        _allTransactionList.add(TransactionModel.fromJson(transaction));
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void filterProduct(int month, BuildContext context) async {
    if (month == 0) {
      _transactionList = [];
      _transactionList.addAll(_allTransactionList);
    } else {
      _transactionList = [];
      _allTransactionList.forEach((transaction) {
        if(DateConverter.getMonthIndex(transaction.createdAt) == month) {
          _transactionList.add(transaction);
        }
      });
      _chooseMonth = _monthItemList[month];
    }
    notifyListeners();
  }


  void initMonthTypeList() async {
    ApiResponse apiResponse = await transactionRepo.getMonthTypeList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _monthItemList = [];
      _monthItemList.addAll(apiResponse.response.data);
      _chooseMonth = apiResponse.response.data[0];
      notifyListeners();
    } else {
      print(apiResponse.error.toString());
    }
  }
}
