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
		public function AirBrake($apiKey:String, $environment:String, $appVersion:String, $projectRoot:String = "/", $hostName:String = null)
		{
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
			return generateRequest(generateXml($error));
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

		protected function generateRequest($errorXml:XML, $vars:Object = null):URLRequest
		{
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.data = [$errorXml.toString()];
			request.url = "http://airbrake.io/notifier_api/v2/notices";
			return request;
		}

		protected function generateXml($error:Error):XML
		{
			var notice:XML = new XML("<notice/>");
			
			// Notifier API Version
			notice.@version = "2.3";

			// API Key Node
			notice.appendChild(generateNode("api-key", _apiKey));

			// Notifier
			notice.appendChild(generateNotifierXml());

			// Error
			notice.appendChild(generateErrorXml($error));

			// Server Environment
			notice.appendChild(generateEnvironmentXml());

			return notice;
		}

		protected function generateNode($name:String, $value:String):XML
		{
			var node:XML = new XML("<" + $name + "/>");
			node.appendChild($value);
			return node;
		}

		protected function generateNotifierXml():XML
		{
			var notifierNode:XML = new XML("<notifier/>");
			notifierNode.appendChild(generateNode("name", "com.cleversoap.AirBrake"));
			notifierNode.appendChild(generateNode("version", "0.1"));
			notifierNode.appendChild(generateNode("url", "https://github.com/cleversoap/as3-airbrake"));
			return notifierNode;
		}

		protected function generateErrorXml($error:Error):XML
		{
			var errorNode:XML = new XML("<error/>");
			
			// Error Type
			errorNode.appendChild(generateNode("class", $error.name));

			// Error Message
			errorNode.appendChild(generateNode("message", $error.message));

			// Stack Trace
			errorNode.appendChild(generateStackTraceXml($error.getStackTrace()));

			return errorNode;
		}

		protected function generateStackTraceXml($stackTrace:String):XML
		{
			var stackTraceNode:XML = new XML("<backtrace/>");

			var lineRegExp:RegExp = /at (?P<type>[\w\.:]+):*\/*(?P<method>\w+)?\(\)(\[(?P<file>.*):(?P<line>\d+)\])?/g;
			
			var matches:Object;
			while (matches = lineRegExp.exec($stackTrace))
			{
				stackTraceNode.appendChild(generateLineXml(
					(matches.method ? matches.method : matches.type),
					(matches.file ? matches.file : matches.type),
					(matches.line ? matches.line : 0)
				));
			}

			return stackTraceNode;
		}

		protected function generateLineXml($method:String, $file:String, $lineNumber:uint):XML
		{
			var lineNode:XML = new XML("<line/>");
			lineNode.@method = $method;
			lineNode.@file = $file;
			lineNode.@number = $lineNumber;
			return lineNode;
		}

		protected function generateEnvironmentXml():XML
		{
			var envNode:XML = new XML("<server-environment/>");
			envNode.appendChild(generateNode("project-root", _projectRoot));
			envNode.appendChild(generateNode("environment-name", _environment));
			envNode.appendChild(generateNode("app-version", _appVersion));
			if (_hostName)
				envNode.appendChild(generateNode("hostname", _hostName));
			return envNode;
		}
	}
}
