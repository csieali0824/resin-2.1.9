<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--========2007/09/25 Moon Festiva by Kerwin=============-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
<title>Query All QC Inspection Lot Data by status</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
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
 		return "Cancel Selected"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "Select All"; 
	}
}
function searchRepNo(svrTypeNo,statusID,pageURL) 
{   
	location.href="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
}
function searchIQCDocNo(statusID,pageURL) 
{   
	location.href="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
}
function submitCheck(ms1,ms2)
{  
	if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  	{       
   		return(false);
  	} 
  
  	if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  	{ 
   		flag=confirm(ms1);      
   		if (flag==false)  return(false);
  	} 
  	if ( document.MYFORM.ACTIONID.value=="005" & (document.MYFORM.CHANGEREPPERSONID==null || document.MYFORM.CHANGEREPPERSONID.value=="--")  )
   	{ 
    	alert(ms2);   
    	return(false);
   	}  
   	return(true);      
}  
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<%   
String searchString=request.getParameter("SEARCHSTRING");
if (searchString==null) searchString="";
String statusID=request.getParameter("STATUSID");  
String statusDesc="",statusName="";
String pageURL=request.getParameter("PAGEURL");
String svrTypeNo=request.getParameter("SVRTYPENO");    
String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
String queryDateFrom="",queryDateTo=""; 
String fromYear=request.getParameter("FROMYEAR");  
if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2010"; else fromYearString=fromYear;
String fromMonth=request.getParameter("FROMMONTH"); 
if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
String fromDay=request.getParameter("FROMDAY");
if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
queryDateFrom=fromYearString+fromMonthString+fromDayString;//設為搜尋收件起始日期的條件
String toYear=request.getParameter("TOYEAR");
if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
String toMonth=request.getParameter("TOMONTH");
if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
String toDay=request.getParameter("TODAY");
if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
int maxrow=0;//查詢資料總筆數 
String sql=null;
//out.println(locale);
try
{   
	Statement statement=con.createStatement();
   	ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   	Statement lotStat=con.createStatement();
   	ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   	rs.next();
   	statusDesc=rs.getString("LOCALDESC");
   	statusName=rs.getString("STATUSNAME");     
   	rs.close();  
   
   	//out.println(UserRoles);
   
   	//取得資料總筆數
   	if (UserRoles.indexOf("admin")>=0) //若為admin則可看到全部
   	{	
		String sqla ="";
		//add by Peggy 20130917,select尚未產生ACCEPT或REJECT交易的資料
		if (statusID.equals("023") || statusID.equals("024"))
		{   
			sqla = " and not exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER x,ORADDMAN.tsciqc_lotinspect_detail y "+
						  " where x.insplot_no=y.insplot_no "+
						  //" and x.insplot_no=a.insplot_no"+
						  " and y.insplot_no=b.insplot_no"+//add by Peggy 20140414	
                          " and y.line_no = b.line_no "+//add by Peggy 20140414						  
						  " and not exists (select 1 from  po.rcv_transactions i"+
						  " where  i.TRANSACTION_TYPE=decode('"+statusID+"','023','ACCEPT','024','REJECT')"+
						  " and i.po_header_id=y.po_header_id"+
						  " and i.po_line_id=y.po_line_id "+
						  " and i.po_line_location_id=y.po_line_location_id"+
						  " and i.shipment_header_id = y.shipment_header_id"+
						  " and i.shipment_line_id = y.shipment_line_id"+
						  "))";	
		}
		
    	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
		{	  
			lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
			lotRs.next();
	    	if (lotRs.getInt(1)>0) //若有存在批號的話
	    	{		   
	       		//rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
				//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
				rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+sqla);	
	    	} 
			else 
			{
           		//rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
				//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
           		rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+sqla);	 	 
        	} //end of lotRs if
		  
     	} 
	 	else 
	 	{ 	   
	 		//rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
			//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
			rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+sqla);			
	 	}	 
	 //out.println("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	} 
	else 
	{ 
    	if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0)
        {  //out.println("1"); // 若為IQC檢驗人員則可檢視草稿及檢驗中狀態
        	if (statusID.equals("020") || statusID.equals("021")) // 若狀態為業務主管或員可看任何詢問單件
            {  
            	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {	//out.println("3");   
                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                {		   
	                	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	                } 
					else 
					{
                    	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                    } //end of lotRs if		  
                } 
				else 
				{  
                	//out.println("select count(*) from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	                rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	            }	        
            }
        } 
		
		if (UserRoles.indexOf("PUR_ALL_MGR")>=0)
        { 
        	if (statusID.equals("026")) // 若狀態為採購主管不分類可看任何單件
            {
            	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {
                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                {
	                	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	                } 
					else 
					{ 
                    	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                    }
                } 
				else 
				{ 
                	//out.println("select count(*) from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	                rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	            }	        
            }  
        }  
		
		if (UserRoles.indexOf("PUR_OUT_MGR")>=0)
        {
        	if (statusID.equals("026") ) // 若狀態為採購主管可看外購類
            {  
            	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	        	{
                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"' and a.IQC_CLASS_CODE='04' ");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                {		   
	                	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE='04' ");	
	                } 
					else 
					{
                    	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE='04' ");	 	 
                    }
                } 
				else 
				{  
	            	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE='04' ");
	            }	        
            }
        }

		if (UserRoles.indexOf("PUR_MGR")>=0)
		{
        	if (statusID.equals("026")) // 若狀態為採購主管可看任非外購類
            {  
            	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {
                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"' and a.IQC_CLASS_CODE !='04' ");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                {
	                	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE !='04' ");	
	                } 
					else 
					{
                        rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE !='04' ");	 	 
                    }
                } 
				else 
				{  
	            	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.IQC_CLASS_CODE !='04' ");
	            }	        
            }
        }
		   
		if (UserRoles.indexOf("YEW_AVP")>=0)
		{
        	if (statusID.equals("027") || statusID.equals("028")) // 若狀態為廠主管可看任何合格或特採單件
            {  
            	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {
                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                {		   
	                	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	                } 
					else 
					{
                    	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                    }
                } 
				else 
				{  
	            	rs=statement.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	            }	        
            }  
        } 
		   
    	// 若狀態為022物管核准特採批         
    	if (UserRoles.indexOf("YEW_IQC_MC")>=0 && statusID.equals("022") ) //若
		{ 
	  		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  		{  
	     		lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
  		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //若有存在批號的話
	     		{
		   			sql = "select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";		
		 		} 
				else 
				{
	            	sql = "select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";	
		        } 	 
	  		} 
			else 
			{
		    	sql = "select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";	
	        }	
 	  		rs=statement.executeQuery(sql);	//out.println("Step10"); 
    	}
		else if (UserRoles.indexOf("YEW_STOCKER")>=0) 
	  	{
	   		if (statusID.equals("023") || statusID.equals("024") ) //若為狀態為待倉管入庫中、待倉管批退供應商中或角色為物管且狀態是物管審核批退批確認中則可看到隸屬於其下之詢問單據
       		{	
				//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
				String sqla = " and not exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER x,ORADDMAN.tsciqc_lotinspect_detail y "+
							  " where x.insplot_no=y.insplot_no "+
							  //" and x.insplot_no=a.insplot_no"+
						      " and y.insplot_no=b.insplot_no"+//add by Peggy 20140414	
                              " and y.line_no = b.line_no "+//add by Peggy 20140414								  
							  " and not exists (select 1 from  po.rcv_transactions i"+
							  " where  i.TRANSACTION_TYPE=decode('"+statusID+"','023','ACCEPT','024','REJECT')"+
							  " and to_char(i.po_header_id)=to_char(y.po_header_id)"+
							  " and to_char(i.po_line_id)=to_char(y.po_line_id)"+
							  " and to_char(i.po_line_location_id)=to_char(y.po_line_location_id)"+
							  " and to_char(i.shipment_header_id) = to_char(y.shipment_header_id)"+
							  " and to_char(i.shipment_line_id) = to_char(y.shipment_line_id)"+
							  "))";
			
	      		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	      		{		    
			 		lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') ");	
  		     		lotRs.next();
 	         		if (lotRs.getInt(1)>0) //若有存在批號的話
	        	 	{
			   			//sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') ";	
						//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
						sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') "+ sqla;	
			 		} 
					else 
					{			 
      	            	//sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') ";	
						//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
						sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') "+ sqla;
			        }  			
          		} 
				else 
				{
	            	//sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') ";
					//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
					sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') "+ sqla;
    	        }	
	      		rs=statement.executeQuery(sql);	  
				//out.println(sql); 
	   		} 
			else 
			{
     	    	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	          	{
		        	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
  		         	lotRs.next();
 	             	if (lotRs.getInt(1)>0) //若有存在批號的話
	             	{
			        	sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";
  			     	} 
					else 
					{
    	            	sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";
			     	}	
              	} 
				else 
				{ 
	            	sql ="select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";
    	        }		
	          	rs=statement.executeQuery(sql);	
				//out.println(sql);
	   		}
		}
	}
   	rs.next();   
   	maxrow=rs.getInt(1);
    
   	statement.close();
   	rs.close();   
   	if (lotRs!=null) lotRs.close();
   	lotStat.close();
} //end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
} 
  
