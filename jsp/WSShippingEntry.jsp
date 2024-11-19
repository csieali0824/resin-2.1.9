<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<%  
  arrayListCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作  
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipping Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Shipping Entry </strong></font>
<FORM ACTION="WSShippingInputEntry.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>  
<% 
   String wareHouse = request.getParameter("WAREHOUSE");
   String custOrder = request.getParameter("CORDER");
   //String model = request.getParameter("MODEL");
   String custNo = request.getParameter("CUSTNO"); 
   String custName = request.getParameter("CUSTNAME");
   String custAddress = request.getParameter("CUSTADDRESS");
   String ordQty = request.getParameter("ORDERQTY");
   String shpQty = request.getParameter("SHIPQTY");

 
   String CenterNo="";
   String locale ="";   
   
   if (custName==null) { custName = "";}
   if (custAddress==null) { custAddress = "";}
   
   
	String sql = "select ACTCENTERNO, ACTLOCALE from WSSHIPPER where (USERNAME='"+UserName+"' or ACTUSERID='"+UserName+"') ";	
	//out.println(sql);
	Statement stateShip=con.createStatement();
	ResultSet rsShip=stateShip.executeQuery(sql);
	if (rsShip.next()) { 
	   CenterNo = rsShip.getString("ACTCENTERNO"); 
	   locale = rsShip.getString("ACTLOCALE"); 
	} else {
	   out.println("You have no authority !!");
	   out.println(UserName);
	}
	rsShip.close();
	stateShip.close();
