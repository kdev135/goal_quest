import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_quest/components/blog_content_list_view.dart';
import 'package:goal_quest/models/data_models/blog.dart';
import 'package:goal_quest/providers/state_providers.dart';
import 'package:goal_quest/screens/resource_screen.dart';
import 'package:goal_quest/styles.dart';



class BlogContentScreen extends ConsumerWidget {
  const BlogContentScreen({Key? key}) : super(key: key);
  static String routeName = "blog";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Blog? blog = ref.watch(blogProvider);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 800,
          child: Builder(builder: (context) {
            if (blog == null) {
              return Center(
                child: Column(
                  children: [
                    const Text(
                      "Blog data missing",
                      style: AppTextStyles.bodyText2,
                    ),
                    TextButton.icon(onPressed: () => Navigator.pushNamed(context, ResourceScreen.routeName), label: const Text("See blogs"), icon:const Icon(Icons.arrow_forward_rounded))
                  ],
                ),
              );
            }
            return const BlogContentListView();
          }),
        ),
      ),
    );
  }
}

List<Widget> parseContent(String content, ) {
  final widgets = <Widget>[];
  final pattern = RegExp(r'\*(.*?)\*');
  final matches = pattern.allMatches(content);
  int startIndex = 0;

  for (var match in matches) {
    final heading = match.group(1)!;
    if (startIndex != match.start) {
      widgets.add(Text(
        content.substring(startIndex, match.start),
        style: AppTextStyles.bodyText1
      ));
    }
    widgets.add(Text(
      heading,
      style: AppTextStyles.headline2
    ));
    startIndex = match.end;
  }

  if (startIndex < content.length) {
    widgets.add(Text(
      content.substring(startIndex),
      style: AppTextStyles.bodyText1
    ));
  }

  return widgets;
}