<!--20171110 Peggy,新增end customer,selling price,tax code,currency code-->
<!--20171215 Peggy,新增tsch so,tsch line no-->
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
function setSubmit(URL)
{
	setClose();
	window.opener.document.MYFORM.action=URL;
	window.opener.document.MYFORM.submit();	
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
//String SGROUP = request.getParameter("SGROUP");
//if (SGROUP==null) SGROUP="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",temp_id="",vStr_code="";
int sheetRows=0,sheetCols=34,i=0,j=0,irow=0,colnum=0;
String strarray[]=new String [sheetCols];
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<!--<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Sales Group</TD>
		<TD>&nbsp;<strong></strong></TD>
	</TR>-->
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSSalesOrderReviseUpload.jsp?ACTION=UPLOAD")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
		</TD>
	</TR>
</TABLE>
<BR>
<font style="color:#0033CC">Upload excel format changed on 2023/4/17,please download a new excel file from system.</font>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D12-001("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		//out.println("sheetRows="+sheetRows);
		
		//CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		//cs1.setString(1,"41");  
		//cs1.execute();
		//cs1.close();	
		
		Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		sql =" SELECT  LOOKUP_CODE, MEANING"+
             " FROM fnd_lookup_values"+
             " WHERE lookup_type = 'YES_NO_HOLD'"+
             " AND language ='US'"+
             " AND enabled_flag ='Y'"+
             " AND TRUNC(NVL(END_DATE_ACTIVE,TO_DATE('20990101','YYYYMMDD')))>TRUNC(SYSDATE)";
		ResultSet rss = statements.executeQuery(sql);		
				
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(" SELECT TSC_ORDER_REVISE_TEMP_ID_S.nextval from dual");
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
			for (j = 0 ; j < sheetCols ; j++)
			{
				colnum=j;vStr_code="";	
				try
				{
					jxl.Cell strCell= sht.getCell(j, i);
					if (strCell.getType() == CellType.DATE)
					{
						DateCell vdate = (DateCell)strCell;
						java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
						SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
						vStr=sy1.format(ReqDate); 
					}
					else if (strCell.getType() == CellType.NUMBER)  //add by Peggy 20201102
					{
						vStr = (new DecimalFormat("######.#####")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
					}
					else
					{
						vStr = (strCell.getContents()).trim();
						if (vStr != null && !vStr.equals("") && vStr.substring(0,1).equals("'"))
						{
							vStr = vStr.substring(1);
						}
						if (j==7 && !vStr.equals(""))
						{
							throw new Exception("Original SSD format error!!");
						}
						else if (j==19 && !vStr.equals(""))
						{
							throw new Exception("New SSD pull in/out format error!!");
						}
						else if (j==31 && !vStr.equals("")) //add by Peggy 20230412
						{
							if (vStr.toUpperCase().indexOf("REMOVE")<0)
							{
								if (rss.isBeforeFirst() ==false) rss.beforeFirst();
								while (rss.next())
								{	
									if (rss.getString("MEANING").equals(vStr))
									{
										vStr_code =rss.getString("LOOKUP_CODE");
										break;
									}
								}
								if (vStr_code.equals(""))
								{
									throw new Exception("New Hold Shipment("+vStr+") not found!!");
								}								
							}
							else
							{
								vStr_code="NA";
							}
						}
						else if (j==33 && !vStr.equals("") && !vStr.equals("NA") && !vStr.equals("N/A")) //add by Peggy 20230412
						{
							if (vStr.length()!=8)
							{
								throw new Exception("New forecast date format error!!");
							}
						}
					}
					//if ( i>=6)
					//{
					//	out.println("strarray["+j+"]="+vStr);
					//}
				}
				catch(Exception e)
				{	
					//add by Peggy 20171215
					if (j==28 || j==29)
					{
						vStr="";
					}
					else
					{
						throw new Exception(e.getMessage());
					}
				}
				//out.println("j="+j);
				strarray[j]=(j==31?vStr_code:vStr); //modify by Peggy 20230412
				if ((j==6 || j==18) && strarray[j]!=null && !strarray[j].equals("")) strarray[j] = strarray[j].replace(",","");
			}
			if ((strarray[1]==null || strarray[1].equals("")) || (strarray[2]==null || strarray[2].equals(""))) //mo#,line#
			{	
				if ((strarray[0]!=null && !strarray[0].equals("")) || (strarray[3]!=null && !strarray[3].equals("")) || (strarray[4]!=null && !strarray[4].equals("")) || (strarray[5]!=null && !strarray[5].equals("")) || (strarray[6]!=null && !strarray[6].equals("")) || (strarray[7]!=null && !strarray[7].equals("")))
				{
					throw new Exception("MO# or Line# can not empty!!");
				}
				else
				{
					continue;
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
				  ",SOURCE_ITEM_DESC"+
				  ",SOURCE_CUSTOMER_PO"+
				  ",SOURCE_SO_QTY"+
				  ",SOURCE_SSD"+
				  ",ORDER_TYPE"+
				  ",CUSTOMER_NUMBER"+
				  ",CUSTOMER_NAME"+
				  ",SHIP_TO_LOCATION_ID"+
				  ",BILL_TO_LOCATION_ID"+
				  ",DELIVER_TO_LOCATION_ID"+
				  ",ITEM_NAME"+
				  ",CUST_ITEM_NAME"+
				  ",CUSTOMER_PO"+
				  ",SHIPPING_METHOD"+
				  ",SO_QTY"+
				  ",SCHEDULE_SHIP_DATE"+
				  ",REQUEST_DATE"+
				  ",FOB"+
				  ",REMARKS"+
				  ",CHANGE_REASON"+
				  ",CHANGE_COMMENTS"+
				  ",SELLING_PRICE"+
				  ",END_CUSTOMER_NO"+
				  ",TAX_CODE"+
				  ",NEW_TSCH_SO_NO"+
				  ",NEW_TSCH_LINE_NO"+
				  ",ORG_ID"+
				  ",SUPPLIER_NUMBER"+  //add by Peggy 20220428
				  ",NEW_HOLD_CODE"+    //add by Peggy 20230310
				  ",NEW_HOLD_REASON"+  //add by Peggy 20230310
				  ",NEW_FORECAST_SSD"+ //add by Peggy 20230412
				  ")"+
				  " values"+
				  " ("+
				  " ?"+
				  ","+(i)+""+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",to_date(?,'yyyymmdd')"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",to_date(?,'yyyymmdd')"+
				  ",to_date(?,'yyyymmdd')"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",case substr(nvl(?,?),1,1) when '7' then ? when '4' then ?  when '8' then ? else ? end "+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  " )";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,temp_id);
			pstmtDt.setString(2,UserName);
			for (int k = 0 ; k < strarray.length-4 ; k++)
			{ 
				if (k==4) continue; //customer
				irow=((k>4)?(k-1):k)+3;
				pstmtDt.setString(irow,strarray[k]);
				//out.println("strarray["+k+"]="+strarray[k]);
			}
			pstmtDt.setString(irow+1,strarray[8]);
			pstmtDt.setString(irow+2,strarray[3]);
			pstmtDt.setString(irow+3,"806");
			pstmtDt.setString(irow+4,"325");
			pstmtDt.setString(irow+5,"906");
			pstmtDt.setString(irow+6,"41");
			pstmtDt.setString(irow+7,strarray[30]);
   		    pstmtDt.setString(irow+8,strarray[31]);	   //add by Peggy 20230325
   		    pstmtDt.setString(irow+9,strarray[32]);	   //add by Peggy 20230325		
			pstmtDt.setString(irow+10,strarray[33]);   //add by Peggy 20230412		
			pstmtDt.executeQuery();
			pstmtDt.close();				  
		}
		wb.close();
		
		CallableStatement cs = con.prepareCall("{call tsc_order_revise_pkg.revise_data_check(?,?)}");
		cs.setString(1,temp_id);
		cs.setString(2,UserName);
		cs.execute();
		cs.close();	
		con.commit();
		
		int error=0;
		int second_times=0;
		Statement statement=con.createStatement();
		sql = " select SEQ_ID,SALES_GROUP,'MO#'||SO_NO ,'Line#'||LINE_NO,ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_TEMP "+
			  " WHERE TEMP_ID='"+temp_id+"' and PASS_FLAG='N'";
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		while (rs.next())
		{
			if (error==0) out.println("<div style='color:#FF0000;font-size:12px'>Upload Fail~~</div><table width='100%'>");
			out.println("<tr style='color:#FF0000'>");
			out.println("<td width='10%'>Row#"+(rs.getInt(1)+1)+":</td>");
			for (j = 3 ; j <= md.getColumnCount() ; j++)
			{
				if (j<md.getColumnCount())
				{
					out.println("<td width='15%'>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
				}
				else
				{
					out.println("<td width='60%'>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
				}
			}
			out.println("</tr>");
			error++;
		}
		rs.close();
		statement.close();
		rss.close();
		statements.close();
		
		if (error >0)
		{
			out.println("</table>");
		}
		else
		{
			statement=con.createStatement();
			sql = " select SEQ_ID,SALES_GROUP,'MO#'||SO_NO ,'Line#'||LINE_NO,row_number() over (order by SEQ_ID) row_seq  from oraddman.TSC_OM_SALESORDERREVISE_TEMP a "+
				  " WHERE TEMP_ID='"+temp_id+"' and CANCEL_MOVE_FLAG='2' order by SEQ_ID";
			rs=statement.executeQuery(sql);
			md=rs.getMetaData();
			while (rs.next())
			{
				second_times++;
				if (rs.getInt("row_seq")==1) out.println("<div style='color:#ff00ff;font-size:12px'><br>Notice!!<br>The following order is the second move, and will pass to the sales head to approve~~</div>");
				out.println("<table width='100%'>");
				out.println("<tr style='color:#ff00ff'>");
				out.println("<td width='10%'>Row#"+(rs.getInt(1))+":</td>");
				for (j = 3 ; j <= md.getColumnCount()-1 ; j++)
				{
					if (j<md.getColumnCount())
					{
						out.println("<td width='15%'>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
					}
					else
					{
						out.println("<td width='60%'>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
					}
				}
				out.println("</tr>");
			}
			rs.close();
			statement.close();
			if (second_times>0)
			{
				out.println("</table>");
				%>
				<hr>
				<div align="center"><input type="button" name="submit1" value="Confirm & Sumbit" style="font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/TSSalesOrderReviseRequest.jsp?ActionType=UPLOAD&ID=<%=temp_id%>')"></div>
				<%
			}
			else
			{		
				out.println("<script language='JavaScript' type='text/JavaScript'>");
				out.println("window.opener.document.MYFORM.action="+'"'+"../jsp/TSSalesOrderReviseRequest.jsp?ActionType=UPLOAD&ID="+temp_id+'"'+";");
				out.println("window.opener.document.MYFORM.submit();");
				out.println("setClose();");
				out.println("</script>");
			}
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Row#"+(i)+"("+colnum+"):"+e.getMessage()+"</div>");
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
