<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	single_image_metadata_rh.cfm
Element:
	Single Image
ADF App:
	pt_photo_gallery
Version:
	0.9.0
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