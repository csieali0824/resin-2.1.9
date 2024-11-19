<!-- 20160517 by Peggy,簡稱不使用 Name Pronuncication ,改採用 Account Description-->
<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setCloseWindow()
{
	setClose();
	window.opener.document.MYFORM.submit();
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
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",temp_id="";
int sheetRows=0,sheetCols=14,i=0,j=0,err_cnt=0,v_seqid=0;
long change_qty =0,new_qty=0;
String strarray[]=new String [sheetCols];
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Sample File </TD>
		<TD>&nbsp;<A HREF="../jsp/samplefiles/D13-001_SampleFile.xls">Download Sample File</A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCHSalesOrderReviseUpload.jsp?ACTION=UPLOAD")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D13-001("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		//out.println("sheetRows="+sheetRows);

		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery("SELECT TSCH_ORDER_REVISE_TEMP_ID_S.nextval from dual");
		if (rs1.next())
		{
			temp_id = rs1.getString(1);
		}
		else
		{
			throw new Exception("Get Temp ID fail!!");
		}
		rs1.close();
		statement1.close();	
								
		for (i = 1 ; i <=sheetRows; i++) 
		{
			//strarray[0]=SGROUP;
			for (j = 0 ; j < 11 ; j++)
			{
				jxl.Cell strCell= sht.getCell(j, i);
				if (strCell.getType() == CellType.DATE)
             	{
             		DateCell vdate = (DateCell)strCell;
             		java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
					SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
					vStr=sy1.format(ReqDate); 
				}	
				else
				{
					vStr = (strCell.getContents()).trim();
					if (vStr != null && !vStr.equals("") && vStr.substring(0,1).equals("'"))
					{
						vStr = vStr.substring(1);
					}
				}
				strarray[j]=vStr;
				if (j==6) strarray[j]=strarray[6].replace(",",""); //add by Peggy 20160711
				//if ((j==6 || j==18) && strarray[j]!=null && !strarray[j].equals("")) strarray[j] = strarray[j].replace(",","");
			}
			if ((strarray[2]==null || strarray[2].equals("")) || (strarray[3]==null || strarray[3].equals(""))) //PO#,PO line#
			{	
				if ((strarray[0]!=null && !strarray[0].equals("")) || (strarray[1]!=null && !strarray[1].equals("")) || (strarray[4]!=null && !strarray[4].equals("")) || (strarray[5]!=null && !strarray[5].equals("")) || (strarray[6]!=null && !strarray[6].equals("")) || (strarray[7]!=null && !strarray[7].equals("")) || (strarray[8]!=null && !strarray[8].equals("")) || (strarray[9]!=null && !strarray[9].equals("")))
				{
					throw new Exception("Cust PO# or PO Line# can not empty!!");
				}
				else
				{
					continue;
				}
			}
			if (strarray[9]==null || strarray[9].equals(""))
			{
				change_qty=0;
			}
			else
			{
				change_qty=Long.parseLong(strarray[9])-Long.parseLong(strarray[6]);
			}
			
			sql = " select a.HEADER_ID,a.order_number,b.LINE_ID,b.line_number||'.'||b.shipment_number line_no,b.FLOW_STATUS_CODE "+
			      ",b.customer_line_number customer_po,d.description,TO_CHAR(b.REQUEST_DATE,'YYYYMMDD') CRD,B.ORDERED_QUANTITY "+
				  ",(select count(1) from oraddman.TSC_OM_SALESORDERREVISE_TSCH x where x.SO_LINE_ID=b.line_id and x.STATUS not in ('CLOSED')) inprocess_cnt"+
			      " from ont.oe_order_headers_all a"+
				  " ,ont.oe_order_lines_all b"+
				  " ,ar_customers c"+
				  " ,inv.mtl_system_items_b d"+
				  " ,HZ_CUST_ACCOUNTS HCA"+
				  " where a.org_id=?"+
				  " and a.header_id=b.header_id"+
				  " and a.sold_to_org_id=c.customer_id"+
				  " and b.inventory_item_id=d.inventory_item_id"+
				  " and b.ship_from_org_id=d.organization_id"+
				  " AND c.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID"+ //add by Peggy 20160517
				  //" and c.customer_number=?"+
				  " and b.customer_line_number=?"+
				  " and b.customer_shipment_number=?"+
				  " and b.FLOW_STATUS_CODE NOT IN ('CANCELLED','SHIPPED','PICKED','CLOSED','PRE-BILLING_ACCEPTANCE')";
			if (!UserRoles.equals("admin") && !UserName.toUpperCase().equals("COCO"))
			{
				sql += " AND EXISTS (SELECT 1 FROM TSC_OM_ORDER_PRIVILEGE X WHERE X.RFQ_USERNAME='"+UserName+"' AND X.CUSTOMER_ID=A.SOLD_TO_ORG_ID AND X.ORG_ID=A.ORG_ID)";
			}
			//out.println(sql);	
			PreparedStatement statement = con.prepareStatement(sql);								  
			statement.setInt(1,806);
			statement.setString(2,strarray[2]);
			statement.setString(3,strarray[3]);
			ResultSet rs=statement.executeQuery();	
			int rec_cnt=0;	
			while (rs.next())
			{	
				if (change_qty!=0)
				{
					if (Long.parseLong(rs.getString("ORDERED_QUANTITY")) +(change_qty) <0)
					{
						new_qty = 0;
						change_qty = (change_qty) + Long.parseLong(rs.getString("ORDERED_QUANTITY"));
					}
					else
					{
						new_qty = Long.parseLong(rs.getString("ORDERED_QUANTITY")) +(change_qty);
						change_qty = 0;
					}
				}
				sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_TEMP "+
					  "(TEMP_ID"+
					  ",SEQ_ID"+
					  ",CREATED_BY"+
					  ",CREATION_DATE"+
					  ",SALES_GROUP"+
					  ",SO_NO"+
					  ",LINE_NO"+
					  ",SO_HEADER_ID"+
					  ",SO_LINE_ID"+
					  ",SOURCE_ITEM_DESC"+
					  ",SOURCE_CUSTOMER_PO"+
					  ",SOURCE_SO_QTY"+
					  ",SOURCE_SSD"+
					  ",SO_QTY"+
					  ",REQUEST_DATE"+
					  ",REMARKS"+
					  ",ORG_ID"+
					  ")"+
					  " values"+
					  " ("+
					  " ?"+
					  ","+(v_seqid++)+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",to_date(?,'yyyymmdd')"+
					  ",?"+
					  ",to_date(?,'yyyymmdd')"+
					  ",?"+
					  ",?"+
					  " )";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,temp_id);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,"TSCH-HK");
				pstmtDt.setString(4,rs.getString("order_number"));
				pstmtDt.setString(5,rs.getString("line_no"));
				pstmtDt.setString(6,rs.getString("HEADER_ID"));
				pstmtDt.setString(7,rs.getString("line_id"));
				pstmtDt.setString(8,rs.getString("description"));
				pstmtDt.setString(9,rs.getString("customer_po"));
				pstmtDt.setString(10,rs.getString("ORDERED_QUANTITY"));
				pstmtDt.setString(11,rs.getString("CRD"));
				pstmtDt.setString(12,(change_qty==0?"":""+new_qty));
				pstmtDt.setString(13,strarray[8]);
				pstmtDt.setString(14,strarray[10]);
				pstmtDt.setString(15,"806");
				pstmtDt.executeQuery();
				pstmtDt.close();
						
				strarray[11]=rs.getString("order_number");
				strarray[12]=rs.getString("line_no");
				strarray[13]="";
				if (rs.getInt("inprocess_cnt")>0) 
				{
					strarray[13]="MO#"+rs.getString("order_number") + "  Line#"+rs.getString("line_no")+ " in process";
				}
				else if (strarray[6] != null && !strarray[6].equals("") && !rs.getString("ORDERED_QUANTITY").equals(strarray[6]))
				{
					strarray[13]="MO#"+rs.getString("order_number") + "  Line#"+rs.getString("line_no")+ " Qty is not match with ERP Order Qty";
				}
				else if (strarray[7] != null && !strarray[7].equals("") && !rs.getString("CRD").equals(strarray[7]))
				{
					strarray[13]="MO#"+rs.getString("order_number") + "  Line#"+rs.getString("line_no")+  " CRD is not match with ERP Order CRD";
				}
				if (strarray[13].length()>0) err_cnt ++;
				rec_cnt++;
			}
			rs.close();
			statement.close();	
			if (rec_cnt ==0)
			{
				strarray[13]="PO not found";
				err_cnt++;
			}
			else if (change_qty !=0)
			{
				strarray[13]="No enough order qty to change";
				err_cnt++;			
			}
			if (strarray[13].length()>0)
			{
				if (err_cnt ==1)
				{
					out.println("<table border='1' width='60%'>");
					out.println("<tr style='background-color:#CCCCCC'>");
					out.println("<td>CUST PO#</td><td> PO Line#</td><td>Error Message</td>");
					out.println("</tr>");
				}
				out.println("<tr>");
				out.println("<td>"+strarray[2]+"</td><td>"+strarray[3]+"</td><td><font color='#ff0000'>"+strarray[13]+"</font></td>");
				out.println("</tr>");
			}
		}	
		wb.close();
		
		if (err_cnt >0) 
		{
			out.println("</table>");				
			throw new Exception("some data error..");
		}
		else
		{
			con.commit();
			out.println("<script language='JavaScript' type='text/JavaScript'>");
			out.println("window.opener.document.MYFORM.action="+'"'+"../jsp/TSCHSalesOrderReviseRequest.jsp?ACODE=UPLOAD&TEMP_ID="+temp_id+'"');
			out.println("window.opener.document.MYFORM.submit();");
			out.println("setClose();");
			out.println("</script>");
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!"+e.getMessage()+"</div>");
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
