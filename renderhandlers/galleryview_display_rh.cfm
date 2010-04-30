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
	PaperThin Inc.
	M. Carroll
Name:
	galleryview_display_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	1.0.0
History:
	2009-07-28 - RLW - Created
--->
<cfscript>
	request.element.isStatic = 0;
	items = attributes.elementInfo.elementData.propertyValues;
	
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadGalleryView("1.1");
</cfscript>

<cfif arrayLen(items)>
	<!--- Get the Photo data from CEData --->
	<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
	
	<cfoutput>
		
		<script type="text/javascript">
			jQuery(document).ready(function() {
				$('##photos').galleryView({
					panel_width: 300,
					panel_height: 300,
					frame_width: 75,
					frame_height: 75
				});
			});
		</script>
	
		<div id="photos" class="galleryview">
			<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
				<div class="panel">
					<img src="#photoDataArray[i].values.photo#" /> 
					<div class="panel-overlay">
						<h2>#photoDataArray[i].values.title#</h2>
						<p>#photoDataArray[i].values.title#</p>
					</div>
				</div>
			</cfloop>
			<ul class="filmstrip">
				<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
					<li><img src="#photoDataArray[i].values.photo#" width="75" height="75" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" /></li>
				</cfloop> 
			</ul>
		</div> 
		
	</cfoutput>
	
</cfif>