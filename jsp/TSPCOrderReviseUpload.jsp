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
	var chvalue="";
	for (var i =0 ; i <document.SUBFORM.rdo1.length ;i++)
	{
		if (document.SUBFORM.rdo1[i].checked)
		{
			 chvalue = document.SUBFORM.rdo1[i].value;
			 break;
		}
	}
	if (chvalue == "")
	{
		alert("Please choose a request type!");
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
	document.SUBFORM.exit1.disabled=true;	
	document.SUBFORM.action=URL+"&rdo1="+chvalue;
	document.SUBFORM.submit();	
}
function setSubmit1(URL)
{
	//setClose();
	//window.opener.document.MYFORM.action=URL;
	//window.opener.document.MYFORM.submit();
	window.location = URL;
}
function setSubmit2(URL)
{
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
//String REQ_TYPE =request.getParameter("REQ_TYPE");
//if (REQ_TYPE==null) REQ_TYPE="";
String PLANTCODE = request.getParameter("PLANT");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String rdo1=request.getParameter("rdo1");
if(rdo1==null) rdo1="";
String VCHKED=request.getParameter("VCHKED");
if(VCHKED==null) VCHKED="";
String REQUESTNO=request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String sql ="",err_msg="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",v_mo="",v_line="",v_result="";
int sheetRows=0,i=0,j=0,irow=0,sheetCols=0,err_cnt=0,v_exist_cnt=0,i_statr_line=0;

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<table width="100%">
	<tr>
		<td width="15%">&nbsp;</td>
		<td width="70%">
		<div align="left">Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Request Type</TD>
		<TD><input type="radio" name="rdo1" value="1" <%=(rdo1.equals("1")?"checked":"")%>>
		Early Ship 
		  <input type="radio" name="rdo1" value="2" <%=(rdo1.equals("2")?"checked":"")%>><font style="font-family: Tahoma,Georgia">Overdue/Early Warning</font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="80" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSPCOrderReviseUpload.jsp?ACTION=UPLOAD&PLANT=<%=PLANTCODE%>")' <%=(ACTION.equals("UPLOAD")?"disabled":"")%>>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="exit1" value="回上頁" style="font-family:'細明體'" onClick="setSubmit1('../jsp/TSPCOrderReviseRequest.jsp')">
		<!--<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();' <%=(ACTION.equals("UPLOAD")?"disabled":"")%>>-->
		</TD>
	</TR>
</TABLE>
	</td>
	<td width="15%">&nbsp;</td>
	</tr>
</table>
<BR>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		if (VCHKED.equals(""))
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();
	
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D15-001("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			//out.println("sheetRows="+sheetRows);
				
			sql = "select tsc_order_revise_pc_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			if (!rs.next())
			{
				throw new Exception("No Data Found!!");
			}
			else
			{
				REQUESTNO=rs.getString(1);
			}
			rs.close();
			statement.close();
			
			if (rdo1.equals("1"))  //Pull in/Early Ship			
			{
				if (PLANTCODE.equals("006"))
				{
					sheetCols=43;
					i_statr_line=1;
				}
				else if (PLANTCODE.equals("010"))
				{
					sheetCols=21;
					i_statr_line=1;
				}
				else if (PLANTCODE.equals("005") || PLANTCODE.equals("008") || PLANTCODE.equals("011"))  //add by Peggy 20221107
				{
					sheetCols=13;
					i_statr_line=1;
				}				
				else if (PLANTCODE.equals("002")) //add by Peggy 20221107
				{
					sheetCols=31;
					i_statr_line=3;
				}
				else
				{
					sheetCols=0;
				}
			}
			else if (rdo1.equals("2"))
			{
				if (PLANTCODE.equals("002")) //add by Peggy 20221107
				{
					sheetCols=40;
					i_statr_line=3;
				}
				else if (PLANTCODE.equals("005") || PLANTCODE.equals("008") || PLANTCODE.equals("011"))  //add by Peggy 20221107
				{
					sheetCols=18;
					i_statr_line=1;
				}				
				else
				{	
					sheetCols=31;
					i_statr_line=1;
				}
			}
			else
			{
				sheetCols=0;
			}
			sheetRows=sht.getRows()-i_statr_line;
			String strarray[][]=new String [sheetRows][8];
			//out.println("sheetRows="+sheetRows);
			for (i = 0 ; i <sheetRows; i++) 
			{
				irow=0;
				for (j = 0 ; j < sheetCols ; j++)
				{
					if (rdo1.equals("1"))  //Pull in/Early Ship
					{
						if (PLANTCODE.equals("006"))
						{				
							if (j==0 || j==2 || j==40 || j==41 || j==42)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=40 && j!=41)
								{
									vStr = (strCell.getContents()).trim();
									if (j==0)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
								}
								if (j==41)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"日期格式錯誤<br>";
									}
								}
								else if ( j==40)
								{
									if (strCell.getType() == CellType.NUMBER) 
									{
										vStr = (new DecimalFormat("#######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤<br>";
									}
								}
		
								if (j==0)
								{
									strarray[i][0]=vStr;
								}
								else if (j==2)
								{
									strarray[i][1]=vStr;
									strarray[i][2]="Early Ship";
									strarray[i][3]="Factory";
								}
								else if (j==40)
								{
									strarray[i][5]=vStr;
								}
								else if (j==41)
								{
									strarray[i][4]=vStr;
								}	
								else if (j==42)
								{
									strarray[i][6]=vStr;
								}											
							}
						}
						else if (PLANTCODE.equals("010"))
						{	
							if (j==0 || j==2 || j==18 || j==19 || j==20)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								//out.println((strCell.getContents()).trim());
								if (j !=18 && j!=19)
								{
									vStr = (strCell.getContents()).trim();
									if (j==0)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
								}
								if (j==19)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"日期格式錯誤<br>";
									}
								}
								else if (j==18)
								{
									if (strCell.getType() == CellType.NUMBER) 
									{
										vStr = (new DecimalFormat("#######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤<br>";
									}
								}
		
								if (j==0)
								{
									strarray[i][0]=vStr;
								}
								else if (j==2)
								{
									strarray[i][1]=vStr;
									strarray[i][2]="Early Ship";
									strarray[i][3]="Factory";
								}
								else if (j==18)
								{
									strarray[i][5]=vStr;
								}
								else if (j==19)
								{
									strarray[i][4]=vStr;
								}	
								else if (j==20)
								{
									strarray[i][6]=vStr;
								}											
							}
						}
						else if (PLANTCODE.equals("005") || PLANTCODE.equals("008") || PLANTCODE.equals("011"))
						{				
							if (j==0 || j==2 || j==11 || j==12)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=11 && j!=12)
								{
									vStr = (strCell.getContents()).trim();
									if (j==0)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
								}
								if (j==11)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"日期格式錯誤<br>";
									}
								}
								else if ( j==12)
								{
									if (strCell.getType() == CellType.NUMBER) 
									{
										vStr = (new DecimalFormat("#######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤<br>";
									}
								}
		
								if (j==0)
								{
									strarray[i][0]=vStr;
								}
								else if (j==2)
								{
									strarray[i][1]=vStr;
									strarray[i][2]="Early Ship";
									strarray[i][3]="Factory";
								}
								else if (j==11)
								{
									strarray[i][4]=vStr;
								}
								else if (j==12)
								{
									strarray[i][5]=vStr;
								}	
							}
						}
						else if (PLANTCODE.equals("002"))
						{				
							if (j==1 || j==2 || j==29 || j==30)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=29 && j!=30)
								{
									vStr = (strCell.getContents()).trim();
									if (j==1)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
								}
								if (j==29)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"日期格式錯誤<br>";
									}
								}
								else if ( j==30)
								{
									if (strCell.getType() == CellType.NUMBER) 
									{
										vStr = (new DecimalFormat("#######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤<br>";
									}
								}
		
								if (j==1)
								{
									strarray[i][0]=vStr;
								}
								else if (j==2)
								{
									strarray[i][1]=vStr;
									strarray[i][2]="Early Ship";
									strarray[i][3]="Factory";
								}
								else if (j==29)
								{
									strarray[i][4]=vStr;
								}
								else if (j==30)
								{
									strarray[i][5]=vStr;
								}	
							}
						}
					}
					else if (rdo1.equals("2"))  //Overdue/Early Warning
					{
						if (PLANTCODE.equals("002")) //add by Peggy 20221107
						{
							if (j==1 || j==3 || j==25|| j==28 || j==29 || j==38 || j==39)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=28 && j!=29)
								{
									vStr = (strCell.getContents()).trim();
									if (j==1)
									{
										v_mo=vStr;
									}
									else if (j==3)
									{
										v_line=vStr;
									}
									else if (j==25)
									{
										if (!vStr.toUpperCase().equals("OVERDUE") && !vStr.toUpperCase().equals("EARLY WARNING"))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   Type錯誤<br>";
										}
										else if (vStr.toUpperCase().equals("OVERDUE"))
										{
											vStr="Overdue";
										}
										else if (vStr.toUpperCase().equals("EARLY WARNING"))
										{
											vStr="Early Warning";
										}
									}
									else if (j==39 && (vStr==null || vStr.equals("")))
									{
										if (strarray[i][2].equals("Overdue") && strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											vStr="SALES HOLD";
										}
										else
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  請輸入原因<br>";
										}											
									}
								}
								if (j==28)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   日期格式錯誤("+vStr+")<br>";
									}
								}
								else if ( j==29)
								{
									if (strCell.getType() == CellType.NUMBER)  
									{
										vStr = (new DecimalFormat("######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										try
										{
											vStr=(strCell.getContents()).trim();
											int i_qty = Integer.parseInt(vStr);
										}
										catch(Exception e)
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤(("+(strCell.getContents()).trim()+")<br>";
										}
									}
								}
								strarray[i][irow]=vStr;
								irow++;
								if (j==25)
								{
									strarray[i][irow]="F";
									irow++;
								}
							}
						}
						else if (PLANTCODE.equals("005") || PLANTCODE.equals("008") || PLANTCODE.equals("011"))  //add by Peggy 20221107
						{
							if (j==0 || j==2 || j==11 || j==12 || j==13 || j==14 || j==15 || j==16)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=13 && j!=14)
								{
									vStr = (strCell.getContents()).trim();
									if (j==0)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
									else if (j==11)
									{
										if (!vStr.toUpperCase().equals("OVERDUE") && !vStr.toUpperCase().equals("EARLY WARNING"))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   Type錯誤<br>";
										}
										else if (vStr.toUpperCase().equals("OVERDUE"))
										{
											vStr="Overdue";
										}
										else if (vStr.toUpperCase().equals("EARLY WARNING"))
										{
											vStr="Early Warning";
										}
									}
									else if (j==12)
									{
										if (vStr==null || vStr.equals(""))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  Ascription By請指定Factory或Sales<br>";
										}
										else if (!vStr.toUpperCase().startsWith("S") && !vStr.toUpperCase().startsWith("F"))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  Ascription By請指定Factory或Sales<br>";
										}
									}
									else if (j==16 && (vStr==null || vStr.equals("")))
									{
										if (strarray[i][2].equals("Overdue") && strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											vStr="SALES HOLD";
										}
										else
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  請輸入原因<br>";
										}										
									}
								}
								if (j==13)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										if (!strarray[i][2].equals("Overdue") || !strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   日期格式錯誤("+vStr+")<br>";
										}
										else
										{
											sql = " SELECT to_char(SCHEDULE_SHIP_DATE,'yyyy/mm/dd')"+
												  " FROM ONT.OE_ORDER_LINES_ALL A"+
												  " WHERE A.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END"+
												  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_HEADERS_ALL B WHERE B.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END AND B.ORDER_NUMBER=? AND B.HEADER_ID=A.HEADER_ID)"+
												  " AND A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER=?";
											PreparedStatement statement1 = con.prepareStatement(sql);
											statement1.setString(1,strarray[i][0]);
											statement1.setString(2,strarray[i][0]);
											statement1.setString(3,strarray[i][0]);
											statement1.setString(4,strarray[i][1]);
											ResultSet rs1=statement1.executeQuery();
											if (rs1.next())
											{	
												vStr = rs1.getString(1);		
											}
											rs1.close();
											statement1.close();
										}										
									}
								}
								else if ( j==14)
								{
									if (strCell.getType() == CellType.NUMBER)  
									{
										vStr = (new DecimalFormat("######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										if (!strarray[i][2].equals("Overdue") || !strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{									
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤("+(strCell.getContents()).trim()+")<br>";
										}
										else
										{
											sql = " SELECT A.ORDERED_QUANTITY"+
												  " FROM ONT.OE_ORDER_LINES_ALL A"+
												  " WHERE A.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END"+
												  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_HEADERS_ALL B WHERE B.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END AND B.ORDER_NUMBER=? AND B.HEADER_ID=A.HEADER_ID)"+
												  " AND A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER=?";
											PreparedStatement statement1 = con.prepareStatement(sql);
											statement1.setString(1,strarray[i][0]);
											statement1.setString(2,strarray[i][0]);
											statement1.setString(3,strarray[i][0]);
											statement1.setString(4,strarray[i][1]);
											ResultSet rs1=statement1.executeQuery();
											if (rs1.next())
											{	
												vStr = rs1.getString(1);		
											}
											rs1.close();
											statement1.close();
										
										}
									}
								}
		
								strarray[i][irow]=vStr;
								irow++;
							}
						}				
						else
						{					
							if (j==0 || j==2 || j==25 || j==26 || j==27 || j==28 || j==29 || j==30)
							{
								jxl.Cell strCell= sht.getCell(j, i+i_statr_line);
								if (j !=27 && j!=28)
								{
									vStr = (strCell.getContents()).trim();
									if (j==0)
									{
										v_mo=vStr;
									}
									else if (j==2)
									{
										v_line=vStr;
									}
									else if (j==25)
									{
										if (!vStr.toUpperCase().equals("OVERDUE") && !vStr.toUpperCase().equals("EARLY WARNING"))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   Type錯誤<br>";
										}
										else if (vStr.toUpperCase().equals("OVERDUE"))
										{
											vStr="Overdue";
										}
										else if (vStr.toUpperCase().equals("EARLY WARNING"))
										{
											vStr="Early Warning";
										}
									}
									else if (j==26)
									{
										if (vStr==null || vStr.equals(""))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  Ascription By請指定Factory或Sales<br>";
										}
										else if (!vStr.toUpperCase().startsWith("S") && !vStr.toUpperCase().startsWith("F"))
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  Ascription By請指定Factory或Sales<br>";
										}
									}
									else if (j==30 && (vStr==null || vStr.equals("")))
									{
										if (strarray[i][2].equals("Overdue") && strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											vStr="SALES HOLD";
										}
										else
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"  請輸入原因<br>";
										}
									}
								}
								if (j==27)
								{
									if (strCell.getType() == CellType.DATE)
									{
										DateCell vdate = (DateCell)strCell;
										java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
										SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
										vStr=sy1.format(ReqDate); 
									}
									else
									{
										if (!strarray[i][2].equals("Overdue") || !strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   日期格式錯誤("+vStr+")<br>";
										}
										else
										{
											sql = " SELECT to_char(SCHEDULE_SHIP_DATE,'yyyy/mm/dd')"+
                                                  " FROM ONT.OE_ORDER_LINES_ALL A"+
                                                  " WHERE A.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END"+
                                                  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_HEADERS_ALL B WHERE B.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END AND B.ORDER_NUMBER=? AND B.HEADER_ID=A.HEADER_ID)"+
                                                  " AND A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER=?";
											PreparedStatement statement1 = con.prepareStatement(sql);
											statement1.setString(1,strarray[i][0]);
											statement1.setString(2,strarray[i][0]);
											statement1.setString(3,strarray[i][0]);
											statement1.setString(4,strarray[i][1]);
											ResultSet rs1=statement1.executeQuery();
											if (rs1.next())
											{	
												vStr = rs1.getString(1);		
											}
											rs1.close();
											statement1.close();
										}
									}
								}
								else if ( j==28)
								{
									if (strCell.getType() == CellType.NUMBER)  
									{
										vStr = (new DecimalFormat("######")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
									}
									else
									{
										if (!strarray[i][2].equals("Overdue") || !strarray[i][3].startsWith("S")) //add by Peggy 20221110
										{
											err_msg += "ROW#"+(i+i_statr_line)+"  MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤("+(strCell.getContents()).trim()+")<br>";
										}
										else
										{	
											sql = " SELECT a.ordered_quantity"+
                                                  " FROM ONT.OE_ORDER_LINES_ALL A"+
                                                  " WHERE A.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END"+
                                                  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_HEADERS_ALL B WHERE B.ORG_ID=CASE SUBSTR(?,1,1) WHEN '4' THEN 325 WHEN '8' THEN 906 ELSE 41 END AND B.ORDER_NUMBER=? AND B.HEADER_ID=A.HEADER_ID)"+
                                                  " AND A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER=?";
											PreparedStatement statement1 = con.prepareStatement(sql);
											statement1.setString(1,strarray[i][0]);
											statement1.setString(2,strarray[i][0]);
											statement1.setString(3,strarray[i][0]);
											statement1.setString(4,strarray[i][1]);
											ResultSet rs1=statement1.executeQuery();
											if (rs1.next())
											{	
												vStr = rs1.getString(1);		
											}
											rs1.close();
											statement1.close();
										}																		
									}
								}
		
								strarray[i][irow]=vStr;
								irow++;
							}
						}
					}
					else
					{
						throw new Exception("Request Type error!");
					}
				}
			}
			wb.close();
			
			if (!err_msg.equals(""))
			{
				throw new Exception();
			}		
			for (i =0 ; i < strarray.length; i++) 
			{	
				if (strarray[i][4]==null || strarray[i][5]==null)
				{
					 throw new Exception("total line:"+strarray.length+ "  MO#"+strarray[i][0]+"  LINE#"+strarray[i][1]+ " data error!");
				}
				//out.println(strarray[i][6]);
				sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
					  "(REQUEST_NO"+
					  ",REQUEST_TYPE"+
					  ",SEQ_ID"+
					  ",SO_NO"+
					  ",LINE_NO"+
					  ",PLANT_CODE"+
					  ",SO_QTY"+
					  ",SCHEDULE_SHIP_DATE"+
					  ",REASON_DESC"+
					  ",REMARKS"+
					  ",ASCRIPTION_BY"+
					  ",CREATED_BY"+
					  ",CREATION_DATE"+
					  ")"+
					  " values"+
					  " ("+
					  " ?"+
					  ",?"+
					  ",APPS.PC_ORDER_REVISE_SEQ_ID_S.NEXTVAL"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",to_date(?,'yyyy/mm/dd')"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  " )";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				//out.println(strarray[i][5]);
				//out.println(strarray[i][4]);
				//out.println(strarray[i][3]);
				//out.println(strarray[i][2]);
				//out.println(strarray[i][1]);
				//out.println(strarray[i][0]);
				pstmtDt.setString(1,REQUESTNO);
				pstmtDt.setString(2,strarray[i][2]);
				pstmtDt.setString(3,strarray[i][0]);
				pstmtDt.setString(4,strarray[i][1]);
				pstmtDt.setString(5,PLANTCODE);
				pstmtDt.setString(6,strarray[i][5]);
				pstmtDt.setString(7,strarray[i][4]);
				pstmtDt.setString(8,(strarray[i][7]==null?"":strarray[i][7]));
				pstmtDt.setString(9,(strarray[i][6]==null?"":strarray[i][6]));
				pstmtDt.setString(10,((strarray[i][3].toUpperCase().startsWith("F")?"Factory":(strarray[i][3].toUpperCase().startsWith("S")?"Sales":""))));
				pstmtDt.setString(11,UserName);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
			}
			con.commit();
			
			sql = " SELECT B.SO_NO"+
				  ",B.LINE_NO"+
				  ",B.ITEM_DESC"+
				  ",TO_CHAR(B.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') NEW_SSD"+
				  ",B.CREATED_BY"+
				  ",TO_CHAR(B.CREATION_DATE,'YYYY/MM/DD HH24:MI') CREATION_DATE"+
				  ",ROW_NUMBER() OVER (PARTITION BY B.SO_NO,B.LINE_NO ORDER BY B.SCHEDULE_SHIP_DATE) LINE_ROW_SEQ"+
				  ",COUNT(1) OVER (PARTITION BY B.SO_NO,B.LINE_NO) LINE_ROW_CNT"+
				  ",ROW_NUMBER() OVER (ORDER BY B.SEQ_ID) ROW_SEQ"+
				  " FROM ORADDMAN.TSC_OM_SALESORDERREVISE_PC_TMP A"+
				  ",ORADDMAN.TSC_OM_SALESORDERREVISE_PC B"+
				  " WHERE A.REQUEST_NO=?"+
				  " AND A.REQUEST_TYPE=?"+
				  " AND A.REQUEST_NO<>B.REQUEST_NO"+
				  " AND A.REQUEST_TYPE=B.REQUEST_TYPE"+
				  " AND A.SO_NO=B.SO_NO"+
				  " AND A.LINE_NO=B.LINE_NO"+
				  " AND B.STATUS=?"+
				  " ORDER BY B.SEQ_ID";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,REQUESTNO);
			statement1.setString(2,"Early Ship");
			statement1.setString(3,"AWAITING_CONFIRM");
			ResultSet rs1=statement1.executeQuery();
			v_exist_cnt =0;
			while (rs1.next())
			{
				if (rs1.getInt("ROW_SEQ")==1)
				{
					out.println("<table width='100%'><tr><td width='15%'>&nbsp;</td><td width='70%'><table width='100%'>");
					out.println("<tr style='color:#000000'>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>MO#</td>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>LINE#</td>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>TSC PARTNO</td>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>NEW SSD</td>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>CREATED BY</td>");
					out.println("<td style='border-bottom-style:solid;border-bottom-color:#000000'>CREATION DATE</td>");
					out.println("</tr>");
				}
				out.println("<tr style='color:#000000'>");
				out.println("<td>"+rs1.getString("SO_NO")+"</td><td>"+rs1.getString("LINE_NO")+"</td><td>"+rs1.getString("ITEM_DESC")+"</td><td>"+rs1.getString("NEW_SSD")+"</td><td>"+rs1.getString("CREATED_BY")+"</td><td>"+rs1.getString("CREATION_DATE")+"</td>");
				out.println("</tr>");
				v_exist_cnt = rs1.getInt("ROW_SEQ");
			}
			rs1.close();
			statement1.close();
		}
		
		if (v_exist_cnt>0)
		{
			out.println("<tr><td colspan='6' align='center' style='color:#0000ff'>系統檢查到以上訂單有前次Early Ship申請記錄,若確定要更版,請按[繼續]鍵,否則,按[取消]重新申請,謝謝!</td></tr>");
			out.println("<tr><td colspan='6' align='center'>");
			out.println("<input type='button' name='conti' value='繼續' onClick='setSubmit2("+'"'+"../jsp/TSPCOrderReviseUpload.jsp?ACTION=UPLOAD&PLANT="+PLANTCODE+"&rdo1="+rdo1+"&VCHKED=Y&REQUESTNO="+REQUESTNO+'"'+")'>");
			out.println("&nbsp;&nbsp;");
			out.println("<input type='button' name='cancel' value='取消' onClick='setSubmit2("+'"'+"../jsp/TSPCOrderReviseUpload.jsp?PLANT="+PLANTCODE+"&rdo1="+rdo1+'"'+")'></td></tr>");
			out.println("</table></td><td width='15%'>&nbsp;</td>");
			out.println("</tr>");
			out.println("</table>");
		}
		
		if (v_exist_cnt==0 && !REQUESTNO.equals(""))
		{
			CallableStatement cs = con.prepareCall("{call tsc_order_revise_pc_pkg.revise_data_check(?,?,?)}");
			cs.setString(1,REQUESTNO);
			cs.setString(2,PLANTCODE);
			cs.registerOutParameter(3, Types.VARCHAR);
			cs.execute();
			v_result = (cs.getString(3)==null?"":cs.getString(3)); 
			cs.close();
	
			if (v_result.equals("ERROR"))
			{
				err_cnt=0;
				Statement statement=con.createStatement();
				sql = " select ROW_NUMBER() OVER (PARTITION BY REQUEST_NO ORDER BY seq_id) SEQ,'MO#'||SO_NO ,'Line#'||LINE_NO, 'SSD:'||TO_CHAR(SCHEDULE_SHIP_DATE,'YYYY/MM/DD'),'QTY:'||SO_QTY, ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
					  " WHERE REQUEST_NO='"+REQUESTNO+"' and STATUS='ERR' ORDER BY SEQ_ID";
				ResultSet rs=statement.executeQuery(sql);
				ResultSetMetaData md=rs.getMetaData();
				while (rs.next())
				{
					if (rs.getInt(1)==1) out.println("<div style='color:#FF0000;font-size:12px'>Upload Fail~~</div><table width='100%'>");
					out.println("<tr style='color:#FF0000'>");
					out.println("<td>Row#"+(rs.getInt(1)+1)+":</td>");
					for (j = 2 ; j <= md.getColumnCount() ; j++)
					{
						out.println("<td>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
					}
					out.println("</tr>");
					err_cnt++;
				}
				rs.close();
				statement.close();
				out.println("</table>");
				if (err_cnt==0)
				{
					out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>申請失敗!!請洽系統管理人員</div>");
				}
				else
				{
					throw new Exception("Error!!");
				}
			}
			else
			{
				//out.println("<div align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>申請成功!!申請單號:"+REQUESTNO+"</div>");
				err_cnt=0;
				Statement statement=con.createStatement();
				sql = " select ROW_NUMBER() OVER (PARTITION BY REQUEST_NO ORDER BY seq_id) SEQ,'MO#'||SO_NO ,'Line#'||LINE_NO, 'SSD:'||TO_CHAR(SCHEDULE_SHIP_DATE,'YYYY/MM/DD'),'QTY:'||SO_QTY, ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
					  " WHERE REQUEST_NO='"+REQUESTNO+"' and STATUS='ERR' ORDER BY SEQ_ID";
				ResultSet rs=statement.executeQuery(sql);
				ResultSetMetaData md=rs.getMetaData();
				while (rs.next())
				{
					if (rs.getInt(1)==1) out.println("<div align='center' style='color:#FF0000;font-size:12px'>以下訂單未申請成功,錯誤原因如下說明~~</div><table align='center' width='100%'>");
					out.println("<tr style='color:#FF0000'>");
					out.println("<td>Row#"+(rs.getInt(1)+1)+":</td>");
					for (j = 2 ; j <= md.getColumnCount() ; j++)
					{
						out.println("<td>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
					}
					err_cnt++;
					out.println("</tr>");
				}
				rs.close();
				statement.close();
				out.println("</table>");	
				
				if (err_cnt==0)
				{
					out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>申請成功!!申請單號:"+REQUESTNO+"</div>");
				}
				else
				{
					statement=con.createStatement();
					sql = " select COUNT(1) from oraddman.TSC_OM_SALESORDERREVISE_PC  WHERE REQUEST_NO='"+REQUESTNO+"'";
					rs=statement.executeQuery(sql);
					if (rs.next())
					{	
						if (rs.getInt(1)>0)
						{
							out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>剩餘其他訂單已申請成功!申請單號:"+REQUESTNO+"</div>");
						}
					}
					rs.close();
					statement.close();			
				}	
				out.println("<p><div align='center'><a onClick='setSubmit1("+'"'+"../jsp/TSPCOrderReviseQuery.jsp?REQUESTNO="+REQUESTNO+'"'+")'>回PC申請變更訂單歷程查詢</a></div>");
	%>
		<script language="JavaScript" type="text/JavaScript">
			document.SUBFORM.upload.disabled=false;
			document.SUBFORM.exit1.disabled=false;
			//subWin=window.open("../jsp/TSPCOrderReviseConfirmExcel.jsp?ACTTYPE=AUTO&NEW_REQ=<%=REQUESTNO%>","subwin"); 
		</script>	
	<%		
			}
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>"+(err_msg.equals("")?e.getMessage():err_msg)+"</div>");
%>
	<script language="JavaScript" type="text/JavaScript">
		document.SUBFORM.upload.disabled=false;
		document.SUBFORM.exit1.disabled=false;
	</script>	
<%
}
%>
<!--%表單參數%-->
<input type="hidden" name="PLANT" value="<%=PLANTCODE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
