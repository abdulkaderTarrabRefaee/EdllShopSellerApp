
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/attribute_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/variant_type_model.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/localization_provider.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/attribute_view.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';

class AddProductNextScreen extends StatefulWidget {
  final ValueChanged<bool> isSelected;
  final Product product;
  final List<String> title;
  final List<String> description;

  final AddProductModel addProduct;
  AddProductNextScreen({this.isSelected, @required this.product,@required this.title, @required this.description,@required this.addProduct});

  @override
  _AddProductNextScreenState createState() => _AddProductNextScreenState();
}

class _AddProductNextScreenState extends State<AddProductNextScreen> {
  bool isSelected = false;
  String _unitValue;
  final FocusNode _discountNode = FocusNode();
  final FocusNode _shippingCostNode = FocusNode();
  final FocusNode _unitPriceNode = FocusNode();
  final FocusNode _purchasePriceNode = FocusNode();
  final FocusNode _taxNode = FocusNode();
  final FocusNode _totalQuantityNode = FocusNode();
  final FocusNode _seoTitleNode = FocusNode();
  final FocusNode _seoDescriptionNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _shippingCostController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _totalQuantityController = TextEditingController();
  final TextEditingController _seoTitleController = TextEditingController();
  final TextEditingController _seoDescriptionController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  AutoCompleteTextField searchTextField;


  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;
  bool _update;
  Product _product;
  AddProductModel _addProduct;
  String thumbnailImage ='', metaImage ='';
  List<String> productImage =[];
  int counter = 0, total = 0;
  int addColor = 0;
  int cat=0, subCat=0, subSubCat=0, unit=0, brand=0;


  void _load(){
    String languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode == 'US'?'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase();
    Provider.of<SplashProvider>(context,listen: false).getColorList();
    Provider.of<RestaurantProvider>(context,listen: false).getAttributeList(context, widget.product, languageCode);
    Provider.of<RestaurantProvider>(context,listen: false).getCategoryList(context,widget.product, languageCode);
    Provider.of<RestaurantProvider>(context,listen: false).getBrandList(context, languageCode);
    Provider.of<RestaurantProvider>(context,listen: false).setBrandIndex(0, false);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _product = widget.product;
    _update = widget.product != null;
    _addProduct = widget.addProduct;
    _taxController.text = '0';
    _discountController.text = '0';
    _shippingCostController.text = '0';
    _load();
    if(_update) {
      Provider.of<RestaurantProvider>(context,listen: false).getEditProduct(context, widget.product.id);
      _unitPriceController.text = PriceConverter.convertPriceWithoutSymbol(context, _product.unitPrice);
      _taxController.text = _product.tax.toString();
      _totalQuantityController.text = _product.currentStock.toString();
      _seoTitleController.text = _product.metaTitle;
      _seoDescriptionController.text = _product.metaDescription;
      Provider.of<RestaurantProvider>(context, listen: false).setDiscountTypeIndex(_product.discountType == 'percent' ? 0 : 1, false);
      _discountController.text = _product.discountType == 'percent' ? _product.discount.toString() : PriceConverter.convertPriceWithoutSymbol(context, _product.discount);
      _purchasePriceController.text = PriceConverter.convertPriceWithoutSymbol(context, _product.purchasePrice);
      thumbnailImage = _product.thumbnail;
      metaImage = _product.metaImage;
      productImage = _product.images;
      _unitValue = _product.unit.toString();

    }else {
      _product = Product();
      _addProduct = AddProductModel();


    }
    super.initState();
  }



