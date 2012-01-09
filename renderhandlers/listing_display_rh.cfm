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
	PaperThin Inc.
	M. Carroll
Name:
	listing_display_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-06-10 - MFC - Created
	2011-10-22 - MFC - Updated to use the metadata form fields.
--->
<cfscript>
	items = attributes.elementInfo.elementData.propertyValues;
	
	// check if the metadata form is defined
	photoSizeID = 0;
	if ( (StructKeyExists(attributes.elementInfo, "RenderHandlerMetaData")) AND (LEN(attributes.elementInfo.RenderHandlerMetaData.PhotoRenderSize.detailSize)) )
		photoSizeID = attributes.elementInfo.RenderHandlerMetaData.PhotoRenderSize.detailSize;
</cfscript>
<!--- <cfdump var="#attributes.elementInfo#" expand="false"> --->
<cfif arrayLen(items)>
	<cfscript>
		if( arrayLen(items) )
			photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected");
		// Prep the photos img source for rendering
		photoImgSrcArray = application.ptPhotoGallery.renderService.getPhotoRenderImgSrcArray(photoDataArray, photoSizeID);
	</cfscript>
	<!--- <cfdump var="#photoImgSrcArray#"> --->
	
	<!--- <cfdump var="#photoDataArray#" expand="false"> --->
	<cfloop index="ren_i" from="1" to="#ArrayLen(photoImgSrcArray)#">
		<cfoutput>
			<div>
				<strong>Title:</strong> #photoDataArray[ren_i].Values.title#<br />
				<img src="#photoImgSrcArray[ren_i]#"><br />
				<strong>Caption:</strong> #photoDataArray[ren_i].Values.caption#<br />
				<strong>Abstract:</strong> #photoDataArray[ren_i].Values.abstract#<br />
			</div><br />
		</cfoutput>
	</cfloop>
</cfif>