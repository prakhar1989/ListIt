import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Sign in to call function
  await signIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List It',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'List It'),
    );
  }
}

typedef SuggestedItemCallback = void Function(String action);

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Thinking...", 
    style: Theme.of(context).textTheme.headlineMedium));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tasks = [];
  String? tip;
  String? mainTask;
  bool isLoading = false;

  handleClick(String action) async {
    setState(() {
      isLoading = true;
    });
    var results = await getListAndTip(action);
    setState(() {
      isLoading = false;
      debugPrint("got ${results.length} results");
      mainTask = action;
      tip = results.last.trim();
      tasks = List.from(results.take(results.length - 1));
    });
  }

  reset() {
    setState(() {
      tasks = [];
      tip = null;
      mainTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: tasks.isEmpty
          ? ZeroState(onSubmit: handleClick)
          : (isLoading ? const Loading() : TasksAndTipView(
              action: mainTask,
              tasks: tasks,
              tip: tip,
              onListClick: handleClick,
            )),
      floatingActionButton: tasks.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: reset,
              backgroundColor: Colors.lightGreenAccent,
              child: const Icon(Icons.restart_alt_rounded),
            ),
    );
  }
}

class TasksAndTipView extends StatelessWidget {
  const TasksAndTipView(
      {super.key,
      required this.action,
      required this.tasks,
      required this.tip,
      required this.onListClick});

  final String? action;
  final String? tip;
  final List<String> tasks;
  final SuggestedItemCallback onListClick;

  Widget taskItem(BuildContext context, String task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.green))),
      child: Row(
        children: [
          Expanded(
              child: Text("• $task",
                  style: Theme.of(context).textTheme.bodyLarge)),
          IconButton.outlined(
            color: Colors.green,
            onPressed: () {
              onListClick(task);
            },
            icon: const Icon(Icons.playlist_add),
          ),
        ],
      ),
    );
  }

  Widget buildTip(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.tips_and_updates_outlined, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text("Tip:$tip",
                    style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final tasksItems = tasks.map((task) => taskItem(context, task)).toList();
    if (tip != null) {
      tasksItems.add(buildTip(context));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            action!.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(flex: 1, child: ListView(children: tasksItems)),
      ],
    );
  }
}

class ZeroState extends StatelessWidget {
  const ZeroState({super.key, required this.onSubmit});

  final SuggestedItemCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "I want to ",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ListInput(
            onSubmitted: onSubmit,
          ),
          const SizedBox(height: 28),
          SuggestedItem(
            title: "Think about big events like...",
            action: "Move to a big city",
            onPressed: onSubmit,
          ),
          const SizedBox(height: 18),
          SuggestedItem(
            title: "or complex goals like...",
            action: "Write a memoir",
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class ListInput extends StatelessWidget {
  const ListInput({super.key, required this.onSubmitted});

  final SuggestedItemCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (input) {
        onSubmitted(input);
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(), hintText: "train for a marathon..."),
    );
  }
}

class SuggestedItem extends StatelessWidget {
  const SuggestedItem(
      {super.key,
      required this.title,
      required this.action,
      required this.onPressed});

  final String title;
  final String action;
  final SuggestedItemCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        OutlinedButton(
            onPressed: () {
              onPressed(action);
            },
            child: Text(action)),
      ],
    );
  }
}
