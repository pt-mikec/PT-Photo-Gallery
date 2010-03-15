<!---
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Custom Field Type:
	Photo Upload
Name:
	photo_upload_render.cfm
Summary:
	Photo upload field for the PT_Photo_Gallery custom application.
ADF Requirements:
	CEDATA_1_0
	Scripts_1_0
Version:
	0.9.1
History:
	2009-11-04 - MFC - Created
--->
<cfscript>
	// The fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// The param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	// Get the directory path to store the document
	//docPath = xParams.docPath;
	//docURL = xParams.docURL;
	//docTypes = xParams.docTypes;
	
	// Get the properties from the config file
	errorMsg = "";
	// Config - UPLOADPATH
	if ( (StructKeyExists(server.ADF.environment[request.site.id].ptPhotoGallery, "UPLOAD_PATH")) AND (LEN(server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_PATH)) )
		docPath = server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_PATH;
	else
		docPath = "#request.subsiteCache[1].dir#cs_apps/ptPhotoGallery/uploads/";
	
	// Config - UPLOADURL
	if ( (StructKeyExists(server.ADF.environment[request.site.id].ptPhotoGallery, "UPLOAD_URL")) AND (LEN(server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_URL)) )
		docURL = server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_URL;
	else
		docURL = "#request.subsiteCache[1].url#_cs_apps/ptPhotoGallery/uploads/";
	
	// Config - UPLOADDOCTYPES
	if ( (StructKeyExists(server.ADF.environment[request.site.id].ptPhotoGallery, "UPLOAD_DOC_TYPES")) AND (LEN(server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_DOC_TYPES)) )
		docTypes = server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_DOC_TYPES;
	else
		docTypes = "";
		
	if (StructKeyExists(url, 'category'))
		category = url.category;
	else
		category = "";
		
	if (StructKeyExists(url, 'callBack'))
		callBackFunct = url.callBack;
	else
		callBackFunct = "";	
		
	// Load jQuery
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2", 1);
	//application.ptPhotoGallery.scripts.loadJQueryTools();
	application.ptPhotoGallery.scripts.loadADFLightbox();
