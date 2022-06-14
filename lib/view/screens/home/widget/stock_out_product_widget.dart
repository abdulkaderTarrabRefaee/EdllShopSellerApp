
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/localization_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/view/base/product_shimmer.dart';
import 'package:sixvalley_vendor_app/view/base/product_widget.dart';
import 'package:sixvalley_vendor_app/view/base/title_row.dart';
import 'package:sixvalley_vendor_app/view/screens/stockOut/stock_out_product_screen.dart';


class StockOutProductView extends StatelessWidget {
  final bool isHome;
  StockOutProductView({@required this.isHome});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).stockOutProductList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        pageSize = (Provider.of<ProductProvider>(context, listen: false).stockOutProductPageSize/10).ceil();

        if(Provider.of<ProductProvider>(context, listen: false).offset < pageSize) {
          Provider.of<ProductProvider>(context, listen: false).setOffset(Provider.of<ProductProvider>(context, listen: false).offset+1);
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();

          Provider.of<ProductProvider>(context, listen: false).getStockOutProductList(
              Provider.of<ProductProvider>(context, listen: false).offset, context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode == 'US'?'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase());

        }
      }
    });


    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.stockOutProductList;


        return SingleChildScrollView(
          controller: scrollController,
          child: Column(children: [
            isHome?Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: TitleRow(title: getTranslated('stock_out_product', context), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StockOutProductScreen()))),
            ):SizedBox(),
            !prodProvider.firstLoading ? productList.length != 0 ? ListView.builder(
              itemCount: isHome && productList.length>0?1: productList.length,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(productModel: productList[index]);
              },
            ) : SizedBox.shrink() : ProductShimmer(isEnabled: prodProvider.firstLoading),

            prodProvider.isLoading ? Center(child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : SizedBox.shrink(),

          ]),
        );
      },
    );
  }
}


