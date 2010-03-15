<cfcomponent displayname="photoForms" extends="ADF.apps.pt_photo_gallery.components.App">

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$photoEditForm
Summary:	
	Returns the edit CE data form for the element that makes Ajax post to syncCEDataToPageMetadata on completion.
Returns:
	String - rtnHTML - HTML edit form
Arguments:
	Numeric - formid - Custom element form ID
	Numeric - datapageid - Custom element data page ID
	String - lbAction - Lightbox action on close
	String - customizedFinalHtml - User defined customized final html
History:
	2009-07-01 - MFC - Created
--->
<cffunction name="photoEditForm" access="public" returntype="string" returnformat="plain" hint="Returns the edit CE data form for the element that makes Ajax post to syncCEDataToPageMetadata on completion.">
	<cfargument name="formID" type="numeric" required="true" hint="Custom element form ID">
	<cfargument name="dataPageId" type="numeric" required="true" hint="Custom element data page ID">
	<cfargument name="lbAction" type="string" required="false" default="norefresh" hint="Lightbox action on close">
	<cfargument name="customizedFinalHtml" type="string" required="false" default="" hint="User defined customized final html">
	
	<cfscript>
		var APIPostToNewWindow = true;
		var rtnHTML = "";
		var formResultHTML = arguments.customizedFinalHtml;
	</cfscript>
	<!--- Check if we have a form result HTML passed in --->
	<cfif LEN(formResultHTML) LTE 0>
		<!--- Set the form result HTML --->
		<cfsavecontent variable="formResultHTML">
			<cfoutput>
			<cfscript>
				application.ptPhotoGallery.scripts.loadJQuery('1.3.2');
				application.ptPhotoGallery.scripts.loadADFLightbox();
			</cfscript>
			<script type='text/javascript'>
				jQuery.get('#application.ADF.ajaxProxy#',
					{ 	
						bean: 'photoService',
						method: 'handlePhotoEdit',
						datapageid: '#arguments.dataPageId#',
						formid: '#arguments.formID#'
					},
					function(data){
						// write the return html to the div
						jQuery('div##retBlock').html(data);
					}
				);
			</script>
			<div id='retBlock' style='text-align:center;'>
				Saving... <img src='/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif'>
			</div>
		</cfoutput>
		</cfsavecontent>
	</cfif>
	<cfsavecontent variable="rtnHTML">
		<cfoutput>
			<!--- Call the UDF function --->
			#application.ptPhotoGallery.scripts.loadADFLightbox()#
			#Server.CommonSpot.UDF.UI.RenderSimpleForm(arguments.dataPageID, arguments.formID, APIPostToNewWindow, formResultHTML)#
		</cfoutput>
	</cfsavecontent>
	<cfreturn rtnHTML>
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
			<cfset application.ptPhotoGallery.scripts.loadADFLightbox()>
			<cfoutput>
				<div align="center">
					<cfif result>
						<p>Photo has been deleted.</p>
						<p>
							<a href="##" onclick="window.parent.location.href = window.parent.location.href;">Click to close and refresh the page</a>
						</p>
					<cfelse>
						<p>Error occurred with photo delete.</p>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
	<cfelse>
		<!--- Render for the delete form --->
		<cfsavecontent variable="rtnHTML">
			<cfset application.ptPhotoGallery.scripts.loadADFLightbox()>
			<cfoutput>
				<form action="#application.ADF.ajaxProxy#?bean=photoForms&method=photoDeleteForm&formid=#arguments.formid#&datapageid=#arguments.datapageid#&processDeleteFlag=1" method="post">
					<div align="center">
						<p>Are you sure you want to delete this photo?</p>
						<p>
							<input type="submit" value="Delete">
							<input type="button" value="Cancel">
						</p>
					</div>
				</form>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	
	<cfreturn rtnHTML>
	
	
	<!--- 
	<cfscript>
		var APIPostToNewWindow = true;
		var rtnHTML = "";
		var formResultHTML = arguments.customizedFinalHtml;
	</cfscript>
	<!--- Check if we have a form result HTML passed in --->
	<cfif LEN(formResultHTML) LTE 0>
		<!--- Set the form result HTML --->
		<cfsavecontent variable="formResultHTML">
			<cfoutput>
			<cfscript>
				application.ptPhotoGallery.scripts.loadJQuery('1.3.2');
			</cfscript>
			<script type='text/javascript'>
				jQuery.get('#application.ADF.ajaxProxy#',
					{ 	
						bean: 'photoService',
						method: 'handlePhotoEdit',
						datapageid: '#arguments.dataPageId#',
						formid: '#arguments.formID#'
					},
					function(data){
						// write the return html to the div
						jQuery('div##retBlock').html(data);
					}
				);
			</script>
			<div id='retBlock' style='text-align:center;'>
				Saving... <img src='/ADF/apps/pt_photo_gallery/images/ajax-loader-arrows.gif'>
			</div>
		</cfoutput>
		</cfsavecontent>
	</cfif>
	<cfsavecontent variable="rtnHTML">
		<cfoutput>
			<!--- Call the UDF function --->
			#Server.CommonSpot.UDF.UI.RenderSimpleForm(arguments.dataPageID, arguments.formID, APIPostToNewWindow, formResultHTML)#
		</cfoutput>
	</cfsavecontent>
	<cfreturn rtnHTML> --->
</cffunction>

</cfcomponent>