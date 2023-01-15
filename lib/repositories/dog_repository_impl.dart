import 'dart:developer';
import 'package:dio/dio.dart';
import './dog_repository.dart';

class DogRepositoryImpl implements DogRepository {
  @override
  Future<String> getDog() async {
    try {
      final result = await Dio().get('https://random.dog/woof.json');
      return result.data['url'];
    } on DioError catch (e) {
      log('Erro', error: e);
      throw Exception('Erro ');
    }
  }
}
