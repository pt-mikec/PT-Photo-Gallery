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
					fx:         'fade',
					timeout:     3000,
					pager:      '##cycle_nav',
					pagerEvent: 'mouseover',
					fastOnEvent: true
				});
			});
		</script>
        
        <style>
			.cycle_container {height:482px; margin:-25px 5px 30px;}
			##cycle_nav {margin:5px; position:relative; top:50px; z-index:10; left:25px; font:11px arial, helvetica sans-serif;}
			##cycle_nav a {margin:5px; padding:3px 7px; border:1px solid ##ccc; background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_nav.png); color:##666; text-decoration:none;}
			##cycle_nav a.activeSlide {background:##d67b00; border: 1px solid ##fff; color:##fff;}
			##cycle_nav a:focus { outline: none; }
			.pics {height: 482px; width: 692px; padding:0; margin:0; overflow: hidden }
			.pics img {height: 450px; width: 660px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
			.pics img {-moz-border-radius: 10px; -webkit-border-radius: 10px;}
			.cycle_title {background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_overlay.png); width:660px; height:25px; font:12px Arial, Helvetica, sans-serif; color:##000; z-index:10; position:relative; top:-100px; left:16px; height:72px;}
			.cycle_title p {font:12px Arial, Helvetica, sans-serif; letter-spacing:1.25px; padding:5px; color:##FFF;}
		</style>
        
        <div class="cycle_container">
        
        <div id="cycle_nav">
        </div>
        
        
        <div style="overflow:hidden; position:relative; z-index:9;" id="cycle" class="pics">
            <cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
            	<img src="#photoDataArray[i].values.photo#" width="660" height="450" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" />
            </cfloop> 
        </div>
        
        <div class="cycle_title">
        	<cfloop index="t" from="1" to="#ArrayLen(photoDataArray)#">
        		<p>#photoDataArray[t].values.title#</p>
            </cfloop>
        </div>
        
        </div>
        
	</cfoutput>
</cfif>