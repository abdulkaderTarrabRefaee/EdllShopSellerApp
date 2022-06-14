import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/bank_info/bank_editing_screen.dart';

class BankInfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Provider.of<BankInfoProvider>(context, listen: false).getBankInfo(context);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('bank_info', context)),
      body: SafeArea(
        child: Container(
          child: Consumer<BankInfoProvider>(
            builder: (context, bankProvider, child) => bankProvider.bankInfo != null ? Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
              ),
              child: Column( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(width: 15, height: 15, child: Image.asset(Images.bank)),
                    SizedBox(width: 5),
                    Text(
                      '${getTranslated('bank_name', context)} : \t',
                      style: titilliumRegular.copyWith(color: ColorResources.getHint(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    Text(
                      '${bankProvider.bankInfo.bankName ?? getTranslated('no_data_found', context)}',
                      style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  Row(children: [
                    Container(width: 15, height: 15, child: Image.asset(Images.branch)),
                    SizedBox(width: 5),
                    Text(
                      '${getTranslated('branch_name', context)} : \t',
                      style: titilliumRegular.copyWith(color: ColorResources.getHint(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    Text(
                      '${bankProvider.bankInfo.branch ?? getTranslated('no_data_found', context)}',
                      style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  Row(children: [
                    Container(width: 15, height: 15, child: Image.asset(Images.holder)),
                    SizedBox(width: 5),
                    Text(
                      '${getTranslated('holder_name', context)} : \t',
                      style: titilliumRegular.copyWith(color: ColorResources.getHint(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    Text(
                      '${bankProvider.bankInfo.holderName ?? getTranslated('no_data_found', context)}',
                      style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  Row(children: [
                    Container(width: 15, height: 15, child: Image.asset(Images.credit_card)),
                    SizedBox(width: 5),
                    Text(
                      '${getTranslated('account_no', context)} : \t',
                      style: titilliumRegular.copyWith(color: ColorResources.getHint(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${bankProvider.bankInfo.accountNo ?? getTranslated('no_data_found', context)}',
                      style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  SizedBox(height: 10),
                  CustomButton(
                    btnTxt: getTranslated('edit', context),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BankEditingScreen(sellerModel: bankProvider.bankInfo))),
                  ),
                ],
              ),
            ) : NoDataScreen(),
          ),
        ),
      ),
    );
  }
}
