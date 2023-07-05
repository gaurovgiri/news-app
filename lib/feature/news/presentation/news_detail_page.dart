import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/feature/news/data/news_article.dart';

class NewsDetailPage extends StatelessWidget {
  final Articles article;
  final List<Articles> similarNews;
  const NewsDetailPage(
      {super.key, required this.article, required this.similarNews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title ?? ' ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(article.urlToImage!),
              ),
            const SizedBox(height: 16),
            if (article.title != null)
              Text(
                article.title!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            const SizedBox(height: 16),
            if (article.description != null) Html(data: article.description!),
            const SizedBox(height: 16),
            if (article.content != null) Html(data: article.content!),
          ],
        ),
      ),
    );
  }
}
