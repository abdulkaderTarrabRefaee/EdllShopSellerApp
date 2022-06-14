import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class OrderTypeButtonHead extends StatelessWidget {
  final String text;
  final String subText;
  final Color color;
  final int index;
  final Function callback;
  final List<OrderModel> orderList;
  OrderTypeButtonHead({@required this.text,this.subText,this.color ,@required this.index, @required this.callback, @required this.orderList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<OrderProvider>(context, listen: false).setIndex(index);
        callback();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),),
        color: color,
        child: Container(
          alignment: Alignment.center,
          width: 120,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(orderList.length.toString(),
                  style: robotoBold.copyWith(color: ColorResources.getWhite(context), fontSize: Dimensions.FONT_SIZE_HEADER_LARGE)),

              Text(text,
                  style: robotoRegular.copyWith(color: ColorResources.getWhite(context),fontSize: Dimensions.FONT_SIZE_MAX_LARGE)),
              SizedBox(height: 5),
              Text(subText,
                  style: robotoRegular.copyWith(color: ColorResources.getWhite(context))),


            ],
          ),
        ),
      ),
    );
  }
}
