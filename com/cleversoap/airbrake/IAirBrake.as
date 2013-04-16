package com.cleversoap.airbrake
{
	import flash.net.URLRequest;

	public interface IAirBrake
	{
		function createErrorNotice($error:Error):URLRequest;
	}
}
