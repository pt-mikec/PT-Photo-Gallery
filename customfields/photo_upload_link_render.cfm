<!---
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Custom Field Type:
	Photo Upload Link Field
Name:
	photo_upload_link_render.cfm
Summary:
	Custom select field to render an upload link to the photo element.
ADF Requirements:
	Scripts_1_0
Version:
	0.9.1
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	
	// Set the photo field ID
	if ( NOT StructKeyExists(xparams, "photoFieldID") OR (LEN(xparams.photoFieldID) LTE 0) )
		xparams.photoFieldID = fqFieldName;
</cfscript>
<!--- <cfdump var="#xparams.category#"> --->

<cfoutput>	
	<cfscript>
		application.ptPhotoGallery.scripts.loadJQuery("1.3.2", 1);
		//application.ptPhotoGallery.scripts.loadThickbox("3.1");
		application.ptPhotoGallery.scripts.loadJQueryUI("1.7.2");
		application.ptPhotoGallery.scripts.loadADFLightbox();
	</cfscript>
	
	<script type="text/javascript">
		// set up the accordion action
		//var profileAcc = new Spry.Widget.Accordion("ProfileAccordion", { defaultPanel: 0 });
		// javascript validation to make sure they have text to be converted
		#fqFieldName#=new Object();
		#fqFieldName#.id='#fqFieldName#';
		#fqFieldName#.tid=#rendertabindex#;
		//#fqFieldName#.validator="#fqFieldName#Obj.handleSaveSort(document.getElementById('#fqFieldName#_List'))";
		//#fqFieldName#.msg="Please upload a document.";
		// push on to validation array
		//vobjects_#attributes.formname#.push(#fqFieldName#);
	</script>
	
	<script type="text/javascript">
		// Store the current value
		var #fqFieldName#currentValue = "#currentValue#";
		
		jQuery(document).ready(function(){
			
			// if currentValue has data, then photo has been uploaded already
			if (#fqFieldName#currentValue != "")
				#fqFieldName#_loadImage();
			else
				#fqFieldName#_loadAddButton();
			// Event click for the remove button
			jQuery('###fqFieldName#_photoRemove').live("click", function()
			{ 
				#fqFieldName#_clearField();
		    });
		});
		
		function #fqFieldName#_loadAddButton()
		{
			jQuery("###fqFieldName#_photoDisplay").hide();
			jQuery("###fqFieldName#_addPhoto").show();
		}
		
		function #fqFieldName#_loadImage()
		{
			// get the image
			var photoID = jQuery("input###xparams.photoFieldID#").val();
			// get the photo URL
			jQuery.get( '#application.ADF.ajaxProxy#',
			{ 	
				bean: 'photoService',
				method: 'getPhotoURLbyPhotoID',
				photoID: photoID,
				size: "small"
			},
			function(photoURL){
				// load new img url into the img field
				if (photoURL != "")
					#fqFieldName#renderPhoto(photoURL);
				else 
				{
					// The photo doesn't exist anymore
					#fqFieldName#_loadAddButton();
					jQuery("input###xparams.photoFieldID#").val("");
				}
			});
		}
		
		// Set the value back from the photo form
		function #fqFieldName#setPhotoField(inArgsArray)
		{
			/* 
				inArgsArray[0] = URL to the image
				inArgsArray[1] = photo UID
			 */
			
			//alert("...I answered!");
			//alert(inArgsArray);
			
			// load new img url into the img field
			#fqFieldName#renderPhoto(inArgsArray[0]);
			
			// Store the photo ID value into the fqFieldName
			jQuery("input###xparams.photoFieldID#").val(inArgsArray[1]);
		}
		
		function #fqFieldName#renderPhoto(url){
			// load new img url into the img field
			jQuery("img###fqFieldName#_photoTag").attr('src',url);
			jQuery("img###fqFieldName#_photoTag").attr('width','50');
			jQuery("img###fqFieldName#_photoTag").attr('height','50');
			jQuery("###fqFieldName#_photoDisplay").show();
			jQuery("###fqFieldName#_addPhoto").hide();
		}
		
		// Function to clear the selected photo field
		function #fqFieldName#_clearField()
		{
			// Get the value for the field value
			var currentPhotoURL = jQuery("input###xParams.photoFieldID#").val();
			
			// check that we have a value to delete
			if (currentPhotoURL != '')
			{
				// confirmation to clear the image
				var clear = confirm("Are you sure you want to clear this photo?");
				if (clear)
				{
					// Delete the photo element instance
					/* jQuery.get( "#request.subsitecache[1].url#_cs_apps/pt_photo_gallery/customfields/photo_upload_cleanup.cfm",
						{ 	imageURL: currentPhotoURL
						},
						function(msg){
							// Clear the field value
							jQuery("input###fqFieldName#").val("");
							
							// clear the photo id field
							if ("#xparams.photoFieldID#" != "")
								jQuery("input###xparams.photoFieldID#").val("");
						}); */
						
					#fqFieldName#_loadAddButton();
				}
			}
		}
	</script>
</cfoutput>

<cfoutput>
<!--- // determine if this is rendererd in a simple form or the standard custom element interface --->
<cfscript>
	if ( structKeyExists(request, "element") )
	{
		labelText = '<span class="CS_Form_Label_Baseline"><label for="#fqFieldName#">#xParams.label#:</label></span>';
		tdClass = 'CS_Form_Label_Baseline';
	}
	else
	{
		labelText = '<label for="#fqFieldName#">#xParams.label#:</label>';
		tdClass = 'cs_dlgLabel';
	}
</cfscript>
<tr>
	<td class="#tdClass#" valign="top">#labelText#</td>
	<td class="cs_dlgLabelSmall" >
		<div id="#fqFieldName#_photoDisplay">
			<img id="#fqFieldName#_photoTag" src="">
			[<a id="#fqFieldName#_photoRemove"><span style="color:##3399CC;text-decoration:none;font-weight:500;cursor:pointer;cursor:hand;">Remove</span></a>]
		</div>
		<div id="#fqFieldName#_addPhoto">
			<!--- [<a href='#server.ADF.environment[request.site.id].ptPhotoGallery.ADD_URL#?callBack=#fqFieldName#setPhotoField&keepThis=true&TB_iframe=true&width=500&height=400' title='Add Photo' class='thickbox' style="text-decoration:none;"><span style="color:##3399CC;text-decoration:none;font-weight:500;cursor:pointer;cursor:hand;">Add Photo</span></a>] --->
			[<a href='' rel='#server.ADF.environment[request.site.id].ptPhotoGallery.ADD_URL#?callback=#fqFieldName#setPhotoField&width=500&height=400&title=Add Photo' title='Add Photo' class='ADFLightbox' style="text-decoration:none;"><span style="color:##3399CC;text-decoration:none;font-weight:500;cursor:pointer;cursor:hand;">Add Photo</span></a>]
		<br />
		<input type="hidden" id="#xparams.photoFieldID#" name="#fqFieldName#" value="#currentValue#">
		<!--- // include hidden field for simple form processing --->
		<input type="hidden" name="#fqFieldName#_FIELDNAME" id="#fqFieldName#_FIELDNAME" value="#REPLACE(xParams.fieldName,'FIC_', '')#">
	</td>
</tr>

</cfoutput>