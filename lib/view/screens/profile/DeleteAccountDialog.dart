





import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../data/model/body/seller_body.dart';
import '../../../data/model/response/seller_info.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/bank_info_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';


class DeleteAccountDialog extends StatefulWidget {


  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  _deleteUserAccount()async
  {
    SellerModel _bank = Provider.of<BankInfoProvider>(context, listen: false).bankInfo;
    SellerModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    SellerBody _sellerBody = SellerBody(
      sMethod: '_put', fName:  "", lName:"", image: updateUserInfoModel.image,
      bankName: _bank.bankName, branch: _bank.branch, holderName: _bank.holderName, accountNo: _bank.accountNo,
    );
    File file;

    updateUserInfoModel.email="";
    updateUserInfoModel.password="";
    updateUserInfoModel.image="";
    updateUserInfoModel.phone="";
    await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(
      updateUserInfoModel, _sellerBody, null, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
    ).then((response) {
      if(response.isSuccess) {
        Provider.of<ProfileProvider>(context, listen: false).getSellerInfo(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
        setState(() {});
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(getTranslated('want_to_delete_your_account', context), style: robotoBold, textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () async {

            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('YES', context), style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: ColorResources.RED, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('NO', context), style: titilliumBold.copyWith(color: ColorResources.WHITE)),
            ),
          )),

        ]),
      ]),
    );
  }
}
