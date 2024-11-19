<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!-- 20110117 liling EXPIRATIONDATE -->
<html>
<head>
<title>IQC Inspection Lot Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<!--%@ include file="/jsp/IQCInclude/MProcessStatusBarStart.jsp"%-->
<!--=================================-->
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrIQC2DReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") gfPop.fHideCal();	
}
var checkflag = "false";
function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = true;
		}
 		checkflag = "true";
 		return "取消選取"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "全部選取"; 
	}
}
function submitCheck(ms1,ms2,ms3,ms4)
{         
	flag=confirm("是否確認送出?");
  	if (flag==false) return(false);
  	else
  	{   
    	if (document.DISPLAYREPAIR.SUBINVENTORY.value=="" || document.DISPLAYREPAIR.SUBINVENTORY.value=="null")
     	{
       		alert("請選擇倉別後再送出確認!!"); 
       		document.DISPLAYREPAIR.ACTIONID.value =="--";  
       		return(false);
     	}
      	if (document.DISPLAYREPAIR.ACTIONID.value =="--")    // 如未選擇動作送出,則顯示警告訊息
      	{
        	alert("請選擇執行動作");
	    	return(false);
      	}
        // 若未選擇任一Line 作動作,則警告
        var chkFlag="FALSE";
		var chSubInv = "TRUE"; // 預設已選擇Line倉別
		//	var chSubInv = "FALSE"; // 預設未選擇Line倉別
		var xIndex = "0";
        if (document.DISPLAYREPAIR.CHKFLAG.length!=null)
        {
        	for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
            {
            	if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	            {
	            	chkFlag="TURE";
	            } 
				xINDEX = document.DISPLAYREPAIR.CHKFLAG[i].value; // 取得Index
				formSUBINV_Write = "document.DISPLAYREPAIR.SUBINVENTORY.value";
                xSUBINV = eval(formSUBINV_Write);  // 把值取得給java script 變數
				if ((xSUBINV=="" ||xSUBINV==" " || xSUBINV=="null") && (document.DISPLAYREPAIR.CHKFLAG[i].checked==true))
				{ // 選了Line Check 卻沒給倉別							 
					chSubInv = "FALSE";
				} 
				else 
				{						          
					//alert(subInvWrite);
				}
            }  // End of for	 
						 
			if ((document.DISPLAYREPAIR.SUBINVENTORY.value==null || document.DISPLAYREPAIR.SUBINVENTORY.value=="") &&  chSubInv=="FALSE")
			{
				alert("                  請確實選擇入庫倉別\n若確認所有項次皆入至相同倉別,請選擇上方之入庫倉別");
				return false;
			}
					   
            if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
            {
            	alert("請選擇清單內項目執行送出確認!!");   
                return(false);
            } 

			if (chSubInv == "FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null && document.DISPLAYREPAIR.SUBINVENTORY.value=="")
			{
				alert("請指定清單內倉別後再送出確認!!");  							
	            document.DISPLAYREPAIR.SUBINVCH.focus();	 
                return(false);
			}
			else 
			{
  				// 20200909 Marvie Add : void double click
  				document.DISPLAYREPAIR.submit2.disabled = true;
				return(true); 	
			}
		} // End of if 
  	} // End of flag = true 確認要送出
  	// 20200909 Marvie Delete : no use
  	//document.DISPLAYREPAIR.submit2.disabled = true;
}

function setSubmit1(URL,subInv)
{
	var linkURL = "#ACTION";
  	if (document.DISPLAYREPAIR.SUBINVENTORY.value=="" || document.DISPLAYREPAIR.SUBINVENTORY.value=="null")
  	{
    	alert("請選擇倉別後再送出確認!!"); 
     	document.DISPLAYREPAIR.ACTIONID.value =="--";  
     	return(false);
  	}
  	document.DISPLAYREPAIR.action=URL+"&SUBINVENTORY="+subInv+linkURL;
  	document.DISPLAYREPAIR.submit();    
}

function setSubmit2(URL)
{ 
	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  	document.DISPLAYREPAIR.submit();    
}

// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
 	{ 
 		return true; 
 	}  
 	return false; 
}

