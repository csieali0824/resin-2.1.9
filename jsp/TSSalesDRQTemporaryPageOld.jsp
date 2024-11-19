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
<jsp:useBean id="array2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/>
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
  } else if (document.DISPLAYREPAIR.ACTIONID.value!="002" && document.DISPLAYREPAIR.ACTIONID.value!="001")  //表示動作清單不為CREATE,可能是自行輸入LINE_ID,因此需卡住網頁動作
          { 
            alert("                    Error Action Process!!!\n Don't try key-in invalid line No in this page...");   
            return(false);
          }        
  
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
  //alert(document.DISPLAYREPAIR.CHKFLAG.length);  
 
  var linkURL = "#ACTION";
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit2(URL,LINKREF)
{ 
   warray=new Array(document.DISPLAYREPAIR.REQUESTDATE.value); 
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
         document.DISPLAYREPAIR.REQUESTDATE.focus();
         return(false);
        }
        gone=datetime.substring(4,5);
        month=datetime.substring(4,6);
        if(isNaN(month)==true)
		{
          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          document.DISPLAYREPAIR.REQUESTDATE.focus();
          return(false);
        }
        gtwo=datetime.substring(7,8);
        day=datetime.substring(6,8);
        if(isNaN(day)==true)
		{
          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          document.DISPLAYREPAIR.REQUESTDATE.focus();
          return(false);
        }
     //   if((gone=="-")&&(gtwo=="-"))
	 //	{
	 //alert(day);
          if(month<1||month>12) 
		  { 
            alert("Month must between 01 and 12 !!"); 
            document.DISPLAYREPAIR.REQUESTDATE.focus();   
            return(false); 
          } 
          if(day<1||day>31)
		  { 
            alert("Day must between 01 and 31!!");
            document.DISPLAYREPAIR.REQUESTDATE.focus(); 
            return(false); 
          }else{
                 if(month==2)
				 {  
                    if(isLeapYear(year)&&day>29)
					{ 
                      alert("February between 01 and 29 !!"); 
                      document.DISPLAYREPAIR.REQUESTDATE.focus();
                      return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                     alert("February between 01 and 29 !!");
                     document.DISPLAYREPAIR.REQUESTDATE.focus(); 
                     return(false); 
                    } 
                 } // End of if(month==2)
                 if((month==4||month==6||month==9||month==11)&&(day>30))
				 { 
                   alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   document.DISPLAYREPAIR.REQUESTDATE.focus(); 
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
          document.DISPLAYREPAIR.REQUESTDATE.focus();
          return(false);
         }
  }else{ // 不卡日期未輸入,由訂單產生前若未設定 Schedule Shippment Date則預設與Customer Request Date相同
          //alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          //document.DISPLAYREPAIR.SSHIPDATE.focus();
          //return(false);
       }
	   
  document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目	   

  var requestDate="&REQUESTDATE="+document.DISPLAYREPAIR.REQUESTDATE.value; 
  var linkURL = "#"+LINKREF;
  document.DISPLAYREPAIR.action=URL+requestDate+linkURL;
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
   String quantity=request.getParameter("QUANTITY");
   String requestDate = request.getParameter("REQUESTDATE");  
   
   String [] check=request.getParameterValues("CHKFLAG");
   //response.sendRedirect("../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo); 
   
      
   if (lineNo==null) { lineNo="";}
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   if (requestDate==null) { requestDate="";}   
   if (quantity==null) { quantity="0";}
   
%>
<body>

