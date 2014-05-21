import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.client.SummaryReportClient;
import massive.munit.TestRunner;

#if js
import js.Lib;
#end

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain extends openfl.display.Sprite
{
	static function main(){	new TestMain(); }

	public function new()
	{
        super();
		var suites = new Array<Class<massive.munit.TestSuite>>();
		suites.push(TestSuite);

		#if MCOVER
			var client = new mcover.coverage.munit.client.MCoverPrintClient();
			var httpClient = new HTTPClient(new mcover.coverage.munit.client.MCoverSummaryReportClient());
		#else
			var client = new RichPrintClient();
			var httpClient = new HTTPClient(new SummaryReportClient());
		#end

		var runner:TestRunner = new TestRunner(client); 
		runner.addResultClient(httpClient);
		//runner.addResultClient(new HTTPClient(new JUnitReportClient()));
		
		runner.completionHandler = completionHandler;
		runner.run(suites);
	}

	/*
		updates the background color and closes the current browser
		for flash and html targets (useful for continous integration servers)
	*/
	function completionHandler(successful:Bool):Void
	{
		try
		{
			#if flash
				openfl.external.ExternalInterface.call("testResult", successful);
			#elseif js
				js.Lib.eval("testResult(" + successful + ");");
			#elseif sys
				Sys.exit(successful ? 0 : 1);
			#end
		}
		// if run from outside browser can get error which we can ignore
		catch (e:Dynamic)
		{
		}
	}
}


/*///////////////////////////////////////////////////////////////////////////////
//
// File: ../pass.hx/TestMain.hx
//
// Copyright 2013 TiVo Inc. All Rights Reserved.
//
// Auto-generated, see the Makefile
//
///////////////////////////////////////////////////////////////////////////////
import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.client.SummaryReportClient;
import massive.munit.TestRunner;

#if js
import js.Lib;
import js.Dom;
#end

#if (haxe_208 && !haxe_209)
    #if neko
        import neko.Sys;
    #elseif cpp
        import cpp.Sys;
    #elseif php
        import php.Sys
    #end
#end

class TestMain
{
    static function main(){ new TestMain(); }

    public function new()
    {
        var suites = new Array<Class<massive.munit.TestSuite>>();
        suites.push(TestSuite);

        #if MCOVER
            var client = new mcover.coverage.munit.client.MCoverPrintClient();
            var httpClient = new HTTPClient(new mcover.coverage.munit.client.MCoverSummaryReportClient());
        #else
            var client = new RichPrintClient();
            var httpClient = new HTTPClient(new SummaryReportClient());
        #end

        var runner:TestRunner = new TestRunner(client); 
        runner.addResultClient(httpClient);
        //runner.addResultClient(new HTTPClient(new JUnitReportClient()));
        
        runner.completionHandler = completionHandler;
        runner.run(suites);
    }

    
        //updates the background color and closes the current browser
        //for flash and html targets (useful for continous integration servers)
    
    function completionHandler(successful:Bool):Void
    {
        try
        {
            #if flash
                //openfl.external.ExternalInterface.call(testResult, successful);
            #elseif js
                js.Lib.eval("testResult(" + successful + ");");
            #elseif (neko || cpp || php)
                Sys.exit(0);
            #end
        }
        // if run from outside browser can get error which we can ignore
        catch (e:Dynamic)
        {
        }
    }
}
*/
