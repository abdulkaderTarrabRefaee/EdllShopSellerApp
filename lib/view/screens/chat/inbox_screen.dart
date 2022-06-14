import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/chat_screen.dart';

// ignore: must_be_immutable
class InboxScreen extends StatelessWidget {
  final bool isBackButtonExist;
  InboxScreen({this.isBackButtonExist = true,});

  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context, listen: false).initChatList(context);

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ChatProvider>(builder: (context, chat, child) {
        return Column(children: [

          // AppBar
          CustomAppBar(title: getTranslated('inbox', context)),

          Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () async {
                await chat.initChatList(context);
              },
              child: Consumer<ChatProvider>(
                builder: (context, chat, child) {
                  return chat.customerList != null ? chat.customerList.length != 0 ? ListView.builder(
                    itemCount: chat.customerList.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: ClipOval(
                              child: Container(
                                color: Theme.of(context).highlightColor,
                                child: CachedNetworkImage(
                                  errorWidget: (ctx, url ,err )=>Image.asset(Images.placeholder_image),
                                  placeholder: (ctx, url )=>Image.asset(Images.placeholder_image),
                                  imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}'
                                      '/${chat.customerList[index].image != null ? chat.customerList[index].image : ''}',
                                  fit: BoxFit.cover, height: 50, width: 50,
                                ),
                              ),
                            ),
                            title: Text(chat.customerList[index].fName+' '+chat.customerList[index].lName, style: titilliumSemiBold),
                            subtitle: Text(
                              chat.customersMessages[index][chat.customersMessages[index].length-1].message,maxLines: 4,overflow: TextOverflow.ellipsis,
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return ChatScreen(customer: chat.customerList[index], customerIndex: index, messages: chat.customersMessages[index]);
                            })),
                          ),
                          Divider(height: 2, color: ColorResources.CHAT_ICON_COLOR),
                        ],
                      );
                    },
                  ) : NoDataScreen() : InboxShimmer();
                },
              ),
            ),
          ),
        ]);
      },
      ),
    );
  }

}

class InboxShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<ChatProvider>(context).chatList == null,
          child: Padding(
            padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              CircleAvatar(child: Icon(Icons.person), radius: 30),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(children: [
                    Container(height: 15, color: ColorResources.WHITE),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(height: 15, color: ColorResources.WHITE),
                  ]),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 10, width: 30, color: ColorResources.WHITE),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                ),
              ])
            ]),
          ),
        );
      },
    );
  }
}

