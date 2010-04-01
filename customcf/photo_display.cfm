<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadADFlightbox();
</cfscript>

<cfoutput>
	<div style="width:100%;text-align:center">
		<img src="#request.params.imgSrc#">
	</div>
</cfoutput>