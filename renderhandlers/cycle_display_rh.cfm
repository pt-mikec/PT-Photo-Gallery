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
	R. Alot
Name:
	cycle_display_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-10-20 - RJA - Created
	2010-04-01 - MFC - Implemented the dynamic size.
	2011-10-22 - MFC - Updated to use the metadata form fields.
--->
<cfscript>
	request.element.isStatic = 0;
	
	// Load the cycle scripts
	application.ptPhotoGallery.renderService.loadCycleScript();

	items = attributes.elementInfo.elementData.propertyValues;
	// Pass in the RH metadata struct
	rhData = application.ptPhotoGallery.renderService.processRHMetadata(attributes.elementInfo.RenderHandlerMetaData);
</cfscript>

<cfif arrayLen(items)>
	<!--- Check if the metadata form has data --->
	<cfif (StructKeyExists(rhData.detailSize, "directory"))>
		
		<!--- Get the Photo data from CEData --->
		<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
		
		<cfoutput>
			<!--- Load the Styles --->
			<link rel="stylesheet" href="/ADF/apps/pt_photo_gallery/style/ptPhotoGallery.css" type="text/css" >
	   		<style>
		    	div##photo_cycle_container {height:#rhData.detailSize.height+32#px; margin:-25px 5px 30px;}
		    	div##photo_cycle_container .pics img {height: #rhData.detailSize.height#px; width: #rhData.detailSize.width#px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
		    	div##photo_cycle_container .pics {height: #rhData.detailSize.height+32#px; width: #rhData.detailSize.width+32#px; padding:0; margin:0; overflow: hidden }
		    	div##photo_cycle_container .cycle_title {background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_overlay.png); width:#rhData.detailSize.width#px; font:12px Arial, Helvetica, sans-serif; color:##000; z-index:10; position:relative; top:-78px; left:16px; height:50px;}
		   	</style>
	        
	        <div id="photo_cycle_container">
		        
		        <div id="cycle_nav">
		        </div>
		        
		        <div style="overflow:hidden; position:relative; z-index:9;" id="cycle" class="pics">
		            <cfloop index="photo_i" from="1" to="#ArrayLen(photoDataArray)#">
		            	<img id="demo:#photo_i#" src="#photoDataArray[photo_i].values.photo#" width="#rhData.detailSize.width#" height="#rhData.detailSize.height#" alt="#photoDataArray[photo_i].values.title#" title="#photoDataArray[photo_i].values.title#" />
		            </cfloop> 
		        </div>
		        
		        <div class="cycle_title">
		        	<cfloop index="photo_j" from="1" to="#ArrayLen(photoDataArray)#">
						<div id="#photo_j#" class="carouselOverlay"><p>#photoDataArray[photo_j].Values.title#</p></div>
					</cfloop>
		        </div>
	        
	        </div>
	   </cfoutput>
	<cfelse>
		<cfoutput>Select the Photo Sizes to render in the metadata form.</cfoutput>
	</cfif>
</cfif>