String scrollRow=request.getParameter("SCROLLROW");    
int rowNumber=qryAllChkBoxEditBean.getRowNumber();
if (scrollRow==null || scrollRow.equals("FIRST")) 
{
	rowNumber=1;
   	qryAllChkBoxEditBean.setRowNumber(rowNumber);
} 
else 
{
	if (scrollRow.equals("LAST")) 
   	{  	 	 
		qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 	rowNumber=maxrow-300;	 	 	   
   	} 
	else 
	{     
		rowNumber=rowNumber+Integer.parseInt(scrollRow);
     	if (rowNumber<=0) rowNumber=1;
     	qryAllChkBoxEditBean.setRowNumber(rowNumber);
   	}	 
}          
  
int currentPageNumber=0,totalPageNumber=0;
totalPageNumber=maxrow/300+1;
if (rowNumber==0 || rowNumber<0)
{
	currentPageNumber=rowNumber/301+1;  
} 
else 
{
	currentPageNumber=rowNumber/300+1; 
}	
if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("確認取消","確認特採項目")' ACTION="../jsp/TSIQCInspectLotMBatchProcess.jsp?FORMID=QC&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 
<strong><font color="#0080C0" size="5">品管IQC檢驗批單據處理</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;檢驗批單據狀態:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>&nbsp;筆記錄)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'>
      &nbsp;&nbsp;</td>
    <td width="84%"><strong><font color="#400040" size="2">請輸入檢驗批單號,供應商,採購單號,收料單號:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchIQCDocNo('<%=statusID%>','<%=pageURL%>')" value='<-查詢'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectLotQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;開單日期
