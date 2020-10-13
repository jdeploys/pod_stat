import 'dart:async';

import 'package:bluetoothadapter/bluetoothadapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pod_stat/component/gatt/GattValue.dart';
import 'package:uuid/uuid.dart';

/// 에어팟의 연결 상태를 관리
class PodStatus with ChangeNotifier {
  final BleManager _bleManager = BleManager();
  final Bluetoothadapter _adaptor = Bluetoothadapter();

  // data
  /// 에어팟 연결 상태 확인
  bool _isConnected = false;

  /// 가능하다면 연결된 제품이 에어팟인지 블루투스 기기인지 판별
  bool isConnectedAirPods = false;

  /// 에어팟 배터리 상태 가져오기
  int leftBatteryPercent = 0;
  int rightBatteryPercent = 0;

  /// 에어팟 배터리 상태 갱신 마지막 시간
  DateTime batteryRefreshTime;

  /// 가능하다면 에어팟 케이스 배터리 상태 포함
  int caseBatteryPercent = 0;

  /// 블루투스 연결 관련 저장 데이터
  Peripheral _peripheral;
  Uuid _uuid = Uuid();
  String _connectedDeviceAddress;

  Future<void> init() async {
    _peripheral = null;
    if (_bleManager != null) {
      _bleManager.destroyClient();
    }
    await _adaptor.initBlutoothConnection(_uuid.v4());
    await _bleManager.createClient();
  }

  void updateConnectFromBLE() async {
    await init();

    /// 권한 확인
    await checkPermission();

    /// 이전에 연결된 에어팟 검사
    await setConnectedDeviceAddress();
    await startScan();
  }

  Future<void> checkPermission() async {
    var locationStatus = await Permission.location.status;
    if (locationStatus.isUndetermined) {
      await Permission.location.request();
    }
    var contactStatus = await Permission.contacts.status;
    if (contactStatus.isUndetermined) {
      await Permission.contacts.request();
    }
  }

  Future<void> startScan() async {
    // ble 는 항상 커져있다고 가정
    if (_connectedDeviceAddress != null) {
      print('맥 주소 $_connectedDeviceAddress');
      _peripheral = _bleManager.createUnsafePeripheral(_connectedDeviceAddress);
      connect();
      return;
    }

    _bleManager.startPeripheralScan(uuids: [
      batteryServiceUUID,
      batteryMeasurementUUID,
    ]).listen((scanResult) {
      // FIXME: 완전 임시 코드
      if (scanResult.peripheral.name != null &&
          scanResult.peripheral.name.toLowerCase().contains('airpods')) {
        print(
            '★★★ 찾음!! ${scanResult.peripheral.name}, RSSI ${scanResult.rssi}');
        _peripheral = scanResult.peripheral;
        _bleManager.stopPeripheralScan();

        connect();
      }
    });

    // 계속 진행 중이면 4초 후 차단
    new Timer(const Duration(milliseconds: 4000), () {
      _bleManager.stopPeripheralScan();
    });
  }

  Future<void> connect() async {
    print('DO CONNECT?');
    if (_peripheral == null) {
      print('NOT FOUND!');
      return;
    }

    _peripheral
        .observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      print('★★★ 연결 상태 감지 !!  ${_peripheral.identifier}'
          ' connection state is $connectionState');
    });

    bool connected = await _peripheral.isConnected();
    if (!connected) {
      print('NOT CONNECT');
      await _peripheral
          .connect(timeout: const Duration(milliseconds: 800))
          .catchError((e) {
        print('연결 오류 : $e');
        _peripheral.disconnectOrCancelConnection();
      }).then((_) {
        print('★★★ CONNECT!!! ${_peripheral.name}');

        checkService();
      });
    }
  }

  Future<void> checkService() async {
    print('왜안해요? checkService');
    await _peripheral.discoverAllServicesAndCharacteristics();
    List<Service> services =
        await _peripheral.services(); //getting all services
    print('★★★★★★!! $services');
    // await _peripheral.disconnectOrCancelConnection();
    List<Characteristic> char1 =
        await _peripheral.characteristics(batteryMeasurementUUID);
    print('★★★★★★!! $char1');
  }

  void watchBleState() async {
    BluetoothState currentState = await _bleManager.bluetoothState();
    // if (currentState == BluetoothState.POWERED_OFF) {
    //   bleManager
    //       .enableRadio();
    // }
    _bleManager.observeBluetoothState().listen((btState) {
      print(btState);
      //do your BT logic, open different screen, etc.
    });
  }

  void setConnectedDeviceAddress() async {
    List<BtDevice> devices = await _adaptor.getDevices();
    for (var device in devices) {
      if (device.name.toLowerCase().contains('airpods')) {
        _connectedDeviceAddress = device.address;
      }
    }
  }

  set isConnected(bool isConnected) {
    this._isConnected = isConnected;
    notifyListeners();
  }

  bool get isConnected => _isConnected;
}
