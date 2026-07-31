# Ti.Admob Module

## Description

Use the iOS Google Admob Module in Titanium.

## Doc

Consult the [documentation](./documentation/) to use the module:
* [Index](./documentation/index.md)
* [Ti.Admob.View](./documentation/view.md)
* [Changelog](./documentation/changelog.md)

## Example

A complete example in [app.js](./example/app.js)
Here a demo app ready to use: https://github.com/Astrovic/ti.admob-sample-app/

## Building the module locally

```bash
npm run build:ios
```

This command will:
1. Automatically download the Pangle SDK into `ios/platform/` if not already present
2. Build the module with `ti build -p ios --build-only`

For a clean build (clears `ios/build/` and `ios/dist/` but keeps downloaded SDKs):

```bash
npm run build:ios:clean
```

### Pangle SDK

The Pangle SDK (`PAGAdSDK.xcframework`, `PAGAdSDK.bundle`, `TikTokBusinessSDK.xcframework`)
is not stored in Git because its binaries exceed GitHub's 100 MB file size limit.

Running `npm run build:ios` downloads it automatically from the official Pangle CDN.
To update the Pangle SDK version, edit the `PANGLE_VERSION` and `PANGLE_URL` variables
at the top of `ios/scripts/ensure-pangle.sh`.
