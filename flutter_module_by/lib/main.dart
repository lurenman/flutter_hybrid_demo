import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

void main() {
  ///这里的CustomFlutterBinding调用务必不可缺少，用于控制Boost状态的resume和pause
  CustomFlutterBinding();
  runApp(MyApp());
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
  /// 其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
  /// 那么只需要像下面这样写成 [CupertinoPageRoute] 即可
  /// (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)
  ///
  /// 注意，如果需要push的时候，两个页面都需要动的话，
  /// （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
  /// 那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
  /// 简单来说，就两个页面都是CupertinoPageRoute就好
  /// 如果用MaterialPageRoute的话同理

  Map<String, FlutterBoostRouteFactory> routerMap = {
    'mainPage': (RouteSettings settings, String? uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            String? data = map['data'] as String?;
            return MainPage(
              data: data,
            );
          });
    },
    'simplePage': (RouteSettings settings, String? uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map =
                settings.arguments as Map<String, dynamic>;
            String? data = map['data'] as String?;
            return SimplePage(
              data: data,
            );
          });
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func =
        routerMap[settings.name] as FlutterBoostRouteFactory?;
    // 检查func是否为null
    if (func == null) {
      // 处理路由未找到的情况，例如返回一个null路由或者抛出一个异常
      return null; // 或者 throw new RouteNotFoundException();
    }

    // 如果func不是null，则调用它并返回结果
    return func(settings, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: true,

      ///必须加上builder参数，否则showDialog等会出问题
      builder: (_, __) {
        return home;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Object? data});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Main Page')),
    );
  }
}

class SimplePage extends StatefulWidget {
  final Object? data;

  const SimplePage({this.data});

  @override
  State<StatefulWidget> createState() {
    return _SimpleState();
  }
}

class _SimpleState extends State<SimplePage> {
  @override
  Widget build(BuildContext context) {
    String displayedData = widget.data?.toString() ?? 'No Data';
    return Container(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'SimplePage${displayedData}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('SecondActivity',
                        arguments: {'data': 'hello natvie'});
                  },
                  child: Text(
                    "跳转原生SecondActivity",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