function setSubmitComment(URL,xINDEX,xSUBINVLINE,DATECURR)
{    
	warray=new Array(document.DISPLAYREPAIR.EXPIRATIONDATE.value); 
  	// 檢查日期是否符合日期格式 
   	var datetime;
   	var year,month,day;
   	var gone,gtwo;
   	if(warray[0]!="")
   	{
    	datetime=warray[0];
     	if(datetime.length==8)
     	{
        	year=datetime.substring(0,4);
        	if(isNaN(year)==true)
			{
         		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
         		document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
         		return(false);
        	}
        	gone=datetime.substring(4,5);
        	month=datetime.substring(4,6);
        	if(isNaN(month)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
          		return(false);
        	}
        	gtwo=datetime.substring(7,8);
        	day=datetime.substring(6,8);
        	if(isNaN(day)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
          		return(false);
        	}	
          	if(month<1||month>12) 
		  	{ 
            	alert("Month must between 01 and 12 !!"); 
            	document.DISPLAYREPAIR.EXPIRATIONDATE.focus();   
            	return(false); 
          	} 
          	if(day<1||day>31)
		  	{ 
            	alert("Day must between 01 and 31!!");
            	document.DISPLAYREPAIR.EXPIRATIONDATE.focus(); 
            	return(false); 
          	}
			else
			{
            	if(month==2)
				{  
                	if(isLeapYear(year)&&day>29)
					{ 
                    	alert("February between 01 and 29 !!"); 
                      	document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
                      	return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                    	alert("February between 01 and 29 !!");
                     	document.DISPLAYREPAIR.EXPIRATIONDATE.focus(); 
                     	return(false); 
                    } 
                } // End of if(month==2)
                if((month==4||month==6||month==9||month==11)&&(day>30))
				{ 
                	alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   	document.DISPLAYREPAIR.EXPIRATIONDATE.focus(); 
                   	return(false); 
                } 
           	} // End of else 
    	}
		else
		{ 
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
          	return(false);
        }
  	}
	else
	{
    }

  	if (document.DISPLAYREPAIR.EXPIRATIONDATE.value < DATECURR && document.DISPLAYREPAIR.EXPIRATIONDATE.value!= "")
 	{
    	alert("ExpirationDate must greater than today!!");
     	document.DISPLAYREPAIR.EXPIRATIONDATE.focus();
	 	return (false);
  	} 
	else if (document.DISPLAYREPAIR.EXPIRATIONDATE.value=="")
    {
		document.DISPLAYREPAIR.EXPIRATIONDATE.value==DATECURR;
	}

	//檢查日期是否符合日期格式__END
  	var linkURL = "#ACTION";  
  	formCOMMENT = "document.DISPLAYREPAIR.COMMENT"+xINDEX+".focus()";
  	formCOMMENT_Write = "document.DISPLAYREPAIR.COMMENT"+xINDEX+".value";
  	xCOMMENT = eval(formCOMMENT_Write);  // 把值取得給java script 變數
  	formSUBINVENTORY = "document.DISPLAYREPAIR.SUBINVENTORY.focus()";
  	formSUBINVENTORY_Write = "document.DISPLAYREPAIR.SUBINVENTORY.value";
  	xSUBINVENTORY = eval(formSUBINVENTORY_Write);  // 把值取得給java script 變數

	// 重分註記  liling   
  	formDEFFLAG = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".focus()";
  	formDEFFLAG_Write = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".value";
  	xDEFFLAG = eval(formDEFFLAG_Write);  // 把值取得給java script 變數
  
  	if (eval(formSUBINVENTORY_Write)==null || eval(formSUBINVENTORY_Write)=="")
  	{
    	alert("請選擇入庫倉別執行Set動作!!!");
		return false;
  	}
  
  	if ( eval(formSUBINVENTORY_Write) != document.DISPLAYREPAIR.SUBINVENTORY.value)
  	{
    	alert("您選擇項次入庫倉別與抬頭倉別不一致!!!");
	 	document.DISPLAYREPAIR.SUBINVENTORY.focus();
	 	return false;
  	}
  
	//重分註記迄  liling
  	document.DISPLAYREPAIR.action=URL+"&COMMENT"+xINDEX+"="+xCOMMENT+"&LINENO="+xINDEX+"&SUBINVENTORY"+xINDEX+"="+xSUBINVENTORY+"&DEFFLAG"+xINDEX+"="+xDEFFLAG+"&LINENO="+xINDEX+linkURL;   //liling
  	document.DISPLAYREPAIR.submit();    
}
function subWindowSubInventoryFind(organizationID,subInv,subInvDesc)
{    
	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,scrollbars=yes");  
} 
function subWindowSubInventoryFindM(organizationID,subInv,subInvDesc,xINDEX)
{    
  	//alert(subInv+"  "+subInvDesc+"   "+xINDEX);
  	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY"+xINDEX+"="+subInv+"&SUBINVDESC"+xINDEX+"="+subInvDesc+"&XINDEX="+xINDEX,"subwin","width=640,height=480,status=yes,scrollbars=yes");  
} 
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
String inspLotNo=request.getParameter("INSPLOTNO");
//String prodManufactory=request.getParameter("PRODMANUFACTORY");   
String lineNo=request.getParameter("LINENO");
//String pcAcceptDate=request.getParameter("PCACPDATE"); 
String actionID = request.getParameter("ACTIONID");   
String remark = request.getParameter("REMARK");   
String line_No=request.getParameter("LINE_NO");
String recUserID=request.getParameter("RECUSERID");
String statusID=request.getParameter("STATUSID");
String subInv=request.getParameter("SUBINVENTORY");
// String subInvDesc=request.getParameter("SUBINVDESC");
   