  route(bool isRoute, String name, String type) async {
    if (isRoute) {
      if(_update){
        if(thumbnailImage=='' && metaImage ==''){
          total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length;
        }else if(productImage.length == 0 && metaImage ==''){
          total = 1;
        }else if(thumbnailImage=='' && productImage.length == 0 && metaImage ==''){
          total = 0;
        }else if(thumbnailImage=='' && productImage.length == 0){
          total = 1;
        }
      }
      if(type == 'meta'){metaImage = name;}
      else if(type == 'thumbnail'){thumbnailImage = name;}
      else{
        productImage.add(name);
      }
      counter++;

      if(metaImage ==''){
        total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length + 1;
      }else{

        total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length + 2;
      }
        if(counter == total){
          Provider.of<RestaurantProvider>(context,listen: false).addProduct(context, _product, _addProduct, productImage, thumbnailImage, metaImage, Provider.of<AuthProvider>(context,listen: false).getUserToken(),!_update,Provider.of<RestaurantProvider>(context,listen: false).attributeList[0].active);

      }
    } else {
      print('Image upload problem');
      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:  widget.product != null ? getTranslated('update_product', context):getTranslated('add_product', context),),
      body: SafeArea(child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<RestaurantProvider>(
            builder: (context, resProvider, child){

              List<int> _brandIds = [];
              List<int> _colors = [];
              _brandIds.add(0);
              _colors.add(0);
              if(resProvider.brandList != null) {
                for(int index=0; index<resProvider.brandList.length; index++) {
                  _brandIds.add(resProvider.brandList[index].id);
                }
                if(_update) {
                  if(brand ==0){
                    resProvider.setBrandIndex(_brandIds.indexOf(_product.brandId), false);
                    brand++;
                  }

                }
              }


                if (_update && Provider.of<RestaurantProvider>(context, listen: false).attributeList != null && Provider.of<RestaurantProvider>(context, listen: false).attributeList.length > 0) {
                  
                  if(addColor==0) {
                    addColor++;
                    if ( widget.product.colors != null && widget.product.colors.length > 0) {
                      Future.delayed(Duration.zero, () async {
                        Provider.of<RestaurantProvider>(context, listen: false).setAttribute();
                      });

                    }
                    for (int index = 0; index < widget.product.colors.length; index++) {
                      _colors.add(index);
                      Future.delayed(Duration.zero, () async {
                        resProvider.addVariant(context,0, widget.product.colors[index].name, widget.product, false);
                        resProvider.addColorCode(widget.product.colors[index].code);

                      });
                    }
                  }

                }



              return SingleChildScrollView(
                child: (resProvider.attributeList != null && resProvider.attributeList.length > 0 && resProvider.categoryList != null && Provider.of<SplashProvider>(context,listen: false).colorList!= null) ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //english
                    Text(getTranslated("general_info", context),style: robotoRegularMainHeadingAddProduct),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('category', context),style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200],
                            spreadRadius: 2,blurRadius: 5,offset: Offset(0, 5))],),
                      child: DropdownButton<int>(
                        value: resProvider.categoryIndex,
                        items: resProvider.categoryIds.map((int value) {
                        return DropdownMenuItem<int>(
                          value: resProvider.categoryIds.indexOf(value),
                          child: Text( value != 0? resProvider.categoryList[(resProvider.categoryIds.indexOf(value) -1)].name: getTranslated('select', context)),
                        );
                      }).toList(),
                        onChanged: (int value) {
                          resProvider.setCategoryIndex(value, true);
                          resProvider.getSubCategoryList(context, value != 0 ? resProvider.categorySelectedIndex : 0, true, widget.product);
                          },

                        isExpanded: true, underline: SizedBox(),),),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('sub_category', context),style: robotoRegularForAddProductHeading),
                              SizedBox(height: 5,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL), boxShadow: [
                                    BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))
                                  ],
                                ),
                                child: DropdownButton<int>(
                                  value: resProvider.subCategoryIndex,
                                  items: resProvider.subCategoryIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: resProvider.subCategoryIds.indexOf(value),
                                      child: Text(value != 0 ? resProvider.subCategoryList[(resProvider.subCategoryIds.indexOf(value) - 1)].name : getTranslated('select', context)),
                                    );
                                  }).toList(),
                                  onChanged: (int value) {
                                    resProvider.setSubCategoryIndex(value, true);
                                    resProvider.getSubSubCategoryList(context, value != 0 ? resProvider.subCategorySelectedIndex : 0, true);

                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('sub_sub_category', context), style: robotoRegularForAddProductHeading),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                                ),
                                child: DropdownButton<int>(
                                  value: resProvider.subSubCategoryIndex,
                                  items: resProvider.subSubCategoryIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: resProvider.subSubCategoryIds.indexOf(value),
                                      child: Text(value != 0 ? resProvider.subSubCategoryList[(resProvider.subSubCategoryIds.indexOf(value)-1)].name : getTranslated('select', context)),
                                    );
                                  }).toList(),
                                  onChanged: (int value) {
                                    resProvider.setSubSubCategoryIndex(value, true);
                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('brand', context) , style: robotoRegularForAddProductHeading),
                              SizedBox(height: 5,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                                ),
                                child: DropdownButton<int>(
                                  value: resProvider.brandIndex,
                                  items: _brandIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: _brandIds.indexOf(value),
                                      child: Text(value != 0 ? resProvider.brandList[(_brandIds.indexOf(value)-1)].name : getTranslated('select', context)),
                                    );
                                  }).toList(),
                                  onChanged: (int value) {
                                    resProvider.setBrandIndex(value, true);
                                    // resProvider.changeBrandSelectedIndex(value);
                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('unit', context), style: robotoRegularForAddProductHeading),
                              SizedBox(height: 5,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                                ),
                                child: DropdownButton<String>(
                                  hint: _unitValue == null ? Text(getTranslated('select', context))
                                      : Text(_unitValue, style: TextStyle(color: ColorResources.getTextColor(context)),),
                                  items: Provider.of<SplashProvider>(context,listen: false).configModel.unit.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(
                                          () {
                                            _unitValue = val;
                                      },
                                    );
                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(getTranslated('variations', context),style: robotoRegularMainHeadingAddProduct),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(
                      children: [
                        Text(getTranslated('colors', context), style: robotoRegularForAddProductHeading),
                        Spacer(),
                        Switch(value:resProvider.attributeList[0].active,
                          onChanged: (value){
                          resProvider.toggleAttribute(context, 0, widget.product);
                        },
                          activeColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.grey,
                        )


                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    resProvider.attributeList[0].active?
                    Consumer<SplashProvider>(builder: (ctx, colorProvider, child){
                      if (colorProvider.colorList != null) {
                        for (int index = 0; index < colorProvider.colorList.length; index++) {
                          _colors.add(index);
                        }
                      }
                      return Autocomplete<int>(
                        optionsBuilder: (TextEditingValue value) {
                          if (value.text.isEmpty) {
                            return Iterable<int>.empty();
                          } else {
                            return _colors.where((color) => colorProvider.colorList[color].name.toLowerCase().contains(value.text.toLowerCase()));
                          }
                        },
                        fieldViewBuilder:
                            (context, controller, node, onComplete) {
                          return Container(
                            height: 50, decoration: BoxDecoration(color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                              boxShadow: [BoxShadow(
                                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200],
                                    spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))
                              ],
                            ),
                            child: TextField(
                              controller: controller,
                              focusNode: node, onEditingComplete: onComplete,
                              decoration: InputDecoration(
                                hintText: getTranslated('search_color', context),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL), borderSide: BorderSide.none),
                              ),
                            ),
                          );
                        },
                        displayStringForOption: (value) => colorProvider.colorList[value].name,
                        onSelected: (int value) {
                          resProvider.addVariant(context, 0,colorProvider.colorList[value].name, widget.product, true);
                          resProvider.addColorCode(colorProvider.colorList[value].code);
                        },
                      );
                    }):SizedBox(),
                    SizedBox(
                        height: resProvider.selectedColor.length != null && resProvider.selectedColor.length > 0 ? Dimensions.PADDING_SIZE_SMALL : 0),
                    SizedBox(
                      height: resProvider.attributeList[0].variants.length != null && resProvider.attributeList[0].variants.length > 0 ? 40 : 0,
                      child: resProvider.attributeList[0].variants.length != null && resProvider.attributeList[0].variants.length > 0 ?ListView.builder(
                        itemCount: resProvider.attributeList[0].variants.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            ),
                            child: Row(children: [
                              Consumer<SplashProvider>(builder: (ctx, colorP,child){
                                return Row(
                                  children: [
                                    Text(resProvider.attributeList[0].variants[index],
                                      style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                                    ),
                                  ],
                                );
                              }),
                              InkWell(
                                onTap: (){
                                  resProvider.removeVariant(context, 0, index, widget.product);
                                  resProvider.removeColorCode(index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Icon(Icons.close, size: 15, color: Theme.of(context).cardColor),
                                ),
                              ),
                            ]),
                          );
                        },
                      ):SizedBox(),
                    ),



                    /*------------------Attribute View-------------------*/

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  AttributeView(product: widget.product, colorOn: resProvider.attributeList[0].active),

                    Text(getTranslated('product_price_and_stock',context),style: robotoRegularMainHeadingAddProduct),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('unit_price', context),
                      style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      controller: _unitPriceController,
                      focusNode: _unitPriceNode,
                      nextNode: _purchasePriceNode,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      isAmount: true,
                      hintText: '\$129',
                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('purchase_price', context),
                      style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      controller: _purchasePriceController,
                      focusNode: _purchasePriceNode,
                      nextNode: _taxNode,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      isAmount: true,
                      hintText: '\$129',
                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('tax_p',context),
                      style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      controller: _taxController,
                      focusNode: _taxNode,
                      nextNode: _discountNode,
                      isAmount: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      hintText: '10',
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Row(children: [

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getTranslated('discount_amount', context),
                            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('discount', context),
                            controller: _discountController,
                            focusNode: _discountNode,
                            nextNode: _shippingCostNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                            isAmount: true,
                            // isAmount: true,
                          ),
                        ],
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          getTranslated('discount_type', context),
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                          ),
                          child: DropdownButton<String>(
                            value: resProvider.discountTypeIndex == 0 ? 'percent' : 'flat',
                            items: <String>['percent', 'flat'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              resProvider.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                            },
                            isExpanded: true,
                            underline: SizedBox(),
                          ),
                        ),
                      ])),

                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    //__________Shipping___________
                    Row(children: [

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getTranslated('shipping_cost', context),
                            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            controller: _shippingCostController,
                            focusNode: _shippingCostNode,
                            nextNode: _totalQuantityNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                            isAmount: true,
                            // isAmount: true,
                          ),
                        ],
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          getTranslated('shipping_cost_multiply', context),
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Switch(value:resProvider.isMultiply,
                          onChanged: (value){
                            resProvider.toggleMultiply(context);
                            print('===IsMultiply=>${resProvider.isMultiply}');
                          },
                          activeColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.grey,
                        )
                      ])),

                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                    Text(getTranslated('total_quantity', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: 5),
                    CustomTextField(
                      textInputType: TextInputType.number,
                      focusNode: _totalQuantityNode,
                      controller: _totalQuantityController,
                      nextNode: _seoTitleNode,
                      textInputAction: TextInputAction.next,
                      isAmount: true,
                      hintText: '10',
                    ),
                    SizedBox(height: 5,),

                    Text(getTranslated('seo_section', context),style: robotoRegularMainHeadingAddProduct),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(getTranslated('meta_title', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.name,
                      focusNode: _seoTitleNode,
                      controller: _seoTitleController,
                      nextNode: _seoDescriptionNode,
                      textInputAction: TextInputAction.next,
                      hintText: getTranslated('meta_title', context),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(getTranslated('meta_description', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: 5,),
                    CustomTextField(
                      controller: _seoDescriptionController,
                      focusNode: _seoDescriptionNode,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.multiline,
                      maxLine: 3,
                      hintText: getTranslated('meta_description_hint', context),

                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('meta_image', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    //image picker........................
                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        child: resProvider.pickedMeta != null? Image.file(
                          File(resProvider.pickedMeta.path), width: 150, height: 120, fit: BoxFit.cover,
                        ) :widget.product!=null? FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          image: '${Provider.of<SplashProvider>(context).configModel.baseUrls.productImageUrl}/meta/${_product.metaImage != null ? _product.metaImage : ''}',
                          height: 120, width: 150, fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 120, width: 150, fit: BoxFit.cover),
                        ):Image.asset(Images.placeholder_image, height: 120, width: 150, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => resProvider.pickImage(false,true, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),

                    //image picker........................

                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Text(getTranslated('image', context),style: robotoRegularMainHeadingAddProduct),


                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Text(getTranslated('youtube_video_link', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      controller: _youtubeLinkController,
                      focusNode: _youtubeLinkNode,
                      textInputAction: TextInputAction.done,
                      hintText: 'www.youtube.com/6valley',

                    ),


                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(getTranslated('upload_thumbnail', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    //image picker........................
                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        child: resProvider.pickedLogo != null ?  Image.file(File(resProvider.pickedLogo.path), width: 150, height: 120, fit: BoxFit.cover,
                        ) :widget.product!=null? FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          image: '${Provider.of<SplashProvider>(context).configModel.baseUrls.productThumbnailUrl}/${_product.thumbnail != null ? _product.thumbnail : ''}',
                          height: 120, width: 150, fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 120, width: 150, fit: BoxFit.cover),
                        ):Image.asset(Images.placeholder_image,height: 120, width: 150, fit: BoxFit.cover,),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => resProvider.pickImage(true,false, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),

                    //image picker........................

                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Text(getTranslated('product_image', context), style: robotoRegularForAddProductHeading),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    //..................multiple image picker......................

                    ConstrainedBox(
                        constraints: resProvider.productImage.length >= 4? BoxConstraints(maxHeight: (double.parse(resProvider.productImage.length.toString())/2.3)*80 ):BoxConstraints(maxHeight: 80),
                      child: StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: resProvider.productImage.length + 1,
                        crossAxisCount: 4, itemBuilder: (BuildContext context, index){
                        return index == resProvider.productImage.length ?
                        GestureDetector(
                          onTap: ()=> resProvider.pickImage(false, false, false),
                          child: Stack(
                            children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                child:  Image.asset(Images.placeholder_image, height: 120, width: 150, fit: BoxFit.cover),
                              ),
                              Positioned(
                                bottom: 0, right: 0, top: 0, left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            :Stack(
                              children: [
                                Container(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                  child: Image.file(File(resProvider.productImage[index].path), width: 150, height: 120, fit: BoxFit.cover,
                          ),
                                ) ,
                          decoration: BoxDecoration(
                                  color: Colors.white,
                                  //image: new DecorationImage(image: FileImage(resProvider.coveredImage[index]), fit: BoxFit.fill,),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),

                          ),

                        ),
                                Positioned(
                                  top:0,right:0,
                                  child: InkWell(
                                    onTap :() => resProvider.removeImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                                      ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 15,),
                                        )),
                                  ),
                                ),
                              ],
                            );

                      }, staggeredTileBuilder: (int index)=> new StaggeredTile.count(index ==0? 1:1, index == 0? 1:1),
                        mainAxisSpacing: 3,crossAxisSpacing: 3, )

                    ),

                    //..................End multiple image picker......................

                    SizedBox(height: 25,),

                    !resProvider.isLoading
                        ?CustomButton(
                      btnTxt: _update ? getTranslated('update',context) : getTranslated('submit', context),
                      onTap: (){
                        List<String> _title = widget.title;
                        List<String> _description = widget.description;
                        String _seoDescription = _seoDescriptionController.text.trim();
                        String _seoTitle = _seoTitleController.text.trim();
                        String _discount = _discountController != null?_discountController.text.trim() : '0.0';
                        String _tax =_taxController != null ? _taxController.text.trim() :  '0.0';
                        String _unitPrice =_unitPriceController.text.trim();
                        String _purchasePrice =_purchasePriceController.text.trim();
                        String _unit =_unitValue.toString().trim();
                        String _brandId =_brandIds[resProvider.brandIndex].toString();
                        String _metaTitle =_seoTitleController.text.trim();
                        String _metaDescription =_seoDescriptionController.text.trim();
                        String _currentStock = _totalQuantityController.text.trim();
                        String _videoUrl = _youtubeLinkController.text.trim();
                        String _shippingCost = _shippingCostController.text.trim();
                        String _multiPlyWithQuantity = resProvider.isMultiply?'1':'0';
                        int _multi = int.parse(_multiPlyWithQuantity);
                        bool _haveBlankVariant = false;
                        bool _blankVariantPrice = false;
                        bool _blankVariantQuantity = false;
                        for (AttributeModel attr
                        in resProvider.attributeList) {
                          if (attr.active && attr.variants.length == 0) {
                            _haveBlankVariant = true;
                            break;
                          }
                        }

                        for (VariantTypeModel variantType in resProvider.variantTypeList) {
                          if (variantType.controller.text.isEmpty) {
                            _blankVariantPrice = true;
                            break;
                          }
                        }
                        for (VariantTypeModel variantType in resProvider.variantTypeList) {
                          if (variantType.qtyController.text.isEmpty) {
                            _blankVariantQuantity = true;
                            break;
                          }
                        }
                        if (_unitPrice.isEmpty) {
                          showCustomSnackBar(getTranslated('enter_unit_price', context),context);
                        }

                        else if (_purchasePrice.isEmpty) {
                          showCustomSnackBar(getTranslated('enter_purchase_price', context),context);
                        }
                        else if (_currentStock.isEmpty) {
                          showCustomSnackBar(getTranslated('enter_total_quantity', context),context);
                        }
                        // else if (_tax.isEmpty) {
                        //   showCustomSnackBar(getTranslated('enter_tax', context),context);
                        // } else if (_discount.isEmpty) {
                        //   showCustomSnackBar(getTranslated('enter_product_discount', context),context);
                        // }
                        else if (resProvider.categoryIndex == 0) {
                          showCustomSnackBar(getTranslated('select_a_category',context),context);
                        } else if (_haveBlankVariant) {
                          showCustomSnackBar(getTranslated('add_at_least_one_variant_for_every_attribute',context),context);
                        } else if (_blankVariantPrice) {
                          showCustomSnackBar(getTranslated('enter_price_for_every_variant', context),context);
                        }else if (_blankVariantQuantity) {
                          showCustomSnackBar(getTranslated('enter_quantity_for_every_variant', context),context);
                        }

                        else if (!_update && resProvider.pickedLogo == null) {
                          showCustomSnackBar(getTranslated('upload_thumbnail_image',context),context);
                        }else if (!_update && resProvider.productImage.length == 0) {
                          showCustomSnackBar(getTranslated('upload_product_image',context),context);
                        }


                        else {
                          _addProduct = AddProductModel();
                          _addProduct.titleList = _title;
                          _addProduct.descriptionList = _description;
                          _addProduct.videoUrl = _videoUrl;
                          _product.tax = double.parse(_tax);
                          _product.unitPrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_unitPrice), context);
                          _product.purchasePrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_purchasePrice), context);
                          _product.discount = resProvider.discountTypeIndex == 0 ? double.parse(_discount) : PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_discount), context);
                          _product.unit = _unit;
                          _product.shippingCost = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_shippingCost), context);
                          _product.multiplyWithQuantity = _multi;
                          _product.brandId = int.parse(_brandId);
                          _product.metaTitle = _metaTitle;
                          _product.metaDescription = _metaDescription;
                          _product.currentStock = int.parse(_currentStock);
                          _product.metaTitle = _seoTitle;
                          _product.metaDescription = _seoDescription;
                          _product.discountType = resProvider.discountTypeIndex == 0 ? 'percent' : 'flat';
                          _product.categoryIds = [];
                          _product.categoryIds.add(CategoryIds(
                              id: resProvider.categoryList[resProvider.categoryIndex-1].id.toString()));
                          if (resProvider.subCategoryIndex != 0) {
                            _product.categoryIds.add(CategoryIds(
                              id: resProvider.subCategoryList[resProvider.subCategoryIndex-1].id.toString()));}
                          if (resProvider.subSubCategoryIndex != 0) {
                            _product.categoryIds.add(CategoryIds(
                              id: resProvider.subSubCategoryList[resProvider.subSubCategoryIndex-1].id.toString()));}

                         _addProduct.colorCodeList =[];
                        if(resProvider.colorCodeList != null){
                          _addProduct.colorCodeList.addAll(resProvider.colorCodeList);
                        }

                        _addProduct.languageList = [];
                        if(Provider.of<SplashProvider>(context, listen:false).configModel.languageList!=null && Provider.of<SplashProvider>(context, listen:false).configModel.languageList.length>0){
                          for(int i=0; i<Provider.of<SplashProvider>(context, listen:false).configModel.languageList.length;i++){
                            _addProduct.languageList.insert(i, Provider.of<SplashProvider>(context, listen:false).configModel.languageList[i].code) ;
                          }

                        }



                          if(_update){
                            // Provider.of<RestaurantProvider>(context,listen: false).addProduct(context, _product, _addProduct, productImage, thumbnailImage, metaImage, Provider.of<AuthProvider>(context,listen: false).getUserToken(),!_update,Provider.of<RestaurantProvider>(context,listen: false).attributeList[0].active);
                            if(resProvider.pickedLogo == null && resProvider.pickedMeta == null && resProvider.productImage.length == 0 || resProvider.productImage == null ){
                              print('===>Btn Pressed');
                              Provider.of<RestaurantProvider>(context,listen: false).addProduct(context, _product, _addProduct, productImage, thumbnailImage, metaImage, Provider.of<AuthProvider>(context,listen: false).getUserToken(),!_update,Provider.of<RestaurantProvider>(context,listen: false).attributeList[0].active);
                            }

                            else{

                              if(resProvider.pickedLogo != null){
                                resProvider.addProductImage(resProvider.pickedLogo,'thumbnail', route);
                              }

                              if(resProvider.pickedMeta != null){
                                resProvider.addProductImage(resProvider.pickedMeta,'meta', route);
                              }

                              if(resProvider.productImage != null && resProvider.productImage.length > 0){
                                for(int i =0; i<resProvider.productImage.length;i++)
                                {
                                  resProvider.addProductImage(resProvider.productImage[i],'product', route);
                                }
                              }

                            }


                          }
                          if(resProvider.pickedLogo != null){
                            resProvider.addProductImage(resProvider.pickedLogo,'thumbnail', route);
                          }

                          if(resProvider.pickedMeta != null){
                            resProvider.addProductImage(resProvider.pickedMeta,'meta', route);
                          }

                          if(resProvider.productImage != null){
                            for(int i =0; i<resProvider.productImage.length;i++)
                            {
                              resProvider.addProductImage(resProvider.productImage[i],'product', route);
                            }
                          }

                        }



                      },
                    ):Center(child: CircularProgressIndicator()),


                  ],):Padding(
                    padding: const EdgeInsets.only(top: 300.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              );
            },

          ),
        ),
      ),),
    );
  }
}
