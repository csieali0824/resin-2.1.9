<!--20161107,新增PRD外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<title>外包PO單價-核淮</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit()
{
	var ACTIONID = document.MYFORM.ACTIONID.value;
	if (ACTIONID == "--" || ACTIONID == null || ACTIONID == "" || ACTIONID=="null")
	{
		alert("請選擇執行動作!");
		document.MYFORM.ACTIONID.focus();
		return false;
	}
	
	if (ACTIONID =="004" && (document.MYFORM.REMARKS.value==null || document.MYFORM.REMARKS.value =="" || document.MYFORM.REMARKS.value=="null"))
	{
		alert("請輸入退件原因!");
		document.MYFORM.REMARKS.focus();
		return false;
	}

	if (ACTIONID =="003")
	{	
		if (confirm("您確定要核淮此申請單嗎?"))
		{
			document.MYFORM.Submit1.disabled=true;	
			document.getElementById("alpha").style.width="100"+"%";
			document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
			document.getElementById("showimage").style.visibility = '';
			document.getElementById("blockDiv").style.display = '';
			document.MYFORM.action="../jsp/TSCPMDQuotationProcess.jsp?ACTIONID="+ACTIONID+"&THISWKFLOW="+document.MYFORM.THISWKFLOW.value+"&REQUESTNO="+document.MYFORM.REQUESTNO.value;
			document.MYFORM.submit();
		}
	}
	else
	{
		document.MYFORM.Submit1.disabled=true;	
		document.getElementById("alpha").style.width="100"+"%";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.MYFORM.action="../jsp/TSCPMDQuotationProcess.jsp?ACTIONID="+ACTIONID+"&THISWKFLOW="+document.MYFORM.THISWKFLOW.value+"&REQUESTNO="+document.MYFORM.REQUESTNO.value;
		document.MYFORM.submit();
	}
}
/*
function subAction()
{
	if (document.MYFORM.ACTIONID.value=="004")
	{
		document.MYFORM.approvemark.value="";
		document.MYFORM.reason.style.visibility="visible";
		document.MYFORM.approvemark.style.visibility="visible";
	}
	else
	{
		document.MYFORM.approvemark.value="";
		document.MYFORM.reason.style.visibility="hidden";
		document.MYFORM.approvemark.style.visibility="hidden";
	}
}
*/
function subWindowHistory(ITEMID,ITEMNAME,ITEMDESC,REQUESTNO,STARTQTY,ENDQTY)
{
	subWin=window.open("../jsp/TSCPMDQuotationHistory.jsp?ITEMID="+ITEMID+"&ITEMNAME="+ITEMNAME+"&ITEMDESC="+ITEMDESC+"&REQUESTNO="+REQUESTNO+"&STARTQTY="+STARTQTY+"&ENDQTY="+ENDQTY,"subwin","width=850,height=480,scrollbars=yes,menubar=no,location=no");
}

