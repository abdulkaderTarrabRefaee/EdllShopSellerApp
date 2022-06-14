import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/screens/profile/profile_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/settings/business_setting.dart';
import 'package:sixvalley_vendor_app/view/screens/shipping/category_wise_shipping.dart';

class ProfileScreenView extends StatefulWidget {
  @override
  _ProfileScreenViewState createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {



  @override
  void initState() {
    super.initState();
    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
      Provider.of<ProfileProvider>(context, listen: false).getSellerInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [

              Image.asset(
                Images.toolbar_background, fit: BoxFit.fill, height: 500,
                color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
              ),
              Container(
                padding: EdgeInsets.only(top: 35, left: 15),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: ColorResources.getBottomSheetColor(context),
                  ),
                  SizedBox(width: 10),
                  Text(getTranslated('my_profile', context), style: robotoTitleRegular.copyWith(fontSize: 20, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),


              Container(
                padding: EdgeInsets.only(top: 55),
                child: Column(
                  children: [

                    SizedBox(height: 100,),


                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                              topRight: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(height: 70,),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2-20,
                                    height: 93,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      Text(profile.userInfoModel.productCount.toString(),
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_TWENTY,color: Theme.of(context).primaryColor, fontFamily: 'Roboto')),
                                     SizedBox(height: 5),
                                      Text(getTranslated('total_products', context),
                                        style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT,fontWeight: FontWeight.w300,color: Color(0xFFB5B5B5), fontFamily: 'Roboto'),
                                ),
                                    ],),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2-20,
                                    height: 93,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                      Text(profile.userInfoModel.ordersCount.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_TWENTY,color: Theme.of(context).primaryColor, fontFamily: 'Roboto'),),
                                        SizedBox(height: 5),
                                      Text(getTranslated('total_order', context),
                                        style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT,fontWeight: FontWeight.w300,color: Color(0xFFB5B5B5), fontFamily: 'Roboto'),),
                                    ],),
                                  ),
                                ),
                              ],),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 15,
                                          height: 15,
                                          child: Image.asset(Images.dark)),
                                    SizedBox(width: 3,),
                                    Text(getTranslated('dark_theme', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Expanded(child: SizedBox()),
                                    FlutterSwitch(
                                      width: 50.0,
                                      height: 25.0,
                                      toggleSize: 30.0,
                                      value: Provider.of<ThemeProvider>(context).darkTheme,
                                      borderRadius: 10.0,
                                      activeColor: Theme.of(context).primaryColor,
                                      padding: 1.0,
                                      activeIcon: Image.asset(Images.dark_mode, width: 30,height: 30, fit: BoxFit.scaleDown),
                                      inactiveIcon: Image.asset(Images.light_mode, width: 30,height: 30,fit: BoxFit.scaleDown,),
                                      onToggle:(bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                                    ),
                                  ],),
                                ),

                              ),),
                            ),

                            InkWell(
                              onTap: (){
                                if(Provider.of<ShippingProvider>(context, listen: false).selectedShippingType == "category_wise"){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CategoryWiseShippingScreen()));
                                }else if(Provider.of<ShippingProvider>(context, listen: false).selectedShippingType == "order_wise"){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BusinessScreen()));
                                }else{
                                  showCustomSnackBar(getTranslated('selected_product_wise_shipping', context), context,isError: false);
                                }

                              },

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(child: Container(
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: 15,
                                              height: 15,
                                              child: Image.asset(Images.box)),
                                          SizedBox(width: 3,),
                                          Text(getTranslated('shipping_method', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                        ],),
                                    ),
                                  ],),

                                ),),
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context, builder: (_) => ProfileScreen());
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreenView()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(child: Container(
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: 15,
                                              height: 15,
                                              child: Image.asset(Images.edit)),
                                          SizedBox(width: 3,),
                                          Text(getTranslated('edit_profile', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),



                                        ],),
                                    ),
                                  ],),

                                ),),
                              ),
                            ),



                            // for Phone No

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(
                top: 70,
                left: 0,right: 0,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CachedNetworkImage(
                              errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}/${profile.userInfoModel.image}',
                            ),


                          ],
                        ),
                      ),
                    ),
                    Text(
                      '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}',
                      style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 20.0),
                    )
                  ],
                ),),
            ],
          );
        },
      ),
    );
  }
}