:FROM
<%
try
{	
	//String a[]={"2008","2009","2010","2011","2012","2013","2014","2006","2007"};
	//modify by Peggy 20130905
	int j =0; 
	String a[]= new String[dateBean.getYear()-2006+1];
	for (int i = dateBean.getYear(); i >= 2006 ; i--)
	{
		a[j++] = ""+i; 
	}
    arrayComboBoxBean.setArrayString(a);	   
	if (fromYear!=null) arrayComboBoxBean.setSelection(fromYearString); 
	arrayComboBoxBean.setFieldName("FROMYEAR");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
/
<%
try
{     
    //String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
	//modify by Peggy 20130905
	int j =0; 
	String a[]= new String[12];
	for (int i =1;i <= 12;i++)
	{
		if (i <10)	a[j++] = "0"+i;
		else a[j++] = ""+i;		
	}	    
    arrayComboBoxBean.setArrayString(a);
   	if (fromMonth!=null) arrayComboBoxBean.setSelection(fromMonth);     	   
   	arrayComboBoxBean.setFieldName("FROMMONTH");	   
   	out.println(arrayComboBoxBean.getArrayString());              
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
/
<%
try
{       
	//String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
	//modify by Peggy 20130905
	int  j =0; 
	String a[]= new String[31];
	for (int i =1;i <= 31;i++)
	{
		if (i <10)	a[j++] = "0"+i;
		else a[j++] = ""+i;		
	}			
    arrayComboBoxBean.setArrayString(a);  	   	   
	if (fromDay!=null) arrayComboBoxBean.setSelection(fromDay);
	arrayComboBoxBean.setFieldName("FROMDAY");	   
    out.println(arrayComboBoxBean.getArrayString());              
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
~
TO
<%
try
{	   
	//String a[]={"2008","2009","2010","2011","2012","2013","2014","2006","2007"};
	//modify by Peggy 20130905
	int j =0; 
	String a[]= new String[dateBean.getYear()-2006+1];
	for (int i = dateBean.getYear(); i >= 2006 ; i--)
	{
		a[j++] = ""+i; 
	}
    arrayComboBoxBean.setArrayString(a);	   
	if (toYear!=null) arrayComboBoxBean.setSelection(toYear); 
	arrayComboBoxBean.setFieldName("TOYEAR");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
/
<%
try
{       
	//String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
	//modify by Peggy 20130905
	int j =0; 
	String a[]= new String[12];
	for (int i =1;i <= 12;i++)
	{
		if (i <10)	a[j++] = "0"+i;
		else a[j++] = ""+i;		
	}	    
    arrayComboBoxBean.setArrayString(a);
	if (toMonth!=null) arrayComboBoxBean.setSelection(toMonth);     	   
	arrayComboBoxBean.setFieldName("TOMONTH");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
/
<%
try
{       
	//String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
	//modify by Peggy 20130905
	int  j =0; 
	String a[]= new String[31];
	for (int i =1;i <= 31;i++)
	{
		if (i <10)	a[j++] = "0"+i;
		else a[j++] = ""+i;		
	}			
    arrayComboBoxBean.setArrayString(a);  	   	   
	if (toDay!=null) arrayComboBoxBean.setSelection(toDay); 
	arrayComboBoxBean.setFieldName("TODAY");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
<%   
try
{   
	Statement lotStat=con.createStatement();
   	ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   	ResultSet rs=null;
   	if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部檢驗單
   	{      	 
		String sqla ="";
		//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
		if (statusID.equals("023") || statusID.equals("024"))
		{   
			sqla = " and not exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER x,ORADDMAN.tsciqc_lotinspect_detail y "+
						  " where x.insplot_no=y.insplot_no "+
						  //" and x.insplot_no=a.insplot_no"+
						  " and y.insplot_no=b.insplot_no"+//add by Peggy 20140414	
                          " and y.line_no = b.line_no "+//add by Peggy 20140414	
						  " and not exists (select 1 from  po.rcv_transactions i"+
						  " where  i.TRANSACTION_TYPE=decode('"+statusID+"','023','ACCEPT','024','REJECT')"+
						  " and i.po_header_id=y.po_header_id"+
						  " and i.po_line_id=y.po_line_id "+
						  " and i.po_line_location_id=y.po_line_location_id"+
						  " and i.shipment_header_id = y.shipment_header_id"+
						  " and i.shipment_line_id = y.shipment_line_id"+
						  "))";	
		}
		 
    	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   	{
	    	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
 		  	lotRs.next();
	      	if (lotRs.getInt(1)>0) //若有存在批號的話
	      	{
		    	//rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM as 台半料號, b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量, b.UOM as 單位,b.AUTHOR_NO as 零件承認編號 ,b.SUPPLIER_LOT_NO as 供應商批號, substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC"); 
				//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
				rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM as 台半料號, b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量, b.UOM as 單位,b.AUTHOR_NO as 零件承認編號 ,b.SUPPLIER_LOT_NO as 供應商批號, substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPLOT_NO ='"+searchString+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+sqla+" order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC"); 
		  	} 
			else 
			{		   
            	//rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC");	 	 
				//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
				rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+sqla+" order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC");	 	 
          	}			
       	} 
		else 
		{	 
	    	//out.println("Admin SQL="+"select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM as 台半料號, b.INV_ITEM_DESC as 料號說明,b.SUPPLIER_NAME as 供應商,b.RECEIPT_QTY as 收料數量, b.UOM as 單位,b.AUTHOR_NO as 零件承認編號 ,b.SUPPLIER_LOT_NO as 供應商(晶片)批號, b.INSPECT_REQUIRE as 檢驗要求,DECODE(b.INSPECT_DATE,'N/A','N/A',substr(b.INSPECT_DATE,0,8)) as 檢驗日期, DECODE(b.RECEIPT_DATE,'N/A','N/A',substr(b.RECEIPT_DATE,0,8)) as 收料日期,a.INSPECT_REMARK as 備註,STATUSID as 狀態碼,STATUS as 狀態, substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC"); 
	        //rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"%') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC");			   
			//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
			rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"%') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+sqla+" order by a.INSPLOT_NO, b.LINE_NO, substr(a.CREATION_DATE,0,8) ASC");			   			
	    }	  		
   	} 
	else 
	{
    	// 若狀態為檢驗員且狀態為草稿或檢驗中,則只取自己所屬檢驗單位所開立的檢驗批單據 	
    	if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 && ( statusID.equals("020") || statusID.equals("021") )) //若為維修中或判定中狀態則select條件為維修工程師個人
		{ 
	  		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  		{
	     		lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
 		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //若有存在批號的話
	     		{
		    		sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.INSPECT_DEPT in ("+userInspDeptID+") and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	
	     		}
				else 
				{
		    		sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	     
         		}
      		} 
			else 
			{		      
				sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"; 
	        }		
	  		rs=statement.executeQuery(sql);	  
     	} 
      	else if (UserRoles.indexOf("PUR_ALL_MGR")>=0 && statusID.equals("026") ) // 採購主管不分類授權
	    {
			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	        {
	        	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
 		        lotRs.next();
	            if (lotRs.getInt(1)>0) //若有存在批號的話
	            { 
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	
	            } 
				else 
				{
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	     
                }
            } 
			else 
			{
				sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"; 
	        }		
	        rs=statement.executeQuery(sql);		   
		} 
        else if (UserRoles.indexOf("PUR_OUT_MGR")>=0 && statusID.equals("026") ) // 採購主管授權
	    {
			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	        {
	        	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"' and a.IQC_CLASS_CODE='04' ");	
 		        lotRs.next();
	            if (lotRs.getInt(1)>0) //若有存在批號的話
	            {
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.IQC_CLASS_CODE='04'  order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	
	            } 
				else 
				{
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'   and a.IQC_CLASS_CODE='04' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	     
                }
            } 
			else 
			{		      
				sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.IQC_CLASS_CODE='04'  order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"; 
	        }		
	        rs=statement.executeQuery(sql);		   
		} 
      	else if (UserRoles.indexOf("PUR_MGR")>=0 && statusID.equals("026") ) // 採購主管授權
	    {
			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	        {
	        	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'  and a.IQC_CLASS_CODE !='04' ");	
 		        lotRs.next();
             	if (lotRs.getInt(1)>0) //若有存在批號的話
	            {
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.IQC_CLASS_CODE !='04'  order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	
	            } 
				else 
				{ 
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.IQC_CLASS_CODE !='04' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	     
                }
            } 
			else 
			{
				sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.IQC_CLASS_CODE !='04'  order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"; 
            }		
	        rs=statement.executeQuery(sql);		   
		} 
		else if (UserRoles.indexOf("YEW_AVP")>=0 && (statusID.equals("027") || statusID.equals("028")) ) // 廠主管授權
	    {
			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	        {
	        	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
 		        lotRs.next();
	            if (lotRs.getInt(1)>0) //若有存在批號的話
	            {
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	
	            } 
				else 
				{
		        	sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	     
                }
            } 
			else 
			{		      
				sql = "select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"'  and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"; 
	        }		
	        rs=statement.executeQuery(sql);		   
		} 
		else 
		{
	  		if (UserRoles.indexOf("YEW_IQC_MC")>=0 && statusID.equals("022") ) //若為物管人員
	  		{
	     		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	     		{
		    		lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"' and a.RESULT in ('ACCEPT','REJECT') ");	
 		    		lotRs.next();
	        		if (lotRs.getInt(1)>0) //若有存在批號的話
	        		{
			  			//sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";			 
						//移除 a.RESULT in ('ACCEPT','REJECT') 條件,modify by Peggy 20140417
						sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";			 
	       	 		} 
					else 
					{
			 	 		//sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	 
						//移除 a.RESULT in ('ACCEPT','REJECT') 條件,modify by Peggy 20140417
			 	 		sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";	 
            		}			  
         		} 
				else 
				{
	            	//sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";
					//移除 a.RESULT in ('ACCEPT','REJECT') 條件,modify by Peggy 20140417
					sql ="select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC";					
	            }		
	     		rs=statement.executeQuery(sql);
	  		} 
			else 
	    	{
	     		if (UserRoles.indexOf("YEW_STOCKER")>=0 && (statusID.equals("023") || statusID.equals("024")) ) //
		 		{   
					//add by Peggy 20130917,排除尚未產生ACCEPT或REJECT交易的資料
					String sqla = " and not exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER x,ORADDMAN.tsciqc_lotinspect_detail y "+
                                  " where x.insplot_no=y.insplot_no "+
                                  //" and x.insplot_no=a.insplot_no"+
						          " and y.insplot_no=b.insplot_no"+//add by Peggy 20140414	
                                  " and y.line_no = b.line_no "+//add by Peggy 20140414									  
                                  " and not exists (select 1 from  po.rcv_transactions i"+
                                  " where  i.TRANSACTION_TYPE=decode('"+statusID+"','023','ACCEPT','024','REJECT')"+
                                  " and to_char(i.po_header_id)=to_char(y.po_header_id)"+
                                  " and to_char(i.po_line_id)=to_char(y.po_line_id) "+
                                  " and to_char(i.po_line_location_id)=to_char(y.po_line_location_id)"+
                                  " and to_char(i.shipment_header_id) = to_char(y.shipment_header_id)"+
                                  " and to_char(i.shipment_line_id) = to_char(y.shipment_line_id)"+
                                  "))";
								  
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	                {
	                	lotRs=lotStat.executeQuery("select count(a.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and a.INSPLOT_NO='"+searchString+"'");	
 		                lotRs.next();
	                    if (lotRs.getInt(1)>0) //若有存在批號的話
	                    {
		                	//rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"); 
							//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
							rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+ sqla + " order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC"); 
		                } 
						else 
						{
                            //rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC");	 	 
							//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
							rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and (a.SUPPLIER_NAME like '"+searchString+"%' or a.INSPLOT_NO like '"+searchString+"%' or a.PO_NUMBER like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+ sqla +" order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC");	 	 
                        }			
                   	} 
					else 
					{	
	             		//rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC");
						//已產生ACC或REJ交易者,才能顯示在畫面上,modify by Peggy 21030917
						rs=statement.executeQuery("select DISTINCT a.INSPLOT_NO as INSPLOTNO,b.LINE_NO, b.RECEIPT_NO as 收料單號,b.INV_ITEM_DESC as 料號說明,a.SUPPLIER_SITE_NAME as 供應商,b.RECEIPT_QTY as 收料數量,b.UOM as 單位,b.AUTHOR_NO as 零件承認編號, b.SUPPLIER_LOT_NO as 供應商批號,substr(a.CREATION_DATE,0,8) as 開單日期 from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO = b.INSPLOT_NO and trim(b.LSTATUSID)='"+statusID+"' and a.RESULT in ('ACCEPT','REJECT','WAIVE','01','02','03') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+ sqla +" order by a.INSPLOT_NO,b.LINE_NO, substr( a.CREATION_DATE,0,8) ASC");
	                }	
		  		}         
          		else            
          		{ //out.println("Step17"); // 若為倉管人員(Warehouser),則可針對所有檢驗批合格或批退項目執行
             
		  		}	//enf of 是否為
	  		} //end of 	 
		} //end of 	  
   	}
   	if (rowNumber==1 || rowNumber<0)
   	{
    	rs.beforeFirst(); //移至第一筆資料列  
   	} 
	else 
	{ 
    	if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  	{
        	rs.absolute(rowNumber); //移至指定資料列	 
	  	}	
   	}
   
   	String sKeyArray[]=new String[2];   
   	sKeyArray[0]="INSPLOTNO";
   	sKeyArray[1]="LINE_NO";
   	
   	qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   	qryAllChkBoxEditBean.setPageURL2("");     
   	qryAllChkBoxEditBean.setHeaderArray(null);
   	//qryAllChkBoxEditBean.setSearchKey("DNDOCNO");
   	qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   	qryAllChkBoxEditBean.setFieldName("CH");
   	qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   	qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   	qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   	qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   	//qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   	qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   	qryAllChkBoxEditBean.setRs(rs);   
   	qryAllChkBoxEditBean.setScrollRowNumber(300);
       
   	out.println(qryAllChkBoxEditBean.getRsString());
   
   	statement.close();
   	rs.close();
   	if (lotRs!=null) lotRs.close();
   	lotStat.close();
   //取得維修處理狀態      
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
<%
try
{       
	if (statusID.equals("103"))
	{
    	Statement statement=con.createStatement();         		 		 
		ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE > '0' order by MANUFACTORY_NO");
        comboBoxBean.setRs(rs);	   
	    comboBoxBean.setFieldName("CHANGEREPCENTERNO");	
		out.println("<table width='100%'><tr bgcolor='#FFFF99'>"); 
		out.println("<td>");%>單據轉送<%out.println("<strong><font color='#FF0000'>:");
        out.println(comboBoxBean.getRsString()); 		 
		 
		statement.close();
        rs.close();       
	} 
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
<%
try
{       
	if (statusID.equals("003") || (statusID.equals("004")) || statusID.equals("008"))
	{ 
		String sqlAct = null;
		String whereAct = null;
		 		 
		if (statusID.equals("003") || statusID.equals("004"))
		{ 
			sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		   	whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";		   
		} 
		else if (statusID.equals("008")) 
		{
			sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
			whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID !='013' and x1.LOCALE='"+locale+"'";         										   
		}
		// 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		if (UserRoles.equals("admin")) whereAct = whereAct+"";  //若是管理員,則任何動作不受限制
		else 
		{
			if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='SH' "; // 若是上海內銷辦事處
			else whereAct = whereAct+"and FORMID='TS' "; // 否則一律皆為外銷流程
		}
		// 2006/04/13加入特殊內銷流程,針對上海內銷_迄		  
		sqlAct = sqlAct + whereAct;
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sqlAct);
		comboBoxBean.setRs(rs);
		comboBoxBean.setFieldName("ACTIONID");	 
		out.println("</font></strong></td><TR><TR><td>");%>備註<%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
		// 2005-05-13 add 038 
		// if ((statusID.equals("003") && userActCenterNo.equals("001")) || UserRoles.equals("admin"))
		if (UserRoles.equals("PCController"))
		{ 
	 
			out.println("<strong><font color='#CC3366'>");%>工廠-><%out.println("</font></strong>");
			Statement stateShip=con.createStatement();
			ResultSet rsShip=stateShip.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE >'0' order by MANUFACTORY_NO");	   
			shipTypecomboBoxBean.setRs(rsShip);	   
			shipTypecomboBoxBean.setSelection("--");
			shipTypecomboBoxBean.setFieldName("MANUFACTORY_NO");	   
			out.println(shipTypecomboBoxBean.getRsString());	
			stateShip.close();
			rsShip.close();
			out.println("<BR>");
		} // 執行動作
		out.println("<strong><font color='#FF0000'>");%>執行動作-><%out.println("</font></strong>");
		out.println(comboBoxBean.getRsString());    
	 
		String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
		// 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //若是管理員,則任何動作不受限制
		else 
		{
			if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereCnt = whereCnt+"and FORMID='SH' "; // 若是上海內銷辦事處
			else whereCnt = whereCnt+"and FORMID='QC' "; // 否則一律皆為外銷流程
		}
		// 2006/04/13加入特殊內銷流程,針對上海內銷_迄	
		sqlCnt = sqlCnt + whereCnt;
		rs=statement.executeQuery(sqlCnt);
		rs.next();
		if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
		{	      
			out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
			if (statusID.equals("003") || statusID.equals("004") || statusID.equals("017") )
			{
				out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>寄發郵件通知<%
			}	
		}		 
		statement.close();		 
		rs.close();   
	} //end of if "003":"008":"010":"006":"015":"016":"017" 
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