/*	
	String sqlU = "select WEBID from WSUSER where USERNAME = '"+UserName+"' ";	
	Statement stateU=con.createStatement();
	ResultSet rsU=stateU.executeQuery(sqlU);
	if (rsU.next())
	{ 
	  UserID = rsU.getString("WEBID"); 
	}
	rsU.close();
	stateU.close();     
*/
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="23%" bordercolor="#FFFFFF" nowrap><font color="#330099" face="Arial Black"><strong>Warehouse :</strong></font>			
		<% 	 		 
	       try
           {   
		     String sSql = "";
   		     String sWhere = "";
		  
		     sSql = "select blwhs as x,blwhs from wsshp_center,wsshipper where centerno=actcenterno and  username= '"+UserName+"' ";		  
		     sWhere = " order by x";		 
		     sSql = sSql+sWhere;		  
		  		      
		     Statement statement=con.createStatement();
             ResultSet rs=statement.executeQuery(sSql);
		  
		     out.println("<select NAME='WAREHOUSE' onChange='setSubmit("+'"'+"../jsp/WSShippingEntry.jsp"+'"'+")'>");
             out.println("<OPTION VALUE=-->--");     
             while (rs.next())
             {            
              String s1=(String)rs.getString(1); 
              String s2=(String)rs.getString(2); 
                        
              if (s1.equals(wareHouse)) 
              {
                out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
              }   
			  else 
			  {
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
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
	</td>       
      <td width="20%" nowrap><font color="#333399" face="Arial Black"><strong>CO :</strong></font> 	  
        <% 			 		 
	       try
           {   
		    String sSql = "";
		    String sWhere = "";

		    sSql = "select DISTINCT LORD as x, LORD from ECL, IIM ";		   
		    //sWhere = " where IPROD = LPROD and IITYP ='F' and (LQORD-LQSHP)>0 and LWHS ='"+wareHouse+"' and LID = 'CL' order by x ";	
		    sWhere = " where IPROD = LPROD and IITYP ='F' and LWHS ='"+wareHouse+"' order by x desc";				
		    sSql = sSql+sWhere;		  
		  		      
            Statement statement=bpcscon.createStatement();
            ResultSet rs=statement.executeQuery(sSql);
		  
		    out.println("<select NAME='CORDER' onChange='setSubmit("+'"'+"../jsp/WSShippingEntry.jsp"+'"'+")'>");
            out.println("<OPTION VALUE=-->--");     
            while (rs.next())
            {            
             String s1=(String)rs.getString(1); 
             String s2=(String)rs.getString(2); 
                        
            if (s1.equals(custOrder)) 
             {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
             } 
			 else 
			 {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
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
        <!--input name="CUSTNO" type="hidden" value="<%=custNo%>"--> 
	  </td>
      <!--td colspan="2" nowrap> <font color="#333399" face="Arial Black"><strong>MODEL : </strong></font> 
        <% 				 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  if (custOrder==null || custOrder.equals("--"))
		  { }
		  else
		  { 
		  	/*	  
		    sSql = "select distinct trim(x.LPROD), trim(x.LPROD)||'('|| trim(IDESC)||trim(IDSCE)||')' as DESCRIPTION from ECL x, IIM y";			  
		    sWhere = " where x.LORD IN("+custOrder+") and x.LPROD=y.IPROD and x.LPROD IS NOT NULL "+
		             " order by 1 ";		              
		    sSql = sSql+sWhere;
			     
            Statement statement=bpcscon.createStatement();
            ResultSet rs=statement.executeQuery(sSql);
            comboBoxBean.setRs(rs);		  		 
		    
			if (model!=null) comboBoxBean.setSelection(model);
	        comboBoxBean.setFieldName("MODEL");	   
            out.println(comboBoxBean.getRsString());		
			*/
			Statement statement=bpcscon.createStatement();
			String sSqlC = "select LCUST from ECL ";
		    String sWhereC = " where LORD IN("+custOrder+") ";
			sSqlC = sSqlC + sWhereC;
			ResultSet rsC=statement.executeQuery(sSqlC);
			if (rsC.next())
			{ custNo = rsC.getString("LCUST"); }
			
			rsC.close();		
			 
            //rs.close();    
		    statement.close();  
	      }  // end of else 
         } //end of try

         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
	   <%
	     try
         {  
		  if (custNo==null || custNo.equals(""))
		  { }
		  else
		  {
		   String sSql = "";
		   String sWhere = "";
		   sSql = "select CNME, CAD1||CAD2||CAD3 as CADDRESS from rcm  ";		  
		   sWhere = " where ccust in("+custNo+") ";	
		   sSql = sSql+sWhere;		  
		  		      
           Statement statement=bpcscon.createStatement();
           ResultSet rs=statement.executeQuery(sSql);
		   if (rs.next())
		   {
		    custName = rs.getString("CNME");	  
		    custAddress = rs.getString("CADDRESS");		   
		   }
		   else
		   {
		    custName = "";
			custAddress = "";
		   }
		   rs.close();
		   statement.close();
		  } // End of Else
		 }

		 catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }     
	   %>  
</td-->  	   
	  <td width="8%" colspan="1"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSShippingInputEntry.jsp")'>
</td> 
	</tr>	
	<tr bgcolor="#D0FFFF">
	    <td colspan="5" nowrap><font color="#330099" face="Arial Black"><strong>Customer Name :</strong></font>
		  <%
		    if (custName==null || custName.equals(""))
		      { out.println("");}
		    else
		      { out.println(custName);}
		  %>	 
		</td>
	</tr>
    <tr bgcolor="#D0FFFF"> 	   
      <td colspan="5" nowrap><font color="#330099" face="Arial Black"><strong>Customer Address :</strong></font>
	    <%
		   if (custAddress==null || custAddress.equals(""))
		     { out.println("");}
		   else
		     { out.println(custAddress);} 
	    %>
       <input name="CUSTNAME" type="hidden" value="<%=custName%>">
	   <input name="CUSTNO" type="hidden" value="<%=custNo%>">
	   <input name="CUSTADDRESS" type="hidden" value="<%=custAddress%>">	
       <input type="hidden" name="CENTERNO" value=<%=CenterNo%> size="3" maxlength="3" >	   
       <input type="hidden" name="LOCALE" value=<%=locale%> size="3" maxlength="3" >	        
      </td>	 
    </tr>
	<tr bgcolor="#D0FFFF"> 	   
       	 
    </tr>
</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
