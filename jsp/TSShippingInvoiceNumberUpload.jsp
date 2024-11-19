<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		setCloseWindow();
    }  
}  
function setUpload(URL)
{
	if (document.SUBFORM.INVOICE_YEAR.value=="--" ||document.SUBFORM.INVOICE_YEAR.value==null)
	{
		alert("Please input the invoice year!");
		document.SUBFORM.INVOICE_YEAR.focus();
		return false;
	}
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("Please choose upload file!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('upload excel file must be 2003 format!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL+"&INVOICE_YEAR="+document.SUBFORM.INVOICE_YEAR.value+"&SNO="+document.SUBFORM.SNO.value;
	document.SUBFORM.submit();	
}
function setSubmit1(URL)
{
	setClose();
	window.opener.document.MYFORM.action=URL;
	window.opener.document.MYFORM.submit();
}
function setCloseWindow()
{
	setClose();
	//window.opener.document.MYFORM.submit();
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
</script>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String INVOICE_YEAR=request.getParameter("INVOICE_YEAR");
if (INVOICE_YEAR==null || INVOICE_YEAR.equals("--")) INVOICE_YEAR=dateBean.getYearString();
String SNO=request.getParameter("SNO");   //add by Peggy 20211229
if (SNO==null) SNO="";
String sql ="",err_msg="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",REQUESTNO="",v_mo="",v_line="",v_result="",v_batch_id="";
int sheetRows=0,i=0,j=0,irow=0,sheetCols=4,err_cnt=0;
double tot_amt=0;
if (UserRoles==null || (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("TSC_Shipping")<0))
{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("您無此功能權限,請洽系統管理人員...");
			setCloseWindow();
		</script>	
<%	
}
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">發票年度</font></TD>
		<TD>
		<%
		try
		{   
			sql = "select distinct invoice_year,invoice_year invoice_year1 from oraddman.TSC_SHIPPING_INVOICE_DETAIL where invoice_year >= to_char(sysdate,'yyyy') order by invoice_year";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(INVOICE_YEAR);
			comboBoxBean.setFieldName("INVOICE_YEAR");	 
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>			
		</TD>
	</TR>	
	<TR>
		<TD width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">起始尾碼</font></TD>
		<TD><input type="text" name="SNO" value="<%=SNO%>" style="font-family:ARIAL;font-size:12px" maxlength="1" size="4" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>	
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/1211_EXCEL_UPLOAD_FILE.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>	
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳"  style="font-family:細明體" onClick='setUpload("../jsp/TSShippingInvoiceNumberUpload.jsp?ACTION=UPLOAD")' <%=(ACTION.equals("UPLOAD")?"disabled":"")%>>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" style="font-family:細明體" onClick='setCloseWindow();' <%=(ACTION.equals("UPLOAD")?"disabled":"")%>>
		</TD>
	</TR>
</TABLE>
<BR>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\Shipping1211("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		String strarray[][]=new String [sheetRows][7];
		//out.println("sheetRows="+sheetRows);
			
		sql = "select APPS.TSC_SHIPPING_1211_BATCH_ID_S.NEXTVAL from dual";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if (!rs.next())
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			v_batch_id=rs.getString(1);
		}
		rs.close();
		statement.close();
		
		for (i = 1 ; i <=sheetRows; i++) 
		{
			for (j = 0 ; j < sheetCols ; j++)
			{
				jxl.Cell strCell= sht.getCell(j, i);
				//if ( j==3)
				//{
				//
				//	if (strCell.getType() == CellType.NUMBER)  
				//	{
				//		vStr = (new DecimalFormat("######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
				//	}
				//	else
				//	{
				//		err_msg += "Line#"+i+"   數量格式錯誤<br>";
				//	}
				//}
				//else
				//{
					vStr = (strCell.getContents()).trim();
					if (j==3)
					{
						vStr=vStr.replace(",","");
						//out.println(vStr);
						try
						{
							tot_amt = Double.parseDouble(vStr);
						}
						catch(Exception e)
						{
							err_msg += "Line#"+i+"  金額欄位型態錯誤<br>";
						}
					}
					else if (j==2)
					{
						sql = " select order_number,FLOW_STATUS_CODE from ont.oe_order_headers_all oha where oha.order_number='"+vStr+"'";
						statement=con.createStatement();
						rs=statement.executeQuery(sql);
						if (!rs.next())
						{
							err_msg += "Line#"+i+"  "+vStr+"查無訂單號碼<br>";
						}
						else if (!rs.getString("FLOW_STATUS_CODE").equals("AWAITING_SHIPPING") && !rs.getString("FLOW_STATUS_CODE").equals("BOOKED"))
						{
							err_msg += "Line#"+i+"  "+vStr+"訂單號碼狀態:"+rs.getString("FLOW_STATUS_CODE")+"不可產生DN<br>";
						}
						rs.close();
						statement.close();						
					}
				//}
				strarray[i-1][j]=vStr;
			}
		}
		wb.close();
		
		if (!err_msg.equals(""))
		{
			throw new Exception();
		}		
		
		for (i =0 ; i < strarray.length; i++) 
		{	
			if (strarray[i][0]==null || strarray[i][2]==null) throw new Exception("data error!");
			
			sql = " insert into oraddman.TSC_SHIPPING_UPLOAD_DETAIL "+
			      "(BATCH_ID"+
				  ",GROUP_ID"+
				  ",CUSTOMER"+
				  ",SO_NO"+
				  ",TOT_AMT"+
				  ",CREATED_BY"+
				  ",CREATION_DATE"+
				  ",SALES_GROUP"+
				  ",ORGANIZATION_ID"+
				  ",INVOICE_YEAR"+
				  ",START_INVOICE_SEQ"+
				  ")"+
				  " select "+
				  " ?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",Tsc_Intercompany_Pkg.get_sales_group(OHA.header_id) "+
				  ",oha.ship_from_org_id"+
				  ",?"+
				  ",?"+
				  " from ont.oe_order_headers_all oha"+
				  " where oha.org_id=? "+
				  " and oha.order_number=?";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			//out.println(strarray[i][4]);
			//out.println(strarray[i][3]);
			pstmtDt.setString(1,v_batch_id);
			pstmtDt.setString(2,strarray[i][0]);
			pstmtDt.setString(3,strarray[i][1]);
			pstmtDt.setString(4,strarray[i][2]);
			pstmtDt.setString(5,strarray[i][3]);
			pstmtDt.setString(6,UserName);
			pstmtDt.setString(7,INVOICE_YEAR);
			pstmtDt.setString(8,SNO);  //add by Peggy 20211229
			pstmtDt.setInt(9,41);
			pstmtDt.setString(10,strarray[i][2]);
			pstmtDt.executeQuery();
			pstmtDt.close();	
		}
		con.commit();
		
		CallableStatement cs = con.prepareCall("{call tsc_shipping_invoice_pkg.MAIN_DN(?)}");
		cs.setString(1,v_batch_id);
		cs.execute();
		cs.close();

		sql = " select row_number() over (order by group_id,dn_number,so_no) row_num,a.*,count(1) over (partition by group_id) group_cnt,row_number() over (partition by group_id order by so_no) group_seq"+
		      " from oraddman.tsc_shipping_upload_detail a "+
			  " WHERE BATCH_ID="+v_batch_id+""+
			  " order by group_id";
		statement=con.createStatement();
		rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (rs.getInt(1)==1)
			{ 
				out.println("<div style='color:#0000FF;font-size:12px'>執行結果如下....</div><table width='100%' border='1'>");
				out.println("<tr style='color:#000000'>");
				out.println("<td>Delivery Note#</td>");
				out.println("<td>Group No</td>");
				out.println("<td>Customer</td>");
				out.println("<td>MO#</td>");
				out.println("<td>Execution result</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			if (rs.getInt("group_seq")==1)
			{
				out.println("<td rowspan="+rs.getInt("group_cnt")+">"+rs.getString("DN_NUMBER")+"</td>");
				out.println("<td rowspan="+rs.getInt("group_cnt")+">"+rs.getString("GROUP_ID")+"</td>");
				out.println("<td rowspan="+rs.getInt("group_cnt")+">"+rs.getString("CUSTOMER")+"</td>");
			}
			out.println("<td>"+rs.getString("SO_NO")+"</td>");
			out.println("<td style='color:"+(rs.getString("ERR_MSG")==null && rs.getString("CHK_FLAG").equals("F")?"#0000ff":"#ff0000")+"'>"+(rs.getString("ERR_MSG")==null && rs.getString("CHK_FLAG").equals("F")?"Success":"Fail.."+rs.getString("ERR_MSG"))+"</td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
		out.println("</table>");
		%>
			<script language="JavaScript" type="text/JavaScript">
				document.SUBFORM.upload.disabled=false;
				document.SUBFORM.winclose.disabled=false;
			</script>	
		<%		
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>"+(err_msg.equals("")?e.getMessage():err_msg)+"</div>");
%>
	<script language="JavaScript" type="text/JavaScript">
		document.SUBFORM.upload.disabled=false;
		document.SUBFORM.winclose.disabled=false;
	</script>	
<%
}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
