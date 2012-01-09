<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2011.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	gallery_single_image_rh.cfm
Summary:
	Renders a single image from the image gallery
ADF App
	PT Photo Gallery
Version:
	2.0
History:
	2011-04-14 - MFC - Created
	2011-10-22 - MFC - Updated to work with the detail size metadata form field.
--->
<cfscript>
	// Get the items for the data
	items = attributes.elementinfo.elementdata.propertyValues;
	// Pass in the RH metadata struct
	rhData = application.ptPhotoGallery.renderService.processRHMetadata(attributes.elementInfo.RenderHandlerMetaData);
</cfscript>
<cfif ArrayLen(items)>
	<!--- Check if the metadata form has data --->
	<cfif (StructKeyExists(rhData.detailSize, "directory"))>
		<cfscript>
			// Call CEData to get the first item if multiple are selected
			photoDataArray = application.ptPhotoGallery.photoDAO.getPhotoData(ListFirst(items[1].values.photoSelect));
		</cfscript>
		<!--- Get the first item out and render that --->
		<cfif ArrayLen(photoDataArray)>
			<cfscript>
				// Get the photo URL
				photoURL = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[1].values.photo, "#rhData.detailSize.directory#");
			</cfscript>
			<cfoutput>
				<img alt="#photoDataArray[1].values.title#" src="#photoURL#">
			</cfoutput>
		</cfif>
	<cfelse>
		<cfoutput>Select the Photo Sizes to render in the metadata form.</cfoutput>
	</cfif>
</cfif>