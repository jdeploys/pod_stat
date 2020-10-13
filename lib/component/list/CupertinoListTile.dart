import 'package:flutter/cupertino.dart';

class CupertinoListTile extends StatefulWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final Function onTap;

  const CupertinoListTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  _StatefulStateCupertino createState() => _StatefulStateCupertino();
}

class _StatefulStateCupertino extends State<CupertinoListTile> {
  @override
  Widget build(BuildContext context) {
    var rowChildren = <Widget>[];
    // Row의 첫번째 자식은 null이 될 수 없음
    if (widget.leading != null) {
      rowChildren.add(widget.leading);
    }

    rowChildren.add(SizedBox(width: 20));
    rowChildren.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title,
            style: TextStyle(
              fontSize: 25,
            )),
        widget.subtitle != null
            ? Text(widget.subtitle,
                style: TextStyle(
                  fontSize: 20,
                ))
            : SizedBox.shrink(),
      ],
    ));

    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: rowChildren,
              ),
              widget.trailing,
            ],
          ),
        ));
  }
}
