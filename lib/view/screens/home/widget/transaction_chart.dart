import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class TransactionChart extends StatefulWidget {
  final List<double> earnings;
  final List<double> commissions;
  final double max;
  TransactionChart({@required this.earnings,@required this.commissions, @required this.max});

  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  final Color leftBarColor = const Color(0xffB6C867);
  final Color rightBarColor = const Color(0xff01937C);
  final double width = 5;

   List<BarChartGroupData> rawBarGroups;
   List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, widget.commissions[0],  widget.earnings[0]);
    final barGroup2 = makeGroupData(1, widget.commissions[1],  widget.earnings[1]);
    final barGroup3 = makeGroupData(2, widget.commissions[2], widget.earnings[2]);
    final barGroup4 = makeGroupData(3, widget.commissions[3],  widget.earnings[3]);
    final barGroup5 = makeGroupData(4, widget.commissions[4], widget.earnings[4]);
    final barGroup6 = makeGroupData(5, widget.commissions[5], widget.earnings[5]);
    final barGroup7 = makeGroupData(6, widget.commissions[6],  widget.earnings[6]);
    final barGroup8 = makeGroupData(7, widget.commissions[7], widget.earnings[7]);
    final barGroup9 = makeGroupData(8, widget.commissions[8], widget.earnings[8]);
    final barGroup10 = makeGroupData(9, widget.commissions[9], widget.earnings[9]);
    final barGroup11 = makeGroupData(10, widget.commissions[10], widget.earnings[10]);
    final barGroup12 = makeGroupData(11, widget.commissions[11], widget.earnings[11]);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8,
      barGroup9,
      barGroup10,
      barGroup11,
      barGroup12,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(width: 14,height: 14 ,child: Image.asset(Images.pie_chart)),
                  SizedBox(width: 5,),
                  Text(getTranslated('monthly_earning', context), style: robotoRegular.copyWith(
                  color: ColorResources.getTextColor(context),
                  fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         children: [
                           Icon(Icons.circle,size: 7,color: Color(0xffB6C867),),
                           Text(
                            getTranslated('your_earnings', context),
                             style: robotoSmallTitleRegular.copyWith(
                      color: ColorResources.getTextColor(context),
                      fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                         ],
                       ),
                       Row(
                         children: [
                           Icon(Icons.circle,size: 7,color: Color(0xff01937C)),
                           Text(
                            getTranslated('commission_given', context),
                             style: robotoSmallTitleRegular.copyWith(
                                 color: ColorResources.getTextColor(context),
                                 fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                         ],
                       ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: widget.max,
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (_a, _b, _c, _d) => null,
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (response == null || response.spot == null) {
                            setState(() {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                            });
                            return;
                          }

                          touchedGroupIndex = response.spot.touchedBarGroupIndex;

                          setState(() {
                            if (!event.isInterestedForInteractions) {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                              return;
                            }
                            showingBarGroups = List.of(rawBarGroups);
                            if (touchedGroupIndex != -1) {
                              var sum = 0.0;
                              for (var rod in showingBarGroups[touchedGroupIndex].barRods) {
                                sum += rod.y;
                              }
                              final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                              showingBarGroups[touchedGroupIndex] =
                                  showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                            }
                          });
                        }),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2), fontWeight: FontWeight.w400, fontSize: 10),
                        margin: 10,
                        getTitles: (double value) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Jan';
                            case 1:
                              return 'Feb';
                            case 2:
                              return 'Mar';
                            case 3:
                              return 'Apr';
                            case 4:
                              return 'May';
                            case 5:
                              return 'Jun';
                            case 6:
                              return 'Jul';
                            case 7:
                              return 'Aug';
                            case 8:
                              return 'Sep';
                            case 9:
                              return 'Oct';
                            case 10:
                              return 'Nov';
                            case 11:
                              return 'Dec';
                            default:
                              return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 1.5;
    const space = 1.5;
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}