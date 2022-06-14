import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/settings/widget/language_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/transaction_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('more', context),),
      body: SafeArea( 
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          children: [

            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            TitleButton(
              icon: Icons.language,
              title: getTranslated('choose_language', context),
              onTap: () => showAnimatedDialog(context, LanguageDialog(isCurrency: false, isShipping: false,)),
            ),
            // TitleButton(
            //   icon: Icons.monetization_on,
            //   title: '${getTranslated('currency', context)} (${Provider.of<SplashProvider>(context).myCurrency.name})',
            //   onTap: () => showAnimatedDialog(context, LanguageDialog(isCurrency: true)),
            // ),
            TitleButton(
                icon: Icons.list_alt,
                title: getTranslated('transactions', context),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TransactionScreen()))
            ),
            TitleButton(
              icon: Icons.local_shipping_outlined,
              title: '${getTranslated('shipping_setting', context)}',
              onTap: () => showAnimatedDialog(context, LanguageDialog(isCurrency: false, isShipping: true,)),
            ),
          ],
        ),
      ),
    );
  }

}
class TitleButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  TitleButton({@required this.icon, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ColorResources.getPrimary(context)),
      title: Text(title, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: onTap,
    );
  }
}

