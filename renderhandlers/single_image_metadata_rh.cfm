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
Author: 	PaperThin Inc.
			M. Carroll
Name:
	single_image_metadata_rh.cfm
Element:
	Single Image
ADF App:
	pt_photo_gallery
Version:
	1.0.0
History:
	2009-06-12 - MFC - Created
--->
<cfdump var="#attributes.elementInfo#" expand="false">
<cfscript>
	imageURL = "";
	pageID = ListLast(attributes.elementInfo.elementParams.SrcURL,":");
	// If we have a 
	if ( pageID GT 0 ){
		photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "imgGalleryPageID", pageID, "selected");
		renderSize = "";
		if ( ArrayLen(photoDataArray) ) {
			if ( StructKeyExists(attributes.elementInfo.renderhandlermetadata, "PhotoRenderSize") AND
					StructKeyExists(attributes.elementInfo.renderhandlermetadata.PhotoRenderSize, "photoSizeSelect") )
			{
				renderSize = attributes.elementInfo.renderhandlermetadata.PhotoRenderSize.photoSizeSelect;	
				if ( LEN(renderSize))
					imageURL = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[1].values.photo, renderSize);
			}
		}
	}
	// If the above fails and we don't get an image URL then use the default
	if ( LEN(imageURL) ) {
		imageURL = attributes.elementInfo.ElementData.PrimaryImage.ResolvedURL.serverRelative;
	}
</cfscript>
<cfif LEN(imageURL)>
	<cfoutput>
		<img src="#imageURL#" alt="#photoDataArray[1].values.title#" title="#photoDataArray[1].values.title#"> <br />
		<em>#photoDataArray[1].values.caption#</em>
	</cfoutput>
</cfif>