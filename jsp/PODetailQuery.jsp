<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->

<title>Purchase Order Detail</title>

<html>
<style type="text/css">
<!--
.style2 {color: #000099}
-->
</style>
<head>
</head>
<body>
<strong><font color="#333333" face="Arial, Helvetica, sans-serif"> </font></strong>
<FORM action="PODetailQuery.jsp"  METHOD="post" NAME="MYFORM" >
  <font color="#333333"  face="Arial, Helvetica, sans-serif"><strong>Purchase 
    Order Detail</strong></font><br>
  <A HREF="../WinsMainMenu.jsp">HOME</A> 
    <% 
     String sqlGlobal=""; 
     String PONO=request.getParameter("PONO");
	 String DATABASE=request.getParameter("DATABASE"); 
	 String poDate=""; 
     String vndNo=""; 
     String vndName=""; 
%>
    <%          try
                {  Statement statement=null;     
                   String sql =  "select PHENDT,PHVEND,VNDNAM"+
			                           "  from hph h,avm v ";
			       String sWhere = " where  h.phvend=v.vendor and phord="+PONO+" ";
			        sql = sql + sWhere ;
						   if (DATABASE=="dbtel" || DATABASE.equals("dbtel" ))
			                  {statement=bpcscon.createStatement(); 						       			 }
						   else
			                 {statement=ifxdistcon.createStatement(); 						   			 }
					//out.println(sql); 
					ResultSet rs=statement.executeQuery(sql);
                      if (rs.next())
                    {            
                         poDate=(String)rs.getString(1); 
                         vndNo=(String)rs.getString(2); 
                         vndName=(String)rs.getString(3); 
					}	   
						    rs.close();    
		                   statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }    
%>  
  <table width="100%" border="1">
    <tr bgcolor="#FFFFCC"> 
      <td colspan="2" nowrap bordercolor="#CCCCCC"><font color="#FFFFFF" size="2"><strong><font color="#0000FF">訂單號碼</font><font color="#FFFFFF" size="2"><strong><font color="#0000FF">：</font></strong></font><font color="#0000FF" face="Arial"><strong><%=PONO%></strong></font></strong></font></td>
      <td colspan="5" nowrap bordercolor="#CCCCCC"><font color="#FFFFFF" size="2"><strong><font color="#0000FF">日期：</font><font color="#0000FF" face="Arial"><strong><%=poDate%></strong></font></strong></font></td>
    </tr>
    <tr bgcolor="#FFFFCC"> 
      <td colspan="2" nowrap bordercolor="#CCCCCC"><font color="#FFFFFF" size="2"><strong><font color="#0000FF">廠商代碼：</font><font color="#0000FF" face="Arial"><strong><%=vndNo%></strong></font></strong></font><font color="#0000FF" size="2">&nbsp;</font></td>
      <td colspan="5" nowrap bordercolor="#CCCCCC"><font color="#0000FF" size="2"><strong>廠商名稱：</strong></font><font color="#FFFFFF" size="2"><strong><font color="#0000FF" face="Arial"><strong><%=vndName%></strong></font></strong></font></td>
    </tr>
    <tr bordercolor="#CCCCCC" bgcolor="#FFFFCC"> 
      <td colspan="7" nowrap><font color="#FFFFFF" size="2"><strong><font color="#0000FF">交貨地點：土城市自強街15巷2號2樓</font></strong></font></td>
    </tr>		
    <tr bordercolor="#CCCCCC" bgcolor="#FDEAFD"> 
      <td width="12%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">料號/品名規格</font></strong></font></td>
      <td width="10%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">單位</font></strong></font></td>
         <td width="11%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">訂單幣別</font></strong></font></td>
      <td width="11%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">訂購數量</font></strong></font></td>
      <td width="13%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">單價</font></strong></font></td>
      <td width="16%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">總價</font></strong></font></td>
      <td width="13%" nowrap><font color="#FFFFFF" size="2"><strong><font color="#663300">交貨時間</font></strong></font></td>
    </tr>
	<%
	try
                {  Statement stmt=null;     
                   String sqlL =  "select PPROD,PODESC,PUM,POCUR,PQORD,PECST,PQORD*PECST as TOTAL,PDDTE"+
			                           "   from  hpo  ";
			       String sWhereL = " where pord="+PONO+" ";
			        sqlL = sqlL + sWhereL ;
					//out.println(sqlL); 
			        sqlGlobal = sqlL;
						   if (DATABASE=="dbtel" || DATABASE.equals("dbtel" ))
			                  {stmt=bpcscon.createStatement( ); 						       			 }
						   else
			                 {stmt=ifxdistcon.createStatement(); 						   			 }
					ResultSet rsl=stmt.executeQuery(sqlL);
                     while (rsl.next())
                    {            
	%>
    <tr bordercolor="#CCCCCC" bgcolor="#E8FDFF"> 
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("PPROD")!=null ) { out.println(rsl.getString("PPROD")); } 
                      else { out.println("&nbsp;"); }
                  %>
        <% 
                      if (rsl.getString("PODESC")!=null ) { out.println(rsl.getString("PODESC")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("PUM")!=null ) { out.println(rsl.getString("PUM")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("POCUR")!=null ) { out.println(rsl.getString("POCUR")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("PQORD")!=null ) { out.println(rsl.getString("PQORD")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("PECST")!=null ) { out.println(rsl.getString("PECST")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("TOTAL")!=null ) { out.println(rsl.getString("TOTAL")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td nowrap><font size="2" color="#000099"> 
        <% 
                      if (rsl.getString("PDDTE")!=null ) { out.println(rsl.getString("PDDTE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
    </tr>
	<%
              
             }
	          rsl.close();
	          stmt.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
  </table>  
  <input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>"> <BR>
 </FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<!--=================================-->
</html>
 