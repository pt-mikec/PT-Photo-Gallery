<cfscript>
	// Make the page dynamics
	request.element.isStatic = 0;
	
	items = attributes.elementInfo.elementData.propertyValues;
	
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	//application.ptPhotoGallery.scripts.loadThickbox("3.1");
	application.ptPhotoGallery.scripts.loadADFlightbox();
</cfscript>

<cfif ArrayLen(items)>
	<!--- <cfdump var="#items#" label="items" expand="false"> --->
	<!--- Get the Photo data from CEData --->
	<cfset photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", items[1].values.photoSelect)>
	<!--- <cfdump var="#photoDataArray#" label="photoDataArray" expand="false"> --->
	<!--- Check we have photo data --->
	<cfif ArrayLen(photoDataArray)>
		<cfoutput>
			<style>
				/*Profile Listing Type C*/
				* {margin:0px; padding:0px;}
				
				a {color:##4f81bd; text-decoration:none;}
				a:hover {color:##8cb4e4; text-decoration:underline;}
				
				##content-wrapper {width:900px; margin:auto;}
				.header {background:url(/ADF/apps/pt_photo_gallery/images/header-dark.gif) left top no-repeat; height:92px; width:900px;}
				
				.listing {width:900px; border-bottom:5px solid ##17365d;}
					.listing a {color:##ff6c0a; text-decoration:none;}
					.listing a:hover {color:##d2d2d2; text-decoration:underline;}
					.listing ul li {font:bold 15px Arial, Helvetica, sans-serif; display:inline; padding:12px 6px 0;}
				.listing a.active {color:##d2d2d2; text-decoration:none; background:url(/ADF/apps/pt_photo_gallery/images/active.gif) center -5px no-repeat;}
					.listing ul {padding:12px 0; margin-top:-24px;}
				.alpha {text-align:center;}
				
				.profile-column {width:900px; overflow:auto;}
					dl {float:left; display:inline; width:258px; padding:20px; border:2px solid ##FFF; border-top:none; border-left:none; height:180px;}
					dl+dl+dl {border-right:none; width:259px;}
					dt {font:bold 12px arial, helvetica, sans serif; font-weight:bold; text-align:center; color:##17365d; letter-spacing:2px; margin-bottom:5px;}
					dd {font:10px arial, helvetica, sans serif; color:##3a3a3a;}
					/* dd img {width:214px; height:143px; border:none; text-align:center;} */
					dd img {border:5px solid ##FFF; text-align:center; -webkit-border-radius:5px; -moz-border-radius:5px; margin-left:50px;}
						.title {text-align:center; color:##17365d; font-weight:bold; letter-spacing:2px;}
						.description {margin-left:10px; margin-top:10px; font-style:italic;}
						.call-to-action {font-size:10px; font-weight:bold; clear:both; float:left; background:url(/ADF/apps/pt_photo_gallery/images/call-to-action.gif) center left no-repeat; padding-left:20px; margin-top:-20px; margin-left:30px; display:none;}
				                .image {}
						.even {background-color:##efefef;}
						.odd {background-color:##d8d8d8;}
				/**/
				</style>
		</cfoutput>
		<!--- Render the pagination --->
		<cfoutput>
			<div class="listing alpha">
		        <ul>
		        	<li><a href="##">&laquo; Previous</a></li>
		            <li><a href="##" class="active">1</a></li>
		            <li><a href="##">2</a></li>
		            <li><a href="##">3</a></li>
		            <li><a href="##">4</a></li>
		            <li><a href="##">5</a></li>
		            <li><a href="##">Next &raquo;</a></li>
		        </ul>
		    </div>
		</cfoutput>
		<cfset currRowCount = 0>
		<!--- loop over the photo data --->
		<cfloop index="i" from="1" to="#ArrayLen(photoDataArray)#">
			<cfoutput>
				<cfif (i mod 3) EQ 1>
					<cfset currRowCount = currRowCount + 1>
					<cfif (currRowCount mod 2) EQ 1>
						<div class="profile-column odd">
					<cfelse>
						<div class="profile-column even">
					</cfif>
				</cfif>
				<cfset largeImg = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'large')>
				<cfset thumbImg = application.ptPhotoGallery.renderService.getPhotoURL(photoDataArray[i].values.photo,'thumbnail')>
				<dl>
					<dt><a href="#largeImg#" class="ADFLightbox">#photoDataArray[i].Values.title#</a></dt>
						<dd class="image"><a href="#largeImg#" title="#photoDataArray[i].Values.title#" class="ADFLightbox">
							<img src="#thumbImg#" alt="#photoDataArray[i].Values.title#" /></a></dd>
					<dd class="description">#photoDataArray[i].Values.abstract#</dd>
				</dl>
				<cfif ((i mod 3) EQ 0) OR (i EQ ArrayLen(photoDataArray))>
					</div>
				</cfif>
			</cfoutput>
		</cfloop>
	<cfelse>
		<cfoutput>No Photos to Display.</cfoutput>
	</cfif>
<cfelse>
	<cfoutput>No Records to Display.</cfoutput>
</cfif>
