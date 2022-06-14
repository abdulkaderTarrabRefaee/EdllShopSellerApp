import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';

class ColorResources {

  static Color getBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF721511) : Color(0xFFdb913a);
  }

  static Color getWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color getColombiaBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF678cb5) : Color(0xFF92C6FF);
  }
  static Color getLightSkyBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF8DBFF6);
  }
  static Color getHarlequin(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF257800) : Color(0xFF3FCC01);
  }
  static Color getCheris(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF941546) : Color(0xFFE2206B);
  }
  static Color getGrey(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF808080) : Color(0xFFF1F1F1);
  }
  static Color getRed(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7a1c1c) : Color(0xFFD32F2F);
  }
  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF916129) : Color(0xFFFFAA47);
  }
  static Color getHint(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF9E9E9E);
  }
  static Color getGainsBoro(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF999999) : Color(0xFFE6E6E6);
  }
  static Color getTextBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF414345) : Color(0xFFF3F9FF);
  }
  static Color getIconBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF2e2e2e) : Color(0xFFF9F9F9);
  }
  static Color getHomeBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF343636) : Color(0xFFF3F3F3);
  }
  static Color getImageBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF3f4347) : Color(0xFFE2F0FF);
  }
  static Color getSellerTxt(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF517091) : Color(0xFF92C6FF);
  }
  static Color getChatIcon(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFebebeb) : Color(0xFFD4D4D4);
  }
  static Color getLowGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7d8085) : Color(0xFFEFF6FE);
  }
  static Color getGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF167d3c) : Color(0xFF23CB60);
  }
  static Color getFloatingBtn(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF49698c) : Color(0xFF7DB6F5);
  }
  static Color getPrimary(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFf0f0f0) : Color(
        0xFF721511);
  }
  static Color getBottomSheetColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF25282B) : Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF52575C);
  }

  static Color getSubTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFA0A0A0) : Color(0xFFA0A0A0);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static const Color BLACK = Color(0xff000000);
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color COLOR_BLUE = Color(0xff721511);
  static const Color COLUMBIA_BLUE = Color(0xff721511);
  static const Color LIGHT_SKY_BLUE = Color(0xff8DBFF6);
  static const Color HARLEQUIN = Color(0xff3FCC01);
  static const Color CERISE = Color(0xffE2206B);
  static const Color GREY = Color(0xffF1F1F1);
  static const Color RED = Color(0xFFD32F2F);
  static const Color YELLOW = Color(0xFFFFAA47);
  static const Color HINT_TEXT_COLOR = Color(0xff9E9E9E);
  static const Color GAINS_BORO = Color(0xffE6E6E6);
  static const Color TEXT_BG = Color(0xFFF4F7FC);
  static const Color ICON_BG = Color(0xffF9F9F9);
  static const Color HOME_BG = Color(0xffF0F0F0);
  static const Color IMAGE_BG = Color(0xffE2F0FF);
  static const Color SELLER_TXT = Color(0xff38DBFF);
  static const Color CHAT_ICON_COLOR = Color(0xffD4D4D4);
  static const Color LOW_GREEN = Color(0xffEFF6FE);
  static const Color GREEN = Color(0xff23CB60);
  static const Color FLOATING_BTN = Color(0xff7DB6F5);
  static const Color COLOR_LIGHT_BLACK = Color(0xFF4A4B4D);

  static const Map<int, Color> colorMap = {
    50: Color(0xD721511),
    100: Color(0x16721511),
    200: Color(0x1d721511),
    300: Color(0x2d721511),
    400: Color(0x54721511),
    500: Color(0x65721511),
    600: Color(0x7e721511),
    700: Color(0xa6721511),
    800: Color(0xd5721511),
    900: Color(0xff721511),
  };

  static const MaterialColor PRIMARY_MATERIAL = MaterialColor(0xff721511, colorMap);
}
