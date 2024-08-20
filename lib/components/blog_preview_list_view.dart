import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:goal_quest/models/data_models/blog.dart';
import 'package:goal_quest/models/ui_models/blog_preview_card.dart';
import 'package:goal_quest/utils/services/fetch_blogs.dart';

class BlogPreviewListView extends StatelessWidget {
  const BlogPreviewListView({
    super.key, this.scrollDirection = Axis.vertical
  });
final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(
            child: SpinKitWave(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 50.0,
              ),
          );
        } else if (snapshot.hasError) {
          var error = snapshot.error; // Corrected error access
          return Center(child: Text("Something went wrong: $error"));
        }
    
        final List<Blog> blogs = snapshot.data as List<Blog>; // Cast data to List<Blog>
    
        return Align(alignment: AlignmentDirectional.topStart,
          child: ListView.builder(
            shrinkWrap: true,
            
            scrollDirection:scrollDirection,
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              
              return BlogPreviewCard(blog: blog);
            },
          ),
        );
      },
    );
  }
}
