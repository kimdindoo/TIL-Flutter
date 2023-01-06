import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riot_api/model/UserModel.dart';

class UserRepository {
  static Future<void> fetchData() async {
    final response = await Dio().get(
        'https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/김딘두',
        options: Options(headers: {
          'X-Riot-Token': 'RGAPI-2bd4bbf5-56ad-485d-ae8b-4cc02e1364f0'
        }));
    print(response.data);
  }
}
