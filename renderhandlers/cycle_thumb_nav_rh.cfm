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
			$('##cycle').cycle({ 
				fx:     'fade', 
				//speed:  'fast', 
				timeout: 0, 
				pager:  '##cycle-nav', 
				pagerAnchorBuilder: function(idx, slide) { 
					// return selector string for existing anchor 
					return '##cycle-nav li:eq(' + idx + ') a'; 
				} 
				 
				$('##direct').click(function() { 
					$('##cycle-nav li:eq(2) a').trigger('click'); 
					return false; 
				}); 
			});
		</script>
        
        <style>
			/*.cycle_container {height:482px; margin:-25px 5px 30px;}*/
			##cycle-nav { width: 300px; margin: 15px; z-index:11; }
			##cycle-nav li { width: 60px; float: left; margin: 8px; list-style: none }
			##cycle-nav a { width: 60px; padding: 3px; display: block; border: 1px solid ##ccc; }
			##cycle-nav a.activeSlide { background: ##88f }
			##cycle-nav a:focus { outline: none; }
			##cycle-nav img { border: none; display: block }
			##cycle {padding:10px 0 0 20px;}
			.pics {height: 282px; width: 392px; padding:0; margin:0; overflow: hidden }
			.pics img {height: 250px; width: 360px; padding: 15px; border: 1px solid ##ccc; background-color: ##eee; top:0; left:0 }
			/*.pics img {-moz-border-radius: 10px; -webkit-border-radius: 10px;}*/
			.cycle_title {background:url(/ADF/apps/pt_photo_gallery/images/bg_cycle_overlay.png); width:660px; height:25px; font:12px Arial, Helvetica, sans-serif; color:##000; z-index:10; position:relative; top:-100px; left:16px; height:72px;}
			.cycle_title p {font:12px Arial, Helvetica, sans-serif; letter-spacing:1.25px; padding:5px; color:##FFF;}
		</style>
        
        <div class="cycle_container">
        <div id="cycle-nav">
        	<ul>
        	<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
            	<li><a href="##" class=""><img src="#application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'thumbnail')#" width="60" height="50" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" /></a></li>
            </cfloop>
            </ul>
        </div>
        
        
        <div style="overflow:hidden; position:relative; z-index:9;" id="cycle" class="pics">
            <cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
            	<img src="#photoDataArray[i].values.photo#" width="660" height="450" alt="#photoDataArray[i].values.title#" title="#photoDataArray[i].values.title#" />
            </cfloop> 
        </div>
                
        </div>
        
	</cfoutput>
</cfif>