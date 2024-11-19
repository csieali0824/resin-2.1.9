    <Script Language="javaScript">
	<!--
		function menu_cbg(obj){
			obj.style.backgroundColor='#036876';
			obj.style.color='#FFFFFF';
			obj.style.cursor="hand";
		}
		function menu_bbg(obj){
			obj.style.backgroundColor='';
			obj.style.color='#000000';
			obj.style.cursor="hand";
		}
		function menu_change(str){
			self.location.href=str;
		}
	//-->
	</Script>
<td width="150" bgcolor="#E6F1F2">
	<table width="150" height="10" border="0" cellpadding="0" cellspacing="0" bgcolor="#32659C" rules="none">
      <tr>
        <td height="10"  bgcolor="#FFFFFF"></td>
      </tr>
    </table>
	<table width="150" height="100%" border="1" cellpadding="0" cellspacing="0" class="menu_table" bordercolor="#FFFFFF" bordercolorlight="#CCCCCC" rules="none">
        <tr> 
          <td width="20" height="25" bgcolor="#CDE4E7"><img src="<%=admin_web_path%>/images/table.gif" width="16" height="16"></td>
          <td width="136" height="25" bgcolor="#CDE4E7"> News Manage</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" bgcolor="#C2DEE0"></td>
        </tr>
        <tr class="menu" onMouseOver="menu_cbg(this);" onMouseOut="menu_bbg(this);" onclick="menu_change('<%=admin_web_path%>/news/news_list.asp');"> 
          <td width="20" height="25" align="right"></td>
          <td height="25"><img src="<%=admin_web_path%>/images/homeaw02.gif" width="11" height="13" border="0">&nbsp;&nbsp;All 
            News</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
        </tr>
	   <tr> 
          <td height="1" colspan="2" bgcolor="#A3CED3"></td>
        </tr>
        <tr bgcolor="#CDE4E7"> 
          <td width="20" height="25"><img src="<%=admin_web_path%>/images/table.gif" width="16" height="16"></td>
          <td width="136" height="25"> Product Manage</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" bgcolor="#A3CED3"></td>
        </tr>
        <tr class="menu" onMouseOver="menu_cbg(this);" onMouseOut="menu_bbg(this);" onclick="menu_change('<%=admin_web_path%>/products/products_list.asp?ptype=0');"> 
          <td width="20" height="25" align="right">&nbsp;</td>
          <td height="25"> <img src="<%=admin_web_path%>/images/homeaw02.gif" width="11" height="13">&nbsp;&nbsp;Telephone</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
        </tr>
		 <tr class="menu" onMouseOver="menu_cbg(this);" onMouseOut="menu_bbg(this);" onclick="menu_change('<%=admin_web_path%>/products/products_list.asp?ptype=1');"> 
          <td width="20" height="25" align="right">&nbsp;</td>
          <td height="25"> <img src="<%=admin_web_path%>/images/homeaw02.gif" width="11" height="13">&nbsp;&nbsp;DBTEL</td>
        </tr>
        <tr> 
          <td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
        </tr>
		 <tr class="menu" onMouseOver="menu_cbg(this);" onMouseOut="menu_bbg(this);" onclick="menu_change('<%=admin_web_path%>/products/products_list.asp?ptype=2');"> 
          <td width="20" height="25" align="right">&nbsp;</td>
          <td height="25"><img src="<%=admin_web_path%>/images/homeaw02.gif" width="11" height="13">&nbsp; 
            Dbtel International </td>
        </tr>
        <tr> 
          <td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
        </tr>
	  <tr> 
		<td height="1" colspan="2" bgcolor="#A3CED3"></td>
	  </tr>
	  <tr bgcolor="#CDE4E7"> 
		<td width="20" height="25"><img src="<%=admin_web_path%>/images/table.gif" width="16" height="16"></td>
		<td width="136" height="25"> System Manage</td>
	  </tr>
	  <tr> 
		<td height="1" colspan="2" bgcolor="#A3CED3"></td>
	  </tr>
	  <tr> 
		<td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
	  </tr>
	  <tr class="menu" onMouseOver="menu_cbg(this);" onMouseOut="menu_bbg(this);" onclick="menu_change('<%=admin_web_path%>/system/menu_list.asp');"> 
		<td width="20" height="25" align="right">&nbsp;</td>
		<td height="25"><img src="<%=admin_web_path%>/images/homeaw02.gif" width="11" height="13">&nbsp; 
		  Menu Setting</td>
	  </tr>
	  <tr> 
		<td height="1" colspan="2" align="right" bgcolor="#C2DEE0"></td>
	  </tr>
	  <tr><td colspan="2">&nbsp;</td></tr>
	 <tr><td height="10" colspan="2" bgcolor="#CCCCCC"></td></tr>
	</table>
</td>
