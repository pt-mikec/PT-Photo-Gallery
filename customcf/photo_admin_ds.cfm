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
	$photo_admin_ds.cfm
Summary:
	Photo Administrator Datasheet
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
	
	request.params.configStruct = application.ptPhotoGallery.getAppConfig();
	request.params.formid = application.ptPhotoGallery.getPhotoFormID();
	request.params.addButtonTitle = "Add New Photo";
	request.params.editLBWidth = 600;
	request.params.editLBHeight = 600;
</cfscript>

<cfoutput>
<script type="text/javascript">
	jQuery(document).ready(function(){
		// Hover states on the static widgets
		jQuery("div.ds-icons").hover(
			function() { 
				$(this).css("cursor", "hand");
				$(this).addClass('ui-state-hover');
			},
			function() { 
				$(this).css("cursor", "pointer");
				$(this).removeClass('ui-state-hover');
			}
		);
	});
</script>
<style>
	div.add-button {
		padding: 1px 10px;
		text-decoration: none;
		margin-left: 20px;
		width: 115px;
		height: 16px;
	}
	div.ds-icons {
		padding: 1px 10px;
		text-decoration: none;
		margin-left: 20px;
		width: 30px;
	}
</style>
<div id="addNew" style="padding:20px;">
	<cfif LEN(request.user.userid)>
		<div rel="#request.params.configStruct.ADD_URL#?renderForm=1&lbAction=norefresh&width=#request.params.editLBWidth#&height=#request.params.editLBHeight#&title=#request.params.addButtonTitle#" id="addNew" title="#request.params.addButtonTitle#" class="ADFLightbox add-button ui-state-default ui-corner-all">#request.params.addButtonTitle#</div><br />
	<cfelse>
		Please <a href="#request.subsitecache[1].url#login.cfm">LOGIN</a> to manage your photos.<br />
	</cfif>
</div>
</cfoutput>
<CFMODULE TEMPLATE="/commonspot/utilities/ct-render-named-element.cfm"
	elementtype="datasheet"
	elementName="customDatasheetJQueryUIStyles">