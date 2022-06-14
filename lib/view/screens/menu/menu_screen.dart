import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/add_product_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/bank_info/bank_info_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/inbox_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/more/html_view_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/profile/profile_view_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/restaurant/shop_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/settings/setting_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/wallet/wallet_screen.dart';

class MenuBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String version = Provider.of<SplashProvider>(context,listen: false).configModel.version != null?Provider.of<SplashProvider>(context,listen: false).configModel.version:'version';
    return  Container(
      height: MediaQuery.of(context).size.width-50,
      decoration: BoxDecoration(
        color: ColorResources.getHomeBg(context),
        borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(25),
            topRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black12,),

          Container(
            height: MediaQuery.of(context).size.width-100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreenView())),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],

                      ),
                      child: Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) =>
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                height: MediaQuery.of(context).size.width/12, width: MediaQuery.of(context).size.width/12,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.WHITE, width: 2)),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                                      placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                                      imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}/${profileProvider.userInfoModel.image}',
                                    height: MediaQuery.of(context).size.width/12, width: MediaQuery.of(context).size.width/12, fit: BoxFit.cover,)
                                ),
                              ),
                              Flexible(
                                child: Center(
                                  child: Text(getTranslated('profile', context),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  CustomBottomSheet(image: Icons.message, title: getTranslated('message', context), widget: InboxScreen()),
                  CustomBottomSheet(image: Icons.monetization_on, title: getTranslated('wallet', context), widget: WalletScreen()),
                  CustomBottomSheet(image: Icons.credit_card, title: getTranslated('bank_info', context), widget: BankInfoScreen()),
                  CustomBottomSheet(image: Icons.home_filled, title: getTranslated('my_shop', context), widget: ShopScreen()),
                  CustomBottomSheet(image: Icons.settings, title: getTranslated('more', context), widget: SettingsScreen()),
                  CustomBottomSheet(image: Icons.confirmation_num, title: getTranslated('terms_and_condition', context), widget: HtmlViewScreen(
                    title: getTranslated('terms_and_condition', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                  )),
                  CustomBottomSheet(image: Icons.account_box, title: getTranslated('about_us', context), widget: HtmlViewScreen(
                    title: getTranslated('about_us', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs,
                  )),
                  CustomBottomSheet(image: Icons.privacy_tip, title: getTranslated('privacy_policy', context), widget: HtmlViewScreen(
                    title: getTranslated('privacy_policy', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy,
                  )),

                  CustomBottomSheet(image: Icons.add, title: getTranslated('add_product', context), widget: AddProductScreen()),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showCupertinoModalPopup(context: context, builder: (_) => SignOutConfirmationDialog());
                    },

                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.logout, height: MediaQuery.of(context).size.width/12,width: MediaQuery.of(context).size.width/12, color: Colors.red),
                            Center(
                              child: Text(
                                getTranslated('logout', context),
                                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorResources.getBottomSheetColor(context),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(getTranslated('app_info', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          Center(
                            child: Text(
                              version, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 6,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
