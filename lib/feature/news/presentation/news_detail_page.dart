import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/feature/news/data/news_article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final Articles article;
  final List<Articles> similarNews;
  const NewsDetailPage(
      {super.key, required this.article, required this.similarNews});

  @override
  Widget build(BuildContext context) {
    final remainingNews =
        similarNews.where((element) => element.title != article.title).toList();
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
        child: SingleChildScrollView(
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              const SizedBox(height: 16),
              if (article.description != null) Html(data: article.description!),
              const SizedBox(height: 16),
              if (article.content != null) Html(data: article.content!),

              const SizedBox(height: 16),

              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Check full news at: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),

              TextButton(
                  onPressed: () {
                    _launchUrl(article.url);
                  },
                  child: Text(article.url ?? '')),

              // Similar News
              const SizedBox(height: 16),

              if (remainingNews.isNotEmpty)
                const Row(
                  children: [
                    Text(
                      "Similar News",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),

              const Divider(),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: remainingNews.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          remainingNews[index].title ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          remainingNews[index].description ?? '',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 70, 69, 69)),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
