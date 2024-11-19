<!-- 20140825 Peggy ,新增ERP END CUSTOMER ID欄位-->
<!-- 20150519 Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20151008 Peggy,加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷>
<!-- 20160512 Peggy,021,022加入單價-->
<!-- 20170216 Peggy,add sales region for bi-->
<!-- 20170512 Peggy,add end cust ship to id-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<!-- 20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Excel Upload To Create a New RFQ Order</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setCreate(URL)
{  
	if (document.form1.Customer.value == "" || document.form1.Customer.value == null)
	{
		alert("請選擇客戶!");
		document.form1.Customer.focus();
		return false;
	}
	else if (document.form1.SALESAREANO.value == "" || document.form1.SALESAREANO.value == null)
	{
		alert("請選擇業務區域!");
		document.form1.SALESAREANO.focus();
		return false;	
	}
	else if (document.form1.SALESAREANO.value =="001")
	{
		alert("歐洲區不適用此上傳功能,若有該區上傳需求,請洽系統管理人員,謝謝!");
		return false;	
	}
	else if (document.form1.PREORDERTYPE.value == "--" || document.form1.PREORDERTYPE.value == "")
	{
		alert("請選擇訂單類型!");
		document.form1.PREORDERTYPE.focus();
		return false;	
	}
	else if (document.form1.UPLOADFILE.value == "")
	{
		alert("請選擇上傳檔案!");
		document.form1.UPLOADFILE.focus();
		return false;		
	}
	var filename = document.form1.UPLOADFILE.value;
	filename = filename.substr(filename.length-4);
	if (filename.toUpperCase() != ".XLS")
	{
		alert('上傳檔案必須為office 2003 excel檔!');
		document.form1.UPLOADFILE.focus();
		return false;	
	}
	var chkflag = false;
	var RFQ_TYPE = "";
	var radioLength = document.form1.rfqtype.length;
	if(radioLength == undefined) 
	{
		return;
	}
	for(var i = 0; i < radioLength; i++) 
	{
		if ( document.form1.rfqtype[i].checked)
		{
			RFQ_TYPE = document.form1.rfqtype[i].value;
			chkflag=true;
			break;
		}
	}
	if (chkflag == false)
	{
		alert("請選擇RFQ類型!");
		return false;		
	}
	var SAMPLEFILE = document.form1.SAMPLEFILE.value;
    document.form1.submit1.disabled=true;
	document.form1.action=URL+"&CUSTOMERID="+document.form1.CUSTOMERID.value+"&CUSTOMERNO="+document.form1.CUSTOMERNO.value+"&CUSTOMERNAME="+document.form1.CUSTOMERNAME.value+"&SalesAreaNo="+document.form1.SALESAREANO.value+"&PREORDERTYPE="+document.form1.PREORDERTYPE.value+"&PAR_ORG_ID="+document.form1.PAR_ORG_ID.value+"&RFQ_TYPE="+RFQ_TYPE+"&SAMPLEFILE="+SAMPLEFILE;
	document.form1.submit(); 
}
function setSubmit(URL)
{  
	var deline="";
	var delcnt=0;
	for (var i=1;i <100;i++)
	{
		try
		{
			if (document.form1.elements["itemname"+i].value=="")
			{
				alert("Line:"+i+"TSC Item Name不可空白!");
				document.form1.elements["itemname"+i].focus();
				return false;
			}
			else 
			{
				try
				{
					var btname = document.form1.elements["btn"+i].name;
					URL += "&LINE"+i+"="+document.form1.elements["itemname"+i].value;
				}catch(err){}
				if (document.getElementById("itemstatus"+i).innerHTML=="NRND")
				{
					if (document.getElementById("status"+i).innerHTML!="PASS" && document.getElementById("status"+i).innerHTML!="CANCEL")
					{
						alert("Line:"+i+" 請確認Item Stauts="+document.getElementById("itemstatus"+i).innerHTML+"是否要下單!");
						return false;						
					}
					else if (document.getElementById("status"+i).innerHTML=="CANCEL")
					{
						if (deline=="")
						{
							deline=",";
						}
						deline += i+",";
						delcnt ++;
					}
				}
			}
		}catch(err){break;}
	}
	//add by Peggy 20120309
	var RFQ_TYPE = "";
	var radioLength = document.form1.rfqtype.length;
	for(var i = 0; i < radioLength; i++) 
	{
		if ( document.form1.rfqtype[i].checked)
		{
			RFQ_TYPE = document.form1.rfqtype[i].value;
		}
	}
			
	document.form1.submit1.disabled=true;
    document.form1.btnsubmit.disabled=true;
	document.form1.action=URL+"&RFQ_TYPE="+RFQ_TYPE+"&DELINE="+deline+"&DELCNT="+delcnt;
	document.form1.submit(); 
}

function checkitem(line,strres)
{
	document.form1.elements["btnpass"+line].style.visibility="hidden";
	document.form1.elements["btncancel"+line].style.visibility="hidden";
	document.getElementById("status"+line).innerHTML=strres;
	document.getElementById("msg"+line).innerHTML="&nbsp;";
}

