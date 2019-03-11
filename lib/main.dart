import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 GetIt getIt = new GetIt(); // Required for v4

void main() {
  getIt.registerSingleton<Counter>(Counter()); // Required for v4
  runApp(MyApp());
} 




class MyApp extends StatelessWidget {
  // Modify this based on the state management approach you choose. 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<CounterBloc>(
        bloc:CounterBloc(),
        child: MyHomePage5()
      ),
    );
  }
}





///// 5. BLoC


enum CounterEvent { increment }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}



class MyHomePage5 extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('bloc'),
          ),
          body: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                BlocBuilder(
                  bloc: _counterBloc,
                  builder: (BuildContext context, int count) {
                    return Text(
                      '${count}',
                      style: Theme.of(context).textTheme.display1,
                    );
                  }
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _counterBloc.dispatch(CounterEvent.increment),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), 
        );
  }
}


////// 4. Service Locator


class Counter {


  // NOTE Requires Rx 0.21, update your pubspec.yaml
  BehaviorSubject _counter = BehaviorSubject.seeded(0);

  get stream$ => _counter.stream;
  int get current => _counter.value;

  increment() { 
    _counter.add(current + 1);
  }

  builder() {
    
  }

}


// Counter counterService = Counter();




class MyHomePage4 extends StatelessWidget {

  final counter = getIt.get<Counter>();

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: AppBar(
            title: Text('Service Locator'),
          ),
          body: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                StreamBuilder(
                  stream: counter.stream$,
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    return Text(
                      '${snap.data}',
                      style: Theme.of(context).textTheme.display1,
                    );
                  }
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => counter.increment(),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), 
        );
  }
}





////// 3. Inherited Widget


class InheritedCounter extends InheritedWidget {
  final Map _counter = { 'val': 0 };
  final Widget child;

  InheritedCounter({ this.child }) : super(child: child);

  increment() { 
     _counter['val']++;
  }

  get counter => _counter['val'];

  @override
  bool updateShouldNotify(InheritedCounter oldWidget) => true;

  static InheritedCounter of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedCounter);
}



class MyHomePage3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

   return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        int counter = InheritedCounter.of(context).counter;
        Function increment = InheritedCounter.of(context).increment;

        return Scaffold(
          appBar: AppBar(
            title: Text('Inherited Widget'),
          ),
          body: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$counter',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setState(() => increment()),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), 
        );
      }
    );
  }
}




////// 2. StatefulBuilder

class MyHomePage2 extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => 
        Scaffold(
          appBar: AppBar(
            title: Text('StatefulBuilder'),
          ),
          body: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setState(() => _counter++),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), 
        )
    );
  }
}



////// 1. StatefulWidget

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
