import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/refund_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/order/order_details_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/refund/widget/refund_details.dart';

class RefundWidget extends StatelessWidget {
  final RefundModel refundModel;
  RefundWidget({@required this.refundModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RefundDetailScreen(
          refundModel: refundModel, orderDetailsId: refundModel.orderDetailsId, variation: refundModel.orderDetails.variant))),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: ColorResources.getBottomSheetColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: .3)],
        ),
        child: refundModel != null?
        Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Text('${getTranslated('refund_no', context)} : ${refundModel.id.toString()}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                  SizedBox(width : 10),
                  Text('${getTranslated('order_no', context)} : ${refundModel.orderId.toString()}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                  Expanded(child: SizedBox()),
                  Container(
                    height: 10,
                    width: 15,
                    decoration: BoxDecoration(shape: BoxShape.circle, color:refundModel.status == 'approved' ? ColorResources.GREEN : ColorResources.RED),),
                  Text(refundModel.status.toUpperCase(), style: titilliumBold.copyWith(color: refundModel.status == 'approved' ? ColorResources.GREEN : ColorResources.RED, fontSize: 14)),
                ]
            ),
            SizedBox(height: 10),

            refundModel.product != null?
            Row(
                children: [
                  Expanded(child: Text('${refundModel.product.name.toString()}',maxLines: 2,overflow: TextOverflow.ellipsis, style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(width: 50, height: 50,
                    child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${refundModel.product.thumbnail}',
                      width: 50, height: 50, fit: BoxFit.cover,
                      imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image),
                    ) ,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),

                ]
            ):Text(getTranslated('product_was_deleted', context)),
            Divider(),


            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(refundModel.createdAt)), style: titilliumSemiBold),
                ),
                Expanded(child: SizedBox()),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: Text('${getTranslated('view_details', context)}',
                      style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context),fontSize: 12)),
                ),
                Icon(Icons.arrow_forward_outlined, color: Theme.of(context).primaryColor)
              ],
            )
          ],
        ):SizedBox(),
      ),
    );
  }
}
