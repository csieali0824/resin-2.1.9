<!--20170712 Peggy,�W�L�T�ѥ����n�ư�����-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Confirm</title>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DPromiseFactoryBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
			if (field[i].style.visibility != 'hidden')
			{
 				field[i].checked = true;
			}
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

document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") gfPop.fHideCal();
}

function submitCheck(ms1,ms2,ms3,ms4,ms5)
{     
	if (document.DISPLAYREPAIR.ACTIONID.value=="004")  //��ܬ�CANCE�ʧ@
  	{ 
   		flag=confirm(ms1);      
   		if (flag==false)  return(false);
  	}    
  
 	if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null)
  	{ 
   		alert(ms2);   
   		return(false);
  	} 
	else if (document.DISPLAYREPAIR.ACTIONID.value !="011"  && document.DISPLAYREPAIR.ACTIONID.value !="015"  && document.DISPLAYREPAIR.ACTIONID.value !="013")
    { 
		// ��ܨϥΪ̦ۦ����}�C��JLine_No, �G�����\��Submit 
        alert(" Error !!!\n Don't try key-in invalid line No in this page...");  
        return(false);
    }  
  	// �Y����ܥ��@Line �@�ʧ@,�hĵ�i
   	var chkFlag="FALSE";
   	for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
   	{
    	if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	 	{
	   		chkFlag="TURE";
			//add by Peggy 20120511
			var editcode=document.DISPLAYREPAIR.elements["Reject"+i].value;
			var autocode=document.DISPLAYREPAIR.elements["AutoCreate"+i].value;
			if (document.DISPLAYREPAIR.ACTIONID.value =="011" && (editcode=="R" || autocode=="R"))
			{
				alert("Line"+(i+1)+" ���سQ�u�t�P�h,�п�ܥ�������ʧ@!");   
				return false;
			}
	 	} 
   	}  
   	//modify by Peggy 20120301
	if (chkFlag=="FALSE" && ( document.DISPLAYREPAIR.CHKFLAG.length!=null || document.DISPLAYREPAIR.CHKFLAG.length != undefined))
   	{
    	alert(ms4);   
    	return(false);
   	}

	if (document.DISPLAYREPAIR.ACTIONID.value=="013")  //�T�{���ڲ��ͷs����߰ݳ�
  	{
    	flag=confirm(ms5);      
      	if (flag==false)  return(false);
  	} 
  	return(true);  
}

function setSubmit1(URL)
{ 
	var linkURL = "#ACTION";
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();    
}

function setSubmit2(URL,LINKREF)
{ 
	warray=new Array(document.DISPLAYREPAIR.REREQUESTDATE.value); 
  	// �ˬd����O�_�ŦX����榡 
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
         		document.DISPLAYREPAIR.REREQUESTDATE.focus();
         		return(false);
        	}
        	gone=datetime.substring(4,5);
        	month=datetime.substring(4,6);
        	if(isNaN(month)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.REREQUESTDATE.focus();
          		return(false);
        	}
        	gtwo=datetime.substring(7,8);
        	day=datetime.substring(6,8);
        	if(isNaN(day)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.REREQUESTDATE.focus();
          		return(false);
        	}
          
		  	if(month<1||month>12) 
		  	{ 
            	alert("Month must between 01 and 12 !!"); 
            	document.DISPLAYREPAIR.REREQUESTDATE.focus();   
            	return(false); 
          	} 
          
		  	if(day<1||day>31)
		  	{ 
            	alert("Day must between 01 and 31!!");
            	document.DISPLAYREPAIR.REREQUESTDATE.focus(); 
            	return(false); 
          	}
			else
			{
            	if(month==2)
				{  
                	if(isLeapYear(year)&&day>29)
					{ 
                    	alert("February between 01 and 29 !!"); 
                      	document.DISPLAYREPAIR.REREQUESTDATE.focus();
                      	return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                    	alert("February between 01 and 29 !!");
                     	document.DISPLAYREPAIR.REREQUESTDATE.focus(); 
                     	return(false); 
                    } 
                } // End of if(month==2)
                
				if((month==4||month==6||month==9||month==11)&&(day>30))
				{ 
                	alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   	document.DISPLAYREPAIR.REREQUESTDATE.focus(); 
                   	return(false); 
                } 
           	} // End of else 
    	}
		else
		{ 
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.DISPLAYREPAIR.REREQUESTDATE.focus();
          	return(false);
        }
  	}
  	// �ˬd����O�_�ŦX����榡
  	document.DISPLAYREPAIR.ACTIONID.value="--"; // �קK�ϥΪ̥���ʧ@�A�]�w�U����
  	var reRequestDate="&REREQUESTDATE="+document.DISPLAYREPAIR.REREQUESTDATE.value; 
  	var linkURL = "#"+LINKREF;
  	document.DISPLAYREPAIR.action=URL+reRequestDate+linkURL;
  	document.DISPLAYREPAIR.submit();    
}

