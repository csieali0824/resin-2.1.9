<%@ page contentType="text/html; charset=utf-8" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,org.apache.commons.net.ftp.FTP,org.apache.commons.net.ftp.FTPClient"%>
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
	window.opener.document.MYFORM.submit();
}
function setClose()
{
	//window.opener.document.getElementById("alpha").style.width="0px";
	//window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
</script>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="",v_reqno="",v_factory="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",batch_id="";
int sheetRows=0,sheetCols=10,i=0,j=0,irow=0,rowcnt=0;
String strarray[]=new String [sheetCols];
DateCell vdate=null;
SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>Notice:upload excel file must be 2003 format!!</td>
	</tr>
	<tr>
		<td>
			<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
				<TR>
					<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
					<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
				</TR>
				<TR>
					<TD colspan="2" align="center">
					<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCRelabelRequest.jsp?ACTION=UPLOAD")'>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
					</TD>
				</TR>
			</TABLE>
		</td>
	</tr>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\Z3-001("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
								
		for (i = 1 ; i <=sheetRows; i++) 
		{
			for (j = 0 ; j < sheetCols ; j++)
			{
				strarray[j]=null;
				
				try
				{
					jxl.Cell strCell= sht.getCell(j, i);
					if (j == 7 )
					{
						if (strCell.getType() == CellType.NUMBER) 
						{ 
							vStr =""+((NumberCell)strCell).getValue();
						}
						else
						{
							throw new Exception("The field("+j+") must be number format!!");	
						}
					} 
					else
					{
						vStr = (strCell.getContents()).trim();
						if (vStr != null && !vStr.equals("") && vStr.substring(0,1).equals("'"))
						{
							vStr = vStr.substring(1);
						}
					}
					if (j==1 || j==2 || j==5 || j==6 || j==7)
					{
						if (vStr ==null || vStr.equals(""))
						{
 							throw new Exception("The field("+j+") must be input a value!!");
						}
					}
				}
				catch(Exception e)
				{	
					throw new Exception(e.getMessage());
				}
				strarray[j]=vStr;
			}
			
			sql = " select attribute3 from inv.mtl_system_items_b a "+
			      " where a.organization_id=?"+
				  " and a.segment1=?"+
				  " and a.description=?";
			PreparedStatement statementp = con.prepareStatement(sql);
			statementp.setInt(1,49);			
			statementp.setString(2,strarray[1]);
			statementp.setString(3,strarray[2]);
			ResultSet rsp=statementp.executeQuery();
			if (!rsp.next())
			{
				rsp.close();
				statementp.close();
				throw new Exception("Item Name:"+strarray[1]+" Item Desc:"+strarray[2]+" 查無料號資料!!");				
			}
			else
			{
			
				v_factory="";
				PreparedStatement statementx = con.prepareStatement(" select 'YEW' from yew_runcard_all a where a.runcard_no=?"+
				                                                    " union all"+
																	" select 'A01' from insitea01_oltp.TSC_SALES_ORDER_VIEW@prod_a01oltp a where a.LOT_NO=?"+
																	" union all"+
																	" select 'TEW' from tsc.tsc_pick_confirm_lines a where lot=? and a.TEW_ADVISE_NO is not null"+
																	" union all"+
																	" select 'ILANHUB' from tsc.tsc_pick_confirm_lines a where lot=? and a.TEW_ADVISE_NO is null and a.ORGANIZATION_ID<>?");
				statementx.setString(1,strarray[5]);
				statementx.setString(2,strarray[5]);
				statementx.setString(3,strarray[5]);	
				statementx.setString(4,strarray[5]);											
				statementx.setString(5,"606");
				ResultSet rsx=statementx.executeQuery();
				if (!rsx.next())
				{
					rsx.close();
					statementx.close();
					throw new Exception("Item Name:"+strarray[1]+" Item Desc:"+strarray[2]+" LOT:"+ strarray[5]+" 查無LOT資料!!");
				}
				else
				{
					v_factory =rsx.getString(1);
				}
				rsx.close();
				statementx.close();			
			}
			rsp.close();
			statementp.close();				  
			
			if (v_reqno.equals(""))
			{
				sql = " select lpad(nvl(max(substr(req_no,8,9)),0)+1,2,'0') from oraddman.ts_relabel_request a "+
					  " where substr(a.req_no,1,7) =?";
				PreparedStatement statementa = con.prepareStatement(sql);
				statementa.setString(1,"R"+strDate.substring(2));			
				ResultSet rsa=statementa.executeQuery();
				if (rsa.next())
				{
					v_reqno = "R"+strDate.substring(2)+rsa.getString(1);
				}			
				else
				{
					v_reqno = "R"+strDate.substring(2)+"01";
				}
				rsa.close();
				statementa.close();					
			}
			sql = " insert into oraddman.ts_relabel_request "+
				  "(req_no"+
				  ",req_seq"+
				  ",shipping_marks"+
				  ",item_name"+
				  ",item_desc"+
				  ",cust_pn"+
				  ",cust_po"+
				  ",lot_number"+
				  ",date_code"+
				  ",quantity"+
				  ",carton_number"+
				  ",creation_date"+
				  ",created_by"+
				  ",factory_code"+
				  ",active_flag"+    
				  ",sales_region"+
				  ")"+
				  " values"+
				  " ("+
				  " ?"+                  //0
				  ",APPS.TS_RELABEL_REQUEST_S.nextval"+            //1 
				  ",?"+                  //2
				  ",?"+                  //3
				  ",?"+                  //4
				  ",?"+                  //5
				  ",?"+                  //6
				  ",?"+                  //7
				  ",?"+                  //8
				  ",?"+                  //9
				  ",?"+                  //10
				  ",SYSDATE"+            //11
				  ",?"+                  //12
				  ",?"+                  //13
				  ",?"+                  //14
				  ",?"+                  //15
				  " )";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,v_reqno);
			pstmtDt.setString(2,strarray[0]);
			pstmtDt.setString(3,strarray[1]);
			pstmtDt.setString(4,strarray[2]);
			pstmtDt.setString(5,strarray[3]);
			pstmtDt.setString(6,strarray[4]);
			pstmtDt.setString(7,strarray[5]);
			pstmtDt.setString(8,strarray[6]);
			pstmtDt.setString(9,strarray[7]);
			pstmtDt.setString(10,strarray[8]);
			pstmtDt.setString(11,UserName);
			pstmtDt.setString(12,v_factory);	
			pstmtDt.setString(13,"A");	
			pstmtDt.setString(14,strarray[9]);									
			pstmtDt.executeQuery();
			pstmtDt.close();	
			irow++;	

		}
		wb.close();
	}
	if (irow>0)
	{
		con.commit();
		out.println("<div style='color:#00ff;font-family:Tahoma,Georgia;font-size:14px'>Upload Successfully!!<br>Request#"+v_reqno+"</div>");
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Record#"+i+":"+e.getMessage()+"</div>");
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
