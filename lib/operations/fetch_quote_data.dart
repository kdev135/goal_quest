// Fetch quote via API
import 'package:dio/dio.dart';
import 'package:goal_quest/constants.dart';

Future<String> fetchQuoteData({String? quote}) async {
  String theQuote = defaultQuote;
  try {
    var response =
        await Dio().get('https://api.quotable.io/random?maxLength=105&tags=inspiration|success|motivational');
    theQuote ='${response.data["content"]}\n\n- ${response.data["author"]}';
    quote = '${response.data["content"]}\n\n- ${response.data["author"]}';
  } catch (e) {
    print(e);
  }
  return theQuote;
}
