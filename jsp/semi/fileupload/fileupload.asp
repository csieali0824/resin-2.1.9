<html>
<!-- #include file="../public/default_value.asp" -->
<!-- #include file="../public/public.asp" -->
<!-- #include file="../head.asp" -->
<%
f = Trim(Request.QueryString("f"))
p = Trim(Request.QueryString("p"))
n = Trim(Request.QueryString("n"))
t = Trim(Request.QueryString("t"))
v = Trim(Request.QueryString("v"))
c = Trim(Request.QueryString("c"))
m = Replace(Replace(Replace(Replace(Replace(Trim(Request.QueryString("m")),"/","_"),"\","_"),",","_"),")","_"),"(","_")
'm = Trim(Request.QueryString("m"))

%>
<Script Language="JavaScript">
<!--
	function checkform(){
		if ( trim(uform.f_file.value) == "" ) {
			alert("Please Select File !! ");
			return false;
		}else if ( trim(uform.f_filename.value) == ""){
			alert("Please Enter FileName !!");
			return false;
		}else{
			for( idx = 0 ; idx <uform.f_filename.value.length ; idx++ ){
				var oname= uform.f_filename.value.charAt(idx);
				if(!((oname>="A"&&oname<="Z")||(oname>="a"&&oname<="z")||(oname>="0"&&oname<="9")||(oname=="-")||(oname=="_")||(oname=="+"))){
					alert("FileName inculde special Character , Please contact to Taipei MIS . E-mail:suming@mail.ts.com.tw  !!");
					return false;
				}
			}
		}
	}
	function get_name(){
		<% If t <> "EDIT" Then %>
		if ( trim(uform.f_file.value) == "" ) {
			uform.f_filename.value = '';
			alert("Please Select File !! ");
		}else{
			if (uform.f_filename.value == ""){
				n = (uform.f_file.value).split("\\");
				str = (n[n.length-1]).split(".");
				uform.f_filename.value = str[0].substr(str[0].length-20,20);
			}
		}
		<% End If %>
	}
//-->
</Script>
<%If f = "" or p = "" or n = "" and t = "" Then %>
<Script Language="JavaScript">
<!--
	window.close();
//-->
</Script>
<%
	Response.End()
End If
%>
<Script Language="JavaScript">
<!--
	if (!window.opener) {
		if (top.location.href.indexOf("<%=logon_web_index%>") == -1)
		top.location.href = "<%=logon_web_path%>/<%=logon_web_index%>";
	}
	
//-->
</Script>
<% 
	If t = "EDIT" and v <> "" Then 
	'response.Write("t")
	'response.end
		'f_value	=	left(v, (Cint(Len(v))) - (Cint(InStrRev(v, "."))))   
		'f_value		=	mid(v, Cint(Len(n))+1,(Cint(InStrRev(v, ".")))-(Cint(Len(n))+1))
		f_value		=	cust_po_num
		open_name	=	"readonly"
	Else
		If v  <> "" Then 

			f_value		=	cust_po_num

			'mid(v, Cint(Len(n))+1,(Cint(InStrRev(v, ".")))-(Cint(Len(n))+1))

			open_name 	= 	"readonly"
			t		=	"EDIT"
		Else
	'response.Write("k")
	'response.end
			f_value		=	cust_po_num
			open_name	=	""
		End If
 	End If 
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form method="post" name="uform" action="filesave.asp" enctype="multipart/form-data" onSubmit="return checkform()">
  <table width="300" border="0" align="center" cellpadding="0" cellspacing="0" class="maintable">
    <tr> 
      <td height="40" colspan="2" align="center"> <strong><font color="#34699E">File 
        Upload</font></strong>
        <hr width="270" size="1" noshade>
		<input type="hidden" name="f_path" value="<%=p%>">
		<input type="hidden" name="f_name" value="<%=n%>">
		<input type="hidden" name="f_text" value="<%=f%>">
		<input type="hidden" name="acton" value="<%=t%>">
		<input type="hidden" name="f_version" value="<%=c%>">
		<input type="hidden" name="f_cust_no" value="<%=v%>">
		<input type="hidden" name="f_ponum" value="<%=m%>">

        <table width="95%" border="1" bordercolor="#CCCCCC" bordercolordark="#FFFFFF">
          <tr> 
            <td width="80" height="40" align="right"><strong>File Path:&nbsp;&nbsp;</strong></td>
            <td width="189" height="40"> 
              <input name="f_file" type="file" class="input-table" size="10" style="cursor:hand" onChange="get_name();" >
              <br>
              <font color="#FF0000">English_Filename_Only</font></td>
          </tr>
          <tr>
            <td width="80" height="40" align="right"><strong>File Name:</strong></td>
            <td height="40"> 
          
              <input name="f_filename" type="text" class="input-table" size="15" maxlength="20" value="<%=n+m+c%>"  readonly ></td>
          </tr>
        </table> </td>
    </tr>
    <tr> 
      <td height="40" colspan="2" align="center"> <input type="submit" value="Send" class="input-button"></td>
    </tr>
  </table>
</form>
</body>
</html>
