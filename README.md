# sampleBootApp
Examples of typical iApp additional functions (in-App purchases, advertising, how to use, etc.).

## Features
* In the App start-up sequence. It is divided, the first boot after installation, migration, usually start-up.
* Advertising (Admob) display. Including a subtle reduction of TableView.
* in-App purchasing process. It is called the EBPurchase.
* Written in HTML, how to use manual.
* In the video, how to use manual. Bundled video files and YouTube reference.
* English and Japanese of the sample implementation.

## Install and Setting
1. $pod install
2. Change sampleBootApp-Prefix.pch, as below.
* Do not forget. To use the pch file, TARGETS -> Build Setting -> Apple LLVM7.0-Language "Prefix Header" to set the "sampleBootApp-Prefix.pch".
* _MyApp_APPLE_ID to your (App) Apple ID.
* AUTHOR_MAILADDER to your contact mail address.
* PERCHASE_ID to the product ID of the in-App purchase.
* MY_AD_UNIT_ID to admob Ad Unit ID. (Now, we set Google sample code).
* MY_VIDEO_URL to the URL of your YouTube videos.
* If you use UITabbar, please delete the comments out of IS_TAB_BAR.
* If you use UIToolbar, please delete the comments out of IS_TOOL_BAR. (toolbar and tabbar, can not be used at the same time).
* If you wish to simulation of Ad display, please delete the comments out of AD_TEST_TIMER.
3. UD_LOADED_ONCE and UD_LOADED_ONCE_PREVIOS.
* UD_LOADED_ONCE, we will put the version name of the release of this time. UD_LOADED_ONCE_PREVIOS puts the version name that is currently in circulation. String entering every release I will in turn shift.
4. Change Info.plist
* Do not forget. In iOS9 later, in Info.plist, "App Transport Security Settings" -> "Allow Arbitrary Loads", must have a value YES setting.
5. Bitcode
* This is also not forget. If you are installing on a real machine in iOS9 later, please disable the Bitcode. TARGETS -> Build Setting -> Build Options "Enable Bitcode" to set NO.

## Change from previous version
* Add iPad support. 
* Support the rotation. Only in the landscape is to stop the ads.
* Added Google sample AD_UNIT_ID. You can ads experiment.

## Limitations and Known issues 
* It is strange resolution in iPad pro.
* Mail, iTunes reviews and Web video of initial message do not work in the simulator. To work in the real machine.
* "Settings -> Restrictions -> in-App Purchases" decision of  might not work (PopUpPurchaseViewController). Actual harm is not, but the message is strange.
* The migration path is an example between the two generations. If over many generations, you will still need a logic of inter-generational. Simply, it may be to list the "UD_LOADED_ONCE" key of each generation (I will have to do so).

## License
Distributed under the MIT License.

## Author
If you wish to contact me, email at: age.products14@gmail.com


