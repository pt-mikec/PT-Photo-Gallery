<!---
/* ***************************************************************
/*
Author: 	Ron West / M.Carroll
Name:
	$banner_photos.cfm
Summary:
	Using the AjaxServiceProxy to render the "Banner Images" flash widget.
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2008-08-11 - RLW - Created
--->
<cfscript>
	request.element.isStatic = 0;
	items = attributes.elementInfo.elementData.propertyValues;
</cfscript>

<cfif arrayLen(items)>
	<cfscript>
		// Build the flash vars XML
		//application.ptPhotoGallery.renderService.buildFlashVars(items[1].values.photoSelect, 100);
	</cfscript>
	<!--- <cfoutput>
		<script src="/ADF/apps/pt_photo_gallery/scripts/swfobject.js" type="text/javascript"></script>
		<div id="flashclip"></div>
		<script type="text/javascript">
			// <![CDATA[
			var flashMovie = new SWFObject("/ADF/apps/pt_photo_gallery/flash/BannerImageGallery/gallery.swf","imageGallery","590","300","8");
			flashMovie.addParam("wmode", "transparent"); //transparent
			flashMovie.addParam("quality", "high");
			flashMovie.addParam("pluginspage", "http://www.macromedia.com/go/getflashplayer");
			flashMovie.addParam("initialscale", "fit");
			flashMovie.addParam("id", "imageGallery");
			
			flashMovie.addParam("flashVars", "xmlfile=/ADF/apps/pt_photo_gallery/flash/vars.xml");
			
			flashMovie.addParam("bgcolor", "##ffffff");
			flashMovie.addParam("name", "flashclip");
			flashMovie.addParam("allowScriptAccess","sameDomain");
			flashMovie.addParam("allowFullScreen","false");
			flashMovie.addParam("loop","true");
			flashMovie.addParam("showLoopButton","false");
			flashMovie.addParam("hideControls","true");
			//flashMovie.addParam("flashvars", "config={playList: [ {url: '/flash/moreau1_noaudio.flv', linkUrl: 'gallery.cfm', linkWindow:'_self'}], hideControls: true, showLoopButton: false, loop: true, autoPlay: true}");
			flashMovie.write("flashclip");
			// ]]>
		</script>
		<noscript>
		    // Provide alternate content for browsers that do not support scripting
		    // or for those that have scripting disabled.
		     This content requires the Adobe Flash Player.
		    <a href="http://www.macromedia.com/go/getflash/">Please download the Flash player</a>
		</noscript>
	</cfoutput> --->
	<cfoutput>
		<script src="/ADF/apps/pt_photo_gallery/scripts/swfobject.js" type="text/javascript"></script>
		<div id="flashclip"></div>
		<script type="text/javascript">
			// <![CDATA[
			var flashMovie = new SWFObject("/ADF/apps/pt_photo_gallery/flash/BannerImageGallery/gallery.swf","imageGallery","590","300","8");
			flashMovie.addParam("wmode", "transparent"); //transparent
			flashMovie.addParam("quality", "high");
			flashMovie.addParam("pluginspage", "http://www.macromedia.com/go/getflashplayer");
			flashMovie.addParam("initialscale", "fit");
			flashMovie.addParam("id", "imageGallery");
			flashMovie.addParam("flashVars", "xmlfile=#URLEncodedFormat('#application.ADF.ajaxProxy#?bean=renderService&method=buildFlashVars&photoIDList=#items[1].values.photoSelect#&imgWidth=100')#");
			flashMovie.addParam("bgcolor", "##ffffff");
			flashMovie.addParam("name", "flashclip");
			flashMovie.addParam("allowScriptAccess","sameDomain");
			flashMovie.addParam("allowFullScreen","false");
			flashMovie.addParam("loop","true");
			flashMovie.addParam("showLoopButton","false");
			flashMovie.addParam("hideControls","true");
			//flashMovie.addParam("flashvars", "config={playList: [ {url: '/flash/moreau1_noaudio.flv', linkUrl: 'gallery.cfm', linkWindow:'_self'}], hideControls: true, showLoopButton: false, loop: true, autoPlay: true}");
			flashMovie.write("flashclip");
			// ]]>
		</script>
		<noscript>
		    // Provide alternate content for browsers that do not support scripting
		    // or for those that have scripting disabled.
		     This content requires the Adobe Flash Player.
		    <a href="http://www.macromedia.com/go/getflash/">Please download the Flash player</a>
		</noscript>
	</cfoutput>
</cfif>