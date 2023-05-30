import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter/article.dart';
import 'package:testing_flutter/news_change_notifier.dart';
import 'package:testing_flutter/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test('Initial values are correct', () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'title1', content: 'description1'),
      Article(title: 'title2', content: 'description2'),
      Article(title: 'title3', content: 'description3'),
    ];

    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer((_) async => articlesFromService);
    }

    test('Gets articles using the NewsService', () async {
      arrangeNewsServiceReturns3Articles();

      await sut.getArticles();

      verify(() => mockNewsService.getArticles()).called(1);
    });

    test('Sets isLoading to true when called', () async {
      arrangeNewsServiceReturns3Articles();
      final future = sut.getArticles();
      expect(sut.isLoading, true);

      await future;

      expect(sut.articles, articlesFromService);
      expect(sut.isLoading, false);
    });
  });
}
