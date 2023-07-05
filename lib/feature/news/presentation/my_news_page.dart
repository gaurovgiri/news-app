import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/feature/news/data/news_article.dart';
import 'package:news_app/feature/news/presentation/news_detail_page.dart';
import 'package:news_app/network/network_request.dart';

class MyNewsPage extends StatelessWidget {
  const MyNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My News Page")),
        body: RefreshIndicator(
          onRefresh: () async {
            await NetworkRequest.fetchNewsData();
          },
          child: FutureBuilder<List<Articles>?>(
              future: NetworkRequest.fetchNewsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final newsArticle = snapshot.data ?? [];

                  return ListView.separated(
                    itemCount: newsArticle.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(), // Give a space between each item
                    itemBuilder: (context, index) {
                      final article = newsArticle[index];

                      return InkWell(
                        // For click use InkWell or GestureDetector
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetailPage(
                                      article: article,
                                      similarNews: newsArticle)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  if (article.urlToImage != null)
                                    Image.network(article.urlToImage!),
                                  if (article.title != null)
                                    Text(
                                      article.title!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  if (article.description != null)
                                    Html(data: article.description!),
                                  if (article.content != null)
                                    Html(data: article.content!),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
