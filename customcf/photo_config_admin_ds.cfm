<cfscript>
	application.ADF.scripts.loadJQuery();
	//application.ADF.scripts.loadJQueryTools();
	application.ADF.scripts.loadJQueryUI("1.7.2", "start");
	application.ADF.scripts.loadADFLightbox();
	
	request.params.configStruct = application.ptPhotoGallery.getAppConfig();
	request.params.formid = application.ADF.cedata.getFormIDByCEName("ptPhotoGallery Configuration");
	request.params.addButtonTitle = "Add New Photo Configuration";
	request.params.editLBWidth = 575;
	request.params.editLBHeight = 330;
</cfscript>

<cfoutput>
<script type="text/javascript">
	jQuery(document).ready(function(){
		// Hover states on the static widgets
		jQuery("div.ds-icons").hover(
			function() { 
				$(this).css("cursor", "hand");
				$(this).addClass('ui-state-hover');
			},
			function() { 
				$(this).css("cursor", "pointer");
				$(this).removeClass('ui-state-hover');
			}
		);
	});
</script>
<style>
	div.add-button {
		padding: 6px 10px 10px 12px;
		text-decoration: none;
		margin-left: 20px;
		width: 210px;
		height: 16px;
	}
	div.ds-icons {
		padding: 1px 10px;
		text-decoration: none;
		margin-left: 20px;
		width: 30px;
	}
</style>
<div id="addNew" style="padding:20px;">
	<cfif LEN(request.user.userid)>
		<div rel="#application.ADF.ajaxProxy#?bean=Forms_1_0&method=renderAddEditForm&formid=#request.params.formid#&datapageid=0&width=#request.params.editLBWidth#&height=#request.params.editLBHeight#&title=#request.params.addButtonTitle#" id="addNew" title="#request.params.addButtonTitle#" class="ADFLightbox add-button ui-state-default ui-corner-all">#request.params.addButtonTitle#</div><br />
	<cfelse>
		Please <a href="#request.subsitecache[1].url#login.cfm">LOGIN</a> to manage your profile.<br />
	</cfif>
</div>
</cfoutput>
<CFMODULE TEMPLATE="/commonspot/utilities/ct-render-named-element.cfm"
	elementtype="datasheet"
	elementName="ptPhotoGalleryConfigDS">