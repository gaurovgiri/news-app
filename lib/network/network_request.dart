import 'package:dio/dio.dart';
import 'package:news_app/feature/news/data/news_article.dart';

class NetworkRequest {
  static Future<List<Articles>?> fetchNewsData() async {
    const apiKey = "87b2df00facf4e03a0acb59b31ceddb1";
    const url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey";

    final dio = Dio();

    final response = await dio.get(url);

    if (response.statusCode == 200) {
      // final jsonData = response.data;
      // final articles = jsonData["articles"];
      // return articles;
      return NewsArticle.fromJson(response.data).articles ?? [];
    } else {
      return [];
    }
  }
}
