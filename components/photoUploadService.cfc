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
/* *************************************************************** */
Author: 	
	PaperThin Inc.
	M. Carroll
Name:
	uploadService.cfc
Summary:
	Photo Upload Service for the Photo Gallery
ADF App:
	PT_Photo_Gallery
Version:
	2.0
History:
	2009-08-04 - MFC - Created
--->
<cfcomponent displayname="photoUploadService" extends="ADF.apps.pt_photo_gallery.components.App">

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$loadPhotoUploadDialog
Summary:
	Loads the photo upload dialog in the photo service.
Returns:
	String - HTML code for the upload photo dialog box.
Arguments:
	String - docPath
	String - docURL
	String - docTypes
	String - category
	String - fieldName
History:
	2009-06-09 - MFC - Created
	2010-03-17 - MFC - Added check to verify the category ID passed in is a valid category.
	2010-06-14 - MFC - Removed old CD dialog code.
--->
<cffunction name="loadPhotoUploadDialog" access="public" returntype="string" hint="Loads the photo upload dialog in the photo service.">
	<cfargument name="docPath" type="string" required="true">
	<cfargument name="docURL" type="string" required="true">
	<cfargument name="docTypes" type="string" required="true">
	<cfargument name="category" type="string" required="true">
	<cfargument name="fieldName" type="string" required="true">
	<cfargument name="photoTempDirPath" type="string" required="false" default="">
	<cfargument name="photoTempURLPath" type="string" required="false" default="">
		
	<cfset var retHTML = "">
	<!--- Verify the category is valid --->
	<cfset catData = application.ptPhotoGallery.photoService.loadCategoryData(arguments.category, arguments.docPath, arguments.docURL)>
	<!--- Verify the category is valid --->
	<cfif (NOT ArrayLen(catData.initialSizeArray)) AND (NOT LEN(catData.title))>
	
		<cfsavecontent variable="retHTML">
			<!--- // set up the common cs dialog data --->
			<cfscript>
				application.ptPhotoGallery.scripts.loadADFLightbox();
			</cfscript>
			<!--- <cfinclude template="/commonspot/dlgcontrols/dlgcommon-head.cfm"> --->
			<cfoutput>
			<table id="MainTable" width="450px;">
				<tr>
					<td class="cs_dlgTitle">Upload New Photo</td>
				</tr>
				<tr>
					<td>
						Please select a category for the uploaded photo.<br /><br />
						<input type="button" value="Return to Form" onclick="window.close();">
					</td>
				</tr>
			</table>
			</cfoutput>
			<!--- <cfinclude template="/commonspot/dlgcontrols/dlgcommon-foot.cfm"> --->
		</cfsavecontent>
		<cfreturn retHTML>
	</cfif>
	<cfset retHTML = renderPhotoUploadDialog(arguments)>
	<cfreturn retHTML>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$renderPhotoUploadDialog
Summary:
	Renders the HTML dialog box to upload a photo.
Returns:
	String - HTML code for the upload photo dialog box.
Arguments:
	Structure - inArgs - Argument structure passed from the Ajax Service.
History:
	2009-06-09 - MFC - Created
	2009-11-04 - MFC - Updated script for ADF Lightbox
	2010-06-14 - MFC - Removed old CD dialog code.
	2012-01-03 - MFC - Removed any lightbox header and footer code.
