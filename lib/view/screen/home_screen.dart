import 'package:bloc_communication/bloc/cubit/counter_cubit.dart';
import 'package:bloc_communication/bloc/internet/internet_cubit.dart';
import 'package:bloc_communication/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final Color color;

  const HomeScreen({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //if use subscription, ignore this BlocListener
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected &&
            state.connectionType == ConnectionType.wifi) {
          BlocProvider.of<CounterCubit>(context).increment();
        } else if (state is InternetConnected &&
            state.connectionType == ConnectionType.mobile) {
          BlocProvider.of<CounterCubit>(context).decrement();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.color,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<InternetCubit, InternetState>(
                  builder: (context, state) {
                    if (state is InternetConnected &&
                        state.connectionType == ConnectionType.wifi) {
                      return Text(
                        'Wifi',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.green),
                      );
                    } else if (state is InternetConnected &&
                        state.connectionType == ConnectionType.mobile) {
                      return Text('Mobile', style: Theme
                          .of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.red),);
                    } else if (state is InternetDisconnected) {
                      return Text('Disconnected', style: Theme
                          .of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.grey),);
                    }
                    return CircularProgressIndicator();
                  }),
              SizedBox(
                height: 10,
              ),
              BlocConsumer<CounterCubit, CounterState>(
                listener: (context, state) {
                  if (state.wasIncremented == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Incremented"),
                      duration: Duration(milliseconds: 900),
                    ));
                  } else if (state.wasIncremented == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Decremented"),
                      duration: Duration(milliseconds: 900),
                    ));
                  }
                },
                builder: (context, state) {
                  return Text(
                    state.counterValue.toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 60),
                  );
                },
              ),
              /*SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'btn1',
                  onPressed: () {
                    BlocProvider.of<CounterCubit>(context).increment();
                  },
                  child: Icon(Icons.add),
                  tooltip: 'Increment',
                ),
                FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () {
                    BlocProvider.of<CounterCubit>(context).decrement();
                  },
                  child: Icon(Icons.remove),
                  tooltip: 'Decrement',
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),*/
              MaterialButton(
                  color: widget.color,
                  textColor: Colors.white,
                  child: Text('Go to Second Page'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/second');
                  }),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: widget.color,
                  textColor: Colors.white,
                  child: Text('Go to Third Page'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/third');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