</script>
<STYLE TYPE='text/css'> 
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:center}
 .style4   {font-family:Arial; font-size:12px; background-color:#C2C6D6; text-align:center;color: #000000;}
 .style1   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:left}
 .style2   {font-family:Arial; font-size:12px; background-color:#9999CC; text-align:left; color: #000000;}
 .style7   {font-family:Arial; font-size:12px; background-color:#C2C6D6; text-align:left; color: #000000;}
 .style5   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:right}
 .style6   {font-family:Arial; font-size:12px;	background-color:#D8DEA9; text-align:right;color: #000000;}
 </STYLE>
</head>
<body>
<%
String REQUESTNO = request.getParameter("REQUESTNO");
String REMARKS = request.getParameter("REMARKS");
if ( REMARKS ==null)  REMARKS="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String THISWKFLOW = request.getParameter("THISWKFLOW");
if (THISWKFLOW==null) THISWKFLOW="";
String ITEMID="",ITEMNAME="",ITEMDESC="",PRICE="",PREPRICE="",PERCENTAGE="",STARTQTY="",ENDQTY="",REASON="",isExists="N",rowcnt="",UOM="",TSC_PROD_GROUP="";
try
{
	String sql = " SELECT a.vendor_code, a.vendor_name, a.vendor_site,a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.created_by_name, to_char(a.approve_date,'yyyy-mm-dd hh24:mi') approve_date, a.approved_by_name"+
				 " ,STATUS,decode(STATUS,'Submit','待核淮','Approved','已核淮','Reject','退件',STATUS) STATUSCODE,NEXT_WKFLOW "+
				 " from oraddman.tspmd_quotation_headers_all a where a.request_no='"+REQUESTNO+"' and NEXT_WKFLOW ='"+THISWKFLOW+"'";

	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		STATUS = rs.getString("STATUS");
		isExists ="Y";
%>
<form name="MYFORM"  METHOD="post" >
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
 <font color="#000000" size="+2" face="標楷體"> <strong>外包PO單價-核淮</strong></font>
<br>
<A HREF="../jsp/TSCPMDQuotationConfirmList.jsp"><font style="font-size:14px;font-family:'細明體'">回待核淮查詢畫面</font></A>&nbsp;&nbsp;&nbsp;
<table width="90%">
	<tr>
		<td height="153">
			<table width="100%" border="1" align="left" cellpadding="1" cellspacing="0"  bordercolorlight="#FFFFFF"  bordercolordark="#C2C6D6">
				<tr>
					<td height="26" colspan="10" class="style2">廠商資訊：</td>
				</tr>
				<tr>
					<td width="7%" height="33"  class="style7">申請單號:</td>
					<td width="10%" class="style1"><font style="font-size:16px;color:#0000CC;"><strong><%=REQUESTNO%></strong></font><input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>"></td> 	
					<td width="7%"  class="style7">廠商名稱:</td>
					<td width="22%" class="style1"><font color="#0000CC"><%="("+rs.getString("vendor_code")+") "+rs.getString("vendor_name")%></font></td> 	
					<td width="7%"  class="style7">Site:</td>
					<td width="12%" class="style1"><%=rs.getString("vendor_site")%></td>
					<td width="7%"  class="style7">幣別:</td>
					<td width="7%" class="style1"><%=rs.getString("currency_code")%></td> 
				</tr>   
				<tr>
					<td height="27" colspan="10" class="style2" >申請明細：</td>
				</tr>
				<TR>
					<td colspan="10">
						<table width="100%" cellspacing="0" bor bordercolordark="#C2C6D6"  border="1">
							<tr>
								<td class="style4" width="3%" height="29">項次</td>
								<td class="style4" width="8%">TSC Prod Group</td>
								<td class="style4" width="13%">料號</td>
								<td class="style4" width="11%">品名</td>
								<td class="style4" width="7%">起始訂單量(>)</td>
								<td class="style4" width="7%">起束訂單量(<=)</td>
								<td class="style4" width="6%">數量單位</td>
								<td class="style4" width="7%">單價</td>
								<td class="style4" width="6%">前次單價</td>
								<td class="style4" width="5%">差異比(%)</td>
								<td class="style4" width="13%">異動原因</td>
								<td class="style4" width="3%">歷程</td>
							</tr>
							<% 
							sql = " SELECT a.inventory_item_id,a.inventory_item_name, a.item_description,"+
							      " (select count(1) from oraddman.tspmd_quotation_lines_all b where b.request_no = a.request_no and b.inventory_item_id = a.inventory_item_id) rowcnt,"+
							      " a.unit_price,a.previous_price, a.start_date, a.end_date,a.request_reason,"+
								  " decode(previous_price,0,0,round((unit_price-previous_price)/previous_price*100,2)) percentage,"+
								  " nvl(a.start_qty,0) start_qty,nvl(a.end_qty,0) end_qty,a.uom"+
								  " ,a.organization_id,a.tsc_prod_group"+ //add by Peggy 20161110
								  " FROM oraddman.tspmd_quotation_lines_all a"+
								  " WHERE  a.request_no='"+ REQUESTNO+"' ORDER BY a.inventory_item_name,a.start_qty";
							Statement statementd=con.createStatement();
							ResultSet rsd=statementd.executeQuery(sql);
							int i =0;
							String str_color="";
							while (rsd.next())				
							{
								PRICE=rsd.getString("unit_price");
								PREPRICE=rsd.getString("previous_price");
								STARTQTY=rsd.getString("start_qty");
								ENDQTY=rsd.getString("end_qty");
								REASON=rsd.getString("request_reason");
								UOM=rsd.getString("UOM");
								PERCENTAGE=rsd.getString("percentage");
								i++;
								out.println("<tr>");
								out.println("<TD class='style3'>"+i+"</td>");
								if (!ITEMID.equals(rsd.getString("inventory_item_id")))
								{
									TSC_PROD_GROUP=rsd.getString("tsc_prod_group");
									ITEMID=rsd.getString("inventory_item_id");
									ITEMNAME=rsd.getString("inventory_item_name");
									ITEMDESC=rsd.getString("item_description");
									rowcnt=rsd.getString("rowcnt");

									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+TSC_PROD_GROUP+"</td>");
									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+ITEMNAME+"</td>");
									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+ITEMDESC+"</td>");
								}
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(STARTQTY))+"&nbsp;</td>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(ENDQTY))+"&nbsp;</td>");
								out.println("<TD class='style3'>"+UOM+"</td>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PRICE))+"&nbsp;</TD>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PREPRICE))+"&nbsp;</td>");
								if (Float.parseFloat(PERCENTAGE) <0)
								{
									str_color = "#0000FF";
								}
								else if (Float.parseFloat(PERCENTAGE) >0)
								{
									str_color = "#FF0000";
								}
								else
								{
									str_color = "#000000";
								}
								out.println("<TD class='style5'><strong><font style='color:"+str_color+"'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PERCENTAGE))+"&nbsp;</font></strong></td>");
								out.println("<TD class='style1'>&nbsp;"+((REASON==null || REASON.equals("null"))?"&nbsp;":REASON)+"</td>");
								out.println("<TD class='style3'><IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='subWindowHistory("+'"'+ITEMID+'"'+","+'"'+ITEMNAME+'"'+","+'"'+ITEMDESC+'"'+","+'"'+REQUESTNO+'"'+","+'"'+STARTQTY+'"'+","+'"'+ENDQTY+'"'+")'></td>");
								out.println("</tr>");
							}
							rsd.close();
							statementd.close();
							%>
						</table>	  
				  </TD>
				</TR>
				<tr>
					<TD height="21" colspan="10" class="style2">&nbsp;</td>
				</tr>
				<TR>
					<td width="15%" class="style7">附件明細</td>
					<td colspan="9">
					<%
					String rootName = "/jsp/PMD_Attache/"+REQUESTNO;
					String rootPath = application.getRealPath(rootName);
					File fp = new File(rootPath);
					if (fp.exists()) 
					{  
						String[] list = fp.list();
						for(int j=0; j<list.length;j++)
						{
							File inFp = new File(rootPath + File.separator + list[j]);
							out.println("&nbsp;<img src='images/pdf.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+ list[j]+"' target='_blank'>"+list[j]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font><br>");
						}
						if (list.length==0) out.println("&nbsp;<br>&nbsp;");
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
					%>
					</td>
				</TR>
				<tr>
					<td width="10%" class="style7">備註說明:</td>
					<td colspan="9"><textarea cols="180" rows="4"  name="REMARKS" style="font-family:ARIAL"><%=REMARKS%></textarea></td>
				</tr>
				<tr>
					<td width="10%" class="style7"><strong><jsp:getProperty name="rPH" property="pgAction"/>=></strong></td>
					<TD colspan="9">						
					<%
					try
					{    
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery("SELECT a.type_no, a.type_name  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE='F2-002'  AND a.status_flag='A' AND a.type_no<>'005'");
						comboBoxBean.setRs(rs1);
						comboBoxBean.setFieldName("ACTIONID");	   
						//comboBoxBean.setOnChangeJS("subAction()");	   
						out.println(comboBoxBean.getRsString());
						rs1.close();       
						statement1.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception1:"+e.getMessage());
					}
					%>
						<INPUT TYPE="button" tabindex='41' value='Submit' name="Submit1" onClick='setSubmit();' style="font-family:arial"></font>
					</TD>
				</tr>
			</table>
	  </td>
	</tr>
	<%
		sql = " SELECT  a.action_name,c.type_name action_desc, to_char(a.action_date,'yyyy-mm-dd hh24:mi:ss')  action_date,a.actor, a.remark "+
		      " FROM oraddman.tspmd_action_history a"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE ='F2_ACTION') b"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE like 'F2-%') c"+
		      " where a.request_no ='" + REQUESTNO+"' and a.ACTION_NAME = b.type_name and b.type_no = c.type_no order by a.action_date";
		Statement statementa=con.createStatement();
		ResultSet rsa=statementa.executeQuery(sql);
		int cnt =0;
		while (rsa.next())
		{
			if (cnt ==0)
			{
				out.println("<tr><td>&nbsp;</td></tr>");
				out.println("<tr><td>");
				out.println("<table width='100%' border='1' cellpadding='1' cellspacing='0'  bordercolorlight='#FFFFFF'  bordercolordark='#C2C6D6'>");
				out.println("<tr>");
				out.println("<td height='26' colspan='8' class='style2'>申請歷程：</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='style4' width='5%'>序號</td>");
				out.println("<td class='style4' width='20%'>交易名稱</td>");
				out.println("<td class='style4' width='20%'>交易日期</td>");
				out.println("<td class='style4' width='20%'>交易人員</td>");
				out.println("<td class='style4' width='35%'>備註說明</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td class='style3'>"+(cnt+1)+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_desc")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_date")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("actor")+"</td>");
			out.println("<td class='style3'>"+((rsa.getString("remark")==null || rsa.getString("remark").equals(""))?"&nbsp;":rsa.getString("remark"))+"</td>");
			out.println("</tr>");
			cnt ++;
		}
		if (cnt >0)
		{
			out.println("</table></td></tr>");
		}
		rsa.close();
		statementa.close();

	%>
</table>
<%
	}
	rs.close();
	statement.close();
	
	if (isExists.equals("N"))
	{
%>
		<script language="javascript">
			alert("此申請單不在待核淮名單內,請重新確認,謝謝!");
			document.location.href="../jsp/TSCPMDQuotationConfirmList.jsp";
		</script>
<%
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());	
}
%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<input type="hidden" name="THISWKFLOW" value="<%=THISWKFLOW%>">
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
</html>
