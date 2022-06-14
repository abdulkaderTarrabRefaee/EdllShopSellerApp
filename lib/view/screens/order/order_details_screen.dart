import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';


class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  final String orderType;
  final String shippingType;
  final double extraDiscount;
  final String extraDiscountType;
  OrderDetailsScreen({this.orderModel, @required this.orderId, @required this.orderType, this.shippingType, this.extraDiscount, this.extraDiscountType});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  void _loadData(BuildContext context, String type) async {
    if(widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(widget.orderId.toString(), context);
    Provider.of<OrderProvider>(context, listen: false).initOrderStatusList(context, widget.shippingType);
    Provider.of<DeliveryManProvider>(context, listen: false).getDeliveryManList(widget.orderModel, context);
  }

  TextEditingController _thirdPartyShippingNameController = TextEditingController();

  TextEditingController _thirdPartyShippingIdController = TextEditingController();

  FocusNode _thirdPartyShippingNameNode = FocusNode();

  FocusNode _thirdPartyShippingIdNode = FocusNode();
  String deliveryType = 'select delivery type';

  @override
  void initState() {
    if(widget.orderModel.thirdPartyServiceName!=null){
      _thirdPartyShippingNameController.text = widget.orderModel.thirdPartyServiceName;
    }
    if(widget.orderModel.thirdPartyTrackingId!=null){
      _thirdPartyShippingIdController.text = widget.orderModel.thirdPartyTrackingId;
    }
   print('====Dhakaaaaaaa=====>${widget.orderModel.deliveryType}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _loadData(context,widget.shippingType);
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('order_details', context)),
      backgroundColor: ColorResources.getHomeBg(context),
      body: Consumer<OrderProvider>(
          builder: (context, order, child) {

            double _itemsPrice = 0;
            double _discount = 0;
            double eeDiscount = 0;
            double _coupon = widget.orderModel.discountAmount;
            double _tax = 0;
            double _shipping = widget.orderModel.shippingCost;
            if (order.orderDetails != null) {
              order.orderDetails.forEach((orderDetails) {
                _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.qty);
                _discount = _discount + orderDetails.discount;
                _tax = _tax + orderDetails.tax ;
              });
            }
            double _subTotal = _itemsPrice +_tax - _discount;

            if(widget.orderType == 'POS'){
              if(widget.extraDiscountType == 'percent'){
                eeDiscount = _itemsPrice * (widget.extraDiscount/100);
              }else{
                eeDiscount = widget.extraDiscount;
              }
            }
            double _totalPrice = _subTotal + _shipping - _coupon - eeDiscount;

            return order.orderDetails != null ? order.orderDetails.length > 0 ? ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              children: [

                // for details
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                  ),
                  child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

                    //assign delivery man

                    Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping'?


                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal:Dimensions.FONT_SIZE_EXTRA_SMALL ),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200],
                                spreadRadius: 2,blurRadius: 5,offset: Offset(0, 5))],),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(getTranslated('shipping_info', context), style: robotoBold,),
                            Container(child: DropdownButton<String>(
                              value: deliveryType,
                              underline: SizedBox(),
                              onChanged: (String newValue) {
                                setState(() {
                                  deliveryType = newValue;
                                  print('==========selected type===>${deliveryType.toString()}');
                                });
                              },
                              items: <String>['select delivery type', getTranslated('by_self_delivery_man', context),getTranslated('by_third_party_delivery_service', context)]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                            ),


                          ],),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        CustomDivider(),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        deliveryType == getTranslated('by_self_delivery_man', context) || widget.orderModel.deliveryType == 'self_delivery'?
                        Padding(padding: const EdgeInsets.only(bottom: 20.0),
                          child: widget.orderType == 'POS'? SizedBox(): Consumer<DeliveryManProvider>(builder: (context, deliveryMan, child) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, right: Dimensions.PADDING_SIZE_DEFAULT,),
                                    decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1), // changes position of shadow
                                      )],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: DropdownButtonFormField<int>(
                                      value: deliveryMan.deliveryManIndex,
                                      isExpanded: true,
                                      icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor), decoration: InputDecoration(border: InputBorder.none), iconSize: 24, elevation: 16, style: titilliumRegular,
                                      items: deliveryMan.deliveryManIds.map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: deliveryMan.deliveryManIds.indexOf(value),
                                         child: Text(value != 0? '${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].fName} ${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].lName}': getTranslated('select_delivery_man', context),style: TextStyle(color: ColorResources.getTextColor(context)),),
                                        );
                                      }).toList(),
                                      onChanged: (int value) {
                                        deliveryMan.setDeliverymanIndex(value, true);
                                        deliveryMan.assignDeliveryMan(context,widget.orderId, deliveryMan.deliveryManList[value-1].id);
                                        debugPrint('==========deliveryman id====>$value  ====>${deliveryMan.deliveryManList[value-1].id}');
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        )
                        :deliveryType == 'By third party delivery service' || widget.orderModel.deliveryType == "third_party_delivery"?
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(child: Row(
                                children: [
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getTranslated('third_party_delivery_service', context),
                                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          controller: _thirdPartyShippingNameController,
                                          focusNode: _thirdPartyShippingNameNode,
                                          nextNode: _thirdPartyShippingIdNode,
                                          textInputAction: TextInputAction.next,
                                          textInputType: TextInputType.name,
                                          isAmount: false,
                                          // isAmount: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getTranslated('third_party_delivery_tracking_id', context),
                                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          controller: _thirdPartyShippingIdController,
                                          focusNode: _thirdPartyShippingIdNode,
                                          textInputAction: TextInputAction.done,
                                          textInputType: TextInputType.text,
                                          isAmount: false,
                                          // isAmount: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),),

                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Consumer<ShippingProvider>(
                                builder: (context, shipping,_) {
                                  return Container( width: 50,
                                    child: CustomButton(btnTxt: getTranslated('add', context), onTap: (){
                                      String serviceName =_thirdPartyShippingNameController.text.trim().toString();
                                      String trackingId =_thirdPartyShippingIdController.text.trim().toString();
                                      if(serviceName.isEmpty){
                                        showCustomSnackBar(getTranslated('delivery_service_provider_name_required',context), context);
                                      }
                                      else{
                                        shipping.isLoading? CircularProgressIndicator(color: Theme.of(context).primaryColor)
                                        :Provider.of<ShippingProvider>(context,listen: false).assignThirdPartyDeliveryMan(context, serviceName, trackingId, widget.orderModel.id);
                                      }
                                    },),
                                  );
                                }
                              )
                            ],
                          ),
                        ):SizedBox(),
                      ],
                    ):SizedBox(),



                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${getTranslated('order_no', context)} : #${widget.orderModel.id}', style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(color: ColorResources.getFloatingBtn(context),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(widget.orderModel.orderStatus.toUpperCase(), style: titilliumSemiBold),
                          ),
                        ]
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text( '${getTranslated('payment_method', context)}:', style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                        SizedBox(width: 5),

                        Text(
                          (widget.orderModel.paymentMethod != null && widget.orderModel.paymentMethod.length > 0)
                              ? '${widget.orderModel.paymentMethod[0].toUpperCase()}${widget.orderModel.paymentMethod.substring(1).replaceAll('_', ' ')}'
                              : 'Digital Payment', style: titilliumSemiBold.copyWith(color: ColorResources.getBlue(context),fontSize: 14),
                        ),

                        Expanded(child: SizedBox()),

                        Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.orderModel.createdAt)),
                            style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context),fontSize: Dimensions.FONT_SIZE_SMALL)),

                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(getTranslated('payment_status', context), style: titilliumSemiBold.copyWith(fontSize: 12),),
                       Expanded(child: SizedBox()),
                        Container(height: 10, width: 15,
                          decoration: BoxDecoration(shape: BoxShape.circle, color:widget.orderModel.paymentStatus == 'paid' ? ColorResources.GREEN : ColorResources.RED),),
                        Text(widget.orderModel.paymentStatus.toUpperCase(), style: titilliumBold.copyWith(color: widget.orderModel.paymentStatus == 'paid' ? ColorResources.GREEN : ColorResources.RED, fontSize: 14)),

                      ],
                    )
                  ]),
                ),



                // for product view
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.orderDetails.length,
                      itemBuilder: (context, index) {

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 70,
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image),
                                      placeholder: Images.placeholder_image,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${order.orderDetails[index].productDetails.thumbnail}',
                                        height: 70, width: 80, fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                Expanded(
                                  child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                    Text(order.orderDetails[index].productDetails.name, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getPrimary(context)), maxLines: 2, overflow: TextOverflow.ellipsis,),

                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,   children: [

                                      Text(
                                        PriceConverter.convertPrice(context, order.orderDetails[index].productDetails.unitPrice.toDouble()),
                                        style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor),
                                      ),

                                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                      Text(' x ${order.orderDetails[index].qty}', style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context))),
                                      order.orderDetails[index].productDetails.discount > 0 && order.orderDetails[index].productDetails.discount!= null  ?
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                          border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            PriceConverter.percentageCalculation(context, order.orderDetails[index].productDetails.unitPrice.toDouble(),order.orderDetails[index].discount, order.orderDetails[index].discountType),
                                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                      ):SizedBox(),

                                    ],),


                                    (order.orderDetails[index].variant != null && order.orderDetails[index].variant.isNotEmpty) ? Padding(
                                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Row(children: [
                                        Text('${getTranslated('variations', context)} : ', style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                        Text(order.orderDetails[index].variant, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor,
                                        )),
                                      ]),
                                    ) : SizedBox(),
                                  ],),
                                ),



                              ],
                            ),
                            Divider(),

                            SizedBox(height: 10),



                          ],
                        );
                      },
                    ),


                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                    // Total
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('sub_total', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text(PriceConverter.convertPrice(context, _itemsPrice), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('tax', context),  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),


                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('discount', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text('(-) ${PriceConverter.convertPrice(context, _discount)}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),
                    widget.orderType == "POS"?
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('extra_discount', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text('(-) ${PriceConverter.convertPrice(context, eeDiscount)}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]):SizedBox(),

                    // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //   Text(getTranslated('sub_total', context),  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    //   Text(PriceConverter.convertPrice(context, _subTotal), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    //
                    // ]),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('coupon_discount', context),  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text('(-) ${PriceConverter.convertPrice(context, _coupon)}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('shipping_fee', context),  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text('(+) ${PriceConverter.convertPrice(context, _shipping)}', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),
                    Divider(),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('total_amount', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor)),
                      Text(PriceConverter.convertPrice(context, _totalPrice), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                      ),
                    ]),

                  ]),
                ),


                // for address
                widget.orderType == 'POS'?Container(
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('shipping_address', context), style: titilliumSemiBold.copyWith(fontSize: 14)),
                    Text('${getTranslated('name', context)} : ${widget.orderModel.customer != null?widget.orderModel.customer.fName ?? '':""} ${widget.orderModel.customer != null?widget.orderModel.customer.lName ?? '':""}', style: titilliumRegular,),
                    Text('${getTranslated('address', context)} : ${widget.orderModel.shippingAddressData != null ? jsonDecode(widget.orderModel.shippingAddressData)['address'] : widget.orderModel.shippingAddress ?? ''}', style: titilliumRegular),
                    Text('${getTranslated('billing_address', context)} : ${widget.orderModel.billingAddressData != null ? widget.orderModel.billingAddressData.address : widget.orderModel.billingAddress ?? ''}', style: titilliumRegular),
                    Text('${getTranslated('phone', context)} : ${widget.orderModel.customer != null?widget.orderModel.customer.phone ?? '':""}', style: titilliumRegular),
                    Text('${getTranslated('order_note', context)} : ${widget.orderModel.orderNote != null?widget.orderModel.orderNote ?? '': ""}', style: titilliumRegular),

                  ]),
                ):SizedBox(),



                // for Customer Details
                widget.orderModel.customer != null?
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('customer_contact_details', context), style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context))),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${widget.orderModel.customer.image}',
                              height: 50,width: 50, fit: BoxFit.cover),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.orderModel.customer.fName ?? ''} ${widget.orderModel.customer.lName ?? ''}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 14)),
                            Text('${getTranslated('email', context)} : ${widget.orderModel.customer.email ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                            Text('${getTranslated('contact', context)} : ${widget.orderModel.customer.phone}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                          ],
                        ))
                      ],
                    )
                  ]),
                ):SizedBox(),

                (order.addOrderStatusErrorText != null && order.addOrderStatusErrorText.isNotEmpty) ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(order.addOrderStatusErrorText, style: titilliumRegular.copyWith(color: order.addOrderStatusErrorText.contains('updated') ? Colors.green : Colors.red),),
                ) : SizedBox(),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                order.isLoading
                    ? Center(child: CircularProgressIndicator(key: Key(''), valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                    : Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.orderType =='POS'? SizedBox():
                  Consumer<OrderProvider>(builder: (context, order, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, right: Dimensions.PADDING_SIZE_DEFAULT,),
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1), // changes position of shadow
                                )
                              ],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: DropdownButtonFormField<String>(
                              value: order.orderStatusType,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                              decoration: InputDecoration(border: InputBorder.none),
                              iconSize: 24, elevation: 16, style: titilliumRegular,
                              //underline: SizedBox(),

                              onChanged: order.updateStatus,
                              items: order.orderStatusList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),


                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                              onTap: () async {
                                if(Provider.of<OrderProvider>(context, listen: false).orderStatusType == Provider.of<OrderProvider>(context, listen: false).orderStatusList[0]) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_order_type', context)), backgroundColor: Colors.red,));
                                }else {
                                  Provider.of<OrderProvider>(context, listen: false).setOrderStatusErrorText('');
                                  List<int> _productIds = [];
                                  order.orderDetails.forEach((orderDetails) {
                                    _productIds.add(orderDetails.id);
                                  });
                                  await Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(
                                    widget.orderModel.id, Provider.of<OrderProvider>(context, listen: false).orderStatusType,
                                  );
                                }

                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: ColorResources.getSellerTxt(context),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(getTranslated('submit', context)))),
                        ),
                      ],
                    );
                  }),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE)

              ],
            ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          }
      ),
    );
  }
}
