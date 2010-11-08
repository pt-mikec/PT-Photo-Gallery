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
Author: 	PaperThin Inc.
			M. Carroll
Name:
	manager_layout.cfm
Summary:
	Custom Script for the tabular layout for the photo manager.
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
	application.ptPhotoGallery.scripts.loadADFLightbox();
	
	categoryFormID = application.ptPhotoGallery.getPhotoCategoryFormID();
	sizeFormID = application.ptPhotoGallery.getPhotoSizeFormID();
	
	// Set the photo UID
	request.params.photoID = createUUID();
	request.params.appConfig = application.ptPhotoGallery.getAppConfig();
</cfscript>

<cfoutput>
<style>
.ui-widget {
	font-size:0.8em !important;
}
</style>		
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("##tabs").tabs();
	
		// Hover states on the static widgets
		jQuery("div.ds-icons,div.add_link,div.add_link_category,div.add_link_size").hover(
			function() { 
				$(this).css("cursor", "hand");
				$(this).addClass('ui-state-hover'); 
			},
			function() { 
				$(this).css("cursor", "pointer");
				$(this).removeClass('ui-state-hover'); 
			}
		);
		// Hover states on the static widgets
		/* jQuery("div.add_link").hover(
			function() { $(this).addClass('ui-state-hover'); },
			function() { $(this).removeClass('ui-state-hover'); }
		); */
	});
</script>
<!--- 
Links to Add to the datasheet to get the button styles
<br /><br />
<div class='ds-icons ui-state-default ui-corner-all' title='edit' ><div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-pencil'></div></div>
<br /><br />
<div class='ds-icons ui-state-default ui-corner-all' title='delete' ><div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-trash'></div></div>
<br /><br /> --->

<div id="tabs">
	<ul>
		<li><a href="##tabs-1">Photo</a></li>
		<li><a href="##tabs-2">Category</a></li>
		<li><a href="##tabs-3">Size</a></li>
	</ul>
	<div id="tabs-1">
	</cfoutput>
	
	<!--- Render the Add Photo Link --->
	<cfif request.user.id gt 0>
		<cfoutput>
			<style>
				div.add_link {
					padding: 1px 10px;
					text-decoration: none;
					margin-left: 20px;
					width: 95px;
					height: 16px;
				}
				div.add_link_category {
					padding: 1px 10px;
					text-decoration: none;
					margin-left: 20px;
					width: 155px;
					height: 16px;
				}
				div.add_link_size {
					padding: 1px 10px;
					text-decoration: none;
					margin-left: 20px;
					width: 125px;
					height: 16px;
				}
			</style>
			<div rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoAddEdit&lbaction=refreshparent&title=Add New Photo&addMainTable=false&micrositeID=#request.microsite.id#" class="ADFLightbox add_link ui-state-default ui-corner-all">Add New Photo</div><br /><br />
		</cfoutput>
	<cfelse>
		<cfoutput>
			<br />Please <a href="#request.subsitecache[1].url#login.cfm">LOGIN</a> to add a photo.<br /><br /> 
		</cfoutput>
		<cfexit>
	</cfif>
		
	<!--- Render the Photo Element Datasheet --->
	<CFMODULE TEMPLATE="/commonspot/utilities/ct-render-named-element.cfm"
		elementtype="datasheet"
		elementName="photoManagerDatasheet">
	<cfoutput>	
	</div>
	<div id="tabs-2">
		<div rel="#application.ADF.ajaxProxy#?bean=Forms_2_0&method=renderAddEditForm&formid=#categoryFormID#&datapageid=0&lbaction=refreshparent&width=700&height=650&title=Add New Photo Category&micrositeID=#request.microsite.id#" class="ADFLightbox add_link_category ui-state-default ui-corner-all">Add New Photo Category</div><br /><br />
	</cfoutput>		
		<!--- Render the Photo Category Element Datasheet --->
		<CFMODULE TEMPLATE="/commonspot/utilities/ct-render-named-element.cfm"
			elementtype="datasheet"
			elementName="photoCategoryManagerDatasheet">
	<cfoutput>	
	</div>
	<div id="tabs-3">
		<div rel="#application.ADF.ajaxProxy#?bean=Forms_2_0&method=renderAddEditForm&formid=#sizeFormID#&datapageid=0&lbaction=refreshparent&width=400&height=250&title=Add New Photo Size&micrositeID=#request.microsite.id#" class="ADFLightbox add_link_size ui-state-default ui-corner-all">Add New Photo Size</div><br /><br />
	</cfoutput>
		<!--- Render the Photo Size Element Datasheet --->
		<CFMODULE TEMPLATE="/commonspot/utilities/ct-render-named-element.cfm"
			elementtype="datasheet"
			elementName="photoSizeManagerDatasheet">
	<cfoutput>
	</div>
</div>
</cfoutput>
