import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class WithdrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('\$567', style: TextStyle(fontWeight: FontWeight.w500,fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Color(0xFF000743)),),
               SizedBox(height: 3,),
                Text('Transfer too bank name', style: TextStyle(fontWeight: FontWeight.w400,fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),),
              ],),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text('28-05-2021', style: TextStyle(fontWeight: FontWeight.w400,fontSize: Dimensions.FONT_SIZE_SMALL,color: Color(0xff9B9B9B)),),
                  SizedBox(height: 3,),
                Text('Success', style: TextStyle(fontWeight: FontWeight.w400,fontSize: Dimensions.FONT_SIZE_SMALL,color: Color(0xff30E02C)),),

              ],),
            ],),

          ),
        ),
        Divider(thickness: 2,),
      ],
    );
  }
}
