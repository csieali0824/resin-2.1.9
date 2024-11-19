<%//@ page contentUNIT="text/html; charset=big5" language="java" import="java.sql.*" errorPage="" %>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Repair Person Input Form</title>
<meta http-equiv="Content-UNIT" content="text/html; charset=big5">

</head>

<body>
<FORM ACTION="file:///O|/webapps/repair/jsp/RepCostInsert.jsp" METHOD="post">
  <p><A HREF="/repair/RepairMainMenu.jsp">回首頁</A> &nbsp;&nbsp <A HREF="file:///O|/webapps/repair/jsp/MRQAll.jsp">查詢所有領料案件</A> 
  </p>
  <p><font color="#0080FF" size="5"><strong>維修費用維護</strong></font> 
    <% 
       
		 String LOCALE=request.getParameter("LOCALE");   	 
		 String UNIT=request.getParameter("UNIT");   	 
	 
	  
  %>
  </p>
  <table width="78%" border="1">
    <tr> 
      <td>維護年月: 
        <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("RECYEAR");	   
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
	   arrayComboBoxBean.setFieldName("RECMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %> </td>
      <td>國別代碼: <font size="2"><font color="#333399" face="Arial Black"><strong> 
        </strong></font><font color="#FF0066" face="Arial Black"><strong> 
        <%
		 
         try
         {   
		  String sSql = "";
		  String sWhere = "";		  
		  
		  sSql = "select trim(LOCALE) from WSLOCALE";		  
		  sWhere = " order by LOCALE";
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='LOCALE' onChange='setSubmit("+'"'+"../jsp/RepCostInput.jsp"+'"'+")'>");
         //out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           //String s2=(String)rs.getString(2); 
		   //String s2=""; 
         
            if (s1.equals(LOCALE)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s1);                                     
            } 
			
			else 
			{
              out.println("<OPTION VALUE='"+s1+"'>"+s1);
            }      
           } //end of while
           out.println("</select>"); 	  		  		  
       
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }      
        %>
        </strong></font><font color="#333399" face="Arial Black"><strong> </strong></font></font></td>
      <td>維護人員:<%=userID%></td>
    </tr>
    <tr> 
      <td width="34%">維修工時單位： <font color="#FF0066" face="Arial Black"> 
        <select name="UNIT">
          <option value="1" <% if (UNIT!=null && (UNIT=="1" || UNIT.equals("1")) ) { out.println("SELECTED"); } %>>0.5</option>
          <option value="2"<% if (UNIT!=null && (UNIT=="2" || UNIT.equals("2")) ) { out.println("SELECTED"); } %>>1</option>
          <option value="3"<% if (UNIT!=null && (UNIT=="3" || UNIT.equals("3")) ) { out.println("SELECTED"); } %>>1.5</option>
          <option value="4"<% if (UNIT!=null && (UNIT=="4" || UNIT.equals("4")) ) { out.println("SELECTED"); } %>>2</option>
        </select>
        </font></td>
      <td width="33%">基本維護費: 
        <INPUT TYPE="text" NAME="USERID2" size="10"> </td>
      <td width="33%">實際維護費: 
        <INPUT TYPE="text" NAME="USERID3" size="10"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="存檔">
  </p>
  </FORM>
  </body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
