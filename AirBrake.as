package com.cleversoap.airbrake
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class AirBrake
	{
		protected var _apiKey      :String;
		protected var _environment :String;
		protected var _appVersion  :String;
		protected var _hostName    :String;

		public function AirBrake($apiKey:String, $environment:String, $appVersion:String, $hostName:String)
		{
			_apiKey      = $apiKey;
			_environment = $environment;
			_appVersion  = $appVersion;
			_hostName    = $hostName;
		}

		public function createErrorReport($error:Error):URLRequest
		{
			return generateRequest(generateXml($error));
		}

		public function get apiKey():String
		{
			return _apiKey;
		}

		public function get environment():String
		{
			return _environment;
		}

		public function get appVersion():String
		{
			return _appVersion;
		}

		public function get hostName():String
		{
			return _hostName;
		}

		protected function generateRequest($errorXml:XML):URLRequest
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
			var notifierNode:XML = new XML("<notifier>");
			notifierNode.appendChild(generateNode("name", "com.cleversoap.airbrake"));
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
			errorNode.appendChild($error.getStackTrace());

			return errorNode;
		}

		protected function generateStackTraceXml($stackTrace:String):XML
		{
			var stackTraceNode:XML = new stackTraceNode("<backtrace/>");
			return stackTraceNode;
		}
	}
}
