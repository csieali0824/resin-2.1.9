<!--20170628 Peggy,點測工單在發料前指定入庫交易-->
<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	if (document.MYFORM.PICK_NO.value =="" || document.MYFORM.PICK_NO.value =="--")
	{
		alert("請選擇撿貨單號!!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit2(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	if (document.MYFORM.STATUS.value =="" || document.MYFORM.STATUS.value =="--")
	{
		alert("請選擇執行動作!");
		document.MYFORM.STATUS.focus();
		return false;
	}	
	if (document.MYFORM.STATUS.value=="CANCELLED")
	{
		if (confirm("您確定要取消撿貨資料嗎?")==false) 
		{	
			return false;
		}
	}
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i].checked;
			lineid = document.MYFORM.chk[i].value;
		}
		if (chkvalue==true)
		{ 
			 //if ((parseFloat(document.MYFORM.elements["TOT_REQ_QTY_"+lineid].value) > parseFloat(document.MYFORM.elements["TOT_PICK_QTY_"+lineid].value)) || (parseFloat(document.MYFORM.elements["TOT_PICK_QTY_"+lineid].value)-parseFloat(document.MYFORM.elements["TOT_REQ_QTY_"+lineid].value)) > parseFloat(document.MYFORM.elements["MOQ_"+lineid].value))
			 //{
			 //	if (document.MYFORM.elements["COMP_TYPE_NO_"+lineid].value!="C008")
			//	{
			//		alert("料號:"+document.MYFORM.elements["ITEM_NAME_"+lineid].value+"發料數量異常,請確認!!");
			//		return false;
			//	}
			// }
			if (document.MYFORM.STATUS.value=="PICKED")
			{
				if (document.MYFORM.elements["REQUEST_TYPE_"+i].value !="MISC" && document.MYFORM.elements["REQUEST_TYPE_"+i].value !="RDMISC" && document.MYFORM.elements["REQUEST_TYPE_"+i].value !="QCMISC")
				{
					if (parseFloat(document.MYFORM.elements["PICK_QTY_"+i].value)<=0)
					{
						alert("工單號:"+document.MYFORM.elements["WIP_NO_"+i].value+" 型號:"+document.MYFORM.elements["ITEM_NAME_"+i].value+" 無庫存,不允許確認!!");
						return false;
					}
					else if (document.MYFORM.elements["COMP_TYPE_NO_"+i].value=="C001" && document.MYFORM.elements["PICK_ERR"+i].value=="Y")
					{
						alert("工單號:"+document.MYFORM.elements["WIP_NO_"+i].value+" 型號:"+document.MYFORM.elements["ITEM_NAME_"+i].value+" 庫存不足,不允許確認!!");
						return false;
					}
				}
			}
			chkcnt ++;				
		}
	}
	if (chkcnt <=0)
	{
		alert("請勾選資料!");
		return false;
	}		
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit3(URL)
{
	document.MYFORM.submit1.disabled= true;
	//document.MYFORM.action=URL;
	//document.MYFORM.submit();	
	subWin=window.open(URL,"subwin","left=200,width=700,height=400,scrollbars=yes,menubar=no");
}
function setOPTValue()
{
	if (document.MYFORM.STATUS.value=="CANCELLED")
	{
		document.getElementById("span2").style.visibility ="visible";
		document.MYFORM.REJ_REASON.value="";
	}
	else
	{
		document.getElementById("span1").style.visibility ="hidden";
		document.MYFORM.REJ_REASON.value="";
	}
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(0);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#DCF5EC";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function SetERPTrans(request_no,line_no,qty)
{
	subWin=window.open("../jsp/TSA01WIPComponentMISC.jsp?REQUEST_NO="+request_no+"&LINE_NO="+line_no+"&NUMQ="+qty,"subwin","width=800,height=400,scrollbars=yes,menubar=no");  
}

</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline; font-size: 12px  }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TSA01 Pick Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sql = "";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null || PICK_NO.equals("--")) PICK_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String COMPONENT_NAME = request.getParameter("COMPONENT_NAME");
if (COMPONENT_NAME==null) COMPONENT_NAME="";
String ERPUSERID="";
String strdetail="",err_msg="";
double tot_pick_qty=0;
int err_cnt=0;
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSA01WIPWareHousePick.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">A01倉庫撿貨確認</font></strong>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#E4F0F1">
	<tr>
		<td width="10%"><font color="#666600">撿貨單號:</font></td>
		<td width="15%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("select PICK_NO,PICK_NO PICK_NO1 from oraddman.tsa01_request_lines_all a where status='CONFIRMED' group by PICK_NO order by PICK_NO ");
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(PICK_NO);
			comboBoxBean.setFieldName("PICK_NO");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} //end of try		 
		catch (Exception e) 
		{ 
			//out.println("Exception:"+e.getMessage()); 
		} 
		%>		
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">工單號碼:</font></td>
		<td width="15%"><input type="text" name="WIP_NO"  style="font-family: Tahoma,Georgia;" value="<%=WIP_NO%>"></td>
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">原物料號:</font></td>
		<td width="40%"><input type="text" name="COMPONENT_NAME"  style="font-family: Tahoma,Georgia;" value="<%=COMPONENT_NAME%>">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit2("../jsp/TSA01WIPWareHousePick.jsp")' > 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value="撿貨單" onClick='setSubmit("../jsp/TSA01WIPWareHousePickExcel.jsp")' > 
		</td>
	</tr>
