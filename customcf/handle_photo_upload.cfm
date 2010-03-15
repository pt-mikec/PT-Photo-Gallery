<!---
/* ***************************************************************
/*
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
	0.9.0
History:
	2009-08-04 - MFC - Created
--->

<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2", 1);
	//application.ptPhotoGallery.scripts.loadThickbox("3.1");
	//application.ptPhotoGallery.scripts.loadJQueryTools();
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
		});
	});
</script>

<!--- DIV text for the photo dialog --->
<div id="photoDialog"></div>
</cfoutput>