<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
<em><font color="#993366" size="+2"><strong><<jsp:getProperty name="rPH" property="pgTempDRQDoc"/>></strong></font></em>
<BR>
<!--=============以下區段為取得交期單據基本資料==========-->  
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<HR>
<table cellSpacing="0" bordercolordark="#99CCFF" cellPadding="1" width="97%" align="center" bordercolorlight="#FFEEFF"  border="1">
    <tr bgcolor="#99CCFF"> 
    <td colspan="3"><font size="2" color="#000066">
      <jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/>
      : <BR>
      <%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	array2DTemporaryBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][7]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#99CCFF'  cellPadding='1' width='100%' align='center' borderColorLight='#ffEEff' border='1'>");
	   out.println("<tr>");
	   out.println("<td nowrap><div align='center'>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	   <%
	   out.println("</div></td>");   
	   //out.println("<td nowrap><font size='2' color='#FFFFFF'></font>&nbsp;</td>");
	   out.println("<td nowrap><font size='2' color='#FFFFFF'>&nbsp;</font></td><td nowrap><font size='2' color='#FFFFFF'>");
	   try
        { 
		  out.println("<font color='RED' size='2'><div align='center'>QTY</div></font><div align='center'><input name='QUANTITY' type='text' size='5' ");
		  if (lineNo!=null) out.println("value="+quantity); else out.println("value="+quantity); 
		  out.println("></div>");	   
	   } //end of try		 
       catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	   out.println("</font></td>");
	   out.println("<td nowrap width='5%'><font size='2' color='RED'><div align='center'>CR. Date</div>");
	   try
        { 
		  out.println("<input name='REQUESTDATE' type='text' size='8' ");
		  if (lineNo!=null) out.println("value="+requestDate); else out.println("value="+requestDate); 
		  out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	   } //end of try		 
       catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	   out.println("</font></td>");
	     
	   out.println("<td><font size='2'>Line</font></td><td><font size='2'>Ordered Item</font></td><td><font size='2'>Item Description</font></td><td><font size='2'>Qty</font></td><td><font size='2'>UOM</font></td><td><font size='2'>Request Date</font></td><td><font size='2'>Remark</font></td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	   { sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   
	          sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
			}
	   //out.println("sqlEst="+sqlEst);
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0"); 
	    out.print("<TR>");		
		out.println("<TD width='1%'><div align='center'>");
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定廠別即設定欲結轉
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給廠別即設定欲結轉  
		if (rowLength==1) out.println("checked >"); else out.println(" >");
		out.println("</div></TD>");
					
		out.println("<TD width='1%'><font size='2'>");
		out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQTemporaryPage.jsp?LINENO="+rs.getString("LINE_NO")+"&DNDOCNO="+dnDocNo+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");	
		out.println("</div></TD>");
		
		out.println("<TD width='5%' nowrap><font size='2'>");
		if (rs.getString("QUANTITY")=="0" || rs.getInt("QUANTITY")==0 || rs.getFloat("QUANTITY")==0.0)
		{  //out.println("1");
		  out.println("<font size='2'>");
		  if (lineNo==null || lineNo.equals(""))
		  { out.println(rs.getFloat("QUANTITY")+"</font>");  }
		  else if (lineNo.equals(rs.getString("LINE_NO")) || lineNo==rs.getString("LINE_NO"))
		  {  out.println(quantity+"</font>");  }
		  else {  out.println(rs.getFloat("QUANTITY")+"</font>"); }
		}
		else  { //out.println("4");
		        out.println("<font size='2' color='#FF0000'>"); 
				if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
				{  out.println(rs.getFloat("QUANTITY")+"</font>");		}
				else {out.println(quantity+"</font>"); }	
		      }		
		out.println("</TD>");
		out.println("<TD width='5%' nowrap>");
		//out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?LINENO="+rs.getString("LINE_NO")+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+preOrderType+"&DNDOCNO="+dnDocNo+'"'+")'>");	
		if (rs.getString("REQUEST_DATE")==null || rs.getString("REQUEST_DATE").equals(""))
		{ 
		  out.println("<font size='2'>"); 
		  if (lineNo==null || lineNo.equals(""))
		  {   }
		  else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO")))
		  {  out.println(requestDate+"</font>"); }		  
		}
		else  { 
		        out.println("<font size='2' color='#FF0000'>"); 
				if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
				{ out.println(rs.getString("REQUEST_DATE").substring(0,8)+"</font>");	}
				else { 
				      if (requestDate=="" || requestDate.equals(""))  out.println(rs.getString("REQUEST_DATE").substring(0,8)+"</font>"); 
					  else out.println(requestDate+"</font>");
					 } 				
		      }	
		out.println("</TD>");
		
		out.println("<TD><font size='2'>");
		out.println(rs.getString("LINE_NO")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("QUANTITY")+"</font></TD><TD><font size='2'>"+rs.getString("UOM")+"</font></TD><TD><font size='2'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD><font size='2'>"+rs.getString("REMARK")+"</font></TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("PCACPDATE");		 
		 array2DTemporaryBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && quantity!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set QUANTITY=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
		  pstmt.setFloat(1,Float.parseFloat(quantity));  // 業務修改數量          
		  pstmt.executeUpdate(); 
          pstmt.close();
        } 
		if (lineNo !=null && requestDate!=null && !requestDate.equals(""))
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set REQUEST_DATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  		 
          pstmt.setString(1,requestDate+dateBean.getHourMinuteSecond());  // 業務修改需求日
		  pstmt.executeUpdate(); 
          pstmt.close();
        } 
		 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=array2DTemporaryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		       
		 }	//enf of a!=null if		
		
    %> </font>      
  </tr>       
</table>
<table cellSpacing="0" bordercolordark="#66CCCC" cellPadding="1" width="97%" align="center" bordercolorlight="#CDFFFF" border="1">       
  <tr bgcolor="#99CCFF"> 
      <td colspan="3"><font size="2"><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
     </td>
    </tr>          
</table>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  
	        
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQTemporaryPage.jsp?DNDOCNO="+dnDocNo+'"'+")'>");				  				  
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
         out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
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
</FORM>
<input name="LSTATUSID" type="hidden" value="<%=frStatID%>" >
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
