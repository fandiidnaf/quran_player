import 'package:dio/dio.dart';

import '../../../../core/constants/api_constant.dart';
import '../../../../core/error/failures.dart';
import '../models/surah_model.dart';

abstract class SurahRemoteDataSource {
  Future<List<SurahModel>> getAllSurahs();
}

class SurahRemoteDataSourceImpl implements SurahRemoteDataSource {
  final Dio _dio;

  const SurahRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SurahModel>> getAllSurahs() async {
    try {
      final response = await _dio.get(ApiConstants.surahListEndpoint);
      final data = response.data as Map<String, dynamic>;

      if (data['code'] != 200) {
        throw ServerFailure('API returned code ${data['code']}');
      }

      final List<dynamic> items = data['data'] as List<dynamic>;
      return items
          .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkFailure(e.message ?? 'Network error');
    }
  }
}
