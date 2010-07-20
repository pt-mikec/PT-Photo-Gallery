<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2010.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadADFlightbox();
</cfscript>

<cfif StructKeyExists(request.params, "imgSrc")>
<cfoutput>
	<CFSCRIPT>
		CD_requiredParams = "pageid";
		CD_Title="Template Hierarchy";
		CD_DialogName = "template-hierarchy";
		CD_CheckLock=0;
		CD_MainTableWidth = 414;
	</CFSCRIPT>
	<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-head.cfm">
	<div style="width:100%;text-align:center">
		<img src="#request.params.imgSrc#">
	</div>
	<CFINCLUDE TEMPLATE="/commonspot/dlgcontrols/dlgcommon-foot.cfm">
</cfoutput>
<cfelse>
<cfoutput>
	<div style="width:100%;text-align:center">
		No Photo to Display
	</div>
</cfoutput>
</cfif>