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
	PaperThin, Inc.
	M Carroll
Name:
	$handle_photo_upload
Summary:
	This script will load the lightbox for the photo uploading.  
	On submission of the form the photo will be uploaded to the 'TEMP' directory,
		then validated for the login category.
ADF App:
	pt_photo_gallery
Version:
	1.3
History:
	2009-08-04 - MFC - Created
	2010-08-19 - MFC - Updated the load JQuery and JQuery versions to use the global versioning.
--->

<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery(force=1);
	application.ptPhotoGallery.scripts.loadADFLightbox();
	
	// set the form action variable
	if ( NOT StructKeyExists(request.params, "formAction") )
		request.params.formAction = "upload";
	if ( NOT StructKeyExists(request.params, "uploadDoc") )
		request.params.uploadDoc = "";
		
	// Set the default values
	photoTempDirPath = "";
	photoTempURLPath = "";
</cfscript>

<cfscript>
	CD_DialogName = request.params.title;
	CD_Title=CD_DialogName;
	CD_IncludeTableTop=0;
	CD_CheckLock=0;
	CD_CheckLogin=1;
	CD_CheckPageAlive=0;
	APIPostToNewWindow = false;
</cfscript>
<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-head.cfm">
<!--- <cfoutput><tr><td></cfoutput> --->

<!--- Upload the file to the TEMP directory --->
<cfif request.params.formAction NEQ "upload">
	<!--- TEMP Folder --->	
	<cfif not directoryExists(request.params.docPath & "temp/")>
		<cfdirectory action="create" directory="#request.params.docPath#temp">
	</cfif>
	
	<cffile action="upload" 
			filefield="uploadDoc"
			destination="#request.params.docPath#temp/"
			nameconflict="makeunique">
	
	<cfset photoTempDirPath = "#request.params.docPath#temp/#cffile.serverFile#">
	<cfset photoTempURLPath = "#request.params.docURL#temp/#cffile.serverFile#">
	<cfset fileExtension = cffile.CLIENTFILEEXT>	
	
	<!--- Reprocess the temp image to contain the width and height --->
	<cfscript>
		// Read the original image
		imageData = ImageRead(photoTempDirPath);
		//application.ADF.utils.dodump(imageData, "imageData", false);	
		
		// Check if the file extension is not PNG
		if ( fileExtension NEQ "png" ){
			
			// Create the new image paths
			newPhotoTempDirPath = ReplaceNocase(photoTempDirPath,".#fileExtension#", ".png" );
			newPhotoTempURLPath = ReplaceNocase(photoTempURLPath,".#fileExtension#", ".png" );
			
			// Convert the image to PNG
			ImageWrite(imageData, newPhotoTempDirPath);
			
			// Delete the old image format
			fileDeleteOp = application.ptPhotoGallery.csdata.CSFile(action="delete", file="#photoTempDirPath#");
			
			// Store the new image paths back into the paths
			photoTempDirPath = newPhotoTempDirPath;
			photoTempURLPath = newPhotoTempURLPath;
		
			// Reload the image data for processing
			imageData = ImageRead(photoTempDirPath);
		}
	</cfscript>
	
</cfif>
<cfoutput>
<script type="text/javascript">
	jQuery(document).ready(function(){
		
		// Load the photo dialog
		jQuery.get( '#application.ADF.ajaxProxy#',
		{ 	
			bean: 'photoUploadService',
			method: 'loadPhotoUploadDialog',
			docPath: '#request.params.docPath#',
			docURL: '#request.params.docURL#',
			docTypes: '#request.params.docTypes#',
			category: '#request.params.category#',
			fieldName: '#request.params.fieldName#',
			photoTempDirPath: '#photoTempDirPath#',
			photoTempURLPath: '#photoTempURLPath#'
		},
		function(msg){
			// Load response into the div
			jQuery("div##photoDialog").html(msg);
			ResizeWindow();
		});
	});
</script>

<!--- DIV text for the photo dialog --->
<div id="photoDialog"></div>
</cfoutput>

<!--- <cfoutput></tr></td></cfoutput> --->
<CFINCLUDE template="/commonspot/dlgcontrols/dlgcommon-foot.cfm">