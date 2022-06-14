import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/order_widget.dart';

class OrderScreen extends StatelessWidget {
  final bool isBacButtonExist;
  OrderScreen({this.isBacButtonExist = false});

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderList(context);

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        List<OrderModel> orderList = [];
        if (order.orderTypeIndex == 0) {
          orderList = order.orderList;
        }else if (order.orderTypeIndex == 1) {
          orderList = order.pendingList;
        }else if (order.orderTypeIndex == 2) {
          orderList = order.processing;
        }else if (order.orderTypeIndex == 3) {
          orderList = order.deliveredList;
        }else if (order.orderTypeIndex == 4) {
          orderList = order.returnList;
        }else if (order.orderTypeIndex == 5) {
          orderList = order.failedList;
        }else if (order.orderTypeIndex == 6) {
          orderList = order.canceledList;
        }else if (order.orderTypeIndex == 7) {
          orderList = order.confirmedList;
        }else if (order.orderTypeIndex == 8) {
          orderList = order.outForDeliveryList;
        }
        return Column(
          children: [
            CustomAppBar(title: getTranslated('my_order', context), isBackButtonExist: isBacButtonExist),

            order.pendingList != null
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
              child: SizedBox(
                height: 60,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    OrderTypeButton(text: getTranslated('all', context), index: 0, orderList: order.orderList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('pending', context), index: 1, orderList: order.pendingList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('processing', context), index: 2, orderList: order.processing),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('delivered', context), index: 3, orderList: order.deliveredList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('return', context), index: 4, orderList: order.returnList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('failed', context), index: 5, orderList: order.failedList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('cancelled', context), index: 6, orderList: order.canceledList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('confirmed', context), index: 7, orderList: order.confirmedList),
                    SizedBox(width: 5),
                    OrderTypeButton(text: getTranslated('out_delivery', context), index: 8, orderList: order.outForDeliveryList),




                  ],
                ),
              ),
            )
                : SizedBox(),
            order.pendingList != null
                ? Expanded(
              child: RefreshIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                onRefresh: () async {
                  await order.getOrderList(context);
                },
                child: ListView.builder(
                  itemCount: orderList.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) => OrderWidget(orderModel: orderList[index]),
                ),
              ),
            ) : Expanded(child: OrderShimmer()),
          ],
        );
      },
      ),
    );
  }
}

class OrderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).highlightColor,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 150, color: ColorResources.WHITE),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Container(height: 45, color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(height: 20, color: ColorResources.WHITE),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(height: 10, width: 70, color: Colors.white),
                              SizedBox(width: 10),
                              Container(height: 10, width: 20, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrderTypeButton extends StatelessWidget {
  final String text;
  final int index;
  final List<OrderModel> orderList;
  OrderTypeButton({@required this.text, @required this.index, @required this.orderList});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Provider.of<OrderProvider>(context, listen: false).setIndex(index),
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Consumer<OrderProvider>(builder: (context, order, child) {
        return Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: order.orderTypeIndex == index ? ColorResources.getPrimary(context) : Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(text,
              style: titilliumBold.copyWith(color: order.orderTypeIndex == index
                  ? Theme.of(context).highlightColor : ColorResources.getPrimary(context))),
        );
      },
      ),
    );
  }
}
