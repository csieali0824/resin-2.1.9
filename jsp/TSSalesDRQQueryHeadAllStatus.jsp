<!-- 20141008 by Peggy,ccyang�i�d�ݩҦ�statuscode=014��rfq-->
<%@ page language="java" import="java.sql.*"  %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="bean.QryAllChkBoxEditBean,bean.ComboBoxBean,bean.ArrayComboBoxBean,bean.DateBean"%>
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
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq�����ݵe��==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============�H�W�Ϭq�����ݵe��==========-->
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
<%-- �U�誺��ƬO�Ψӱ���O�_�R�����T�{�ʧ@ --%>
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
	if (document.MYFORM.ACTIONID.value=="--")  //��ܨS�����ʧ@
  	{       
   		return(false);
  	} 
  
   	if (document.MYFORM.ACTIONID.value=="004")  //��ܬ�CANCE�ʧ@
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
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxHeadEditBean" scope="session" class="bean.QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
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
  	queryDateFrom=fromYearString+fromMonthString+fromDayString;//�]���j�M����_�l���������
  	String toYear=request.getParameter("TOYEAR");
  	if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  	String toMonth=request.getParameter("TOMONTH");
  	if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  	String toDay=request.getParameter("TODAY");
  	if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
  	queryDateTo=toYearString+toMonthString+toDayString;//�]���j�M����I����������
  	int maxrow=0;//�d�߸���`���� 
  
 	if (userActCenterNo==null || userActCenterNo.equals("")) userActCenterNo = "000"; // �Y�ݫD�~�ȤH���d��,�h�� 000�s��
  
 	try
  	{   
   		Statement statement=con.createStatement();
   		ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF "+
		" where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   		Statement lotStat=con.createStatement();
   		ResultSet lotRs=null; //�����j�M�O�_���帹�s�b����ƶ�
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
   		
  		//���o����`����
   		if (UserRoles.indexOf("admin")>=0) //�Y��admin�h�i�ݨ����
   		{	 
     		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	 		{	 
				lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,"+
				//" ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
				" ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO LIKE '"+searchString+"'");	
				lotRs.next();
	    		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	    		{	
		   			if (statusID.equals("999")) // ��ܥѺ޲z���@������˵� 2006/06/01
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
		        	if (statusID.equals("999")) // ��ܥѺ޲z���@������˵� 2006/06/01
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
	        	if (statusID.equals("999")) // ��ܥѺ޲z���@������˵� 2006/06/01
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
           	{  //out.println("1"); // �Y���~�Ⱥ޲z����PC�ͺޤH���h�i�˵��Ҧ��߰ݳ�
            	if (statusID.equals("036") ) // �Y���A���~�ȥD�ީέ��i�ݥ���߰ݳ��
              	{  
                	if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	                {	//out.println("3");   
                   		lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO "+
						//" and a.DNDOCNO='"+searchString+"'");	
						" and a.DNDOCNO like '"+searchString+"'");	 //modify by Peggy 20111201
		                lotRs.next();
	                    if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
    
		// �Y���A���~�ȳ��(001 ~)�h�u���ۤv�Φۤv���ݷ~�ȳ��Ҷ}�ߪ��߰ݳ��          
			if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //�Y
			{ 
				if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
				{  
					lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
					" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					" where a.DNDOCNO = b.DNDOCNO "+
					//" and a.DNDOCNO = '"+searchString+"'");	
					" and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
					lotRs.next();
					if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
				//�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
				if ( statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 ) 		
				//�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
				{	
					if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						" where a.DNDOCNO = b.DNDOCNO "+
						//" and a.DNDOCNO='"+searchString+"'  ");	
						" and a.DNDOCNO like '"+searchString+"'  "); //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
				//�Y�����A���u�t����Ʃw���Ψ��⬰�u�t��003,�ޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
				{
					if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'  "); //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
					if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
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
				//�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
       			{	
					if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' "+
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' "+ //modify by Peggy 20111201
						" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
						lotRs.next();
						if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
				//�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
       			{	
	       			if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	      			{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y'  ");	 //modify by Peggy 20111201
						lotRs.next();
						if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
	       			if (statusID.equals("002")) //�Y���A�������Ͳ��a,�h�u���즬�󤤤ߤά��ݤ����פ��ߥi�ݨ�����e����
		   			{                                                     // 2004-10-05 028 �T�ŧ��צ^�G�Ŧb�~��
		      			if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
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
						{ // �Y���~�ȥ����ͺޤH��(SlaesPlanner),�h�i�w��Ҧ��~�Ȧa�Ϫ���ڧ@���a����(�~�ȥ������o��userActCenterNo=000)
			           // 2006/04/14 �W�[���P��������,�ȥi���� 010 �� 011����l
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
					{ // �Ҧ����󳣤����ߪ�SQL 
		        		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	          			{
		         			lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
							" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
							//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
							" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
  		         			lotRs.next();
 	             			if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
		   			}  //enf of �O�_��020�ǳƫ�e�T�Ť����A
	   			} //end of �T�ź��ת��A�P�w
			} //end of ���פ����A�P�w	  
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
   	ResultSet lotRs=null; //�����j�M�O�_���帹�s�b����ƶ�   
   	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   	ResultSet rs=null;
   	String sql=null;  
   	if (UserRoles.indexOf("admin")>=0) //�Y���⬰admin�h�i�ݨ�����߰ݳ�
   	{      	 	 
    	if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	   	{
	    	lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
			//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
			" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	//modify by Peggy 20111201
 		  	lotRs.next();
	      	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
	    	if (statusID.equals("999")) // ��ܥѺ޲z���@������˵� 2006/06/01
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
    	// �Y���A���~�ȳ��(001 ~ )�h�u���ۤv�Φۤv���ݷ~�ȳ��Ҷ}�ߪ��߰ݳ�� 
    	if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //�Y�����פ��ΧP�w�����A�hselect���󬰺��פu�{�v�ӤH
		{ 
	  		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	  		{
	     		lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
				" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
				" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");//modify by Peggy 20111201
 		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
	  		if ( statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 ) //�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
	  		{
	     		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	     		{
		    		lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	//modify by Peggy 20111201
 		    		lotRs.next();
	        		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
			//if (  statusID.equals("003") && UserRoles.indexOf("MPC_003")>=0 ) //�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
			if ((statusID.equals("003") || statusID.equals("014")) && UserRoles.indexOf("MPC_003")>=0 ) //modif by Peggy 20141008
			{
				if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b"+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  ");	
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"'  "); //modify by Peggy 20111201	
					lotRs.next();
					if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
				if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
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
			//�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
			{
				if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' "+
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' "+ //modify by Peggy 20111201
					" and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
					lotRs.next();
					if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
			// MSPC_User �s�F�tPC����SAMPLE ORDER
			else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("MSPC_User")>=0 ) 
			//�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
			{
				if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
				{
					lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
					//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' "+
					" and nvl(a.SAMPLE_CHARGE,'Y')='Y' ");	
					lotRs.next();
					if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
				//�Y���A���Ͳ��a����,�h�u���첣�a�γQ���������a���ߥi�ݨ�߰ݳ��
				{                                                     
					if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
					{
						lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
						" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
						//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"'  ");	
						" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"' and substr(TSAREANO,1,3)>='"+userActCenterNo+"'  ");	
						lotRs.next();
						if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
						{  // �L�帹�ƶq				   
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
					{ // �L����j�M�r���J
						//�Y���A���Ͳ��a����,�h�u���첣�a�γQ���������a���ߥi�ݨ�߰ݳ��	   
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
				{ //out.println("Step17"); // �Y���~�ȥ����ͺޤH��(SlaesPlanner),�h�i�w��Ҧ��~�Ȧa�Ϫ���ڧ@���a����(�~�ȥ������o��userActCenterNo=000)
					if (statusID.equals("004") || statusID.equals("007")) // 2005-05-16 ADD 006
					{
							if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
							{
								lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
								" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	
								lotRs.next();
								if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
							if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
							{
								lotRs=lotStat.executeQuery("select count(DISTINCT a.DNDOCNO) "+
								" from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
								//" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
								" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO like '"+searchString+"'");	
								lotRs.next();
								if (lotRs.getInt(1)>0) //�Y���s�b�帹����
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
					}	//enf of �O�_��020�ǳƫ�e�T�Ť����A
				} //end of �T�ź��ת��A�P�w	 
			} //end of ���פ����A�P�w	  
		}
   		if (rowNumber==1 || rowNumber<0)
   		{
    		rs.beforeFirst(); //���ܲĤ@����ƦC  
   		}
		else 
		{ 
    		if (rowNumber<=maxrow) //�Y�p���`���Ʈɤ~�~�򴫭�
	  	{
       		rs.absolute(rowNumber); //���ܫ��w��ƦC	 
	  	}	
   	}
   
   	String sKeyArray[]=new String[2];   
   	sKeyArray[0]="DNDOCNO";
   	sKeyArray[1]="LSTATUSID";
   	
   	qryAllChkBoxHeadEditBean.setPageURL("../jsp/"+pageURL);
   	qryAllChkBoxHeadEditBean.setPageURL2("");     
   	qryAllChkBoxHeadEditBean.setHeaderArray(null);
   	qryAllChkBoxHeadEditBean.setSearchKeyArray(sKeyArray); // �HsetSearchKeyArray���N��, �]�����ݶǻ���Ӻ����Ѽ�
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
   //���o���׳B�z���A      
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
	     // 2006/04/13�[�J�S���P�y�{,�w��W�����P_�_								  
		if (UserRoles.equals("admin")) whereAct = whereAct+"";  //�Y�O�޲z��,�h����ʧ@��������
		else 
		{
			if (userActCenterNo.equals("010")|| userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='SH' "; // �Y�O�W�����P��ƳB
			else whereAct = whereAct+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{(�]�t012,013�j�����PYEW�W�u��@�v�ݥͦ�MO�y�{ )
		}
	    // 2006/04/13�[�J�S���P�y�{,�w��W�����P_��		  
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
		 // 2006/04/13�[�J�S���P�y�{,�w��W�����P_�_								  
		 if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //�Y�O�޲z��,�h����ʧ@��������
		 else {
		         if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereCnt = whereCnt+"and FORMID='SH' "; // �Y�O�W�����P��ƳB
				 else whereCnt = whereCnt+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{
		      }
	     // 2006/04/13�[�J�S���P�y�{,�w��W�����P_��	
		 sqlCnt = sqlCnt + whereCnt;         
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //�P�_�Y�S���ʧ@�i��ܴN���X�{submit���s
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
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
