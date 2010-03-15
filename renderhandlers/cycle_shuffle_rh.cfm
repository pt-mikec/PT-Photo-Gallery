<!---
/* ***************************************************************
/*
Author: 	
	PaperThin Inc.
	R. Alot
Name:
	cycle_shuffle_rh.cfm
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
	items = attributes.elementInfo.elementData.propertyValues;
	
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	//application.ptPhotoGallery.scripts.loadCycle();
</cfscript>

<cfif arrayLen(items)>
	<!--- Get the Photo data from CEData --->
	<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect, "selected")>
	
	<cfoutput>
    	<script type="text/javascript" src="/ADF/apps/pt_photo_gallery/scripts/jquery.cycle.all.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('##cycle').cycle({
					fx: 'shuffle',
				});
			});
		</script>
        
        <!--- <style>
			.pics { height: 257px; width: 362px; padding:0; margin:0; overflow:hidden; }
			.pics img { height: 225px; width: 330px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
			.pics img {-moz-border-radius: 10px; -webkit-border-radius: 10px;}
		</style> --->
		<style>
			.pics { height: 347px; width: 472px; padding:0; margin:0; overflow:hidden; }
			.pics img { height: 290px; width: 440px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
			.pics img {-moz-border-radius: 10px; -webkit-border-radius: 10px;}
		</style>        
        
        <div style="overflow:hidden; position:relative;" id="cycle" class="pics">
            <cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
            	<!--- <img src="#photoDataArray[i].values.photo#" width="330" height="225" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" /> --->
				<img src="#application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'medium')#" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" />
            </cfloop> 
        </div>
        
	</cfoutput>
</cfif>