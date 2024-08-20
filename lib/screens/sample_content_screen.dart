import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

import '../models/ui_models/animated_page_title_model.dart';
import '../utils/operations/date_format.dart';

class SampleContentScreen extends StatelessWidget {
  const SampleContentScreen({Key? key}) : super(key: key);
  static String routeName = "sample";

  final String sampleTitle = "Save KES 2,000,000 for a Down Payment on a House";
  final String sampleDescription =
      "Accumulate a substantial down payment of KES 2,000,000 by the end of 2025 to secure a mortgage for a three-bedroom house in Nairobi. This financial milestone will be achieved through a strategic approach that combines disciplined saving, aggressive debt reduction, and potential income augmentation. By prioritizing housing as a primary financial goal, implementing a robust savings plan, and exploring additional income streams, it is anticipated that the target amount will be reached within the specified timeframe. Successful attainment of this goal will mark a significant step towards long-term financial stability and homeownership.";
  final String sampleActionPlan =
      "* Dedicate at least 30% of monthly income to a dedicated high-yield savings account.\n* Explore side hustle opportunities or part-time employment to supplement income.\n* Create a detailed monthly budget to identify areas for cost reduction and eliminate unnecessary expenses.";

  @override
  Widget build(BuildContext context) {
    final DateTime sampleTargetDate = DateTime(2025,11,25);

    return Scaffold(
      appBar: AppBar(
        leading:  BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const AnimatedPageTitleModel(
          titleText: 'S A M P L E  G O A L',
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
            child: SizedBox(
                    width: 800,
                    child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text("Goal Title", style: AppTextStyles.headline2),
                Text(
                  sampleTitle,
                  style: AppTextStyles.bodyText1,
                ),
                const SizedBox(height: 10,),
                const Text("Goal Description", style: AppTextStyles.headline2),
                Text(sampleDescription, style: AppTextStyles.bodyText1),
                const SizedBox(height: 10,),
                const Text("Action Plan", style: AppTextStyles.headline2),
                Text(sampleActionPlan, style: AppTextStyles.bodyText1),
                const SizedBox(height: 10,),
                const Text("Target Date", style: AppTextStyles.headline2),
                Text(customDateFormat(sampleTargetDate), style: AppTextStyles.bodyText1),
              ],
            ),
                    ),
                  ),
          )),
    );
  }
}
