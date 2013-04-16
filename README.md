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

## Download
I've included a compiled SWC for ease of use [here](https://github.com/cleversoap/as3-airbrake/raw/master/bin/as3-airbrake.swc) that can be easily included into your project.