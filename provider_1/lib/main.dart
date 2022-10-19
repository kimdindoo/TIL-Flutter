import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_1/fish_model.dart';
import 'package:provider_1/seafish_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              FishModel(name: 'Salmon', number: 10, size: 'big'),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SeaFishModel(name: 'Tuna', tunaNumber: 0, size: 'middle'),
        ),
      ],
      child: MaterialApp(
        home: FishOrder(),
      ),
    );
  }
}

class FishOrder extends StatelessWidget {
  const FishOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fish name: ${Provider.of<FishModel>(context).name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            High()
          ],
        ),
      ),
    );
  }
}

class High extends StatelessWidget {
  const High({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyA is located at high place',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyA()
      ],
    );
  }
}

class SpicyA extends StatelessWidget {
  const SpicyA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fish number: ${Provider.of<FishModel>(context).number}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        Text(
          'Fish size: ${Provider.of<FishModel>(context).size}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Middle()
      ],
    );
  }
}

class Middle extends StatelessWidget {
  const Middle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyB is located at middle place',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyB()
      ],
    );
  }
}

class SpicyB extends StatelessWidget {
  const SpicyB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tuna number: ${Provider.of<SeaFishModel>(context).tunaNumber}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        Text(
          'Tuna size: ${Provider.of<SeaFishModel>(context).size}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<SeaFishModel>(context, listen: false)
                .changeSeaFishNumber();
          },
          child: Text('Sea fish number'),
        ),
        SizedBox(
          height: 20,
        ),
        Low(),
      ],
    );
  }
}

class Low extends StatelessWidget {
  const Low({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyC is located at low place',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyC()
      ],
    );
  }
}

class SpicyC extends StatelessWidget {
  const SpicyC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'number: ${Provider.of<FishModel>(context).number}',
        style: TextStyle(
            fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
      ),
      Text(
        'size: ${Provider.of<FishModel>(context).size}',
        style: TextStyle(
            fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<FishModel>(context, listen: false).changeFishNumber();
        },
        child: Text('Change fish number'),
      ),
    ]);
  }
}
