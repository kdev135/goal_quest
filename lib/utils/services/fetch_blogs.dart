
import 'package:goal_quest/supabase_client.dart';

import '../../models/data_models/blog.dart';

Future<List<Blog>> fetchBlogs() async {

  try {
    final response = await supabase.from('blogs').select();


    final List<dynamic> data = response as List<dynamic>;
    final List<Blog> blogs = data.map((json) => Blog.fromJson(json)).toList();

    return blogs;
  } catch (error) {
    throw Exception('Error fetching blogs: $error');
  }
}
