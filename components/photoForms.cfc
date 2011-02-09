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

<cfcomponent displayname="photoForms" extends="ADF.apps.pt_photo_gallery.components.App">

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$photoAddEdit
Summary:	
	Returns the HTML for an Add/Edit Custom element record
Returns:
	String formHTML
Arguments:
	Numeric - formID - the Custom Element Form ID
	Numeric - dataPageID - the dataPageID for the record that you would like to edit
History:
	2009-10-26 - MFC - Created
	2010-09-30 - MFC - Updated the function to utilize the form for ADD and EDIT
--->
<cffunction name="photoAddEdit" access="public" returntype="string">
	<cfargument name="dataPageId" type="numeric" required="false" default="0">
	<cfargument name="lbAction" type="string" required="false" default="norefresh">
	<cfargument name="renderResult" type="boolean" required="false" default="0">
	
	<cfscript>
		var photoFormID = application.ptPhotoGallery.getPhotoFormID();
		var APIPostToNewWindow = false;
		var rtnHTML = "";
		var formResultHTML = "";
		// Find out if the CE contains an RTE field
		var photoData = "";
	</cfscript>
	
	<!--- Result from the Form Submit --->
	<cfsavecontent variable="formResultHTML">
		<cfoutput>
			<cfscript>
				request.params.height = 300;
				
				application.ptPhotoGallery.scripts.loadJquery(force=true);
				application.ptPhotoGallery.scripts.loadADFLightbox(force=true);
			</cfscript>
			<cfset request.params.ga_contentActions = "photo-create">
			<cfoutput>
				<script type='text/javascript'>
					function processPhoto(formData){
						alert("CALLBACK!");
						console.log(formData);
						
						jQuery.ajax({
							url: '#application.ADF.ajaxProxy#',
							data: {
								bean: 'photoService',
								method: 'processForm',
								photoID: formData.photoID,
								lbAction: '#arguments.lbAction#'
							},
							success: function(data) {
								//alert(data);
								// Check that we returned data
								if ( data != '' ) {
									jQuery('div##photoMsgSaving').html(data);
									ResizeWindow();
								}
								else {
									// write the return html to the div
									jQuery('div##photoMsgSaving').html('Error processing the photo.');
								}
							},
							error: function(data){
								// write the return html to the div
								jQuery('div##photoMsgSaving').html('Error processing the photo.');
							}
						});
					}
				</script>
				
				<!--- Render the text --->
				<div id="photoMsgSaving" align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					<strong>Saving Photo...<img src="/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif"></strong><br /><br />
				</div>
			</cfoutput>
		</cfoutput>
	</cfsavecontent>
	
	<!--- Wrap the HTML with the LB header/footer --->
	<cfset formResultHTML = application.ptPhotoGallery.forms.wrapHTMLWithLightbox(formResultHTML)>
	
	<!--- Render the UI form --->
	<cfreturn application.ptPhotoGallery.forms.renderAddEditForm(
				formID=photoFormID, 
				dataPageId=arguments.dataPageId,
				customizedFinalHtml=formResultHTML,
				lbAction=arguments.lbAction,
				callback="processPhoto")>
	
	<!--- <cfif NOT renderResult>
		<!--- <cfif formContainRTE>
			<!--- Set the form result HTML --->
			<cfsavecontent variable="formResultHTML">
				<cfoutput>
				<!--- Close the lightbox on click --->
				<script type='text/javascript'>
					window.opener.location.href = window.opener.location.href + "&renderResult=true";
					// Close the window
					if (jQuery.browser.msie){
						window.open('','_self','');
	           			window.close();
				    }else{
				    	window.close();
				    } 
				</script>
				</cfoutput>
			</cfsavecontent>
		</cfif> --->
		<!--- HTML for the form --->
		<cfsavecontent variable="rtnHTML">    
		  <cfscript>
				CD_DialogName = request.params.title;
				CD_Title=CD_DialogName;
				CD_IncludeTableTop=1;
				CD_CheckLock=0;
				CD_CheckLogin=1;
				CD_CheckPageAlive=0;
				APIPostToNewWindow = false;
			</cfscript>
			<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-head.cfm">
			<cfoutput>
			<cfscript>
				application.ptPhotoGallery.scripts.loadADFLightbox(force=1);
			</cfscript>
			<!--- Call the UDF function --->
			<tr><td>#Server.CommonSpot.UDF.UI.RenderSimpleForm(arguments.dataPageID, photoFormID, APIPostToNewWindow, formResultHTML)#</td></tr>
			</cfoutput>
			<CFINCLUDE template="/commonspot/dlgcontrols/dlgcommon-foot.cfm">
		</cfsavecontent>
		
	<cfelse>
		<cfset rtnHTML = formResultHTML>
	</cfif>
	<cfreturn rtnHTML> --->