</cfscript>
<cfoutput>
	<script>
		// javascript validation to make sure they have text to be converted
		#fqFieldName# = new Object();
		#fqFieldName#.id = '#fqFieldName#';
		//#fqFieldName#.tid = #rendertabindex#;
		
		// Global variables
		includeImgGalFlag = "no";
		
		// Check if we need the validation
		if ( '#UCASE(xparams.req)#' == 'YES' ){
			#fqFieldName#.validator = "validatePhoto()";
			#fqFieldName#.msg = "Please upload a Photo.";
			// push on to validation array
			vobjects_#attributes.formname#.push(#fqFieldName#);
		}
		
		function validatePhoto()
		{
			// get the current value of the hidden field
			// do your validation on the field against the parameters
			if( jQuery('###fqFieldName#_upload').val() == "" )
				return false;
			else
				return true;
		}

		// handle the return
		function #fqFieldName#setCSURL(inArgs) {
			
			var url = inArgs[0];
			var dir = inArgs[1];
			
			// Sets value for hidden CS URL page
			jQuery('input###fqFieldName#_upload').val(url);
			// Set the category id for the uploaded image
			jQuery('input###fqFieldName#_directoryPath').val(dir);
			// Update the display image for the selection 
			jQuery('img###fqFieldName#_photo_disp').attr({ 
	          src: url,
	          width: 100,
	          height: 100
	        });
	        jQuery('img###fqFieldName#_photo_disp').show(1000);
			
			// Disable the Category and Image Gallery Checkbox fields
			#fqFieldName#_disableFormFields();
		}
		
		function doOnClick() {
			// Set the value to the category default
			var categoryVal = '#xparams.PHOTOCATEGORY#';
			// Check if the form field is defined or use the default category
			var catFldID = jQuery("input###xparams.catFldName#").attr("id");
			
			// Check if the form field is defined or use the default category
			if ( catFldID == "#xparams.catFldName#" ) {
				categoryVal = jQuery("input###xparams.catFldName#").val();
			}
			
			// Lightbox URL string
			var lbURL = '#application.ptPhotoGallery.getAppConfig().UPLOAD_FORM_URL#?docPath=#docPath#&docURL=#docURL#&docTypes=#docTypes#&category='+categoryVal+'&fieldName=#fqFieldName#&height=300&width=430&title=Upload New Photo';
			// Open the upload lightbox window
			//window.parent.openLB(lbURL, 400);
			openLB(lbURL);
		}
		
		// Disable the Category and Image Gallery Checkbox fields
		function #fqFieldName#_disableFormFields(){
			#xparams.catFldName#_disableFld();
			//#xparams.includeImgGalleryFldName#_disableFld();
		}
		
		// Enable the Category and Image Gallery Checkbox fields
		function #fqFieldName#_enableFormFields(){
			#xparams.catFldName#_enableFld();
			//#xparams.includeImgGalleryFldName#_enableFld();
		}
		
		jQuery(document).ready(function(){
			
			// Load the Category value for the photo into the form field
			// Verify that the category fld is empty then default the category 
			if ( jQuery("input###xparams.catFldName#").val() == '' )
				jQuery("input###xparams.catFldName#").val('#xparams.photoCategory#');
			
			// Set a global Category value variable
			categoryVal = jQuery("input###xparams.catFldName#").val();
			
			// check to see if the uploaded file still exists on the server
			// Get the value for the field value
			var currentFileURL = jQuery("input###fqFieldName#_upload").val();
			if (currentFileURL != "") {
				// Check that the file exists on the server
				jQuery.get( '#application.ADF.ajaxProxy#',
				{ 	
					bean: 'photoService',
					method: 'verifyUploadsFile',
					inFile: currentFileURL,
					categoryID: '#xparams.photoCategory#',
					deleteFile: false
				},
				function(msg){
					if (msg == "false"){
						// Clear the field value
						jQuery("input###fqFieldName#_upload").val("");
						jQuery("input###fqFieldName#_directoryPath").val("");
						// Clear the Image Gallery Page ID field
						// if the photo was stored into the image gallery, then store the page id
						if ( includeImgGalFlag == 'yes' ) {
							// Sets value for hidden Image Gallery PageID field
							setImgGalPageID(0);
						}
						
						// Clear the display upload for the selection
						jQuery('img###fqFieldName#_photo_disp').hide();
					}
					else {
						// We Have a valid photo
						// Hide the category and image gallery fields
						#fqFieldName#_disableFormFields();
					}
				});
			}
			else {
				// clear the img field and hide
				jQuery('img###fqFieldName#_photo_disp').attr({ 
		          src: '',
		          width: 100,
		          height: 100
		        });
		        jQuery('img###fqFieldName#_photo_disp').hide();
			}
			
			// Clear the selected file field
			jQuery('###fqFieldName#_clearField').click( function(){
				
				// Get the value for the field value
				var currentFileURL = jQuery("input###fqFieldName#_upload").val();
				if (currentFileURL != "") {
					// confirmation to clear the image
					var clear = confirm("Attention: This photo will be deleted without saving the form.\n\nAre you sure you want to delete this document?");
					if (clear){
						var imgGalPageID = 0;
						// Get the Image Gallery Page ID Field value
						if ( includeImgGalFlag == 'yes' )
						{
							// Sets value for hidden Image Gallery PageID field
							imgGalPageID = getImgGalPageID();
						}
						
						// Delete the file record
						jQuery.get( '#application.ADF.ajaxProxy#',
						{ 	
							bean: 'photoService',
							method: 'verifyUploadsFile',
							inFile: currentFileURL,
							categoryID: '#xparams.photoCategory#',
							deleteFile: true,
							imgGalPageID: imgGalPageID
						},
						function(msg){
							if (msg == "true"){
								// Clear the field value
								jQuery("input###fqFieldName#_upload").val("");
								jQuery("input###fqFieldName#_directoryPath").val("");
								// Clear the Image Gallery Page ID field
								if ( includeImgGalFlag == 'yes' ) {
									// Sets value for hidden Image Gallery PageID field
									setImgGalPageID(0);
								}
								// Clear the display upload for the selection
								jQuery('img###fqFieldName#_photo_disp').hide(1000);
								
								// Enable the Category and Image Gallery Checkbox fields
								#fqFieldName#_enableFormFields();								
							}
						});
					}
				}			
			});
		});
	</script>
	<!--- // determine if this is rendererd in a simple form or the standard custom element interface --->
	<cfscript>
		if ( structKeyExists(request, "element") )
		{
			labelText = '<span class="CS_Form_Label_Baseline"><label for="#fqFieldName#">#xParams.label#:</label></span>';
			tdClass = 'CS_Form_Label_Baseline';
		}
		else
		{
			labelText = '<label for="#fqFieldName#">#xParams.label#:</label>';
			tdClass = 'cs_dlgLabel';
		}
	</cfscript>
	<tr>
		<td class="#tdClass#" valign="top">
			<font face="Verdana,Arial" color="##000000" size="2">
				<cfif xparams.req eq "Yes"><strong></cfif>
				#labelText#
				<cfif xparams.req eq "Yes"></strong></cfif>
			</font>
		</td>
		<td class="cs_dlgLabelSmall">
			<img id="#fqFieldName#_photo_disp" src="#currentValue#" width="100" height="100" style="display:block;">
			<input type="button" value="Upload..." name="upload_btn_#fqFieldName#" id="upload_btn_#fqFieldName#" onclick="doOnClick()">
			<input type="button" value="Clear" id="#fqFieldName#_clearField">	
		</td>
	</tr>

	<!---// hidden field for document location --->
	<input type="hidden" name="#fqFieldName#" value="#currentValue#" id="#fqFieldName#_upload">
	<input type="hidden" name="#fqFieldName#_directoryPath" value="" id="#fqFieldName#_directoryPath">
	<!--- // include hidden field for simple form processing --->
	<input type="hidden" name="#fqFieldName#_FIELDNAME" id="#fqFieldName#_FIELDNAME" value="#listLast(xParams.fieldName, "_")#">
</cfoutput>