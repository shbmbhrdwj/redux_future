import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class Increment {}

int counterReducer(int state, dynamic action) {
  if (action is FutureSuccessAction<Increment, int>) {
    return state + 1;
  }

  return state;
}

void main() {
  final store = Store<int>(counterReducer,
      initialState: 0, middleware: [futureMiddleware]);

  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<int> store;

  MyApp({@required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<int>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<int, CounterViewModel>(
        converter: (store) => CounterViewModel.fromStore(store),
        builder: (context, viewModel) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '${viewModel.counterValue}',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: viewModel.callback,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ));
        });
  }
}

class CounterViewModel {
  int counterValue;
  VoidCallback callback;

  CounterViewModel({this.counterValue, this.callback});

  factory CounterViewModel.fromStore(Store<int> store) {
    return CounterViewModel(
      counterValue: store.state,
      callback: () => store.dispatch(
        FutureAction<Increment, int>(
          future: Future.delayed(
            Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
