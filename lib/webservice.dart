import 'dart:convert';

import 'package:hacker_news/story.dart';
import 'package:hacker_news/urlHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Webservice {
  
  Future<Response> _getStory(int storyId) {
    return http.get(UrlHelper.urlForStory(storyId));
  }

  Future<List<Response>> getCommentsByStory(Story story) async {

    return Future.wait(story.commentIds.map((commentId)  { 
        return http.get(UrlHelper.urlForCommentById(commentId));
    }));

  }

  Future<List<Response>> getTopStories() async {
    
    final response = await http.get(UrlHelper.urlForTopStories());
    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);
      return Future.wait(storyIds.take(10).map((storyId) {
        return _getStory(storyId);
      }));

    } else {
      throw Exception("Unable to fetch data!");
    }
  }
}
