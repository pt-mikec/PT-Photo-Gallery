<!---
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Name:
	category-display-render.cfm
Summary:
	Datasheet column render handler to display the category title for the
		uploaded photos.
ADF Requirements:
	CEDATA_1_0
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
if (LEN(Request.Datasheet.CurrentColumnValue)) {
	itemData = application.ptPhotoGallery.cedata.getCEData("Photo_Category", "categoryID", Request.Datasheet.CurrentColumnValue, "selected");
	Request.Datasheet.CurrentFormattedValue = "<td><div class='' align='left'><font class='' face='Verdana,Arial' color='##000000' size='2'>#itemData[1].Values.title#</font></div></td>";
}
else
	Request.Datasheet.CurrentFormattedValue = "<td></td>";
</cfscript>

