<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,,ArrayComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<p> <strong><font color="#54A7A7" size="+2" face="Arial Black"> DBTEL</font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  產品代碼<font color="#FF0000">復原</font></font></strong></p>

<A HREF="../WinsMainMenu.jsp">首頁</A>
<%
String WEBID=null;
String RD_CODE=null;;
String PCLS_CODE=null;
String APPEAR_CODE=null;
String PLATFORM_CODE=null;
String PRODEXT_CODE=null;
String FTURE_CODE=null;
String FTURE_CODE2=null;
String BUYER=null;
String REMARK=null;
String seqkey=request.getParameter("MODELNO");
String dateString=null;
String recPersonID=userID;
String userName=request.getParameter("userName");
String RDDPT=null;
String pjtnDate=null;
String recDate=null;
String ENUSER=null;
String ENDTIME=null;
String PROD_CLASS=null;
String PROD_APPEAR=null;
String SPLATFM_NAME=null;
String PRODEXTEND=null;
String FEATURE=null;
String FEATURE2=null;
String MODELNO=null;
String APPNO=null;
%>

<FORM ACTION="WSModelCodeAct.jsp" METHOD="post">
<%
try
{  
  dateString=dateBean.getYearMonthDay();
  //====先取得流水號=====  
  Statement statement=con.createStatement();
  String sql = "select * from MRMODELAPP where MODELNO='"+seqkey+"' ";
  ResultSet rs=statement.executeQuery(sql);
  
  if (rs.next()==true)
  {   
   APPNO=rs.getString("APPNO");
   WEBID=rs.getString("APPLY_USER");
   recDate=rs.getString("APPLY_DATE");
   pjtnDate=rs.getString("PJTTNON_DATE");
   ENUSER=rs.getString("ENUSER");
   ENDTIME=rs.getString("ENDTIME");
   BUYER=rs.getString("BUYER");
   RD_CODE=seqkey.substring(0,1);
   PCLS_CODE=seqkey.substring(1,2);
   APPEAR_CODE=seqkey.substring(2,3);
   PLATFORM_CODE=seqkey.substring(3,5);
   PRODEXT_CODE=seqkey.substring(7,8);
   if (seqkey.length()>8)
   {
     FTURE_CODE=seqkey.substring(8,9);
     FTURE_CODE2=seqkey.substring(9,10);
   }	 
   String sSql = "select RDDPT from MRDPT where RD_CODE = '"+RD_CODE+"' ";
   ResultSet rs1=statement.executeQuery(sSql);
   if (rs1.next()==true)
   	  RDDPT=rs1.getString("RDDPT");
   
   sql = "select PROD_CLASS from MRPRODCLS where PCLS_CODE='"+PCLS_CODE+"' ";
   ResultSet rs2=statement.executeQuery(sql); 
   if (rs2.next()==true)
   	  PROD_CLASS=rs2.getString("PROD_CLASS");

   sql = "select PROD_APPEAR from MRPROD_APRNCE where APPEAR_CODE='"+APPEAR_CODE+"' ";
   ResultSet rs3=statement.executeQuery(sql); 
   if (rs3.next()==true)
   	  PROD_APPEAR=rs3.getString("PROD_APPEAR");

   sql = "select vnd_name || '('||SPLATFM_NAME ||')' as x  from PRPROD_PLATFORM where PLATFORM_CODE='"+PLATFORM_CODE+"' ";
   ResultSet rs4=statement.executeQuery(sql); 
   if (rs4.next()==true)
   	  SPLATFM_NAME=rs4.getString("x");

   sql = "select PRODEXTEND from MRPROD_EXT where PRODEXT_CODE='"+PRODEXT_CODE+"' ";
   ResultSet rs5=statement.executeQuery(sql); 
   if (rs5.next()==true)
   	  PRODEXTEND=rs5.getString("PRODEXTEND");

   sql = "select FEATURE from MROTH_FEATURE where FTURE_CODE='"+FTURE_CODE+"' ";
   ResultSet rs6=statement.executeQuery(sql); 
   if (rs6.next()==true)
   	  FEATURE=rs6.getString("FEATURE");

   sql = "select FEATURE from MROTH_FEATURE where FTURE_CODE='"+FTURE_CODE2+"' ";
   ResultSet rs7=statement.executeQuery(sql); 
   if (rs7.next()==true)
   	  FEATURE2=rs7.getString("FEATURE");

  } else
  {
    out.println("error modelno: "+seqkey);
   }  // END OF ELSE
  

  //=============================================================================      


  statement.close();
  rs.close(); 
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
  <strong><font color="#0000FF" face="Arial">產品代碼 : 
<%
	 String model = seqkey;
	 String prfx  = model.substring(0,3);
	 String skey  = model.substring(3,7);
	 String seri  = model.substring(7); 
	 out.println("<font color='#000000'>"+prfx+"</font>"+"<font color='#FF0000' face='Arial Black'>"+skey+"</font>"+"<font color='#000000'>"+seri+"</font>"); 
  %>  </font></strong> 
</p>
<table width="735" border="1">
  <tr> 
      <td width="195" height="40" bgcolor="#CCCCCC"><font color="#0000FF">申請人：</font><font color="#0000FF"><%=WEBID %></font></td>
      <td width="268" bgcolor="#CCCCCC"><font color="#FF0000">研發單位 ：</font><font color="#FF0000"><%=RDDPT %></font></td>
      <td width="250" bgcolor="#CCCCCC"><font color="#0000FF">申請日 :</font><font color="#0000FF"> <%=recDate %></font></td>
  </tr>
  <tr> 
      <td height="41" bgcolor="#CCCCCC"> <font color="#FF0000">產品別 :</font> <font color="#0000FF">&nbsp;<%=PROD_CLASS %></font></td>
      <td bgcolor="#CCCCCC"> <font color="#FF0000">外觀　: <%=PROD_APPEAR %></font></td>
      <td bgcolor="#CCCCCC"> <font color="#FF0000">發展平台：<%=SPLATFM_NAME %></font></td>
  </tr>
  <tr> 
      <td height="37" bgcolor="#CCCCCC"><font color="#FF0000">主螢幕 ：<%=PRODEXTEND %></font></td>
      <td bgcolor="#CCCCCC"><font color="#FF0000">延伸機種１：<%=FEATURE %></font></td>
      <td bgcolor="#CCCCCC"><font color="#FF0000">延伸機種２：<%=FEATURE2 %></font></td>
  </tr>
  <tr> 
      <td height="43" bgcolor="#CCCCCC"><font color="#0000FF">Buyer ：<%=BUYER %></font></td>
      <td bgcolor="#CCCCCC">&nbsp;</td>
      <td bgcolor="#CCCCCC"><font color="#0000FF">專案生效日 :</font><font size=2> 
        <%
         String PJTNYEAR=request.getParameter("PJTNYEAR");
         String PJTNMONTH=request.getParameter("PJTNMONTH");
         String PJTNDAY=request.getParameter("PJTNDAY");
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("PJTNYEAR");	   
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
	   arrayComboBoxBean.setSelection(dateBean.getMonthString());     	   
	   arrayComboBoxBean.setFieldName("PJTNMONTH");	   
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
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   	   
	   arrayComboBoxBean.setSelection(dateBean.getDayString());
	   arrayComboBoxBean.setFieldName("PJTNDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
  </tr>
  <tr> 
      <td height="44" bgcolor="#FFCCCC"><font color="#0000FF">修改人 :</font><font color="#FF0000" > 
        <%=userID
	   %></font></td>
      <td bgcolor="#FFCCCC"><font color="#0000FF">修改日 :</font><font color="#FF0000"> 
        <%=dateBean.getYearMonthDay()%></font></td>
      <td bgcolor="#FFCCCC"><font color="#0000FF">修改時間 :</font><font color="#FF0000"> 
        <%=dateBean.getHourMinuteSecond()%></font></td>
  </tr>
    <tr> 
      <td height="38" colspan="3"><font color="#0000FF">備註 ：</font> 
        <input name="REMARK" type="text" size="30"></td>
    </tr>
</table>
  <p> 
    <input type="hidden" name="MODELNO" value="<%= seqkey %>" >
    <input type="hidden" name="APPNO" value="<%= APPNO %>" >
    <input type="hidden" name="RDDPT" value="<%= RDDPT %>" >
    <input type="hidden" name="BUYER" value="<%= BUYER %>" >
    <input type="hidden" name="PROD_CLASS" value="<%= PROD_CLASS %>" >
    <input type="hidden" name="APPLY_USER" value="<%= WEBID %>" >
    <input type="hidden" name="APPLY_DATE" value="<%= recDate %>" >
    <input type="hidden" name="ENUSER" value="<%= ENUSER %>" >
    <input type="hidden" name="ENDTIME" value="<%= ENDTIME %>" >

    <input type="submit" name="Submit" value="復原">
    <em>　
    <input type="reset" name="reset" value="取消">
    </em> </p>

</form>
<p>&nbsp; </p>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
