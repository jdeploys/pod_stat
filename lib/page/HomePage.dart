import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pod_stat/component/list/CupertinoListTile.dart';
import 'package:pod_stat/locale/LocaleConvert.dart';
import 'package:pod_stat/store/PodStatus.dart';
import 'package:provider/provider.dart';

/// Page View 에서는 항상 CupertinoPageScaffold -> child 구성요소를 만든다고 가정한다.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = Localizations.of<LocaleConvert>(context, LocaleConvert);
    var status = Provider.of<PodStatus>(context);

    return ListView(
      children: [
        CupertinoButton(
          onPressed: status.updateConnectFromBLE,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/air_pods_pro.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            /// Info Card
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: Text(
                status.isConnected ? lang.l('connected') : lang.l('notConnected'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
          ),
        )),
        CupertinoListTile(
          title: lang.l('connectedAirPods'),
          trailing: CupertinoSwitch(
            value: status.isConnected,
            onChanged: (bool value) {
              status.isConnected = value;
            },
          ),
          onTap: () {
            status.isConnected = !status.isConnected;
          },
        )
      ],
    );
  }
}
