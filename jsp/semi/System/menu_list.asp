<html>
<!-- #include file="../public/check_session.asp" -->
<!-- #include file="../head.asp" -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="770" border="0" align="center" cellpadding="0" cellspacing="0" class="maintable">
  <tr>
    <td> 
	  <!-- #include file="../header.asp" -->
      <table width="770" border="0" align="center" cellpadding="0" cellspacing="0" class="maintable">
	  <tr valign="top"> 
		<!-- #include file="menu_menu.asp" -->
		<td width="618" height="390" class="maintable"><table width="100%" height="390" border="0" cellpadding="0" cellspacing="10">
			<tr>
			  <td valign="top">
			  	  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><font size="3"><strong><font size="4">Menu Setting</font></strong></font></td>
                    </tr>
                    <tr> 
                      <td height="1" bgcolor="#006666"></td>
                    </tr>
                  </table>
				  <%  'start---------------------------------------------------------------------------------------------  %>
				  <!-- #include file="menu_public.asp" -->
				  <%
				  	f_mtype = Request.Form("f_mtype")
					If f_mtype = "" Then 
						f_mtype = "0"
					End If
				  %>
				  <Script Language="JavaScript">
					<!--
						function cf(s,str){
							var obj = nform;
							if( str == "ctype") {
								obj.action = 'menu_list.asp';
							}else if ( str == "Lock" || str == "onLock" || str == "EDIT_ORDER"){
								obj.action = "menu_save.asp";
							}else{
								obj.action = 'menu_table.asp';
							}
							obj.f_mid.value = s;
							obj.acton.value = str;
							obj.submit();
						}
					//-->
					</Script>
				<form name="nform" method="post">
				  <input type="hidden" name="acton">
				  <input type="hidden" name="f_fid" value="0">
				  <input type="hidden" name="f_rid" value="0">
				  <input type="hidden" name="f_mid">
					  <table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" bgcolor="#EEFAFF">
						<tr> 
						  <td width="1%">&nbsp;</td>
						  <td width="47%">
							<select name="f_mtype" onchange="cf(0,'ctype');">
								<% For i =0  to UBOUND(array_mtype_id) %>
									<% If cint(f_mtype) = cint(i) Then 
											selected = "selected"
									   Else
									   		selected = ""
									   End If
									%>
								<option value="<%=i%>" <%=selected%>><%=array_mtype_name(i)%></option>	
								<% Next %>
							</select>
						  </td>
						  <td width="52%" align="right">
						  [<a href="JavaScript:cf(0,'EDIT_ORDER');" title="Edit Order"><img src="../images/folder.gif" alt="Edit" width="19" height="18" border="0" align="absmiddle" style="cursor:hand">Edit
						    Order</a> ]　
						  [ <a href="JavaScript:cf(0,'ADD');" title="Add"><img src="../images/folder_new.gif" width="19" height="18" border="0" align="absmiddle">Add</a> 
							]&nbsp;&nbsp;</td>
						</tr>
					  </table>
					  <br>
					  <table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#6699CC">
						 <tr align="center" bgcolor="#336699"> 
							<td width="10%"><font color="#FFFFFF">ID</font></td>
							<td width="10%"><font color="#FFFFFF">Order</font></td>
							<td width="20%"><font color="#FFFFFF">Name</font></td>
							<td width="25%" bgcolor="#336699"><font color="#FFFFFF">Default</font></td>
							<td width="20%"><font color="#FFFFFF">Picture</font></td>
							<td width="5%"><font color="#FFFFFF">Open</font></td>
							<td width="10%" colspan="2"><font color="#FFFFFF">Function</font></td>
						 </tr>
						  <% 
							sql = "select *, " &_
								  "p_order = (Case when Menu_Order is null then (select max(Menu_Order)+1 from Menu_Data) Else Menu_Order end) "&_
								  "from Menu_Data where Menu_Access <> 'D' and Menu_RID = 0 and Menu_Type = '" & array_mtype_id(f_mtype) & "'" &_
								  " order by p_order"
								  
							Set conn = Server.CreateObject("ADODB.Connection")
							Set rs = Server.CreateObject("ADODB.Recordset")
							conn.open db_connection_str
							rs.open sql,conn,3,2
							If not rs.eof Then 
								while not rs.eof 
									show_id 		=	rs("Menu_ID")
									show_Name		=	rs("Menu_Name")
									show_order		=	rs("Menu_Order")
									show_default	=	rs("Menu_Default")
									show_pic		=	rs("Menu_Pic")
									show_access		=	rs("Menu_Access")
									If (show_default = "" or isnull(show_default)) Then show_default = "&nbsp;"
									If (show_pic = "" or isnull(show_pic)) Then show_pic = "&nbsp;"
									If show_access = "Y" Then 
										lock_img	= 	"folder_lock.gif"
										lock_type	=	"Lock"
										lock_alt	=	"Close"
									Else
										lock_img	=	 "folder_open.gif"
										lock_type	=	"onLock"
										lock_alt	=	"Open"
									End If
									
						  %>
						 <tr onMouseOut="this.style.backgroundColor=''"  onMouseOver="this.style.backgroundColor='#F3F2F3'">
							<td width="10%" align="center"><% = show_id %></td>
							<td width="10%" align="center">
						  		<input type="hidden" name="f_order_id" value="<%=show_id%>">
						  		<input type="text" value="<%=show_order%>" name="f_order_<%=show_id%>" size="2" maxlength="2" class="input-table" style="width:20px;text-align:right">
							</td>
							<td width="20%" align="center"><% = show_Name %></td>
							<td width="25%" align="center"><% = show_default %></td>
							<td width="20%" align="center"><% = show_pic %></td>
							<td width="5%" align="center"><% = show_access %></td>
						  <td width="5%" align="center"><img src="../images/folder.gif" width="19" height="18" onclick="JavaScript:cf(<%=show_id%>,'EDIT');" style="cursor:hand" alt="Edit"></td>
						  <td width="5%" align="center"><img src="../images/<%=lock_img%>" width="19" height="18" onclick="JavaScript:cf(<%=show_id%>,'<%=lock_type%>');" style="cursor:hand" alt="<%=lock_alt%>"></td>
						</tr>
							<% 
								rs.movenext
								wend
							%>
						<% Else %>
						<tr>
							<td colspan="8" align="center">Not Data!!</td>
						</tr>
						<% End If%>
						<% 
							rs.close						
							Set rs = nothing
							conn.close
							Set conn = nothing

						%>
					</table>
				</form>

			  </td>
			</tr>
      </table> </td>
  </tr>
  </table>
  <!-- #include file="../footer.asp" -->
  </td></tr>
</table>
</body>
</html>
