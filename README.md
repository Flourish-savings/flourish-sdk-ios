[<img width="400" src="https://github.com/Flourish-savings/flourish-sdk-flutter/blob/main/images/logo_flourish.png?raw=true"/>](https://flourishfi.com)
<br>
<br>
# Flourish SDK iOS

This iOS library will allow the communication between the visual implementation of Flourish functionality.
<br>
<br>

Table of contents
=================

<!--ts-->
* [Getting Started](#getting-started)
    * [About the SDK](#about-the-sdk)
    * [Using the SDK](#using-the-sdk)
* [Events](#events)
* [Examples](#examples)
<!--te-->
<br>

## Getting Started
___

### Adding Flourish to your project

In your project configuration, add the repository url of Flourish iOS library to your package dependencies.
```
https://github.com/Flourish-savings/flourish-sdk-ios
```

### SDK internal requirements

To use this SDK, you will need these elements:

- partnerId: a unique identifier that will be provided by Flourish
- secret: a string that represents a key, also provided by Flourish
- costumer_code: a string that represents an identifier of yourself

This library can be run in two different environments:

- staging: In this environment, you can test the functionality without impacting any real data
- production: this environment is for running the app with the real data
  <br>
  <br>

### About the SDK

The integration with us works as follows, the client authenticates himself in our backend
and we return an access token that allows him to load our webview, given that,
the sdk serves to encapsulate and help in loading this webview.

### Using the SDK
___

### 1 - Initialization

##<span style="color:red;">IMPORTANT❗</span>


<div style="border: 1px solid grey; padding: 10px;">

**For the flow to work correctly and for us to have the metrics correctly to show our value, it is extremely important to initialize our SDK when opening your App, for example at startup or on the home screen. The most important thing is that it is not initialized at the same time as opening our module.**

</div>

___

First foremost, it is necessary to initialize the Library providing the variables: `partnerId`, `secret`, `env`, `language` and `customerCode`.

```swift
let flourishSdkManager = FlourishSdkManager(
    customerCode: "HERE_YOU_WILL_USE_YOUR_CUSTOMER_CODE",
    partnerUuid: "HERE_YOU_WILL_USE_YOUR_PARTNER_ID",
    partnerSecret: "HERE_YOU_WILL_USE_YOUR_SECRET",
    environment: Environment.staging,
    language: Language.en
)

flourishSdkManager.initialize(completion: { _ in  })
```

### 2 - Open Flourish module

Finally you need to use our view component by passing the previously initialized Flourish SdkManager
```swift
var body: some View {
    FlourishSdkView(flourishSdkManager: flourishSdkManager).edgesIgnoringSafeArea(.all)
}
```

## EVENTS
___

You can also register for some events to know when something happens within our platform.

You can listen to a specific already mapped event.

### Listen our mapped events

We have some events already mapped that you can listen to separately

For example, if you need know when ou Trivia feature finished, you can listen to the "TriviaGameFinishedEvent"

The first thing you need to do is create a class that extends our protocol called `FlourishEvent` and then override the event method you need to listen to.
```swift
class FlourishEventDelegate: FlourishEvent {
    func onTriviaGameFinishedEvent(triviaFinishEvent: FlourishSDK.TriviaFinishEvent) {
        print("Received TriviaGameFinishedEvent on ExampleApp: \(triviaFinishEvent)")
    }
}
```

After creating this class, you need to pass it to initialization as well

```swift
let flourishEventDelegate = FlourishEventDelegate()
flourishSdkManager.initialize(completion: { _ in  })
```


you can find our all mapped events here:
https://github.com/Flourish-savings/flourish-sdk-ios/tree/main/Sources/FlourishSDK/events


### Events to listen
here you have all events we will return

| Event name      | Description                                                                         |
|-----------------|-------------------------------------------------------------------------------------|
| BACK_BUTTON_PRESSED | When you need to know when the user clicks on the back menu button on our platform. |
| TRIVIA_GAME_FINISHED  | When you need to know when the user finishes a Trivia game on our platform.         |
| TRIVIA_CLOSED  | When you need to know when the user closed the Trivia game on our platform.         |
| REFERRAL_COPY          | When you need to know when the user copy the referral code to the clipboard area.   |
| GIFT_CARD_COPY  | When you need to know when the user copy the Gift code to the clipboard area.       |
| HOME_BANNER_ACTION      | When you need to know when the user clicks on the home banner.                      |
| MISSION_ACTION     | When you need to know when the user clicks on a mission card                        |
| ERROR      | When you need to know when a error happened.                                        |


## Examples
We have an example app to show how to integrate with us:

https://github.com/Flourish-savings/flourish-sdk-ios-example
<br>
