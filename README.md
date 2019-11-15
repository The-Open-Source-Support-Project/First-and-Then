# first_then

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

for app signing delete the .jks file and make a new one with the following at the command line:

On Mac/Linux, use the following command:
```keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key```
On Windows, use the following command:
```keytool -genkey -v -keystore c:/Users/USER_NAME/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key```

then Create a file named <app dir>/android/key.properties that contains a reference to your keystore:

```storePassword=<password from previous step>
   keyPassword=<password from previous step>
   keyAlias=key
   storeFile=<location of the key store file, such as /Users/<user name>/key.jks>```
