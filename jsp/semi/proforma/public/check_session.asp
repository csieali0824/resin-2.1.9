<!-- #include file="default_value.asp" -->
<Script Language="JavaScript">
<!--
	if (window.opener) {
		if (window.opener.parent.top.location.href.indexOf("index.asp") == -1){
		window.opener.parent.location.href = "<%=logon_web_path%>/<%=logon_web_index%>";
		window.self.close();
		}
	}else{
		if (top.location.href.indexOf("<%=logon_web_index%>") == -1)
		top.location.href = "<%=logon_web_path%>/<%=logon_web_index%>";
	}
	
//-->
</Script>
<%
	If session("sess_logon_id") = "" Then 
		go_logon
		Response.End
	End If
%>
<%
Function go_logon()
%>
<Script Language="JavaScript">
<!--
	if (window.opener) {
		window.opener.parent.location.href="<%=logon_web_path%>/<%=logon_web_index%>";
		window.self.close();
	}else{
		window.top.parent.location.href="<%=logon_web_path%>/<%=logon_web_index%>";
	}
	
//-->
</Script>
<%
Response.End
End Function 
%>