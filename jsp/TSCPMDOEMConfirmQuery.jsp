<!-- 20161104 Peggy,新增prd A01外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ArrayComboBoxBean,DateBean,QueryAllRepairBean,ComboBoxBean"%>
<html>
<head>
<title>Query unApprove Request Order List</title>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============以上區段為等待畫面==========-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="queryAllRepairBean" scope="application" class="QueryAllRepairBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<style type="text/css">
BODY        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }

 .style1   {font-family:Arial; font-size:12px; background-color:#D7F4E6; color:#000000; text-align:left;}
</style>
<script language="JavaScript" type="text/JavaScript">
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
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
				setCheck((i+1));
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
	var lineid="";
	document.MYFORM.TXTREJ.value="";
	document.MYFORM.OPEN.style.visibility="hidden";
	document.MYFORM.REJ.style.visibility="hidden";
	document.MYFORM.TXTREJ.style.visibility="hidden";
		
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
		lineid = document.MYFORM.chk[irow-1].value;
		
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked)
			{
				document.MYFORM.TXTREJ.value="";
				document.MYFORM.OPEN.style.visibility="visible";
				document.MYFORM.REJ.style.visibility="visible";
				document.MYFORM.TXTREJ.style.visibility="visible";
				break;			
			}
		}		
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
		
		if (chkflag)
		{
			document.MYFORM.TXTREJ.value="";
			document.MYFORM.OPEN.style.visibility="visible";
			document.MYFORM.REJ.style.visibility="visible";
			document.MYFORM.TXTREJ.style.visibility="visible";		
		}
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#daf1a9";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setOpen(URL)
{
	var reqlist="";
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked)
			{
				if (reqlist.length>0) reqlist=reqlist+",";
				reqlist=reqlist+document.MYFORM.chk[i].value;
			}
		}		
	}
	else
	{
		reqlist= document.MYFORM.chk.value;
	}
	document.MYFORM.REJ.disabled=false;
	document.MYFORM.action=URL+"?REQLIST="+reqlist;	
	document.MYFORM.submit();		
}
function setRej(URL)
{
	if (document.MYFORM.TXTREJ.value=="")
	{
		alert("請輸入退件原因!");
		document.MYFORM.TXTREJ.focus();
		return false;	
	}
	document.MYFORM.REJ.disabled=false;
	document.MYFORM.action=URL+"?ACTYPE=REJ";	
	document.MYFORM.submit();		
}
</script>
<%   
String pageURL=request.getParameter("PAGEURL");
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 20;
String PROD_GROUP=request.getParameter("PROD_GROUP");
if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161106
String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID=""; //add by Peggy 20161106
String sql="",sqlt="";
String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String ITEM_DESC=request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String CREATED_BY=request.getParameter("CREATED_BY");
if (CREATED_BY==null) CREATED_BY="";
String ACTYPE=request.getParameter("ACTYPE");
if (ACTYPE==null) ACTYPE="";
String TXTREJ=request.getParameter("TXTREJ");
if (TXTREJ==null) TXTREJ="";
String REQUESTNO="",VERSIONID="",statuscode="";

