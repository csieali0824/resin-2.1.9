<!--20160727 Peggy,add catalog_cust_moq欄位-->
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
		alert("請選擇Internal/External!");
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
if (PLANT_CODE==null) PLANT_CODE="TS";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="",PACKING_CLASS="",TSC_PROD_GROUP="",TSC_FAMILY="",TSC_PROD_FAMILY="",TSC_PACKAGE="",ITEM_ID="",ITEM_DESC="",ITEM_NAME="",TSC_PACKING_CODE="",SPQ="",SAMPLE_SPQ="",MOQ="",CATALOG_CUST_MOQ=""; //CATALOG_CUST_MO add by Peggy 20160727
String VENDOR_MOQ=""; //add by Peggy 20211207
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();  
int REC_CNT=0; 
int start_row=1;

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="1" cellpadding="1" bordercolor="#CCCCCC">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:arial;font-size:12px">&nbsp;Internal/External&nbsp;</font></TD>
		<TD><input type="text" name="PLANT_CODE" value="<%=PLANT_CODE%>" onKeyDown="return (event.keyCod==-9);"  style="color:#000099;font-family:Arial;font-size:12px">
		</TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/D3-002_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSDRQItemPackageCategoryUpload.jsp?ACTION=UPLOAD")'>
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

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D3-002("+PLANT_CODE+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				ITEM_DESC ="";ITEM_ID="";REC_CNT=99;
				//PACKING CLAS0
				jxl.Cell wcPACKINGCLASS = sht.getCell(0, i);          
				PACKING_CLASS = (wcPACKINGCLASS.getContents()).trim();
				if (PACKING_CLASS == null) PACKING_CLASS = "";
				if (PACKING_CLASS.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:PACKING CLASS不可空白!!");
				}
			
				//型號
				jxl.Cell wcITEMNAME = sht.getCell(6, i);  
				ITEM_NAME = (wcITEMNAME.getContents()).trim();
				if (ITEM_NAME== null)ITEM_NAME = "";
				if (!ITEM_NAME.equals(""))
				{
					sql = //" select TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
					      //",tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Family') tsc_family"+
					      //",tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_FAMILY') tsc_prod_family"+
						  //",tsc_om_category(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') tsc_package "+
						  " select TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,1100000003) TSC_PROD_GROUP"+
						  ",TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,21) tsc_family"+
						  ",TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,1100000004) tsc_prod_family"+
						  ",TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,23) tsc_package"+
						  ",TSC_GET_ITEM_PACKING_CODE(ORGANIZATION_ID,INVENTORY_ITEM_ID) TSC_PACKING_CODE"+
						  ",INVENTORY_ITEM_ID"+
						  ",DESCRIPTION"+
						  //",count(description) over (partition by DESCRIPTION order by DESCRIPTION) rec_cnt"+//add by Peggy 20180331
                          ",nvl((SELECT COUNT(DESCRIPTION) over (partition by DESCRIPTION order by DESCRIPTION) FROM inv.mtl_system_items_b B WHERE B.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND B.ORGANIZATION_ID=A.ORGANIZATION_ID AND B.INVENTORY_ITEM_STATUS_CODE<>'Inactive'),0) rec_cnt"+
						  ",SEGMENT1"+  //add by Peggy 20181004
						  ",INVENTORY_ITEM_STATUS_CODE"+ //add by Peggy 20181004
					      " from inv.mtl_system_items_b a"+
						  " where organization_id=49"+
						  " AND LENGTH(a.SEGMENT1)>=22"+
						  //" and (segment1 =? or description =?)"+
						  " and ? in (segment1, description )"+
						  " order by decode(INVENTORY_ITEM_STATUS_CODE,'Inactive',999,1)"; //add by Peggy 20181004
						  //" and segment1 =?";
					//out.println(sql);
					//out.println(ITEM_NAME);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ITEM_NAME);
					//statement.setString(2,ITEM_NAME);
					ResultSet rs=statement.executeQuery();
					if (!rs.next())					 
					{
						throw new Exception("第"+(i+1)+"列:"+ITEM_NAME+"查無此型號!!");
					}	
					else
					{
						TSC_PROD_GROUP =rs.getString(1);
						TSC_FAMILY = rs.getString(2);
						TSC_PROD_FAMILY = rs.getString(3);
						TSC_PACKAGE = rs.getString(4);
						TSC_PACKING_CODE =rs.getString(5);
						//ITEM_ID=rs.getString(6);
						REC_CNT =rs.getInt(8); //add by Peggy 20180331
						if (REC_CNT<=1)
						{
							if (rs.getString(10).equals("Inactive"))
							{
								throw new Exception("第"+(i+1)+"列:"+ITEM_NAME+"已停用!!");
								//ITEM_NAME="";ITEM_DESC="";ITEM_ID="";
							}
							else
							{
								ITEM_ID=rs.getString(6);
								ITEM_NAME=rs.getString(9);//add by Peggy 20181004
								ITEM_DESC=rs.getString(7);
							}
						}
					}
					
					rs.close();	
					statement.close();
				}
				
				if (ITEM_NAME.equals("") && REC_CNT ==1) continue; //inactive直接跳過
				
				if (ITEM_NAME.equals("") || REC_CNT>1 ) 
				{
					//TSC PROD GROUP
					jxl.Cell wcTSCPRODGROUP = sht.getCell(1, i);          
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
									
					//TSC FAMILY
					jxl.Cell wcTSCFAMILY = sht.getCell(2, i);  
					TSC_FAMILY = (wcTSCFAMILY.getContents()).trim();
					if (TSC_FAMILY == null) TSC_FAMILY = "";
					if (TSC_FAMILY.equals(""))
					{
						if (!(userProdCenterNo==null?"":userProdCenterNo).equals("006")) //MODIFY BY PEGGY 20200413
						{
							throw new Exception("第"+(i+1)+"列:Family不可空白!!");
						}
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
					jxl.Cell wcTSCPRODFAMILY = sht.getCell(3, i);  
					TSC_PROD_FAMILY = (wcTSCPRODFAMILY.getContents()).trim();
					if (TSC_PROD_FAMILY == null) TSC_PROD_FAMILY = "";
					//if (TSC_PROD_GROUP.equals("PMD") || TSC_PROD_GROUP.equals("SSP") || TSC_PROD_GROUP.equals("SSD"))
					if (TSC_PROD_GROUP.equals("SSP") || TSC_PROD_GROUP.equals("SSD"))  //MODIFY BY PEGGY 20200413
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
					jxl.Cell wcTSCPACKAGE = sht.getCell(4, i);  		   
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
					
					//TSC PACKING CODE
					jxl.Cell wcTSCPACKINGCODE = sht.getCell(5, i);  		   
					TSC_PACKING_CODE = (wcTSCPACKINGCODE.getContents()).trim();
					if (TSC_PACKING_CODE == null) TSC_PACKING_CODE = "";
					if (TSC_PACKING_CODE.equals(""))
					{
						throw new Exception("第"+(i+1)+"列:Packing Code不可空白!!");
					}	
					
					if (REC_CNT>1)
					{
						sql = "SELECT INVENTORY_ITEM_ID"+
							  ",SEGMENT1"+
							  ",DESCRIPTION"+
    						  ",row_number() over (partition by DESCRIPTION order by DESCRIPTION) rec_cnt"+
							  " from inv.mtl_system_items_b a"+
							  " where organization_id=49"+
							  " and description =?"+
							  " and INVENTORY_ITEM_STATUS_CODE<>'Inactive'"+ //add by Peggy 20181004
							  " and TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,1100000003)=?"+
							  " and TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,21) =?"+
							  " and TSC_INV_Category(INVENTORY_ITEM_ID,ORGANIZATION_ID,23) =?";
						PreparedStatement statement = con.prepareStatement(sql);
						//statement.setString(1,ITEM_NAME);
						statement.setString(1,ITEM_DESC);
						statement.setString(2,TSC_PROD_GROUP);
						statement.setString(3,TSC_FAMILY);
						statement.setString(4,TSC_PACKAGE);
						ResultSet rs=statement.executeQuery();
						if (rs.next())					 
						{
							if (rs.getInt(4)>1)  throw new Exception("第"+(i+1)+"列:此型號有兩個以上22D,請指定22D料號上傳!!"); 
							ITEM_ID=rs.getString(1);
							ITEM_NAME=rs.getString(2);
							ITEM_DESC=rs.getString(3);
							REC_CNT =rs.getInt(4); 
						}
						
						rs.close();	
						statement.close();	
					}				
				}
				
				
				//SPQ
				jxl.Cell wcSPQ = sht.getCell(7, i);  		   
				if (wcSPQ.getType() == CellType.NUMBER) 
				{
					SPQ = ""+((NumberCell)wcSPQ).getValue();
				}
				else
				{
					SPQ = (wcSPQ.getContents()).trim();
				}
				if (SPQ == null || SPQ.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:SPQ不可空白!!");
				}
				else  if (Float.parseFloat(SPQ)<=0)
				{
					throw new Exception("第"+(i+1)+"列:SPQ必須大於0!!");
				}
				
				//SPQ(SAMPLE)
				jxl.Cell wcSAMPLE_SPQ = sht.getCell(8, i);  		   
				if (wcSAMPLE_SPQ.getType() == CellType.NUMBER) 
				{
					SAMPLE_SPQ = ""+((NumberCell)wcSAMPLE_SPQ).getValue();
				}
				else
				{
					SAMPLE_SPQ = (wcSAMPLE_SPQ.getContents()).trim();
				}
				if (SAMPLE_SPQ == null || SAMPLE_SPQ.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:SAMPLE SPQ不可空白!!");
				}
				else  if (Float.parseFloat(SAMPLE_SPQ)<=0)
				{
					throw new Exception("第"+(i+1)+"列:SAMPLE SPQ必須大於0!!");
				}
				
				//MOQ
				jxl.Cell wcMOQ = sht.getCell(9, i);  		   
				if (wcMOQ.getType() == CellType.NUMBER) 
				{
					MOQ = ""+((NumberCell) wcMOQ).getValue();
				}
				else
				{
					MOQ = ( wcMOQ.getContents()).trim();
				}
				if (MOQ == null || MOQ.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:MOQ不可空白!!");
				}
				else  if (Float.parseFloat(MOQ)<=0)
				{
					throw new Exception("第"+(i+1)+"列:MOQ必須大於0!!");
				}
				else if ((Float.parseFloat(MOQ)%Float.parseFloat(SPQ))!=0)
				{
					throw new Exception("第"+(i+1)+"列:MOQ必須是SPQ倍數!!");
				}
				//else if ((Float.parseFloat(MOQ)%Float.parseFloat(SAMPLE_SPQ))!=0)
				//{
				//	throw new Exception("第"+(i+1)+"列:MOQ必須是Sample SPQ倍數!!");
				//}	
				
				//CATALOG_CUST_MOQ,add by Peggy 20160727
				jxl.Cell wcCATALOG_CUST_MOQ = sht.getCell(10, i);  		   
				if (wcCATALOG_CUST_MOQ.getType() == CellType.NUMBER) 
				{
					CATALOG_CUST_MOQ = ""+((NumberCell) wcCATALOG_CUST_MOQ).getValue();
				}
				else
				{
					CATALOG_CUST_MOQ = ( wcCATALOG_CUST_MOQ.getContents()).trim();
				}
				if (CATALOG_CUST_MOQ != null && !CATALOG_CUST_MOQ.equals(""))
				{
					if (Float.parseFloat(CATALOG_CUST_MOQ)<=0)
					{
						throw new Exception("第"+(i+1)+"列:CATALOG CUST MOQ必須大於0!!");
					}
					else if ((Float.parseFloat(CATALOG_CUST_MOQ)%Float.parseFloat(SPQ))!=0)
					{
						throw new Exception("第"+(i+1)+"列:CATALOG CUST MOQ必須是SPQ倍數!!");
					}
				}	
				
				//CATALOG_CUST_MOQ,add by Peggy 20211207
				jxl.Cell wcVENDOR_MOQ = sht.getCell(11, i);  		   
				if (wcVENDOR_MOQ.getType() == CellType.NUMBER) 
				{
					VENDOR_MOQ = ""+((NumberCell) wcVENDOR_MOQ).getValue();
				}
				else
				{
					VENDOR_MOQ = ( wcVENDOR_MOQ.getContents()).trim();
				}
				if (VENDOR_MOQ != null && !VENDOR_MOQ.equals(""))
				{
					if (Float.parseFloat(VENDOR_MOQ)<=0)
					{
						throw new Exception("第"+(i+1)+"列:VENDOR_MOQ必須大於0!!");
					}
					else if ((Float.parseFloat(VENDOR_MOQ)%Float.parseFloat(SPQ))!=0)
					{
						throw new Exception("第"+(i+1)+"列:VENDOR_MOQ必須是SPQ倍數!!");
					}
				}
																						
				try
				{
					if (ITEM_ID.equals(""))
					{
						sql = " SELECT * FROM  (SELECT ROWID,TSC_FAMILY,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY"+
						 ",ROW_NUMBER() over (order by CREATION_DATE desc) as row_num "+
						 " FROM ORADDMAN.TSITEM_PACKING_CATE "+
						 " WHERE INT_TYPE =?"+
						 " AND TSC_PROD_GROUP = ?"+
						 " AND PACKING_CLASS=?"+
						 " AND NVL(TSC_FAMILY,'XX') = NVL(?,'XX')"+
						 " AND TSC_OUTLINE=?"+
						 " AND PACKAGE_CODE=?"+
						 " AND NVL(TSC_PROD_FAMILY,'XX') = NVL(?,'XX')"+
						 " )"+
						 " WHERE row_num =1";
					}
					else
					{
						sql = " SELECT * FROM  (SELECT ROWID,TSC_FAMILY,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY"+
						 ",ROW_NUMBER() over (order by CREATION_DATE desc) as row_num "+
						 " FROM ORADDMAN.TSITEM_PACKING_CATE "+
						 " WHERE INT_TYPE =?"+
						 " AND NVL(INVENTORY_ITEM_ID,-999) = NVL(?,-999)"+
						 " )"+
						 " WHERE row_num =1";					
					}
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,PLANT_CODE);
					if (ITEM_ID.equals(""))
					{					
						statement.setString(2,TSC_PROD_GROUP);
						statement.setString(3,PACKING_CLASS);
						statement.setString(4,TSC_FAMILY);
						statement.setString(5,TSC_PACKAGE);
						statement.setString(6,TSC_PACKING_CODE);
						statement.setString(7,TSC_PROD_FAMILY);
					}
					else
					{
						statement.setString(2,ITEM_ID);
					}
					ResultSet rs=statement.executeQuery();
					if (rs.next())
					{
						sql = " UPDATE ORADDMAN.TSITEM_PACKING_CATE"+
							" SET INT_TYPE=?"+
							",PACKING_CLASS=?"+
							",TSC_FAMILY=?"+
							",TSC_OUTLINE=?"+
							",PACKAGE_CODE=?"+
							",SPQ=?"+
							",MOQ=?"+
							",CATALOG_CUST_MOQ=?"+ //add by Peggy 20160727
							",TSC_PROD_GROUP=?"+
							",LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
							",LAST_UPDATED_BY=?"+
							",SAMPLE_SPQ=?"+ 
							",TSC_PROD_FAMILY=?"+
							",INVENTORY_ITEM_ID=?"+
							",ITEM_NO=?"+
							",ITEM_DESCRIPTION=?"+ 
							",VENDOR_MOQ=?"+  //add by Peggy 20211207		
							" WHERE ROWID=?";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,PLANT_CODE);	
						st1.setString(2,PACKING_CLASS);
						st1.setString(3,TSC_FAMILY); 
						st1.setString(4,TSC_PACKAGE);
						st1.setString(5,TSC_PACKING_CODE);  
						st1.setString(6,SPQ); 
						st1.setString(7,MOQ);
						st1.setString(8,CATALOG_CUST_MOQ); //Add by Peggy 20160727
						st1.setString(9,TSC_PROD_GROUP);
						st1.setString(10,UserName);
						st1.setString(11,SAMPLE_SPQ);
						st1.setString(12,TSC_PROD_FAMILY);
						st1.setString(13,ITEM_ID);
						st1.setString(14,ITEM_NAME);
						st1.setString(15,ITEM_DESC);			
						st1.setString(16,VENDOR_MOQ); //add by Peggy 20211207		
						st1.setString(17,rs.getString("ROWID"));			
						st1.executeQuery();
						st1.close();				
					}
					else
					{
						//out.println("i="+1);					
						sql = " insert into ORADDMAN.TSITEM_PACKING_CATE"+
								" (INT_TYPE,PACKING_CLASS,TSC_FAMILY,TSC_OUTLINE,PACKAGE_CODE,SPQ,MOQ,TSC_PROD_GROUP,CREATION_DATE,CREATED_BY,SAMPLE_SPQ"+ //add SAMPLE_SPQ field by Peggy on 20120516
								",TSC_PROD_FAMILY,INVENTORY_ITEM_ID,ITEM_NO,ITEM_DESCRIPTION,LAST_UPDATE_DATE,LAST_UPDATED_BY"+ 
								",CATALOG_CUST_MOQ,VENDOR_MOQ)"+ //add by Peggy 20160727,//add by Peggy 20211207		
								" values"+
								" (?,?,?,?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),?,?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),?,?,?)";
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,PLANT_CODE);	
						st1.setString(2,PACKING_CLASS);
						st1.setString(3,TSC_FAMILY); 
						st1.setString(4,TSC_PACKAGE);
						st1.setString(5,TSC_PACKING_CODE);  
						st1.setString(6,SPQ); 
						st1.setString(7,MOQ);
						st1.setString(8,TSC_PROD_GROUP);
						st1.setString(9,UserName);
						st1.setString(10,SAMPLE_SPQ);
						st1.setString(11,TSC_PROD_FAMILY);
						st1.setString(12,ITEM_ID);
						st1.setString(13,ITEM_NAME);
						st1.setString(14,ITEM_DESC);
						st1.setString(15,UserName);
						st1.setString(16,CATALOG_CUST_MOQ);
						st1.setString(17,VENDOR_MOQ);
						st1.executeQuery();
						st1.close();
					}	
					rs.close();	
					statement.close();				
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
				alert("Action Successfully completed!");
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
