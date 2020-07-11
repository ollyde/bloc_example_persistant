import 'dart:async';

import 'package:bloctest/counter_bloc.dart';
import 'package:bloctest/custom_hydrated_bloc_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await CustomHydratedBlocStorage.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * BlocProvider or MultiBlocProvider is at the root of the app. 
     * Above Material. We only use the provider once.
     */
    return BlocProvider(
      create: (BuildContext context) => counterBlock,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  }

  _logCounter() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      print('Counter log : ' + counterBlock.state.total.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      /**
       * Bloc builder is the dependancy injection. We do not pass blocs down, that is dumb.
       */
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
                    // This will run after the updates. Great for navigation etc.
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _logCounter();
                    });
                    context.bloc<CounterBloc>().add(IncreaseCount(1));
                    context.bloc<CounterBloc>().add(IncreaseCount(1));
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
