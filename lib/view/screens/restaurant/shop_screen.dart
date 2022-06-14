import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/localization_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_review_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shop_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/restaurant/shop_update_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/restaurant/widget/all_product_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/review/product_review_screen.dart';

class ShopScreen extends StatefulWidget {
  final int initialPage;

  ShopScreen({this.initialPage = 0});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String sellerId = '0';
  Future<void> _loadData(BuildContext context, bool reload) async {
    String languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode == 'US'?'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, 1, context, languageCode, reload: true);
    await Provider.of<ProductReviewProvider>(context, listen: false).getReviewList( context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ShopProvider>(context, listen: false).selectedIndex;
    sellerId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString();
    _loadData(context, false);
    PageController _pageController = PageController(initialPage: widget.initialPage);
    Provider.of<ShopProvider>(context, listen: false).getShopInfo(context);
    return Scaffold(
      // appBar: CustomAppBar(title:''),
        body: SafeArea(
            child: Consumer<ShopProvider>(
                builder: (context, resProvider, child) {
                  return resProvider.shopModel !=null ? resProvider.shopModel != null ? Container(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20))
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width/2.5,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                                      errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,),
                                      imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.shopImageUrl}/banner/${resProvider.shopModel.banner}',),
                                  ),
                                ),
                              ),


                              InkWell(
                                onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ShopUpdateScreen())),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:14.0, right: 14),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(width: 25,height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: Theme.of(context).primaryColor
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.asset(Images.edit,color: Colors.white,),
                                        )),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: ()=> Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Icon(Icons.arrow_back_ios_rounded),
                                ),
                              ),

                            ],

                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  width: 70,
                                  height: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CachedNetworkImage(
                                        placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                                        errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,),
                                        imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.shopImageUrl}/${resProvider.shopModel.image}',),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Flexible(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${resProvider.shopModel.name ?? ''}',
                                        style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                      ),
                                      Text(
                                        '${resProvider.shopModel.address ?? ''}',
                                        style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2, overflow: TextOverflow.ellipsis,softWrap: false,
                                      ),

                                      Row(children: [
                                        Container(
                                            width: 16,
                                            height: 16,
                                            child: Image.asset(Images.star)),
                                        SizedBox(width: 5,),
                                        Text('${resProvider.shopModel.ratting ?? ''}', style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                                        SizedBox(width: 5,),
                                        Text('${resProvider.shopModel.rattingCount ?? ''}',style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),),
                                        SizedBox(width: 5,),
                                        Text(getTranslated('ratting', context),style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),)
                                      ],)

                                    ],),
                                )

                              ],),
                          ),
                          // for decision making section like All product or Product review section
                          Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  left: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    //margin: EdgeInsets.only(right: Dimensions.FONT_SIZE_LARGE),
                                    height: 1,
                                    color: ColorResources.getGainsBoro(context),
                                  ),
                                ),
                                Consumer<ShopProvider>(
                                  builder: (context,authProvider,child)=>Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                        child: Column(
                                          children: [
                                            Text(getTranslated('all_products', context), style: authProvider.selectedIndex == 0 ? titilliumSemiBold : titilliumRegular),
                                            Container(
                                              height: 1,
                                              width: MediaQuery.of(context).size.width/2-30,
                                              margin: EdgeInsets.only(top: 8),
                                              color: authProvider.selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 25),
                                      InkWell(
                                        onTap: () => _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                        child: Column(
                                          children: [
                                            Text(getTranslated('product_review', context), style: authProvider.selectedIndex == 1 ? robotoTitleRegular : robotoRegular),
                                            Container(
                                                height: 1,
                                                width: MediaQuery.of(context).size.width/2-30,
                                                margin: EdgeInsets.only(top: 8),
                                                color: authProvider.selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Consumer<ShopProvider>(
                              builder: (context,shopProvider,child)=>PageView.builder(
                                itemCount: 2,
                                controller: _pageController,
                                itemBuilder: (context, index) {
                                  if (shopProvider.selectedIndex == 0) {
                                    return ProductView(sellerId: shopProvider.shopModel.id);
                                  } else {
                                    return ProductReview();
                                  }
                                },
                                onPageChanged: (index) {
                                  shopProvider.updateSelectedIndex(index);
                                },
                              ),
                            ),
                          ),
                        ],
                      )

                  )
                      : NoDataScreen()
                      : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                })
        )
    );
  }
}

