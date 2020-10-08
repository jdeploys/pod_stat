// 에어팟의 연결 상태를 관리
import 'package:bluetoothadapter/bluetoothadapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pod_stat/component/gatt/GattValue.dart';
import 'package:uuid/uuid.dart';

class PodStatus with ChangeNotifier {
  final _uuid = Uuid().toString();
  final _adaptor = Bluetoothadapter();
  final FlutterBlue _blue = FlutterBlue.instance;

  // data
  // 에어팟 연결 상태 확인
  bool _isConnected = false;
  BluetoothDevice _connectedDevice;

  // 가능하다면 연결된 제품이 에어팟인지 블루투스 기기인지 판별
  bool isConnectedAirPods = false;

  // 에어팟 배터리 상태 가져오기
  int leftBatteryPercent = 0;
  int rightBatteryPercent = 0;

  // 에어팟 배터리 상태 갱신 마지막 시간
  DateTime batteryRefreshTime;

  // 가능하다면 에어팟 케이스 배터리 상태 포함
  int caseBatteryPercent = 0;

  // 블루투스 연결 관련 저장 데이터
  Map _scanResults;
  BluetoothService _watchService;
  BluetoothCharacteristic _watchCharacteristic;

  void updateConnectFromBLE() async {
    // 블루투스 ON/OFF
    // await _adaptor.initBlutoothConnection(_uuid);
    // _adaptor.checkBluetooth().then((value) => print(value.toString()));
    // List<BtDevice> devices = await _adaptor.getDevices();
    // for (var device in devices) {
    //   if (device.name.toLowerCase().contains('airpods')) {
    //     _connectedDevice = device;
    //   }
    // }
    //
    // if (_connectedDevice != null) {
    //   print('connected! ${_connectedDevice.address}');
    // }
  }

  void startScan() {
    _scanResults = new Map();

    _blue
        .scan(
      timeout: const Duration(seconds: 4),
    )
        .listen((scanResult) {
      print(scanResult.advertisementData.localName);
      if (scanResult.advertisementData.localName.startsWith('HX-')) {
        _scanResults[scanResult.device.id] = scanResult;
        notifyListeners();
      }
    });
  }

  void deviceConnect(BluetoothDevice device) async {
    _connectedDevice = device;
    print('연결 시도 : ${device.name}');
    await device.connect();

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      // Reads all characteristics
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        print('서비스 uuid : ${c.uuid.toString()}');
        if (c.uuid.toString() == batteryServiceUUID) {
          _watchService = service;
          _watchCharacteristic = c;
        }
      }
    });

    if (_watchService != null) {
      // 감시 설정
      await _watchCharacteristic.setNotifyValue(true);
      _watchCharacteristic.value.listen((value) {
        print(value);
      });
    }
  }

  set isConnected(bool isConnected) {
    this._isConnected = isConnected;
    notifyListeners();
  }

  bool get isConnected => _isConnected;
}
