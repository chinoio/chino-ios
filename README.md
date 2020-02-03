#  CHINO.io Swift client #

**This repository is deprecated.**
This branch is only kept for compatibility with older versions.

The code will be maintained on https://gitlab.com/chinoio-public/sdk-chino-swift.

- - -

## To install the latest version

Follow the instructions in the
[current repository](https://gitlab.com/chinoio-public/sdk-chino-swift/blob/master/INSTRUCTIONS.md#install)

## To install an older version

The iOS deployment target is set to 10.3
If you want to change it, check the settings of the project
under *General* tab.

Use one of the two methods below to get an older version 
of the library (up to 1.3).

### CocoaPods

To use [CocoaPods](http://cocoapods.org), a dependency manager for Cocoa projects, you should first install it using the following command:

```bash
$ gem install cocoapods
```

Then navigate to the directory that contains your project and create a new file called `Podfile`. You can do this either with `pod init`, or open an existing Podfile, and then add `pod 'ChinoOSXLibrary', :git => 'https://github.com/chinoio/chino-ios.git', :tag => '1.3'` to the main loop. Your Podfile should look something like this:

```ruby
use_frameworks!

target '<YOUR_PROJECT_NAME>' do
pod 'ChinoOSXLibrary', :git => 'https://github.com/chinoio/chino-ios.git', :tag => '1.3'
end
```

Then, run the following command to install the dependency:

```bash
$ pod install
```

Once your project is integrated with the CHINO.io Swift SDK, you can pull SDK updates using the following command:

```bash
$ pod update
```  

---

### Carthage

You can also integrate the CHINO.io Swift SDK into your project using [Carthage](https://github.com/Carthage/Carthage), a decentralized dependency manager for Cocoa. Carthage offers more flexibility than CocoaPods, but requires some additional work. You can install Carthage (with Xcode 7+) via [Homebrew](http://brew.sh/):

```bash
brew update
brew install carthage
```

To install the CHINO.io Swift SDK via Carthage, you need to create a `Cartfile` in your project with the following contents:

```
# CHINO.io
github "https://github.com/chinoio/chino-ios" ~> 1.1
```

Then, run the following command to install the dependency to checkout and build the CHINO.io Swift SDK repository:

##### iOS

```bash
carthage update --platform iOS
```

In the Project Navigator in Xcode, select your project, and then navigate to **General** > **Linked Frameworks and Libraries**, then drag and drop `ChinoOSXLibrary.framework` (from `Carthage/Build/iOS`).

Then, navigate to **Build Phases** > **+** > **New Run Script Phase**. In the newly-created **Run Script** section, add the following code to the script body area (beneath the "Shell" box):

```
/usr/local/bin/carthage copy-frameworks
```

Then, navigate to the **Input Files** section and add the following path:

```
$(SRCROOT)/Carthage/Build/iOS/ChinoOSXLibrary.framework
```
