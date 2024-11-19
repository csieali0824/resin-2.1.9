<html>
<!-- #include file="../public/check_session.asp" -->
<!-- #include file="../head.asp" -->
<!-- #include file="../public/public.asp" -->

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
					'get value
				  	f_mtype = Request.Form("f_mtype")
					acton	= Request.Form("acton")
					f_fid	= Request.Form("f_fid")
					f_rid	= Request.Form("f_rid")
					f_mid	= Request.Form("f_mid")
					f_ntitle= Request.Form("f_ntitle")

					If f_mtype = "" or acton = "" Then 
				  		js_back()
						Response.End()  	
					End If

					Select Case acton
						Case "ADD"
							f_mname 	= 	""
							f_mdefault 	= 	""
							f_mpic		=	""
							f_mopen		=	"Y"
							acton 		= 	"SAVE_ADD"
							f_mtitle	=	f_ntitle
							f_mmemo		=	""
						Case "EDIT"
							sql = "select *, " &_
								  "p_order = (Case when Menu_Order is null then (select max(Menu_Order)+1 from Menu_Data) Else Menu_Order end) "&_
								  "from Menu_Data where Menu_Access<>'D' and Menu_Type = '" & array_mtype_id(f_mtype) &_
								  "' and ( Menu_RID = " & f_mid  & "or Menu_ID = "  & f_mid & ") "&_
								  "order by Menu_RID,p_order,Menu_ID"
								
							Set conn = Server.CreateObject("ADODB.Connection")
							Set rs = Server.CreateObject("ADODB.Recordset")
							conn.open db_connection_str
							rs.open sql,conn,3,2
							If Not rs.eof Then 
								f_mid		=	rs("Menu_ID")
								f_fid		= 	rs("Menu_FID")
								f_rid		= 	rs("Menu_RID")
								f_mname 	= 	rs("Menu_Name")
								f_mdefault 	= 	rs("Menu_Default")
								f_mpic		=	rs("Menu_Pic")
								f_mopen		=	rs("Menu_Access")
								f_mmemo		=	rs("Menu_Memo")
								f_title		=	" -- " & f_mname
								if (Right(f_ntitle,Len(f_title))) = f_title Then 
									f_ntitle	= Left(f_ntitle,Len(f_ntitle)-Len(f_title))
								End If
								f_mtitle	=	f_ntitle & " -- " & f_mname
								acton 		=	"SAVE_EDIT"
							Else
								f_mid		=	0
								f_mname 	= 	""
								f_mdefault 	= 	""
								f_mpic		=	""
								f_mopen		=	"Y"
								acton 		= 	"SAVE_ADD"
								f_mtitle	=	f_ntitle
								f_mmemo		=	""					
							End If
							
					End Select
				  %>
				   <Script Language="JavaScript">
					<!--
						function cf(s,str){
							var obj= nform;
							obj.acton.value = str;
							obj.f_mid.value = s;
							obj.action = "menu_save.asp";
							if ( str == "BACK" ){
							    <% if f_rid = 0 Then %>
								obj.action = "menu_list.asp";
								<% Else %>
								obj.action = "menu_table.asp";
								<% End If%>
								obj.f_ntitle.value = "<%=f_ntitle%>";
								obj.acton.value = "EDIT";
								obj.submit();
							}else if ( str == "SAVE_ADD" || str == "SAVE_EDIT") {
								if ( trim(obj.f_mname.value) == "" ) {
									alert("項目名稱不可空白");
									obj.f_mname.focus();
									return false;
								}else{
									obj.submit();
								}
							}else if ( str == "SAVE_DEL"){
								if (confirm("確定刪除嗎?")){
									obj.submit();
								}else{
									return false;
								}
							}else if ( str == "ADD"){
								obj.action = "menu_table.asp";
								obj.f_rid.value = <%=f_mid%>;
								obj.submit();
							}else if ( str == "EDIT"){
								obj.action = "menu_table.asp";
								obj.submit();
							}else if ( str == "Lock" || str == "onLock" || str == "EDIT_ORDER"){
								obj.f_rid.value = <%=f_mid%>;
								obj.submit();
							}else{
								obj.submit();
							}
						}
					//-->
					</Script>
					<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" bgcolor="#EEFAFF">
					  <tr> 
						<td>&nbsp;&nbsp;<font color="#999999">&lt;&lt;</font> <a href="javascript:cf(<%=f_rid%>,'BACK');" class="lm">Previous</a></td>
						<td align="right">&nbsp;</td>
					  </tr>
					</table>
					<form name="nform" method="post" action="menu_save.asp">
					<input type="hidden" name="acton" value="<%=acton%>">
					<input type="hidden" name="f_fid" value="<%=f_fid%>">
					<input type="hidden" name="f_rid" value="<%=f_rid%>">
					<input type="hidden" name="f_mid" value="<%=f_mid%>">
					<input type="hidden" name="f_title" value="<%=f_title%>">
					<input type="hidden" name="f_ntitle" value="<%=f_mtitle%>">
					  <table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr> 
						  <td align="center" valign="top"> 
							<table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#CCCCCC">
                            <tr> 
                              <td width="20%" align="center" class="table-table">Type</td>
                              <td colspan="3"><font color="#000000"> 
                                <%=array_mtype_name(f_mtype)%>
                                <input type="hidden" name="f_mtype" value="<%=f_mtype%>">
                                <% = f_ntitle %>
                                </font> </td>
                            </tr>
                            <tr> 
                              <td align="center" class="table-table"><font color="#34699E">&nbsp;</font>ID</td>
                              <td>
							  <% If acton <> "SAVE_ADD" Then %>
							  <%=f_mid%>
							  <% Else %>
							  <%="&nbsp"%>
							  <% End If%>
							  </td>
                              <td align="center" class="table-table">Open State </td>
                              <td><input type="radio" name="f_mopen" value="Y" <% If f_mopen ="Y" then %>checked<%End IF%>>
                                Open 
                                <input type="radio" name="f_mopen" value="N"  <% If f_mopen ="N" then %>checked<%End IF%>>
                                Close </td>
                            </tr>
                            <tr> 
                              <td width="20%" align="center" class="table-table"><font color="#FF0000">*</font><font color="#34699E">&nbsp;</font>Name</td>
                              <td width="35%"><input name="f_mname" type="text" class="input-table" value="<%=Server.HTMLEncode(f_mname)%>" size="20" maxlength="100"></td>
                              <td width="20%" align="center" class="table-table">Default</td>
                              <td width="25%"><textarea name="f_mdefault" cols="20" rows="2" class="textarea-table"><%=Server.HTMLEncode(f_mdefault)%></textarea></td>
                            </tr>
                            <tr> 
                              <td align="center" class="table-table">Picture</td>
                              <td><input name="f_mpic" type="text" size="10" class="input-table" onclick="FileView('<%=default_menu_pic_path%>','<%=f_mpic%>');" value="<%=f_mpic%>" readonly> 
                                &nbsp;&nbsp; 
                                <% if f_mpic = "" Then %>
                                <input type="button" name="b_upload" value="Upload" onclick="FileWin('nform.f_mpic','ADD',nform.f_mpic.value,'<%=default_menu_pic_path%>','<%=default_menu_pic_name%>');"> 
                                <% Else %>
                                <input type="button" name="b_upload" value="Edit" onclick="FileWin('nform.f_mpic','EDIT','<%=f_mpic%>','<%=default_menu_pic_path%>','<%=default_menu_pic_name%>');"> 
                                <input type="button" name="b_cancel" value="Del" onclick="nform.f_mpic.value='';"> 
                                <% End If%>
                              </td>
                              <td align="center" class="table-table">Memo</td>
                              <td><input name="f_mmemo" type="text" class="input-table" value="<%=Server.HTMLEncode(f_mmemo)%>" size="20" maxlength="50"></td>
                            </tr>
                          </table>
							<br> 
							<table width="100%" border="0">
							  <tr> 
								<td align="center"> &nbsp; &nbsp; <input type="button" value="SAVE" class="input-button" onclick="cf(<%=f_mid%>,'<%=acton%>');"> 
								  &nbsp; &nbsp; <input type="button" value="DEL" class="input-button" onclick="cf(<%=f_mid%>,'SAVE_DEL');"> 
								  &nbsp; &nbsp; </td>
							  </tr>
							</table>
							<br>
							<% If f_mid <> 0 and acton = "SAVE_EDIT" Then %>
							<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0">
							  <tr> 
								<td bgcolor="#006666" height="1"></td>
							  </tr>
							  <tr> 
								<td  height="5"></td>
							  </tr>
							  <tr>
								<td>
								   <table width="100%" border="0" cellpadding="5" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#CCCCCC" bgcolor="#EEFAFF">
                                  <tr> 
                                    <td align="right">
									[<a href="JavaScript:cf(<%=f_mid%>,'EDIT_ORDER');" title="Edit Order"><img src="../images/folder.gif" alt="Edit" width="19" height="18" border="0" align="absmiddle" style="cursor:hand">Edit
								    Order</a> ]
									[ <a href="JavaScript:cf(<%=f_mid%>,'ADD');" title="Add"><img src="../images/folder_new.gif" width="19" height="18" border="0" align="absmiddle">Add</a> 
                                      ]&nbsp;</td>
                                  </tr>
                                </table>
								</td>
							  </tr>
							</table>
							 
							<% if rs.recordcount > 1 then %>
							<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#6699CC">
							  <tr align="center"> 
								<td width="10%" bgcolor="#336699"><font color="#FFFFFF">ID</font></td>
								<td width="10%" bgcolor="#336699"><font color="#FFFFFF">Order</font></td>
								<td width="30%" bgcolor="#336699"><font color="#FFFFFF">Name</font></td>
								<td width="20%" bgcolor="#336699"><font color="#FFFFFF">Default</font></td>
								<td width="15%" bgcolor="#336699"><font color="#FFFFFF">Picture</font></td>
								<td width="5%" bgcolor="#336699"><font color="#FFFFFF">Open</font></td>
								<td width="10%" colspan="3" bgcolor="#336699"><font color="#FFFFFF">Function</font></td>
							  </tr>
							  <%
							  	count = 0 
							  	while not rs.eof 
							  		count = count + 1
									if count <> 1 then  
										show_id 		=	rs("Menu_ID")
										show_Name		=	rs("Menu_Name")
										show_Order		=	rs("Menu_Order")
										show_default	=	rs("Menu_Default")
										show_pic		=	rs("Menu_Pic")
										show_access		=	rs("Menu_Access")
										If (show_default="" or isnull(show_default)) Then show_default = "&nbsp;"
										If (show_pic="" or isnull(show_pic)) Then 
											show_pic = "&nbsp;"
										Else
											show_pic = "<img src=""" & default_menu_pic_path & "/" & show_pic & """>"
										End If
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
								<td width="10%" align="center"><%=show_id%></td>
								<td width="10%" align="center">
						  			<input type="hidden" name="f_order_id" value="<%=show_id%>">
						  			<input type="text" value="<%=show_order%>" name="f_order_<%=show_id%>" size="2" maxlength="2" class="input-table" style="width:20px;text-align:right">
								</td>
								<td width="30%" align="center"><%=show_Name%></td>
	                            <td width="20%" align="center"><%=show_default%></td>
					            <td width="15%" align="center"><%=show_pic%></td>
								<td width="5%" align="center"><%=show_access%></td>
								<td width="5%" align="center"><img src="../images/folder.gif" width="19" height="18" onclick="JavaScript:cf(<%=show_id%>,'EDIT');" style="cursor:hand" alt="Edit"></td>
								<td width="5%" align="center"><img src="../images/<%=lock_img%>" width="19" height="18" onclick="JavaScript:cf(<%=show_id%>,'<%=lock_type%>');" style="cursor:hand" alt="<%=lock_alt%>"></td>
							  </tr>
							  <% 
							  		end if
							  	 rs.movenext
							   wend
							  %>
							</table>
							<%
							rs.close						
							Set rs = nothing
							conn.close
							Set conn = nothing
							%>
							<% End If%>
							<% End If%>
							</td>
						</tr>
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