</table> 
<hr>
<%
try
{
	sql = " SELECT a.request_no"+
		  ", a.request_type"+
		  ", g.organization_code"+
		  ", a.organization_id"+
		  ", a.wip_entity_name"+
		  ", a.wip_entity_id"+
		  ", a.inventory_item_id"+
		  ", a.item_name"+
		  ", a.tsc_package"+
		  ", a.created_by"+
		  ", to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
		  ", a.last_updated_by"+
		  ", to_char(a.last_update_date,'yyyy-mm-dd') last_update_date"+
		  ", nvl(d.TYPE_VALUE ,a.status) status"+
		  ", a.version_id"+
		  ", e.PICK_NO"+
		  ", c.TYPE_NAME"+
		  ", b.description component_item_desc"+
		  ", e.line_no"+
		  ", e.comp_type_no"+
		  ", f.comp_type_name"+
		  ", e.component_item_id"+
		  ", e.component_name"+
		  ", e.uom"+
		  ", e.request_qty"+
		  ", e.remarks"+
		  ",(select listagg(k.LOT ||'  ' ||K.LOT_QTY||K.UOM ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'\n') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
		  "   where e.request_no=k.request_no"+
		  "   and e.line_no=k.line_no) lot_list"+
		  " ,(SELECT COUNT(1) FROM  oraddman.tsa01_request_wafer_lot_all k WHERE e.request_no = k.request_no AND e.line_no = k.line_no) lot_cnt"+
		  " ,nvl((select sum(lot_qty) from oraddman.tsa01_request_line_lots_all x where x.request_no=e.request_no and x.line_no=e.line_no),0) lot_qty"+
		  " ,nvl((SELECT distinct MISCELLANEOUS_FLAG FROM  oraddman.tsa01_request_wafer_lot_all k WHERE e.request_no = k.request_no AND e.line_no = k.line_no and NVL(k.MISCELLANEOUS_FLAG,'N')='Y'),'N') MISCELLANEOUS_FLAG"+
		  " FROM oraddman.tsa01_request_headers_all a"+
		  " ,inv.mtl_system_items_b b"+
		  " ,(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
		  " ,(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
		  " ,oraddman.tsa01_request_lines_all e"+
		  " ,oraddman.tsa01_component_type f"+
		  " ,mtl_parameters g"+
		  " where e.organization_id=b.organization_id "+
		  " and e.component_item_id=b.inventory_item_id "+
		  " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
		  " and a.status=d.TYPE_NAME(+)"+
		  " and a.request_no=e.request_no(+)"+
		  " and e.COMP_TYPE_NO=f.COMP_TYPE_NO(+)"+
		  " and a.organization_id=g.organization_id(+)"+
		  " and e.status=?";
	if (!PICK_NO.equals(""))
	{
		sql += " and e.pick_no='"+ PICK_NO+"'";
	}
	if (!WIP_NO.equals(""))
	{
		sql += " and upper(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	}
	if (!COMPONENT_NAME.equals("") && !COMPONENT_NAME.equals("--"))
	{
		sql += " and e.COMPONENT_NAME LIKE '"+ COMPONENT_NAME+"%'";
	}	
	sql += " order by a.wip_entity_name,a.request_no,e.LINE_NO";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"CONFIRMED");
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	String strColor="",pick_err=""; 
	while (rs.next())
	{		
		if (icnt ==0)
		{
	%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr bgcolor="#B7CEC9" style="font-family:'細明體';font-size:12px" align="center">
					<td width="3%"><input type="checkbox" name="chkall" value="Y"  onClick="checkall()"></td>
					<td width="7%">撿貨單號</td>
					<td width="6%">領料單號</td>
					<td width="6%">交易類型</td>
					<td width="8%">工單號碼</td>
					<td width="8%">類別</td>
					<td width="12%">原物料名稱</td>
					<td width="23%">品名</td>
					<td width="6%">領用數量</td>
					<td width="6%">撿貨數量</td>
					<td width="5%">單位</td>
					<td width="4%">入庫明細</td>
					<td width="6%">LOT明細</td>
				</tr>
	<%		
		}
						
			//if ((rs.getFloat("tot_request_qty") > rs.getFloat("tot_pick_qty")) || (rs.getFloat("tot_pick_qty") -rs.getFloat("tot_request_qty")) > rs.getFloat("moq"))
			//{
			//	strColor ="color:#ff0000;font-weight:bold;";
			//	if (!rs.getString("comp_type_no").equals("C008"))  //半成品不管庫存
			//	{
			//		//err_cnt ++;
			//	}
			//	if (err_msg.length()>0) err_msg+="<br>";
			//	err_msg +="料號:"+rs.getString("ITEM_NAME")+" 撿貨數量異常";
			//}
			if (rs.getFloat("REQUEST_QTY") > rs.getFloat("lot_qty"))
			{
				strColor="color:#FF0000;font-weight:bold;";
				pick_err="Y";
			}
			else
			{
				strColor ="color:#000000;";
				pick_err="N";
			}
			sql = " SELECT  a.subinventory_code,"+
                  " a.lot_number, a.lot_qty,a.uom,"+
                  " to_char(a.expiration_date,'yyyy-mm-dd') expiration_date,a.transfer_subinventory"+
				  " from oraddman.tsa01_request_line_lots_all a"+
                  " where a.request_no=? "+
				  " and a.line_no=?"+
                  " order by a.lot_number,to_char(a.expiration_date,'yyyy-mm-dd') ";
			//out.println(sql);
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,rs.getString("request_no"));
			statement1.setString(2,rs.getString("line_no"));
			ResultSet rs1=statement1.executeQuery();
			strdetail="";tot_pick_qty=0;
			float pick_qty=0;
			int rowcnt=0;		
			while (rs1.next())
			{	
				if (strdetail.equals(""))
				{
					strdetail ="<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
				}	
				strdetail += "<tr><td>"+rs1.getString("SUBINVENTORY_CODE")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>"+rs1.getString("LOT_NUMBER")+"</td><td align=right>"+Double.valueOf(rs1.getString("LOT_QTY")).doubleValue()+"</td><td align=center>&nbsp;&nbsp;"+rs1.getString("EXPIRATION_DATE")+"</td><td align=center>"+(rs1.getString("transfer_subinventory")==null?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":rs1.getString("transfer_subinventory")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")+"</td></tr>";
				tot_pick_qty +=Double.parseDouble(rs1.getString("LOT_QTY"));
			}	
			if (strdetail.length() >0) strdetail += "<tr><td colspan=5>---------------------------------------------------------------------------------------------------</td></tr><tr><td colspan=3 align=right>Total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+tot_pick_qty+"</td><td>&nbsp;</td></table>";
			//if (strdetail.length() >0) strdetail += "</table>";
			rs1.close();
			statement1.close();
			//out.println(strdetail);
			
	%>
				<tr id="tr_<%=icnt%>">
					<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("request_no")+"_"+rs.getString("line_no")%>" onClick="setCheck('<%=icnt%>')"><INPUT TYPE="hidden" name="PICK_ERR<%=icnt%>" VALUE="<%=pick_err%>"></td>
					<td align="center"><%=rs.getString("pick_no")%></td>
					<td align="center"><%=rs.getString("request_no")%></td>
					<td align="center" <%=rs.getString("request_type").equals("MISC")||rs.getString("request_type").equals("RDMISC") && rs.getString("request_type").equals("QCMISC")?"style='background-color:#CCFF99'":""%>><%=rs.getString("TYPE_NAME")%><input type="hidden" name="REQUEST_TYPE_<%=icnt%>" value="<%=rs.getString("request_type")%>"></td>
					<td align="center"><%=rs.getString("WIP_ENTITY_NAME")%><input type="hidden" name="WIP_NO_<%=icnt%>" value="<%=rs.getString("WIP_ENTITY_NAME")%>"></td>
					<td align="left"><%=rs.getString("comp_type_name")%><input type="hidden" name="COMP_TYPE_NO_<%=icnt%>" value="<%=rs.getString("COMP_TYPE_NO")%>"></td>
					<td align="left"><a onMouseOver="this.T_STICKY=true;this.T_WIDTH=450;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_TITLE='Subinventory&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lot Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Qty&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiration Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transfer Subinv';this.T_OFFSETY=-100;return escape('<%=strdetail%>')"><%=rs.getString("COMPONENT_NAME")%></a><input type="hidden" name="ITEM_NAME_<%=icnt%>" value="<%=rs.getString("COMPONENT_NAME")%>"></td>
					<td align="left" style="font-size:11px"><%=rs.getString("COMPONENT_ITEM_DESC")%></td>
					<td align="right" style="font-size:12px"><%=Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()%><input type="hidden" name="REQUEST_QTY_<%=icnt%>" value="<%=rs.getFloat("REQUEST_QTY")%>"></td>
					<td align="right" style="<%=strColor%>font-size:12px"><%=Double.valueOf(rs.getString("LOT_QTY")).doubleValue()%><input type="hidden" name="PICK_QTY_<%=icnt%>" value="<%=rs.getFloat("LOT_QTY")%>"></td>
					<td align="center"><%=rs.getString("UOM")%></td>
					<td align="center">
					<%
					if (rs.getString("MISCELLANEOUS_FLAG").equals("Y"))
					{
					%>
					<input type="button" name="btn_<%=icnt%>" value="入庫明細" style="font-family:arial;font-size:12px" onClick="SetERPTrans('<%=rs.getString("REQUEST_NO")%>','<%=rs.getString("LINE_NO")%>','<%=rs.getString("LOT_QTY")%>')">
					<%
					}
					else
					{
						out.println("-------");
					}
					%>
					</td>
					<td align="center"><input type="button" name="btn_<%=icnt%>" value="LOT明細" style="font-family:arial;font-size:12px" onClick="setSubmit3('../jsp/TSA01WIPWareHousePickDetail.jsp?REQUEST_NO=<%=rs.getString("REQUEST_NO")%>&LINE_NO=<%=rs.getString("LINE_NO")%>&ACODE=NEW&REQUEST_TYPE=<%=rs.getString("REQUEST_TYPE")%>')"></td>
				</tr>
	<%				
	
			icnt++;
		}
		if (icnt >0)
		{
	%>
			</table>
			<hr>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#E4F0F1">
				<tr>
					<td>
			  <p><font style="font-family:Tahoma,Georgia;font-size:12px">
			  <jsp:getProperty name="rPH" property="pgAction"/>
			  =></font>
			 <%
			try
			{   
				sql = "select distinct a.type_name,a.type_value from oraddman.tsa01_base_setup a where a.type_code='REQ_STATUS' AND TYPE_GROUP='K2-004'"+
				      " order by a.type_value desc";			
				Statement statement2=con.createStatement();
				ResultSet rs2=statement2.executeQuery(sql);
				comboBoxBean.setRs(rs2);
				comboBoxBean.setSelection(STATUS);
				comboBoxBean.setOnChangeJS("setOPTValue()");
				comboBoxBean.setFieldName("STATUS");	
				comboBoxBean.setFontName("Tahoma,Georgia");   
				out.println(comboBoxBean.getRsString());
				rs2.close();   
				statement2.close();      	 
			} 
			catch (Exception e) 
			{ 
				out.println("Exception:"+e.getMessage()); 
			} 	
			%>	
	        <input type="button" name="submit1" value="Submit" style="font-family: Tahoma,Georgia;" onClick='setSubmit1("../jsp/TSA01WIPComponentProcess.jsp?PROGRAM=K2-004")'>
		<span id="span2" style="visibility:hidden;font-size:12px">
			取消原因 =></font>
  <input type="text"  name="REJ_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia;font-size:12px">
            </span> 
					
					</td>
				</tr>
			</table>
	<%
	
		}
		else
		{
			out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
		}
		rs.close();
		statement.close();
	//}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

