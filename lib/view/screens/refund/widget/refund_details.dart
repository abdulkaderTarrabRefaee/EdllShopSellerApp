import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_details_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/refund_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

import 'image_diaglog.dart';

class RefundDetailScreen extends StatefulWidget {
  final RefundModel refundModel;
  final int orderDetailsId;
  final String variation;
  RefundDetailScreen({@required this.refundModel, @required this.orderDetailsId, this.variation});

  @override
  _RefundDetailScreenState createState() => _RefundDetailScreenState();
}

class _RefundDetailScreenState extends State<RefundDetailScreen> {
  @override
  Widget build(BuildContext context) {
    int count =0;
    final TextEditingController noteController = TextEditingController();
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    Provider.of<RefundProvider>(context, listen: false).getRefundReqInfo(context, widget.orderDetailsId);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: getTranslated('refund_details', context)),
        body: SingleChildScrollView(
          child: Consumer<RefundProvider>(
              builder: (context,refundReq,_) {
                return Padding(
                  padding: mediaQueryData.viewInsets,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              children: [
                                Text('${getTranslated('order_no', context)} : #${widget.refundModel.orderId.toString()}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                                Expanded(child: SizedBox()),
                                Container(
                                  height: 10,
                                  width: 15,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color:widget.refundModel.status == 'approved' ? ColorResources.GREEN : ColorResources.RED),),
                                Text(widget.refundModel.status.toUpperCase(), style: titilliumBold.copyWith(color: widget.refundModel.status == 'approved' ? ColorResources.GREEN : ColorResources.RED, fontSize: 14)),
                              ]
                          ),
                          SizedBox(height: 10),
                          Text('${getTranslated('product_details', context)}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          widget.refundModel.product != null?
                          Row(
                              children: [
                                Container(width: 50, height: 50,
                                  child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                                    image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${widget.refundModel.product.thumbnail}',
                                    width: 50, height: 50, fit: BoxFit.cover,
                                    imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image),
                                  ) ,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${widget.refundModel.product.name.toString()}',maxLines: 2,
                                        overflow: TextOverflow.ellipsis, style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),fontSize: 14),),

                                      (widget.variation != null && widget.variation.isNotEmpty) ?
                                      Padding(
                                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child:  Text('${getTranslated('variations', context)} : '+widget.variation,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                                              color: Theme.of(context).disabledColor,
                                            )),
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ),

                              ]
                          ):Text(getTranslated('product_was_deleted', context)),

                          RichText(
                            text: TextSpan(text: getTranslated('refund_reason', context), style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(text: '${widget.refundModel.refundReason.toString()}', style: TextStyle(fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),

                          widget.refundModel.images != null && widget.refundModel.images.length>0?Text(getTranslated('attachment', context),
                            style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w700),):SizedBox(),

                          widget.refundModel.images != null && widget.refundModel.images.length>0?
                          Container(height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:  widget.refundModel.images.length,
                              itemBuilder: (BuildContext context, index){
                                return   widget.refundModel.images.length > 0?
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () => showDialog(context: context, builder: (ctx)  =>
                                            ImageDialog(imageUrl:'${AppConstants.BASE_URL}/storage/app/public/refund/${widget.refundModel.images[index]}'), ),
                                        child: Container(width: 100, height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                            child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                                              image: '${AppConstants.BASE_URL}/storage/app/public/refund/${widget.refundModel.images[index]}',
                                              width: 100, height: 100, fit: BoxFit.cover,
                                              imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image),
                                            ),
                                          ) ,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):SizedBox();

                              },),
                          ):SizedBox(),

                          Consumer<RefundProvider>(
                              builder: (context, refund,_) {
                                return Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: refund.refundDetailsModel != null?
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(text: getTranslated('product_price', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.productPrice), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('quantity', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: refund.refundDetailsModel.quntity.toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('product_total_discount', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.productTotalDiscount), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('product_total_tax', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.productTotalTax), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('subtotal', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.subtotal), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('coupon_discount', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.couponDiscount), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(text: getTranslated('total_refund_amount', context), style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w300)),
                                              TextSpan(text: PriceConverter.convertPrice(context, refund.refundDetailsModel.refundAmount), style: TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                      ]):SizedBox(),
                                );
                              }
                          ),

                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          // for Customer Details
                          widget.refundModel.customer != null?
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
                                        imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${widget.refundModel.customer.image}',
                                        height: 50,width: 50, fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                  Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${widget.refundModel.customer.fName ?? ''} ${widget.refundModel.customer.lName ?? ''}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 14)),
                                      Text('${getTranslated('email', context)} : ${widget.refundModel.customer.email ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                      Text('${getTranslated('contact', context)} : ${widget.refundModel.customer.phone}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                    ],
                                  ))
                                ],
                              )
                            ]),
                          ):SizedBox(),

                          //deliveryman contact details
                          (refundReq.refundDetailsModel !=null && refundReq.refundDetailsModel.deliverymanDetails != null)?
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(getTranslated('deliveryman_contact_details', context), style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context))),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child:  CachedNetworkImage(
                                        errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                                        placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                                        imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.reviewImageUrl}/delivery-man/${refundReq.refundDetailsModel.deliverymanDetails.image}',
                                        height: 50,width: 50, fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                  Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${refundReq.refundDetailsModel.deliverymanDetails.fName ?? ''} ${refundReq.refundDetailsModel.deliverymanDetails.lName ?? ''}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 14)),
                                      Text('${getTranslated('email', context)} : ${refundReq.refundDetailsModel.deliverymanDetails.email ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                      Text('${getTranslated('contact', context)} : ${refundReq.refundDetailsModel.deliverymanDetails.phone}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                    ],
                                  ))
                                ],
                              )
                            ]),
                          ):SizedBox(),

                          // for change log Details
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          (refundReq.refundDetailsModel != null && refundReq.refundDetailsModel.refundRequest[0].refundStatus != null)?
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('refund_status_change_log', context), style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context))),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              ConstrainedBox(
                                constraints: refundReq.refundDetailsModel.refundRequest[0].refundStatus.length > 0 ? BoxConstraints(maxHeight: 180 * double.parse(refundReq.refundDetailsModel.refundRequest[0].refundStatus.length.toString())):BoxConstraints(maxHeight: 0),
                                child: ListView.builder(

                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: refundReq.refundDetailsModel.refundRequest[0].refundStatus.length,
                                  itemBuilder: (context,index) {
                                    print('========Count======>${count.toString()}');

                                    if(refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].changeBy =="admin"){
                                     count++;
                                    }
                                    return Container(
                                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: ColorResources.getBottomSheetColor(context),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                                      ),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        Text('${getTranslated('status', context)} : ${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].status ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                        Text('${getTranslated('updated_by', context)} : ${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].changeBy ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),
                                        Text('${getTranslated('reason', context)} : ${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].message ?? ''}', style: titilliumSemiBold.copyWith(color: ColorResources.getHintColor(context), fontSize: 12)),

                                      ]),
                                    );
                                  }
                                ),
                              ),
                            ],
                          ):SizedBox(),




                          //approve and reject

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(width: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                                  ),

                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: InkWell(
                                        onTap: (){
                                          if(count > 0){
                                            showCustomSnackBar(getTranslated('you_cant_override_admin_decision', context), context);
                                          }else{
                                            Navigator.pop(context);
                                            refundReq.toggleSendButtonActivity();
                                            showDialog(context: context,barrierDismissible: false, builder: (BuildContext context){
                                              return ConfirmationDialog(icon:  Images.ok_icon,
                                                  description: getTranslated('are_you_sure_want_to_approve', context),
                                                  note: noteController,
                                                  refund: true,
                                                  onYesPressed: () {

                                                    if(noteController.text.trim().isEmpty){
                                                      showCustomSnackBar(getTranslated('note_required', context), context);
                                                    }else{
                                                      refundReq.isLoading?
                                                      Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel.id, 'approved',noteController.text.trim()).then((value) {
                                                        if(value.response.statusCode ==200){
                                                          Provider.of<RefundProvider>(context, listen: false).getRefundList(context);
                                                          Navigator.pop(context);
                                                          noteController.clear();
                                                        }
                                                      });
                                                    }


                                                  }


                                              );});
                                          }






                                        },
                                        child: Text(getTranslated('approve', context),style: TextStyle(color: ColorResources.getTextColor(context)))),
                                  ))),
                              Container(width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                                  ),

                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: InkWell(

                                        onTap: (){
                                       if(count > 0){
                                       showCustomSnackBar(getTranslated('you_cant_override_admin_decision', context), context);
                                       }else{
                                         Navigator.pop(context);
                                         refundReq.toggleSendButtonActivity();
                                         showDialog(context: context, builder: (BuildContext context){
                                           return ConfirmationDialog(icon:  Images.cross,
                                               description: getTranslated('are_you_sure_want_to_reject', context),
                                               note: noteController,
                                               refund: true,
                                               onYesPressed: () {
                                                 if(noteController.text.trim().isEmpty){
                                                   showCustomSnackBar(getTranslated('note_required', context), context);
                                                 }else{
                                                   refundReq.isLoading?
                                                   Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel.id, 'rejected', noteController.text.trim()).then((value) {
                                                     if(value.response.statusCode ==200){
                                                       Provider.of<RefundProvider>(context, listen: false).getRefundList(context);
                                                       Navigator.pop(context);
                                                     }
                                                   });
                                                 }

                                               }


                                           );});
                                       }


                                        },
                                        child: Text(getTranslated('reject', context),style: TextStyle(color: ColorResources.getTextColor(context)))),
                                  ))),


                            ],)
                              // :Center(child: Text(getTranslated('you_cant_override_admin_decision', context),style: TextStyle(color: Colors.red))),


                        ]),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}

