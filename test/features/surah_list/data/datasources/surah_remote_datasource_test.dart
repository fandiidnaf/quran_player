import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player/core/constants/api_constant.dart';
import 'package:quran_player/core/error/failures.dart';
import 'package:quran_player/features/surah_list/data/datasources/surah_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late SurahRemoteDataSourceImpl dataSource;
  late MockDio dio;

  setUp(() {
    dio = MockDio();
    dataSource = SurahRemoteDataSourceImpl(dio);
  });

  Response<dynamic> response(dynamic data, {int statusCode = 200}) => Response(
    requestOptions: RequestOptions(path: ApiConstants.surahListEndpoint),
    data: data,
    statusCode: statusCode,
  );

  const Map<String, Object> okJson = {
    'code': 200,
    'status': 'OK',
    'data': [
      {
        'number': 1,
        'name': 'سُورَةُ الفَاتِحَةِ',
        'englishName': 'Al-Faatiha',
        'englishNameTranslation': 'The Opening',
        'numberOfAyahs': 7,
        'revelationType': 'Meccan',
      },
    ],
  };

  group('getAllSurahs', () {
    test('returns a list of SurahModel on a 200 response', () async {
      when(
        () => dio.get(ApiConstants.surahListEndpoint),
      ).thenAnswer((_) async => response(okJson));

      final result = await dataSource.getAllSurahs();

      expect(result, hasLength(1));
      expect(result.first.latinName, 'Al-Faatiha');
      expect(result.first.number, 1);
    });

    test('throws ServerFailure when the API code is not 200', () async {
      when(
        () => dio.get(ApiConstants.surahListEndpoint),
      ).thenAnswer((_) async => response({'code': 404, 'data': []}));

      expect(() => dataSource.getAllSurahs(), throwsA(isA<ServerFailure>()));
    });

    test('throws NetworkFailure on a DioException', () async {
      when(() => dio.get(ApiConstants.surahListEndpoint)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiConstants.surahListEndpoint),
          message: 'timeout',
        ),
      );

      expect(() => dataSource.getAllSurahs(), throwsA(isA<NetworkFailure>()));
    });
  });
}
