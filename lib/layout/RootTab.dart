import 'package:flutter/cupertino.dart';
import 'package:pod_stat/locale/LocaleConvert.dart';

class RootTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = Localizations.of<LocaleConvert>(context, LocaleConvert);

    // 탭 모양
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          // 메인
          BottomNavigationBarItem(
              label: lang.l('home'),
              icon: Icon(
                CupertinoIcons.headphones,
                size: 36.0,
              )),
          BottomNavigationBarItem(
            label: lang.l('setting'),
            icon: Icon(
              CupertinoIcons.cube,
              size: 36.0,
            ),
          ),
          BottomNavigationBarItem(
            label: lang.l('about'),
            icon: Icon(
              CupertinoIcons.drop,
              size: 36.0,
            ),
          )
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'),
              ),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Page 2 of tab $index'),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                child: const Text('Back'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}