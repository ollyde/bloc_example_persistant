import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloctest/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _logCounter();
    asyncInit();
  }

  asyncInit() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path);

    // Timer.periodic(Duration(milliseconds: 1500), (timer) {
    //   counterBlock.add(CounterEvent.increment);
    // });
  }

  _logCounter() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      print('Counter log : ' + counterBlock.state.total.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => counterBlock,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BlocBuilder<CounterBloc, CounterState>(
          bloc: counterBlock,
          builder: (context, count) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    count.total.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // counterBlock.add(CounterEvent.increment);
                      context.bloc<CounterBloc>().add(IncreaseCount(Random().nextInt(10)));
                      _logCounter();
                    },
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
