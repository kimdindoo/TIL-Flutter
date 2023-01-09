import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riot_api/const/data.dart';
import 'package:riot_api/model/UserModel.dart';

class UserRepository {
  static Future<void> fetchData() async {
    final response = await Dio().get(
        'https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/김딘두',
        options: Options(headers: {
          'X-Riot-Token': serviceKey
        }));
    print(response.data);
  }
}