String waiveItem=request.getParameter("WAIVEITEM");
//String comment=request.getParameter("COMMENT");
int lineIndex = 1;
if (line_No!=null) lineIndex = Integer.parseInt(line_No);
String comment=request.getParameter("COMMENT"+Integer.toString(lineIndex));
String defFlag =request.getParameter("DEFFLAG"+Integer.toString(lineIndex));   //重分註記  liling
String partTransDef =request.getParameter("PARTTRANSDEF"+Integer.toString(lineIndex));   
String subInventory =request.getParameter("SUBINVENTORY"+Integer.toString(lineIndex)); 
String subInvDesc =request.getParameter("SUBINVDESC"+Integer.toString(lineIndex)); 
String expSetDate=request.getParameter("EXPSETDATE"+Integer.toString(lineIndex));  
String expirationDate=request.getParameter("EXPIRATIONDATE"); 
//out.println("subInventory="+subInventory);
   
if (subInventory==null || subInventory.equals("") || subInventory.equals("null")) { subInventory = ""; }
String assyItemId ="";
String [] check=request.getParameterValues("CHKFLAG");
String primaryQty="";
String primaryUom="";
if (lineNo==null) { lineNo="";} 
if (subInv==null) { subInv = ""; }
//if (subInventory==null) { subInventory="";}
if (subInvDesc==null) { subInvDesc="";}
//if (pcAcceptDate==null) { pcAcceptDate="";}
if (remark==null) { remark=""; }
if (comment==null) comment="";  // 若未指定,預設為 ""
   
CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
cs1.setString(1,userWSOrgID);  // 取品管人員隸屬OrgID
cs1.execute();
//out.println("Procedure : Execute Success !!! ");
cs1.close();
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<BR>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作","請選擇入庫倉別")' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
<!--=============以下區段為取得IQC檢驗批基本資料==========-->
<%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%>
<% 
  if (expirationDate==null || expirationDate.equals("")) expirationDate = dateBean.getYearMonthDay();
