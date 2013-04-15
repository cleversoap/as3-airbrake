/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap
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
	public class AirBrake
	{
		/// Project ID
		protected var _projectId   :String;

		/// API key for your airbrake destination
		protected var _apiKey      :String;

		/// Environment (typically production, testing, staging, etc...)
		protected var _environment :String;

		/// App version
		protected var _appVersion  :String;

		/// Project root
		protected var _projectRoot :String;

		/// Hostname
		protected var _hostName    :String;

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
		public function AirBrake($projectId:String, $apiKey:String, $environment:String, $appVersion:String, $projectRoot:String = "/", $hostName:String = null)
		{
			_projectId   = $projectId;
			_apiKey      = $apiKey;
			_environment = $environment;
			_appVersion  = $appVersion;
			_projectRoot = $projectRoot;
			_hostName    = $hostName;
		}

		/**
		* Creates a URLRequest that will report an error to AirBrake
		* based on the passed Error object.
		*
		* @param $error	Error to report.
		*/
		public function createErrorReport($error:Error):URLRequest
		{
			return generateRequest(generateNotice($error)); 
		}

		public function get projectId():String
		{
			return _projectId;
		}

		/**
		*/
		public function get apiKey():String
		{
			return _apiKey;
		}

		/**
		*/
		public function get environment():String
		{
			return _environment;
		}

		/**
		*/
		public function get appVersion():String
		{
			return _appVersion;
		}

		/**
		*/
		public function get hostName():String
		{
			return _hostName;
		}

		/**
		*/
		public function get projectRoot():String
		{
			return _projectRoot;
		}

		protected function generateRequest($notice:Object):URLRequest
		{
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.contentType = "application/json";
			request.url = "http://collect.airbrake.io/api/v3/projects/" + _projectId + "/notices?key=" + _apiKey;
			request.data = JSON.stringify($notice);
			return request;
		}

		protected function generateNotice($error:Error):Object
		{
			return {	
				"notifier": generateNotifier(),
				"errors": [generateErrors($error)],
				"context": generateContext()
			};

		}

		protected function generateNotifier():Object
		{
			return {
				"name": "com.cleversoap.AirBrake",
				"version": "0.1",
				"url": "https://github.com/cleversoap/as3-airbrake"
			};
		}

		protected function generateErrors($error:Error):Object
		{
			return {
				"type": $error.name,
				"message": $error.message,
				"backtrace": generateBackTrace($error.getStackTrace())
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
					"line"     : (match.line ? match.line : 0),
					"function" : (match.method ? match.method : match.type)
				});
			}

			return backTrace;
		}

		protected function generateContext():Object
		{
			return {
				"language": "Actionscript 3",
				"environment": _environment,
				"version": _appVersion,
				"url": "www.example.com",
				"rootDirectory": _projectRoot
			};
		}
	}
}
