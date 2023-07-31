# Divide And Conquer

A simple app that uses LLMs to help you break down complex goals and tasks into smaller subtasks. This is a flutter port of the [generative-ai](https://github.com/google/generative-ai-docs/tree/main/demos/palm/web/list-it) example by Google.

<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/649249/257088076-bb3433a9-0bee-4fa0-b501-5e5cbc1977e6.png" height="600">

## Getting Started

Setup Firebase as per the directions below to. Once that's done, [follow the instructions](https://firebase.google.com/docs/flutter/setup?platform=android) for setting up FlutterFire to complete the integration.

## Firebase Setup

To set up Firebase:

1. Create a Firebase project at https://console.firebase.google.com.

2. Add a web app to your Firebase project and follow the on-screen instructions to add or install the Firebase SDK.

3. Go to https://console.cloud.google.com and select your Firebase project. Then go to _Security > Secret Manger_ using the left-side menu and make sure the Secret Manager API is enabled.

4. If you don’t already have an API key for the PaLM API, follow [these instructions](https://developers.generativeai.google/tutorials/setup) to get one.

5. Install the Call PaLM API Securely extension from the [Firebase Extensions Marketplace](https://extensions.dev/extensions). Follow the on-screen instructions to configure the extension.

    __NOTE__: Your project must be on the Blaze (pay as you go) plan to install the extension.

6. Enable anonymous authentication for your Firebase project by returning to https://console.firebase.google.com and selecting _Build_ in the left panel. Then go to _Authentication > Sign-in method_ and make sure _Anonymous_ is enabled.

7. Return to https://console.cloud.google.com and select your Firebase project. Click _More Products_ at the bottom of the left-side menu, then scroll down and click _Cloud Functions_. Select each function and then click _Permissions_ at the top. Add `allUsers` to the Cloud Functions Invoker role.
