<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean"%>
<html>
<head>
<title>INVIssPage.jsp</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function btnCustomerInfo()
{ 
  subWin=window.open("subwindow/CustomerInfoSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
var chkflag="false";
function btnItemInfo()
{ 
  subWin=window.open("subwindow/AddMaterialSubWindow.jsp?FIRST=Y","subwin","width=600,height=400,scrollbars=yes,menubar=no");  
  chkflag = "true"; 
}
function btnAddJam()
{ 
  subWin=window.open("subwindow/AddJamCodeSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function submitCheck()
{ 
  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert("請先選擇您欲執行之動作後再存檔!!");   
   return(false);
  } 
  
 
  if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm("確定要REJECT?");      
   if (flag==false)  return(false);
  }   
  
   if (chkflag=="false")  
   {
       alert("請先選擇倉別/架位後再存檔!!");   
       return(false);
   }  
            
  document.MYFORM.submit();    
  //return(true);  
}
</script>
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckInputBoxBean"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="arrayCheckInputBoxBean" scope="session" class="ArrayCheckInputBoxBean"/>

<%
  arrayCheckInputBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作

  String ISSCREATENO=request.getParameter("ISSCREATENO");
  String ISSCENTERNO="";
  String ISSCREATEDATE="";
  String ISSCREATEUSER="";
  String WHS="";
  String LOC="";
  String REMARK="";
  String ISSSTATID="";
  String ISSSTAT="";
  String USERNAME="";  
%>
</head>
<body>
<FORM ACTION="/wins/jsp/INVProcessACT.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()'>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <BR>
  <font color="#0080FF" size="5"><strong>領料單確認</strong></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
  <%
  try
    {
  	Statement statement9=con.createStatement();
    ResultSet rs9=statement9.executeQuery("select ISSCREATENO from INV_M_ISS WHERE ISSCREATENO='"+ISSCREATENO+"'");
    rsBean.setRs(rs9);
   
   if(rs9.next())
   {
	if (ISSCREATENO != null)
	{
	   
	  Statement statement=con.createStatement();
      //String sql="select * from RPMR where MRDOCNO='"+MRDOCNO+"'"; // 修正SPAN 誤用 userName 之問題點 2004/05/24 //
      String sql="select ISSCREATENO,ACTCENTERNO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT,USERNAME from INV_M_ISS, WSSHIPPER "+
                 "where ACTUSERID=ISSCREATEUSER and ISSCREATENO='"+ISSCREATENO+"' ";
      ResultSet rs=statement.executeQuery(sql);
	  rs.next();
	 ISSCREATENO=rs.getString("ISSCREATENO");
     ISSCENTERNO=rs.getString("ACTCENTERNO");
	 ISSCREATEDATE=rs.getString("ISSCREATEDATE");
     ISSCREATEUSER=rs.getString("ISSCREATEUSER");
	 ISSSTATID=rs.getString("ISSSTATID");
	 ISSSTAT=rs.getString("ISSSTAT");
     USERNAME=rs.getString("USERNAME");

 	 rs=statement.executeQuery("select * from INV_M_HISTORY WHERE RECCREATENO='"+ISSCREATENO+"' ");	
	 while (rs.next())
	 { 
	   REMARK=rs.getString("REMARK");
	 }
	 rs.close();
		
	} //end of if
   }//end of if
   }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<% out.println("<font color='#000099' size='4'><strong>單號 : </strong></font>"+"<font color='#FF0000' size='4'><strong>"+ISSCREATENO+"</strong></font>"); %>
  <table width="96%" border="1">
    <tr> 
      <td colspan="3">申請日期:<%=ISSCREATEDATE.substring(0,4)%>/<%=ISSCREATEDATE.substring(4,6)%>/<%=ISSCREATEDATE.substring(6,8)%>  </td>
      <td width="30%"> 申請人:<%=ISSCREATEUSER+"("+UserName+")" //修正SPAN 誤用 userName 之問題點 2004/05/24 // %><!--%=RECCREATEUSER+"("+USERNAME+")"%--></td>
    </tr>
    <tr> 
      <td width="40%" colspan="3" >申請料件: <br>
        <%
	  try
      {       
	   String jamString="";
	   String qty="";
       Statement statement1=con.createStatement();
       out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>料號</font></td><td><font size='2' color='#FFFFFF'>料號說明</font></td><td><font size='2' color='#FFFFFF'>數量</font></td></tr>"); 
       ResultSet rs1=statement1.executeQuery("select * from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");	   
	   while (rs1.next())
	   {
	    jamString=rs1.getString("ISSITEMNO");
        String itemDesc = "";  
        Statement stateID=con.createStatement();
        ResultSet rsID=stateID.executeQuery("select ITEMDESC from INV_ITEM where trim(ITEMNO)='"+jamString+"' ");	 
        if (rsID.next()) { itemDesc = rsID.getString("ITEMDESC");  }  
        rsID.close();     
        stateID.close();            
		   
		out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+jamString+"</font></td>");
        out.print("<td><font size='2'>"+itemDesc+"</font></td>");  
		qty=rs1.getString("ISSQTY");
		out.print("<td><font size='2'>"+qty+"</font></td></tr>");
	   }    	   	   	          
	   out.println("</table>");
	   
	   statement1.close();
       rs1.close();        
	   
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %> 
      </td>
      <td><input name="button3" type=button onClick="btnItemInfo()" value="實領料件">        
      <%
		  //this field means to get the all features to arrayCheckInputBoxBean  		     
		  try
		  {
		  	 //String jamString="";
	         //String qty="";
			 Statement statementy=con.createStatement();
             ResultSet rsy=statementy.executeQuery("select count (*) from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");			 			 			                         	  
			 rsy.next();
			 int featureCount= rsy.getInt(1);
			 rsy.close();
			 if (featureCount>0) //if there are some features exists
			 {
			 String t[][]=new String[featureCount][4];
		     Statement statementp=con.createStatement();
             ResultSet rsp=statementp.executeQuery("select ISSITEMNO,ISSQTY,ISSWHS,ISSLOC from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"'");			 			 			                         	  			 
			 
			  int i=0;
			 
			     while (rsp.next())
			     {
			      t[i][0]=rsp.getString("ISSITEMNO");
			      t[i][1]=rsp.getString("ISSQTY");
			      t[i][2]=rsp.getString("ISSWHS");
			      t[i][3]=rsp.getString("ISSLOC");				  
			      i++;
			     }    		
    		     arrayCheckInputBoxBean.setArray2DString(t);				 
			     statementp.close();
			     rsp.close();
				 } else {
			     arrayCheckInputBoxBean.setArray2DString(null);
			  }	
	 
		  } //end of try
		  catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }	  
	    %> </td></tr>
  </table> 
  <br> 
    <strong><font color="#FF0000">可執行動作-&gt;</font></strong> 
    <%
	  try
      {       
       Statement statement=con.createStatement();
       /*    對自己sql 很有信心的 SPAN 不將 sql 寫於字串供檢核, 且未作到 已簽核單據不出現執行動作的 檢查
        ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from RPWORKFLOW x1,RPWFACTION x2 WHERE FORMID='RI' AND FROMSTATUSID='025' AND x1.ACTIONID=x2.ACTIONID");
       */   //對自己sql 很有信心的 SPAN 不將 sql 寫於字串供檢核, 且未作到 已簽核單據不出現執行動作的 檢查
       String sql = "select x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1, WSWFACTION x2, INV_M_ISS x3  "+
                    "WHERE FORMID='RD' AND FROMSTATUSID='004' AND x1.ACTIONID=x2.ACTIONID "+
                    "and x1.FROMSTATUSID=x3.ISSSTATID and x3.ISSCREATENO='"+ISSCREATENO+"' ";  
       ResultSet rs=statement.executeQuery(sql); 
       comboBoxBean.setRs(rs);
	   comboBoxBean.setFieldName("ACTIONID");	   
       out.println(comboBoxBean.getRsString());
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  </div>
 <p> 
	<INPUT TYPE="button" value='執行' onClick='submitCheck()'>
  </p>
  <p>
  <!-- 表單參數 -->  
    <input name="ISSCREATENO" type="HIDDEN" value="<%= ISSCREATENO %>">	
    <input name="ISSSTATID" type="HIDDEN" value="<%= ISSSTATID %>">	
    <input name="FROMSTATUSID" type="HIDDEN" value="004">
  </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