if (ACTYPE.equals("REJ"))
{
	String chk[]= request.getParameterValues("chk");
	for (int i=0 ; i<chk.length ; i++)
	{
		REQUESTNO = chk[i].substring(0,chk[i].indexOf("-"));
		VERSIONID = chk[i].substring(chk[i].indexOf("-")+1);
		statuscode = "Reject";
		sql=  " update oraddman.tspmd_oem_headers_all "+
			  " set STATUS = ?"+
			  ",APPROVE_DATE = sysdate"+
			  ",APPROVED_BY =?"+
			  ",APPROVED_BY_NAME =?"+
			  ",APPROVE_REMARK=?"+
			  ",LAST_UPDATE_DATE=sysdate"+
			  ",LAST_UPDATED_BY=?"+
			  ",INV_DATE=TO_CHAR(sysdate,'yyyymmddhh24miss')"+
			  ",INV_BY=CREATED_BY"+
			  " where REQUEST_NO=?"+
			  " and VERSION_ID=?"+
			  " and STATUS in (SELECT a.type_name  FROM oraddman.tspmd_data_type_tbl a  where a.DATA_TYPE='ACTION'  and a.TYPE_NO='002')";
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,statuscode);         //狀態
		pstmt.setString(2,userID);             //approve user
		pstmt.setString(3,UserName);           //approve user name
		pstmt.setString(4,TXTREJ);    //退件原因
		pstmt.setString(5,userID);             //最後異動者
		pstmt.setString(6,REQUESTNO);         //申請單號
		pstmt.setString(7,VERSIONID);  //版次
		if ( pstmt.executeUpdate()>0)
		{
			sql=" INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
				" VALUES(?,?,?,sysdate,?,?)";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,REQUESTNO);         //申請單號
			pstmt.setString(2,VERSIONID);  //版次
			pstmt.setString(3,statuscode);         //狀態
			pstmt.setString(4,UserName);        //操作者名稱
			pstmt.setString(5,TXTREJ);              //備註
			pstmt.executeUpdate();
							
			CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_PKG.PMD_EMAIL_NOTICE(?,?,?)}");			 
			cs4.setString(1,REQUESTNO); 
			cs4.setInt(2,Integer.parseInt(VERSIONID)); 
			cs4.setString(3,statuscode); 
			cs4.execute();
			cs4.close();
		}
	}
}
%>
<body>
<FORM NAME="MYFORM" METHOD="POST"> 
<table width="100%">
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td width="50%"><font color="#000000" size="4" face="標楷體"><strong>委外加工單未核淮明細(狀態:Submit)</strong></FONT></td>
					<td width="50%" align="right"><font color="#000000" size="2" face="細明體"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#99CC99"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1" bordercolor="#cccccc">
				<tr>
					<td width="10%" style="background-color:#99CCCC">供應商</td>
					<td width="20%">
					<%
					try
					{   
						sql = " SELECT DISTINCT a.VENDOR_CODE,'('||VENDOR_CODE||')'|| VENDOR_NAME VENDOR_NAME FROM oraddman.tspmd_oem_headers_all A where STATUS='Submit' order by a.VENDOR_CODE";
						Statement st2=con.createStatement();
						ResultSet rs2=st2.executeQuery(sql);
						comboBoxBean.setRs(rs2);
						comboBoxBean.setFontSize(11);
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setSelection(VENDOR);
						comboBoxBean.setFieldName("VENDOR");	 
						out.println(comboBoxBean.getRsString());				   
						rs2.close();   
						st2.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					}		
					%>						
					</td>
					<td width="10%"style="background-color:#99CCCC">品名</td>
					<td width="20%">
					<%
					try
					{   
						sql = " SELECT DISTINCT a.ITEM_DESCRIPTION,a.ITEM_DESCRIPTION FROM oraddman.tspmd_oem_headers_all A where STATUS='Submit' order by a.ITEM_DESCRIPTION";
						Statement st2=con.createStatement();
						ResultSet rs2=st2.executeQuery(sql);
						comboBoxBean.setRs(rs2);
						comboBoxBean.setFontSize(11);
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setSelection(ITEM_DESC);
						comboBoxBean.setFieldName("ITEM_DESC");	 
						out.println(comboBoxBean.getRsString());				   
						rs2.close();   
						st2.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					}		
					%>					
					</td>
					<td width="10%"style="background-color:#99CCCC">申請者</td>
					<td width="20%">
					<%
					try
					{   
						sql = " SELECT DISTINCT a.CREATED_BY_NAME,a.CREATED_BY_NAME FROM oraddman.tspmd_oem_headers_all A where STATUS='Submit' order by a.CREATED_BY_NAME";
						Statement st2=con.createStatement();
						ResultSet rs2=st2.executeQuery(sql);
						comboBoxBean.setRs(rs2);
						comboBoxBean.setFontSize(11);
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setSelection(CREATED_BY);
						comboBoxBean.setFieldName("CREATED_BY");	 
						out.println(comboBoxBean.getRsString());				   
						rs2.close();   
						st2.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					}		
					%>					
					</td>
					<td width="10%">
						<input type="button" name="Search" value="Search" style="font-family:Tahoma,Georgia" onClick="sendSubmit('../jsp/TSCPMDOEMConfirmQuery.jsp')">
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
<%
try
{
	int iCnt = 0,pagewidth=0,LastPage =0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
   	Statement statement=con.createStatement(); 
	sql =  " SELECT a.request_no||'-'||a.version_id \"申請單號\""+
	       ",a.tsc_prod_group \"PROD GROUP\""+
		   ",b.TYPE_NAME \"工單類型\""+
		   ",'('||a.vendor_code||') '|| a.vendor_name \"供應商\""+
           ",a.request_date \"申請日期\""+
		   ",a.inventory_item_name \"料號\""+
		   ",a.item_description \"品名\""+
		   ",a.quantity \"數量\""+
		   ",a.created_by_name \"申請者\""+
           " FROM oraddman.tspmd_oem_headers_all a"+
		   ", oraddman.tspmd_data_type_tbl b"+
           " where b.DATA_TYPE='WIP' "+
		   " AND A.wip_type_no=b.type_no  "+
		   " AND b.STATUS_FLAG='A' "+
		   " AND a.STATUS in (select type_name from oraddman.tspmd_data_type_tbl c where c.DATA_TYPE='ACTION'  AND c.type_no='002')";
	if (!VENDOR.equals("") && !VENDOR.equals("--"))
	{
		sql += " and a.VENDOR_CODE='"+VENDOR+"'";
	}
	if (!ITEM_DESC.equals("") && !ITEM_DESC.equals("--"))
	{
		sql += " and a.ITEM_DESCRIPTION='"+ITEM_DESC+"'";
	}
	if (!CREATED_BY.equals("") && !CREATED_BY.equals("--"))
	{
		sql += " and a.CREATED_BY_NAME='"+CREATED_BY+"'";
	}
	//out.println(sql);
	sql +=  " order by  a.request_no";
	ResultSet rs=statement.executeQuery(sql);
	int colCount=0,showCnt=0;
	String backgroundcolor = "";
	while (rs.next()) 
	{ 	
		if (iCnt == 0)
		{	
			sqlt = " select count(1) rowcnt from ("+sql+") ss";
			Statement statement1=con.createStatement(); 
			ResultSet rs1 =statement1.executeQuery(sqlt);
			while (rs1.next())
			{
				//總筆數
				dataCnt = Long.parseLong(rs1.getString("rowcnt"));
				//最後頁數
				LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
			}
			rs1.close();
			statement1.close();	
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0' bordercolor='#cccccc'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			if (LastPage==1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}
			else if (NowPage == 1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
			}
			else if (NowPage == LastPage)
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}				
			else
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
			}
			out.println("<input type='button' name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type='button' name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;"+"第"+NowPage+"頁&nbsp;&nbsp;");
			out.println("<input type='button' name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type='button' name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
			ResultSetMetaData md=rs.getMetaData();
			colCount=md.getColumnCount();
			String colLabel[]=new String[colCount+1]; 
			out.println("<TABLE cellSpacing='0' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bordercolor='#cccccc'>");      
			out.println("<TR bgcolor='#99CCCC'>");        
			for (int i=1;i<=colCount;i++) 
			{
				colLabel[i]=md.getColumnLabel(i);
				if (i==1)
				{
					out.println("<TD><input type='checkbox' name='chkall' value='all' onClick='checkall()'></TD>");
				}
				out.println("<TD>"+colLabel[i]+"</TD>");
			} 
			out.println("</TR>");
		}

		if ((iCnt+1) > sCnt && (iCnt+1) <= eCnt)
		{
			if ((showCnt%2) ==1)
			{
				backgroundcolor="#E3E4B6";
			}
			else
			{
				backgroundcolor="#ECEDCD";
			}
			out.println("<TR id='tr_"+(iCnt+1)+"'>");    
			for (int i=1;i<=colCount;i++) 
			{
				if (i==1)
				{
					out.println("<TD><input type='checkbox' name='chk' value='"+rs.getString(i)+"'  onClick='setCheck("+(iCnt+1)+")'></TD>");
					out.println("<TD title='點我,可進入委外加工單核淮畫面!'><a href='../jsp/TSCPMDOEMConfirm.jsp?PROD_GROUP="+rs.getString(2)+"&REQUESTNO="+rs.getString(i)+"'>"+rs.getString(i)+"</a></TD>");
				}			
				else if (i==8)
				{
					out.println("<TD>"+(new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rs.getString(i)))+"</TD>");
				}
				else 
				{
					out.println("<TD>"+rs.getString(i)+"</TD>");
				}
			} 
			out.println("</TR>");
			showCnt++;
		}
		iCnt ++;
	}
	if (iCnt >0)
	{
		out.println("</table>");
		out.println("</td>");
		out.println("</tr>");		
		out.println("</table>");
	}
	else
	{
		out.println("<font face='細明體' size='2' color='red'>查無相關資料,請重新輸入查詢條件,謝謝!</font>");
	}
}
catch(Exception e)
{	
	out.println("Exception8:"+e.getMessage());
}	
%>
		</td>
	</tr>
	<tr>
		<td>
		<input type="button" name="OPEN" value="Open" style="visibility:hidden;font-family:Tahoma,Georgia" onClick="setOpen('../jsp/TSCPMDOEMConfirm.jsp')" >&nbsp;&nbsp;
		<input type="button" name="REJ" value="Reject" style="visibility:hidden;font-family:Tahoma,Georgia" onClick="setRej('../jsp/TSCPMDOEMConfirmQuery.jsp')" ><input type="text" name="TXTREJ"  value="" style="visibility:hidden"></td>
	</tr>
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
