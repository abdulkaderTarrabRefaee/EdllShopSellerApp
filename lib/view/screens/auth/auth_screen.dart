import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/login_screen.dart';

class AuthScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

   // Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;


    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [

          // background
          Provider.of<ThemeProvider>(context).darkTheme ? SizedBox()
              : Image.asset(Images.background, fit: BoxFit.fill, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),

          Consumer<AuthProvider>(
            builder: (context, auth, child) => SafeArea(
              child: ListView(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    child: Image.asset(Images.logo, height: 200, width: 200),
                  ),
                  Center(child: Text(getTranslated('login', context), style: titilliumBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),)),

                  SignInWidget()

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

