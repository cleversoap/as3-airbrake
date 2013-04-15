package com.cleversoap
{
	import flash.net.URLRequest;

	public interface IAirBrake
	{
		function createErrorNotice($error:Error):URLRequest;
	}
}
