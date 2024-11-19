<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Assign</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DArrangedFactoryBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
function submitCheck(ms1,ms2,ms3,ms4)
{     
  if (document.DISPLAYREPAIR.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  } 
  
 if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null)
  { 
   alert(ms2);   
   return(false);
  } else if (document.DISPLAYREPAIR.ACTIONID.value !="010" && document.DISPLAYREPAIR.ACTIONID.value !="014" && document.DISPLAYREPAIR.ACTIONID.value !="005")
           { // 表示使用者自行於網址列輸入Line_No, 故不允許其Submit
              alert("              Error process action!!\n Don't try key-in invalid line No in this page...");  
              return(false);
           }  
 //     
  // 若未選擇任一Line 作動作,則警告
   var chkFlag="FALSE";
   for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
   {
     if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	 {
	   chkFlag="TURE";
	 } 
   }  
   if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
   {
    alert(ms4);   
    return(false);
   }
  //   
       
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  var linkURL = "#ACTION";
  
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();       
}
function setSubmit2(URL,LINKREF,DATECURR)
{ 
  warray=new Array(document.DISPLAYREPAIR.PCACPDATE.value); 
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
         document.DISPLAYREPAIR.PCACPDATE.focus();
         return(false);
        }
        gone=datetime.substring(4,5);
        month=datetime.substring(4,6);
        if(isNaN(month)==true)
		{
          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          document.DISPLAYREPAIR.PCACPDATE.focus();
          return(false);
        }
        gtwo=datetime.substring(7,8);
        day=datetime.substring(6,8);
        if(isNaN(day)==true)
		{
          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          document.DISPLAYREPAIR.PCACPDATE.focus();
          return(false);
        }
     //   if((gone=="-")&&(gtwo=="-"))
	 //	{
	 //alert(day);
          if(month<1||month>12) 
		  { 
            alert("Month must between 01 and 12 !!"); 
            document.DISPLAYREPAIR.PCACPDATE.focus();   
            return(false); 
          } 
          if(day<1||day>31)
		  { 
            alert("Day must between 01 and 31!!");
            document.DISPLAYREPAIR.PCACPDATE.focus(); 
            return(false); 
          }else{
                 if(month==2)
				 {  
                    if(isLeapYear(year)&&day>29)
					{ 
                      alert("February between 01 and 29 !!"); 
                      document.DISPLAYREPAIR.PCACPDATE.focus();
                      return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                     alert("February between 01 and 29 !!");
                     document.DISPLAYREPAIR.PCACPDATE.focus(); 
                     return(false); 
                    } 
                 } // End of if(month==2)
                 if((month==4||month==6||month==9||month==11)&&(day>30))
				 { 
                   alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   document.DISPLAYREPAIR.PCACPDATE.focus(); 
                   return(false); 
                 } 
           } // End of else 
    // }else // End of if((gone=="-")&&(gtwo=="-"))
    //    {
    //      alert("??入日期!格式?(yyyy-mm-dd) \n例(2001-01-01)");
    //      checktext.focus();
    //      return false;
    //    }
    }else{ // End Else of if(datetime.length==10)
          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          document.DISPLAYREPAIR.PCACPDATE.focus();
          return(false);
         }
  }else{ // End of if(Trim(checktext.value)!="")
         //return true;
       }
    
  // 檢查日期是否符合日期格式
  
  if (document.DISPLAYREPAIR.PCACPDATE.value =="")
  {
    alert("Please Input Confirm Date before you set this item !!");
	return (false);
  }
  
  if (document.DISPLAYREPAIR.PCACPDATE.value < DATECURR)
  {
     alert("<jsp:getProperty name='rPH' property='pgAlertDateSet'/>");
     //alert("Not Allow to input Delivery Date less than current date !");
     document.DISPLAYREPAIR.PCACPDATE.focus();
	 return (false);
  }
  
  document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目

  var pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  var linkURL = "#"+LINKREF;
  document.DISPLAYREPAIR.action=URL+pcAcceptDate+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit3(URL)
{
  //alert(document.DISPLAYREPAIR.ACTIONID.value);
  if (document.DISPLAYREPAIR.ACTIONID.value =="005" ) // 若選擇Reject,則請務必給定原因於備註欄
  { // 表示使用者自行於網址列輸入Line_No, 故不允許其Submit
    if (document.DISPLAYREPAIR.REMARK.value=="")
    { 
	 alert("<jsp:getProperty name='rPH' property='pgAlertRejectMsg'/>");  
     return(false);
	} 
  }  
  document.DISPLAYREPAIR.action=URL;
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
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<%
   String dnDocNo=request.getParameter("DNDOCNO");
   String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   String pcAcceptDate=request.getParameter("PCACPDATE"); 
   String actionID = request.getParameter("ACTIONID");   
   String remark = request.getParameter("REMARK");   
   String line_No=request.getParameter("LINE_NO");
   //response.sendRedirect("../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo); 
   
   String [] check=request.getParameterValues("CHKFLAG");
   
   if (lineNo==null) { lineNo="";}
   if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   
   
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
  <!--=============以下區段為取得維修基本資料==========-->
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<%
  if (frStatID.equals("007")) //  若狀態是 (007)客戶交期(生管)同意中_RESPONDING,才顯示明細供使用者設定相關參數,否則,使用者無法作任何Submit...(防止User自行於網址列輸入LineNO)
  {
%>
<HR>
<table border="1" cellpadding="0" cellspacing="0" align="center" width="97%" bordercolor="#996633"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
    <tr bgcolor='#D5D8A7'> 
    <td colspan="3"><font color="#000066">
      <jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></font>
      :&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600" size="2"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/><BR>
      <%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	array2DArrangedFactoryBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	     int rowLength = 0;
		 String sqlCNT = null;
	     Statement stateCNT=con.createStatement();
		 if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	     { sqlCNT ="select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"'  "; }
		 else { sqlCNT ="select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and substr(DNDOCNO,3,3) >= '"+userPlanCenterNo+"' and LSTATUSID = '"+frStatID+"'  "; }
         ResultSet rsCNT=stateCNT.executeQuery(sqlCNT);	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE border='1' cellpadding='0' cellspacing='0' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	   out.println("<tr bgcolor='#D5D8A7'>");
	   out.println("<td nowrap>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	   <%
	   out.println("</td>");
	   out.println("<td><font color='#000000'>&nbsp;</font></td>");
	   out.println("<td><font color='#000000'><img src='../image/point.gif'>PC Confirm Date<BR>");
	   try
        { 
		  out.println("<input name='PCACPDATE' type='text' size='8' ");
		  if (lineNo!=null) out.println("value="+pcAcceptDate); else out.println("value="+pcAcceptDate); 
		  out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.PCACPDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	   } //end of try		 
       catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	  
	   out.println("</font></td>");
	   out.println("<td width='1%' nowrap><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgAnItem"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %>
	   <jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgQty"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %>
	   <jsp:getProperty name="rPH" property="pgUOM"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgRequestDate"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgRemark"/>
	   <%
	   out.println("</font></td>"); 
	   out.println("<td nowrap><font color='#FF0000'><div align='center'>");
	   %><jsp:getProperty name="rPH" property="pgReAssign"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgReject"/><jsp:getProperty name="rPH" property="pgCodeDesc"/><%
	   out.println("</font></td>"); 
	   //out.println("<td width='5%'><font size='2'>Line</font></td><td><font size='2'>Ordered Item</font></td><td><font size='2'>Item Description</font></td><td><font size='2'>Qty</font></td><td><font size='2'>UOM</font></td><td><font size='2'>Request Date</font></td><td><font size='2'>Remark</font></td></TR>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	   { sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE,REASON_CODE,REASONDESC from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE,REASON_CODE,REASONDESC from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and substr(DNDOCNO,3,3) >= '"+userPlanCenterNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0");
	       
	      // 若有批退,則取出原因
	       String reasonDesc = "(N/A)";
	       Statement stateReason=con.createStatement();
	       ResultSet rsReason=stateReason.executeQuery("select * from ORADDMAN.TSREASON where TSREASONNO='"+rs.getString("REASON_CODE")+"' ");	
		   if (rsReason.next())	
		   {
		     reasonDesc = "("+rsReason.getString("REASONCODE")+")"+rsReason.getString("REASONDESC");
		   } 
		   rsReason.close();
		   stateReason.close();
	     // 若有批退,則取出原因
	    
	    out.print("<TR bgcolor='#D5D8A7'>");
		
		out.println("<TD width='1%'><div align='center'>");
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生管交期確認即設定欲結轉
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生管交期確認即設定欲結轉  
		if (rowLength==1) out.println("checked >"); else out.println(" >");
		out.println("</div></TD>");
		
		out.println("<TD width='2%' nowrap><font color='#000000'>");		
		out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQAcceptingPage.jsp?DNDOCNO="+dnDocNo+"&LINENO="+rs.getString("LINE_NO")+"&LINE_NO="+line_No+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+dateBean.getYearMonthDay()+'"'+")'>");			
		out.println("</TD>");
		out.println("<TD width='5%' nowrap><font color='#000000'>&nbsp;"); 
		if (rs.getString("PCACPDATE")==null || rs.getString("PCACPDATE").equals("") || rs.getString("PCACPDATE")=="N/A" || rs.getString("PCACPDATE").equals("N/A"))
		{		 // 表示未設定,以工廠給定交期為預設值
		  if (lineNo==null || lineNo.equals(""))
		  { 
		    if (rs.getString("FTACPDATE").length()>=8)  // 表示正常回覆交期
		    { out.println("<font color='#000099'>"+rs.getString("FTACPDATE").substring(0,8)+"</font>"); }
			else { // 否則表示其為批退件,顯示原因
			        out.println("<font color='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font>");
			     } 
		  } // 若未設定前一律以工作安排日為Default
		  else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO")))
		  {  out.println(pcAcceptDate+"</font>");  }
		  else  { 
		          if (rs.getString("FTACPDATE").length()>=8)  // 表示正常回覆交期
		          { out.println("<font color='#000099'>"+rs.getString("FTACPDATE").substring(0,8)+"</font>"); }
			      else { // 否則表示其為批退件,顯示原因
			             out.println("<font color='#000099'>"+reasonDesc+"</font>");
			           } 
				}
		  
		}
		else  { //out.println("11");
		        out.println("<font color='#FF0000'>"); 
				if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
				{ 
				  //if (reasonDesc=="(N/A)" || reasonDesc.equals("(N/A)"))
				 // {
				    if (rs.getString("PCACPDATE").length()>=8)  // 表示正常回覆交期 
				    { out.println("<font color='#000099'>"+rs.getString("PCACPDATE").substring(0,8)+"</font>"); }
					else if (rs.getString("FTACPDATE").length()>=8)
					{  out.println("<font color='#000099'>"+rs.getString("FTACPDATE").substring(0,8)+"</font>"); }
					else { out.println("<font color='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font>"); }
				 // }
				 // else { out.println("<font color='#FF0099'>"+reasonDesc+"</font>");  }
				}
				else {out.println(pcAcceptDate+"</font>"); } 
				
		      }		     			                      								  
	    			
		
		out.println("</TD><TD><font color='#000000'><a name="+rs.getString("LINE_NO")+">");
		out.println(rs.getString("LINE_NO")+"</a></font></TD><TD><font color='#000000'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font color='#000000'>"+rs.getString("QUANTITY")+"</font></TD><TD><font color='#000000'>"+rs.getString("UOM")+"</font></TD><TD><font color='#000000'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD><font color='#000000'>"+rs.getString("REMARK")+"</font></TD>");
		out.println("<TD><font color='#FF0000'>");
		if (rs.getString("REASON_CODE")==null || rs.getString("REASON_CODE").equals("00") || rs.getString("REASON_CODE").equals(""))
		{  // 正常件,印藍色
		 out.println("<font color='#000099'>"+rs.getString("REASON_CODE")+reasonDesc+"</font>");
		} // 批退件,印紅色
		else { out.println("<font color='#FF0000'>"+rs.getString("REASON_CODE")+reasonDesc+"</font>"); }
		out.println("</font></TD>");
		out.println("</TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("PCACPDATE");b[k][7]=rs.getString("FTACPDATE");	 
		 array2DArrangedFactoryBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && pcAcceptDate!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PCACPDATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,pcAcceptDate+dateBean.getHourMinuteSecond());  // 工廠交期安排
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=array2DArrangedFactoryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		        //out.println("ROW="+a.length+" ");
				//out.println("COLUMN="+a[0].length+"<BR>");
						
				//out.println(a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");	
				//out.println(a[1][0]+ " " +a[1][1]+" " +a[1][2]+" " +a[1][3]+" " +a[1][4]+" " +a[1][5]+" " +a[1][6]+"<BR>");
				//out.println(a[2][0]+ " " +a[2][1]+" " +a[2][2]+" " +a[2][3]+" " +a[2][4]+" " +a[2][5]+" " +a[2][6]+"<BR>");
				//out.println(a[3][0]+ " " +a[3][1]+" " +a[3][2]+" " +a[3][3]+" " +a[3][4]+" " +a[3][5]+" " +a[3][6]+"<BR>");
				//out.println(a[4][0]+ " " +a[4][1]+" " +a[4][2]+" " +a[4][3]+" " +a[4][4]+" " +a[4][5]+" " +a[4][6]+"<BR>");
				//out.println(a[5][0]+ " " +a[5][1]+" " +a[5][2]+" " +a[5][3]+" " +a[5][4]+" " +a[5][5]+" " +a[5][6]+"<BR>");
				
	        	//array2DEstimateFactoryBean.setFieldName("ADDITEMS");			
				//out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來  		
				//out.println(array2DEstimateFactoryBean.getCheckContent()); 				
		 }	//enf of a!=null if		
		/* 
	  int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String d[][]=array2DEstimateFactoryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (d!=null) 
		 {		  
		        div1=d.length;
				div2=d[0].length;				
	        	//array2DEstimateFactoryBean.setFieldName("ADDITEMS");			
				out.println(array2DEstimateFactoryBean.getArray2DString()); 				
				//isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y"  	
		  		 				
		 }	//enf of a!=null if		
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }*/
    %> </font>      
  </tr>       
</table>
<table border="1" cellpadding="0" cellspacing="0" align="center" width="97%" bordercolor="#996633"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">       
  <tr bgcolor='#D5D8A7'> 
      <td colspan="3"><font color='#000000'><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
     </td>
    </tr>
    <tr bgcolor='#D5D8A7'>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><font size="2"><%=userID+"("+UserName+")"%></font></td>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessDate"/>:<%=dateBean.getYearMonthDay()%>
    </font></td>
      <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessTime"/>: 
	   <%=dateBean.getHourMinuteSecond()%></font>
      </td>
    </tr>       
</table>
<%
  }  // End of if (frStatID.equals("007"))
%>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  
	        
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' order by 2 ");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQAcceptingPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+'"'+")'>");				  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
          out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
               }        
	   } //end of while
	   out.println("</select>"); 
	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   {
         //out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='setSubmit3("+'"'+"../jsp/TSSalesDRQMProcess.jsp?DNDOCNO="+dnDocNo+'"'+")'>");
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
	   } 
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></a></td></tr></table>
<!-- 表單參數 --> 
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>