</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$photoDeleteForm
Summary:	
	Returns the HTML for delete confirmation and then calls process for delete.
Returns:
	String - rtnHTML - HTML
Arguments:
	Numeric - formid - Custom element form ID
	Numeric - datapageid - Custom element data page ID
	Boolean - processDeleteFlag
History:
	2009-11-04 - MFC - Created
	2010-04-29 - MFC - Updated to force the load ADF Lightbox
--->
<cffunction name="photoDeleteForm" access="public" returntype="string" returnformat="plain" hint="Returns the delete CE data form for the element that makes Ajax post to syncCEDataToPageMetadata on completion.">
	<cfargument name="formID" type="numeric" required="true" hint="Custom element form ID">
	<cfargument name="dataPageId" type="numeric" required="true" hint="Custom element data page ID">
	<cfargument name="processDeleteFlag" type="boolean" required="false" default="0" hint="Flag to process the deleting">
	
	<cfset var rtnHTML = "">
	<cfset var deleteArgs = StructNew()>
	<cfset var result = "">
	
	<cfif arguments.processDeleteFlag>
		<!--- process the deleting --->
		<!--- get the current items data --->
		<cfset itemData = application.ptPhotoGallery.cedata.getElementInfoByPageID(arguments.dataPageId, arguments.formid)>
		<!--- Call profile service to handle uploaded photo delete --->
		<cfscript>
			deleteArgs = StructNew();
			deleteArgs.categoryID = itemData.values.category;
			deleteArgs.inFile = itemData.values.photo;
			if ( StructKeyExists(itemData.values, "imgGalleryPageID") )
				deleteArgs.imgGalPageID = itemData.values.imgGalleryPageID;
			// Delete result
			result = application.ptPhotoGallery.photoService.deletePhoto(deleteArgs);
			// If delete success, then delete the CE record data
			if (result)
				result = application.ptPhotoGallery.cedata.deleteCE(arguments.dataPageId);
		</cfscript>
		<cfsavecontent variable="rtnHTML">
			<cfset application.ptPhotoGallery.scripts.loadADFLightbox(force=1)>
			<!--- Dialog Header --->
			<CFSCRIPT>
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
			<cfoutput>
				<div align="center">
					<cfif result>
						<p>Photo has been deleted.</p>
						<p>
							<a href="javascript:;" onclick="closeLBReloadParent();">Click to close and refresh the page</a>
						</p>
					<cfelse>
						<p>Error occurred with photo delete.</p>
					</cfif>
				</div>
			</cfoutput>
			<cfoutput></td></tr></cfoutput>
			<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm">
		</cfsavecontent>
	<cfelse>
		<!--- Render for the delete form --->
		<cfsavecontent variable="rtnHTML">
			<cfset application.ptPhotoGallery.scripts.loadADFLightbox(force=1)>
			<!--- 
			<!--- Dialog Header --->
			<CFSCRIPT>
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
			<cfoutput><tr><td></cfoutput> --->
			<cfoutput>
				<form action="#application.ADF.ajaxProxy#?bean=photoForms&method=photoDeleteForm&formid=#arguments.formid#&datapageid=#arguments.datapageid#&processDeleteFlag=1" method="post">
					<div align="center">
						<p>Are you sure you want to delete this photo?</p>
						<p>
							<input type="submit" value="Delete">
							<input type="button" value="Cancel" onclick="closeLB();">
						</p>
					</div>
				</form>
			</cfoutput>
			<!--- <cfoutput></td></tr></cfoutput>
			<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm"> --->
		</cfsavecontent>
	</cfif>
	
	<cfreturn rtnHTML>
</cffunction>

</cfcomponent>