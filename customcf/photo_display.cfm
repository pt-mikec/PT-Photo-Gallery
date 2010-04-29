<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadADFlightbox();
</cfscript>

<cfif StructKeyExists(request.params, "imgSrc")>
<cfoutput>
	<div style="width:100%;text-align:center">
		<img src="#request.params.imgSrc#">
	</div>
</cfoutput>
<cfelse>
<cfoutput>
	<div style="width:100%;text-align:center">
		No Photo to Display
	</div>
</cfoutput>
</cfif>