class PromptBuilder {
  final String? preamble;
  final List<String> prefixes;
  final List<List<String>> examples;

  PromptBuilder({
    this.preamble,
    this.prefixes = const [],
    this.examples = const [],
  });

  String constructPrompt(String input) {
    var lines = <String>[];
    if (preamble != null) {
      lines.add(preamble!);
    }

    var allExamples = List.from(examples);
    allExamples.add([input, " "]);

    for (var example in allExamples) {
      for (var j = 0; j < example.length; j++) {
        final prefix = prefixes[j];
        final value = example[j];
        lines.add('$prefix $value');
      }
    }
    ;

    return lines.join('\n');
  }
}

const _prefixes = [
  'You want to:',
  'Here is a list of tasks you might need to complete for that activity:',
  'Something additional to consider that newcomers may overlook:'
];

var _examples = [
  [
    'go camping',
    [
      'Choose a campsite that suits your needs and preferences.',
      'Pack clothing suitable for the climate and activities you have planned.',
      'Bring a tent or other shelter that will keep you safe and comfortable.',
      'Plan and pack your meals, snacks, and cooking supplies.',
      'Bring enough water or a way to purify it.'
    ].join('\n'),
    'Food attracts wildlife! Never leave food, trash, or other scented products inside your tent.'
  ],
  [
    'buy a house',
    [
      'Consider the neighborhood, proximity to amenities, and commute times.',
      'Figure out how much space you need.',
      'Research mortgage options and get pre-approved before house hunting.',
      'Determine if there is sufficient parking for your needs.',
      'Consider the potential resale value of the property.'
    ].join('\n'),
    'When budgeting, make sure to account for unexpected expenses such as repairs or upgrades, as these can significantly impact the total cost.'
  ],
  [
    'plan a family vacation',
    [
      'Choose a destination that suits the interests of everyone in the family.',
      'Make a packing list and ensure that everyone has what they need for the trip.',
      "Plan how you will get to and from your destination and how you will get around once you're there.",
      'Research dining options and consider any dietary restrictions or preferences.',
      'Bring books, games, or other entertainment for the journey and downtime.'
    ].join('\n'),
    'When planning activities, remember to allow space for downtime so you can relax and recharge.'
  ],
  [
    'apply to a job',
    [
      'Research the company and the position you are applying for.',
      'Review the job requirements and ensure that you meet them.',
      'Ensure that your resume or CV is up-to-date and tailored to the position.',
      'Determine your salary requirements before the interview and be prepared to negotiate if necessary.',
      'Send a thank-you note or email after the interview to express your appreciation and reiterate your interest in the position.'
    ].join('\n'),
    "Make sure to look into the company's work culture and values, as this could have a large impact on your job satisfaction if you are hired."
  ],
  [
    'go on a first date',
    [
      "Choose a location that is convenient for both people and suits the vibe that you're after.",
      'Plan an activity that allows for conversation and helps you get to know each other.',
      'Dress appropriately for the activity and location.',
      'Prepare some conversation topics to avoid awkward silence and ensure interesting conversation.',
      'Put your phone on silent to avoid distractions during the date.'
    ].join('\n'),
    "Keep your expectations reasonable and remember that a first date is just the beginning of getting to know someone. Not all first dates lead to a second date or a relationship, and that's ok!"
  ]
];

var promptBuilder = PromptBuilder(
  preamble: null,
  prefixes: _prefixes,
  examples: _examples,
);