--->
<cffunction name="renderPhotoUploadDialog" access="public" returntype="String" hint="Renders the HTML dialog box to upload a photo.">
	<cfargument name="inArgs" type="struct" required="true" hint="Argument structure passed from the Ajax Service.">

	<cfset var retHTML = "">
	<cfset var catData = StructNew()>

	<cfsavecontent variable="retHTML">
		<!--- // set up the common cs dialog data --->
		<cfscript>
			application.ptPhotoGallery.scripts.loadADFLightbox();
		</cfscript>
		
		<!--- Set the flag for if the photo is uploaded --->
		<cfset photoUploaded = false>
		<cfif ( StructKeyExists(arguments.inArgs, "photoTempURLPath") ) AND ( LEN(arguments.inArgs.photoTempURLPath) )>
			<cfset photoUploaded = true>
		</cfif>
	
		<!--- Load the category data structure --->
		<cfset catData = application.ptPhotoGallery.photoService.loadCategoryData(arguments.inArgs.category, arguments.inArgs.docPath, arguments.inArgs.docURL)>

		<!--- do the photo upload operations --->
		<cfif photoUploaded>
			<!--- Verify that the photo uploaded meets the initial size reqs --->
			<cfset uploadTemp = verifyTempPhotoReqDim(catData, arguments.inArgs.photoTempDirPath, arguments.inArgs.photoTempURLPath)>
						
			<cfif (NOT uploadTemp.error)>
				<cfoutput>
					<div style="width:100%;text-align:center">
						<p>	
							<img src="/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif"><br>
						</p>
						<p>
							Saving Photo
						</p>
					</div>
					<cfscript>
						//application.ptPhotoGallery.scripts.loadADFLightbox();
					</cfscript>
					<!--- // take the URL for the new docuemnt and send it back to the calling page --->
					<script type="text/javascript">
						var outArgsArray = new Array();
				    	outArgsArray[0] = "#uploadTemp.tempURLPath#";
				    	outArgsArray[1] = "#uploadTemp.tempDirPath#";
										
						// Process the callback function
						getCallback('#arguments.inArgs.fieldName#setCSURL', outArgsArray);
						
						// Close the lightbox
						closeLB();
					</script>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<cfif (StructKeyExists(uploadTemp, "errorMsg")) AND (LEN(uploadTemp.errorMsg))>
						#uploadTemp.errorMsg#<br />
					</cfif>
					<input type="button" value="Please Try Again" onclick="document.location='#application.ptPhotoGallery.getAppConfig().UPLOAD_FORM_URL#?docURL=#arguments.inArgs.docURL#&docPath=#arguments.inArgs.docPath#&docTypes=#arguments.inArgs.docTypes#&category=#arguments.inArgs.category#&fieldName=#arguments.inArgs.fieldName#';">
				</cfoutput>	
			</cfif>
		<cfelse>
			<cfoutput>
			<!--- // handle the javascript check for document types --->
			<script type="text/javascript">
				function checkDocType(theForm)
				{
					var isValid = false;
					var docTypesList = '#arguments.inArgs.docTypes#';
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
			<!--- // form for uploading the document --->
			<form action="#application.ptPhotoGallery.getAppConfig().UPLOAD_FORM_URL#" id="docForm" class="cs_default_form" method="post" enctype="multipart/form-data">
				<!--- // hidden form field for the subsite where the document should be uploaded --->
				<input type="hidden" name="docPath" value="#arguments.inArgs.docPath#">
				<input type="hidden" name="docURL" value="#arguments.inArgs.docURL#">
				<input type="hidden" name="docTypes" value="#arguments.inArgs.docTypes#">
				<input type="hidden" name="fieldName" value="#arguments.inArgs.fieldName#">
				<input type="hidden" name="category" value="#arguments.inArgs.category#">
				<input type="hidden" name="formAction" value="save">
				<table>
					<tr>
						<td colspan="2">
							Possible photo upload dimensions are the following:<br />
							<cfloop index="initSize_l" from="1" to="#arraylen(catData.initialSizeArray)#">
								&nbsp;&nbsp;&nbsp;#catData.initialSizeArray[initSize_l].Values.title# = #catData.initialSizeArray[initSize_l].Values.width# X #catData.initialSizeArray[initSize_l].Values.height#<br />
							</cfloop>
							<br /><br />
						</td>
					</tr>
					<tr>
						<td class="cs_dlgLabelSmall">Browse for file:</td>
						<td class="cs_dlgLabelSmall"><input type="file" id="uploadDoc" name="uploadDoc"><br>Valid document types are: <cfloop list="#url.docTypes#" index="docType">.#docType# </cfloop></td>
					</tr>
					<tr>
						<td class="cs_dlgLabelSmall"></td>
						<td class="cs_dlgLabelSmall"><input type="button" value="Do Upload" onclick="this.disabled='disabled';this.value='processing...';checkDocType(this.form);" id="uploadbutton"/><input type="button" value="Cancel" onclick="closeLB();"></td>
					</tr>
				</table>
			</form>
			</cfoutput>
		</cfif>
	</cfsavecontent>
	<cfreturn retHTML>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$verifyTempPhotoReqDim
Summary:
	Verifies the uploaded temp photo matches the category required size.
Returns:
	Struct - Temp photo data to return
Arguments:
	Struct - categoryData - Structure containing the category data for required and resize dimensions.
	String - tempDirPath - Photo Temp dir path
	String - tempURLPath - Photo Temp URL path
History:
	2009-07-06 - MFC - Created
--->
<cffunction name="verifyTempPhotoReqDim" access="private" returntype="Struct" hint="Upload the photo to the temp directory and store the path in the field.">
	<cfargument name="categoryData" type="struct" required="true" hint="Structure containing the category data for required and resize dimensions.">
	<cfargument name="tempDirPath" type="string" required="true">
	<cfargument name="tempURLPath" type="string" required="true">
	
	<cfscript>
		var retPhoto = StructNew();
		var objImageInfo = StructNew();
		var photoInitSizeMatch = false;
		var initSize_j = 1;
		var currPhotoDir = "";
		var dirOp = "";
		
		retPhoto.error = false;
		retPhoto.tempURLPath = "";
		retPhoto.tempDirPath = "";
	</cfscript>
<!--- <cfdump var="#arguments#" label="arguments" expand="false">	 --->
	<!--- // upload the document to a local file system --->
	<cftry>

		<!--- check if the directory exists or create --->
		<cfif not directoryExists(arguments.categoryData.photoDirPath)>
			 <cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: arguments.categoryData.photoDirPath
						) />
			 <!--- <cfdirectory action="create" directory="#arguments.categoryData.photoDirPath#">  --->
		</cfif>
