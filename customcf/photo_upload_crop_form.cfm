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
	$photo_upload_crop_form
Summary:
	Custom form to upload and crop an photo into the photo gallery app.
ADF App:
	pt_photo_gallery
Version:
	1.0.0
History:
	2009-12-15 - MFC - Created
	2010-04-30 - MFC - Update the CFT for the ADF Lightbox
--->
<cfscript>
	// Load the lightbox
	application.ptPhotoGallery.scripts.loadADFLightbox(force=1);
		
	// Check if the action is defined
	if ( NOT StructKeyExists(request.params, "action") )
		request.params.action = "form";

	appConfig = application.ptPhotoGallery.getAppConfig();
	
	// Config - UPLOADPATH
	if ( (StructKeyExists(appConfig, "UPLOAD_PATH")) AND (LEN(appConfig.UPLOAD_PATH)) )
		docPath = appConfig.UPLOAD_PATH;
	else
		docPath = "#request.site.dir#cs_apps/ptPhotoGallery/uploads/";
	
	// Config - UPLOADURL
	if ( (StructKeyExists(appConfig, "UPLOAD_URL")) AND (LEN(appConfig.UPLOAD_URL)) )
		docURL = appConfig.UPLOAD_URL;
	else
		docURL = "#request.site.CSAPPSURL#ptPhotoGallery/uploads/";
		
	// Check if a callback is NOT defined
	if ( NOT StructKeyExists(request.params, "callback") )
		request.params.callback = "";
		
	if ( NOT StructKeyExists(request.params, "category"))	
		request.params.category = "";
</cfscript>

