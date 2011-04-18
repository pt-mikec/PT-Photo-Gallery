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
	2.0.0
History:
	2011-04-14 - MFC - Created
--->
<cfscript>
	request.element.isStatic = 0;
	// Get the items for the data
	items = attributes.elementinfo.elementdata.propertyValues;
</cfscript>
<cfif ArrayLen(items)>
	<cfscript>
		// Call CEData to get the first item if multiple are selected
		photoDataArray = application.ptPhotoGallery.photoDAO.getPhotoData(ListFirst(items[1].values.photos));
	</cfscript>
	<!--- Get the first item out and render that --->
	<cfif ArrayLen(photoDataArray)>
		<cfscript>
			// Get the photo URL
			photoURL = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[1].values.photo, "large");
		</cfscript>
		<cfoutput>
			<img alt="#photoDataArray[1].values.title#" src="#photoURL#">
		</cfoutput>
	</cfif>
</cfif>