fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios test_sdk
```
fastlane ios test_sdk
```
Run Tests on SDK
### ios test_app
```
fastlane ios test_app
```
Run Tests on App
### ios build_and_archive
```
fastlane ios build_and_archive
```
Build App
### ios upload_and_distribute
```
fastlane ios upload_and_distribute
```
Upload App
### ios bump
```
fastlane ios bump
```
Bump Version
### ios push_tag
```
fastlane ios push_tag
```
Push Tag
### ios sync_to_github
```
fastlane ios sync_to_github
```
Sync to Github
### ios my_pods
```
fastlane ios my_pods
```
Install Cocoapods for Example Project

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
