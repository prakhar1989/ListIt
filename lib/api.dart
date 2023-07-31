import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'prompts.dart';

const region = 'us-west2';
const instanceId = 'palm-secure-backend';
const functionName = "ext-$instanceId-post";

Future<dynamic> post(String prompt) async {
  try {
    var params = _constructRequestParams(prompt);
    final response = await FirebaseFunctions.instanceFor(region: region)
        .httpsCallable(functionName)
        .call(params);
    return response.data;
  } on Exception catch (err) {
    debugPrint(err.toString());
  }
}

Future<List<String>> getListAndTip(input) async {
  final prompt = promptBuilder.constructPrompt(input);
  final results = await post(prompt);
  final String tasks = results["candidates"][0]["output"];
  final List<String> tasksAndTip = tasks.split("\n");
  final tip = tasksAndTip.removeLast().split(":").last;
  tasksAndTip.add(tip);
  return tasksAndTip;
}

Map<String, dynamic> _constructRequestParams(String prompt,
    {double temperature = 0.25}) {
  return {
    "method": "generateText",
    "model": "text-bison-001",
    "prompt": {"text": prompt},
    "temperature": temperature
  };
}
