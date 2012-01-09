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