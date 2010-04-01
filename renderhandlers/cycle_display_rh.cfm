<!---
/* ***************************************************************
/*
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
	0.9.0
History:
	2009-10-20 - RJA - Created
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
	<cfif (StructKeyExists(rhData.photoSizeSelect, "directory"))>
		
		<!--- Get the Photo data from CEData --->
		<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
		
		<cfoutput>
	   		<style>
		    	div##photo_cycle_container {height:#rhData.photoSizeSelect.height+32#px; margin:-25px 5px 30px;}
		    	div##photo_cycle_container .pics img {height: #rhData.photoSizeSelect.height#px; width: #rhData.photoSizeSelect.width#px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
		    	div##photo_cycle_container .pics {height: #rhData.photoSizeSelect.height+32#px; width: #rhData.photoSizeSelect.width+32#px; padding:0; margin:0; overflow: hidden }
		    	div##photo_cycle_container .cycle_title {background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_overlay.png); width:#rhData.photoSizeSelect.width#px; font:12px Arial, Helvetica, sans-serif; color:##000; z-index:10; position:relative; top:-78px; left:16px; height:50px;}
		   	</style>
	        
	        <div id="photo_cycle_container">
		        
		        <div id="cycle_nav">
		        </div>
		        
		        <div style="overflow:hidden; position:relative; z-index:9;" id="cycle" class="pics">
		            <cfloop index="photo_i" from="1" to="#ArrayLen(photoDataArray)#">
		            	<img id="demo:#photo_i#" src="#photoDataArray[photo_i].values.photo#" width="#rhData.photoSizeSelect.width#" height="#rhData.photoSizeSelect.height#" alt="#photoDataArray[photo_i].values.title#" title="#photoDataArray[photo_i].values.title#" />
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