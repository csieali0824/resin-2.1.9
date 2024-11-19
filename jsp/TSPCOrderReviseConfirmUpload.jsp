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
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
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
String sql ="",v_source_ssd="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",id="",V_BATCH_ID="",strShippingMethod="",v_sales_region="";
int sheetRows=0,sheetCols=12,i=0,j=0,k=0,rec_cnt=0,err_cnt=0,v_cnt=0;
String strarray[]=new String [sheetCols];
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#99CC99">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSPCOrderReviseConfirmUpload.jsp?ACTION=UPLOAD")'>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D15-002("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		int v_year=0,v_month=0,v_day=0;
						
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(" SELECT TSC_OM_SALESORDERREVISE_U_IS_S.nextval from dual");
		if (rs1.next())
		{
			V_BATCH_ID = rs1.getString(1);
			%>
				<input type="hidden" name="BATCHID" value="<%=V_BATCH_ID%>">
			<%
			
		}
		else
		{
			throw new Exception("Batch Id取得失敗!!");
		}
		rs1.close();
		statement1.close();	
				
		sql = " SELECT lookup_code,meaning FROM fnd_lookup_values lv"+
			  " WHERE language = 'US'"+
			  " AND view_application_id = 3"+
			  " AND lookup_type = 'SHIP_METHOD'"+
			  " AND security_group_id = 0"+
			  " AND ENABLED_FLAG='Y'"+
			  " AND (end_date_active IS NULL OR end_date_active > SYSDATE)";
		Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rsh = statementh.executeQuery(sql);	
											
		for (i = 1 ; i <=sheetRows; i++) 
		{
			k=0;
			strarray[0]="";strarray[1]="";strarray[2]="";strarray[3]="";strarray[4]="";strarray[5]="";strarray[6]="";strarray[7]="";strarray[8]="";strarray[9]="";strarray[10]="";strarray[11]="";
			for (j = 0 ; j < 24 ; j++)
			{
				if (j==3)
				{
					jxl.Cell strCell= sht.getCell(j, i);
					v_sales_region = (strCell.getContents()).trim();
					if (v_sales_region.equals("TSCE"))
					{
						v_cnt=1;
					}
					else
					{
						v_cnt=0;
					}
				}
				if (j ==0 || j == 1 || j ==5 || j == 6 || j==14 || j==15+v_cnt || j==16+v_cnt || j==17+v_cnt || j==18+v_cnt || j==19+v_cnt || j==20+v_cnt)
				{
					//out.println("j="+j);
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
					strarray[k]=vStr;
					k++;
				}
			}
			//out.println(strarray[0]);
			//out.println(strarray[1]);
			//out.println(strarray[2]);
			//out.println(strarray[3]);
			//out.println(strarray[4]);
			//out.println(strarray[5]);
			//out.println(strarray[6]);
			//out.println(strarray[7]);
			//out.println(strarray[8]);
			if ((strarray[0]==null || strarray[0].equals("")) || (strarray[1]==null || strarray[1].equals(""))) //request_no,seq_id
			{	
				if ((strarray[6]!=null && !strarray[6].equals("")) || (strarray[7]!=null && !strarray[7].equals("")) || (strarray[8]!=null && !strarray[8].equals("")))
				{
					throw new Exception("Request# or Seq# can not empty!!");
				}
			}
		
			strShippingMethod="";
			if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
			while (rsh.next())
			{
				if (rsh.getString("MEANING").equals(strarray[6]))
				{
					strShippingMethod = rsh.getString("LOOKUP_CODE");
					break;
				}
			}
			
			if (strShippingMethod.equals(""))
			{
				strarray[11]="運輸方式未定義("+strarray[6]+")";
				err_cnt ++;		
			}				

			if (strarray[5].length()!=8)
			{
				strarray[11]="SSD format error";
				err_cnt ++;			
			}
			else
			{
				v_year = Integer.parseInt(strarray[5].substring(1,4));
				v_month = Integer.parseInt(strarray[5].substring(4,6));
				v_day = Integer.parseInt(strarray[5].substring(6,8));
				if (v_month >12 || v_month<1)
				{
					strarray[11]="SSD month error("+strarray[5]+"-"+strarray[5].substring(4,6)+")";
					err_cnt ++;					
				}
				else if ((v_month ==1 || v_month ==3 || v_month ==5 || v_month ==7  || v_month ==8  || v_month ==10  || v_month ==12) && v_day >31)
				{
					strarray[11]="1.SSD error("+v_month+v_day+")";
					err_cnt ++;					
				}
				else if ((v_month ==4 || v_month ==6 || v_month ==9  || v_month ==11) && v_day >30)
				{
					strarray[11]="2.SSD error("+v_month+v_day+")";
					err_cnt ++;	
				}
				else if ((v_year % 4 !=0 || (v_year % 100 ==0 && v_year%400 != 0)) && v_month ==2 && v_day>28) 
				{
					strarray[11]="3.SSD error("+v_month+v_day+")";
					err_cnt ++;					
				}
			}
			if (!strarray[7].equals(""))
			{
				if (strarray[9].equals("Early Ship"))
				{
					strarray[11]="Please keep hold flag to empty when Early Ship type";
					err_cnt ++;
				}
				else if (!strarray[7].equals("Y"))
				{
					strarray[11]="The hold value must be a Y or space value";
					err_cnt ++;
				}
			}
			if (strarray[8] == null || (!strarray[8].toUpperCase().equals("OK") && !strarray[8].toUpperCase().startsWith("REJ")))
			{
				strarray[11]="The result must be a  [OK] or [Reject] value("+strarray[8]+")";
				err_cnt ++;
			}
			else if (strarray[10].equals("Early Ship") && strarray[8].toUpperCase().startsWith("REJ") && (strarray[9]==null || strarray[9].trim().equals("")))
			{
				strarray[11]="Please input a reject reason";
				err_cnt ++;
			}
			
			if (strarray[11].equals(""))
			{
				sql = " select 1 from oraddman.tsc_om_salesorderrevise_pc a"+
					  " where REQUEST_NO=?"+
					  " and SEQ_ID=?"+
					  " and STATUS=?";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,strarray[0]);
				statement.setString(2,strarray[1]);
				statement.setString(3,"AWAITING_CONFIRM");
				ResultSet rs=statement.executeQuery();
				v_source_ssd="";
				if (rs.next())
				{
					sql = " update oraddman.tsc_om_salesorderrevise_pc"+
						  " set SALES_CONFIRMED_QTY=SO_QTY"+
						  ",SALES_CONFIRMED_SSD=TO_DATE(?,'YYYYMMDD')"+
						  ",SHIPPING_METHOD=?"+
						  ",SALES_CONFIRMED_RESULT=?"+
						  ",SALES_CONFIRMED_REMARKS=UTL_I18N.UNESCAPE_REFERENCE(?)"+
						  ",HOLD_CODE=?"+
						  ",HOLD_REASON=UTL_I18N.UNESCAPE_REFERENCE(?)"+  
						  ",BATCH_ID=?"+
						  " WHERE REQUEST_NO=?"+
						  " AND SEQ_ID=?"+
						  " AND STATUS=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,strarray[5]);
					pstmtDt.setString(2,strarray[6]);
					pstmtDt.setString(3,(strarray[8].toUpperCase().startsWith("REJ")?"R":(strarray[8].toUpperCase().startsWith("OK")?"A":"")));
					pstmtDt.setString(4,strarray[9]);
					pstmtDt.setString(5,strarray[7]);
					pstmtDt.setString(6,(strarray[7].startsWith("Y")?strarray[9]:""));
					pstmtDt.setString(7,V_BATCH_ID);
					pstmtDt.setString(8,strarray[0]);
					pstmtDt.setString(9,strarray[1]);
					pstmtDt.setString(10,"AWAITING_CONFIRM");
					pstmtDt.executeQuery();
					pstmtDt.close();						
				}
				else
				{
					strarray[11]="no Data found";
					err_cnt ++;
				}
				rs.close();
				statement.close();  
			}
					
			if ( rec_cnt==0)
			{
			%>
			<table width="100%">
				<tr bgcolor="#99CC99">
					<td width="10%">Request No </td>
					<td width="6%">Seq No</td>
					<td width="10%">MO No</td>
					<td width="4%">Line No</td>
					<td width="8%">Sales CFM Qty</td>
					<td width="8%">Sales CFM SSD</td>
					<td width="11%">Shipping Method</td>
					<td width="6%">Sales Hold</td>
					<td width="12%" colspan="2">Sales CFM Result</td>
					<td width="11%">Sales CFM Remarks</td>
					<td width="21%">Error Message</td>
				</tr>
			<%
			}
			
			%>
				<tr>
					<td><%=strarray[0]%></td>
					<td><%=strarray[1]%></td>
					<td><%=strarray[2]%></td>
					<td><%=strarray[3]%></td>					
					<td><input type="text" name="qty_<%=id%>" value="<%=strarray[4]%>" style="font-family: Tahoma,Georgia;font-size:11px; text-align:right" size="6" readonly></td>
					<td><input type="text" name="ssd_<%=id%>" value="<%=strarray[5]%>" style="font-family: Tahoma,Georgia;font-size:11px; text-align:right" size="7" readonly></td>
					<td><%=(strarray[6]==null?"&nbsp;":strarray[6])%></td>
					<td style="color:#FF0000"><%=(strarray[7]==null?"&nbsp;":strarray[7])%></td>
					<td align="center"><input type="checkbox" name="chk" value="<%=id%>" checked readonly></td>
					<td><input type="radio" name="rdo_<%=id%>" value="A" <%=(strarray[8].toUpperCase().equals("OK")?" checked":"")%> style="font-family: Tahoma,Georgia;font-size:11px;">Accept&nbsp;&nbsp;<input type="radio" name="rdo_<%=id%>" value="R" <%=(strarray[6].toUpperCase().startsWith("REJ")?" checked":"")%> style="font-family: Tahoma,Georgia;font-size:11px;">Reject</td>
					<td><input type="text" name="pcremark_<%=id%>" value="<%=strarray[9]%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px" size="8" readonly></td>
					<td style="color:#FF0000"><%=(strarray[9]==null?"&nbsp;":strarray[11])%></td>
				</tr>
			<%
			rec_cnt++;
		}
		
		if (rec_cnt >0)
		{
		%>
			</table>
		<%
		}		
		wb.close();
		rsh.close();
		statementh.close();
		
		if (err_cnt ==0)
		{
			con.commit();
		%>
		<script language="JavaScript" type="text/JavaScript">
			window.opener.document.MYFORM.action="../jsp/TSPCOrderReviseConfirm.jsp?ATYPE=UPD&BID="+document.SUBFORM.BATCHID.value;
			window.opener.document.MYFORM.submit();
			window.close();	
		</script>
		<%
			
		}
		else
		{
			con.rollback();
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Row#"+i+" Data Error"+e.getMessage()+"</div>");
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
