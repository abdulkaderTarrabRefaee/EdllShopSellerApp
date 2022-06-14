
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';

import 'custom_button.dart';
import 'custom_snackbar.dart';


class AttributeView extends StatefulWidget {
  final Product product;
  final bool colorOn;
  AttributeView({@required this.product, @required this.colorOn,});

  @override
  State<AttributeView> createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> {
  bool _update;
  bool colorONOFF;
  int addVar = 0;

  void _load(){
    Provider.of<RestaurantProvider>(context,listen: false).selectedColor;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
    _update = widget.product != null;



  }


  @override
  Widget build(BuildContext context) {
    if(_update){

      if(addVar==0){
        addVar++;
        if(widget.product.attributes != null && widget.product.attributes.length>0){
          Future.delayed(Duration.zero, () async {
            for(int i = 0; i <widget.product.attributes.length ; i++ ){
              Provider.of<RestaurantProvider>(context,listen: false).setAttributeItemList(widget.product.attributes[i]);

            }
          });

        }


      }




    }
    colorONOFF = widget.colorOn;

    return Consumer<RestaurantProvider>(
      builder: (context, resProvider, child){


        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(
            getTranslated('attribute', context),
            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          SizedBox(
            height: 50,
            child: resProvider.attributeList.length> 0 ?
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: resProvider.attributeList.length,
              itemBuilder: (context, index) {

                if(index == 0 && widget.colorOn){
                  return SizedBox();
                }

                return InkWell(
                  onTap: () => resProvider.toggleAttribute(context,index, widget.product),
                  child: Container(
                    width: 100, alignment: Alignment.center,
                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: resProvider.attributeList[index].active ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    ),
                    child: Text(
                      resProvider.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(
                        color: resProvider.attributeList[index].active ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                );
              },
            ):SizedBox(),
          ),
          SizedBox(height: resProvider.attributeList.where((element) => element.active).length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),
          resProvider.attributeList.length>0?
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: resProvider.attributeList.length,
            itemBuilder: (context, index) {
              return (resProvider.attributeList[index].active && index != 0) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Container(
                    width: 100, height: 50, alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300], blurRadius: 5, spreadRadius: 1)],
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    ),
                    child: Text(
                        resProvider.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                  Expanded(child: CustomTextField(
                    controller: resProvider.attributeList[index].controller,
                    textInputAction: TextInputAction.done,
                    capitalization: TextCapitalization.words,
                    // title: false,
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  CustomButton(
                    onTap: () {
                      String _variant = resProvider.attributeList[index].controller.text.trim();
                      if(_variant.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_a_variant_name', context),context);
                      }else {
                        resProvider.attributeList[index].controller.text = '';
                        resProvider.addVariant(context,index, _variant, widget.product, true);
                      }
                    },
                    btnTxt: 'add',
                  ),

                ]),

                Container(
                  height: 30, margin: EdgeInsets.only(left: 120),
                  child: resProvider.attributeList[index].variants.length > 0? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    itemCount: resProvider.attributeList[index].variants.length,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        ),
                        child: Row(children: [
                          Text(resProvider.attributeList[index].variants[i], style: robotoRegular),
                          InkWell(
                            onTap: () => resProvider.removeVariant(context,index, i, widget.product),
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.close, size: 15),
                            ),
                          ),
                        ]),
                      );
                    },
                  ):Align(
                      alignment: Alignment.centerLeft,
                      child: Text(getTranslated('no_variant_added_yet', context))),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ]) : SizedBox();
            },
          ):SizedBox(),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          resProvider.variantTypeList.length>0?
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: resProvider.variantTypeList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                child: Row(children: [
                  Expanded(flex: 6, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('variant',context),
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(
                      height: 50, alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300], blurRadius: 5, spreadRadius: 1)],
                      ),
                      child: Text(
                        resProvider.variantTypeList[index].variantType, style: robotoRegular, textAlign: TextAlign.center, maxLines: 1,
                      ),
                    ),
                  ])),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated('price',context),style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor)),

                      CustomTextField(
                        hintText: getTranslated('price',context),
                        controller: resProvider.variantTypeList[index].controller,
                        focusNode: resProvider.variantTypeList[index].node,
                        nextNode: index != resProvider.variantTypeList.length-1 ? resProvider.variantTypeList[index+1].node : null,
                        textInputAction: index != resProvider.variantTypeList.length-1 ? TextInputAction.next : TextInputAction.done,
                        isAmount: true,
                        textInputType: TextInputType.number,
                        amountIcon: true,
                      ),
                    ],
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated('quantity',context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),),
                      CustomTextField(
                        hintText: getTranslated('quantity',context),
                        controller: resProvider.variantTypeList[index].qtyController,
                        focusNode: resProvider.variantTypeList[index].qtyNode,
                        nextNode: index != resProvider.variantTypeList.length-1 ? resProvider.variantTypeList[index+1].node : null,
                        textInputAction: index != resProvider.variantTypeList.length-1 ? TextInputAction.next : TextInputAction.done,
                        isAmount: true,
                        amountIcon: false,
                        textInputType: TextInputType.number,
                      ),
                    ],
                  )),

                ]),
              );
            },
          ):SizedBox(),
          SizedBox(height: resProvider.hasAttribute() ? Dimensions.PADDING_SIZE_LARGE : 0),

        ]);
      },
    );
  }
}
