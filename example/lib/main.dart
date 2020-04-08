import 'package:example/reducer.dart';
import 'package:example/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

void main() {
  final store = Store<CounterState>(CounterReducer.reduce,
      initialState: CounterState(), middleware: [futureMiddleware]);
  FutureReducerDefaults.pendingReducer =
      <S, A>(S prevState, FuturePendingAction<A> action) {
    return prevState;
  };
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<CounterState> store;

  MyApp({@required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CounterState>(
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
    return StoreConnector<CounterState, CounterViewModel>(
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

  factory CounterViewModel.fromStore(Store<CounterState> store) {
    return CounterViewModel(
      counterValue: store.state.value,
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

S meraBachchaReducer<S, A>(S prevState, FuturePendingAction<A> action) {
  return prevState;
}
