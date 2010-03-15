<!---
	$Id: photo-id-image-preview-display-render.cfm,v 0.1 2009/11/12 

	Description:
		
	Parameters:
		none
	Usage:

	Documentation:
		2009-11-12 - MFC - Initial Version
	Based on:
--->
<cfif len(Request.Datasheet.CurrentColumnValue)>
	<cfscript>
		photoImg = "No image preview";
		// get the Photo data 
		photoData = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", Request.Datasheet.CurrentColumnValue);
		
		if ( ArrayLen(photoData) )
		{
			photoURL = application.ptPhotoGallery.renderService.getPhotoURL(photoData[1].Values.photo,"small");
			photoImg = "<img src='#photoURL#' width='50' height='50' hspace='5' rel='#photoURL#?width=650' class='ADFLightbox'>";
		}
	</cfscript>
	<cfsavecontent variable="variables.celldata">
	<cfoutput>
		#photoImg#
	</cfoutput>
	</cfsavecontent>
	<cfset Request.Datasheet.CurrentFormattedValue = "<td>#variables.celldata#</td>" />
</cfif>