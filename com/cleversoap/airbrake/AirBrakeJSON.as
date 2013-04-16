/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap.airbrake
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	* Simple AirBrake notifier that uses native Flash Errors.
	* Does make any assumptions about how you send the reports and
	* only generates a URLRequest object.
	*
	* http://help.airbrake.io/kb/api-2/notifier-api-v3
	*/
	public class AirBrakeJSON extends AirBrake implements IAirBrake
	{
		/// Project ID
		protected var _projectId   :String;

		/**
		* Create an AirBrake notifier instance for a specific environment
		* configuration to generate error reports for.
		*
		* @param $apiKey		AirBrake API Key.
		* @param $environment	AirBrake environment to report to.
		* @param $appVersion	The version of your application to report errors for.
		* @param $projectRoot	The path to the project in which the error occurred.
		* @param $hostName		Platform host name.
		*/
		public function AirBrakeJSON($projectId:String, $apiKey:String, $environment:String, $appVersion:String, $projectRoot:String = "/", $hostName:String = null)
		{
			// Build the generic airbrake notifier core first
			super($apiKey, $environment);

			// Append JSON to the notifier name
			this.notifier.name += "JSON";

			// Set the project ID as this is needed by the JSON API only
			_projectId   = $projectId;
		}

		//----------------------------------------------------[PUBLIC FUNCTIONS]

		/**
		* Creates a URLRequest that will report an error to AirBrake
		* based on the passed Error object.
		*
		* @param $error	Error to report.
		*/
		public function createErrorNotice($error:Error):URLRequest
		{
			return generateRequest(generateNotice($error)); 
		}

		//----------------------------------------------------------[PROPERTIES] 

		/**
		* Airbrake Project ID
		*/
		public function get projectId():String
		{
			return _projectId;
		}

		//----------------------------------------------------[MEMBER FUNCTIONS] 

		/**
		* Create a URLRequest that points to the AirBrake JSON API.
		*/
		protected function generateRequest($notice:Object):URLRequest
		{
			var request:URLRequest = new URLRequest();
			request.method         = URLRequestMethod.POST;
			request.contentType    = "application/json";
			request.url            = "http://collect.airbrake.io/api/v3/projects/" + _projectId + "/notices?key=" + _apiKey;
			request.data           = JSON.stringify($notice);
			return request;
		}

		protected function generateNotice($error:Error):Object
		{
			return {	
				"notifier" : _notifier, 
				"errors"   : [generateErrors($error)],
				"context"  : generateContext()
			};
		}

		protected function generateErrors($error:Error):Object
		{
			return {
				"type"      : $error.name,
				"message"   : $error.message,
				"backtrace" : generateBackTrace($error.getStackTrace()),
				"context"   : generateContext()
			};
		}

		protected function generateBackTrace($stackTrace:String):Array
		{
			var backTrace:Array = [];	

			var lineRegExp:RegExp = /at (?P<type>[\w\.:]+):*\/*(?P<method>\w+)?\(\)(\[(?P<file>.*):(?P<line>\d+)\])?/g;
			
			var match:Object;
			while (match = lineRegExp.exec($stackTrace))
			{
				backTrace.push({
					"file"     : (match.file ? match.file : match.type),
					"line"     : Number(match.line ? match.line : 0),
					"function" : (match.method ? match.method : match.type)
				});
			}

			return backTrace;
		}

		protected function generateContext():Object
		{
			return {
				"language"      : "Ruby 1.9.3",
				"environment"   : _environment,
				"version"       : _appVersion,
				"url"           : "www.example.com",
				"rootDirectory" : _projectRoot
			};
		}
	}
}
