import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../styles.dart';

class ReportContainerModel extends StatelessWidget {
  const ReportContainerModel({Key? key, required this.reportList, required this.index}) : super(key: key);

  final List reportList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: interactiveFieldGrey)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${reportList[index]['report']}',
                  textAlign: TextAlign.justify,
                  style: AppTextStyles.bodyText1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Report date: ${reportList[index]['record_date']}',
                  textAlign: TextAlign.start,
                  style: AppTextStyles.captionText,
                )
              ],
            ),
          )),
    );
  }
}
