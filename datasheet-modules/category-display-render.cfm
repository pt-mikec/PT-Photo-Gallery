<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2011.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Name:
	category-display-render.cfm
Summary:
	Datasheet column render handler to display the category title for the
		uploaded photos.
ADF Requirements:
	CEDATA_1_1
Version:
	2.0.0
History:
	2009-08-04 - MFC - Created
	2011-06-21 - MFC - Added sort value to the column render.
--->
<cfscript>
if (LEN(Request.Datasheet.CurrentColumnValue)) {
	itemData = application.ptPhotoGallery.cedata.getCEData("Photo_Category", "categoryID", Request.Datasheet.CurrentColumnValue, "selected");
	Request.Datasheet.CurrentFormattedValue = "<td><div class='' align='left'><font class='' face='Verdana,Arial' color='##000000' size='2'>#itemData[1].Values.title#</font></div></td>";
	request.datasheet.currentSortValue = itemData[1].Values.title;
}
else
	Request.Datasheet.CurrentFormattedValue = "<td></td>";
</cfscript>
