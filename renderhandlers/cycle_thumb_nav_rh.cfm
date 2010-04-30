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
	R. Alot / M. Carroll
Name:
	cycle_thumb_nav_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	1.1.0
History:
	2009-10-20 - RJA - Created
	2010-04-01 - MFC - Implemented the dynamic size.
--->
<cfscript>
	request.element.isStatic = 0;
	
	// Load the cycle scripts
	application.ptPhotoGallery.renderService.loadCycleThumbNavScript();
	
	items = attributes.elementInfo.elementData.propertyValues;
	// Pass in the RH metadata struct
	rhData = application.ptPhotoGallery.renderService.processRHMetadata(attributes.elementInfo.RenderHandlerMetaData);
</cfscript>

<cfif arrayLen(items)>
	<!--- Get the Photo data from CEData --->
	<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
	
	<cfoutput>
    	<style>
			div##photo_cycle_thumb_container ##cycle_nav li { width: #rhData.photoSizeSelect.width#px; float: left; margin: 8px; list-style: none; padding-right:10px;}
			div##photo_cycle_thumb_container ##cycle_nav a { width: #rhData.photoSizeSelect.width#px; padding: 3px; display: block; border: 1px solid ##ccc; }
			div##photo_cycle_thumb_container .pics {height: #rhData.detailSize.height+32#px; width: #rhData.detailSize.width+32#px; padding:0; margin:0 0 0 10px; overflow: hidden }
			div##photo_cycle_thumb_container .pics img {height: #rhData.detailSize.height#px; width: #rhData.detailSize.width#px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
			div##photo_cycle_thumb_container ##cycle_title {background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_overlay.png); width:#rhData.detailSize.width#px; height:25px; font:12px Arial, Helvetica, sans-serif; color:##000; z-index:12; position:relative; top:-76px; left:26px; height:50px; overflow:hidden;}
			div##photo_cycle_thumb_container ##cycle_wrapper {overflow:hidden; width:#rhData.detailSize.width+50#px; height:#rhData.detailSize.height+34#px;}
		</style>
        
        <div id="photo_cycle_thumb_container">
	        <div id="cycle_nav">
	        	<ul>
	        	<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
	            	<li><a href="javscript:;" class="">
		            	<img src="#application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'#rhData.photoSizeSelect.directory#')#" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" />
					</a>
					</li>
	            </cfloop>
	            </ul>
	        </div>
	        <div id="cycle_wrapper">
	            <div style="overflow:hidden; position:relative; z-index:9;" id="cycle" class="pics">
	                <cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
	                   <img src="#application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'#rhData.detailSize.directory#')#" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" />
	                </cfloop> 
	            </div>
	            
	            <div id="cycle_title">
	                <cfloop index="t" from="1" to="#ArrayLen(photoDataArray)#">
	                    <p>#photoDataArray[t].values.title#</p>
	                </cfloop>
	            </div>
	        </div>
        </div>
	</cfoutput>
</cfif>