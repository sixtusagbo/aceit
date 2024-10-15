final class Environment {
  static const fbProjectId = String.fromEnvironment('FB_PROJECT_ID');
  static const fbAndroidApiKey = String.fromEnvironment('FB_ANDROID_API_KEY');
  static const fbIosApiKey = String.fromEnvironment('FB_IOS_API_KEY');
  static const fbAndroidAppId = String.fromEnvironment('FB_ANDROID_APP_ID');
  static const fbIosAppId = String.fromEnvironment('FB_IOS_APP_ID');
  static const fbMessagingSenderId =
      String.fromEnvironment('FB_MESSAGING_SENDER_ID');
  static const fbStorageBucket = String.fromEnvironment('FB_STORAGE_BUCKET');
}