// �ˬd�|�~,�P�_�����J�X�k��
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
 	{ 
 		return true; 
 	}  
 	return false; 
} 

function setSubmit3(URL,NEWREQUEST)
{ 
	var linkURL = "#ACTION";
  	var newRequest="&NEWREQUEST="+document.DISPLAYREPAIR.NEWREQUEST.value; 
  	document.DISPLAYREPAIR.action=URL+newRequest+linkURL;
  	document.DISPLAYREPAIR.submit();    
}

</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<%
String dnDocNo=request.getParameter("DNDOCNO");
String prodManufactory=request.getParameter("PRODMANUFACTORY");   
String lineNo=request.getParameter("LINENO");
String actionID = request.getParameter("ACTIONID");   
String remark = request.getParameter("REMARK");   
String line_No = request.getParameter("LINE_NO");
String reRequestDate=request.getParameter("REREQUESTDATE");
String newRequest=request.getParameter("NEWREQUEST");
String [] check=request.getParameterValues("CHKFLAG");
String rfqExceedFlag = "N";  // �w�]���W�L�u�t�^��3��;
String autoCreateFlag = "N";  //�w�]�H�u�ͦ��q��
if (reRequestDate==null) { reRequestDate="";}
if (remark==null) { remark=""; }
if (actionID==null) { actionID="--"; }
if (newRequest==null) { newRequest = "N"; }
if (lineNo==null) { lineNo="";}  
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>","<jsp:getProperty name="rPH" property="pgConfirm"/><jsp:getProperty name="rPH" property="pgAbortToTempDRQ"/>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
<!--=============�H�U�Ϭq�����o���װ򥻸��==========-->
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<%
String dateCurrent = dateBean.getYearMonthDay();
boolean rejectFlag = false;
try
{          
	String sqlReject = " select a.DNDOCNO, a.LINE_NO from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
	                   " where a.DNDOCNO = b.DNDOCNO AND a.LINE_NO = b.LINE_NO AND a.DNDOCNO = '"+dnDocNo+"' "+
	                   " AND b.LSTATUSID = '008' and a.ORISTATUSID IN ('003','004') and a.ACTIONID='005' "+ // �Y���e�@�Ӫ��A�ʧ@��REJECT,�h�������ʧ@�L�k��wAPPLY�@�Ȥ�T�{,20110111 �[�J'004'   
					   " union all"+
					   " select a.DNDOCNO, a.LINE_NO from  ORADDMAN.TSDELIVERY_NOTICE_DETAIL a where a.DNDOCNO = '"+dnDocNo+"' and nvl(a.EDIT_CODE,'')='R' AND a.LSTATUSID = '008'"; //add by Peggy 20120418
    Statement stateRej=con.createStatement();
    ResultSet rsRej=stateRej.executeQuery(sqlReject);
	while (rsRej.next())
	{
		rejectFlag = true;			
	}
	rsRej.close();
	stateRej.close();
}//end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}	

