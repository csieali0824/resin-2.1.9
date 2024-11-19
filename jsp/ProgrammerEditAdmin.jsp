<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxAllBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ProgrammerEdit.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>


<form action="../jsp/UpdateProgrammerAdmin.jsp" method="post" name="signform" >
  <table  border="1" align="center" bordercolor="#6699CC">
    <tr>
      <td width="606" height="72" background="../image/back5.gif"> 
        <p><a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp">查詢所有檔案資訊</A><br>
          <%
  String ADDRESS=request.getParameter("ADDRESS");
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");
  String LINENO=request.getParameter("LINENO");
  String MODEL=request.getParameter("MODEL");  
  String programmername=""; 
  String lineno=""; 
  String model=""; 
  int maxno=0; 
  
try
{
     Statement statement=con.createStatement();
	 String sSql="select PROGRAMMERNAME,MODEL,LINENO,ADDRESS from wsProgrammer where trim(ADDRESS)='"+ADDRESS+"'"; 
	 //out.println(sSql); 
     ResultSet rs=statement.executeQuery(sSql);
     if(rs.next())
	 {
	 programmername=rs.getString("PROGRAMMERNAME"); 
	 model=rs.getString("MODEL"); 
	 lineno=rs.getString("LINENO"); 
	 //ADDRESS=rs.getString("ADDRESS"); 
	 } 
	statement.close();
	rs.close();
  }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }%>
        </p>
        <p><font color="#FF0000"><strong>程式檔案維護</strong></font> </p></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 角色名稱: 
        <% 
		 out.println("Admin");
       %>
        <br>模組: 
		<%
		  /*	 if(!model.equals(""))
		   {MODEL=model;   }
		   	 if(!MODEL.equals("") || !MODEL.equals(null))
		   {model="";   }*/

		%>
        <%--<select name="MODEL" onChange="setSubmit('../jsp/ProgrammerEditAdmin.jsp')">
          <option value="A1" <% if (MODEL!=null && (MODEL=="A1" || MODEL.equals("A1")) || (model=="A1" || model.equals("A1")) ) { out.println("SELECTED"); } %>>A1 人員管理 </option>
          <option value="B1" <% if (MODEL!=null && (MODEL=="B1" || MODEL.equals("B1")) || (model=="B1" || model.equals("B1")) ) { out.println("SELECTED"); } %>>B1 報表查詢 </option>
          <option value="C1" <% if (MODEL!=null && (MODEL=="C1" || MODEL.equals("C1")) || (model=="C1" || model.equals("C1"))) { out.println("SELECTED"); } %>>C1 資料維護與管理 </option>
          <option value="D1" <% if (MODEL!=null && (MODEL=="D1" || MODEL.equals("D1")) || (model=="D1" || model.equals("D1")) ) { out.println("SELECTED"); } %>>D1 SALES FORECAST </option>
          <option value="E1" <% if (MODEL!=null && (MODEL=="E1" || MODEL.equals("E1")) || (model=="E1" || model.equals("E1")) ) { out.println("SELECTED"); } %>>E1 出貨管理 </option>
          <option value="F1" <% if (MODEL!=null && (MODEL=="F1" || MODEL.equals("F1")) || (model=="F1" || model.equals("F1")) ) { out.println("SELECTED"); } %>>F1 LC維護管理 </option>
          <option value="G1" <% if (MODEL!=null && (MODEL=="G1" || MODEL.equals("G1")) || (model=="G1" || model.equals("G1")) ) { out.println("SELECTED"); } %>>G1 產品發展平台資料查詢 </option>
          <option value="H1" <% if (MODEL!=null && (MODEL=="H1" || MODEL.equals("H1")) || (model=="H1" || model.equals("H1")) ) { out.println("SELECTED"); } %>>H1 產品資訊 </option>
          <option value="J1" <% if (MODEL!=null && (MODEL=="J1" || MODEL.equals("J1")) || (model=="J1" || model.equals("J1")) ) { out.println("SELECTED"); } %>>J1 業務員管理 </option>
          <option value="K1" <% if (MODEL!=null && (MODEL=="K1" || MODEL.equals("K1")) || (model=="K1" || model.equals("K1")) ) { out.println("SELECTED"); } %>>K1 RD倉管理 </option>
        </select>--%>
		 <select name="MODEL" onChange="setSubmit('../jsp/ProgrammerEditAdmin.jsp')">
          <option value="A1" <% if (MODEL!=null && (MODEL=="A1" || MODEL.equals("A1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="A1" || model.equals("A1"))) { out.println("SELECTED"); }%>>A1 人員管理 </option>
          <option value="B1" <% if (MODEL!=null && (MODEL=="B1" || MODEL.equals("B1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="B1" || model.equals("B1"))) { out.println("SELECTED"); }%>>B1 報表查詢 </option>
          <option value="C1" <% if (MODEL!=null && (MODEL=="C1" || MODEL.equals("C1")) ) { out.println("SELECTED"); }   else if(MODEL==null  &&  (model=="C1" || model.equals("C1"))) { out.println("SELECTED"); }%> >C1 資料維護與管理 </option>
          <option value="D1" <% if (MODEL!=null && (MODEL=="D1" || MODEL.equals("D1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="D1" || model.equals("D1"))) { out.println("SELECTED"); }%>>D1 SALES FORECAST </option>
          <option value="E1" <% if (MODEL!=null && (MODEL=="E1" || MODEL.equals("E1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="E1" || model.equals("E1"))) { out.println("SELECTED"); }%>>E1 出貨管理 </option>
          <option value="F1" <% if (MODEL!=null && (MODEL=="F1" || MODEL.equals("F1")) ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="F1" || model.equals("F1"))) { out.println("SELECTED"); }%>>F1 LC維護管理 </option>
          <option value="G1" <% if (MODEL!=null && (MODEL=="G1" || MODEL.equals("G1"))  ) { out.println("SELECTED");} else if(MODEL==null  &&  (model=="G1" || model.equals("G1"))) { out.println("SELECTED"); } %>>G1 產品發展平台資料查詢 </option>
          <option value="H1" <% if (MODEL!=null && (MODEL=="H1" || MODEL.equals("H1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="H1" || model.equals("H1"))) { out.println("SELECTED"); }%>>H1 產品資訊 </option>
          <option value="J1" <% if (MODEL!=null && (MODEL=="J1" || MODEL.equals("J1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="J1" || model.equals("J1"))) { out.println("SELECTED"); }%> >J1 業務員管理 </option>
          <option value="K1" <% if (MODEL!=null && (MODEL=="K1" || MODEL.equals("K1")) ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="K1" || model.equals("K1"))) { out.println("SELECTED"); }%>>K1 RD倉管理 </option>
        </select>
        <br>
          網址: <%= ADDRESS%>
          <br>
        檔案說明:
        <input type="text" name="PROGRAMMERNAME" value="<%= programmername%>" size="30" maxlength="40">
        
        <br>
        排序:<font color="#0000FF" size="1" face="Arial, Helvetica, sans-serif">&nbsp; 
        </font> 
		<%
			   try
			   {
			    if (MODEL!=null || !MODEL.equals(null))    
			    { 			 
			        Statement stmt=con.createStatement();    
				    ResultSet rssno=null;   
					 rssno=stmt.executeQuery("select max(LINENO) as LINENO from WSPROGRAMMER  where MODEL='"+MODEL+"' order by LINENO");   
					 if (rssno.next())   
					   {    
					    maxno=rssno.getInt("LINENO")+1; 
					   	}   
						stmt.close();  
					    rssno.close(); 
					} 
					}				    
			      catch (Exception e)
                 { if(e.getMessage()==null)
                    {out.println("&nbsp;");}
					else
					{out.println("Exception:"+e.getMessage());}
                  }   
				
				%>
        <input type="text" name="LINENO" value="<% if(MODEL==null ){out.println(lineno); } else {out.println(maxno);} %>" size="3" maxlength="3">
        <br>
        <font color="#CC0000" size="2">目前已有的序號：</font><font color="#0000FF" size="1" face="Arial, Helvetica, sans-serif">
        <%
 try
  {
  
   
   Statement stmt=con.createStatement(); 
   String sSql=""; 
   if (MODEL==null) 
   {sSql="select distinct LINENO as LINENO from WSPROGRAMMER  where MODEL='"+model+"' order by LINENO"; }
   else
   { sSql="select distinct LINENO as LINENO from WSPROGRAMMER  where MODEL='"+MODEL+"' order by LINENO"; }
   ResultSet rssno=stmt.executeQuery(sSql); 
   //out.println(sSql); 
   while (rssno.next())  
   {//maxno=rs.getInt(1);
    if(rssno.getString("LINENO")!=null )
    {out.println(rssno.getString("LINENO")); }
	}
   stmt.close();
   rssno.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
        </font> <font color="#0000FF" size="1" face="Arial, Helvetica, sans-serif">&nbsp; 
        </font> </td>
    </tr>
    <tr>
      <td><input type="submit" name="Sure" value="確定"> </td>
    </tr>
  </table>
 <input name="ADDRESS" type="hidden" value="<%=ADDRESS%>">
  <br>
</form>
<HR>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
<script language="JavaScript">   
function setSubmit(URL)
{    
 document.signform.action=URL;
 document.signform.submit();
}
</script>