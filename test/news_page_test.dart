import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:testing_flutter/article.dart';
import 'package:testing_flutter/news_change_notifier.dart';
import 'package:testing_flutter/news_page.dart';
import 'package:testing_flutter/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: 'title1', content: 'description1'),
    Article(title: 'title2', content: 'description2'),
    Article(title: 'title3', content: 'description3'),
  ];

  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async => articlesFromService);
  }

  void arrangeNewsServiceReturns3ArticlesAfter2SecondWait() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;
    });
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News app',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets('title is displayed', (WidgetTester widgetTester) async {
    arrangeNewsServiceReturns3Articles();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    expect(find.text('News'), findsOneWidget);
  });

  testWidgets('loading indicator is displayed while waiting for articles',
      (WidgetTester widgetTester) async {
    arrangeNewsServiceReturns3ArticlesAfter2SecondWait();

    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await widgetTester.pumpAndSettle();
  });

  testWidgets('articles are displayed', (WidgetTester widgetTester) async {
    arrangeNewsServiceReturns3Articles();

    await widgetTester.pumpWidget(createWidgetUnderTest());

    await widgetTester.pump();

    for (final article in articlesFromService) {
      expect(find.text(article.title), findsOneWidget);
      expect(find.text(article.content), findsOneWidget);
    }
  });
}
