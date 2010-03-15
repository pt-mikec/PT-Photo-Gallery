<!---
/* ***************************************************************
/*
Author: 	
	PaperThin Inc.
	M. Carroll
Name:
	carousel_display_rh.cfm
Element:
	Photo Gallery
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2009-07-28 - RLW - Created
--->
<cfscript>
	request.element.isStatic = 0;
	items = attributes.elementInfo.elementData.propertyValues;
	
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadJCarousel();
	//application.ptPhotoGallery.scripts.loadThickbox("3.1");
	application.ptPhotoGallery.scripts.loadADFLightbox();
</cfscript>

<cfif arrayLen(items)>
	<!--- <cfdump var="#items#" label="items" expand="false"> --->
	<!--- Get the Photo data from CEData --->
	<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
	<!--- <cfdump var="#photoDataArray#" label="photoDataArray" expand="false"> --->
	
	<cfoutput>
	<script type="text/javascript">
		jQuery(document).ready(function() {
		    jQuery('##mycarousel').jcarousel({
		        // Configuration goes here
		    });
		});
	</script>
		
	<ul id="mycarousel" class="jcarousel-skin-ie7">
		<!--- The content goes in here --->
	   	<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
			<li>
				<!---<a href="#photoDataArray[i].values.photo#" class="thickbox" title="#photoDataArray[i].values.title#">--->
				<a href="#photoDataArray[i].values.photo#" class="ADFLightbox" title="#photoDataArray[i].values.title#">
					<img src="#photoDataArray[i].values.photo#" style="border:none;" width="75" height="75" alt="#photoDataArray[i].values.title#" />
				</a>
			</li>
	   	</cfloop>
	</ul>
	</cfoutput>
</cfif>