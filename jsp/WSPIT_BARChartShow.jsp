<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,RsBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSPIT </title>
</head>
<body>
<FORM ACTION="WSPIT_BARChartShow.jsp" METHOD="post" NAME="MYFORM" >
  <table width="100%" border="0">
    <tr> 
      <td height="26" align="center" colspan=6><div align="left"><strong><font color="#0000FF" face="Arial"><A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
          </font><font color="#0000FF" size="+2" face="Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font color="#0000FF" size="+2" face="Arial">&nbsp; 
          &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;產品問題不良比率統計圖</font><font color="#0000FF" face="Arial">&nbsp;&nbsp; 
          &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;</font></strong></div></td>
    </tr>

<tr>
<td width="20%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="3"><strong><font color="#FF0000">*</font>PRODUCT:</strong></font>
      <%      
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs=null,subRs=null;	 
  String product=request.getParameter("PRODUCT"); 
  if (product==null){product="";}
  String model=request.getParameter("MODEL"); 
  String object1=request.getParameter("OBJECT"); 
  String version=request.getParameter("VERSION"); 
	  try
      {     	         
	      String sql="select unique PRODUCT a,PRODUCT b from PIT_MASTER";
		  sql=sql+" order by a";		  
          rs=statement.executeQuery(sql);			  	 	    			
	      comboBoxBean.setRs(rs);	  
		  comboBoxBean.setFontSize(9); 
		  comboBoxBean.setSelection(product);	 
		  comboBoxBean.setOnChangeJS(""); 
	      comboBoxBean.setFieldName("PRODUCT");	   
          out.println(comboBoxBean.getRsString());	      	           
		  rs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>      
	   </td>
      <td width="17%" height="45" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black" size="3"><strong>MODEL:</strong></font> 
          <% 		 		 		 
	     try
         {   
		    String sql="select unique MODEL a,MODEL b from PIT_MASTER";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(model);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("MODEL");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </td>
      <td width="21%"><font color="#330099" face="Arial Black" size="2"><strong></strong></font><font color="#333399" face="Arial Black" size="3"><strong>OBJECT</strong></font>: 
        <% 		 		 		 
	     try
         {   
		    String sql="select unique p.T_OBJECT as b, o.NAME as a from PIT_MASTER p,PIT_OBJECT o"+
			           " where p.T_OBJECT=o.OBJECTID";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(object1);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("OBJECT");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	     		                   		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>      </td>
      <td colspan=2><font color="#333399" face="Arial Black" size="3"><strong>VERSION:</strong></font> 
          <% 		 		 		 
	     try
         {   
		    String sql="select unique T_VERSION a,T_VERSION b from PIT_MASTER";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(version);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("VERSION");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td width="18%"><input name="submit1" type="submit" value="Query" onClick='return setSubmit()'></td>
	  </tr>
  </table>
<hr>
  <%   try
   {
  //===============先取得總數
   //Statement statement=statement=con.createStatement();
   if (!product.equals("--") && product!=null && !product.equals(""))
   {
       String sWhere = "PRODUCT='"+product+"'";
     	if (version!=null && !version.equals("--")) sWhere=sWhere+" and T_VERSION='"+version+"'";
	    if (model!=null && !model.equals("--")) sWhere=sWhere+" and MODEL='"+model+"'";
	    if (object1!=null && !object1.equals("--")) sWhere=sWhere+" and T_OBJECT='"+object1+"'";
   		String rsSql="select unique t_version  from pit_master WHERE "+ sWhere+" order by t_version desc" ;
    	rs=statement.executeQuery(rsSql);
   		String Version="";
  		while (rs.next())
   		{
     		Version=rs.getString("t_version");
    		 out.println("<img src=WSPIT_BARChart.jsp?VERSION="+Version+"&PRODUCT="+product+"&MODEL="+model+"&OBJECT="+object1+">&nbsp;&nbsp;");
   		}   
   		rs.close();
   		statement.close();
	 }//end if
	 else
	 {
	 out.println("<STRONG><FONT COLOR=RED>請選擇 PRODUCT</FONT></STRONG>");
	 }
   	//===================================================   
    } // End of Try
  catch (Exception e)
  {  out.println("Exception:"+e.getMessage());   }   
%></br>
  </FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>