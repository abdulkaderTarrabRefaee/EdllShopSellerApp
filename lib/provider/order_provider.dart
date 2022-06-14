import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_details_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/repository/order_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class OrderProvider extends ChangeNotifier {
  final OrderListRepo orderListRepo;
  OrderProvider({@required this.orderListRepo});


  List<OrderModel> _orderList;
  List<OrderModel> get orderList => _orderList != null ? _orderList.reversed.toList() : _orderList;

  List<OrderModel> _pendingList;
  List<OrderModel> _processing;
  List<OrderModel> _deliveredList;
  List<OrderModel> _returnList;
  List<OrderModel> _canceledList;
  List<OrderModel> _failedList;
  List<OrderModel> _confirmedList;
  List<OrderModel> _outForDeliveryList;
  List<OrderModel> get pendingList => _pendingList != null ? _pendingList.reversed.toList() : _pendingList;
  List<OrderModel> get processing => _processing != null ? _processing.reversed.toList() : _processing;
  List<OrderModel> get deliveredList => _deliveredList != null ? _deliveredList.reversed.toList() : _deliveredList;
  List<OrderModel> get returnList => _returnList != null ? _returnList.reversed.toList() : _returnList;
  List<OrderModel> get canceledList => _canceledList != null ? _canceledList.reversed.toList() : _canceledList;
  List<OrderModel> get confirmedList => _confirmedList != null ? _confirmedList.reversed.toList() : _confirmedList;
  List<OrderModel> get outForDeliveryList => _outForDeliveryList != null ? _outForDeliveryList.reversed.toList() : _outForDeliveryList;
  List<OrderModel> get failedList => _failedList != null ? _failedList.reversed.toList() : _failedList;



  List<OrderDetailsModel> _orderDetails;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  List<String> _orderStatusList = [];
  String _orderStatusType = '';
  List<String> get orderStatusList => _orderStatusList;
  String get orderStatusType => _orderStatusType;

  String _addOrderStatusErrorText;
  String get addOrderStatusErrorText => _addOrderStatusErrorText;

  List<String> _paymentImageList;
  List<String> get paymentImageList => _paymentImageList;

  int _paymentMethodIndex = 0;
  int get paymentMethodIndex => _paymentMethodIndex;

  void setOrderStatusErrorText(String errorText) {
    _addOrderStatusErrorText = errorText;
    notifyListeners();
  }

  Future<ResponseModel> updateOrderStatus(int id, String status) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    ApiResponse apiResponse;
    apiResponse = await orderListRepo.orderStatus(id, status);

    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data.toString();
      int _status = apiResponse.response.data['success'];
      if(_status != null) {
        responseModel = ResponseModel(false, apiResponse.response.data['message']);
        _addOrderStatusErrorText = apiResponse.response.data['message'];

      }else {
        responseModel = ResponseModel(true, message);
        _addOrderStatusErrorText = message;
        _orderDetails[0].deliveryStatus = status;
      }
    } else {
      responseModel = ResponseModel(false, apiResponse.error['message'] ?? apiResponse.error.toString());
    }
    notifyListeners();
    return responseModel;
  }


  Future<void> getOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderListRepo.getOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderList = [];
      _pendingList = [];
      _processing = [];
      _deliveredList = [];
      _returnList = [];
      _canceledList = [];
      _confirmedList = [];
      _outForDeliveryList = [];
      _failedList = [];
      apiResponse.response.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        _orderList.add(orderModel);
        if (orderModel.orderStatus == AppConstants.PENDING) {
          _pendingList.add(orderModel);
        } else if (orderModel.orderStatus == AppConstants.PROCESSING || orderModel.orderStatus == AppConstants.PROCESSED) {
          _processing.add(orderModel);
        }else if (orderModel.orderStatus == AppConstants.DELIVERED) {
          _deliveredList.add(orderModel);
        }else if ( orderModel.orderStatus == AppConstants.RETURNED) {
          _returnList.add(orderModel);
        } else if (orderModel.orderStatus == AppConstants.FAILED) {
          _failedList.add(orderModel);
        }else if (orderModel.orderStatus == AppConstants.CANCELLED) {
          _canceledList.add(orderModel);
        }else if (orderModel.orderStatus == AppConstants.CONFIRMED) {
          _confirmedList.add(orderModel);
        }else if (orderModel.orderStatus == AppConstants.OUT_FOR_DELIVERY) {
          _outForDeliveryList.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  void setIndex(int index) {
    _orderTypeIndex = index;
    notifyListeners();
  }


  Future<List<OrderDetailsModel>> getOrderDetails( String orderID , BuildContext context) async {
    _orderDetails = null;
    _addOrderStatusErrorText = '';
    ApiResponse apiResponse = await orderListRepo.getOrderDetails(orderID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response.data.forEach((order) => _orderDetails.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }


  void initOrderStatusList(BuildContext context, String type) async {
    ApiResponse apiResponse = await orderListRepo.getOrderStatusList(type);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderStatusList.clear();
      _orderStatusList.addAll(apiResponse.response.data);
      _orderStatusType = apiResponse.response.data[0];
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void updateStatus(String value) {
    _orderStatusType = value;
    notifyListeners();
  }

  void setPaymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  bool _selfDelivery = false;
  bool _thirdPartyDelivery = false;
  bool get selfDelivery => _selfDelivery;
  bool get thirdPartyDelivery => _thirdPartyDelivery;

  void deliveryTypeOnOff(BuildContext context, bool isOk, int index) {

    notifyListeners();

  }

}