if (frStatID.equals("008")) //  �Y���A�O (008)�Ȥ���(�~��)�w�T�{_CONFIRMED,�~��ܩ��ӨѨϥΪ̳]�w�����Ѽ�,�_�h,�ϥΪ̵L�k�@����Submit...(����User�ۦ����}�C��JLineNO)
{
%>
<HR>
<TABLE cellSpacing="1" cellPadding="5" width="97%" align="center" border="0">
   <TBODY>
       <TR>
         <TD bgColor=#ffffff>
			<table border="1" cellpadding="1" cellspacing="0" align="center" width="100%" bordercolor="#999966"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
  				<tr bgcolor='#D5D8A7'> 
    				<td colspan="3"><font color="#000066">
         <jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/>	 
         : 
		 <font color="#666666"><jsp:getProperty name="rPH" property="pgQDocNo"/>:</font><font color="#006699"><%=dnDocNo%></font>&nbsp;&nbsp;&nbsp;
		 <font color="#000099"><jsp:getProperty name="rPH" property="pgYellowItem"/><jsp:getProperty name="rPH" property="pgDenote"/><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgReject"/></font>
		 <BR>
         	<%
			try
         	{   
	       		String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // ���N���e���Ӫ����Y,���@���}�C		 	     			  
    	   		array2DPromiseFactoryBean.setArrayString(oneDArray);
		   
	       		// ���� �Ӹ߰ݳ浧��_�_
	       		int rowLength = 0;
	       		Statement stateCNT=con.createStatement();
           		ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' ");	
	       		if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	       		rsCNT.close();
	       		stateCNT.close();
	       		String b[][]=new String[rowLength+1][8]; // �ŧi�@�G���}�C,���O�O(�����t���a=�C)X(������+1= ��)
	  
	       		out.println("<TABLE border='1' cellpadding='0' cellspacing='1' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	       		out.println("<tr bgcolor='#D5D8A7'>");
		   		out.println("<td nowrap>");
	      	%>
	        	<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	       	<%
	       		out.println("</td>");
	       		out.println("<td><font color='#000000'>&nbsp;</td>");
	       		out.println("<td nowrap><font color='#000000'><div align='center'>");
		   	%>
		   	<jsp:getProperty name="rPH" property="pgNewRequestDate"/>
		   	<%
		   		out.println("</div>");
	       		try
           		{ 
		    		out.println("<input name='REREQUESTDATE' type='text' size='8' ");
		     		if (lineNo!=null) out.println("value="+reRequestDate); else out.println("value="+reRequestDate); 
		     		out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.REREQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	       		} //end of try		 
           		catch (Exception e) 
				{ 
					out.println("Exception2:"+e.getMessage()); 
				} 
	   			out.println("</font></td>");
	   			out.println("<td width='1%' nowrap><font color='#000000'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgAnItem"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
	   		<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgQty"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
	   		<jsp:getProperty name="rPH" property="pgUOM"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgRequestDate"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgRemark"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>"); 
	   		%>
			<jsp:getProperty name="rPH" property="pgDesc"/>
	   		<%
	   			out.println("</font></td><td nowrap><font color='#000000'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgSalesPlanner"/><jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   		<%
	   			out.println("</font></td>");
	   			out.println("<td nowrap><font color='#FF9966'><div align='center'>");
	   		%>
			<jsp:getProperty name="rPH" property="pgReAssign"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgReject"/><jsp:getProperty name="rPH" property="pgCodeDesc"/>
			<%
	   			out.println("</font></td>"); 
	   			out.println("</TR>");    
	       		int k=0;
	   
	       		String sqlEst = "";
	       		if (UserRoles.indexOf("admin")>=0) // �Y�O�޲z��,�i�������@�t�ϥ��
	       		{ 
					//sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,REREQUEST_DATE,REASON_CODE,EDIT_CODE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
					//modify by Peggy 20120301,add autocreate_flag field
					sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,REREQUEST_DATE,REASON_CODE,EDIT_CODE,nvl(AUTOCREATE_FLAG,'N') AUTOCREATE_FLAG from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
				}
	       		else 
				{   
					//sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,REREQUEST_DATE,REASON_CODE,EDIT_CODEfrom ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
					//modify by Peggy 20120301,add autocreate_flag field
					sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,REREQUEST_DATE,REASON_CODE,EDIT_CODE,nvl(AUTOCREATE_FLAG,'N') AUTOCREATE_FLAG from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
				}
           		Statement statement=con.createStatement();
           		ResultSet rs=statement.executeQuery(sqlEst);	   
	       		while (rs.next())
	       		{
			  		// �������^�Х���η~�ȽT�{�����Ӿ��{�ɤ�,�P�_���Ȥ�T�{�O�_�W�L�u�t�^�Х��4��H�W,�h��s�L�ĳ��FLAG='Y'
		            String respondingDate= "0";
		            String salesCinfirmDate = "0";
		            String limitSalesDate="0";
		            String sPlannerRemark = "";
                    String respDay="";   //20101005 PC�^�Ф�O�P���X
                    int setDay=3;  //20101005 �s�W���ܼ� �зǬO3�Ѥ��n�^��
		            Statement stateEstDate=con.createStatement();
	                //ResultSet rsEstDate=stateEstDate.executeQuery("select UPDATEDATE,ORISTATUSID,REMARK ,decode(trim(to_char(to_date(UPDATEDATE,'yyyy/mm/dd'),'day','NLS_DATE_LANGUAGE = American')),'thursday','B','friday','B','saturday','B','sunday','A','C') resp_day from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
                    //                                              "  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+rs.getString("LINE_NO")+"' "+
                    //                     				            "and ORISTATUSID in ('004','008') and ORISTATUS in ('ARRANGED','CONFIRMED') ");	
					//modify by Peggy 20111005
					String sqls = " SELECT a.updatedate, a.oristatusid, a.remark,"+
                                   //" nvl( (SELECT limit_days FROM oraddman.tssales_comfirm_days "+
								   //" WHERE TO_DATE (a.updatedate, 'yyyy-mm-dd') BETWEEN start_date AND end_date) ,"+
                                   //" DECODE (TRIM (TO_CHAR (TO_DATE (a.updatedate, 'yyyy/mm/dd'),'day','NLS_DATE_LANGUAGE = American')),"+
                                   //" 'thursday', '2', 'friday', '2', 'saturday', '2','sunday', '1','0')) resp_day"+
								   " to_char(to_date(a.updatedate,'yyyymmdd')+"+setDay+"+tsc_get_holiday_days( TO_DATE(a.updatedate,'YYYYMMDD'), sysdate,null),'yyyymmdd') limitSalesDate"+ //add by Peggy 20170712
                                   " FROM oraddman.tsdelivery_detail_history a"+
                                   " WHERE a.dndocno = '"+dnDocNo+"'"+
                                   " AND TO_CHAR (a.line_no) = '"+rs.getString("LINE_NO")+"' "+
                                   " AND a.oristatusid IN ('004', '008','014')"+
                                   " AND a.oristatus IN ('ARRANGED', 'CONFIRMED','PENDING')"+
								   " order by  decode(a.oristatusid,'004',1,'008',2,3)";
	                ResultSet rsEstDate=stateEstDate.executeQuery(sqls);	
		            while (rsEstDate.next())
		            {  
		             	//if (rsEstDate.getString("ORISTATUSID").equals("004")) 
						if (rsEstDate.getString("ORISTATUSID").equals("004") || rsEstDate.getString("ORISTATUSID").equals("014"))   //add 014 status by Peggy 20160908
					   	{ 
					    	respondingDate=rsEstDate.getString("UPDATEDATE"); 
                         	//respDay=rsEstDate.getString("RESP_DAY");  //20101005
							if (limitSalesDate.equals("0"))
							{
								limitSalesDate=rsEstDate.getString("limitSalesDate");  //add by Peggy 20170712
							}
					     	if (sPlannerRemark.equals("") && rsEstDate.getString("REMARK")!=null && !rsEstDate.getString("REMARK").equals(""))
						 	{   
					     		sPlannerRemark = rsEstDate.getString("REMARK");
						 	}
					   	}
			           	salesCinfirmDate = dateBean.getYearMonthDay(); // ����鬰�~�ȽT�{���
					   	if (rsEstDate.getString("ORISTATUSID").equals("008") || rsEstDate.getString("ORISTATUSID").equals("014"))  // �������H��������(REMARK)
					   	{
					    	if (sPlannerRemark.equals("") && rsEstDate.getString("REMARK") !=null && !rsEstDate.getString("REMARK").equals(""))
						 	{   
					        	sPlannerRemark = rsEstDate.getString("REMARK");
							}
					   	}	 
		            }
		            stateEstDate.close();
		            rsEstDate.close();
					
					//add by Peggy 20111229
					if (sPlannerRemark == null || sPlannerRemark.equals("") || sPlannerRemark.equals("&nbsp;"))
					{
						sqlEst = " select pc_remark from oraddman.tsdelivery_detail_history b "+
							 " where pc_remark IS NOT NULL  AND oristatusid = '003' AND actionid = '008'  "+
							 " and b.DNDOCNO='"+dnDocNo+"'"+
							 " AND TO_CHAR (b.line_no) = '"+rs.getString("LINE_NO")+"' ";
						Statement state1=con.createStatement();
						ResultSet rs1=state1.executeQuery(sqlEst);
						if (rs1.next())
						{
							sPlannerRemark = rs1.getString("pc_remark");
						}
						else
						{
							sPlannerRemark = "&nbsp;"; 
						}
						rs1.close();	
						state1.close();
					}
									
		            ////Step1. �]�w�u�t�P�w�鬰�ثe���, �B�~�ȥ�T�{�Ȥ���
		            //if (respondingDate!="0" && !respondingDate.equals("0") && salesCinfirmDate != "0" && !salesCinfirmDate.equals("0"))
		            //{
					//	//if (respDay=="B" || respDay.equals("B")) setDay=setDay+2;  //20101005 B��ܶg�|�����^�� ,�h�G��,�@5��
					//	//if (respDay=="A" || respDay.equals("A")) setDay=setDay+1;  //20101005 A��ܶg��^�� ,�h1��,�@4��
					//	setDay += Integer.parseInt(respDay);  //20111005 modify by Peggy �����[�Wselect sql�^�ǤѼ� 
					//	
		             //   dateBean.setVarDate(Integer.parseInt(respondingDate.substring(0,4)),Integer.parseInt(respondingDate.substring(4,6)),Integer.parseInt(respondingDate.substring(6,8)));
			        // 	//  dateBean.setAdjDate(3);   //20090522 liling �ѭ�4���3��,cytsou�q��
			        //    dateBean.setAdjDate(setDay);   //20101005 liling ����ܼƱ���
			        //    limitSalesDate=dateBean.getYearMonthDay(); // ���^�~�ȭ���}���(�u�t�T�{��3��)
					//   	//out.print("<br>limitSalesDate="+limitSalesDate);
					//  	//out.print("<br>setDay="+setDay);
			        //	//dateBean.setAdjDate(-3);//����վ�^��   //20090522 liling �ѭ�4���3��,cytsou�q��
			         //  dateBean.setAdjDate(-setDay);//����վ�^��   //20101005 liling ����ܼƱ���
			          // dateBean.setVarDate(Integer.parseInt(dateCurrent.substring(0,4)),Integer.parseInt(dateCurrent.substring(4,6)),Integer.parseInt(dateCurrent.substring(6,8))); //����վ�^�� 
			        //   //if (Integer.parseInt(salesCinfirmDate)>Integer.parseInt(limitSalesDate)) { exceedGenMODateMSG = ""; } // ����u�t�P�w�����Y�j��~�ȽT�{��3�ѥH�W,�h��REMARK ����ܰT��
			        //   //out.println("limitSalesDate="+limitSalesDate);
			        //   //out.println("respondingDate="+respondingDate);
		            //}
					//out.println("salesCinfirmDate="+salesCinfirmDate+" limitSalesDate="+limitSalesDate);
					if (Integer.parseInt(salesCinfirmDate)>Integer.parseInt(limitSalesDate)) // �P�_�Y�W�L,�h��sExceed_Valid Flag --> Y
					{
						rfqExceedFlag = "Y";	
						//20090522 liling �s�W�Y�W�L�^�Ф�,��stable��flag���O
	                    String sqlExceed="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set SDRQ_EXCEED='Y' where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+rs.getString("LINE_NO")+"' ";		                                 
	                    PreparedStatement stmtExceed=con.prepareStatement(sqlExceed);
						stmtExceed.executeUpdate();  	
					} // End of if
					else
					{
						rfqExceedFlag ="N";
					}
					
					//out.print("<br>salesCinfirmDate="+salesCinfirmDate+"  respondingDate="+respondingDate+"  limitSalesDate="+limitSalesDate+" rfqExceedFlag="+rfqExceedFlag);		
		    		// ���u�t�^�Х���η~�ȽT�{�����Ӿ��{�ɤ�	   
		    		// �Y����h,�h���X��]
	              	String reasonDesc = "(N/A)";
	              	Statement stateReason=con.createStatement();
	              	ResultSet rsReason=stateReason.executeQuery("select * from ORADDMAN.TSREASON where TSREASONNO='"+rs.getString("REASON_CODE")+"' ");	
		          	if (rsReason.next())	
		          	{
		           		reasonDesc = "("+rsReason.getString("REASONCODE")+")"+rsReason.getString("REASONDESC");
		          	} 
		          	rsReason.close();
		          	stateReason.close();
	        		// �Y����h,�h���X��]
			
		   			// �P�_�Y����h��,�h�I���ܦ�_�_
		     		if (rs.getString("EDIT_CODE").equals("R"))
	         		{ 
						out.print("<TR bgcolor='#FFFF00'>"); 
			 		}
			 		else 
					{   
						out.print("<TR bgcolor='#D5D8A7'>"); 
					}
		   			// �P�_�Y����h��,�h�I���ܦ�_��
		   			out.println("<TD width='1%'><div align='center'>");

					out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
					if (!rs.getString("AUTOCREATE_FLAG").equals("Y"))
					{
						if (check !=null) // �Y���e�H�]�w�����,�hCheck Box ��� checked
						{
							for (int j=0;j<check.length;j++) 
							{ 
								if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  
							}
							if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // ���w���s����Y�]�w������
						} 
						else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //�Ĥ@�����w���s����Y�]�w������  
						if (rowLength==1) out.println("checked >"); else out.println(" >");
					}
					else 
					{
						out.println(" style='visibility: hidden;'>"); //add by Peggy 20120301
					}
		    		out.println("</div>");
					out.println("</TD>");			                      								  
		    		out.println("<TD width='1%' nowrap><font color='BLACK'>");
		    		out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQConfirmedPage.jsp?NEWREQUEST="+newRequest+"&LINENO="+rs.getString("LINE_NO")+"&DNDOCNO="+dnDocNo+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");	
		    		out.println("</TD>");
      	    		out.println("<TD width='5%' nowrap>&nbsp;");
	 				if (rs.getString("EDIT_CODE").equals("R"))
	 				{
	  	 				out.println("<font COLOR='#000099'>");
			%>
				<jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgReject"/>
			<%
						out.println("</FONT>");
	 				} 
					else 
					{	
		     			if (rs.getString("REREQUEST_DATE")==null || rs.getString("REREQUEST_DATE").equals("") || rs.getString("REREQUEST_DATE")=="N/A" || rs.getString("REREQUEST_DATE").equals("N/A"))
		     			{ 		  
		       				if (lineNo==null || lineNo.equals(""))
		       				{ 
								out.println("<font COLOR='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</FONT>"); 
							}
		       				else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO")))
		       				{  
								out.println("<font COLOR='#000099'>"+reRequestDate+"</font>"); 
							}
		     			}
		     			else  
						{ 
		             		out.println("<font color='#FF0000'>"); 
				     		if (lineNo==null || lineNo.equals(""))
				     		{ 
					  			out.println(rs.getString("REREQUEST_DATE").substring(0,8)+"</font>");						 
					 		}
				     		else 
							{
					       		out.println(reRequestDate+"</font>");
						  	} 
		            	}		
		     		} 
		     		out.println("</TD>");
					out.println("<TD nowrap><font color='#000099'><a name="+rs.getString("LINE_NO")+">"+rs.getString("LINE_NO")+"</a></font>");
					out.println("</TD>");
					out.println("<TD nowrap><font color='#000099'>"+rs.getString("ITEM_DESCRIPTION")+"</font>");
					out.println("</TD>");
					out.println("<TD nowrap><font color='#000099'>"+rs.getString("QUANTITY")+"</font></TD><TD nowrap><font color='#000099'>"+rs.getString("UOM")+"</font></TD><TD nowrap><font color='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD nowrap><font color='#000099'>"+rs.getString("REMARK")+"</font>");
					out.println("</TD>");
			
			 		if (rfqExceedFlag.equals("Y"))
			 		{				 
			  			out.println("<TD nowrap><font color='#FF0000'>");
			%>
			<jsp:getProperty name="rPH" property="pgExceedValidDate"/>
			<%    // �Y�W�X���u�t�T�{3��H�W,�h��ܰT������
			  			out.println("</font>");
						out.println("</TD>");			 
			 		} 
					else 
					{
			        	out.println("<TD nowrap>");
						out.println("<font color='#000099'>&nbsp;</font>");
						out.println("</TD>");
			        }		
			 		out.println("<TD width='5%' nowrap><font color='FF3333'>"+sPlannerRemark+"</font>");
					out.println("</TD>"); 	// 2006/01/23 ��ܥ��������B�zRemark����		          
			 		out.println("<TD><font color='#FF0000'>");
		     		if (rs.getString("REASON_CODE")==null || rs.getString("REASON_CODE").equals("00") || rs.getString("REASON_CODE").equals(""))
		     		{  
						// ���`��,�L�Ŧ�
		       			out.println("<font color='#000099'>"+rs.getString("REASON_CODE")+reasonDesc+"</font>");
		     		} // ��h��,�L����
		     		else 
					{ 
						out.println("<font color='#FF0000'>"+rs.getString("REASON_CODE")+reasonDesc+"</font>"); 
					}
		     		out.println("</font>");
					out.println("<input type='hidden' name='Reject"+k+"' value='"+rs.getString("EDIT_CODE")+"'>");      //add by Peggy 20120511
					out.println("<input type='hidden' name='AutoCreate"+k+"' value='"+ rs.getString("AUTOCREATE_FLAG")+"'>");//add by Peggy 20120511
					out.println("</TD>");
			 		out.println("</TR>");
			  		String prodMFG = "";
			  		Statement stateMFGArea=con.createStatement();
	          		ResultSet rsMFGArea=stateMFGArea.executeQuery("select ALNAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO = '"+rs.getString("ASSIGN_MANUFACT")+"' ");
		      		if (rsMFGArea.next())  prodMFG = rsMFGArea.getString(1);
			  		rsMFGArea.close();
			  		rsMFGArea.close();
		     		b[k][0]=rs.getString("LINE_NO");
					b[k][1]=rs.getString("ITEM_SEGMENT1");
					b[k][2]=rs.getString("QUANTITY");
					b[k][3]=rs.getString("UOM");
					b[k][4]=rs.getString("REQUEST_DATE");
					b[k][5]=rs.getString("REMARK");
					b[k][6]=rs.getString("REREQUEST_DATE");	
			 		b[k][7]=prodMFG;  // ��������Ͳ��a�� �}�C		 
		     		array2DPromiseFactoryBean.setArray2DString(b);
		     		k++;
	       		}  // End of while   	   	 
	       		out.println("</TABLE>");
	       		statement.close();
           		rs.close();          
	
	        	if (lineNo !=null && reRequestDate!=null)
	        	{
			    	if (reRequestDate==null || reRequestDate.equals("")) // �Y����s�ݨD���J������I�� Set,�h�N��ݨD�鵹�s�ݨD��
			       	{   
			        	for (int t=0;t<b.length-1;t++)
				       	{
				       		if (b[t][0]==lineNo || b[t][0].equals(lineNo))
				         	{ 
				          		reRequestDate=b[t][4].substring(0,8);
				         	} 
				       	}
			        }
			 
	          		String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set REREQUEST_DATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	          		PreparedStatement pstmt=con.prepareStatement(sql);  
              		pstmt.setString(1,reRequestDate+dateBean.getHourMinuteSecond());  // �u�t����w��
		      		pstmt.executeUpdate(); 
              		pstmt.close();
            	}  
           	} //end of try
           	catch (Exception e)
           	{
            	out.println("Exception3:"+e.getMessage());
           	}
	   
	        String a[][]=array2DPromiseFactoryBean.getArray2DContent();//���o�ثe�}�C���e 		    		                       		    		  	   
            if (a!=null) 
		    {		  
		    }	
   			%>
		 	</font>      
  		</tr> 
  		<%
  		%>    
  		<tr bgcolor='#D5D8A7'> 
      		<td colspan="3"><font color='#000000'><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        		<INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
				<INPUT type="hidden" name="WORKTIME" value="0">
        		<INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
     		</td>
    	</tr>
    	<tr bgcolor='#D5D8A7'>
    	<td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><font color='#000000'><%=userID+"("+UserName+")"%></font></td>
    	<td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessDate"/>:<%=dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString()%>
    	</font>
		</td>
      	<td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessTime"/>: 
	   	<%=dateBean.getHourMinuteSecond()%></font>
      	</td>
    </tr>       
</table>
</TD>
   </TR>
 </TBODY>
</TABLE>
<%
}  // End of if (frStatID.equals("008"))
%>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong>
   <a name='#ACTION'> 
	<%
	try
    {  
		String sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";	   
	   	String whereAct = "WHERE FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' ";
		if (UserRoles.equals("admin")) whereAct = whereAct+"";  //�Y�O�޲z��,�h����ʧ@��������
		else 
		{
			if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='SH' "; // �Y�O�W�����P��ƳB
			else whereAct = whereAct+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{
		}
	   	if (rejectFlag==true)
	   	{
	    	whereAct = whereAct+"and x2.ACTIONID !='011' "; // �����APPLY
	%>
	    <script language="javascript">
	    	alert("<jsp:getProperty name='rPH' property='pgAlertCfmRjtMsg'/>");
		</script>
	<%
		}   
	   	if (rfqExceedFlag=="Y" || rfqExceedFlag.equals("Y"))
	   	{
	    	whereAct = whereAct+"and x2.ACTIONID !='011' "; // �����APPLY
	%>
		<script language="javascript">
			alert("Exceed the factory reply for 3 days!");
	   	</script>
	<%
	   	}   
	   	sqlAct = sqlAct + whereAct;	    
       	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery(sqlAct);
	   	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQConfirmedPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+"&NEWREQUEST="+newRequest+'"'+")'>");				  				  
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
	   	}
	   	out.println("</select>"); 
	   	String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
	   	String whereCnt = "WHERE FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";
		if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //�Y�O�޲z��,�h����ʧ@��������
		else 
		{
			if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereCnt = whereCnt+"and FORMID='SH' "; // �Y�O�W�����P��ƳB
			else whereCnt = whereCnt+"and FORMID='TS' "; // �_�h�@�߬Ҭ��~�P�y�{
		}
	   	if (rejectFlag==true)
	   	{
	    	whereCnt = whereCnt+"and x2.ACTIONID !='011' "; // �����APPLY
	   	}   
	   	sqlCnt = sqlCnt + whereCnt; 	
	   	rs=statement.executeQuery(sqlCnt);
	   	rs.next();
	   	if (rs.getInt(1)>0) //�P�_�Y�S���ʧ@�i��ܴN���X�{submit���s
	   	{
        	out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 	out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");
		%>
		<jsp:getProperty name="rPH" property="pgMailNotice"/>
		<%
		 	if (actionID.equals("013"))
		 	{
		  		out.println("&nbsp;<INPUT TYPE='checkBox' NAME='NEWDRQOPTION' VALUE='YES'>");
		%>
		<font color="#FF0000"><strong><jsp:getProperty name="rPH" property="pgAbortToTempDRQ"/></strong></font>
		<%
			} 
	   	} 
       	rs.close();       
	   	statement.close();
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception4:"+e.getMessage());
    }
    %>
		</a>
		</td>
	</tr>
</table>
<!-- ���Ѽ� --> 
<INPUT TYPE="hidden" NAME="LINE_NO" SIZE=60  value="<%=line_No%>">
<INPUT TYPE="hidden" NAME="NEWREQUEST" SIZE=60  value="<%if (newRequest=="N" || newRequest.equals("N")) out.print("Y"); else out.print("N"); %>">
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============�H�U�Ϭq������s����==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>