#  CHINO.io Swift client #
*Official* Swift wrapper for **CHINO.io** API,
The iOS deployment target is set to 10.3
If you want to change it, check the settings of the project
under *General* tab.

##Setup
Clone the github repository and open it in XCode.
There are some tests you can use as examples of usage
of the framework under *ChinoOSXLibraryTests/* folder

In the file ChinoOSXLibraryTests.swift you have to insert
your <customer-id> and <customer-key> in order for the tests
to work

##Usage
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
    #Here you can use the variable 'repository' when the call is completed
    ...
}

#   <----   While the call is executed the main thread continue to run

```  

