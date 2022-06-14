import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/business_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/confirmation_dialog.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_shipping_method.dart';
import 'package:sixvalley_vendor_app/view/screens/settings/business_setting_details.dart';

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<BusinessProvider>(context, listen: false).getBusinessList(context);
    Provider.of<ShippingProvider>(context, listen: false).getShippingList(context,Provider.of<AuthProvider>(context,listen: false).getUserToken());

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('business_settings', context)),
      body: SafeArea(
        child: Consumer<ShippingProvider>(
          builder: (context, shipProv, child) => Column(
            children: [

              shipProv.shippingList !=null ? shipProv.shippingList.length > 0 ? Expanded(
                  child: ListView.builder(
                    itemCount: shipProv.shippingList.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShippingMethodScreen(shipping: shipProv.shippingList[index])));
                      },child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                        margin: EdgeInsets.all( Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                        ),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                              Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                                Text('Title : ${shipProv.shippingList[index].title}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${PriceConverter.convertPrice(context, shipProv.shippingList[index].cost)}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 11)),
                                  SizedBox(width: 10,),
                                    Icon(Icons.access_time_sharp, color: Colors.grey,size: 12,),
                                    SizedBox(width: 5,),
                                    Text('${shipProv.shippingList[index].duration}days', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_SMALL)),

                                  ],
                                ),
                              ],),
                                Row(children: [
                                  IconButton(
                                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => ShippingMethodScreen(shipping: shipProv.shippingList[index]))),
                                    icon: Icon(Icons.edit,color: Colors.green,),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  IconButton(
                                    onPressed: (){
                                      showDialog(context: context, builder: (BuildContext context){
                                        return ConfirmationDialog(icon: Images.cross,
                                            description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                                            onYesPressed: () {Provider.of<ShippingProvider>(context, listen:false).deleteShipping(context ,shipProv.shippingList[index].id);
                                            }

                                        );});
                                    },
                                      icon: Icon(Icons.delete,color: Colors.red,))


                                ],)



                            ],),
                          ],
                        ),
                      ),
                    ),
                  ))
                  : NoShippingDataScreen()
                  : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ShippingMethodScreen()));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(Images.add_btn),
        ),),
    );
  }
}
