import 'package:flutter/material.dart';
import 'package:goal_quest/components/blog_preview_list_view.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/styles.dart';

/// A catalog of the availiable resources to help in goal achievement
class ResourceScreen extends StatelessWidget {
  const ResourceScreen({Key? key}) : super(key: key);
  static String routeName = "blogs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),),
        title: AnimatedPageTitleModel(titleText: "RESOURCES"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Center(
          child: SizedBox(
            width: 800,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: BlogPreviewListView(),
            ),
          ),
        ),
      ),
    );
  }
}
