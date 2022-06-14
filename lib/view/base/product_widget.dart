import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/add_product_screen.dart';


class ProductWidget extends StatelessWidget {
  final Product productModel;
  ProductWidget({@required this.productModel});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: Stack(
        children: [
          Card(
            child: Column(children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${productModel.thumbnail}',)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productModel.name ?? '', style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(children: [
                              Text(
                                PriceConverter.convertPrice(context, productModel.unitPrice, discountType: productModel.discountType, discount: productModel.discount),
                                style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),
                              ),
                              Expanded(child: SizedBox.shrink()),
                              Text(productModel.rating != null ? productModel.rating.length != 0 ? double.parse(productModel.rating[0].average).toStringAsFixed(1) : '0.0' : '0.0',
                                  style: robotoRegular.copyWith(
                                    color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange,
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                  )),
                              Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange, size: 15),

                              SizedBox(width: Dimensions.FONT_SIZE_DEFAULT),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(product: productModel)));
                                },
                                child: Container( width: 15,height: 15,
                                    child: Image.asset(Images.edit,color: Theme.of(context).primaryColor)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              IconButton(
                                onPressed: (){

                                  showDialog(context: context, builder: (BuildContext context){
                                    return ConfirmationDialog(icon: Images.cross,
                                      refund: false,
                                      description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                                      onYesPressed: () {Provider.of<RestaurantProvider>(context, listen:false).isLoading?
                                        Center(child: CircularProgressIndicator()):Provider.of<RestaurantProvider>(context, listen:false).deleteProduct(context ,productModel.id);
                                      }


                                    );});
                                },
                                  icon: Icon(Icons.delete, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.red, size: 15)),


                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            productModel.discount > 0 ? Text(
                              PriceConverter.convertPrice(context, productModel.unitPrice),
                              style: robotoBold.copyWith(
                                color: Theme.of(context).hintColor,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                              ),
                            ) : SizedBox.shrink(),




                          ],),
                      ),
                    )

                  ],),
              ),

            ],),
          ),
          // Off
          productModel.discount >= 1 ? Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: ColorResources.getPrimary(context),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  PriceConverter.percentageCalculation(context, productModel.unitPrice, productModel.discount, productModel.discountType),
                  style: robotoRegular.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                ),
              ),
            ),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