</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:Tahoma,Georgia; font-size:12px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:left;}
 .style3   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style31  {font-family:Tahoma,Georgia; font-size:12px; background-color:#FF8822; color:#000000; text-align:left;}
 .style4   {font-family:Tahoma,Georgia; font-size:12px; color: #000000; text-align:center}
 .style5   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style6   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:center;}
 .style7   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style8   {font-family:Tahoma,Georgia; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:center;}
 .style9   {font-family:Tahoma,Georgia; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style11  {font-family:Tahoma,Georgia; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:center;}
 .style17  {font-family:標楷體; font-size:16px; background-color:#FFFFFF; color:#FF0000; text-align:LEFT;}
 td {word-break:break-all}
</STYLE>
</head>
<body>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<p>
<font color="#003399" size="+2" face="Arial Black">TSC</font>
<font color="#000000" size="+2" face="Times New Roman"> <strong>  Excel Upload To Create a New RFQ Order</strong></font>
<br>
</p>
<%
String PTYPE = request.getParameter("PTYPE");
if (PTYPE == null) PTYPE="0";
String CustomerName = request.getParameter("CUSTOMERNAME");
if (CustomerName == null) CustomerName="";
String CustomerNo = request.getParameter("CUSTOMERNO");
if (CustomerNo == null) CustomerNo="";
String CustomerID = request.getParameter("CUSTOMERID");
if (CustomerID == null) CustomerID="";
String Customer = "";
if (CustomerNo != "" && CustomerName !="" ) Customer = "("+ CustomerNo+")"+ CustomerName ;
String SalesArea = request.getParameter("SalesArea");
if (SalesArea == null) SalesArea="";
String SalesAreaNo = request.getParameter("SalesAreaNo");
if (SalesAreaNo == null) SalesAreaNo = "";
String PreOrderType = request.getParameter("PREORDERTYPE");
if (PreOrderType == null) PreOrderType = "";
String PAR_ORG_ID = request.getParameter("PAR_ORG_ID");
if (PAR_ORG_ID == null) PAR_ORG_ID = "";
String RFQ_TYPE = request.getParameter("RFQ_TYPE");
//out.println("RFQ_TYPE"+RFQ_TYPE);
String SAMPLEFILE = request.getParameter("SAMPLEFILE");
if (SAMPLEFILE ==null) SAMPLEFILE="";
StringBuffer sbf_s = new StringBuffer();
StringBuffer sbf_d = new StringBuffer();
StringBuffer allStrErr = new StringBuffer();
StringBuilder sb = new StringBuilder();
int ErrCnt=0;
String pgmName = "D4011_"; 
String sql = "";
String ORDER_ITEM_ID = "";
String ITEM_NAME = "",ITEM_STATUS="";
String INV_ITEM_ID = "";
String Unit_Price = "";
String UOM = "";
String IssueQty = "";
String Order_Item = "";
String Amount = "";
String Item_Desc = "";
String Currency = "";
String CustomerPo = "";
String StrReqDate = "";
String RequestDate = "";
String SalesPerson = "";
String toPersonID  = "";
String Remark = "";
String LineItem = "";
String StrCustomerName="";
String ShippingMethod = "";
String bb[][] = null;
String cc[][] = null;
String itemFactory = "";                  //add by Peggy 20120301
String defaultLineType = "";              //add by Peggy 20120301
String orderType = "";                    //add by Peggy 20120301
String custPO = "";                       //add by Peggy 20120308
String showStatus ="";                    //add by Peggy 20120525
String FOB="";                            //add by Peggy 20130208
String rfqTypeNormal = "";
String FOBList="",ShippingMethodList="";  //add by Peggy 20130208
String strEndCustID1="",greenFlag="",strBIRegion="",BIRegionList="";     //add by Peggy 20150519
int showcol=18;
if (SalesAreaNo.equals("021") || SalesAreaNo.equals("022")) //add by Peggy 20120525
{
	rfqTypeNormal="checked";
	showStatus = "style='visibility:hidden'";
}
else
{
	showStatus = "style='visibility:visible'";
}
String rfqTypeForecast = "";
String rfqTypeName1= "NORMAL";
String rfqTypeName2= "FORECAST";
String ship_via = "";
String lineFob = "";
String shipping_Marks ="",remarks="",tsc_prod_group="";   //add by Peggy 20130227
boolean UploadErr = false;
String strEndCustID ="",strEndCust=""; //add by Peggy 20140825

if (PTYPE.equals("U") || PTYPE.equals("S"))
{
	if (PTYPE.equals("S"))
	{
		//response.sendRedirect((String)session.getAttribute("D4011URL"));
		CustomerID = (String)session.getAttribute("CUSTOMERID");
		CustomerNo = (String)session.getAttribute("CUSTOMERNO");
		CustomerName = (String)session.getAttribute("CUSTOMERNAME");
		SalesArea =	(String)session.getAttribute("PROCESSAREA");
		SalesAreaNo = (String)session.getAttribute("SALESAREANO");
		PreOrderType = (String)session.getAttribute("PREORDERTYPE");
		Customer = "("+ CustomerNo+")"+ CustomerName;
		PAR_ORG_ID = (String)session.getAttribute("PAR_ORG_ID");	
		CustomerPo = (String)session.getAttribute("CUSTOMERPO");
		Currency = (String)session.getAttribute("CURR");
		if (RFQ_TYPE.equals(rfqTypeName1))
		{ 
			rfqTypeNormal="checked";
		}
		else if (RFQ_TYPE.equals(rfqTypeName2))
		{
			rfqTypeForecast="checked";
		}		
		sb.setLength(0);
		sb.append((String)session.getAttribute("EXL"));

		if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022")) //add by Peggy 20120525
		{
			//出貨方式list
			Statement statet=con.createStatement();
			sql = "select a.SHIPPING_METHOD_CODE ,a.SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a ";
			ResultSet rst=statet.executeQuery(sql);
			while (rst.next())
			{
				ShippingMethodList += (rst.getString("SHIPPING_METHOD")+"@"+rst.getString("SHIPPING_METHOD_CODE")+";");
			}

			//FOB list
			sql = "select distinct a.FOB_CODE from OE_FOBS_ACTIVE_V a ";
			rst=statet.executeQuery(sql);
			while (rst.next())
			{
				FOBList += (rst.getString("FOB_CODE")+";");
			}
			rst.close();
			statet.close();	
		}
		else
		{
			//BI REGION
			Statement statet=con.createStatement();
			sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
        	ResultSet rst=statet.executeQuery(sql);
			while (rst.next())
			{
				BIRegionList += (rst.getString("A_VALUE")+";");
			}	
			rst.close();
			statet.close();				
		}
	}
	else if (PTYPE.equals("U"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		String strDate=dateBean.getYearMonthDay();
		String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();
		if (uploadFile_name == null || uploadFile_name.equals("") )
		{
			out.println("<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的office 2003 excel檔，謝謝!')</script>");
		}
		else if (!(uploadFile_name.toLowerCase()).endsWith("xls"))
		{
			out.println("<script language=javascript>alert('上傳檔案必須為office 2003 excel檔!')</script>");
		}
		else
		{
			try
			{
				String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+pgmName+"("+CustomerNo+")"+strDateTime+"-"+uploadFile_name;
				upload_file.saveAs(uploadFilePath); 
				java.util.Date datetime = new java.util.Date();
				SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
				String CreationDate = (String) formatter.format( datetime );
				int icnt=0;
				InputStream is = new FileInputStream(uploadFilePath); 			
				jxl.Workbook wb = Workbook.getWorkbook(is);  
				jxl.Sheet sht = wb.getSheet(0);
							
				if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022")) //add by Peggy 20120525
				{
					//出貨方式list
					Statement statet=con.createStatement();
					sql = "select a.SHIPPING_METHOD_CODE ,a.SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a ";
					ResultSet rst=statet.executeQuery(sql);
					while (rst.next())
					{
						ShippingMethodList += (rst.getString("SHIPPING_METHOD")+"@"+rst.getString("SHIPPING_METHOD_CODE")+";");
					}
		
					//FOB list
					sql = "select distinct a.FOB_CODE from OE_FOBS_ACTIVE_V a ";
					rst=statet.executeQuery(sql);
					while (rst.next())
					{
						FOBList += (rst.getString("FOB_CODE")+";");
					}
					rst.close();
					statet.close();	
							
					//customer name
					jxl.Cell cellCustomerName = sht.getCell(1,0);
					StrCustomerName = cellCustomerName.getContents();
					byte[] temp_t = CustomerName.getBytes("ISO8859-1");
					StrCustomerName  = new String(temp_t);			
					//Customer PO
					jxl.Cell  cellcustomerpo  = sht.getCell(1,1); 
					CustomerPo = cellcustomerpo.getContents();
					//Currency
					jxl.Cell   cellcurrency = sht.getCell(1,4); 
					Currency = cellcurrency.getContents();
						
					//line detail
					for (int i = 6; i <sht.getRows(); i++) 
					{
						//Customer ITEM
						jxl.Cell wcOrder_Item = sht.getCell(0, i);          
						Order_Item = (wcOrder_Item.getContents()).trim();
						if (Order_Item == null) Order_Item= "";
					
						//ITEM DESC
						jxl.Cell wcItem_Desc = sht.getCell(1, i);          
						Item_Desc = (wcItem_Desc.getContents()).trim();
						if (Item_Desc  == null) Item_Desc = "";
					
						// qty
						jxl.Cell wcIssueQty = sht.getCell(2, i);  
			   			if (wcIssueQty.getType() == CellType.NUMBER) 
						{
                 			IssueQty = ""+((NumberCell) wcIssueQty).getValue();
			   			} 
						else IssueQty = (wcIssueQty.getContents()).trim();
						if (IssueQty == null) IssueQty="0";
					
						//Unit Price
						jxl.Cell wcUnit_Price = sht.getCell(3, i);  
			   			if (wcUnit_Price.getType() == CellType.NUMBER) 
						{
                 			Unit_Price = ""+((NumberCell) wcUnit_Price).getValue();
			   			} 
						else Unit_Price = (wcUnit_Price.getContents()).trim();
						if (Unit_Price == null) Unit_Price="";
					
						// Amount 
						jxl.Cell wcAmount = sht.getCell(4, i);           
			   			if (wcAmount.getType() == CellType.NUMBER) 
						{
                 			Amount= ""+((NumberCell) wcAmount).getValue();
			   			} 
						else Amount = (wcAmount.getContents()).trim();
						if (Amount == null) Amount = "0";
						
						// Request Date
						if (!Unit_Price.toUpperCase().equals("TOTAL") && Unit_Price.length()>0)
						{
							try
							{
								jxl.Cell wcReqDate = sht.getCell(5, i);           
								DateCell datec11 = (DateCell)wcReqDate;
								java.util.Date ReqDate  =  datec11.getDate();				
								SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
								StrReqDate =sy1.format(ReqDate);
							}
							catch(Exception e)
							{
								StrReqDate="";
							}
						}
						else
						{
							StrReqDate ="";
						}
						
						//CUSTOMER PO
						jxl.Cell wcCustPO = sht.getCell(6, i);          
						custPO = (wcCustPO.getContents()).trim();
						if (custPO == null || custPO.length() ==0) custPO = CustomerPo;

						//Shipping Method,add by Peggy 20130208
						jxl.Cell wcShippingMethod = sht.getCell(7, i);          
						ShippingMethod = (wcShippingMethod.getContents()).trim();
						if (ShippingMethod == null || ShippingMethod.length() ==0) ShippingMethod ="";

						//FOB,add by Peggy 20130208
						jxl.Cell wcFOB = sht.getCell(8, i);          
						FOB = (wcFOB.getContents()).trim();
						if (FOB == null || FOB.length() ==0) FOB ="";
											
						//REMARK
						jxl.Cell wcRemark = sht.getCell(9, i);          
						Remark = (wcRemark.getContents()).trim();
						if (Remark == null || Remark.length() ==0) Remark = "";
						
						//END CUSTOMER ID,add by Peggy 20140825
						jxl.Cell cellEndCustID = sht.getCell(10, i);          
						strEndCustID = (cellEndCustID.getContents()).trim();
						if (strEndCustID==null || strEndCustID.length()==0) strEndCustID="&nbsp;";
																
						//負數數量不做上傳
						if ((!IssueQty.startsWith("-") && !IssueQty.equals("0") && (!Order_Item.equals("") || !Item_Desc.equals(""))) || Unit_Price.toUpperCase().startsWith("TOTAL"))
						{
							sb.append(Order_Item+";"+Item_Desc+";"+IssueQty+";"+Unit_Price+";"+Amount+";"+StrReqDate+";"+custPO+";"+ShippingMethod+";"+FOB+";"+Remark+";"+strEndCustID+";<br>");
							icnt++;
						}
					}
				}
				else
				{
					//BI REGION
					Statement statet=con.createStatement();
					sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
					ResultSet rst=statet.executeQuery(sql);
					while (rst.next())
					{
						BIRegionList += (rst.getString("A_VALUE")+";");
					}	
					rst.close();
					statet.close();	
										
					for (int i = 1; i <sht.getRows(); i++) 
					{
						//CUSTOMER PO
						jxl.Cell wcCustPO = sht.getCell(0, i);          
						custPO = (wcCustPO.getContents()).trim();
						if (custPO == null || custPO.length() ==0) custPO = "";
						if ((CustomerPo == null || CustomerPo.equals("")) && custPO != null && !custPO.equals("")) CustomerPo =custPO;
						//out.println("CustomerPo="+CustomerPo);
					
						//ITEM DESC
						jxl.Cell wcItem_Desc = sht.getCell(2, i);          
						Item_Desc = (wcItem_Desc.getContents()).trim();
						if (Item_Desc  == null) Item_Desc = "";

						jxl.Cell wcReqDate = sht.getCell(5, i);           
						DateCell datec11 = (DateCell)wcReqDate;
						java.util.Date ReqDate  =  datec11.getDate();				
						SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
						StrReqDate =sy1.format(ReqDate);

						// qty
						jxl.Cell wcIssueQty = sht.getCell(7, i);  
			   			if (wcIssueQty.getType() == CellType.NUMBER) 
						{
                 			IssueQty = ""+((NumberCell) wcIssueQty).getValue();
			   			} 
						else IssueQty = (wcIssueQty.getContents()).trim();
						if (IssueQty == null) IssueQty="0";
						IssueQty = "" + (Float.parseFloat(IssueQty) / Float.parseFloat("1000"));

						//Unit Price,add by Peggy 20160512
						jxl.Cell wcUnit_Price = sht.getCell(9, i);  
			   			if (wcUnit_Price.getType() == CellType.NUMBER) 
						{
                 			Unit_Price = ""+((NumberCell) wcUnit_Price).getValue();
			   			} 
						else Unit_Price = (wcUnit_Price.getContents()).trim();
						if (Unit_Price == null) Unit_Price="0";
						
						//REMARK
						jxl.Cell wcRemark = sht.getCell(10, i);          
						Remark = (wcRemark.getContents()).trim();
						if (Remark == null || Remark.length() ==0) Remark = "";
						
						//END CUSTOMER ID,add by Peggy 20140825
						jxl.Cell cellEndCustID = sht.getCell(11, i);          
						strEndCustID = (cellEndCustID.getContents()).trim();
						if (strEndCustID==null || strEndCustID.length()==0) strEndCustID="";
								
						//bi region,add by Peggy 20170218
						jxl.Cell cellBIRegion = sht.getCell(12, i);          
						strBIRegion = (cellBIRegion.getContents()).trim();
						if (strBIRegion==null || strBIRegion.length()==0) strBIRegion="&nbsp;";
																
						//Unit_Price = "0";
						Amount = "0";
						
						//負數數量不做上傳
						if (!IssueQty.startsWith("-") && !IssueQty.equals("0") && !Item_Desc.equals(""))
						{
							sb.append(Order_Item+";"+Item_Desc+";"+IssueQty+";"+Unit_Price+";"+Amount+";"+StrReqDate+";"+custPO+";"+Remark+";"+strEndCustID+";"+strBIRegion+";<br>");
							icnt++;
						}
						//out.println("sht.getRows()="+sht.getRows());
						if (i == (sht.getRows()-1))
						{
							sb.append(";;;TOTAL;0;;;;;&nbsp;<br>");
							icnt++;
					}
					}
				}
				wb.close();
				if (icnt <=1) throw new Exception("上傳內容錯誤!");
				//out.println(sb.toString());
				session.setAttribute("EXL",sb.toString());
			}
			catch(Exception e)
			{
				UploadErr = true;
				out.println("Exception1:"+e.getMessage());
			}
		}
	}
	try
	{	
		if (!UploadErr) 
		{
			sbf_s.append("<table cellspacing='0' bordercolordark='#998811' cellpadding='1' width='100%' align='left' bordercolorlight='#ffffff' border='1'>"+
						 "<tr>"+
						 "<td class='style9'>Line No</td>"+
						 "<td class='style9'>Customer Item</td>"+
						 "<td class='style9'>TSC Item Desc</td>"+
						 "<td class='style9'>TSC Item Name</td>"+
						 "<td class='style9'>Item Status</td>"+
						 "<td class='style11'>Qty(K)</td>"+
						 "<td class='style11'>UOM</td>"+
						 "<td class='style11'>Unit Price</td>"+
						 "<td class='style11'>Amount</td>"+
						 "<td class='style11'>Request Date</td>"+
						 "<td class='style11'>Customer PO</td>");     //add by Peggy 20120308
			if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022")) //add by Peggy 20161229
			{
				sbf_s.append("<td class='style11'>Shipping Method</td>"+
						     "<td class='style11'>FOB</td>");
			}
			else
			{
				showcol=16;
			}
			sbf_s.append("<td class='style11'>Remark</td>"+
						 "<td class='style11'>End Cust ID</td>"+   //add by Peggy 20140825
						 "<td class='style11'>End Customer</td>"+  //add by Peggy 20140825
						 "<td class='style11'>Status</td>"+
						 "<td class='style9'>Error Message</td>"+
						 "</tr>");
			try 
			{
				//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
				CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
				cs1.setString(1,PAR_ORG_ID);  // 取業務員隸屬ParOrgID
				cs1.execute();
				cs1.close();
		
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt=con.prepareStatement(sql1);
				pstmt.executeUpdate(); 
				pstmt.close();		
				
				//add by Peggy 20140820
				sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
							  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
							  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SalesAreaNo+"') d"+
							  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
							  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
							  " and a.STATUS = b.STATUS "+
							  " and a.ORG_ID = b.ORG_ID "+										
							  " and a.ORG_ID = d.PAR_ORG_ID"+
							  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
							  " and c.STATUS='A'"+
							  " order by c.customer_id";
				Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rss = statements.executeQuery(sql);
							
				//add by Peggy 20120309
				if (CustomerID != null && !CustomerID.equals(""))
				{
					Statement statementa=con.createStatement();
					String sqla = " select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
								 " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION"+ 
								 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
								 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
								 " AND b.party_site_id = party_site.party_site_id"+
								 " AND loc.location_id = party_site.location_id "+
								 " and a.STATUS='A' "+
								 " and a.PRIMARY_FLAG='Y'"+
								 " and b.CUST_ACCOUNT_ID ='"+CustomerID+"'"+
								 " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
								 " order by case when upper(a.SITE_USE_CODE)='SHIP_TO' then 1 when upper(a.SITE_USE_CODE)='BILL_TO' then 2 else 3 end";
					//out.println(sqla);
					ResultSet rsa=statementa.executeQuery(sqla);
					while (rsa.next())
					{
						if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
						{
							if (ship_via==null || ship_via.equals(""))
							{
								ship_via = rsa.getString("ship_via");
							}
							if (lineFob==null || lineFob.equals(""))
							{
								lineFob = rsa.getString("FOB_POINT");
							}
						}
						else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
						{
							if (ship_via==null || ship_via.equals(""))
							{
								ship_via = rsa.getString("ship_via");
							}													
							if (lineFob==null || lineFob.equals(""))
							{
								lineFob = rsa.getString("FOB_POINT");
							}						
						}
					}
					rsa.close();
					statementa.close();
					if (SalesAreaNo.equals("021") || SalesAreaNo.equals("022"))
					{
						ShippingMethod = ship_via;
						FOB = lineFob;
					}
					//add by Peggy 20120606
					//if ((ship_via==null || ship_via.equals("")) && SalesAreaNo.equals("021"))  ship_via="000001_TRUCK_L_LTL";
					if ((ShippingMethod==null || ShippingMethod.equals("")) && SalesAreaNo.equals("021"))  ShippingMethod="000001_TRUCK_L_LTL";
				}
					
				int rec_cnt =0;
				int lines =0;
				int irow=0;
				if (RFQ_TYPE.equals(rfqTypeName1) && (SalesAreaNo.equals("021") || SalesAreaNo.equals("022")))	lines=1; else lines=0;
				String [] strArray  = (sb.toString()).split("<br>");
				//out.println("strArray ="+strArray.length);
				//String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode"};
				//modify by Peggy 20120301
				String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust Po Line No","Quote#","End Cust ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust PartNo"};//add by Peggy 20160313
				arrayRFQDocumentInputBean.setArrayString(oneDArray);
				String DELINE = request.getParameter("DELINE");  //add by Peggy 20161229
				if (DELINE==null) DELINE="";
				String DELCNT = request.getParameter("DELCNT");   //add by Peggy 20161229
				if (DELCNT==null) DELCNT="0";
				bb = new String[strArray.length-lines-Integer.parseInt(DELCNT)][oneDArray.length];
				cc = new String[strArray.length-lines-Integer.parseInt(DELCNT)][oneDArray.length];
				for (int i = 0 ; i < strArray.length ; i ++)
				{	
					if (DELINE.indexOf(","+(i+1)+",")>=0)  //add by Peggy 20161229
					{
						continue;
					}
					INV_ITEM_ID = "";	
					UOM = "";	
					ITEM_NAME = "";ITEM_STATUS="";
					tsc_prod_group =""; //add by Peggy 20130319
					allStrErr.setLength(0);
					allStrErr.append("");
					rec_cnt=0;
					String [] strDetail = strArray[i].split(";");
					//out.println(strArray[i]);
					//out.println("strDetail="+strDetail.length);
					if ( i != (strArray.length-1))
					{
						itemFactory =""; //add by Peggy 20120303
						orderType = "";  //add by Peggy 20120303
						sbf_d.append("<tr>");
						sbf_d.append("<td class='style3'>"+(i+1)+"</td>");
	
						
						//CUSTOMER ITEM
						Order_Item = strDetail[0].trim();
		
						// Item Desc
						Item_Desc = strDetail[1].trim();
						
						try
						{
							try
							{
								LineItem=request.getParameter("LINE"+(i+1));
								if (LineItem == null) LineItem ="%";				
							}
							catch(Exception e)
							{
								LineItem="%";
							}
							if ((Order_Item  == null || Order_Item.equals("")) && (Item_Desc == null && Item_Desc.equals("")))
							{
								Order_Item = "&nbsp;";
								Item_Desc = "&nbsp;";
								throw new Exception("P/N不可空白<br>Vendor P/N不可空白<br>");
							}
							else if ((Order_Item  == null || Order_Item.equals("")) && Item_Desc != null && !Item_Desc.equals(""))
							{ 
								Order_Item = "&nbsp;";
								sql = " select  DISTINCT a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
									  " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
									  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									  " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+   //add by Peggy 20130319
									  //" ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT order_num FROM oraddman.tsarea_ordercls  WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) END AS order_type"+
									  " ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT order_num FROM oraddman.tsarea_ordercls  WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) END AS order_type"+  //modify by Peggy 20191122
			                          " ,TSC_ITEM_GREEN_CHECK(msi.ORGANIZATION_ID,msi.INVENTORY_ITEM_ID)  GREEN_FLAG"+
									  " ,msi.INVENTORY_ITEM_STATUS_CODE"+  //add by Peggy 20161229
									  " from oe_items_v a"+
									  " ,inv.mtl_system_items_b msi "+
									  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
									  " where a.SOLD_TO_ORG_ID = '"+CustomerID+"' "+
									  " and a.ITEM_DESCRIPTION = '"+Item_Desc+"'"+
									  " and a.INVENTORY_ITEM LIKE '"+LineItem +"'"+
									  " and a.organization_id = msi.organization_id"+
									  " and a.inventory_item_id = msi.inventory_item_id"+
									  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
									  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
									  " and msi.ORGANIZATION_ID = '49'"+
									  " and c.CATEGORY_SET_ID = 6"+
									  " and a.CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20120524
								Statement statement=con.createStatement();
								ResultSet rs = statement.executeQuery(sql);
								rec_cnt=0;
								while(rs.next())
								{
									ITEM_NAME = rs.getString("INVENTORY_ITEM");
									INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
									UOM = rs.getString("PRIMARY_UOM_CODE");
									itemFactory = rs.getString("ATTRIBUTE3");									
									orderType = rs.getString("ORDER_TYPE");								
									tsc_prod_group = rs.getString("TSC_PROD_GROUP");  //add by Peggy 20130319			
									greenFlag = rs.getString("GREEN_FLAG"); //add by Peggy 20150519			
									ITEM_STATUS =rs.getString("INVENTORY_ITEM_STATUS_CODE");  //add by Peggy 20161229
									rec_cnt++;
								}
								rs.close();
								statement.close();	
								if (rec_cnt >1)
								{
									Order_Item="";
									ITEM_NAME=""; 
									throw new Exception("對應的台半料號超過一個以上,請手動選擇正確台半料號<br>");
								}
								if (rec_cnt==0)
								{
									sql = " select  DISTINCT msi.DESCRIPTION ITEM_DESCRIPTION,msi.INVENTORY_ITEM_ID,"+
										  " msi.segment1 INVENTORY_ITEM, msi.PRIMARY_UOM_CODE"+
										  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									      " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+ //add by Peggy 20130319
										  //" ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) END AS order_type"+
										  " ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) END AS order_type"+  //modify by Peggy 20191122
			                              " ,TSC_ITEM_GREEN_CHECK(msi.ORGANIZATION_ID,msi.INVENTORY_ITEM_ID)  GREEN_FLAG"+
										  " ,msi.INVENTORY_ITEM_STATUS_CODE"+  //add by Peggy 20161229
										  " from inv.mtl_system_items_b msi "+
										  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
										  " where  msi.DESCRIPTION = '"+Item_Desc+"'"+
										  " and msi.segment1 like '"+LineItem +"'"+
										  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
										  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
										  " and msi.ORGANIZATION_ID = '49'"+
										  " and c.CATEGORY_SET_ID = 6"+
										  " and NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+     //add by Peggy 20151008
         								  " and NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+	//add by Peggy 20151008									  
										  " and msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'"; //add by Peggy 20120524
									statement=con.createStatement();
									rs = statement.executeQuery(sql);
									rec_cnt=0;
									while(rs.next())
									{
										ITEM_NAME = rs.getString("INVENTORY_ITEM");
										INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
										UOM = rs.getString("PRIMARY_UOM_CODE");
										itemFactory = rs.getString("ATTRIBUTE3");									
										orderType = rs.getString("ORDER_TYPE");								
										tsc_prod_group = rs.getString("TSC_PROD_GROUP");  //add by Peggy 20130319						
										greenFlag = rs.getString("GREEN_FLAG"); //add by Peggy 20150519			
										ITEM_STATUS =rs.getString("INVENTORY_ITEM_STATUS_CODE");  //add by Peggy 20161229
										rec_cnt++;
									}
									rs.close();
									statement.close();		
									if (rec_cnt==0)
									{
										throw new Exception(Item_Desc+"查無對應的ERP料號<br>");
									}
									if (rec_cnt >1)
									{
										Order_Item="";
										ITEM_NAME=""; 
										throw new Exception("對應的台半料號超過一個以上,請手動選擇正確台半料號<br>");
									}								
								}
							}
							else if (Order_Item  != null && !Order_Item.equals("")  && (Item_Desc == null || Item_Desc.equals("")))
							{
								Item_Desc = "&nbsp;";
								sql = " select  DISTINCT a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
									  " a.INVENTORY_ITEM,a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
									  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									  " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+   //add by Peggy 20130319
									  //" ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) END AS order_type"+
									  " ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) END AS order_type"+  //modify by Peggy 20191122
			                          " ,TSC_ITEM_GREEN_CHECK(msi.ORGANIZATION_ID,msi.INVENTORY_ITEM_ID)  GREEN_FLAG"+
									  " ,msi.INVENTORY_ITEM_STATUS_CODE"+  //add by Peggy 20161229
									  " from oe_items_v a"+
									  " ,inv.mtl_system_items_b msi "+
									  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
									  " where a.SOLD_TO_ORG_ID = '"+CustomerID+"' "+
									  " and  a.ITEM = '"+Order_Item+"'"+
									  " and a.INVENTORY_ITEM LIKE '"+LineItem +"'"+
									  " and a.organization_id = msi.organization_id"+
									  " and a.inventory_item_id = msi.inventory_item_id"+
									  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
									  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
									  " and msi.ORGANIZATION_ID = '49'"+
									  " and c.CATEGORY_SET_ID = 6"+	
									  " and a.CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20120524
								Statement statement=con.createStatement();
								ResultSet rs = statement.executeQuery(sql);
								rec_cnt=0;
								while(rs.next())
								{
									ITEM_NAME = rs.getString("INVENTORY_ITEM");
									INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
									Item_Desc = rs.getString("ITEM_DESCRIPTION");
									UOM = rs.getString("PRIMARY_UOM_CODE");
									itemFactory = rs.getString("ATTRIBUTE3");									
									orderType = rs.getString("ORDER_TYPE");								
									tsc_prod_group = rs.getString("TSC_PROD_GROUP");  //add by Peggy 20130319						
									greenFlag = rs.getString("GREEN_FLAG"); //add by Peggy 20150519			
									ITEM_STATUS =rs.getString("INVENTORY_ITEM_STATUS_CODE");  //add by Peggy 20161229
									rec_cnt++;
								}
								rs.close();
								statement.close();			
								if (rec_cnt ==0) throw new Exception(Order_Item+"查無對應的ERP料號<br>");
								if (rec_cnt >1)
								{
									Item_Desc="";
									ITEM_NAME="";
									throw new Exception("對應的台半料號超過一個以上,請手動選擇正確台半料號<br>");
								}
							}
							else
							{
								sql = " select DISTINCT a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
									  " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
									  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									  " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+   //add by Peggy 20130319
									  //" ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) END AS order_type"+
									  " ,CASE  WHEN '"+SalesAreaNo+"' = '021' OR '"+SalesAreaNo+"' = '022' THEN (SELECT DISTINCT a.order_num FROM oraddman.tsarea_ordercls a WHERE sarea_no = '"+SalesAreaNo+"' AND otype_id ='"+PreOrderType+"') ELSE tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) END AS order_type"+  //modify by Peggy 20191122
			                          " ,TSC_ITEM_GREEN_CHECK(msi.ORGANIZATION_ID,msi.INVENTORY_ITEM_ID)  GREEN_FLAG"+
									  " ,msi.INVENTORY_ITEM_STATUS_CODE"+  //add by Peggy 20161229
									  " from oe_items_v  a"+
									  " ,inv.mtl_system_items_b msi "+
									  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
									  " where a.SOLD_TO_ORG_ID = '"+CustomerID +"' "+
									  " and a.ITEM = '"+Order_Item+"'"+
									  " and a.ITEM_DESCRIPTION = '"+Item_Desc+"'"+
									  " and a.INVENTORY_ITEM LIKE '"+LineItem +"'"+
									  " and a.organization_id = msi.organization_id"+
									  " and a.inventory_item_id = msi.inventory_item_id"+
									  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
									  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
									  " and msi.ORGANIZATION_ID = '49'"+
									  " and c.CATEGORY_SET_ID = 6"+	
									  " and a.CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20120524
								Statement statement=con.createStatement();
								ResultSet rs = statement.executeQuery(sql);
								rec_cnt=0;
								while(rs.next())
								{
									ITEM_NAME = rs.getString("INVENTORY_ITEM");
									INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
									UOM = rs.getString("PRIMARY_UOM_CODE");
									itemFactory = rs.getString("ATTRIBUTE3");									
									orderType = rs.getString("ORDER_TYPE");		
									tsc_prod_group = rs.getString("TSC_PROD_GROUP");  //add by Peggy 20130319						
									greenFlag = rs.getString("GREEN_FLAG"); //add by Peggy 20150519			
									ITEM_STATUS =rs.getString("INVENTORY_ITEM_STATUS_CODE");  //add by Peggy 20161229
									rec_cnt++;
								}
								rs.close();
								statement.close();									
								if (rec_cnt >1)
								{
									ITEM_NAME=""; 
									throw new Exception("對應的台半料號超過一個以上,請手動選擇正確台半料號<br>");
								}
								if (rec_cnt ==0) throw new Exception("查無對應的ERP料號<br>");
							}
						}
						catch(Exception e)
						{
							allStrErr.append(e.getMessage());
						}
	
						sbf_d.append("<td class='style3'>"+Order_Item+"</td>");
						sbf_d.append("<td class='style3'><input class='style3' type='text' name='itemdesc"+(i+1)+"' value='"+Item_Desc+"' size=15 readonly></td>");
						if (rec_cnt>1)
						{
							sbf_d.append("<td class='style3'><input class='style31' type='text' name='itemname"+(i+1)+"' value='' size=30 readonly>");
							sbf_d.append("<input type='button' name='btn"+(i+1) +"' value='..' onClick='window.open("+'"'+
							"../jsp/subwindow/TscExcelUploadItemInfo.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+"&CUSTITEM="+java.net.URLEncoder.encode(Order_Item)+"&ITEMDESC="+java.net.URLEncoder.encode(Item_Desc)+"&LINEID="+(i+1)+'"'+","+'"'+"subwin"+'"'+","+'"'+"height=200"+'"'+","+'"'+"menubar=no"+'"'+")' title='輸入台半料號!'>");
							ErrCnt++; //客戶料號或台半品名對應到一筆以上的台半料號,須要求User輸入正確的台半料號
						}
						else
						{
							sbf_d.append("<td class='style3'><input class='style3' type='text' name='itemname"+(i+1)+"' value='"+ITEM_NAME+"' size=30 readonly>");
						}
						sbf_d.append("</td>");
						if (!PTYPE.equals("S") && PreOrderType.equals("1302") && ITEM_STATUS.equals("NRND"))  //訂單類型:4121 & ITEM STATUS=NRND,add by Peggy 20161229
						{
							sbf_d.append("<td style='font-family:Tahoma,Georgia;font-size:12px;color=#ff0000' align='center'><div id='itemstatus"+(i+1)+"'>"+ITEM_STATUS+"</div>");
							sbf_d.append("<BR><input type='button' name='btnpass"+(i+1)+"' value='Pass' style='font-family:Tahoma,Georgia;font-size:12px;' onclick='checkitem("+(i+1)+","+'"'+"PASS"+'"'+")'>&nbsp;&nbsp;<input type='button' name='btncancel"+(i+1)+"' value='Cancel' style='font-family:Tahoma,Georgia;font-size:12px;' onclick='checkitem("+(i+1)+","+'"'+"CANCEL"+'"'+")'>");
							sbf_d.append("</td>");  //add by Peggy 20161229
							allStrErr.append("此型號狀態="+ITEM_STATUS+",若確定要下單請按Pass鍵,反之,請按Cancel鍵取消");
							ErrCnt++;
						}
						else
						{
							sbf_d.append("<td class='style6'><div id='itemstatus"+(i+1)+"'>"+ITEM_STATUS+"</div></td>");  //add by Peggy 20161229
						}
						
						// qty
						try
						{
							IssueQty = strDetail[2].trim();
							if (IssueQty == null || IssueQty.equals(""))
							{
								IssueQty = "&nbsp;";
								throw new Exception("Issue Qty不可空白<br>");
							}
							else
							{
								float qtynum = Float.parseFloat(IssueQty.replace(",",""));
								if ( qtynum <= 0)
								{
									throw new Exception("Issue Qty必須大於零<br>");
								}
								else
								{
									IssueQty =(new DecimalFormat("#######0.0#")).format(qtynum);
								}
							}
						}
						catch(Exception e)
						{
							allStrErr.append(e.getMessage());
						}
						sbf_d.append("<td class='style5'>"+IssueQty+"</td>");
						
						//UOM
						sbf_d.append("<td class='style6'><input class='style6' type='text' name='uom"+(i+1) +"' value='"+UOM + "' size=3 readonly></td>");
						
						// Unit Price
						try
						{
							Unit_Price = strDetail[3].trim();
							if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022"))  //add by Peggy 20120525
							{
								if (Unit_Price == null || Unit_Price.equals(""))
								{
									Unit_Price = "&nbsp;";
									throw new Exception("Consign Price不可空白<br>");
								}
								else
								{
									float pricenum = Float.parseFloat(Unit_Price.replace(",",""));
									if ( pricenum <= 0)
									{
										throw new Exception("Consign Price必須大於零<br>");
									}
									else
									{
										Unit_Price =(new DecimalFormat("###,##0.000##")).format(pricenum);
									}
								}
							}
						}
						catch(Exception e)
						{
							allStrErr.append(e.getMessage());
						}			
						sbf_d.append("<td class='style5'>"+(Unit_Price==null||Unit_Price.equals("")?"&nbsp;":Unit_Price)+"</td>");
						
						// Amount 
						try
						{
							if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022"))  //add by Peggy 20120525
							{
								Amount = strDetail[4].trim();
								if (Amount == null || Amount.equals(""))
								{
									Amount = "&nbsp;";
									throw new Exception("Amount不可空白<br>");
								}
								else
								{
									float amt_num = Float.parseFloat(Amount.replace(",",""));
									if ( amt_num <= 0)
									{
										throw new Exception("Amount必須大於零<br>");
									}
									else
									{
										Amount =(new DecimalFormat("##,###,##0.00")).format(amt_num);
									}
								}
							}
						}
						catch(Exception e)
						{
							allStrErr.append(e.getMessage());
						}
						sbf_d.append("<td class='style5'>"+Amount+"</td>");
					
						//Request Date
						try
						{
							RequestDate = strDetail[5].trim();
							if (RequestDate == null || RequestDate.equals(""))
							{
								RequestDate = "&nbsp;";
								throw new Exception("Request Date不可空白<br>");
							}
						}
						catch(Exception e)
						{
							allStrErr.append(e.getMessage());
						}
						sbf_d.append("<td class='style6'>"+RequestDate+"</td>");
						
						//Customer PO
						custPO = strDetail[6].trim();
						//out.println("custPO="+custPO);
						//custPO = custPO.replace('（','(').repacle('）',')');  //add by Peggy 20130327
						sbf_d.append("<td class='style6'>"+custPO+"</td>");
						
						if (!SalesAreaNo.equals("021") && !SalesAreaNo.equals("022")) //add by Peggy 20120525
						{
							//shippingMethod,add by Peggy 20130208
							ShippingMethod = strDetail[7].trim();
							if (ShippingMethod==null || ShippingMethod.equals(""))
							{
								ShippingMethod =ship_via;
							}
						
							//出貨方式
							if (ShippingMethod == null || ShippingMethod.equals(""))
							{
								ShippingMethod = "&nbsp;";
								throw new Exception("出貨方式不可空白<br>");
							}
							else
							{
								boolean bolExist = false;
								String [] strarray= ShippingMethodList.split(";");
								for (int x = 0 ; x < strarray.length ; x++)
								{
									String [] strd = strarray[x].split("@");
									if (ShippingMethod.equals(strd[0]) || ShippingMethod.equals(strd[1]))
									{
										bolExist = true;
										ShippingMethod = strd[1];
									}
								}
								if (!bolExist) throw new Exception("出貨方式不可空白<br>");
							}
							sbf_d.append("<td class='style6'>"+ShippingMethod+"</td>");
				
							//shippingMethod,add by Peggy 20130208
							FOB = strDetail[8].trim();
							if (FOB==null || FOB.equals(""))
							{
								FOB =lineFob;
							}
							//FOB
							if (FOB== null ||FOB.equals(""))
							{
								FOB = "&nbsp;";
								throw new Exception("FOB不可空白<br>");
							}
							else
							{
								boolean bolExist = false;
								String [] strarray= FOBList.split(";");
								for (int x = 0 ; x < strarray.length ; x++)
								{
									if (FOB.equals(strarray[x]))
									{
										bolExist = true;
									}
								}
								if (!bolExist) throw new Exception("FOB不存在<br>");
							}
							sbf_d.append("<td class='style6'>"+FOB+"</td>");
						
							//Remark
							Remark = strDetail[9].trim();
							sbf_d.append("<td class='style6'>"+(Remark==null?"&nbsp;":Remark)+"</td>");
							
							//end customer id
							strEndCustID = strDetail[10].trim();
							if (strEndCustID.startsWith("&nbsp")) strEndCustID="";
							
							strBIRegion=""; //add by Peggy 20170218
						}
						else
						{
							//Remark
							Remark = strDetail[7].trim();
							sbf_d.append("<td class='style6'>"+(Remark==null?"&nbsp;":Remark)+"</td>");

							//end customer id
							strEndCustID = strDetail[8].trim();
							if (strEndCustID.startsWith("&nbsp")) strEndCustID="";

							//bi region,add by Peggy 20170218
							strBIRegion = strDetail[9].trim();
							//out.println("strBIRegion="+strBIRegion);
							//out.println("strBIRegion="+strDetail[10].trim());
							//add by Peggy 20170218	
							if (strBIRegion ==null || strBIRegion.equals("") || strBIRegion.startsWith("&nbsp;"))
							{
								strBIRegion="&nbsp;";
								throw new Exception("BI Region不可空白<br>");											
							}
							else
							{
								boolean bolExist = false;
								//out.println(BIRegionList);
								String [] strarray= BIRegionList.split(";");
								for (int x = 0 ; x < strarray.length ; x++)
								{
									if (strBIRegion.equals(strarray[x]))
									{
										bolExist = true;
									}
								}
								if (!bolExist) throw new Exception("BI Region必須為"+BIRegionList.substring(0,BIRegionList.length()-1).replace(";","或")+"<br>");				
							}	
						}

						//END CUSTOMER
						strEndCust="";strEndCustID1="";
						if (!strEndCustID.equals(""))
						{
							//end customer id不可與customer id相同
							if (strEndCustID.equals(CustomerNo))
							{
								 throw new Exception("End Customer ID:"+strEndCustID+"不可與Customer ID相同");
							}
							else
							{
								if (rss.isBeforeFirst() ==false) rss.beforeFirst();
								while (rss.next())
								{
									if (rss.getString("customer_number").equals(strEndCustID))
									{
										strEndCust = rss.getString("CUSTOMER_NAME_PHONETIC");
										strEndCustID1 =""+rss.getInt("customer_id");
										break;
									}
								}
							}
							if (strEndCust.equals("")) 	throw new Exception("End Customer ID:"+strEndCustID+"不存在ERP");	
						}
						sbf_d.append("<td class='style6'>"+(strEndCustID==null || strEndCustID.equals("")?"&nbsp;":strEndCustID)+"</td>");
						sbf_d.append("<td class='style6'>"+(strEndCust==null || strEndCust.equals("")?"&nbsp;":strEndCust)+"</td>");
											
						if (allStrErr.length() >0)
						{	
							sbf_d.append("<td class='style8'><div id='status"+(i+1)+"'>Error</div></td>");
							sbf_d.append("<td class='style2'><div id='msg"+(i+1)+"'>"+allStrErr+"</div></td>");
							ErrCnt++;
						}
						else
						{
							sbf_d.append("<td class='style8'>&nbsp;</td>");
							sbf_d.append("<td class='style2'>&nbsp;</td>");
						}
						sbf_d.append("</tr>");
						
					
						//add by Peggy 20140409
						//if ((UserRoles.equals("admin") && SalesAreaNo.equals("002"))|| UserName.equals("COCO"))
						if (UserRoles.equals("admin") && SalesAreaNo.equals("018"))  //modify by Peggy 20171221
						{	
							//汽車客戶,S1M R2品質issue,須從山東出貨
							//if ( ((custPO.indexOf("BUEHLER MOTOR")>0 || custPO.indexOf("Marelli(Guangzhou)")>0 ) && itemFactory.equals("008")) || Item_Desc.equals("S1M R2"))
							if ( ((custPO.indexOf("BUEHLER MOTOR")>0 || custPO.indexOf("Marelli(Guangzhou)")>0 ) && itemFactory.equals("008")))  //MODIFY BY Peggy 20160812
							{
								itemFactory="002";
								orderType="1156";
							}
						}
												
						//add by Peggy 20120301
						Statement stateLType=con.createStatement();
						String sqlOrgInf = "";
						if (CustomerID.equals("5274"))
						{
							sqlOrgInf = " select wf.LINE_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
										" where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
										" and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
										" and c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+orderType+"')"+
										" and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
							ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
							if (rsLType.next())
							{
								defaultLineType = rsLType.getString("LINE_TYPE_ID");
							} 
							else 
							{ 
								defaultLineType ="0"; 
							} 
							rsLType.close();
						}
					
						if (!CustomerID.equals("5274") || defaultLineType.equals("0"))
						{
							sqlOrgInf = "select a.DEFAULT_ORDER_LINE_TYPE "+
											"from ORADDMAN.TSAREA_ORDERCLS a, APPS.OE_TRANSACTION_TYPES_V b "+
											"where a.DEFAULT_ORDER_LINE_TYPE=b.TRANSACTION_TYPE_ID and to_char(a.ORDER_NUM) = '"+orderType+"' "+
											"and a.SAREA_NO = '"+SalesAreaNo+"' and a.ACTIVE ='Y' ";					
							ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
							if (rsLType.next())
							{
								defaultLineType = rsLType.getString("DEFAULT_ORDER_LINE_TYPE");
							} 
							else 
							{ 
								defaultLineType ="0"; 
							} 
							rsLType.close();
						}
						stateLType.close();		
						
						Statement statea=con.createStatement();
						//String sqla = " SELECT 1,substr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
						String sqla = " SELECT 1,decode('"+custPO+"','IN SHIN','"+ custPO+"',substr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1))) customer,a.shipping_marks, a.remarks"+
                               " FROM oraddman.tsc_om_remarks_setup a "+
                               " where TSAREANO='"+SalesAreaNo+"'"+
                               //" AND USER_NAME ='"+UserName+"'"+
                               //" AND substr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1)) LIKE '%' || customer||'%'"+
							   " AND '"+custPO+"' LIKE '%' || customer||'%'"+//modify by Peggy 20140111
                               " AND ORDER_TYPE ='"+orderType+"'"+
							   " UNION ALL"+
						       " SELECT 2,substr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPO.replace("'","''")+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
                               " FROM oraddman.tsc_om_remarks_setup a "+
                               " where TSAREANO='"+SalesAreaNo+"'"+
                               //" AND USER_NAME ='"+UserName+"'"+
                               " AND customer='ALL'"+
                               " AND ORDER_TYPE ='"+orderType+"'"+							   
							   " ORDER BY 1";
						//out.println(sqla);
						ResultSet rsa=statea.executeQuery(sqla);
						if (rsa.next())
						{
							shipping_Marks= rsa.getString("shipping_marks");
							shipping_Marks = shipping_Marks.replace("?01",(rsa.getString("customer")==null?custPO:rsa.getString("customer")));
							remarks = rsa.getString("remarks");
							remarks = remarks.replace("?02",(greenFlag.equals("Y")?"green compound":""));
							//out.println(ITEM_NAME);
							//if (ITEM_NAME.substring(10,11).equals("1"))
							//if (ITEM_NAME.length()>0)
							//{
								//if (ITEM_NAME.substring(10,11).equals("1") || (tsc_prod_group.equals("PMD") && ITEM_NAME.substring(3,4).equals("G"))) //PMD料號22碼中第四碼為G表GREEN COMPOUND,add by Peggy 20130319
								//{ 
								//	remarks = remarks.replace("?02","green compound"); 
								//}
								//else
								//{
								//	remarks = remarks.replace("?02",""); 
								//}
							//}
						} 
						else 
						{ 
							shipping_Marks=""; 
							remarks ="";
						} 
						rsa.close();
						statea.close();
							   
						bb[irow][0]=""+(i+1);
						bb[irow][1]=ITEM_NAME;
						bb[irow][2]=Item_Desc;
						bb[irow][3]=IssueQty;
						bb[irow][4]=UOM;
						bb[irow][5]="&nbsp;"; 
						//bb[i][6]=ship_via ;
						bb[irow][6]=ShippingMethod; //add by Peggy 20130208
						bb[irow][7]=RequestDate;
						bb[irow][8]=custPO;
						bb[irow][9]=Remark.replace("&nbsp;","");
						bb[irow][10]="N";
						bb[irow][11]="0";
						bb[irow][12]="0";
						bb[irow][13]=itemFactory;
						bb[irow][14]=Order_Item; //客戶料號 add by Peggy 20120301
						bb[irow][15]=Unit_Price; //單價 add by Peggy 20120301
						bb[irow][16]=orderType; //訂單類型 add by Peggy 20120301
						bb[irow][17]=defaultLineType;  //line type add by peggy 20120301
						//bb[i][18]=lineFob;        //add by Peggy 20120330
						bb[irow][18]=FOB;              //add by Peggy 20130208
						bb[irow][19]="&nbsp;";         //add by Peggy 20120531
						bb[irow][20]="&nbsp;";         //add by Peggy 20120917
						bb[irow][21]=strEndCustID;     //add by Peggy 20140825
						bb[irow][22]=shipping_Marks;   //add by Peggy 20130227
						bb[irow][23]=remarks;          //add by Peggy 20130227
						bb[irow][24]=strEndCust;       //add by Peggy 20140825
						bb[irow][25]="&nbsp;";         //add by Peggy 20150519
						bb[irow][26]="&nbsp;";         //add by Peggy 20160313
						bb[irow][27]=strBIRegion;      //add by Peggy 20170218
						bb[irow][28]="&nbsp;";         //END CUSTOMER SHIP TO ID,add by Peggy 20170512
						bb[irow][29]="&nbsp;";         //End Cust PartNo,add by Peggy 20190227
						cc[irow][0]=""+(i+1);
						cc[irow][1]="D";
						cc[irow][2]="D";
						cc[irow][3]="U";
						cc[irow][4]="U";
						cc[irow][5]="D";
						cc[irow][6]="D";
						cc[irow][7]="U";
						cc[irow][8]="U";
						cc[irow][9]="U";
						cc[irow][10]="P";
						cc[irow][11]="P";
						cc[irow][12]="P";
						cc[irow][13]="D";
						cc[irow][14]="D";
						cc[irow][15]="D";
						cc[irow][16]="D";
						cc[irow][17]="D";
						cc[irow][18]="D";
						cc[irow][19]="D"; //add by Peggy 20120531
						cc[irow][20]="D"; //add by Peggy 20120917
						cc[irow][21]="D"; //add by Peggy 20121107
						cc[irow][22]="T"; //add by Peggy 20130227
						cc[irow][23]="T"; //add by Peggy 20130227
						cc[irow][24]="D"; //add by Peggy 20140825
						cc[irow][25]="D"; //add by Peggy 20150519
						cc[irow][26]="D"; //add by Peggy 20160313
						cc[irow][27]="D"; //add by Peggy 20170218
						cc[irow][28]="D"; //add by Peggy 20170512
						cc[irow][29]="D"; //add by Peggy 20190227
						irow++;
					}
					else
					{
						sbf_d.append("<tr>");
						for (int k = 0 ; k < showcol ; k++)
						{
							if (k <= 6 || k > 8)
							{
								sbf_d.append("<td class='style8'>&nbsp;</td>");
							}
							else if (k == 7)
							{
								sbf_d.append("<td class='style5'>Total:</td>");
							}
							else if (k == 8)
							{
								sbf_d.append("<td class='style5'>"+(new DecimalFormat("##,###,##0.00")).format(Float.parseFloat(strDetail[4].trim().replace(",","")))+"</td>");
							}
						}
						sbf_d.append("</tr>");
					}
				}
				
				rss.close();
				statements.close();
										
				sbf_s.append(sbf_d);
				sbf_s.append("<tr><td colspan="+showcol+"><input type='Button' name='btnsubmit' value='Submit' onClick='setSubmit("+'"'+"../jsp/TSCExcelUploadToImport.jsp?PTYPE=S"+'"'+")' style='font-family:Tahoma,Georgia'></td></tr></table>");
			}
			catch (Exception e) 
			{
				con.rollback();
				ErrCnt++;
				allStrErr.setLength(0);
				allStrErr.append("上傳動作失敗，請洽系統管理員，謝謝！<br>Exception insert:"+e.getMessage()+"<br>");
			}
		}
		else
		{
			ErrCnt++;
			allStrErr.setLength(0);
			sbf_s.setLength(0);
			allStrErr.append("動作失敗，上傳檔案格式錯誤，請重新確認後再上傳，謝謝！");
		}
	}
	catch(Exception e)
	{
		out.println("上傳動作失敗，請洽系統管理員，謝謝！<br>Exception2:"+e.getMessage());
	}
	if (!UploadErr && (PTYPE.equals("U")||PTYPE.equals("S"))) 
	{
		String strInsert="Y";
		String CUSTACTIVE = "A";
		String Remark_h="Order Import from file";
		String ISMODELSELECTED = "Y";
		String PROGRAM_NAME="";
		if (SalesAreaNo.equals("021") || SalesAreaNo.equals("022"))
		{
			SalesPerson = "SAMPLE";
			toPersonID  = "100001180";
		}
		else
		{
		
			Statement statement=con.createStatement();
			String sSql = " select b.PRIMARY_SALESREP_ID, c.RESOURCE_NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,JTF_RS_DEFRESOURCES_VL c "+
						  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and to_char(a.CUST_ACCOUNT_ID) ='"+CustomerID+"' and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID and a.SHIP_TO_FLAG='P' "+
						  " and c.RESOURCE_ID = b.PRIMARY_SALESREP_ID";
			ResultSet rsSalsPs=statement.executeQuery(sSql);	 
			if (rsSalsPs.next())
			{  
				SalesPerson = rsSalsPs.getString("RESOURCE_NAME");
				toPersonID  = rsSalsPs.getString("PRIMARY_SALESREP_ID");
			}
			rsSalsPs.close();	
			statement.close();	
		}
		arrayRFQDocumentInputBean.setArray2DString(bb);
		arrayRFQDocumentInputBean.setArray2DCheck(cc);
		session.setAttribute("SPQCHECKED","N");
		session.setAttribute("CUSTOMERID",CustomerID);
		session.setAttribute("CUSTOMERNO",CustomerNo);
		session.setAttribute("CUSTOMERNAME",CustomerName);
		session.setAttribute("CUSTOMERPO", CustomerPo);
		session.setAttribute("CURR", Currency);
		session.setAttribute("CUSTACTIVE",CUSTACTIVE);
		session.setAttribute("SALESAREANO",SalesAreaNo);
		session.setAttribute("REMARK",Remark_h);
		session.setAttribute("PREORDERTYPE",PreOrderType);
		session.setAttribute("ISMODELSELECTED",ISMODELSELECTED);
		session.setAttribute("PROCESSAREA",SalesArea);
		session.setAttribute("CUSTOMERIDTMP",CustomerID);
		session.setAttribute("INSERT",strInsert);	
		session.setAttribute("MAXLINENO",""+bb.length);
		session.setAttribute("SALESPERSONID",toPersonID);
		session.setAttribute("SALESPERSON",SalesPerson);
		session.setAttribute("PAR_ORG_ID",PAR_ORG_ID);
		session.setAttribute("RFQ_TYPE",RFQ_TYPE);	
		session.setAttribute("PROGRAMNAME","D4-011");
		if (RFQ_TYPE.equals(rfqTypeName2))
		{
			PROGRAM_NAME ="TSSalesDRQCreateImport.jsp";
		}
		else
		{
			PROGRAM_NAME ="TSSalesDRQ_Create.jsp";		
		}
		String urlDir = PROGRAM_NAME+"?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
		   "&SPQCHECKED=N"+
		   "&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
		   "&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName)+
		   "&CUSTACTIVE="+java.net.URLEncoder.encode(CUSTACTIVE)+
		   "&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
		   "&SALESPERSON="+java.net.URLEncoder.encode(SalesPerson)+
		   "&SALESPERSONID="+java.net.URLEncoder.encode(toPersonID)+
		   "&CUSTOMERPO="+java.net.URLEncoder.encode(CustomerPo)+
		   "&CURR="+java.net.URLEncoder.encode(Currency)+
		   "&REMARK="+java.net.URLEncoder.encode(Remark_h)+
		   "&PREORDERTYPE="+java.net.URLEncoder.encode(PreOrderType)+
		   "&ISMODELSELECTED="+java.net.URLEncoder.encode(ISMODELSELECTED)+
		   "&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
		   "&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerID)+
		   "&INSERT="+strInsert+
		   "&RFQTYPE="+RFQ_TYPE+
		   "&PROGRAMNAME=D4-011";
		session.setAttribute("D4011URL",urlDir);
		//debug用,別刪
		//out.println("<tr><td width='100%'>"+sbf_s.toString()+"</td></tr>");
		if (ErrCnt==0) response.sendRedirect(urlDir);
	}
}
//sql1="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
//pstmt=con.prepareStatement(sql1);
//pstmt.executeUpdate(); 
//pstmt.close();
%>
<table width="100%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
	<tr>
		<TD width="90%"  height="80%" title="回首頁!">
			<A HREF="../ORAddsMainMenu.jsp" style="font-family:標楷體;text-decoration:none;color:#0000FF">
			<STRONG>回首頁</STRONG>
			</A>
		</TD>
		<TD><A HREF="../jsp/samplefiles/D4-011_User_Guide.doc">User Guide</A>				
		</TD>
	</tr>
	<tr>
		<td colspan="2">
			<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  <tr class="style3">
				<td >客戶名稱：</FONT></td>
				<td ><input type="text" class="style3" size="80" name="Customer" value="<%=Customer%>" readonly>
				  <IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='window.open("../jsp/subwindow/TscExcelUploadCustInfo.jsp?CustomerNo=<%=CustomerNo%>","subwin","height=500","menubar=no")' title='請按我!'></td>
			  </tr>
			  <tr class="style3">
				<td >業務區域：</FONT></td>
				<td ><input type="text" class="style3" size="80" name="SalesArea" value="<%=SalesArea%>" readonly>
			  </tr>
			  <tr class="style3">
				<td >訂單類型：</FONT></td>
				<td >
				<%
				try
        		{   
					Statement statement=con.createStatement();
            		ResultSet rs=null;	
					String sqlOrgInf = " select DISTINCT OTYPE_ID, ORDER_NUM||'('||DESCRIPTION||')' as TRANSACTION_TYPE_CODE "+ 
			                           " from ORADDMAN.TSAREA_ORDERCLS "+
					                   " where  ACTIVE ='Y'  ";							  
					if (UserRoles!="admin" && !UserRoles.equals("admin")) 
					{ 
						if (UserRegionSet==null || UserRegionSet.equals(""))
						{
							sqlOrgInf += "and SAREA_NO = '"+userActCenterNo+"' and PAR_ORG_ID = '"+PAR_ORG_ID+"' ";
						} 
						else 
						{
				    		sqlOrgInf += "and SAREA_NO in ("+UserRegionSet+") and PAR_ORG_ID = '"+PAR_ORG_ID+"' ";
						} 
					}  
					if (SalesAreaNo=="020" || SalesAreaNo.equals("020")) 
					{ 
						sqlOrgInf += "and ORDER_NUM not in ('1121','1122','4121') "; 
					}
					sqlOrgInf +=" order by 2";
					//out.println("sql="+sqlOrgInf);
            		rs=statement.executeQuery(sqlOrgInf);
					String s1=""; 
					String s2=""; 
					out.println("<select NAME='PREORDERTYPE' tabindex='1' >");				  			  
	        		out.println("<OPTION VALUE=-->--");     
	        		while (rs.next())
	        		{            
		    			s1=rs.getString(1); 
		        		s2=rs.getString(2); 
						if (s1.equals(PreOrderType)) 
  		        		{		   					   
                			out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
                		} 
						else 
						{
                    		out.println("<OPTION VALUE='"+s1+"'>"+s2);
                		}    
	        		} 
	        		out.println("</select>"); 
		    		rs.close();   
		    		statement.close(); 
					%>
					<script language="javascript" type="text/JavaScript">
						if (document.getElementById("PREORDERTYPE").length==2)
						{
							document.getElementById("PREORDERTYPE").value =document.getElementById("PREORDERTYPE").options[1].value;
						}
					</script>
					<%
       			} 
        		catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 
				%>
			  </tr>
			  <tr class="style3">
				<td>RFQ類型：</FONT></td>
				<td>
				<input type="radio" name="rfqtype" value="<%=rfqTypeName1%>" <%=rfqTypeNormal%>><%=rfqTypeName1%>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<span <%=showStatus%>><input type="radio" name="rfqtype" value="<%=rfqTypeName2%>" <%=rfqTypeForecast%>><%=rfqTypeName2%></span>
				</td>
			  </tr>
			  <tr class="style3">
				<td width="15%" bgcolor="#AAFFAA" class="style3">Upload File：</font></td>
				<td width="85%" ><INPUT TYPE="FILE" NAME="UPLOADFILE" size="90" class="style3"><% if (!SAMPLEFILE.equals("")) out.println("<A HREF="+'"'+SAMPLEFILE+'"'+">Download Sample File</A>"); else out.println("");%></td>
			  </tr>
			  <tr>
				<td class="style3" colspan=2 title="請按我，謝謝!">
				<input type="button" class="style4" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCExcelUploadToImport.jsp?PTYPE=U')">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
	<TR><TD colspan="2">&nbsp;</td></tr>
	<%
	if (!UploadErr && (PTYPE.equals("U")||PTYPE.equals("S"))) 
	{
		if (ErrCnt>0)
		{
		    if (RFQ_TYPE.equals(rfqTypeName1))
			{
			%>
        		<Script type="text/javascript">
        			document.form1.rfqtype[0].checked=true;
        		</Script>
			<%
			}
			if (RFQ_TYPE.equals(rfqTypeName2))
			{
			%>
        		<Script type="text/javascript">
        			document.form1.rfqtype[1].checked=true;
        		</Script>			
			<%
			}		
			out.println("<tr><td colspan='2' width='100%' class='style17'><strong>"+allStrErr+"</strong></td></tr>");
			out.println("<tr><td colspan='2' width='100%'>"+sbf_s.toString()+"</td></tr>");
		}
	}
	%>
</table>
<input name="CUSTOMERNO" type="HIDDEN" value="<%=CustomerNo%>">
<input name="CUSTOMERNAME" type="HIDDEN" value="<%=CustomerName%>">
<input name="SALESAREANO" type="HIDDEN" value="<%=SalesAreaNo%>">
<input name="CUSTOMERID" type="HIDDEN" value="<%=CustomerID%>">
<input name="PAR_ORG_ID" type="HIDDEN" value="<%=PAR_ORG_ID%>">
<input name="SAMPLEFILE" type="HIDDEN" value="<%=SAMPLEFILE%>">
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
