# first_then

A simple easy to use First And Then board you can use well your out so you don't need to carry your board and all your visuals with you.

# License

all Software in the OSSP must fallow the basic MIT license + the fallow basic Rules

1. Applications must remain Free for individual/personal use.
2. Applications must remain ad free.

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

then Create a file named ```<app dir>```/android/key.properties that contains a reference to your keystore:
<code>storePassword=`<password from previous step>`
<br>keyPassword=`<password from previous step>`
<br>keyAlias=key
<br>storeFile=`<location of the key store file, such as /Users/<user name>`/key.jks></code>

then run this comand in your terminal from the app project directory

```flutter -v build appbundle --build-number <buildNumber>```

Discord: [https://discord.gg/ZqnP6c](https://discord.gg/ZqnP6c)