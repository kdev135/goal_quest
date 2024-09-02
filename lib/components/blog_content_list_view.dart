import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_quest/models/data_models/blog.dart';
import 'package:goal_quest/screens/blog_content_screen.dart';
import 'package:goal_quest/styles.dart';

import '../providers/state_providers.dart';

class BlogContentListView extends ConsumerWidget {
  const BlogContentListView({
    super.key,

  });

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Blog? blog = ref.watch(blogProvider);
    return ListView(
      children: [
        Image.network(
          blog!.bannerImageUrl!,
          height: 250,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  blog.title,
                  style: AppTextStyles.headline2,
                ),
              ), Text("Read time: ${blog.readTime}"),
          const SizedBox(height: 15,),
          ...parseContent(blog.content, ),
            ],
          ),
        ),
       
      ],
    );
  }
}
