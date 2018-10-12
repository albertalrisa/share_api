# Flutter Share API Plugin

Flutter Plugin for sharing contents to social media.

At this moment, this plugin is **Android-only**. 
Adding iOS compatibility is the highest priority on the development road map.

## Introduction

This plugin is still in development. Specifications and APIs may change in the subsequent versions. Use this at your own risk.

## Available Features

| Platform | Android | iOS | Activity Return Value | Notes |
| ---- | ---- | ---- | ---- | ---- |
| System UI | ✅ | ❌ | ❌ | Text, Images, and Files |
| Facebook Story | ✅ | ❌ | ✅ | Images (Background and Sticker)|
| Instagram Story | ✅ | ❌ | ❌ | Images (Background and Sticker)|

## Configuration

### Sharing Images and Files

In order to share files and/or images, you will need to add the following:

#### Android

In the `android/app/src/main/AndroidManifest.xml`, add the following in the `manifest/application`:

```xml
<!-- Add FileProvider in order to access the shared file -->
<provider
        android:name="android.support.v4.content.FileProvider"
        android:authorities="${applicationId}.com.albertalrisa.share_api"
        android:exported="false"
        android:grantUriPermissions="true">
    <meta-data
            android:name="android.support.FILE_PROVIDER_PATHS"
            android:resource="@xml/file_paths" />
</provider>
```

After adding the File Provider to the manifest, create a file named `file_paths.xml` in the `app/src/main/res/xml` 
folder:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <cache-path name="images" path="/"/>
</paths>
```

## Usage

The module is accessed statically by calling `ShareApi.via[module].[function]()`.

The following functions are available:

| Module     | Function         |
| ---------- | ---------------- |
| System UI  | `shareText()`    |
|            | `shareFile()`    |
|            | `shareImage()`   |
| Facebook   | `shareToStory()` |
| Instagram  | `shareToStory()` |

## Return Values

All share functions will return an integer representing the return value of the activity called. 
If the function does not support obtaining the operation result, `ShareResult.undefined` or `0x00` is given.
Otherwise, the return value will be one of three possible values, which are `ok`, `canceled`, and `failed`.
As of now, only Facebook responds with proper value, therefore running the other functions will always 
return `undefined`.

There are four possible values:

| Value                            | Meaning                                                                          |
| -------------------------------- | -------------------------------------------------------------------------------- |
| `ShareResult.undefined` (`0x00`) | The share function does not support return values                                |
| `ShareResult.ok` (`0x01`)        | The share function has completed successfully, and the content has been shared   |
| `ShareResult.canceled` (`0x02`)  | The user canceled the share action and return back to the application            |
| `ShareResult.failed` (`0x03`)    | The share function failed to complete. Mostly due to exceptions and other errors |  

## Development Road Map

* iOS Compatibility for System UI, Facebook Story, and Instagram Story
* Examples and Documentation Revamp 

## Contributing

Feel free to contribute by opening issues or submitting PRs through GitHub.
