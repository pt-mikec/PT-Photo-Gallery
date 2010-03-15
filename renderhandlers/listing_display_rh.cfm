<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	listing_display_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2009-06-10 - MFC - Created
--->
<cfscript>
	items = attributes.elementInfo.elementData.propertyValues;
	
	// check if the metadata form is defined
	photoSizeID = 0;
	if ( (StructKeyExists(attributes.elementInfo, "RenderHandlerMetaData")) AND (LEN(attributes.elementInfo.RenderHandlerMetaData.PhotoRenderSize.photoSizeSelect)) )
		photoSizeID = attributes.elementInfo.RenderHandlerMetaData.PhotoRenderSize.photoSizeSelect;
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