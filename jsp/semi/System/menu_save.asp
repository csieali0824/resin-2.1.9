<!-- #include file="../public/check_session.asp" -->
<!-- #include file="../head.asp" -->
<!-- #include file="../public/public.asp" -->
<!-- #include file="menu_public.asp" -->

<%

'get value
acton 		= 	Request.Form("acton")
f_fid		=	Request.Form("f_fid")
f_rid		=	Request.Form("f_rid")
f_mid		=	Request.Form("f_mid")
f_mtype		=	Request.Form("f_mtype")
f_mname 	=	SqlStr(Trim(Request.Form("f_mname")))
f_mdefault	=	SqlStr(Trim(Request.Form("f_mdefault")))
f_mopen		=	Request.Form("f_mopen")
f_mmemo		=	SqlStr(Trim(Request.Form("f_mmemo")))
f_mpic		=	Request.Form("f_mpic")
f_ntitle	=	Request.Form("f_ntitle")
f_title		=	Request.Form("f_title")
If acton <> "SAVE_ADD" and f_mid = "" Then 
	js_back()
	Response.End
ElseIf ( acton = "SAVE_ADD" or acton = "SAVE_EDIT" ) Then 
	if ( f_fid = "" or f_rid = "" or f_mid = "" or f_mtype = "" or f_mname = "" or f_mopen = "" ) Then 
		js_alert("Please fill this form completely!!")
		js_back()
		Response.End()
	End If
End If

turn_url = Request.ServerVariables("HTTP_REFERER")

Set conn = Server.CreateObject("ADODB.Connection")
conn.open db_connection_str

Select Case acton 
	Case "SAVE_ADD"
		f_rid = f_mid
		sql	= 	" SET NOCOUNT ON;" &_
			 	" INSERT INTO Menu_Data(Menu_Type,Menu_FID,Menu_RID,Menu_Name,Menu_Default,Menu_Memo,Menu_Pic,Menu_Access,CreateBy)" &_
			 	" VALUES(" &_
			 	"'" & array_mtype_id(f_mtype) & "'," & f_fid & "," & f_rid & ",'" & f_mname & "','" & f_mdefault & "','" & f_mmemo & "'," &_
			 	"'" & f_mpic & "','" & f_mopen & "','" & session("sess_logon_id")  & "')" &_
				" SELECT @@IDENTITY AS Menu_ID;"
		
		Set rs = conn.execute(sql)
		f_mid = rs(0)
		If f_rid = 0 Then 
			sql = "UPDATE Menu_Data Set Menu_FID = " & f_mid & " where Menu_ID = " & f_mid 
			conn.execute(sql)
		End If
		rs.close
		Set rs = nothing
		msg = "Add Data Successfully!!"
	Case "SAVE_EDIT"
		sql = "Select Menu_Pic From Menu_Data Where Menu_ID =" & f_mid
		Set rs = conn.execute(sql)
		If Not rs.eof Then 
			If f_mpic = "" Then 
				set fso = Server.CreateObject("Scripting.FileSystemObject")
				file_name = server.MapPath(default_menu_pic_path) & "/" & rs("Menu_Pic")
				If fso.FileExists(file_name) Then
					fso.DeleteFile file_name, True
				end if 
			End If
		End If
		sql = 	"UPDATE Menu_Data Set Menu_Name = '" & f_mname & "',Menu_Default='" & f_mdefault & "'," &_
				"Menu_Memo='" & f_mmemo & "',Menu_Pic='" & f_mpic & "'," &_
		 	  	"Menu_Access='" & f_mopen & "',ModifyBy='" & session("sess_logon_id") & "',ModifyTime = getdate() " &_
				"Where Menu_ID = " & f_mid
		conn.execute(sql)
		rs.close
		Set rs = nothing
		if (Right(f_ntitle,Len(f_title))) = f_title Then 
			f_ntitle = Left(f_ntitle,Len(f_ntitle)-Len(f_title))
		End If
		msg = "Modify Data Succesfully!!"
	Case "SAVE_DEL"
		sql = "UPDATE Menu_Data Set Menu_Access = 'D',ModifyBy='" & session("sess_logon_id") & "',ModifyTime = getdate() where Menu_ID = " & f_mid
		conn.execute(sql)
		msg = "Delete Data Successfully!!"
		f_mid = f_rid
		if f_mid = 0 Then  turn_url = "menu_list.asp"
		f_ntitle	= Left(f_ntitle,Len(f_ntitle)-Len(f_title))
	Case "Lock"
		sql = "UPDATE Menu_Data Set Menu_Access = 'N',ModifyBy='" & session("sess_logon_id") & "',ModifyTime = getdate() where Menu_ID = " & f_mid
		conn.execute(sql)
		msg = "Close Successfully!!"
		f_mid = f_rid
	Case "onLock"
		sql = "UPDATE Menu_Data Set Menu_Access = 'Y',ModifyBy='" & session("sess_logon_id") & "',ModifyTime = getdate() where Menu_ID = " & f_mid
		conn.execute(sql)
		msg = "Open Successfully!!"
		f_mid = f_rid
	Case "EDIT_ORDER"
		f_order_id	= Split(Request.Form("f_order_id"),", ")
		For i = 0 To UBOUND(f_order_id)
			f_order_num = Trim(Request.Form("f_order_" & f_order_id(i)))
			If Not isNumeric(f_order_num) Then f_order_num = "Null"
			sql = sql & " UPDATE Menu_Data Set Menu_Order = " & f_order_num & " Where Menu_ID=" & f_order_id(i) & ";"
		Next
		conn.execute(sql)
		msg = "UPDATE Order Successfully!!"
End Select

conn.close
Set conn = nothing

%>


<form name="sform" method="post" action="<%=turn_url%>">
  <input type="hidden" name="acton" value="EDIT">
  <input type="hidden" name="f_mtype" value="<%=f_mtype%>">
  <input type="hidden" name="f_fid" value="<%=f_fid%>">
  <input type="hidden" name="f_rid" value="<%=f_rid%>">
  <input type="hidden" name="f_mid" value="<%=f_mid%>">
  <input type="hidden" name="f_ntitle" value="<%=f_ntitle%>">
</form>
<Script Language="JavaScript">
<!--
	alert("<% = msg %>");
	sform.submit();
//-->
</Script>