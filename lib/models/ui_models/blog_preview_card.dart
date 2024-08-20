import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_quest/models/data_models/blog.dart';
import 'package:goal_quest/providers/state_providers.dart';
import 'package:goal_quest/screens/blog_content_screen.dart';
import 'package:goal_quest/styles.dart';

class BlogPreviewCard extends ConsumerWidget {
  const BlogPreviewCard({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SizedBox(width: 300,height: 70,
        child: ListTile(
         dense: true,
          title: Text(
            blog.title,
            style: AppTextStyles.headline3,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
          subtitle: Text("Read time: ${blog.readTime}"),
          leading: (blog.thumbnailUrl != null)
              ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(blog.thumbnailUrl!,))
              : null,
          onTap: () {
            ref.read(blogProvider.notifier).state = blog;
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushNamed(context, BlogContentScreen.routeName);
            });
          }, // Display thumbnail if available
        ),
      ),
    );
  }
}
