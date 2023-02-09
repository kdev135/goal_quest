// Fetch quote via API
import 'package:dio/dio.dart';

import 'package:goal_quest/constants.dart';

void getQuote() async {
  try {
    var response = await Dio().get(
        'https://api.quotable.io/random?maxLength=105&tags=inspiration|success|motivational');
    await quoteBox.put('newQuote', '${response.data["content"]}\n\n- ${response.data["author"]}');
    
  } catch (e) {
    print(e);
  }
}
