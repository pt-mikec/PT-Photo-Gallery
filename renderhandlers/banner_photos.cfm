<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2010.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

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
	1.0.0
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