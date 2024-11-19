<!-- #include file="../public/default_value.asp" -->
<!-- #include file="../public/public.asp" -->
<!-- #include file="../system/menu_public.asp" -->
<!-- #include file="../head.asp" -->
<%
set xup = Server.CreateObject("Xionsoft.XionFileUpLoad")

'get value
If xup.ItemCount <= 0 Then
	response.Redirect("fileupload.asp")
	response.End()
End If
acton		=	xup.ItemValue("acton")
f_path		=	xup.ItemValue("f_path")
f_name		=	xup.ItemValue("f_name")
f_text		=	xup.ItemValue("f_text")
f_version	=	xup.ItemValue("f_version")
f_ponum		=	xup.ItemValue("f_ponum")
f_cust_no	=	xup.ItemValue("f_cust_no")
f_filename	=	Trim(xup.ItemValue("f_filename"))
If xup.FileCount > 0 Then 
	pic_full_name	= 	xup.FileName("f_file")
Else
	pic_full_name 	=	""
End If

if ( f_path = "" or f_name = "" or f_text = "" or f_filename = "" or pic_full_name = "" ) Then 
	js_alert("尚未欄位未填寫!!")
	js_back()
	Response.End()
Else
	f_path = Server.MapPath(f_path)
	'response.Write(f_path)
	'response.End
End If

for i=1 to xup.FileCount
	spic_uname = pic_full_name
	spic_type = Right(spic_uname, (Cint(Len(spic_uname))) - (Cint(InStr(spic_uname, "."))))
	str_pic = f_name & f_ponum & f_version & "." & spic_type
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	file_name = f_path & "/" & str_pic
	If fso.FileExists(file_name) and acton = "ADD" Then
%>
	<Script language="JavaScript">
	<!--
		alert("Duplicated Filename!!");
		history.back();
	//-->
	</Script>
<%
		Response.End()
	Else
		xup.SaveFile i, f_path & "/" & str_pic , false
	End if 
next
%>
<Script language="JavaScript">
<!--
	alert("File Upload Successfully!!");
	opener.<%=f_text%>.value = "<%=str_pic%>";
	window.close();
//-->
</Script>