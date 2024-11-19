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
String vStr="",REQUESTNO="",v_mo="",v_line="",err_msg="",v_result="" ;
int sheetRows=0,sheetCols=21,i=0,j=0,irow=0,colnum=0,err_cnt=0;
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
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSW02OrderReviseUpload.jsp?ACTION=UPLOAD")'>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\N1-001("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		String strarray[][]=new String [sheetRows][sheetCols];
		
		sql = "select tsc_order_revise_w02_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual";
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
		
		for (i = 1 ; i <=sheetRows; i++) 
		{
			irow=0;
			for (j = 0 ; j < sheetCols ; j++)
			{
				if (j==2 || j==3 || j==17 || j==18 || j==19 || j==20)
				{
					vStr="";
					jxl.Cell strCell= sht.getCell(j, i);
					if (j==2 || j==3 || j==20)
					{
						vStr = (strCell.getContents()).trim();
						if (j==2)
						{
							v_mo=vStr;
						}
						else if (j==3)
						{
							v_line=vStr;
						}
						//out.println(vStr);
						if (j==2)
						{
							strarray[i-1][0]=vStr;
						}
						else if (j==3)
						{
							strarray[i-1][1]=vStr;
						}
						else if (j==20)  //add by Peggy 20220805
						{
							strarray[i-1][5]=vStr;
						}												
					}
					else if (j==17)
					{
						if (strCell.getContents()!="")
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
								err_msg += "MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"CRD日期格式錯誤<br>";
							}
						}
						strarray[i-1][2]=vStr;
					}					
					else if (j==18)
					{
						if (strCell.getContents()!="")
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
								err_msg += "MO#"+v_mo+"   Line#"+v_line+"   "+(strCell.getContents()).trim()+"SSD日期格式錯誤<br>";
							}
						}
						strarray[i-1][3]=vStr;
					}
					else if ( j==19)
					{
						if (strCell.getContents()!="")
						{
							if (strCell.getType() == CellType.NUMBER) 
							{
								vStr = (new DecimalFormat("#######.000")).format(Double.parseDouble(""+((NumberCell) strCell).getValue()));
							}
							else
							{
								err_msg += "MO#"+v_mo+"   Line#"+v_line+"   數量格式錯誤<br>";
							}
						}
						strarray[i-1][4]=vStr;
					}
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
			if (strarray[i][0]==null || strarray[i][1]==null) throw new Exception("data error!");
			
			sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_W02_T "+
				  "(REQUEST_NO"+
				  ",SEQ_ID"+
				  ",SO_NO"+
				  ",LINE_NO"+
				  ",SO_QTY"+
				  ",SCHEDULE_SHIP_DATE"+
				  ",CREATED_BY"+
				  ",CREATION_DATE"+
				  ",CUSTOMER_DOCK_CODE"+ //add by Peggy 20220805
				  ",REQUEST_DATE"+     //add by Peggy 20230113
				  ")"+
				  " values"+
				  " ("+
				  " ?"+
				  ",APPS.W02_ORDER_REVISE_SEQ_ID_S.NEXTVAL"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",to_date(?,'yyyy/mm/dd')"+
				  ",?"+
				  ",sysdate"+
				  ",?"+ //add by Peggy 20220805
				  ",to_date(?,'yyyy/mm/dd')"+ //add by Peggy 20230113
				  " )";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUESTNO);
			pstmtDt.setString(2,strarray[i][0]);
			pstmtDt.setString(3,strarray[i][1]);
			pstmtDt.setString(4,strarray[i][4]);
			pstmtDt.setString(5,strarray[i][3]);
			pstmtDt.setString(6,UserName);
			pstmtDt.setString(7,strarray[i][5]); //add by Peggy 20220805
			pstmtDt.setString(8,strarray[i][2]); //add by Peggy 20230113
			pstmtDt.executeQuery();
			pstmtDt.close();	
		}
		con.commit();
			
		if (!REQUESTNO.equals(""))
		{
			CallableStatement cs = con.prepareCall("{call tsc_order_revise_w02_pkg.revise_data_check(?,?)}");
			cs.setString(1,REQUESTNO);
			cs.registerOutParameter(2, Types.VARCHAR);
			cs.execute();
			v_result = (cs.getString(2)==null?"":cs.getString(2)); 
			cs.close();
	
			if (v_result.equals("ERROR"))
			{
				err_cnt=0;
				sql = " select ROWNUM SEQ,'MO#'||SO_NO ,'Line#'||LINE_NO,ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_W02_T "+
					  " WHERE REQUEST_NO='"+REQUESTNO+"' and STATUS='ERR' ORDER BY SEQ_ID";
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);					  
				ResultSetMetaData md=rs1.getMetaData();
				while (rs1.next())
				{
					if (rs1.getInt(1)==1) out.println("<div style='color:#FF0000;font-size:12px'>Upload Fail~~</div><table width='100%'>");
					out.println("<tr style='color:#FF0000'>");
					out.println("<td>Row#"+(rs1.getInt(1)+1)+":</td>");
					for (j = 2 ; j <= md.getColumnCount() ; j++)
					{
						out.println("<td>"+(rs1.getString(j)==null?"&nbsp;":rs1.getString(j))+"</tr>");
					}
					out.println("</tr>");
					err_cnt++;
				}
				rs1.close();
				statement1.close();
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
			
			out.println("<script language='JavaScript' type='text/JavaScript'>");
			out.println("window.opener.document.MYFORM.action="+'"'+"../jsp/TSW02OrderReviseRequest.jsp?ActionType=UPLOAD&REQNO="+REQUESTNO+'"'+";");
			out.println("window.opener.document.MYFORM.submit();");
			out.println("setClose();");
			out.println("</script>");			
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!<br>"+(err_msg.equals("")?e.getMessage():err_msg)+"</div>");
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
