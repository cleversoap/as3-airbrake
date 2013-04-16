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
		function createErrorNotice($error:Error):URLRequest;
	}
}
