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
	1.3
History:
	2009-08-04 - MFC - Created
	2010-08-19 - MFC - Updated the load JQuery and JQuery versions to use the global versioning.
--->
<cfscript>
application.ptPhotoGallery.scripts.loadJQuery();
application.ptPhotoGallery.scripts.loadJQueryUI();
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
	
	
	
	
	<!--- <CFSCRIPT>
		formid = application.ptPhotoGallery.getPhotoFormID();
		dataPageID = 0;
		controlid = 0;
		
		// true value indicates we're coming from select data form action
		controltypeid = formid;
		datacontrolid = controlid;
		
		
		CD_CheckLock=0;
		CD_Title = "Add New Photo";
		CD_IncludeTableTop = 1;
		
		proc_type = "datasheetAction";
		
		functionEvent = 'update';
	</CFSCRIPT> --->
	
	<!--- <form action="/live/webadmin/photogallery/loader.cfm" name="actionColumnForm1637" method="post" target="actiontarget">
		<input name="category" type="hidden" value="" />
		<input name="controlid" type="hidden" value="" />
		<input name="pageid" type="hidden" value="" />
		<input name="photo" type="hidden" value="" />
		<input name="photoid" type="hidden" value="" />
		<input name="title" type="hidden" value="" />
		<input name="formid" type="hidden" value="1534" />
		<input name="csModule" type="hidden" value="" />
		<input name="proc_type" type="hidden" value="datasheetAction" />
		<input name="targetmodule" type="hidden" value="" />
		<input name="cd_title" type="hidden" value="" />
	</form> --->
	
	
	<!--- <CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-head.cfm">
	<CFINCLUDE TEMPLATE="/commonspot/controls/default-mode.cfm">

	<CFSET noTimeStamp = 1>
	<CFINCLUDE template="/commonspot/controls/customform/form-render-js.cfm"> --->
	<!--- <cfoutput>
		#Server.CommonSpot.UDF.UI.RenderSimpleForm(dataPageID, formid, false, "test")#
	</cfoutput> --->
	
	<!--- <CFINCLUDE template="/commonspot/controls/customform/form-render.cfm"> --->
	
	<!--- // render the form --->
	<!--- <cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
		elementName="photo_add_form"
		elementType="form"> --->
	
	
	
	
	<!--- <CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm"> --->
	
	
	
	<!--- <CFSCRIPT>
		request.params.formid = application.ptPhotoGallery.getPhotoFormID();
		request.params.dataPageID = 0;
		request.params.proc_type = "datasheetAction";
	</CFSCRIPT>
	
	<!--- <cfset eParamOverride = StructNew()>
	<cfinclude template="/commonspot/controls/datasheet/cs-edit-form-data.cfm">	 --->
	
	<cfinclude template="/live/webadmin/photogallery/loader.cfm">
	 --->
	 
	<!--- Dialog Header --->
	<CFSCRIPT>
		request.params.formid = application.ptPhotoGallery.getPhotoFormID();
		request.params.dataPageID = 0;
		
		// Dialog Info
		CD_DialogName = request.params.title;
		CD_Title=CD_DialogName;
		CD_IncludeTableTop=1;
		CD_CheckLock=0;
		CD_CheckLogin=1;
		CD_CheckPageAlive=0;
		//CD_OnLoad="";
	</CFSCRIPT>
	<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-head.cfm">
	<cfoutput><tr><td></cfoutput>
		
		<cfmodule template="/commonspot/utilities/ct-render-named-element.cfm"
			elementName="photo_add_form"
			elementType="form">
			
	<!--- </td></tr>
	</cfoutput>
	<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm"> --->
	
	
	
	
	
	
	
	
	
	
	
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
	
	<!--- Dialog Footer --->
	<cfoutput></td></tr></cfoutput>
	<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm">
		
<cfcatch>
	<cfoutput>Error Occcured.</cfoutput>
	<cfdump var="#cfcatch#" label="cfcatch" expand="false">
</cfcatch>
</cftry>