// 에어팟의 연결 상태를 관리
import 'package:flutter/cupertino.dart';

class PodStatus with ChangeNotifier {
  // data
  // 에어팟 연결 상태 확인
  bool _isConnected = false;
  // 가능하다면 연결된 제품이 에어팟인지 블루투스 기기인지 판별
  bool isConnectedAirPods = false;
  // 에어팟 배터리 상태 가져오기
  int leftBatteryPercent = 0;
  int rightBatteryPercent = 0;
  // 에어팟 배터리 상태 갱신 마지막 시간
  DateTime batteryRefreshTime;
  // 가능하다면 에어팟 케이스 배터리 상태 포함
  int caseBatteryPercent = 0;

  set isConnected(bool isConnected) {
    this._isConnected = isConnected;
    notifyListeners();
  }

  bool get isConnected => _isConnected;
}