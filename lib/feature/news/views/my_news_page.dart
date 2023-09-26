import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/feature/news/data/news_article.dart';
import 'package:news_app/feature/news/views/news_detail_page.dart';
import 'package:news_app/network/network_request.dart';

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({super.key});

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Scaffold(
        appBar: AppBar(title: const Text("My News Page")),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              NetworkRequest.fetchNewsData();
            });
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
                          player.play(AssetSource("audio/sound.wav"));
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
                                  // user loadingBuilder with image
                                  if (article.urlToImage != null)
                                    CachedNetworkImage(
                                      imageUrl: article.urlToImage!,
                                      placeholder: (context, url) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                                height: 300,
                                                width: 400,
                                                color: Colors.grey),
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ]),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
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
