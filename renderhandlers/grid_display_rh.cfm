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
	R. Alot / M. Carroll
Name:
	grid_display_rh.cfm
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
	// Make the page dynamics
	request.element.isStatic = 0;
	
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadADFlightbox();
	
	appConfig = application.ptPhotoGallery.getAppConfig();
	
	items = attributes.elementInfo.elementData.propertyValues;
	// Pass in the RH metadata struct
	rhData = application.ptPhotoGallery.renderService.processRHMetadata(attributes.elementInfo.RenderHandlerMetaData);
	
	// Pagination
	itemRenderPerPage = 6;
	// Set the rendering page
	if ( NOT StructKeyExists(request.params, "page") ){
		request.params.page = 1;
	}
</cfscript>
<cfif ArrayLen(items)>
	<!--- Check if the metadata form has data --->
	<cfif (StructKeyExists(rhData.detailSize, "directory")) AND (StructKeyExists(rhData.photoSizeSelect, "directory"))>
		<!--- <cfdump var="#items#" label="items" expand="false"> --->
		<!--- Get the Photo data from CEData --->
		<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect)>
		<cfscript>
			pageStruct = application.ptPhotoGallery.utils.buildPagination(page=request.params.page, itemCount=ArrayLen(photoDataArray), pageSize=itemRenderPerPage, showCount=false);
		</cfscript>
		<!--- <cfdump var="#pageStruct#"> --->
		<!--- <cfdump var="#photoDataArray#" label="photoDataArray" expand="false"> --->
		<!--- Check we have photo data --->
		<cfif ArrayLen(photoDataArray)>
			<!--- Render the pagination --->
			<cfoutput>
				<!--- Load the Styles --->
				<link rel="stylesheet" href="/ADF/apps/pt_photo_gallery/style/ptPhotoGallery.css" type="text/css" >
				<div id="photo_grid_view">
					<!--- Check if the total records need pagination --->
					<cfif ArrayLen(photoDataArray) GT itemRenderPerPage>
						<div class="listing alpha">
					        <ul>
						        <cfif len(pageStruct.prevLink)>
									<li class="previous"><a href="#pageStruct.prevLink#">&laquo; Previous</a></li>
								</cfif>
								<cfloop index="k" from="1" to="#arrayLen(pageStruct.pageLinks)#">
									<li><a href="#cgi.script_name##pageStruct.pageLinks[k].link#" <cfif k EQ request.params.page>class="active"</cfif>>#k#</a></li>
								</cfloop>
								<cfif len(pageStruct.nextLink)>
									<li class="next"><a href="#pageStruct.nextLink#">Next &raquo;</a></li>
								</cfif>
					        </ul>
					    </div>
				    </cfif>
			</cfoutput>
			<cfset currRowCount = 0>
			<!--- loop over the photo data --->
			<!--- <cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#"> --->
			<cfloop index="i" from="#pageStruct.itemStart#" to="#pageStruct.itemEnd#">
				<cfoutput>
					<cfif (i mod 3) EQ 1>
						<cfset currRowCount = currRowCount + 1>
						<cfif (currRowCount mod 2) EQ 1>
							<div class="profile-column odd">
						<cfelse>
							<div class="profile-column even">
						</cfif>
					</cfif>
					<cfscript>
						largeImg = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'#rhData.detailSize.directory#');
						thumbImg = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'#rhData.photoSizeSelect.directory#');
						lbWidth = rhData.detailSize.width + 50;
						lbHeight = rhData.detailSize.height + 50;
					</cfscript>
					<dl>
						<dt><a href="javascript:;" rel="#appConfig.DISPLAY_URL#?imgsrc=#largeImg#&width=#lbWidth#&height=#lbHeight#&title=#photoDataArray[i].Values.title#" class="ADFLightbox">#photoDataArray[i].Values.title#</a></dt>
							<dd class="image"><a href="javascript:;" rel="#appConfig.DISPLAY_URL#?imgsrc=#largeImg#&width=#lbWidth#&height=#lbHeight#&title=#photoDataArray[i].Values.title#" title="#photoDataArray[i].Values.title#" class="ADFLightbox">
								<img src="#thumbImg#" alt="#photoDataArray[i].Values.title#" /></a></dd>
						<dd class="description">#photoDataArray[i].Values.abstract#</dd>
					</dl>
					<cfif ((i mod 3) EQ 0) OR (i EQ ArrayLen(photoDataArray))>
						</div>
					</cfif>
				</cfoutput>
			</cfloop>
			<cfoutput>
				</div>
			</cfoutput>
		<cfelse>
			<cfoutput>Select the Photo Sizes to render in the metadata form.</cfoutput>
		</cfif>	
	<cfelse>
		<cfoutput>No Photos to Display.</cfoutput>
	</cfif>
<cfelse>
	<cfoutput>No Records to Display.</cfoutput>
</cfif>