%>
<!--=================================-->
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">       
	<tr bgcolor="#CCCC99"> 
    	<td width="10%" nowrap>入庫Sub-Inventory:<img src="../image/point.gif"></td>
	 	<td>
        	<INPUT TYPE="TEXT" NAME="SUBINVENTORY" SIZE=5 value="<%=subInv%>" readonly>
			<input type='button' name='SUBINVCH' value='...' onClick='subWindowSubInventoryFind(<%=organizationID%>,this.form.SUBINVENTORY.value,this.form.SUBINVDESC.value)'>
			<INPUT TYPE="TEXT" NAME="SUBINVDESC" SIZE=40 value="<%=subInvDesc%>">               
     	</td>
   	</tr>
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
	<tr bgcolor="#CCCC99"> 
    	<td colspan="3">
	   		<font color="#000066">處理內容明細: </font><BR>
    		<%  //out.println("userWSEmpID="+userWSEmpID); 
	  		try
      		{   
	    		String transFlag="";
				String oneDArray[]= {"項次","說明","台半料號","收料數量","單位","收料日期","供應商進料批號","備註"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    			arrIQC2DReceivingBean.setArrayString(oneDArray);
				// 先取 該詢問單筆數
	     		int rowLength = 0;
	     		Statement stateCNT=con.createStatement();
         		ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' ");	
	     		if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     		rsCNT.close();
	     		stateCNT.close();
	   			//choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   			String b[][]=new String[rowLength+1][12]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
			   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
			   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
			   out.println("<TABLE cellSpacing='0' bordercolordark='#B5B89A' cellPadding='0' width='100%' align='center' bordercolorlight='#FFFFFF'  border='1'>");
			   out.println("<tr bgcolor='#CCCC99'>");
			   out.println("<td nowrap>");
	   		%>
	   		<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
	   		<%
	   		out.println("</td>");
	   		out.println("<td>項次</td>");
      		out.println("<td nowrap width='1%'><font color='#000000'><div align='center'><img src='../image/point.gif'>到期日</div>");
	   		try
        	{
		  		out.println("<input name='EXPIRATIONDATE' type='text' size='7'  ");
          		if (lineNo!=null) out.println("value="+expirationDate); else out.println("value="+expirationDate);
		  		out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.EXPIRATIONDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
       		} //end of try		 
       		catch (Exception e) 
			{ 
				out.println("Exception:"+e.getMessage()); 
			} 
       		out.println("<td nowrap>收料單(異動明細)</td><td nowrap>供應商進料批號</td><td nowrap>台半料號</td><td nowrap>收料數量</td><td>單位</td><td>收料日期</td><td nowrap>備註</td>");    
	   		int k=0;
	   
	   		String sqlEst = "",poCurrency="",organizationId="";
			//add by Peggy 20130918,排除尚未產生ACCEPT或REJECT交易的資料
			String sqla = " and not exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER x,ORADDMAN.tsciqc_lotinspect_detail y "+
						  " where x.insplot_no=y.insplot_no "+
						  " and y.insplot_no=a.insplot_no"+
						  " and y.line_no = a.line_no"+ //add by Peggy 20140414
						  " and not exists (select 1 from  po.rcv_transactions i"+
						  " where  i.TRANSACTION_TYPE=decode('"+frStatID+"','023','ACCEPT','024','REJECT')"+
						  " and i.po_header_id=y.po_header_id"+
						  " and i.po_line_id=y.po_line_id "+
						  " and i.po_line_location_id=y.po_line_location_id"+
						  " and i.shipment_header_id = y.shipment_header_id"+
						  " and i.shipment_line_id = y.shipment_line_id"+
						  "))";	
	   		if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   		{ 
	     		sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM,INV_ITEM_ID, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, PO_HEADER_ID, PO_LINE_LOCATION_ID, TO_ORGANIZATION_ID, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, PART_TRANS_FLAG, SUBINVENTORY, SHIPMENT_LINE_ID,EXPIRATION_DATE  "+
				  //"  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
				  "  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL a where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' "+sqla+" order by LINE_NO"; 
			}
	   		else 
			{   
	        	sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM,INV_ITEM_ID, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, PO_HEADER_ID, PO_LINE_LOCATION_ID, TO_ORGANIZATION_ID, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, PART_TRANS_FLAG, SUBINVENTORY, SHIPMENT_LINE_ID,EXPIRATION_DATE "+
                       //"  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
						"  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL a where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' "+ sqla+" order by LINE_NO"; 			
			}
       		Statement statement=con.createStatement();
       		ResultSet rs=statement.executeQuery(sqlEst);	
			int rec_cnt =0; //add by Peggy 20130918   
	   		while (rs.next())
	   		{
				rec_cnt ++;
	       		// 找Oracle Deliver 的Transaction Type_起
		      	String recList = "";
			  	int listCNT = 1;
		      	Statement stateDlvr=con.createStatement();
			  	//out.println("select TRANSACTION_TYPE from RCV_TRANSACTIONS where ATTRIBUTE6 = '"+inspLotNo+"' and VENDOR_LOT_NUM = '"+rs.getString("SUPPLIER_LOT_NO")+"' and SHIPMENT_LINE_ID = '"+rs.getString("SHIPMENT_LINE_ID")+"' ");
              	ResultSet rsDlvr=stateDlvr.executeQuery("select TRANSACTION_TYPE, TRANSACTION_DATE from RCV_TRANSACTIONS where VENDOR_LOT_NUM = '"+rs.getString("SUPPLIER_LOT_NO")+"' and SHIPMENT_LINE_ID = '"+rs.getString("SHIPMENT_LINE_ID")+"' order by TRANSACTION_DATE ");	
		      	while (rsDlvr.next())
			  	{
			    	listCNT++;
					if (listCNT==1)
					{
			      		recList = recList+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					} 
					else if (listCNT==2)
				    {
						recList = recList+"&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					} 
					else 
					{
						recList = recList+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					}
			  	}
			  	rsDlvr.close();
			  	stateDlvr.close();
		  		// 找Oracle Deliver 的Transaction Type_迄	   

         		//抓取PO CURRENCY ,判斷若為外銷而幣別為'CNY'者,一律入到'外銷05'暫存倉
			 	String sqlTxnId = " SELECT poh.currency_code FROM po_headers_all poh, po_line_locations_all poll "+
 							   "  WHERE poh.po_header_id = poll.po_header_id AND poll.line_location_id = "+rs.getString("PO_LINE_LOCATION_ID")+" ";
			 	Statement stateTxnId=con.createStatement();
    	     	ResultSet rsTxnId=stateTxnId.executeQuery(sqlTxnId);
			 	if (rsTxnId.next())
			  	{ 
					poCurrency = rsTxnId.getString(1);   
				} //幣別 			
			 	rsTxnId.close();
			 	stateTxnId.close();
             	organizationId=rs.getString("TO_ORGANIZATION_ID");

		 		if ( (organizationId=="327" || organizationId.equals("327")) && (poCurrency=="CNY" || poCurrency.equals("CNY")))
         		{ 
					subInventory="05"; subInv="05"; 
				}
	   
	    		out.print("<TR bgcolor='#CCCC99'>");		
				out.println("<TD width='1%'><div align='center'>");
				out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
				if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
				{
		  			for (int j=0;j<check.length;j++) 
					{ 
						if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  
					}
		  			if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生產日期即設定欲結轉
				} 
				else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
				if (rowLength==1) out.println("checked >"); 	else out.println(" >");		
				out.println("</div></TD>");
				out.println("<TD nowrap>");
				out.print(rs.getString("LINE_NO")+"</TD>");
				out.print("<TD nowrap>");
			%>
        		<!--20071210 -->
				<!--INPUT TYPE='button' value='Set' onClick='setSubmitComment("../jsp/TSIQCInspectLotReceivingPage.jsp?INSPLOTNO=<%//=inspLotNo%>&LINE_NO=<%//=rs.getString("LINE_NO")%>&EXPAND=<%//=expand%>",<%//=rs.getString("LINE_NO")%>,this.form.SUBINVENTORY<%//=rs.getString("LINE_NO")%>.value)'--> 
				<INPUT TYPE='button' value='Set' onClick='setSubmitComment("../jsp/TSIQCInspectLotReceivingPage.jsp?INSPLOTNO=<%=inspLotNo%>&LINE_NO=<%=rs.getString("LINE_NO")%>&EXPAND=<%=expand%>",<%=rs.getString("LINE_NO")%>,this.form.SUBINVENTORY.value,<%=dateBean.getYearMonthDay()%>)'> 
			<%
				if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) // 若是處理項次,則予此次給定comments
				{ 
					out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='"+expirationDate+"' size=7>"); 
				}
				else 
				{ 
		        	if (rs.getString("EXPIRATION_DATE")==null)	out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='' size=7>");  
			    	else out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='"+rs.getString("EXPIRATION_DATE")+"' size=7>"); 
			 	}		
				out.println("</TD>");	

		 		//判斷是否存在切割後料件
		 		int parentInvItemID = 0;
		 		String parentInvItem = null;
		 		String parentItemDesc = null;
	 	 		if (rs.getString("INV_ITEM").substring(0,2).equals("11"))
		 		{
					if (parentInvItemID==0)
			 		{	
			  			transFlag="N";
					} 
					else 
					{
			        	assyItemId = Integer.toString(parentInvItemID);
                     	transFlag="N";			    	
				   	} 
				   
					if (transFlag=="Y" || transFlag.equals("Y")) 
  	  		 		{   
						out.print("<TD nowrap>"); // 自動重分註明_起   liling
						out.print("<select name='DEFFLAG"+rs.getString("LINE_NO")+"' size='1'>"); 
			   			if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) 
			    		{ 
			      			if (defFlag==null || defFlag.equals("Y"))
		 	     			{ 
			      				out.print("<option value='N' >否</option><option value='Y' selected>是</option>");
			     			} 
							else 
							{ 
			            		out.print("<option value='N' selected>否</option><option value='Y'>是</option>"); 
			            	}
			    		}		 
		   	    		else 
						{ 
			          		if (rs.getString("PART_TRANS_FLAG")==null || rs.getString("PART_TRANS_FLAG").equals("Y"))
				  	  		{ 
					   			out.print("<option value='N'>否</option><option value='Y' selected>是</option>");
					  		}
					 		else 
							{ 
					        	out.print("<option value='N' selected>否</option><option value='Y'>是</option>");
					      	}
			         	}  
			    		out.print("</select>");
			    		out.println("</TD>");  // 自動重分註明__迄  liling
		      		}
		      		else 
					{
                    	defFlag="N";
					  	out.print("<INPUT TYPE='hidden' NAME='DEFFLAG"+rs.getString("LINE_NO")+"' value='N'> ");
					}
	    		} 
				else 
				{
		        	out.print("<INPUT TYPE='hidden' NAME='DEFFLAG"+rs.getString("LINE_NO")+"' value='N'> ");
                	defFlag="N";
                } 
		  		if (assyItemId==null || assyItemId.equals(""))  assyItemId="";

				CallableStatement cs3a = con.prepareCall("{call RCV_QUANTITIES_S.get_primary_qty_uom(?,?,?,?,?,?)}");			 
				cs3a.setFloat(1,rs.getFloat("RECEIPT_QTY"));     //   transaction_qty
				cs3a.setString(2,rs.getString("UOM"));                        //   transaction_uom	
				cs3a.setInt(3,Integer.parseInt(rs.getString("INV_ITEM_ID")));     //   item_id	
				cs3a.setInt(4,Integer.parseInt(rs.getString("TO_ORGANIZATION_ID")));     //   organization_id	 			 
				cs3a.registerOutParameter(5, Types.INTEGER);  //回傳 primary_qty
				cs3a.registerOutParameter(6, Types.VARCHAR);  //回傳 primary_uom			
				cs3a.execute();
				//out.println("QTY Exchange : Execute Success !!! ");	             
				primaryQty = cs3a.getString(5);    // 回傳 primary_qty
				primaryUom = cs3a.getString(6);   // 回傳 primary_uom
				//out.print("<br>primaryqty="+primaryQty+"   primaryuom="+primaryUom);
				cs3a.close();	

		 		out.println("<TD nowrap>");
		 	%>
		   		<a onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=recList%>")'>
		 	<% 
				out.print(rs.getString("RECEIPT_NO")); 
			%>
		   		</a>
		 	<%
		   		out.println("</TD>");	
		 		out.println("<TD nowrap>"+rs.getString("SUPPLIER_LOT_NO")+"</TD>");
		 		out.println("<TD nowrap>");
		 	%>
		   		<a onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=parentInvItem%>")'>
		 	<%	 
				out.print(rs.getString("INV_ITEM_DESC")); 
			%>
		   		</a>
		 	<%
		 		out.println("</TD>");
		 		out.println("<TD nowrap>"+rs.getString("RECEIPT_QTY")+"</TD><TD nowrap>"+rs.getString("UOM")+"</TD><TD nowrap>"+rs.getString("RECEIPT_DATE")+"</TD><TD nowrap>"+rs.getString("INSPECT_REMARK")+"</TD></TR>");
		 
		 		b[k][0]=rs.getString("LINE_NO");
				b[k][1]=rs.getString("INV_ITEM");
				b[k][2]=rs.getString("RECEIPT_QTY");
				b[k][3]=rs.getString("UOM");
				b[k][4]=rs.getString("RECEIPT_DATE");
				b[k][5]=rs.getString("SUPPLIER_LOT_NO");
				b[k][6]=rs.getString("INSPECT_REMARK");		 
				b[k][7]=rs.getString("EXPIRATION_DATE");
				b[k][8]=rs.getString("PART_TRANS_FLAG");
				b[k][9]=assyItemId;
				b[k][10]=primaryQty;
				b[k][11]=primaryUom;
		 		arrIQC2DReceivingBean.setArray2DString(b);
		 		k++;
	   		}  
	   		out.println("</TABLE>");
	   		statement.close();
       		rs.close();  
	
			//add by Peggy 20130918
			if (rec_cnt ==0)
			{
				throw new Exception("Not Data Found!!");
			}
			
	    	if ((lineNo !=null && comment!=null && !comment.equals("")) || (lineNo !=null && defFlag!=null && !defFlag.equals("")) || (lineNo !=null && subInventory!=null && !subInventory.equals("")))
	    	{ 
		  		if (defFlag==null || defFlag.equals(""))  defFlag="Y";

 		  		if ( (organizationId=="327" || organizationId.equals("327")) && (poCurrency=="CNY" || poCurrency.equals("CNY")) )
          		{  
					subInventory="05";  
				}

	      		String sql = " update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set EXPIRATION_DATE=? ,PART_TRANS_FLAG=?,EXPDATE_FLAG='N'   where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+lineNo+"' ";
	      		PreparedStatement pstmt=con.prepareStatement(sql);  
          		pstmt.setString(1,expirationDate);  //20110117
		  		pstmt.setString(2,defFlag);  // 2006/11/21 增加 重分註記 FLAG
		  		pstmt.executeUpdate(); 
          		pstmt.close();
       	 	}  
			if (subInv!=null && !subInv.equals("")) // 依使用者選定的Header Subinventory決定入庫倉別
			{  
		 		if ( (organizationId=="327" || organizationId.equals("327")) && (poCurrency=="CNY" || poCurrency.equals("CNY")) )
         		{  
					subInv="05";  
				}
		 
		  		if (defFlag==null || defFlag.equals(""))  defFlag="Y";

		  		String sql = " update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set  PART_TRANS_FLAG=?  where INSPLOT_NO='"+inspLotNo+"' ";
	      		PreparedStatement pstmt=con.prepareStatement(sql);          
 		  		pstmt.setString(1,defFlag);
		  		pstmt.executeUpdate(); 
          		pstmt.close();
			}		
       	}
       	catch (Exception e)
       	{
        	out.println("Exception 2:"+e.getMessage());
       	}
	   
  		boolean rejectFlag = false;  //判斷有效期是否有輸入,否則不顯示action選項
  		try
  		{          
	    	String sqlReject = "SELECT EXPDATE_FLAG FROM ORADDMAN.TSCIQC_LOTINSPECT_DETAIL WHERE EXPDATE_FLAG='Y' AND INSPLOT_NO='"+inspLotNo+"' "; // 若找到前一個狀態動作為REJECT,則本頁面動作無法選定APPLY作客戶確認,20110111 加入'004'   
         	Statement stateRej=con.createStatement();
         	ResultSet rsRej=stateRej.executeQuery(sqlReject);
		 	while (rsRej.next())
		 	{
		    	rejectFlag = true;	//若有一筆存在即不可入庫		
		 	}
		 	rsRej.close();
		 	stateRej.close();
   		}
   		catch (Exception e)
   		{
        	out.println("Exception reject:"+e.getMessage());
   		}	

	    String a[][]=arrIQC2DReceivingBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
        if (a!=null) 
		{		  
		}	//enf of a!=null if		
    	%>       
  	</tr>       
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">          
   	<tr bgcolor="#CCCC99"> 
   		<td width="10%" nowrap>本批次處理說明:</td>
		<td>
			<INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
			<INPUT type="hidden" name="WORKTIME" value="0">
			<INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 >           
		</td>
	</tr>          
