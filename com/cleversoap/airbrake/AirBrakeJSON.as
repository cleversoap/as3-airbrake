/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap.airbrake
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;


	public class AirBrakeJSON extends AirBrake implements IAirBrake
	{
		//-------------------------------------------------------------[MEMBERS]

		/// Project ID
		protected var _projectId   :String;

		//---------------------------------------------------------[CONSTRUCTOR]

		/**
		* Create an AirBrake notifier instance for a specific environment
		* configuration to make error reports for.
		*
		* @param $apiKey        AirBrake API Key.
		* @param $environment   AirBrake environment to report to.
		* @param $projectId     AirBrake Project ID key.
		*/
		public function AirBrakeJSON($apiKey:String, $environment:String, $projectId:String,
		                             $projectVersion:String = "0.0", $projectRoot:String = "/")
		{
			// Build the generic airbrake notifier core first
			super($apiKey, $environment, $projectVersion, $projectRoot);

			// Append JSON to the notifier name
			_notifier.name += "JSON";

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
			return makeRequest(JSON.stringify(makeNotice($error))); 
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

		protected function makeNotice($error:Error):Object
		{
			return {	
				"notifier" : _notifier, 
				"errors"   : [makeErrors($error)],
				"context"  : makeContext()
			};
		}

		protected function makeErrors($error:Error):Object
		{
			return {
				"type"      : $error.name,
				"message"   : $error.message,
				"backtrace" : parseStackTrace($error.getStackTrace()),
				"context"   : makeContext()
			};
		}

		override protected function makeBackTraceLine($file:String, $line:uint, $function:String):*
		{
			return {"file": $file, "line": $line, "function": $function};
		}
	
		protected function makeContext():Object
		{
			return {
				"language"      : "Actionscript 3",
				"environment"   : _environment,
				"version"       : _projectVersion,
				"url"           : "www.example.com",
				"rootDirectory" : _projectRoot
			};
		}
	}
}
