import 'package:flutter/material.dart';

class StatusModel {
  // 단계
  final int level;

  // 단계 이름
  final String label;

  // 주색상
  final Color primaryColor;

  // 어두운색상
  final Color darkColor;

  // 밝은색상
  final Color lightColor;

  // 폰트색상
  final Color detailfontColor;

  // 이모티콘 이미지
  final String imagePath;

  // 코멘트
  final String comment;

  // 미세먼지 최소치
  final double minFinedust;

  // 초미세먼지 최소치
  final double minUltraFineDust;

  // 오존 최소치
  final double minO3;

  // 이산화탄소 최소치
  final double minNO2;

  // 일산화탄소 최소치
  final double minCO;

  // 이황산가스 최소치
  final double minSO2;

  StatusModel({
    required this.level,
    required this.label,
    required this.primaryColor,
    required this.darkColor,
    required this.lightColor,
    required this.detailfontColor,
    required this.imagePath,
    required this.comment,
    required this.minFinedust,
    required this.minUltraFineDust,
    required this.minO3,
    required this.minNO2,
    required this.minCO,
    required this.minSO2,
  });

}