</table>
<BR>
<table align="left">
	<tr>
		<td colspan="3">
	   	<strong><font color="#FF0000">執行動作-&gt;</font></strong> 
	   	<a name='#ACTION'>
	<%
	try
    {  
    	String sqlAct="select x1.ACTIONID,decode(x2.ACTIONNAME,'RECEIVE','DELIVER',x2.ACTIONNAME) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' ";
	   	//out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
	   	if (rejectFlag==true)
	   	{
	    	sqlAct = sqlAct+" and x2.ACTIONID !='018' "; // 不顯示DELIVER
	   	}   

       	Statement statement=con.createStatement();
      	ResultSet rs=statement.executeQuery(sqlAct);
	%>
	   	<select NAME='ACTIONID' onChange='setSubmit1("../jsp/TSIQCInspectLotReceivingPage.jsp?INSPLOTNO=<%=inspLotNo%>",this.form.SUBINVENTORY.value)' >				  				  	   
	<%
		out.println("<OPTION VALUE=-->--");     
	   	while (rs.next())
	   	{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
        	if (s1.equals(actionID)) 
  			{
          		out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        	} 
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
	   	} //end of while
	%>
	   	</select>
	<%
	   	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   	rs.next();
	   	if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   	{
        	out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 	out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   	} 
       	rs.close();       
	   	statement.close();
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception e:"+e.getMessage());
    }
    %>
	</a>
		</td>
	</tr>
</table>
<!-- 表單參數 --> 
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<!--%@ include file="/jsp/IQCInclude/MProcessStatusBarStop.jsp"%-->
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
