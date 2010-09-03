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
/* *************************************************************** */
Author: 	
	PaperThin Inc.
	M. Carroll
Name:
	gallery_single_image_random_rh.cfm
Summary:
	SUMMARY
Element:
	Photo Gallery
ADF App:
	PT Photo Gallery	
Version:
	1.3
History:
	2010-08-05 - MFC - Created
--->
<cfscript>
	// Get the data
	items = attributes.elementInfo.elementData.propertyValues;
	
	// Pass in the RH metadata struct
	rhData = application.ptPhotoGallery.renderService.processRHMetadata(attributes.elementInfo.RenderHandlerMetaData);
</cfscript>
<cfif ArrayLen(items) AND (ListLen(items[1].values.photoSelect))>
	<!--- Check if the metadata form has data --->
	<cfif (StructKeyExists(rhData.photoSizeSelect, "directory"))>
		
		<!--- Get the Photo data from CEData --->
		<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
		
		<cfoutput>
			<script type="text/javascript">
				var photoDataObject = new Array();
		</cfoutput>
				
		<cfloop index="photo_i" from="1" to="#ArrayLen(photoDataArray)#">
			<cfscript>
				photoSrc = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[photo_i].values.photo,'#rhData.photoSizeSelect.directory#');
			</cfscript>
			<cfoutput>photoDataObject[photoDataObject.length] = '<img src="#photoSrc#" alt="#photoDataArray[photo_i].values.title#" width="#rhData.photoSizeSelect.width#" height="#rhData.photoSizeSelect.height#" title="#photoDataArray[photo_i].values.title#" />';</cfoutput>
		</cfloop>
		<cfoutput></script></cfoutput>
		
		<!--- // get a random image from the list --->
		<cfoutput>
			<span id="imgTag"><!-- // random image goes here --></span>
			<script type="text/javascript">
				function getRandomInt(min, max) {
				  return Math.floor(Math.random() * (max - min + 1)) + min;
				}
				randomIndex = getRandomInt(0, photoDataObject.length - 1);
		
				// set the innerHTML for the <span> tag with the HTML
				imgSpan = document.getElementById("imgTag");
				imgSpan.innerHTML = photoDataObject[randomIndex];
			</script>
		</cfoutput>
	<cfelse>
		<cfoutput>Select the Photo Sizes to render in the metadata form.</cfoutput>
	</cfif>
</cfif>