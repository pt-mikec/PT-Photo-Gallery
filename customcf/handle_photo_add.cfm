<!---
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	M Carroll
Name:
	$handle_photo_add
Summary:
	This script will load the simple form to add a new photo.
	After the form has been submitted back and saved, the resizing process
	is called.
	Following that, if the include in image gallery field is present and selected, 
	then the process to upload the photo into the image gallery is called.  Once completed,
	the photo element is updated with the image gallery pageid.
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
//application.ptPhotoGallery.scripts.loadThickbox("3.1");
application.ptPhotoGallery.scripts.loadJQueryUI("1.7.2");
application.ptPhotoGallery.scripts.loadADFlightbox();

// Set the process flag
processForm = 0;
// Check if the form has been submitted
if ( structKeyExists(request.params, "parameters") ) {
	processForm = 1;
}

// Set the session vars before we submit the form
if (processForm EQ 0)
{
	// Var to store the struct to get the values after the form is processed
	session.ptPhotoGallery.addFormStruct = StructNew();
	
	// Lightbox action for rendered link 
	if ( structKeyExists(request.params, "lbaction") )
		tmp = StructInsert(session.ptPhotoGallery.addFormStruct, "lbaction", request.params.lbaction);
	else
		tmp = StructInsert(session.ptPhotoGallery.addFormStruct, "lbaction", "norefresh");
		
	// Check if we have a callback function
	if ( (structKeyExists(request.params, "callback")) )
		tmp = StructInsert(session.ptPhotoGallery.addFormStruct, "callback", request.params.callback);
	else
		tmp = StructInsert(session.ptPhotoGallery.addFormStruct, "callback", "");

}

// Set the photo UID
request.params.photoID = createUUID();
</cfscript>

<cftry>
	<!--- // render the form --->
	<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
		elementName="photo_add_form"
		elementType="form">
	
	<cfif processForm>	
		
		<cfoutput>
			<script type="text/javascript">
				function closeSavingImage(){
					jQuery('##savingImage').hide();
				}
			</script>
			<div id="savingImage" align="center">
				Saving ... <img src="/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif">
			</div>
		</cfoutput>
		
		<cfscript>
			pageIDResult = application.ptPhotoGallery.photoService.handlePhotoFormSubmit(form);
		</cfscript>
		
		<!--- Display the error for if the Image Gallery Upload fails --->
		<!--- <cfif NOT imgGalleryStatus.uploadCompleted>
			<cfoutput>
				<p align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					Upload to Image Gallery failed.<br />
					#imgGalleryStatus.uploadResponse#<br />
				</p>
			</cfoutput>
		</cfif> --->
		<!--- Display status if the ccapi to update the element --->
		<!--- <cfdump var="#pageIDResult#" label="pageIDResult" expand="false"> --->
		<cfif ( StructKeyExists(pageIDResult, "contentUpdated") AND pageIDResult.contentUpdated ) >
			<cfoutput>
				<script type="text/javascript">
					closeSavingImage();
				</script>
				<div width="100%" align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					<cfif session.ptPhotoGallery.addFormStruct.lbaction EQ "refreshParent">
						<a href="javascript:;" onclick="closeLBReloadParent();">Click here to close and refresh.</a>
					<cfelse>
						<a href="javascript:;" onclick="closeLB();">Click here to close.</a>
					</cfif>
				</div>
			</cfoutput>
			<!--- do we have a callback function --->
			<cfif LEN(session.ptPhotoGallery.addFormStruct.callback)>
				<!--- get the photoid from the form --->
				<cfset formData = application.ptPhotoGallery.forms.extractFromSimpleForm(form, "photoID")>
				<!--- get the updated data from the element record --->
				<cfset dataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", formData.photoID)>
				<!--- check that we get the data back --->
				<cfif ArrayLen(dataArray)>
					<!--- call the callback function --->
					<cfoutput>
					<script type="text/javascript">
						// Build an array to pass back to the caller
						var outArgsArray = new Array();
				    	outArgsArray[0] = '#dataArray[1].values.photo#';
				    	outArgsArray[1] = '#dataArray[1].values.photoid#';
						
						// Make the ADFLightbox callback
						getCallback('#session.ptPhotoGallery.addFormStruct.callback#', outArgsArray);
					</script>
					</cfoutput>
				</cfif>
			</cfif>
			<!--- Check if we want to just close the LB and no confirmation message --->
			<cfif session.ptPhotoGallery.addFormStruct.lbaction EQ "noconfirm">
				<cfoutput>
				<script type="text/javascript">
					closeLB();
				</script>
				</cfoutput>
			</cfif>
		<cfelse>
			<cfoutput>
				<script type="text/javascript">
					closeSavingImage();
				</script>
				<p align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					<strong>Photo Upload Error!</strong><br />
					<a href="javascript:;" onclick="closeLB();">Click here to close</a>
				</p>
			</cfoutput>
		</cfif>
		<!--- Clear this session variable after the form is processed --->
		<cfset session.ptPhotoGallery.addFormStruct = StructNew()>
	</cfif>
<cfcatch>
	<cfoutput>Error Occcured.</cfoutput>
	<cfdump var="#cfcatch#" label="cfcatch" expand="false">
</cfcatch>
</cftry>