<!-- 20151119 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160130 Peggy,add No Wafer Lead Time column-->
<!-- 20180802 Peggy,新增"停用/啟用"欄位-->
<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean,ComboBoxBean," %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0";
		window.opener.document.getElementById("alpha").style.height="0";
		window.close();				
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.PLANT_CODE.value ==null || document.SUBFORM.PLANT_CODE.value=="" || document.SUBFORM.PLANT_CODE.value=="--")
	{
		alert("請選擇生產廠區!");
		return false;	
	}
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL+"&PLANT_CODE="+document.SUBFORM.PLANT_CODE.value;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0";
	window.opener.document.getElementById("alpha").style.height="0";
	window.close();				
}
</script>
<title>Excel Upload</title>
</head>
<%
String PLANT_CODE = request.getParameter("PLANT_CODE");
if (PLANT_CODE==null) PLANT_CODE="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="",TSC_PROD_GROUP="",TSC_FAMILY="",TSC_PROD_FAMILY="",TSC_PACKAGE="",ITEM_DESC="",LEAD_TIME="",LEAD_TIME_NOWAFER="",LEAD_TIME_UOM="WEEK",ACTIVE_FLAG="",S_VOLTAGE="",E_VOLTAGE="",V_BATCH_ID="",REMARKS="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int start_row=1,v_found_cnt=0;

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#CCCCCC">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;生產廠區&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong>
		<%
		try
		{
			sql = " select a.manufactory_no,a.manufactory_no || ' '||a.manufactory_name manufactory_name from oraddman.tsprod_manufactory a where MANUFACTORY_NO in ('002','005','006','008','010','011')";
			if (UserRoles.indexOf("admin")<0)
			{
				sql += " and MANUFACTORY_NO='"+userProdCenterNo+"'";
				PLANT_CODE = userProdCenterNo;
			}
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(PLANT_CODE);
			comboBoxBean.setFieldName("PLANT_CODE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</strong></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/D3-009_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSDRQProdLeadTimeUpload.jsp?ACTION=UPLOAD")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
					
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D3-009("+PLANT_CODE+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(" SELECT TS_LEADTIME_BATCH_ID_S.nextval from dual");
			if (rs1.next())
			{
				V_BATCH_ID = rs1.getString(1);
			}
			else
			{
				throw new Exception("BATCH_ID取得失敗!!");
			}
			rs1.close();
			statement1.close();	
						
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				//TSC PROD GROUP
				jxl.Cell wcTSCPRODGROUP = sht.getCell(0, i);          
				TSC_PROD_GROUP = (wcTSCPRODGROUP.getContents()).trim();
				if (TSC_PROD_GROUP == null) TSC_PROD_GROUP = "";
				if (TSC_PROD_GROUP.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Prod Group不可空白!!");
				}
				else
				{
					sql = "SELECT 1  FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_GROUP' AND DISABLE_DATE IS NULL and SEGMENT1=?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,TSC_PROD_GROUP);
					ResultSet rs=statement.executeQuery();
					if (!rs.next())					 
					{
						throw new Exception("第"+(i+1)+"列:"+TSC_PROD_GROUP+"查無此Prod Group!!");
					}	
					rs.close();	
					statement.close();				
				}
								
				//型號
				jxl.Cell wcITEMDESC = sht.getCell(4, i);  
				ITEM_DESC = (wcITEMDESC.getContents()).trim();
				if (ITEM_DESC== null)ITEM_DESC = "";
				if (!ITEM_DESC.equals(""))
				{
					sql = " select tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Family') tsc_family,tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_FAMILY') tsc_prod_family,tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') tsc_package "+
					      " from inv.mtl_system_items_b a where description =?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ITEM_DESC);
					ResultSet rs=statement.executeQuery();
					if (!rs.next())					 
					{
						throw new Exception("第"+(i+1)+"列:"+ITEM_DESC+"查無此型號!!");
					}	
					else
					{
						TSC_FAMILY = rs.getString(1);
						TSC_PROD_FAMILY = rs.getString(2);
						TSC_PACKAGE = rs.getString(3);
					}
					
					rs.close();	
					statement.close();
				}
				else
				{
					//TSC FAMILY
					jxl.Cell wcTSCFAMILY = sht.getCell(1, i);  
					TSC_FAMILY = (wcTSCFAMILY.getContents()).trim();
					if (TSC_FAMILY == null) TSC_FAMILY = "";
					if (TSC_FAMILY.equals(""))
					{
						throw new Exception("第"+(i+1)+"列:Family不可空白!!");
					}	
					else
					{
						sql = "SELECT 1  FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Family' AND DISABLE_DATE IS NULL and SEGMENT1=?";
						PreparedStatement statement = con.prepareStatement(sql);
						statement.setString(1,TSC_FAMILY);
						ResultSet rs=statement.executeQuery();
						if (!rs.next())					 
						{
							throw new Exception("第"+(i+1)+"列:"+TSC_FAMILY+"查無此Family!!");
						}	
						rs.close();	
						statement.close();				
					}
					
					//TSC PROD FAMILY
					jxl.Cell wcTSCPRODFAMILY = sht.getCell(2, i);  
					TSC_PROD_FAMILY = (wcTSCPRODFAMILY.getContents()).trim();
					if (TSC_PROD_FAMILY == null) TSC_PROD_FAMILY = "";
					if (TSC_PROD_GROUP.equals("PMD") || TSC_PROD_GROUP.equals("SSP") || TSC_PROD_GROUP.equals("SSD"))
					{
						if (TSC_PROD_FAMILY.equals(""))
						{
							throw new Exception("第"+(i+1)+"列:Prod Family不可空白!!");
						}	
						else
						{
							sql = "SELECT 1  FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_FAMILY' AND DISABLE_DATE IS NULL and SEGMENT1=?";
							PreparedStatement statement = con.prepareStatement(sql);
							statement.setString(1,TSC_PROD_FAMILY);
							ResultSet rs=statement.executeQuery();
							if (!rs.next())					 
							{
								throw new Exception("第"+(i+1)+"列:"+TSC_PROD_FAMILY+"查無此Prod Family!!");
							}	
							rs.close();	
							statement.close();				
						}
					}
					else
					{
						TSC_PROD_FAMILY ="";
					}
												
									
					//TSC PACKAGE
					jxl.Cell wcTSCPACKAGE = sht.getCell(3, i);  		   
					TSC_PACKAGE = (wcTSCPACKAGE.getContents()).trim();
					if (TSC_PACKAGE == null) TSC_PACKAGE = "";
					if (TSC_PACKAGE.equals(""))
					{
						throw new Exception("第"+(i+1)+"列:Package不可空白!!");
					}	
					else
					{
						sql = "SELECT 1  FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Package' AND DISABLE_DATE IS NULL and SEGMENT1=?";
						PreparedStatement statement = con.prepareStatement(sql);
						statement.setString(1,TSC_PACKAGE);
						ResultSet rs=statement.executeQuery();
						if (!rs.next())					 
						{
							throw new Exception("第"+(i+1)+"列:"+TSC_PACKAGE+"查無此Package!!");
						}	
						rs.close();	
						statement.close();				
					}
				}
				
				//START VOLTAGE,ADD BY PEGGY 20200306
				jxl.Cell wcSVOLTAGE = sht.getCell(5, i);  
				S_VOLTAGE = (wcSVOLTAGE.getContents()).trim();
				if (S_VOLTAGE== null) S_VOLTAGE = "";

				//END VOLTAGE,ADD BY PEGGY 20200306
				jxl.Cell wcEVOLTAGE = sht.getCell(6, i);  
				E_VOLTAGE = (wcEVOLTAGE.getContents()).trim();
				if (E_VOLTAGE== null) E_VOLTAGE = "";				
				
				//LEAD TIME
				jxl.Cell wcLEADTIME = sht.getCell(7, i);  		   
				if (wcLEADTIME.getType() == CellType.NUMBER) 
				{
					LEAD_TIME = ""+((NumberCell)wcLEADTIME).getValue();
				}
				else
				{
					LEAD_TIME = (wcLEADTIME.getContents()).trim();
				}
				if (LEAD_TIME == null || LEAD_TIME.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Lead Time不可空白!!");
				}
				else  if (Float.parseFloat(LEAD_TIME)<=0)
				{
					throw new Exception("第"+(i+1)+"列:Lead Time必須大於0!!");
				}
				
				//LEAD TIME(no wafer) add by Peggy 20160130
				//jxl.Cell wcLEADTIME_NOWAFER = sht.getCell(8, i);  		   
				//if (wcLEADTIME_NOWAFER.getType() == CellType.NUMBER) 
				//{
				//	LEAD_TIME_NOWAFER = ""+((NumberCell)wcLEADTIME_NOWAFER).getValue();
				//}
				//else
				//{
				//	LEAD_TIME_NOWAFER = (wcLEADTIME_NOWAFER.getContents()).trim();
				//}
				//if (LEAD_TIME_NOWAFER == null || LEAD_TIME_NOWAFER.equals(""))
				//{
				//	throw new Exception("第"+(i+1)+"列:Lead Time不可空白!!");
				//}
				//else  if (Float.parseFloat(LEAD_TIME_NOWAFER)<=0)
				//{
				//	throw new Exception("第"+(i+1)+"列:Lead Time必須大於0!!");
				//}
					
				//STATUS,add by Peggy 20180802
				jxl.Cell wcSTATUS = sht.getCell(8, i);  		   
				ACTIVE_FLAG = (wcSTATUS.getContents()).trim();
				if (ACTIVE_FLAG==null||ACTIVE_FLAG.equals("")) ACTIVE_FLAG="A";
						
				//REMARKS,add by Peggy 20200310
				jxl.Cell wcREMARKS = sht.getCell(9, i);  
				REMARKS = (wcREMARKS.getContents()).trim();
				if (REMARKS== null) REMARKS = "";					
				
												
				try
				{
					v_found_cnt=0;
					if (S_VOLTAGE.equals("") && E_VOLTAGE.equals(""))				
					{
						//check data exists 
						sql = " select seq_id from oraddman.tsprod_manufactory_leadtime a"+
							  " where MANUFACTORY_NO=?"+
							  " and TSC_PROD_GROUP=?"+
							  " and TSC_FAMILY=?"+
							  " and nvl(TSC_PROD_FAMILY,'xx')=nvl(?,'xx')"+
							  " and TSC_PACKAGE=?"+
							  " and nvl(TSC_DESC,'xxx')=nvl(?,'xxx')";
						PreparedStatement statement = con.prepareStatement(sql);
						statement.setString(1,PLANT_CODE);
						statement.setString(2,TSC_PROD_GROUP);
						statement.setString(3,TSC_FAMILY);
						statement.setString(4,TSC_PROD_FAMILY);
						statement.setString(5,TSC_PACKAGE);
						statement.setString(6,ITEM_DESC);
						ResultSet rs=statement.executeQuery();
						if (rs.next())
						{
							sql= " update oraddman.tsprod_manufactory_leadtime "+
								 " set LEAD_TIME=?"+
								 ",NO_WAFER_LEAD_TIME=?"+
								 ",LEAD_TIME_UOM=?"+
								 ",LAST_UPDATED_BY=?"+
								 ",LAST_UPDATE_DATE=sysdate"+
								 ",ACTIVE_FLAG=?"+
								 ",S_VOLTAGE=?"+
								 ",E_VOLTAGE=?"+
								 ",REMARKS=?"+
								 " where seq_id = ?";
							PreparedStatement st1 = con.prepareStatement(sql);
							st1.setString(1,LEAD_TIME);
							st1.setString(2,LEAD_TIME_NOWAFER);
							st1.setString(3,LEAD_TIME_UOM); 
							st1.setString(4,UserName);
							st1.setString(5,ACTIVE_FLAG);
							st1.setString(6,S_VOLTAGE);
							st1.setString(7,E_VOLTAGE);
							st1.setString(8,REMARKS);
							st1.setString(9,rs.getString("seq_id"));	
							st1.executeQuery();
							st1.close();
							v_found_cnt++;
						}		
						rs.close();	
						statement.close();									
					}
					
					if (v_found_cnt ==0)
					{
						if (!ITEM_DESC.equals(""))
						{
							sql= " delete oraddman.tsprod_manufactory_leadtime "+
								 " where TSC_PROD_GROUP=? and nvl(TSC_DESC,'xxx')=nvl(?,'xxx')";
							PreparedStatement st1 = con.prepareStatement(sql);
							st1.setString(1,TSC_PROD_GROUP);
							st1.setString(2,ITEM_DESC);
							st1.executeQuery();
							st1.close();
						}
						if (!S_VOLTAGE.equals("") || !E_VOLTAGE.equals(""))
						{
							sql = " delete oraddman.tsprod_manufactory_leadtime a"+
								  " where MANUFACTORY_NO=?"+
								  " and TSC_PROD_GROUP=?"+
								  " and TSC_FAMILY=?"+
								  " and nvl(TSC_PROD_FAMILY,'xx')=nvl(?,'xx')"+
								  " and TSC_PACKAGE=?"+
								  " and (S_VOLTAGE is not null or E_VOLTAGE is not null)"+
								  " and BATCH_ID<>?";
							//out.println(sql);							
							PreparedStatement st1 = con.prepareStatement(sql);
							st1.setString(1,PLANT_CODE);
							st1.setString(2,TSC_PROD_GROUP);
							st1.setString(3,TSC_FAMILY);
							st1.setString(4,TSC_PROD_FAMILY);
							st1.setString(5,TSC_PACKAGE);
							st1.setString(6,V_BATCH_ID);	
							st1.executeQuery();
							st1.close();												
						}
											
						sql = " insert into oraddman.tsprod_manufactory_leadtime "+
							  " (manufactory_no"+
							  ",tsc_prod_group"+
							  ",tsc_family"+
							  ",tsc_prod_family"+
							  ",tsc_package"+
							  ",tsc_desc"+
							  ",lead_time"+
							  ",lead_time_uom"+
							  ",created_by"+
							  ",creation_date"+
							  ",last_updated_by"+
							  ",last_update_date"+
							  ",seq_id"+
							  ",NO_WAFER_LEAD_TIME"+
							  ",ACTIVE_FLAG"+
							  ",S_VOLTAGE"+
							  ",E_VOLTAGE"+
							  ",BATCH_ID"+
							  ",REMARKS"+
							  ")"+
							  " select "+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",sysdate"+
							  ",?"+
							  ",sysdate"+
							  ",NVL(max(seq_id),0)+1"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  " from oraddman.tsprod_manufactory_leadtime ";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,PLANT_CODE);	
						st1.setString(2,TSC_PROD_GROUP);
						st1.setString(3,TSC_FAMILY); 
						st1.setString(4,TSC_PROD_FAMILY); 
						st1.setString(5,TSC_PACKAGE);
						st1.setString(6,ITEM_DESC);  
						st1.setString(7,LEAD_TIME);  
						st1.setString(8,LEAD_TIME_UOM);  
						st1.setString(9,UserName); 
						st1.setString(10,UserName); 
						st1.setString(11,LEAD_TIME_NOWAFER); 
						st1.setString(12,ACTIVE_FLAG); 
						st1.setString(13,S_VOLTAGE); 
						st1.setString(14,E_VOLTAGE); 
						st1.setString(15,V_BATCH_ID); 
						st1.setString(16,REMARKS); 
						st1.executeQuery();
						st1.close();
					}	
			
					con.commit();
				}
				catch(Exception e)
				{
					con.rollback();
					throw new Exception(e.getMessage());
				}
			}
			wb.close();
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.MYFORM.submit();
				setClose();		
			</script>
	<%				
			
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>上傳失敗!!錯誤原因如下說明..<br>"+e.getMessage()+"</div>");
		}
	}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
