import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/provider/transaction_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_edit_dialog.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/transaction_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/widget/transaction_widget.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionProvider>(context, listen: false).getTransactionList(context);
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('wallet', context)),
      body: SafeArea(
        child: Container(
          child: Column(children: [
            Consumer<ProfileProvider>(
              builder: (context, seller, child) {
                return seller.userInfoModel !=null ? SizedBox(
                    height: 410,
                    child: Column(
                      children: [
                        Container(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 900 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                          ),
                          child: Row(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset(Images.wallet)),
                              SizedBox(width: 15),
                              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('balance_withdraw', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.totalEarning ?? 0 : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),

                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () => showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context, builder: (_) => CustomEditDialog()),
                                child: Text(getTranslated('withdraw', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                              ),
                              Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white,)
                            ],
                          ),
                        ) ,
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Row(children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-10,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: 10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF00A3FF),
                                  Color(0xFF00E8F6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.withdrawn : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  Text(getTranslated('withdrawn', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-20,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            // margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: ColorResources.SELLER_TXT,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.pendingWithdraw : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),

                                  Text(getTranslated('pending_withdrawn', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),

                                ],
                              ),
                            ),
                          ),

                        ],),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Row(children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-10,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: 10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF00A3FF),
                                  Color(0xFF00E8F6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.commissionGiven : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  Text(getTranslated('commission_given', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-20,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            // margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: ColorResources.SELLER_TXT,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.deliveryChargeEarned : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),

                                  Text(getTranslated('delivery_charge_earned', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),

                                ],
                              ),
                            ),
                          ),

                        ],),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Row(children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-10,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: 10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF00A3FF),
                                  Color(0xFF00E8F6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.collectedCash : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  Text(getTranslated('collected_cash', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width/2-20,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            // margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: ColorResources.SELLER_TXT,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                            ),
                            child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(PriceConverter.convertPrice(context, seller.userInfoModel.wallet != null ? seller.userInfoModel.wallet.totalTaxCollected : 0),
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white,fontSize: Dimensions.FONT_SIZE_LARGE)),

                                  Text(getTranslated('total_collected_tax', context), style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),

                                ],
                              ),
                            ),
                          ),

                        ],),

                      ],

                    )
                )
                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
              },

            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Text(getTranslated('withdraw_history', context), style: TextStyle(fontSize: Dimensions.FONT_SIZE_LARGE,fontWeight: FontWeight.w400,color: ColorResources.getTextColor(context)),),
                Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionScreen()));
                  },
                    child: Text(getTranslated('view_all', context),style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT,fontWeight: FontWeight.w400,color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,))),

              ],),
            ),

            Expanded(
              child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) =>Container(

                  child: transactionProvider.transactionList !=null ? transactionProvider.transactionList.length > 0 ? ListView.builder(
                    itemCount: transactionProvider.transactionList.length,
                    itemBuilder: (context, index) => TransactionWidget(transactionModel: transactionProvider.transactionList[index]),
                  ) : NoDataScreen()
                      : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),


              ),
            ),


          ],),
        ),
      ),

    );

  }
}
