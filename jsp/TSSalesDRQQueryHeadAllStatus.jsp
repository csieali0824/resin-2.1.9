<!-- 20141008 by Peggy,ccyang可查看所有statuscode=014的rfq-->
<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
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
<title>Query All Sales Devivery Request Data by status</title>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============以上區段為等待畫面==========-->
<%
if (UserName.indexOf("NONO")>=0)
{
%>
	<meta http-equiv="refresh" content="300">
<%
}
else
{
%>
	<meta http-equiv="Content-Type" content="text/html; charset=big5">
<%
}
%>
</head>
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
	//location.href="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
	//modify by Peggy 20111201
	var URL ="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL;
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 	
}

function searchDNDocNo(statusID,pageURL) 
{   
	//location.href="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
	//modify by Peggy 20111201
	var URL ="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL;
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 	
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

function setDnDocCheck(statusID,pageURL)
{
	if (event.keyCode==13)
   	{ 
    	//location.href="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
		//modify by Peggy 20111201
		var URL ="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL;
		document.MYFORM.action=URL;
		document.MYFORM.submit(); 	
		
   	}
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxHeadEditBean" scope="session" class="QryAllChkBoxEditBean"/>
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
  	if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
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
  
 	if (userActCenterNo==null || userActCenterNo.equals("")) userActCenterNo = "000"; // 若屬非業務人員查詢,則給 000群組
  
 	try
  	{   
   		Statement statement=con.createStatement();
   		ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF "+
		" where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   		Statement lotStat=con.createStatement();
   		ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   		String sql=null;
   		if (rs.next())
   		{
    		statusDesc=rs.getString("LOCALDESC");
    		statusName=rs.getString("STATUSNAME");   
   		} 
		else 
		{
        	statusDesc = "RFQ System Manager Viewer";
			statusName="ALLSTATUS";
        }	
   		rs.close();  
   		
  		//取得資料總筆數
   		if (UserRoles.indexOf("admin")>=0) //若為admin則可看到全部
   		{	 
     		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	 		{	 
				lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,"+
				//" ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
				" ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO LIKE '"+searchString+"'");	
				lotRs.next();
	    		if (lotRs.getInt(1)>0) //若有存在批號的話
	    		{	
		   			if (statusID.equals("999")) // 表示由管理員作全資料檢視 2006/06/01
		   			{	
		      			rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"' "+
						//" and a.DNDOCNO ='"+searchString+"' "+
						" and a.DNDOCNO like '"+searchString+"' "+  //modify by Peggy 20111201
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
		   			}
		   			else 
					{
	              		rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						"from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
						//" and a.DNDOCNO ='"+searchString+"'"+
						" and a.DNDOCNO like '"+searchString+"'"+ //modify by Peggy 20111201
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
					} // end of if (statusID.equals("999")) 
	    		} 
				else 
				{
		        	if (statusID.equals("999")) // 表示由管理員作全資料檢視 2006/06/01
		         	{	
				   		rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"' "+
						" and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	  
				 	}
				 	else 
					{ 
                    	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
						" and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
					} 
               	} //end of lotRs if
     		} 
			else 
			{ 
	        	if (statusID.equals("999")) // 表示由管理員作全資料檢視 2006/06/01
			 	{
			    	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
					"from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"'"+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
			 	}
			 	else
				{
	            	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
				} 
	        }	 
   		} 
		else 
		{ 
        	if (UserRoles.indexOf("SalesAdmin")>=0 || UserRoles.indexOf("PCCntroller")>=0)
           	{  //out.println("1"); // 若為業務管理員或PC生管人員則可檢視所有詢問單
            	if (statusID.equals("036") ) // 若狀態為業務主管或員可看任何詢問單件
              	{  
                	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	                {	//out.println("3");   
                   		lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO "+
						//" and a.DNDOCNO='"+searchString+"'");	
						" and a.DNDOCNO like '"+searchString+"'");	 //modify by Peggy 20111201
		                lotRs.next();
	                    if (lotRs.getInt(1)>0) //若有存在批號的話
	                    {		   
	                    	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	                    } 
						else 
						{
                        	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO) "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
							" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                        } //end of lotRs if		  
                    } 
					else 
					{  
	                	rs=statement.executeQuery("select count(DISTINCT a.DNDOCNO)  "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	           		}	        
            	}  // end of if (statusID.equals("036"))       
        	}  // end of if (UserRoles.indexOf("Qassurer")>=0)
    
		// 若狀態為業務單位(001 ~)則只取自己及自己所屬業務單位所開立的詢問單據          
			if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //若
			{ 
				if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
				{  
					lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO "+
					//" and a.DNDOCNO = '"+searchString+"'");	
					" and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
					lotRs.next();
					if (lotRs.getInt(1)>0) //若有存在批號的話
					{
						sql = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						"  where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and REQPERSONID='"+userID+"' and TSAREANO in ("+UserRegionSet+") "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";		
					} 
					else 
					{
						sql = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and REQPERSONID='"+userID+"'"+
						" and TSAREANO in ("+UserRegionSet+") "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO  like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
					} 
		 			//2005-05-16 add
					if (statusID.equals("018")) 
					{ 
						sql = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
					}
				} 
				else 
				{
					if (statusID.equals("018"))  //2005-05-16 add
					{ 
						sql = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") "+
						" and REQUIRE_DATE  between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
					}
					else
					{ 
						sql = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and REQPERSONID='"+userID+"' "+
						" and TSAREANO in ("+UserRegionSet+") and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
					}
				}	
				rs=statement.executeQuery(sql);	//out.println("Step10"); 
			} 
			else 
			{
				//若為狀態為工廠交期排定中或角色為工廠生管且狀態是已排定產期則可看到隸屬於其下之詢問單據
				if ( statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 ) 		
				//若為狀態為工廠交期排定中或角色為工廠生管且狀態是已排定產期則可看到隸屬於其下之詢問單據
				{	
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO "+
						//" and a.DNDOCNO='"+searchString+"'  ");	
						" and a.DNDOCNO like '"+searchString+"'  "); //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //若有存在批號的話
						{
							sql ="select count(DISTINCT a.DNDOCNO) "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b  "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%')"+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%')"+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'"+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";	
						} 
						else 
						{
							sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') "+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%') "+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'   ";	
						}  
					} 
					else 
					{
						sql ="select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";
					}	
					//out.println("MPC="+sql);
					rs=statement.executeQuery(sql);	   
				}
				//MPC_SU
				//if ( statusID.equals("003")  && UserRoles.indexOf("MPC_003")>=0 ) 
				if ( (statusID.equals("003") || statusID.equals("014"))  && UserRoles.indexOf("MPC_003")>=0 )  //modify by Peggy 20141008
				//若為狀態為工廠交期排定中或角色為工廠生003,管且狀態是已排定產期則可看到隸屬於其下之詢問單據
				{
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'  "); //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //若有存在批號的話
						{
							sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') "+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%') "+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";	
						} 
						else 
						{
							sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%')"+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%')"+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'   ";	
						}  
					} 
					else 
					{
						sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";
					}	
	      			rs=statement.executeQuery(sql);	   
	   			}
				else if (statusID.equals("014") && UserRoles.indexOf("SMCUser")>=0 && (UserName.equals("CCYANG") || UserName.equals("RITA_ZHOU"))) //add by Peggy 20141008
				{
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
					{
						//sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						sql ="select count(1) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
						" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%')"+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'   ";	
					} 
					else 
					{
						//sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						sql ="select count(1) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";
					}	
	      			rs=statement.executeQuery(sql);	
				}
			//MPC_SU
			// sample user
        		else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("Sample_User")>=0  ) 
				//若為狀態為工廠交期排定中或角色為工廠生管且狀態是已排定產期則可看到隸屬於其下之詢問單據
       			{	
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' "+
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' "+ //modify by Peggy 20111201
						" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
						lotRs.next();
						if (lotRs.getInt(1)>0) //若有存在批號的話
						{
							sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b  "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') "+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%') "+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
							" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";	
						} 
						else 
						{
							sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') "+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%') "+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
							" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";	
						}  
					} 
					else 
					{
						sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
						" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";
    	        	}	
	      			rs=statement.executeQuery(sql);	   
	   			}
			//// sample user
			// MSPC_User
        		else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("MSPC_User")>=0  ) 
				//若為狀態為工廠交期排定中或角色為工廠生管且狀態是已排定產期則可看到隸屬於其下之詢問單據
       			{	
	       			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	      			{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y'  ");	 //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //若有存在批號的話
						{
			   				sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b  "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') "+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%') "+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";	
			 			} 
						else 
						{
      	       				sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%')"+
							" and (a.DNDOCNO like '"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%')"+ //modify by Peggy 20111201
							" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";	
			 			}  
          			} 
					else 
					{
	            		sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";
    	        	}	
	      			rs=statement.executeQuery(sql);	   
	   			}
				//// MSPC_User
        		else 
				{
	       			if (statusID.equals("002")) //若狀態為分派生產地,則只有原收件中心及相屬之維修中心可看到應後送之件
		   			{                                                     // 2004-10-05 028 三級完修回二級在途中
		      			if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	          			{
			    			if (UserRoles.equals("SalesPlanner") && statusID.equals("002"))
 			    			{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								" and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
								" and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";  
							}
			    			else if (UserRoles.equals("SamplePlanner") && statusID.equals("002"))
 			    			{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
								" and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
								" and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
								" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";  
							}
                			else 
			    			{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								" and ( substr(TSAREANO,1,3) in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%'"+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "; 
							}
              			} 
						else 
						{ // 若為業務企劃生管人員(SlaesPlanner),則可針對所有業務地區的單據作產地分派(業務企劃取得的userActCenterNo=000)
			           // 2006/04/14 增加內銷企劃角色,僅可指派 010 及 011的單子
  		            		if (UserRoles.indexOf("SalesPlanner")>=0 && (statusID.equals("002") 
							|| statusID.equals("004") || statusID.equals("007")))
          	          		{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								" and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
								" and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
							}
  		              		else if (UserRoles.indexOf("SamplePlanner")>=0 && (statusID.equals("002") || statusID.equals("004") 
								|| statusID.equals("007")))
          	          		{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
								" and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
								" and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
								" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' "; 
							}
					  		else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007")))
					  		{ 
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								" and ( substr(TSAREANO,1,3) in ('010','011','012','013') ) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
							}
                      		else if (statusID.equals("020"))
   	                    	{  
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
							}
                        	else
   	                    	{  
								sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"')"+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
							}
    	            	}
	          			rs=statement.executeQuery(sql);	
		   			} 
					else 
					{ // 所有條件都不成立的SQL 
		        		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	          			{
		         			lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
							" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
  		         			lotRs.next();
 	             			if (lotRs.getInt(1)>0) //若有存在批號的話
	             			{
			        			sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								//" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  ) "+
								" and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                    " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
								" or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  ) "+
								//" and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
								" and a.DNDOCNO like '"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"; //modify by Peggy 20111201
  			     			} 
							else 
							{
    	            			sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								//" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  )"+
								" and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                    " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
								" or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  )"+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
			     			}	
              			} 
						else 
						{ 
	            			sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
							//" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) "+
							" and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
							" or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
    	      			}		
	          			rs=statement.executeQuery(sql);	
		   			}  //enf of 是否為020準備後送三級中狀態
	   			} //end of 三級維修狀態判定
			} //end of 維修中狀態判定	  
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
  	int rowNumber=qryAllChkBoxHeadEditBean.getRowNumber();
  	if (scrollRow==null || scrollRow.equals("FIRST")) 
  	{
   		rowNumber=1;
   		qryAllChkBoxHeadEditBean.setRowNumber(rowNumber);
  	} 
	else 
	{
   		if (scrollRow.equals("LAST")) 
   		{  	 	 
	 		qryAllChkBoxHeadEditBean.setRowNumber(maxrow);	 
	 		rowNumber=maxrow-300;	 	 	   
   		} 
		else 
		{     
	 		rowNumber=rowNumber+Integer.parseInt(scrollRow);
     		if (rowNumber<=0) rowNumber=1;
     		qryAllChkBoxHeadEditBean.setRowNumber(rowNumber);
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
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>")' ACTION="../jsp/TSSalesDRQMBatchProcess.jsp?FORMID=TS&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 

<strong><font color="#0080C0" size="5" face="Tahoma,Georgia"><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgProcess"/></font></strong> <FONT COLOR=RED SIZE=4 face="Tahoma,Georgia">&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgRepStatus"/>:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2 face="Tahoma,Georgia">(<jsp:getProperty name="rPH" property="pgTotal"/><%=maxrow%>&nbsp;<jsp:getProperty name="rPH" property="pgRecord"/>)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="23%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
      &nbsp;&nbsp;</td>
    <td width="77%"><strong><font color="#400040" size="2" face="Tahoma,Georgia"><jsp:getProperty name="rPH" property="pgPlsEnter"/><jsp:getProperty name="rPH" property="pgQDocNo"/>,<jsp:getProperty name="rPH" property="pgCustInfo"/>,<jsp:getProperty name="rPH" property="pgCustPONo"/>:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%> >
      <input name="search" type=button onClick="searchDNDocNo('<%=statusID%>','<%=pageURL%>')" value='<-<jsp:getProperty name="rPH" property="pgSearch"/>'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2" face="Tahoma,Georgia"><strong><font color="#FF0080" face="Tahoma,Georgia"><jsp:getProperty name="rPH" property="pgFirst"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2" face="Tahoma,Georgia"><strong><font color="#FF0080" face="Tahoma,Georgia"><jsp:getProperty name="rPH" property="pgLast"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A><font color="#FF0080" face="Tahoma,Georgia"><strong><font size="2" face="Tahoma,Georgia">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgNext"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgPrevious"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPages"/>)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgCreateFormDate"/>
:FROM
<%
//try
//{	   
//	String a[]={"2006","2007","2008","2009","2010","2011","2012"};
//   arrayComboBoxBean.setArrayString(a);	   
//	if (fromYear!=null) arrayComboBoxBean.setSelection(fromYearString); 
//	arrayComboBoxBean.setFieldName("FROMYEAR");	   
//    out.println(arrayComboBoxBean.getArrayString());              
//} //end of try
//catch (Exception e)
//{
//out.println("Exception2:"+e.getMessage());
//}
//modify by Peggy 20150105
try
{     
	int  j =0; 
	String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
	for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2006 ; i--)
	{
		a[j++] = ""+i; 
	}
	arrayComboBoxBean.setArrayString(a);
	arrayComboBoxBean.setSelection((fromYear==null?"--":fromYear));
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
	String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
    arrayComboBoxBean.setArrayString(a);
	if (fromMonth!=null) arrayComboBoxBean.setSelection(fromMonth);     	   
	arrayComboBoxBean.setFieldName("FROMMONTH");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception3:"+e.getMessage());
}
%>
/
<%
try
{       
	String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
    arrayComboBoxBean.setArrayString(a);  	   	   
	if (fromDay!=null) arrayComboBoxBean.setSelection(fromDay);
	arrayComboBoxBean.setFieldName("FROMDAY");	   
    out.println(arrayComboBoxBean.getArrayString());                 
} //end of try
catch (Exception e)
{
	out.println("Exception4:"+e.getMessage());
}
%>
~
TO
<%
//try
//{	   
//	String a[]={"2006","2007","2008","2009","2010","2011","2012"};
//    arrayComboBoxBean.setArrayString(a);	   
//	if (toYear!=null) arrayComboBoxBean.setSelection(toYear); 
//	arrayComboBoxBean.setFieldName("TOYEAR");	   
//   out.println(arrayComboBoxBean.getArrayString());              
//} //end of try
//catch (Exception e)
//{
//	out.println("Exception5:"+e.getMessage());
//}
//modify by Peggy 20150105
try
{       
	int  j =0; 
	String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
	for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2006 ; i--)
	{
		a[j++] = ""+i; 
	}
	arrayComboBoxBean.setArrayString(a);
	arrayComboBoxBean.setSelection((toYear==null?"--":toYear));
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
	String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
    arrayComboBoxBean.setArrayString(a);
	if (toMonth!=null) arrayComboBoxBean.setSelection(toMonth);     	   
	arrayComboBoxBean.setFieldName("TOMONTH");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception6:"+e.getMessage());
}
%>
/
<%
try
{       
	String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
    arrayComboBoxBean.setArrayString(a);  	   	   
	if (toDay!=null) arrayComboBoxBean.setSelection(toDay); 
	arrayComboBoxBean.setFieldName("TODAY");	   
    out.println(arrayComboBoxBean.getArrayString());              
} //end of try
catch (Exception e)
{
	out.println("Exception7:"+e.getMessage());
}
%>
<%   
try
{   
	Statement lotStat=con.createStatement();
   	ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   	ResultSet rs=null;
   	String sql=null;  
   	if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部詢問單
   	{      	 	 
    	if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   	{
	    	lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
			//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
			" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
 		  	lotRs.next();
	      	if (lotRs.getInt(1)>0) //若有存在批號的話
	      	{
		    	if (statusID.equals("999"))
				{
		     		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,"+
					"CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
					"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,"+
					" PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"' "+
					//" and a.DNDOCNO ='"+searchString+"' "+
					" and a.DNDOCNO  like '"+searchString+"' "+ //add by Peggy 20111201
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
					" order by a.DNDOCNO,REQUIRE_DATE ASC");  		    
		    	} 
				else 
				{
			    	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+									
					"TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
					"PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
					"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,"+
					"a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
					//" and a.DNDOCNO ='"+searchString+"' "+
					" and a.DNDOCNO like '"+searchString+"' "+ //modify by Peggy 20111201
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC");  
			    }
		  	} 
			else 
			{	
		    	if (statusID.equals("999"))
				{    
		        	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG"+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"' "+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC"); 
				} 
				else 
				{
					rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,"+
					"SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"'"+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC");
				}          
            }			
       	} 
		else 
		{	
	    	if (statusID.equals("999")) // 表示由管理員作全資料檢視 2006/06/01
		    {
				rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
				"TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,"+
				"PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
				"STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
				"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,"+
				"SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID) !='"+statusID+"' "+
				" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
				" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC");  
			}
			else 
			{       
	        	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
				"TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,"+
				"FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID,"+
				" b.LSTATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
				" TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
				" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
				" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
				" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC"); 
			}
	    }	 // End of else
   	} 
	else 
	{                     
    	// 若狀態為業務單位(001 ~ )則只取自己及自己所屬業務單位所開立的詢問單據 
    	if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //若為維修中或判定中狀態則select條件為維修工程師個人
		{ 
	  		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  		{
	     		lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
				" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
				" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");//modify by Peggy 20111201
 		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //若有存在批號的話
	     		{
		    		sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
					"PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
					"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
					"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and REQPERSONID='"+userID+"'"+
					" and TSAREANO in ("+UserRegionSet+")"+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC";	
	     		} 
				else 
				{
		    		sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
					" a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,"+
					" a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					" and REQPERSONID='"+userID+"' and TSAREANO in ("+UserRegionSet+") "+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC";	     
         		}
		 		//2005-05-16 add
		 		if (statusID.equals("018"))			
		   		{ 
					sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
					"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,"+
					"STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
					"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					" and TSAREANO in ("+UserRegionSet+") "+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC";	   
				}
      		} 
			else 
			{
		 		if (statusID.equals("018")) //2005-05-16 add			
		   		{ 
					sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,"+
					" SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") "+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC";	   
				}
         		else
   	       		{ 
					sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					" and REQPERSONID='"+userID+"' and TSAREANO in ("+UserRegionSet+") "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC"; 
				}
	  		}		
	  		rs=statement.executeQuery(sql);	  
    	} 
		else 
		{ //out.println("Step15");  
	  		if ( statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 ) //若為工廠則可看到隸屬於其下之所有被指派之詢問單
	  		{
	     		if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	     		{
		    		lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	//modify by Peggy 20111201
 		    		lotRs.next();
	        		if (lotRs.getInt(1)>0) //若有存在批號的話
	        		{
			  			sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
						"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'"+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
						" order by a.DNDOCNO,REQUIRE_DATE ASC";			 	        		
					}
					else 
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
						"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
						" order by a.DNDOCNO,REQUIRE_DATE ASC";	 
					}			  
				} 
				else 
				{
					//sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
					//"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
					//"STATUS,b.LSTATUSID, b.LSTATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY"+
					//",TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					//" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					//" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					//" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
					//" order by a.DNDOCNO,REQUIRE_DATE ASC";
					//performance issue,modify by Peggy 20140313
					sql ="select a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
					"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
					"STATUS,'"+statusID+"' as LSTATUSID,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY"+
					",TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a "+
					" where substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
					" and exists (select 1 from ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"') "+
					" order by a.DNDOCNO,REQUIRE_DATE ASC";
				}		
				//out.println("2.MPC SQL="+sql);  
				rs=statement.executeQuery(sql);
			}
			//MPC_003
			//if (  statusID.equals("003") && UserRoles.indexOf("MPC_003")>=0 ) //若為工廠則可看到隸屬於其下之所有被指派之詢問單
			if ((statusID.equals("003") || statusID.equals("014")) && UserRoles.indexOf("MPC_003")>=0 ) //modif by Peggy 20141008
			{
				if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  "); //modify by Peggy 20111201	
					lotRs.next();
					if (lotRs.getInt(1)>0) //若有存在批號的話
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
						"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
						" order by a.DNDOCNO,REQUIRE_DATE ASC";			 
					} 
					else 
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
						"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG"+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
						" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
						"  order by a.DNDOCNO,REQUIRE_DATE ASC";	 
					}			  
				}
				else 
				{
					//sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					//"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					//"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					//"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					//" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					//" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
					//" order by a.DNDOCNO,REQUIRE_DATE ASC";
					//performance issue,modify by Peggy 20140313
					sql ="select a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,'"+statusID+"' as LSTATUSID, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a "+
					" where substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
					" and exists (select 1 from ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' )"+
					" order by a.DNDOCNO,REQUIRE_DATE ASC";					
				}	
				//out.println(sql);	
				rs=statement.executeQuery(sql);
			}
			//add by Peggy 20141008
			else if (statusID.equals("014") && UserRoles.indexOf("SMCUser")>=0 && (UserName.equals("CCYANG") || UserName.equals("RITA_ZHOU"))) 
			{
				if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
				{
					sql ="select DISTINCT a.DNDOCNO,'('||a.TSAREANO||')'||c.alname REGION,d.username requestor,b.ITEM_DESCRIPTION,B.LINE_NO"+
					",b.QUANTITY AS \"QTY(K)\""+ //add by Peggy 20230224
					",substr(b.REQUEST_DATE,1,8) SSD"+ //add by Peggy 20230608
					//",TSCUSTOMERID"+
					",CUSTOMER,CUST_PO,CURR,AMOUNT,e.MANUFACTORY_NAME factory,"+
					"a.REMARK,STATUS,b.LSTATUS,b.LSTATUSID"+
					//", a.CREATION_DATE,a.CREATED_BY,"+
					//"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY "+
					//",TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG"+  //modify by Peggy 20230608
					" from ORADDMAN.TSDELIVERY_NOTICE a"+
					",ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
					",oraddman.TSSALES_AREA c"+
					",oraddman.WSUSER d"+
					",oraddman.TSPROD_MANUFACTORY e"+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
					" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
					" and a.TSAREANO=c.sales_area_no"+
					" and a.REQPERSONID=d.WEBID"+
					" and b.ASSIGN_MANUFACT=e.manufactory_no"+						
					" order by B.ITEM_DESCRIPTION,b.REQUEST_DATE,a.DNDOCNO,b.line_no";
				}
				else 
				{
					sql ="select a.DNDOCNO,'('||a.TSAREANO||')'||c.alname REGION,d.username requestor,B.ITEM_DESCRIPTION,B.LINE_NO"+
					",b.QUANTITY AS \"QTY(K)\""+ //add by Peggy 20230224	
					",substr(b.REQUEST_DATE,1,8) SSD"+ //add by Peggy 20230608							
					//",TSCUSTOMERID"+
					",CUSTOMER,CUST_PO,CURR,AMOUNT,e.MANUFACTORY_NAME factory,"+
					"a.REMARK,STATUS,b.LSTATUSID"+
					//",a.CREATION_DATE,a.CREATED_BY,"+
					//"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY "+
					//",TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+  //modify by Peggy 20230608
					" from ORADDMAN.TSDELIVERY_NOTICE a "+
					",ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
					",oraddman.TSSALES_AREA c"+
					",oraddman.WSUSER d"+
					",oraddman.TSPROD_MANUFACTORY e"+					
					" where a.DNDOCNO = b.DNDOCNO and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
					" and b.LSTATUSID='"+statusID+"'"+
					" and a.TSAREANO=c.sales_area_no"+
					" and a.REQPERSONID=d.WEBID"+	
					" and b.ASSIGN_MANUFACT=e.manufactory_no"+				
					" order by B.ITEM_DESCRIPTION,b.REQUEST_DATE,a.DNDOCNO,b.line_no";					
				}	
				//out.println(sql);	
				rs=statement.executeQuery(sql);
			}
			
			//MPC_003
			// SAMPLE USER
			else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("Sample_User")>=0 ) 
			//若為工廠則可看到隸屬於其下之所有被指派之詢問單
			{
				if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' "+
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' "+ //modify by Peggy 20111201
					" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
					lotRs.next();
					if (lotRs.getInt(1)>0) //若有存在批號的話
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
						"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
						"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,"+
						"SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
						" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,REQUIRE_DATE ASC";			 
					} 
					else 
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
						"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' "+
						" and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,REQUIRE_DATE ASC";	 
					}			  
				} 
				else 
				{
					sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
					" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,REQUIRE_DATE ASC";
				}		
				rs=statement.executeQuery(sql);
			}
			// SAMPLE USER
			// MSPC_User 山東廠PC不看SAMPLE ORDER
			else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("MSPC_User")>=0 ) 
			//若為工廠則可看到隸屬於其下之所有被指派之詢問單
			{
				if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" and nvl(a.SAMPLE_CHARGE,'Y')='Y' ");	
					lotRs.next();
					if (lotRs.getInt(1)>0) //若有存在批號的話
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
						"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
						"STATUS,b.LSTATUSID, b.LSTATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
						"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y' "+
						" order by a.DNDOCNO,REQUIRE_DATE ASC";			 
					} 
					else 
					{
						sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
						" CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
						"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
						"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
						" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
						" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
						" and nvl(a.SAMPLE_CHARGE,'Y')='Y' order by a.DNDOCNO,REQUIRE_DATE ASC";	 
					}			  
				} 
				else 
				{
					sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
					"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
					"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
					"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'"+
					" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y'"+
					" order by a.DNDOCNO,REQUIRE_DATE ASC";
				}		
				rs=statement.executeQuery(sql);
			}
			// MSPC_User
			else 
			{  //out.println("UserRoles.equals(SalesPlanner");
				if ((UserRoles.indexOf("SalesPlanner")>=0  || UserRoles.indexOf("SamplePlanner")>=0 
				|| UserRoles.indexOf("CInternal_Planner")>=0) && statusID.equals("002")) 
				//若狀態為生產地移轉,則只有原產地及被指派之產地中心可看到詢問單據
				{                                                     
					if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"'  ");	
						lotRs.next();
						if (lotRs.getInt(1)>0) //若有存在批號的話
						{
							if (UserRoles.indexOf("SalesPlanner")>=0 && statusID.equals("002"))
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									 "CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
									  "PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
									  "a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,"+
									  "a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									  " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									  " where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
									  //" and a.DNDOCNO ='"+searchString+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
									  " and a.DNDOCNO like '"+searchString+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
									  " and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
									  " and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
									  " order by a.DNDOCNO,REQUIRE_DATE ASC";
							}
							else if (UserRoles.indexOf("SamplePlanner")>=0 && statusID.equals("002"))
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
									  "TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,"+
									  "FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, "+
									  "b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
									  "a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									  " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									  //" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and a.DNDOCNO ='"+searchString+"'"+
									  " where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and a.DNDOCNO like '"+searchString+"'"+
									  " and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
									  " and substr(TSAREANO,1,3) not in ('010','011','012','013') ) "+
									  " and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
									  " and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' "+
									  " order by a.DNDOCNO,REQUIRE_DATE ASC";
							}
							else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007")) ) 
							{
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									 "CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
									 "PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
									 "a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,"+
									 "a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									 " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									 //" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and a.DNDOCNO ='"+searchString+"' "+
									 " where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and a.DNDOCNO like '"+searchString+"' "+
									 " and substr(TSAREANO,1,3) in ('010','011','012','013') "+
									 " and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
									 " order by a.DNDOCNO,REQUIRE_DATE ASC";
							}
							else 
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,"+
									"FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, "+
									"b.LSTATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
									"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
									//" and substr(TSAREANO,1,3)>='"+userActCenterNo+"' and a.DNDOCNO ='"+searchString+"' "+
									" and substr(TSAREANO,1,3)>='"+userActCenterNo+"' and a.DNDOCNO like '"+searchString+"' "+
									" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
									" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
							}
						} 
						else 
						{  // 無批號數量				   
							if (UserRoles.indexOf("SalesPlanner")>=0 && statusID.equals("002"))
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
								"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
								"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
								"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
								"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
								" and substr(TSAREANO,1,3) not in ('010','011','012','013') "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
								" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
							}
							else if (UserRoles.indexOf("SamplePlanner")>=0 && statusID.equals("002"))
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
								 "TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,"+
								"PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID,"+
								" b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
								"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
								" and substr(TSAREANO,1,3)>='"+userActCenterNo+"' and substr(TSAREANO,1,3) not in ('010','011','012','013') "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N'"+
								" and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,REQUIRE_DATE ASC"; 
							}
							else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007")) ) 
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
								 "TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE"+
								",FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
								"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
								"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								"from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(TSAREANO,1,3) in ('010','011','012','013')"+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') "+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
								" order by a.DNDOCNO,REQUIRE_DATE ASC";
							}
							else if (statusID.equals("020"))
							{ 
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
								"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
								"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
								"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"')"+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
								"  and (substr(TSAREANO,1,3) in (select tssaleareano from oraddman.tsrecperson "+
			                    " where (USERID='"+UserName+"' or USERNAME='"+UserName+"')))"+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%'"+
								" or CUST_PO like '"+searchString+"%')"+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "+
								" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
							}
							else
							{   
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
								"TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,"+
								"FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID,"+
								" b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
								"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') "+
								" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"'"+
								" and (substr(TSAREANO,1,3) in (select tssaleareano from oraddman.tsrecperson "+
			                    " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))) "+
								" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
								" or CUST_PO like '"+searchString+"%')"+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
								" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
							}
						}			   
					} 
					else 
					{ // 無任何搜尋字串輸入
						//若狀態為生產地移轉,則只有原產地及被指派之產地中心可看到詢問單據	   
						if (UserRoles.indexOf("SalesPlanner")>=0 && statusID.equals("002"))
						{   
							sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
							"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,"+
							"a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
							"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG"+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"'"+
							" and substr(TSAREANO,1,3) not in ('010','011','012','013') "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
							" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
						}
						else if (UserRoles.indexOf("SamplePlanner")>=0 && statusID.equals("002"))
						{   
							sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
							"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
							"PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
							" a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
							"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"' "+
							" and substr(TSAREANO,1,3) not in ('010','011','012','013') "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N'"+
							" and nvl(a.SAMPLE_ORDER,'Y')='Y' "+
							" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
						}
						else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007")) ) 
						{ 
							sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
							"CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,"+
							" STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
							" a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG"+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(TSAREANO,1,3) in ('010','011','012','013') "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
							"  order by a.DNDOCNO,REQUIRE_DATE ASC"; 
						}
						else
						{  
							sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
							"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
							"PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
							" a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
							"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
							"from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"') "+
							" and substr(TSAREANO,1,3) not in ('010','011','012','013') "+
							" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
							" order by a.DNDOCNO,REQUIRE_DATE ASC"; 
						}
					}			
					rs=statement.executeQuery(sql);            
				}         
				else            
				{ //out.println("Step17"); // 若為業務企劃生管人員(SlaesPlanner),則可針對所有業務地區的單據作產地分派(業務企劃取得的userActCenterNo=000)
					if (statusID.equals("004") || statusID.equals("007")) // 2005-05-16 ADD 006
					{
							if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
							{
								lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
								" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	
								lotRs.next();
								if (lotRs.getInt(1)>0) //若有存在批號的話
								{
									sql = "select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									" CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
									" PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
									" a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
									"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
									//" AND TSAREANO>='"+userActCenterNo+"' and a.DNDOCNO ='"+searchString+"' "+
									" AND TSAREANO>='"+userActCenterNo+"' and a.DNDOCNO like '"+searchString+"' "+
									" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
									" order by a.DNDOCNO,REQUIRE_DATE ASC";     
									rs=statement.executeQuery(sql); 
								} 
								else 
								{		   
									rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									" CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
									"PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS,"+
									" a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
									"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									"from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' "+
									" AND TSAREANO>='"+userActCenterNo+"'"+
									" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
									" or CUST_PO like '"+searchString+"%')"+
									" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
									" order by a.DNDOCNO,REQUIRE_DATE ASC");	 	 
								}			
							} 
							else 
							{	
								rs=statement.executeQuery("select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
								"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
								"STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,"+
								"a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								" where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"'"+
								" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
								" order by a.DNDOCNO,REQUIRE_DATE ASC");
							}	       
						} 
						else
						{ //out.println("Step18=NO HOLD SQL");
							if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
							{
								lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
								" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	
								lotRs.next();
								if (lotRs.getInt(1)>0) //若有存在批號的話
								{
									sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,"+
									"CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,"+
									" PROD_FACTORY,a.REMARK,STATUSID,STATUS,b.LSTATUSID, b.LSTATUS, "+
									"a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,"+
									"TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
									" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
									//" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) "+
									" and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                        " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
									" or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) "+
									//" and a.DNDOCNO ='"+searchString+"' "+
									" and a.DNDOCNO like '"+searchString+"' "+
									" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
									" order by a.DNDOCNO,REQUIRE_DATE ASC";
								} 
								else 
								{
									sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
									 "TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,"+
									"PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
									"STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+
									"a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,"+
									"SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
									" where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
									//" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') )"+
									" and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                        " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
									" or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') )"+
									" and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' "+
									" or CUST_PO like '"+searchString+"%')"+
									" and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
									" order by a.DNDOCNO,REQUIRE_DATE ASC";	 
								}			   
							} 
							else 
							{
								sql ="select DISTINCT a.DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
									 "TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,AMOUNT,REQUIRE_DATE,"+
									 "PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,a.REMARK,STATUSID,"+
									 "STATUS,b.LSTATUSID, b.LSTATUS, a.CREATION_DATE,a.CREATED_BY,"+ 
									 "a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,"+
									 "SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG "+
									 " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
									 " where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' "+
									 //" and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') )"+
									 " and (TSAREANO in (select tssaleareano from oraddman.tsrecperson "+
			                         " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
									 " or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') )"+
									 " and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
									 " order by a.DNDOCNO,REQUIRE_DATE ASC";
							}		               
							rs=statement.executeQuery(sql);	
						}
					}	//enf of 是否為020準備後送三級中狀態
				} //end of 三級維修狀態判定	 
			} //end of 維修中狀態判定	  
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
   	sKeyArray[0]="DNDOCNO";
   	sKeyArray[1]="LSTATUSID";
   	
   	qryAllChkBoxHeadEditBean.setPageURL("../jsp/"+pageURL);
   	qryAllChkBoxHeadEditBean.setPageURL2("");     
   	qryAllChkBoxHeadEditBean.setHeaderArray(null);
   	qryAllChkBoxHeadEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   	qryAllChkBoxHeadEditBean.setFieldName("CH");
   	qryAllChkBoxHeadEditBean.setHeadColor("#D8DEA9");
   	qryAllChkBoxHeadEditBean.setHeadFontColor("#0066CC");
   	qryAllChkBoxHeadEditBean.setRowColor1("#E3E4B6");
   	qryAllChkBoxHeadEditBean.setRowColor2("#ECEDCD");
   	qryAllChkBoxHeadEditBean.setTableWrapAttr("nowrap");
   	qryAllChkBoxHeadEditBean.setRs(rs);   
   	qryAllChkBoxHeadEditBean.setScrollRowNumber(300);
       
   	out.println(qryAllChkBoxHeadEditBean.getRsString());
   
   	statement.close();
   	rs.close();
   	if (lotRs!=null) lotRs.close();
   	lotStat.close();
   //取得維修處理狀態      
} //end of try
catch (Exception e)
{
	out.println("Exception8:"+e.getMessage());
}
%>
<%
try
{       
	if (statusID.equals("103"))
	{
    	Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')'"+
		" from ORADDMAN.TSPROD_MANUFACTORY where LOCALE > '0' order by MANUFACTORY_NO");
        comboBoxBean.setRs(rs);	   
	    comboBoxBean.setFieldName("CHANGEREPCENTERNO");	
		out.println("<table width='100%'><tr bgcolor='#FFFF99'>"); 
		out.println("<td>");%><jsp:getProperty name="rPH" property="pgProdTransferTo"/><%out.println("<strong><font color='#FF0000'>:");
        out.println(comboBoxBean.getRsString()); 		 
		 
		statement.close();
        rs.close();       
	} //end if of "003" condition 
} //end of try
catch (Exception e)
{
	out.println("Exception9:"+e.getMessage());
}
%>
<%
try
{       
	//2005-05-13 add 038
	String sqlAct = null;
	String whereAct = null;
	if (statusID.equals("008"))
	{ 
		sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";	
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		if (UserRoles.equals("admin")) whereAct = whereAct+"";  //若是管理員,則任何動作不受限制
		else 
		{
			if (userActCenterNo.equals("010")|| userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='SH' "; // 若是上海內銷辦事處
			else whereAct = whereAct+"and FORMID='TS' "; // 否則一律皆為外銷流程(包含012,013大陸內銷YEW上線後一率需生成MO流程 )
		}
	    // 2006/04/13加入特殊內銷流程,針對上海內銷_迄		  
	    sqlAct = sqlAct + whereAct;
        Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqlAct);
        comboBoxBean.setRs(rs);
     	comboBoxBean.setFieldName("ACTIONID");	 
		out.println("</font></strong></td><TR><TR><td>");%><jsp:getProperty name="rPH" property="pgRemark"/><%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
         // 2005-05-13 add 038 
		// if ((statusID.equals("003") && userActCenterNo.equals("001")) || UserRoles.equals("admin"))
		if (UserRoles.equals("PCController"))
		{ 
		 
		   out.println("<strong><font color='#CC3366'>");%><jsp:getProperty name="rPH" property="pgProdManufactory"/>-><%out.println("</font></strong>");
		   Statement stateShip=con.createStatement();
           ResultSet rsShip=stateShip.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE >'0' order by MANUFACTORY_NO");	   
	       shipTypecomboBoxBean.setRs(rsShip);	   
	       shipTypecomboBoxBean.setSelection("--");
	       shipTypecomboBoxBean.setFieldName("MANUFACTORY_NO");	   
           out.println(shipTypecomboBoxBean.getRsString());	
		   stateShip.close();
		   rsShip.close();
		   out.println("<BR>");
		   
		}
	     out.println("<strong><font color='#FF0000'>");%><jsp:getProperty name="rPH" property="pgAction"/>-><%out.println("</font></strong>");
         out.println(comboBoxBean.getRsString());  
		 String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		 String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
		 // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		 if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //若是管理員,則任何動作不受限制
		 else {
		         if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereCnt = whereCnt+"and FORMID='SH' "; // 若是上海內銷辦事處
				 else whereCnt = whereCnt+"and FORMID='TS' "; // 否則一律皆為外銷流程
		      }
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_迄	
		 sqlCnt = sqlCnt + whereCnt;         
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
		   if (statusID.equals("003") || statusID.equals("010") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
           }			 
	     } 
		 
		 statement.close();		 
         rs.close();       
		} //end of if "003":"008":"010":"006":"015":"016":"017" 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception10:"+e.getMessage());
       }
       %>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
