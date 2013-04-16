AS3 Airbrake
============

This is an [AirBrake](http://airbrake.io/) [URLRequest](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html) generator that uses either the XML or JSON [interface to V3 of the Airbrake API](http://help.airbrake.io/kb/api-2/notifier-api-v3)

It is based around the IAirBrake interface and can be used in the following manner:

````
var notifier:IAirBrake = new AirBrakeXML("your-api-key", "production");
````
or

````
var notifier:IAirBrake = new AirBrakeXML("your-api-key", "production", #project-id);
````

After that all that's left to do is pass an [Error](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Error.html) object of any type to *createErrorNotice* like so:

````
var req:URLRequest = notifier.createErrorNotice(new Error());
````
Obviously you can put a caught Error there or any Error object aquired in any other fashion, try to get it as close to the actual issue though as its stack trace will be parsed for reporting and the accuracy of that data can be crucial. Once you have your [URLRequest](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html) you can treat like it any other - [load it with a URLLoader](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLLoader.html#load\(\)), for example. I made no assumptions about how you wanted to actually send the data once you have the URLRequest object so it can be inserted into any system.