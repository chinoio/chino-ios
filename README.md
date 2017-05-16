#  CHINO.io Swift client #
*Official* Swift wrapper for **CHINO.io** API,
The iOS deployment target is set to 10.3
If you want to change it, check the settings of the project
under *General* tab.

### SDK distribution

You can integrate the CHINO.io Swift SDK into your project using one of several methods.

### CocoaPods

To use [CocoaPods](http://cocoapods.org), a dependency manager for Cocoa projects, you should first install it using the following command:

```bash
$ gem install cocoapods
```

Then navigate to the directory that contains your project and create a new file called `Podfile`. You can do this either with `pod init`, or open an existing Podfile, and then add `pod 'ChinoOSXLibrary', :git => 'https://github.com/chinoio/chino-ios.git', :tag => '1.0'` to the main loop. Your Podfile should look something like this:

```ruby
use_frameworks!

target '<YOUR_PROJECT_NAME>' do
pod 'ChinoOSXLibrary', :git => 'https://github.com/chinoio/chino-ios.git', :tag => '1.0'
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
github "https://github.com/chinoio/chino-ios" ~> 1.0
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

---

### Setup

Clone the github repository and open it in XCode.
There are some tests you can use as examples of usage
of the framework under *ChinoOSXLibraryTests/* folder

In the file ChinoOSXLibraryTests.swift you have to insert
your <customer-id> and <customer-key> in order for the tests
to work

### Usage

Once you have successfully imported the *Chino.io* SDKs you have to create a *ChinoAPI* variable  

```Swift
import ChinoOSXLibrary

var customerId = "<your-customer-id>"
var customerKey = "<your-customer-key>"
var server = "https://api.test.chino.io/v1"

var chino = ChinoAPI.init(hostUrl: server, customerId: customerId, customerKey: customerKey)
```  

Note that in this example we have used the test server. Use the production server for development only!  
  
The functions are asyncronous, this means that they are called on separate threads while the main thread continue to run.  
  
An example for the creation of a Repository is the following

```Swift
chino.repositories.createRepository(description: "test_repository_description") { (repository) in
    // Here you can use the variable 'repository' when the call is completed
    ...
}

// <---- While the call is executed the main thread continue to run

```  

pod 'ChinoOSXLibrary', :git => 'https://github.com/chinoio/chino-ios.git', :tag => '1.0'