<!--- Check if the Upload Crop URL page is setup --->
<cfif StructKeyExists(appConfig, "UPLOAD_CROP_URL") AND LEN(appConfig.UPLOAD_CROP_URL)>
	
	<cfif request.params.action EQ "form">
		<!--- Load the category data structure --->
		<!--- 
		<cfset catData = application.ptPhotoGallery.photoService.loadCategoryData(request.params.category)>
		 --->
		<cfoutput>
			
		<!--- // handle the javascript check for document types --->
		<script type="text/javascript">
			function checkDocType(theForm)
			{
				var isValid = false;
				var docTypesList = 'jpg,gif,png,bmp';
				var fieldValue = document.getElementById('uploadDoc').value;
				// determine the documentType for the uploaded document
				var dot = fieldValue.lastIndexOf(".");
				var currentDocType = fieldValue.substring(dot + 1, fieldValue.length);
				// make an array of the comma separated list of docTypes
				var docTypesArray = docTypesList.split(",");
				// loop through the valid document types and compare against current document type
				for( var itm=0; itm < docTypesArray.length; itm++ )
				{
					if( docTypesArray[itm].toUpperCase() == currentDocType.toUpperCase() )
					{
						isValid = true;
						break;
					}
				}
				if( isValid )
					document.getElementById('docForm').submit();
				else
				{
					alert("Please enter a valid Document Type");
					document.getElementById("uploadbutton").disabled = 0;
					document.getElementById("uploadbutton").value = "Do Upload";
					return false;
				}
			}
		</script>
		
		<cfscript>
			// Get the category data structure
			catData = application.ptPhotoGallery.photoService.loadCategoryData(request.params.category);
		</cfscript>
		<!--- <cfdump var="#catData#" label="catData" expand="false"> --->
		
		<div align="center">
			<!--- // form for uploading the document --->
			<form action="#appConfig.UPLOAD_CROP_URL#" id="docForm" class="cs_default_form" method="post" enctype="multipart/form-data">
				<!--- // hidden form field for the subsite where the document should be uploaded --->
				<input type="hidden" name="callback" value="#request.params.callback#">
				<input type="hidden" name="category" value="#request.params.category#">
				<input type="hidden" name="action" value="crop">
				<input type="hidden" name="width" value="750">
				<input type="hidden" name="height" value="800">
				<input type="hidden" name="title" value="Add Photo">
				<table>
					<tr>
						<td colspan="2">
							<p>
								Select the #catData.Title# photo to upload into the photo gallery.
							</p>
							<p>
								The photo is required to have the minumum dimensions of #catData.initialSizeArray[1].Values.width# X #catData.initialSizeArray[1].Values.height#
							</p>
							
						</td>
					</tr>
					<tr>
						<td class="cs_dlgLabelSmall">Browse for file:</td>
						<td class="cs_dlgLabelSmall"><input type="file" id="uploadDoc" name="uploadDoc"><br>Valid document types are: jpg, gif, png, or bmp </td>
					</tr>
					<tr>
						<td class="cs_dlgLabelSmall"></td>
						<td class="cs_dlgLabelSmall"><input type="button" value="Do Upload" onclick="this.disabled='disabled';this.value='Processing...';checkDocType(this.form);" id="uploadbutton"/><input type="button" value="Cancel" onclick="closeLB();"></td>
					</tr>
				</table>
			</form>
		</div>
		</cfoutput>
	
	<cfelseif request.params.action EQ "crop">
		
		<cftry>
			
			<cfscript>
				application.ADF.scripts.loadJcrop();
				// Load the category data structure
				catData = application.ptPhotoGallery.photoService.loadCategoryData(request.params.category);
				
				// Check that we have category data
				if ( ArrayLen(catData.INITIALSIZEARRAY) ){
					// Check the initial size array
					maxWidth = catData.INITIALSIZEARRAY[1].values.width;
					maxHeight = catData.INITIALSIZEARRAY[1].values.height;
					// Set the aspect ratio
					aspectRatio = NumberFormat(catData.INITIALSIZEARRAY[1].values.width/catData.INITIALSIZEARRAY[1].values.height, "_.__");
				}
				else {
					maxWidth = 0;
					maxHeight = 0;
					aspectRatio = 1;
				}
			</cfscript>
			
			<!--- <cfdump var="#catData#" label="catdata" expand="false">
			<cfoutput>
				<p>maxWidth = #maxWidth#</p>
				<p>maxHeight = #maxHeight#</p>
				<p>aspectRatio = #aspectRatio#</p>
			</cfoutput> --->
			
			<!--- TEMP Folder --->	
			<cfif not directoryExists(docPath & "temp/")>
				<cfdirectory action="create" directory="#docPath#temp">
			</cfif>
		
			<!--- <cffile action="upload" 
					filefield="uploadDoc"
					destination="#docPath#temp/"
					nameconflict="makeunique">
			<cfset photoTempDirPath = "#docPath#temp/#cffile.serverFile#">
			<cfset photoTempURLPath = "#docURL#temp/#cffile.serverFile#">
			<cfdump var="#photoTempDirPath#" label="photoTempDirPath" expand="false">
			<cfdump var="#photoTempURLPath#" label="photoTempURLPath" expand="false"> --->
			
			<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
								action= "upload",
								filefield="uploadDoc",
								destination= "#docPath#temp/",
								nameconflict="makeunique"
							) >
			<!--- <cfdump var="#fileOp#" label="fileOp" expand="false"> --->
			<cfset photoTempDirPath = "#docPath#temp/#fileOp.cffile.serverFile#">
			<cfset photoTempURLPath = "#docURL#temp/#fileOp.cffile.serverFile#">
			<cfset fileExtension = fileOp.cffile.CLIENTFILEEXT>	
				
			<!--- Reprocess the temp image to contain the width and height --->
			<cfscript>
				// Default image width
				defaultPhotoDim = 700;
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
				
				// Check if the width and height meet the minimum reqs
				if ( (imageData.width LT catData.INITIALSIZEARRAY[1].values.width) OR (imageData.height LT catData.INITIALSIZEARRAY[1].values.height) ) {
					
					// Resize the image to be the minimum size to crop
					newWidth = catData.INITIALSIZEARRAY[1].values.width;
					newHeight = catData.INITIALSIZEARRAY[1].values.height;
					
					// Resize the image
					ImageResize(imageData, newWidth, newHeight);
					// Update the original to the new croppped image
					ImageWrite(imageData, photoTempDirPath);
				}
				
				// Check if the width and height are over defaultPhotoDim px
				if ( (imageData.width GT defaultPhotoDim) OR (imageData.height GT defaultPhotoDim) ) {
					// Determine the current ratio
					currAspectRatio = NumberFormat(imageData.width/imageData.height, "_.__");
					//application.ADF.utils.dodump(currAspectRatio, "currAspectRatio", false);
				
					// If the width is too large, then rescale based on the width
					if ( imageData.width GT defaultPhotoDim ){
						newWidth = defaultPhotoDim;
						newHeight = Round(newWidth/currAspectRatio);
					}
					else if ( imageData.height GT defaultPhotoDim ){
						// Else the height is too large
						newHeight = defaultPhotoDim;
						newWidth = Round(newHeight * currAspectRatio);
					}
		
					//application.ADF.utils.dodump(newWidth, "newWidth", false);	
					//application.ADF.utils.dodump(newHeight, "newHeight", false);
			
					// Resize the image
					ImageResize(imageData, newWidth, newHeight);
					// Update the original to the new croppped image
					ImageWrite(imageData, photoTempDirPath);
				}
				imageData = ImageRead(photoTempDirPath);
			</cfscript>
			
			<cfoutput>
			<script language="Javascript">
		
				// Remember to invoke within jQuery(window).load(...)
				// If you don't, Jcrop may not initialize properly
				jQuery(document).ready(function(){
					jQuery('##cropbox').Jcrop({
						onChange: showCoords,
						onSelect: showCoords,
						minSize: [#maxWidth#, #maxHeight#],
						setSelect: [0,0, #maxWidth#, #maxHeight#],
						aspectRatio: #aspectRatio#
					});
				});
		
				// Our simple event handler, called from onChange and onSelect
				// event handlers, as per the Jcrop invocation above
				function showCoords(c)
				{
					jQuery('input##crop_x').val(c.x);
					jQuery('input##crop_y').val(c.y);
					jQuery('input##crop_x2').val(c.x2);
					jQuery('input##crop_y2').val(c.y2);
					jQuery('input##crop_w').val(c.w);
					jQuery('input##crop_h').val(c.h);
				};
		
			</script>
			
			<!--- Set the fixed hieght for the window --->
			<style>
				div##photoCropperForm {
					overflow-y: auto;
					height: 500px;
				}
			</style>
			<div id="photoCropperForm">
				<form action="#appConfig.UPLOAD_CROP_URL#" id="docForm" method="post">
					<input type="hidden" name="photoTempURL" id="docURL" value="#photoTempURLPath#">
					<input type="hidden" name="photoTempDir" id="docDir" value="#photoTempDirPath#">
					<input type="hidden" name="callback" value="#request.params.callback#">
					<input type="hidden" name="category" value="#request.params.category#">
					<input type="hidden" name="categoryTitle" value="#catData.Title#">
					<input type="hidden" name="action" value="process">
					<input type="hidden" name="crop_x" id="crop_x" value="">
					<input type="hidden" name="crop_y" id="crop_y" value="">
					<input type="hidden" name="crop_x2" id="crop_x2" value="">
					<input type="hidden" name="crop_y2" id="crop_y2" value="">
					<input type="hidden" name="crop_w" id="crop_w" value="">
					<input type="hidden" name="crop_h" id="crop_h" value="">
					<input type="hidden" name="final_width" id="final_width" value="#maxWidth#">
					<input type="hidden" name="final_height" id="final_height" value="#maxHeight#">
					<p>
						Title: <input type="text" size="50" id="photoTitle" name="photoTitle" value="">
					</p>
					<p>
						Caption: <input type="text" size="50" id="photoCaption" name="photoCaption" value="">
					</p>
					<p>
						<!--- This is the image we're attaching Jcrop to --->
						<img src="#photoTempURLPath#" id="cropbox" />
					</p>
					<p>
						<input type="button" value="Save Image" onclick="this.disabled='disabled'; this.value='Processing...'; this.form.submit();">
					</p>
				</form>
				<!--- Resize the LB window for the fixed height --->
				<script>
					jQuery(document).ready(function(){
						commonspot.lightbox.resizeCurrent(#request.params.width#, 550);
					});
				</script>
			</div>
			</cfoutput>
	
			<cfcatch>
				<cfoutput>
					<p align="center">
						<strong>Error with the photo processing.</strong>
					</p>
					<p align="center">
						<strong>Please try uploading a different photo.</strong>
					</p>
					<p align="center">
						<a href="javascript:;" onclick="closeLB();">Close this window</a>
					</p>
				</cfoutput>
			</cfcatch>
		</cftry>
		
	<cfelseif request.params.action EQ "process">
		
		<cfoutput>
			<div id="process" align="center">
				Processing the Image...<img src="/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif"> 
			</div>
		</cfoutput>
		<cfscript>
			// Load Lightbox
			application.ADF.scripts.loadADFLightbox();
			
			// Read the original image in
			origImg = ImageRead(request.params.photoTempDir);
			// Crop out the new image
			croppedImg = imageCopy(origImg, request.params.crop_x, request.params.crop_y, request.params.crop_w, request.params.crop_h);
			//application.ADF.utils.dodump(croppedImg, "croppedImg - 1", false);
	  		
	  		// Check that we have category data
			// Resize the cropped image to the category dimensions
			//if ( ArrayLen(catData.INITIALSIZEARRAY) )
			//	ImageResize(croppedImg, catData.INITIALSIZEARRAY[1].values.width, catData.INITIALSIZEARRAY[1].values.height);
			
			if ( (request.params.final_width GT 0) AND (request.params.final_height GT 0) ){
				ImageResize(croppedImg, request.params.final_width, request.params.final_height);
				//application.ADF.utils.dodump(croppedImg, "croppedImg - 2", false);
			}
			
			// Check if the height and width are under the final dimensions
			// Resolve the bug in CFIMAGE that will create the image 1 pixel less than defined.
			if ( (request.params.final_width GT croppedImg.width) AND (request.params.final_height GT croppedImg.height) ) {
				ImageResize(croppedImg, request.params.final_width, request.params.final_height);
				//application.ADF.utils.dodump(croppedImg, "croppedImg - 3", false);		
			}
					
			// Update the original to the new croppped image
			ImageWrite(croppedImg, request.params.photoTempDir);
			
			// Build the data struct to create the photo record
			photoUID = createUUID();
			dataStruct = StructNew();
			dataStruct.photoID = photoUID;
			dataStruct.category = request.params.category;
			dataStruct.photo = request.params.photoTempURL;
			//application.ADF.utils.dodump(dataStruct);
	
			// Check if a title was defined
			if ( LEN(request.params.photoTitle) )
				dataStruct.title = request.params.photoTitle;
			else
				dataStruct.title = "#request.params.categoryTitle# Photo";
			// Set the photo caption
			dataStruct.caption = request.params.photoCaption;
			
			createStatus = application.ptPhotoGallery.photoDAO.photoCCAPI(dataStruct);
		</cfscript>
		<!--- <cfdump var="#createStatus#" label="createStatus" expand="false"> --->
		
		<cfif createStatus.contentUpdated>
			<!--- // get the data for the new record --->
			<cfset photoData = application.ptPhotoGallery.cedata.getCEData("Photo", "photoID", photoUID)>
			<!--- // Process the photo --->
			<cfset pageIDResult = application.ptPhotoGallery.photoService.processPhoto(photoData[1].pageid, photoData[1].formid)>
			<!--- <cfdump var="#pageIDResult#" label="pageIDResult" expand="false">		 --->
			
			<!--- <cfdump var="#pageIDResult#" label="pageIDResult" expand="false"> --->
			<!--- // If processing completed, then get the new photo data --->
			<cfif ( pageIDResult.contentUpdated )>
				<!--- // get the data for the new record --->
				<cfset photoData = application.ptPhotoGallery.cedata.getCEData("Photo", "photoID", photoUID)>
				<!--- check if photo data exists --->
				<cfif ArrayLen(photoData)>
					<cfoutput>
						<!--- Check if we have a callback --->
						<cfif LEN(request.params.callback)>
							<script type="text/javascript">
								// Build an array to pass back to the caller
								var outArgsArray = new Array();
						    	outArgsArray[0] = '#photoData[1].values.photo#';
						    	outArgsArray[1] = '#photoData[1].values.photoid#';
								// Make the ADFLightbox callback
								getCallback('#request.params.callback#', outArgsArray);
							</script>
						</cfif>
						<script type="text/javascript">
							// Close the lightbox
							closeLB();
						</script>
					</cfoutput>
				</cfif>
			
			<cfelse>
				<cfoutput>
					<cfif (StructKeyExists(pageIDResult, "msg")) AND (LEN(pageIDResult.msg))>
						<div id="error" align="center">
							<p><!--- #pageIDResult.msg# --->
								Error cropping and uploading the image.  Please try again.
							</p>
							<p>
								<a href="javascript:;" onclick="closeLB();">Return to form</a>
							</p>
						</div>
					</cfif>
					<!--- <input type="button" value="Please Try Again" onclick="document.location='#application.ptPhotoGallery.getAppConfig().UPLOAD_FORM_URL#?docURL=#arguments.inArgs.docURL#&docPath=#arguments.inArgs.docPath#&docTypes=#arguments.inArgs.docTypes#&category=#arguments.inArgs.category#&fieldName=#arguments.inArgs.fieldName#';"> --->
					<!--- script to hide the loading message --->
					<script type="text/javascript">
						jQuery("##process").hide();
					</script>
				</cfoutput>	
			</cfif>
		</cfif>
		
	<cfelse>
		<cfoutput>
			<p align="center">
				<strong>Error with the photo processing.</strong>
			</p>
		</cfoutput>
	</cfif>
	
<cfelse>
	<cfoutput>
		<div width="100%" align="center" style="font-size:small;">
			Photo Upload Crop Field is not configured.  Please consult the documentation.
		</div>
	</cfoutput>
</cfif>
	