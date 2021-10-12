# Orb Demo

This app demonstrates how to integrate and launch the Orb SDK in a Flutter app.

## Getting started

### Install Android Studio
Follow the Android Studio installation instructions for your development
environment:

- [Windows/macOS/Linux/ChromeOs](https://developer.android.com/studio/install)


### Install Flutter
Follow the Flutter installation instructions for your development environment:

- [Windows](https://flutter.dev/docs/get-started/install/windows)
- [macOS](https://flutter.dev/docs/get-started/install/macos)
- [Linux](https://flutter.dev/docs/get-started/install/linux)
- [ChromeOs](https://flutter.dev/docs/get-started/install/chromeos)

Check your Flutter installation:

```shell
which flutter
flutter doctor
```

### Clone the Orb SDK repo

Clone the [Orb SDK repo](https://github.com/meya-ai/orb-sdk) into the directory containing this repo 
such that the `orb-sdk` repo and this `orb-demo-flutter` repos are siblings in a parent directory:

```
parent/
  |-- orb-sdk/
  |-- orb-demo-flutter/
```

### Setup the Orb SDK

Run the following commands:

```shell
cd orb-sdk/orb/
flutter pub get
```

This will get all dependencies for the Orb SDK.

**Note**, you will need to run these commands every time a change occurs in `orb-sdk` repo e.g.
you checkout a different sdk version, or you made some manual changes.


### Build and run the Orb Demo

- Open Android Studio
- Select `Open an Existing Project`
- Navigate to the `orb-demo-flutter` directory
- Click `Open`

This will open the Orb Demo app and Android Studio will setup the project.

If you do not have a physical device connected or you do not have an Android Virtual Device configured,
then follow these instructions. Alternatively, you can use an iOS device or the iOS Simulator.


#### Create an Android Virtual Device (AVD)
- Go to `Tools > AVD Manager`
- Click `+ Create Virtual Device` at the bottom left
- From the `Phone` category, select a device e.g. `Pixel 3`
- Click `Next`
- Use the recommended release (you can customize this if you wish).
- Click `Next`
- Optionally set the `AVD Name`
- Click `Finish`
- From the `AVD Manager`, click the "Play" button of the device you've just 
  created.


#### Run the Orb Demo
Android Studio should automatically detect the device and create a new run configuration for it.

- Select the device you wish to target e.g. `Pixel 4 API 28`.
- Make sure the `main.dart` run configuration is selected.
- Click the "Play" button.
