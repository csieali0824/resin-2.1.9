<%@ page import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0%";
		window.opener.document.getElementById("alpha").style.height="0px";
		window.close();				
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("Please choose a source file!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('excel must be a .xls file !');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0%";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="",ItemName="",OrgName="",OrgID="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="25%" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Please choose source file&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Download Sample File&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/H11-001_SampleFile.xls"><font face="Tahoma,Georgia" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../jsp/TSCSGForecastItemUpload.jsp?ACTION=UPLOAD")' style="font-family:Tahoma,Georgia">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" onClick='setClose();' style="font-family:Tahoma,Georgia">
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H11-001("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			PreparedStatement statement9 =null;
			ResultSet rs9=null;
			String arrylist [][] = new String[sht.getRows()-1][3];
			
			for (int i = 1 ; i <sht.getRows(); i++) 
			{
				//ORGANIZATION_CODE
				OrgID="";
				jxl.Cell wcOrgName = sht.getCell(0, i);          
				OrgName = (wcOrgName.getContents()).trim();
				if (OrgName  == null) OrgName = "";
				if (OrgName.equals(""))
				{
					throw new Exception("Row#"+(i+1)+":org name must be input!!");
				}
				else if (!OrgName.equals("SG1") && !OrgName.equals("SG2"))
				{
					throw new Exception("Row#"+(i+1)+":org name must be SG1 or SG2!!");
				}
							
				//料號
				jxl.Cell wcItemName = sht.getCell(1, i);          
				ItemName = (wcItemName.getContents()).trim();
				if (ItemName  == null) ItemName = "";
				if (ItemName.equals(""))
				{
					throw new Exception("Row#"+(i+1)+":item name must be input!!");
				}
				else
				{
					sql = " select a.segment1,(select count(1) from inv.mtl_system_items_b x,inv.mtl_parameters y where x.organization_id=y.organization_id and x.inventory_item_id=a.inventory_item_id and y.organization_code=?) sg_flag"+
					      ",(select organization_id from inv.mtl_parameters z where z.organization_code=?) organization_id"+
					      " from  inv.mtl_system_items_b a"+
						  " where a.organization_id=?"+
						  " and a.segment1=? ";
					statement9 = con.prepareStatement(sql);
					statement9.setString(1,OrgName);
					statement9.setString(2,OrgName);
					statement9.setString(3,"43");
					statement9.setString(4,ItemName);
					rs9=statement9.executeQuery();
					if (rs9.next())
					{
						if (rs9.getInt("sg_flag")==0)
						{
							throw new Exception("Row#"+(i+1)+":"+ItemName+" not assign to SG");
						}
						OrgID = rs9.getString("organization_id");
					}
					else
					{
						throw new Exception("Row#"+(i+1)+":"+ItemName+" not found");
					}
					rs9.close();
					statement9.close();
				}
				arrylist[i-1][0]=OrgID;
				arrylist[i-1][1]=OrgName;
				arrylist[i-1][2]=ItemName;
			}
			wb.close();
			
			//truncate table TSSG_FORECAST_ITEM_TEMP
			sql = " truncate table oraddman.tssg_forecast_item_temp";
			PreparedStatement pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.executeUpdate();
			pstmtDt1.close();	
			
			for (int j =0 ; j < arrylist.length ; j++)
			{
				sql = " insert into oraddman.tssg_forecast_item_temp"+
				       " values(?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",sysdate"+
					   ",null)";
				pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,arrylist[j][0]);
				pstmtDt1.setString(2,arrylist[j][1]);
				pstmtDt1.setString(3,arrylist[j][2]);
				pstmtDt1.setString(4,UserName);
				pstmtDt1.executeQuery();
				pstmtDt1.close();	
				
				sql = " insert into oraddman.tssg_forecast_item_history"+
				       " select ?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",sysdate"+
					   ",?"+
					   ",sysdate "+
					   " from dual"+
					   " where not exists (select 1 from oraddman.tssg_forecast_item_history x"+
					   "               where x.organization_id=?"+
					   "                and x.item_name=?)";
				pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,arrylist[j][0]);
				pstmtDt1.setString(2,arrylist[j][1]);
				pstmtDt1.setString(3,arrylist[j][2]);
				pstmtDt1.setString(4,UserName);
				pstmtDt1.setString(5,UserName);
				pstmtDt1.setString(6,arrylist[j][0]);
				pstmtDt1.setString(7,arrylist[j][2]);
				pstmtDt1.executeQuery();
				pstmtDt1.close();						
			}
			
			String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
			pstmtNLS.executeUpdate(); 
			pstmtNLS.close();
			
			CallableStatement cs1 = con.prepareCall("{call tssg_inv_pkg.item_update_job(?)}");
			cs1.setString(1,UserName); 	
			cs1.execute();
			cs1.close();			
			con.commit();
			
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.submit();
				setClose();		
			</script>
	<%				
			
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>The action fail,error cause is..<br>"+e.getMessage()+"</div>");
		}
	}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
