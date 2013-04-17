AS3 Airbrake
============

This is an [AirBrake](http://airbrake.io/) [URLRequest](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html) generator that uses either the XML or JSON [interface to V3 of the Airbrake API](http://help.airbrake.io/kb/api-2/notifier-api-v3)

It is based around the [IAirBrake](https://github.com/cleversoap/as3-airbrake/blob/master/com/cleversoap/airbrake/IAirBrake.as) interface so that you are not dependent on one API implementation or the other. They are all apart of the ```com.cleversoap.airbrake``` namespace and should be used in the following fashion:

```actionscript3
var notifier:IAirBrake = new AirBrakeXML("your-api-key", "production");
```
or

```actionscript3
var notifier:IAirBrake = new AirBrakeJSON("your-api-key", "production", #project-id);
```

After that all that's left to do is pass an [Error](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Error.html) object of any type to *createErrorNotice* like so:

```actionscript3
var req:URLRequest = notifier.createErrorNotice(new Error());
```
Obviously you can put a caught Error there or any Error object aquired in any other fashion, try to get it as close to the actual issue though as its stack trace will be parsed for reporting and the accuracy of that data can be crucial. Once you have your [URLRequest](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html) you can treat like it any other - [load it with a URLLoader](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLLoader.html#load\(\)), for example. I made no assumptions about how you wanted to actually send the data once you have the URLRequest object so it can be inserted into any system.

## Optional Parameters and URLs
In addition to handling Error objects each call to *createErrorNotice* can handle two additional (optional) arguments. The first is an object that contains keyed values, these are additional parameters that you feel are relevant to the error, eg. user id or browser type.

```actionscript3
var req:URLRequest = notifier.createErrorNotice(new Error(), {"user-id": 12345, "browser": "Mozilla Something"};
```

The second optional parameter is the URL at which the error occurred. This value can usually be retrieved by doing the following (if you've embedded it in the browser):

```actionscript3
ExternalInterface.call("eval", "window.location.href");
```

You can then use this value like so - note that the optional params here are null but obviously can be any value as I described before:

```actionscript3
var req:URLRequest = notifier.createErrorNotice(new Error(), null, "http://example.com/error-maker");
```

## Compiling
A Makefile has been included that, as long as you have the FlexSDK (**compc** specifically) accessible from the command line, you can run directly with ```make``` - it will output the swc to the *bin* directory. This is the same way that I build the swc for downloading.

## Download
I've included a compiled SWC for ease of use [here](bin/as3-airbrake.swc) that can be easily included into your project.

## License
[MIT License](http://opensource.org/licenses/MIT)
