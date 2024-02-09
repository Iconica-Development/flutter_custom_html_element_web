import 'package:custom_html_element_web/custom_html_element.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';

@JS('onUpdateCount')
external set _onUpdateCount(void Function(dynamic) function);

// this is called every time the counter increases
void onUpdateCounter(count) {
  debugPrint(count.toString());
}

void main() {
  _onUpdateCount = allowInterop(onUpdateCounter);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int increment = 1;

  final controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: controller,
        itemBuilder: (context, value) {
          if (value == 10) {
            // we create only one HTML element for testing
            return CustomHtmlElement(
              width: 160,
              height: 90.0 + increment,
              tag: 'my-counter',
              id: 'my-id',
              // by providing the controller, the html element can update
              // every time the scroll controller updates.
              layoutObservable: controller,
              attributes: {
                'data-initial-count': '12',
                'data-increment-amount': '$increment',
                'data-on-count-changed': 'onUpdateCount',
              },
            );
          }
          if (value.isEven) {
            return Container(
              height: 100,
              width: 100,
              color: Colors.red,
            );
          }
          return Container(
            height: 100,
            width: 100,
            color: Colors.blue,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          setState(() {
            increment += 1;
          });
        },
      ),
    );
  }
}
