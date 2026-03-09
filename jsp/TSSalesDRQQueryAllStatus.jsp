<!-- 20130322 liling �s�W���QUANTITY-->
<!-- 20141111 Peggy,�W�[REQUEST_DATE�~�ȻݨD��-->
<!-- 20150105 Peggy,�~�פU�Կ��{����g-->
<!-- 20170823 Peggy,���oraddman.tsdelivery_notice_detail.remark���-->
<%@ page language="java" import="java.sql.*,java.util.Base64"  %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="bean.QryAllChkBoxEditBean,bean.ComboBoxBean,bean.ArrayComboBoxBean,bean.DateBean,bean.Array2DimensionInputBean"%>
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
<title>Query All Sales Devivery Request Data by status</title>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
	<%@ page import="java.util.Arrays" %>
	<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq�����ݵe��==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============�H�W�Ϭq�����ݵe��==========-->
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
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
	location.href="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&TSC_PACKAGE="+document.MYFORM.TSC_PACKAGE.value ;
}

function searchDNDocNo(statusID,pageURL) 
{   
	location.href="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&TSC_PACKAGE="+document.MYFORM.TSC_PACKAGE.value;
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
//add by Peggy 20190812
function setSorting(col,stype)
{
	document.MYFORM.SORT_COL.value=col;
	location.href="../jsp/TSSalesDRQQueryAllStatus.jsp?"+document.MYFORM.STRURL.value+"&SORT_COL="+col+"&SORT_TYPE="+stype;
}
function setUpload(URL)
{
	subWin=window.open(URL,"subwin","left=100,width=700,height=400,scrollbars=yes,menubar=no");  
}

</script>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="bean.QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="bean.Array2DimensionInputBean"/>
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="bean.Array2DimensionInputBean"/>
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
String SORT_COL=request.getParameter("SORT_COL");
if (SORT_COL==null) SORT_COL="";
String SORT_TYPE=request.getParameter("SORT_TYPE");
if (SORT_TYPE==null) SORT_TYPE="";
String TSC_PACKAGE=request.getParameter("TSC_PACKAGE");  //add by Peggy 20210317
if (TSC_PACKAGE==null || TSC_PACKAGE.equals("--")) TSC_PACKAGE="";
String REASON_CODE=""; //add by Peggy 20210817
String STRURL="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+searchString+"&TSC_PACKAGE="+TSC_PACKAGE; 
queryDateTo=toYearString+toMonthString+toDayString;//�]���j�M����I����������
int maxrow=0;//�d�߸���`���� 
  
// �P�_�Y���q��ͦ�,�h���mMO���L��T_�_
if (statusID.equals("009")) //  �Y���A�O 009 �q��ͦ���,�~��ܩ��ӨѨϥΪ̳]�w�����Ѽ�,�_�h,�ϥΪ̵L�k�@����Submit...(����User�ۦ����}�C��JLineNO)
{
	String moContactInfor[]=array2DMOContactInfoBean.getArrayContent(); // ���@���}�C���e
	String moDeliverInfor[]=array2DMODeliverInfoBean.getArrayContent(); // ���@���}�C���e
    if (moContactInfor!=null)
    {
		array2DMOContactInfoBean.setArrayString(null);  
	}
	if (moDeliverInfor!=null)
	{
		array2DMODeliverInfoBean.setArrayString(null); 
	}
} // End of if (statusID.equals("009"))
// �P�_�Y���q��ͦ�,�h���mMO���L��T_��

if (userActCenterNo==null || userActCenterNo.equals("")) userActCenterNo = "000"; // �Y�ݫD�~�ȤH���d��,�h�� 000�s��
try
{   
	Statement statement=con.createStatement();
   	ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   	Statement lotStat=con.createStatement();
   	ResultSet lotRs=null; //�����j�M�O�_���帹�s�b����ƶ�
   	String sql=null;
   	rs.next();
   	statusDesc=rs.getString("LOCALDESC");
   	statusName=rs.getString("STATUSNAME");   
   	rs.close();  
   
   	//���o����`����
   	if (UserRoles.indexOf("admin")>=0) //�Y��admin�h�i�ݨ����
   	{	 
    	//if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	 	//{	  
		//	lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
		//	lotRs.next();
	    //	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	    //	{		   
	    //  		rs=statement.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	    //	} 
		//	else 
		//	{
        //  		rs=statement.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
        //	} //end of lotRs if
     	//} 
		//else 
		//{ 
	   	//	//out.println("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	   	//	rs=statement.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	 	//}	 
		rs=statement.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (a.CUSTOMER like '"+searchString+"%' or b.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"' or b.ITEM_DESCRIPTION like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
   	} 
	else 
	{ 
    	if (UserRoles.indexOf("SalesAdmin")>=0 || UserRoles.indexOf("PCCntroller")>=0)
        {  //out.println("1"); // �Y���~�Ⱥ޲z����PC�ͺޤH���h�i�˵��Ҧ��߰ݳ�
        	if (statusID.equals("036") ) // �Y���A���~�ȥD�ީέ��i�ݥ���߰ݳ��
            {  
            	if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	            {	//out.println("3");   
                	lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
		            lotRs.next();
	                if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	                {		   
	                	rs=statement.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	                } 
					else 
					{
                    	rs=statement.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                    } //end of lotRs if		  
                } 
				else 
				{  
                	//out.println("select count(*) from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	                rs=statement.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	            }	        
            } 
        } 
		   
    	// �Y���A���~�ȳ��(001 ~)�h�u���ۤv�Φۤv���ݷ~�ȳ��Ҷ}�ߪ��߰ݳ��          
    	if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //�Y
		{ 
	  		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	  		{	  
	     		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
  		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	     		{
		   			sql = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";		
		 		} 
				else 
				{
	       			sql = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO  like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
		 		} 
		 		//2005-05-16 add
		 		if (statusID.equals("018")) 
	       		{ 
					sql = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
				}
	  		} 
			else 
			{
		 		if (statusID.equals("018"))  //2005-05-16 add
	       		{ 
					sql = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and substr(REQUIRE_DATE,0,8)  between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
				}
         		else
	       		{ 
					sql = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"; 
				}
	    	}	
			//out.println(sql);
 	  		rs=statement.executeQuery(sql);	//out.println("Step10"); 
    	} 
		else 
		{
	   		if (statusID.equals("003") || (statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 )) //�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
       		{	
	           	sql =" select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				     " where a.DNDOCNO = b.DNDOCNO "+
					 " and b.LSTATUSID='"+statusID+"'"+
					 " and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO like '"+searchString+"%' or b.ITEM_DESCRIPTION like '"+searchString+"%') "+
					 " and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'   "+
					 " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))";
	      		rs=statement.executeQuery(sql);
	    	} 
			else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("Sample_User")>=0 ) //�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
         	{	
	       		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	      		{
			 		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
  		     		lotRs.next();
 	         		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	         		{
			   			sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b  where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";	
			 		} 
					else 
					{
      	       			sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ";	
			 		}  		
          		} 
				else 
				{
	            	sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y'  ";
    	        }
				//out.println(sql);
	      		rs=statement.executeQuery(sql);	   
	    	} 
			else if ((statusID.equals("003") || statusID.equals("004")) && UserRoles.indexOf("MSPC_User")>=0 ) //�Y�����A���u�t����Ʃw���Ψ��⬰�u�t�ͺޥB���A�O�w�Ʃw�����h�i�ݨ����ݩ��U���߰ݳ��
         	{	
	       		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	      		{
			 		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ");	
  		     		lotRs.next();
 	         		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	         		{
			   			sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b  where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";	
			 		} 
					else 
					{
      	       			sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";	
			 		}  		
         		} 
				else 
				{
	             	sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ";
    	        }
				//out.println(sql);
	      		rs=statement.executeQuery(sql);	
	   		}
			else 
			{
	       		if (UserRoles.indexOf("SalesPlanner")>=0 || UserRoles.indexOf("CInternal_Planner")>=0 || UserRoles.indexOf("SamplePlanner")>=0) //�Y����O�����Τ��P����,�h�u���즬�󤤤ߤά��ݤ����פ��ߥi�ݨ�����e����
		   		{                                                     // 2004-10-05 028 �T�ŧ��צ^�G�Ŧb�~��
		      		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	          		{	
			     		sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"') and (a.DNDOCNO='"+searchString+"' or CUSTOMER like '%"+searchString+"%' or CUST_PO='"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  ";
              		} 
					else 
					{ // �Y���~�ȥ����ͺޤH��(SlaesPlanner),�h�i�w��Ҧ��~�Ȧa�Ϫ���ڧ@���a����(�~�ȥ������o��userActCenterNo=000)
  		           		if (UserRoles.indexOf("SalesPlanner")>=0 && (statusID.equals("002") || statusID.equals("004") || statusID.equals("007")))
          	       		{ 
							sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' and substr(TSAREANO,1,3) not in ('010','011','012','013') ) and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
						}
  		           		else if (UserRoles.indexOf("SamplePlanner")>=0 && (statusID.equals("002") || statusID.equals("004") || statusID.equals("007")))
          	       		{ 
							sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"' and substr(TSAREANO,1,3) not in ('010','011','012','013') ) and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' "; 
						}
				   		else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007")))
				   		{ 
				     		sql ="select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ( substr(TSAREANO,1,3) in ('010','011','012','013') ) and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "; 					 
				  		}
                   		else if (statusID.equals("020"))
   	                  	{  
							sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
						}
                     	else
   	                  	{  
							sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)>='"+userActCenterNo+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  "; 
						}
    	      		}
					//out.println(sql);
	          		rs=statement.executeQuery(sql);	
		  		 } 
				 else 
				 { // �Ҧ����󳣤����ߪ�SQL 
     	      		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	          		{
		         		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
  		         		lotRs.next();
 	             		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	             		{
			        		sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  ) and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
  			     		} 
						else 
						{
    	            		sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"')  ) and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
			     		}	
              		} 
					else 
					{ 
	            		sql ="select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
    	      		}		
					//out.println(sql);
	          		rs=statement.executeQuery(sql);
		   		}  
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
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>")' ACTION="../jsp/TSSalesDRQMBatchProcess.jsp?FORMID=TS&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 

<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgProcess"/></font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgRepStatus"/>:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(<jsp:getProperty name="rPH" property="pgTotal"/><%=maxrow%>&nbsp;<jsp:getProperty name="rPH" property="pgRecord"/>)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="23%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	<%if (UserRoles.indexOf("admin")>=0 || UserName.equals("AMANDA") || UserName.equals("FENG_SHUXIA"))
	{
	%>
		&nbsp;&nbsp;
	    <input type="button" name="btnImport" value="Import From Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload('../jsp/TSSalesDRQArrangedPagePCUpload.jsp')">
	<%
	}
	%>
	    &nbsp;&nbsp;</td>
    <td width="77%"><strong><font color="#400040" size="2"><jsp:getProperty name="rPH" property="pgPlsEnter"/><jsp:getProperty name="rPH" property="pgQDocNo"/>,<jsp:getProperty name="rPH" property="pgCustInfo"/>,<jsp:getProperty name="rPH" property="pgCustPONo"/>
	<%
	if (statusID.equals("003") || statusID.equals("004"))
	{
	%>
	,<jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgItemDesc"/>
	<%
	}
	%>
	:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
	 &nbsp;&nbsp;<font style="font-family:Arial;font-size:12px">TSC Package</font>
	 <%
		try
		{  
			String opt_flag="";
			String sql = " SELECT DISTINCT TSC_INV_CATEGORY(b.inventory_item_id,43,23) tsc_package "+
			             " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL b,ORADDMAN.TSDELIVERY_NOTICE a  "+
						 " WHERE b.LSTATUSID='"+statusID+"'"+
						 " AND b.ASSIGN_MANUFACT = "+(userProdCenterNo==null?"b.ASSIGN_MANUFACT":"'"+userProdCenterNo+"'")+
						 " AND b.DNDOCNO=a.DNDOCNO"+
						 " AND a.TSAREANO in ("+(UserRegionSet==null||UserRegionSet.equals("'000'")?"a.TSAREANO":UserRegionSet)+")"+
						 " ORDER BY 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			out.println("<select NAME='TSC_PACKAGE' style='font-family:Tahoma,Georgia;font-size:12px'>");
			out.println("<OPTION VALUE=--"+ (TSC_PACKAGE.equals("") || TSC_PACKAGE.equals("--") ?" selected ":"")+">--");     
			while (rs2.next())
			{  
				if (TSC_PACKAGE.equals(rs2.getString(1))) opt_flag="1";          
           		out.println("<OPTION VALUE='"+rs2.getString(1)+"'"+ (TSC_PACKAGE.equals(rs2.getString(1))?" selected ":"") +">"+rs2.getString(1));
			} 
			out.println("</select>"); 
			if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--") && opt_flag.equals("")) TSC_PACKAGE="";
			
			rs2.close();   
			st2.close();    
					 
			/*String sql = " SELECT DISTINCT TSC_INV_CATEGORY(b.inventory_item_id,43,23) tsc_package,TSC_INV_CATEGORY(b.inventory_item_id,43,23) tsc_package1 "+
			             " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL b,ORADDMAN.TSDELIVERY_NOTICE a  "+
						 " WHERE b.LSTATUSID='"+statusID+"'"+
						 " AND b.ASSIGN_MANUFACT = "+(userProdCenterNo==null?"b.ASSIGN_MANUFACT":"'"+userProdCenterNo+"'")+
						 " AND b.DNDOCNO=a.DNDOCNO"+
						 " AND a.TSAREANO in ("+(UserRegionSet==null||UserRegionSet.equals("'000'")?"a.TSAREANO":UserRegionSet)+")"+
						 " ORDER BY 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(12);
			comboBoxBean.setFontName("ARIAL");
			comboBoxBean.setSelection(TSC_PACKAGE);
			comboBoxBean.setFieldName("TSC_PACKAGE");	
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();
			*/     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}	
	%>
      <input name="search" type="button" onClick="searchDNDocNo('<%=statusID%>','<%=pageURL%>')" value='<-<jsp:getProperty name="rPH" property="pgSearch"/>'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgFirst"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgLast"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgNext"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgPrevious"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPages"/>)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgCreateFormDate"/>
:FROM
<%
     //try
     // {	   
     //  String a[]={"2006","2007","2008","2009","2010","2011","2012","2013"};
     //  arrayComboBoxBean.setArrayString(a);	   
	 //  if (fromYear!=null) arrayComboBoxBean.setSelection(fromYearString); 
	 //  arrayComboBoxBean.setFieldName("FROMYEAR");	   
     //  out.println(arrayComboBoxBean.getArrayString());              
     //  } //end of try
     //  catch (Exception e)
     //  {
     //   out.println("Exception2:"+e.getMessage());
     //  }
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
     // {	   
     //  String a[]={"2006","2007","2008","2009","2010","2011","2012","2013"};
     //  arrayComboBoxBean.setArrayString(a);	   
	 //  if (toYear!=null) arrayComboBoxBean.setSelection(toYear); 
	 //  arrayComboBoxBean.setFieldName("TOYEAR");	   
     //  out.println(arrayComboBoxBean.getArrayString());              
     //  } //end of try
     //  catch (Exception e)
     //  {
     //   out.println("Exception5:"+e.getMessage());
     //  }
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
   		//if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	   	//{
	    //	lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		//  	lotRs.next();
	    //  	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	    //  	{
		//    	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as PCACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
		//  	} 
		//	else 
		//	{		   
        //    	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as PCACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
        //  	}			
       	//}
		//else 
		//{	 
	    //	//out.println("Admin SQL="+"select DISTINCT a.DNDOCNO,b.LINE_NO,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as PCACPDATE,CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,b.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,REQUIRE_DATE ASC"); 
	    //    rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as PCACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");			   
	    //}	  
		sql = " select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as PCACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE"+
		      ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
		      ",b.REASON_CODE"+ //add by Peggy 20210817
		      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%' or b.item_description like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
		if (SORT_COL.equals(""))
		{
			sql += " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
		}
		else
		{
			sql += "order by "+ SORT_COL+ " "+ SORT_TYPE;
		}						
//		out.println("mpc SQL="+sql);
		rs=statement.executeQuery(sql);				
   	} 
	else 
	{
	                     
    	// �Y���A���~�ȳ��(001 ~ )�h�u���ۤv���ݷ~�ȳ��Ҷ}�ߪ��߰ݳ�� 
		// �Y�O�~��,�h�ݨ쪺�O�����w�ƪ����(PCACPDATE)
    	if (statusID.equals("008") || statusID.equals("009") || statusID.equals("010")) //�Y�����פ��ΧP�w�����A�hselect���󬰺��פu�{�v�ӤH
		{ 
	  		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	  		{
	     		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		 		lotRs.next();
	     		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	     		{
		    		sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,NVL(b.ORDER_TYPE_ID,b.ORDER_TYPE_ID) ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                  ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						  ",b.REASON_CODE"+ //add by Peggy 20210817
					      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
				      	  " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))"+
						  " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	
	     		} 
				else 
				{
		    		sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,NVL(b.ORDER_TYPE_ID,b.ORDER_TYPE_ID) ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                  ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						  ",b.REASON_CODE"+ //add by Peggy 20210817
					      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
   					      " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))"+
						  " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	     
         		}
				//�_�Ǫ�code mark by Peggy 20210817
		 		////2005-05-16 add
		 		//if (statusID.equals("018"))			
		   		//{ 
				//	sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,NVL(b.ORDER_TYPE_ID,a.ORDER_TYPE_ID) ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		        //         ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag"+
				//		  ",b.REASON_CODE"+ //add by Peggy 20210817
         		//		  " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
   				//	      " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))"+
				//		  " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	   
				//}
			} 
			else 
			{
				//�_�Ǫ�code mark by Peggy 20210817
				//if (statusID.equals("018")) //2005-05-16 add			
				//{ 
				//	sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,a.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		        //          ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
				//	      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
   				//	      " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))"+
				//		  " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	   
				//}
				//else
				//{ // 2006/01/11 ������U�O����ڦP�ϧY�i�ݨ�		        
					sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.PCACPDATE,'N/A','N/A',substr(b.PCACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,nvl(b.ORDER_TYPE_ID,a.ORDER_TYPE_ID) ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                  ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						  ",b.REASON_CODE"+ //add by Peggy 20210817
					      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in ("+UserRegionSet+") and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' "+
   					      " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))"+
						  " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
				//}
			}		
//			out.println("Sales SQL="+sql);
			rs=statement.executeQuery(sql);	  
		} 
		else 
		{ //out.println("Step15");  // �u�t�P�w�Τu�t����w�ƽT�{
			if (statusID.equals("003") || (statusID.equals("004") && UserRoles.indexOf("MPC_User")>=0 )) //�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
			{
				sql =" select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,nvl(tsc_inv_category(b.inventory_item_id,49,23),tsc_inv_category(b.inventory_item_id,43,23)) TSC_PACKAGE,nvl(tsc_inv_category(b.inventory_item_id,49,1100000003),tsc_inv_category(b.inventory_item_id,43,1100000003)) TSC_Prod_Group,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag"+
				     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"'"+
				     " and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%' or b.item_description like '"+searchString+"%') "+
					 " and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'"+
					 " and tsc_inv_category(b.inventory_item_id,43,23)=nvl('"+TSC_PACKAGE+"',tsc_inv_category(b.inventory_item_id,43,23))";
				if (SORT_COL.equals(""))
				{
					if (userProdCenterNo.equals("006"))
					{
						//sql += " order by  b.ITEM_DESCRIPTION,substr(b.REQUEST_DATE,0,8),a.CREATION_DATE,a.DNDOCNO,b.LINE_NO";	 
						sql += " order by  b.ITEM_DESCRIPTION,a.DNDOCNO,b.LINE_NO";	 //modify by Peggy 20220104
					}
					else
					{
						sql += " order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
					}
				}
				else
				{
					sql += "order by "+ SORT_COL+ " "+ SORT_TYPE;
				}						
//		 		out.println("mpc SQL="+sql);
	     		rs=statement.executeQuery(sql);
				// sample user
	  		} 
			else if (statusID.equals("003") || (statusID.equals("004") && UserRoles.indexOf("Sample_User")>=0 )) //�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
	  		{
	    		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	     		{
		    		lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and PROD_FACTORY like '%"+userProdCenterNo+"%' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
 		    		lotRs.next();
	        		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	        		{
			  			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                     ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";			 
	        		} 
					else 
					{
			  			sql =" select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                     ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	 
            		}			  
         		} 
				else 
				{
	       			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                 ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
					     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y'  order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
	     		}
//		 		out.println("sample SQL="+sql);
	     		rs=statement.executeQuery(sql);
// sample user
// MSPC_User  �s�F�tPC����SAMPLE ORDER
			} 
			else if (statusID.equals("003") || (statusID.equals("004") && UserRoles.indexOf("MSPC_User")>=0 )) //�Y���u�t�h�i�ݨ����ݩ��U���Ҧ��Q�������߰ݳ�
	  		{
	    		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	     		{
		    		lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and PROD_FACTORY like '%"+userProdCenterNo+"%' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' ");	
 		    		lotRs.next();
	        		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	        		{
			  			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                     ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";			 
	        		} 
					else 
					{
			  			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                     ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
						     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	 
            		}			  
         		} 
				else 
				{
	       			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,b.QUANTITY,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                 ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
					     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y') ='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
	     		}
//		 		out.println("MSPC_User="+sql);
	     		rs=statement.executeQuery(sql);
				// MSPC_User
      		} 
			else 
			{  //out.println("Step16");
	    		if (statusID.equals("006") || statusID.equals("028") ) //�Y���A���Ͳ��a����,�h�u���첣�a�γQ���������a���ߥi�ݨ�߰ݳ��
		 		{                                                      // 2004-10-05 028 �T�ŧ��צ^�G�Ŧb�~��
		    		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	         		{
		        		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' ");	
 		        		lotRs.next();
	            		if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	            		{
  		           			if (UserRoles.equals("Planner") && statusID.equals("028"))
 			          		{ 
								sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
							}
                   			else 
//			          		{ sql ="select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,REMARK from RPREPAIR where SVRTYPENO='"+svrTypeNo+"' and STATUSID='"+statusID+"' and (IMEI!='$' OR IMEI IS NULL) and (substr(RECCENTERNO,1,3)='"+userRepCenterNo+"') and REPNO in (select trim(REPNO) from RPREPLOT where LOTNO='"+searchString+"') and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC"; }
			          		{ 
								sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
							}
			    		} 
						else 
						{  // �L�帹				   
  		           			if (UserRoles.equals("Planner") && statusID.equals("028"))
	                  		{ 
								sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
							}
                   			else if (statusID.equals("020"))
 	                  		{ 
								sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
							}
                     		else
 	                  		{ 
								sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
							}
                		}			   
             		} 
					else 
					{			   
                		if (UserRoles.equals("Planner") && statusID.equals("002"))
                    	{ 
							sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                         ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
						}
                    	else if (statusID.equals("020"))
// 	               		{ sql ="select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,REMARK from RPREPAIR where SVRTYPENO='"+svrTypeNo+"' and STATUSID='"+statusID+"' and (IMEI!='$' OR IMEI IS NULL) and (substr(RECCENTERNO,1,3)='"+userRepCenterNo+"') and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC"; }
 	                	{ 
							sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                         ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
						}
                    	else
 	                	{ 
							sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                         ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"; 
						}
	            	}			
                     
                	if (UserRoles.indexOf("Qassurer")>=0)
                	{  
                		if (statusID.equals("036")) // �Y���A���u�t�~�˧P�w��,�h�~�˭��i�ݥ�����ץ�
                    	{  
                    		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	                    	{
	                    		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		                    	lotRs.next();
	                        	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	                        	{
		                    		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                                   ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
									       " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC"); 
		                    	} 
								else 
								{		   
                                	rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                                   ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
									       " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"'  and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");	 	 
                            	}				
                        	} 
							else 
							{	 //out.println("select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,REMARK from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC");  
	                    		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                                   ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								           " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where trim(b.LSTATUSID)='"+statusID+"'  and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
	                    	}	          
                    	}  // end of if (statusID.equals("036"))       
               		}  // end of if (UserRoles.indexOf("Qassurer")>=0)   
              		rs=statement.executeQuery(sql);            
		 		}         
          		else            
          		{ //out.println("Step17"); // �Y���~�ȥ����ͺޤH��(SlaesPlanner),�h�i�w��Ҧ��~�Ȧa�Ϫ���ڧ@���a����(�~�ȥ������o��userActCenterNo=000)
            		if (UserRoles.indexOf("SalesPlanner")>=0 && (statusID.equals("002") || statusID.equals("004") || statusID.equals("007"))) // 2005-05-16 ADD 006
             		{
                		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	                	{
	                		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'  ");	
 		                	lotRs.next();
	                    	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	                    	{
                       			sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                              ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";     
		                   		rs=statement.executeQuery(sql); 
		                	} 
							else 
							{		   
                        		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                              ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and  (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");	 	 
                        	}			
                    	} 
						else 
						{	 //out.println("select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,REMARK from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC");  
	                		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							         " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
	                	}	       
             		}
// sampleplanner begin
             		else if (UserRoles.indexOf("SamplePlanner")>=0 && (statusID.equals("002") || statusID.equals("004") || statusID.equals("007"))) // 2005-05-16 ADD 006
             		{
                		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	                	{
	                		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' ");	
 		                	lotRs.next();
	                    	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	                    	{
                        		sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
            		                  ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";     
		                    	rs=statement.executeQuery(sql); 
		                	} 
							else 
							{		   
                        		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and  (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");	 	 
                        	}			
                    	} 
						else 
						{	 //out.println("select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,REMARK from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(b.LSTATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC");  
	                		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                           ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							       " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO>='"+userActCenterNo+"' and TSAREANO not in ('010','011','012','013') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='N' and nvl(a.SAMPLE_ORDER,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
	                	}	       
             		}
// sampleplanner end
			 		else if (UserRoles.indexOf("CInternal_Planner")>=0 && (statusID.equals("002") || statusID.equals("007"))) // 2005-05-16 ADD 006
             		{
                		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	                	{
	                		lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y' ");	
 		                	lotRs.next();
	                    	if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	                    	{
                        		sql = "select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                              ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								      " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO in ('010','011','012','013') and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";     
		                    	rs=statement.executeQuery(sql); 
		                	} 
							else 
							{		   
                        		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							       	 " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO in ('010','011','012','013') and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");	 	 
                        	}			
                   		} 
						else 
						{	 //out.println("select DISTINCT a.DNDOCNO,b.LINE_NO,b.ITEM_DESCRIPTION,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,CUSTOMER,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,b.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO in ('010','011','012','013') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");  
	                		rs=statement.executeQuery("select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
							         " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' AND TSAREANO in ('010','011','012','013') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and nvl(a.SAMPLE_CHARGE,'Y')='Y' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC");
	                	}	       
            		}
			 		else
             		{ //out.println("Step18=NO HOLD SQL");
 	            		if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
	            		{
		          			lotRs=lotStat.executeQuery("select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		          			lotRs.next();
	              			if (lotRs.getInt(1)>0) //�Y���s�b�帹����
	              			{ //out.println("Step19");
			        			sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and a.DNDOCNO ='"+searchString+"' and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
			      			} 
							else 
							{//out.println("Step20");
	                    		sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                             ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
								     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and (CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";	 
                        	}			   
                		} 
						else 
						{//out.println("Step21");
	                		sql ="select DISTINCT a.DNDOCNO,b.LINE_NO,b.item_segment1 item_name,b.ITEM_DESCRIPTION,APPS.TSCC_GET_FLOW_CODE(b.inventory_item_id) as flow_code,DECODE(b.FTACPDATE,'N/A','N/A',substr(b.FTACPDATE,0,8)) as FTACPDATE,substr(b.REQUEST_DATE,0,8) \"REQUEST DATE\",CUSTOMER,b.REMARK,CUST_PO,TSCUSTOMERID,REQREASON,REQPERSONID,TSAREANO,CURR,AMOUNT,REQUIRE_DATE,PROD_FACTORY,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,TOPERSONID,b.ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,ASSIGN_MANUFACT,LINE_TYPE "+
 		                         ",NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=b.assign_manufact and y.vendor_site_id=b.vendor_site_id),'N') tw_vendor_flag,tsc_inv_category(b.inventory_item_id,43,23) TSC_PACKAGE"+
  							     " from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and substr(REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO,b.LINE_NO,REQUIRE_DATE ASC";
	                	}		               
//                  		out.println("sql="+sql);
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
   
   	String sKeyArray[]=new String[6+(TSC_PACKAGE==null || TSC_PACKAGE.equals("")?0:1)+(!statusID.equals("009")?0:1)];
   	sKeyArray[0]="DNDOCNO";
   	sKeyArray[1]="LINE_NO";
   	//sKeyArray[1]="LINE";
   	sKeyArray[2]="ASSIGN_MANUFACT";
   	sKeyArray[3]="ORDER_TYPE_ID";
   	sKeyArray[4]="LINE_TYPE";
   	sKeyArray[5]="TW_VENDOR_FLAG";
	if (TSC_PACKAGE!=null && !TSC_PACKAGE.equals(""))
	{
		sKeyArray[6]="TSC_PACKAGE";
	}
	//add by Peggy 20210817
	if (statusID.equals("009"))
	{
		sKeyArray[sKeyArray.length-1]="REASON_CODE";
	}	
   
   	String tdMouseOverMsg = "";   
   	String tdTipCh = "";
   
   	
   	qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   	qryAllChkBoxEditBean.setPageURL2("");     
   	qryAllChkBoxEditBean.setHeaderArray(null);
   	//qryAllChkBoxEditBean.setSearchKey("DNDOCNO");
   	qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // �HsetSearchKeyArray���N��, �]�����ݶǻ���Ӻ����Ѽ�
   	qryAllChkBoxEditBean.setFieldName("CH");
   	qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   	qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   	qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   	qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   	//qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   	//qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   	qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   	qryAllChkBoxEditBean.setRs(rs);   
   	qryAllChkBoxEditBean.setScrollRowNumber(300);
//	if (statusID.equals("003") || statusID.equals("004"))
//	{
//		qryAllChkBoxEditBean.setOnSortingJS("setSorting"); //add by Peggy 20190812
//		qryAllChkBoxEditBean.setColSortingFlag(true); //add by Peggy 20190812
//		qryAllChkBoxEditBean.setColSorting(SORT_COL); //add by Peggy 20190812
//		qryAllChkBoxEditBean.setColSortingType(SORT_TYPE); //add by Peggy 20190812
//	}
   
   	if (statusID.equals("009")) // �p���q��ͦ�,�h��� ToolTip��DNDOCNO
   	{
    	tdMouseOverMsg =" Please Choose' ) ";
	 
	 	tdTipCh = "1";
	 	qryAllChkBoxEditBean.setTDMouseMoveAttr(tdMouseOverMsg);
	 	qryAllChkBoxEditBean.setTDTipCh(tdTipCh);
   	}  // �p���q��ͦ�,�h��� ToolTip��DNDOCNO       
   	out.println(qryAllChkBoxEditBean.getRsString());
   
   	statement.close();
   	rs.close();
   	if (lotRs!=null) lotRs.close();
   	lotStat.close();
   //���o���׳B�z���A      
   //out.println("DE1");
} //end of try
catch (Exception e)
{
	out.println("Exception8:"+e.getMessage());
}
 %>
  <%
	  try
      {       
	   //if (statusID.equals("003") || UserRoles.equals("admin") )
	   if (statusID.equals("103"))
	   {
         Statement statement=con.createStatement();         		 		 
		 ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE > '0' order by MANUFACTORY_NO");
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
	      
	   if (statusID.equals("003") || (statusID.equals("004")) || statusID.equals("008"))
	   { 
	     String sqlAct = null;
		 String whereAct = null;
		 //out.println("DE2"+locale);		 
		 if (statusID.equals("003") || statusID.equals("004"))
		 { 
		   sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		   whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";		   
		 } 
		 else if (statusID.equals("008")) {
		                                   sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
										   whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID !='013' and x1.LOCALE='"+locale+"'";         										   
		                                  }
		 //out.println("DE3="+sqlAct +whereAct);
		 // 2006/04/13�[�J�S���P�y�{,�w��W�����P_�_								  
		 if (UserRoles.equals("admin")) whereAct = whereAct+"";  //�Y�O�޲z��,�h����ʧ@��������
		 else {		         
		         if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='SH' "; // �Y�O�W�����P��ƳB
				 else whereAct = whereAct+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{
				 //out.println("DE4="+sqlAct +whereAct);
		      }
		//out.println("DE5");
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
				 else whereCnt = whereCnt+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{(�]�t012,013�j�����PYEW�W�u��@�v�ݥͦ�MO�y�{ )
		      }
	     // 2006/04/13�[�J�S���P�y�{,�w��W�����P_��	
		 sqlCnt = sqlCnt + whereCnt;
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //�P�_�Y�S���ʧ@�i��ܴN���X�{submit���s
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
		   if (statusID.equals("003") || statusID.equals("004") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
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
<input type="hidden" name="STRURL" value="<%=STRURL%>">
<input type="hidden" name="SORT_COL" value="<%=SORT_COL%>">
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