<!--- <cfdump var="#arguments#" label="arguments" expand="false"> --->		
		<!---
			Read in the image file. This will read in the binary
			image into an object of coldfusion.image.Image.
		--->
		<cfimage action="INFO" 
				 source="#arguments.tempDirPath#" 
				 structname="objImageInfo">
<!--- <cfdump var="#objImageInfo#" label="objImageInfo" expand="false"> --->		
		<!--- flag to know if the uploaded photo has a matching initial size --->
		<cfset photoInitSizeMatch = false>
		<!--- Loop over the Initial Size Requirements to find a match for the uploaded photo --->
		<cfloop index="initSize_j" from="1" to="#ArrayLen(arguments.categoryData.initialSizeArray)#">
			<!--- match the width and the height --->
			<cfif (objImageInfo.width eq arguments.categoryData.initialSizeArray[initSize_j].Values.width) AND
					(objImageInfo.height eq arguments.categoryData.initialSizeArray[initSize_j].Values.height)>
				<!--- Current photo directory --->
				<cfset currPhotoDir = "#arguments.categoryData.photoDirPath##arguments.categoryData.initialSizeArray[initSize_j].Values.directory#/">
				<!--- check if the directory exists or create --->
				<cfif not directoryExists(currPhotoDir)>
					<cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: currPhotoDir
						) />
					 <!--- <cfdirectory action="create" directory="#currPhotoDir#">  --->
				</cfif>
				
				<!--- // store the image in the initial size directory  --->
				<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
									action: "copy",
									source: arguments.tempDirPath,
									destination: currPhotoDir&"/"&ListLast(arguments.tempDirPath,'/')
								) />

				<!--- <cffile action="copy" 
					source = "#arguments.tempDirPath#"
					destination = "#currPhotoDir#"> --->
					
				<cfset photoInitSizeMatch = true>
				<cfbreak> <!--- found the photo match, exit the loop --->
			</cfif>
		</cfloop>
		<!--- found a matching size, and do photo operations --->
		<cfif photoInitSizeMatch>
			<!--- Photo upload to temp success, pass the values back --->
			<cfscript>
				retPhoto.error = false;
				retPhoto.tempURLPath = arguments.tempURLPath;
				retPhoto.tempDirPath = arguments.tempDirPath;
			</cfscript>
		<cfelse> <!--- no match found, alert the user of the initial size reqs --->
			<!--- Delete the uploaded image --->
			<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
									action: "delete",
									file: arguments.tempDirPath
								) />
			<!--- <cffile action="delete" file="#arguments.tempDirPath#"> --->
			<cfscript>
				retPhoto.error = true;
				retPhoto.errorMsg = "";
			</cfscript>
			<!--- message to the user --->
			<cfsavecontent variable="retPhoto.errorMsg">
				<cfoutput>
					The uploaded photo does not meet any of the dimension requirements. <br /><br />
					Possible photo upload dimensions are the following:<br />
					<cfloop index="initSize_l" from="1" to="#arraylen(arguments.categoryData.initialSizeArray)#">
						&nbsp;&nbsp;&nbsp;#arguments.categoryData.initialSizeArray[initSize_l].Values.title# = #arguments.categoryData.initialSizeArray[initSize_l].Values.width# X #arguments.categoryData.initialSizeArray[initSize_l].Values.height#<br />
					</cfloop>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- Catch any errors with the processing --->
		<cfcatch>
			<!--- <cfdump var="#cfcatch#" label="cfcatch" expand="false"> --->
			<cfscript>
				retPhoto.error = true;
				retPhoto.errorMsg = cfcatch.message;
			</cfscript>
			<cfsavecontent variable="retDataStruct.errorMsg">
				<cfdump var="#cfcatch#">
			</cfsavecontent>
		</cfcatch>
	</cftry>
	<cfreturn retPhoto>
</cffunction>

</cfcomponent>