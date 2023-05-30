import 'package:flutter/material.dart';
import 'package:testing_flutter/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top,
          bottom: mediaQuery.padding.bottom,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Text(
              article.title,
            ),
            const SizedBox(height: 8),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}
