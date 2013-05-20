/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap.airbrake
{
	import flash.net.URLRequest;

	/**
	* Generic AirBrake request creator interface.
	*/
	public interface IAirBrake
	{
		/**
		* Create a URLRequest object to report an error to AirBrake.
		*
		* @param $error	Error to report.
		*/
		function createErrorNotice($error:Error, $params:Object = null, $url:String = null):URLRequest;

		function get environment():Object;
		function get session():Object;

		function addEnvironmentVar($name:String, $value:*):void;
		function addSessionVar($name:String, $value:*):void;

		function removeEnvironmentVar($name:String):void;
		function removeSessionVar($name:String):void;
	}
}
