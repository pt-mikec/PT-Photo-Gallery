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
	PaperThin, Inc.
	M. Carroll 
Custom Field Type:
	Photo Gallery Upload Crop Field
Name:
	photo_upload_crop_render.cfm
Summary:
	Custom select field to upload and crop a photo to the photo gallery.
ADF Requirements:
	Scripts_1_0
Version:
	2.0
History:
	2009-12-15 - MFC - Created
	2010-04-30 - MFC - Update the CFT for the ADF Lightbox
	2010-08-19 - MFC - Updated the load JQuery and JQuery versions to use the global versioning.
--->
<cfscript>
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	
	// Set the photo field ID
	if ( NOT StructKeyExists(xparams, "photoFieldID") OR (LEN(xparams.photoFieldID) LTE 0) )
		xparams.photoFieldID = fqFieldName;
		
	appConfig = application.ptPhotoGallery.getAppConfig();	
</cfscript>
<!--- <cfdump var="#xparams#" label="photo_upload_crop"> --->

<!--- Check if the Upload Crop URL page is setup --->
<cfif StructKeyExists(appConfig, "UPLOAD_CROP_URL") AND LEN(appConfig.UPLOAD_CROP_URL)>
	<cfset xparams.cropFieldSetup = true>
<cfelse>
	<cfset xparams.cropFieldSetup = false>
</cfif>

<cfif xparams.cropFieldSetup>
	<cfoutput>	
		<cfscript>
			application.ptPhotoGallery.scripts.loadJQuery(force=1);
			application.ptPhotoGallery.scripts.loadJQueryUI();
			application.ptPhotoGallery.scripts.loadADFLightbox();
		</cfscript>
		
		<script type="text/javascript">
			// set up the accordion action
			//var profileAcc = new Spry.Widget.Accordion("ProfileAccordion", { defaultPanel: 0 });
			// javascript validation to make sure they have text to be converted
			#fqFieldName#=new Object();
			#fqFieldName#.id='#fqFieldName#';
			#fqFieldName#.tid=#rendertabindex#;
			//#fqFieldName#.validator="#fqFieldName#Obj.handleSaveSort(document.getElementById('#fqFieldName#_List'))";
			//#fqFieldName#.msg="Please upload a document.";
			// push on to validation array
			//vobjects_#attributes.formname#.push(#fqFieldName#);
		</script>
		
		<script type="text/javascript">
			// Store the current value
			var #fqFieldName#currentValue = "#currentValue#";
			
			jQuery(document).ready(function(){
				
				// if currentValue has data, then photo has been uploaded already
				if (#fqFieldName#currentValue != "")
					#fqFieldName#_loadImage(#fqFieldName#currentValue);
				else
					#fqFieldName#_loadAddButton();
			});
			
			function #fqFieldName#_loadAddButton()
			{
				jQuery("###fqFieldName#_photoDisplay").hide();
				jQuery("###fqFieldName#_addPhoto").show();
			}
			
			function #fqFieldName#_loadImage(photoUID)
			{
				// get the photo URL
				jQuery.get( '#application.ADF.ajaxProxy#',
				{ 	
					bean: 'photoService',
					method: 'getPhotoURLbyPhotoID',
					photoID: photoUID,
					size: "_system_resize"
				},
				function(photoURL){
					// load new img url into the img field
					if (photoURL != "")
						#fqFieldName#renderPhoto(photoURL);
					else 
					{
						// The photo doesn't exist anymore
						#fqFieldName#_loadAddButton();
						jQuery("input###xparams.photoFieldID#").val("");
					}
				});
			}
			
			// Set the value back from the photo form
			function #fqFieldName#setPhotoField(inArgsArray)
			{
				/* 
					inArgsArray[0] = URL to the image
					inArgsArray[1] = photo UID
				 */
				
				// load new img url into the img field
				#fqFieldName#_loadImage(inArgsArray[1]);
				
				// Store the photo ID value into the fqFieldName
				jQuery("input###xparams.photoFieldID#").val(inArgsArray[1]);
				
				// Resize the window for CS 5
				if ( #ListFirst(ListLast(request.cp.productversion," "),".")# < 6 )
					lbResizeWindow();
				else
					commonspot.lightbox.recalcLightboxSizeByPos(0);
			}
			
			function #fqFieldName#renderPhoto(url){
				// load new img url into the img field
				jQuery("img###fqFieldName#_photoTag").attr('src',url);
				jQuery("img###fqFieldName#_photoTag").attr('width','50');
				jQuery("img###fqFieldName#_photoTag").attr('height','50');
				jQuery("###fqFieldName#_photoDisplay").show();
				jQuery("###fqFieldName#_addPhoto").hide();
			}
			
			// Function to clear the selected photo field
			function #fqFieldName#_clearField()
			{
				// Get the value for the field value
				var currentPhotoUID = jQuery("input###xParams.photoFieldID#").val();
				if (currentPhotoUID != "") {
					// confirmation to clear the image
					var clear = confirm("Attention: This photo will be deleted without saving the form.\n\nAre you sure you want to delete this document?");
					if (clear){
						
						// Delete the file record
						jQuery.get( '#application.ADF.ajaxProxy#',
						{ 	
							bean: 'photoService',
							method: 'deletePhotoUID',
							photoUID: currentPhotoUID
						},
						function(msg){
							if (msg == "true"){
								// Clear the field value
								jQuery("input###fqFieldName#").val("");
								// clear the photo id field
								jQuery("input###xparams.photoFieldID#").val("");
								#fqFieldName#_loadAddButton();
							}
						});
					}
				}
			}
			
			
			
			function #fqFieldName#_addPhotoForm(){
				
				// Resize the window for CS 5
				if ( #ListFirst(ListLast(request.cp.productversion," "),".")# < 6 )
					window.resizeTo(800,800);
				
				// Open the lightbox for the add form
				openLB("#appConfig.UPLOAD_CROP_URL#?action=form&callback=#fqFieldName#setPhotoField&category=#xparams.photoCategoryID#&width=500&height=300&title=Add Photo");
			}
		</script>
	</cfoutput>
</cfif>

<cfoutput>
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
	<td class="#tdClass#" valign="top">#labelText#</td>
	<td class="cs_dlgLabelSmall" >
		
		<cfif xparams.cropFieldSetup>
			<div id="#fqFieldName#_photoDisplay">
				<img id="#fqFieldName#_photoTag" src="">
				[<a href="javascript:;" id="#fqFieldName#_photoRemove" onclick="#fqFieldName#_clearField();">Remove</a>]
			</div>
			<div id="#fqFieldName#_addPhoto">
				<!--- [<a href='javascript:;' rel='#appConfig.UPLOAD_CROP_URL#?action=form&callback=#fqFieldName#setPhotoField&category=#xparams.photoCategoryID#&width=500&height=300&title=Add Photo' title='Add Photo' class='ADFLightbox' style="text-decoration:none;">Add Photo</a>] --->
				[<a href='javascript:;' onclick='#fqFieldName#_addPhotoForm();'>Add Photo</a>]
			<br />
		<cfelse>
			<div style="font-size:small;">
				Photo Upload Crop Field is not configured.  Please consult the documentation.
			</div>
		</cfif>
		
		<input type="hidden" id="#xparams.photoFieldID#" name="#fqFieldName#" value="#currentValue#">
		<!--- // include hidden field for simple form processing --->
		<input type="hidden" name="#fqFieldName#_FIELDNAME" id="#fqFieldName#_FIELDNAME" value="#REPLACE(xParams.fieldName,'FIC_', '')#">
	</td>
</tr>

</cfoutput>