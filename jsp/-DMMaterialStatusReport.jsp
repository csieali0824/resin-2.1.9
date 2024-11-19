<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理完成開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Material Status Report</title>
</head>

<body>
<p> 
  <% 
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO");

		if ( sModelNo==null || sModelNo.equals("") ) 
		{ sModelNo = "unknow model"; //out.println("未傳入MODELNO");
		}
		
	%>
  <font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font> 
  <font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> Material Status </strong></font> 
<table border="1">
  <tr bgcolor="#0072A8"> 
    <td width="103" ><font color="#FFFF00" size="2" face="Arial, Helvetica, sans-serif">更新日期</font></td>
    <td width="110" > <div align="center"> <font color="#FFFF00" size="2" face="Arial, Helvetica, sans-serif"> 
        <%
 
		     String sDate ="";
     	     String sD="";
			 String sMM="";
			
			 
		     if (sModelNo !=null && !sModelNo.equals("") )
		     {
		   
		       String sSqlDate = "SELECT MAX(MCDATE) AS MCDATE FROM MATECTL WHERE MCMODELNO='"+sModelNo+"' ";
			   //out.println(sSqlDate);
			   
			  
			   Statement stateDate=dmcon.createStatement();
			   ResultSet rsDate=stateDate.executeQuery(sSqlDate);
			   
			   if(rsDate.next()) 
				{ 
					sDate=rsDate.getString("MCDATE");
					if ( sDate !=null && !sDate.equals("") ) 
					{
						 sD = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8);
						 sMM = sDate.substring(4,6);
					}
					else { sD = "沒有記錄"; }
				}
				rsDate.close();
				stateDate.close();
				
				out.println(sD);
			} // end if
	
	%>
        </font></div></td>
    <%
	 
	       try
		    {
			
			  int iTotal = 0;
		      int iTillShip =  0;
		      int iMonthShip = 0;
		      int iSample = 0;
		      int iStock = 0;
		      int iNetQty = 0;
		      int iWip = 0;
		      int iWhileSetQty = 0;
		      int iPWhileSetQty = 0;
			  int iNWhileSetQty = 0;
			  DecimalFormat df=new DecimalFormat(",000");
					   
		      if (sModelNo !=null && !sModelNo.equals("") && sDate !=null && !sDate.equals(""))
                 { 
			       String sSql = "SELECT MCPURKIT AS TOTAL, MCSHIPEND AS TILLSHIP,MCSHIP AS MONTHSHIP,"+
		           "MCISSUE AS SAMPLE,MCSTOCK AS  STOCK,MCREMKIT AS NETQTY ,MCWIPKIT AS WIP,"+
			       "MCKIT1 AS  WHILESETQTY,MCKIT2 AS PWHILESETQTY,MCKIT3 AS NWHILESETQTY FROM MATECTL"+
			       " WHERE MCDATE='"+sDate+"' AND MCMODELNO='"+sModelNo+"' ";
				   //out.println(sSql);
			       Statement  stateSql = dmcon.createStatement();
				   ResultSet rsSql=stateSql.executeQuery(sSql);
		           boolean rsSql_isEmpty = !rsSql.next();		
			       boolean rsSql_hasData = !rsSql_isEmpty;
				   while (rsSql_hasData)
				   { 
  				        iTotal = rsSql.getInt("TOTAL");
			            iTillShip = rsSql.getInt("TILLSHIP");
			            iMonthShip = rsSql.getInt("MONTHSHIP");
			            iSample = rsSql.getInt("SAMPLE");
			            iStock = rsSql.getInt("STOCK");
                        iNetQty = rsSql.getInt("NETQTY");
			            iWip = rsSql.getInt("WIP");
			            iWhileSetQty= rsSql.getInt("WHILESETQTY");
			            iPWhileSetQty = rsSql.getInt("PWHILESETQTY");
			            iNWhileSetQty = rsSql.getInt("NWHILESETQTY");

%>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">Total 購料數</font></td>
    <td> <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
	     if (iTotal!=0)
		     { 
			   if(iTotal >=1000 || iTotal <=-1000)
			   {out.println(df.format(iTotal)); }
			   else 
			    {out.println(iTotal); }			   
			 }
	         else {out.println(0); } 
		   %>
        </font> </div>
      <font face="Arial, Helvetica, sans-serif"><div align="right">
    </td>
  </tr>
  <tr> 
    <td> <font size="2" face="Arial, Helvetica, sans-serif"> 
      <%
	          if (sMM !=null || !sMM.equals(""))
		        {out.println("未含"+sMM+"月累計出貨數");}
		      else 
			    {out.println("未含當月累計出貨數"); }
	       %>
      </font></td>
    <td><font face="Arial, Helvetica, sans-serif"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
      <div align="right"><font face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iTillShip!=0)
		   {
		     if(iTillShip >=1000 || iTillShip<=-1000)
			  {out.println(df.format(iTillShip)); }
			 else 
			   {out.println(iTillShip); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">樣品需求</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iSample!=0)
		   {
		     if(iSample >=1000 || iSample <=-1000)
			  {out.println(df.format(iSample)); }
			 else 
			   {out.println(iSample); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td> <font size="2" face="Arial, Helvetica, sans-serif"> 
      <%
	   	 if (sMM!=null || !sMM.equals(""))
			  {out.println(sMM+"月出貨數");}
	    else 
			  {out.println("當月出貨數"); }

	  %>
      </font>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iMonthShip!=0)
		   {
		     if(iMonthShip >=1000 || iMonthShip <=-1000)
			  {out.println(df.format(iMonthShip)); }
			 else 
			   {out.println(iMonthShip); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成品 Inventory</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iStock!=0)
		   {
		     if(iStock >=1000 || iStock <=-1000)
			  {out.println(df.format(iStock)); }
			 else 
			   {out.println(iStock); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">WIP</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iWip!=0)
		   {
		     if(iWip >=1000 || iWip <=-1000)
			  {out.println(df.format(iWip)); }
			 else 
			   {out.println(iWip); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成套材料數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iWhileSetQty!=0)
		   {
		     if(iWhileSetQty >=1000 || iWhileSetQty <=-1000)
			  {out.println(df.format(iWhileSetQty)); }
			 else 
			   {out.println(iWhileSetQty); }
			}  
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成套材料數 (80%)</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
    	 if (iPWhileSetQty!=0)
		   {
		     if(iPWhileSetQty >=1000 || iPWhileSetQty <=-1000)
			  {out.println(df.format(iPWhileSetQty)); }
			 else 
			   {out.println(iPWhileSetQty); }
	   	   }   
          else {out.println(0); } 
	 %>
        </font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">不成套材料數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <%
	    if (iNWhileSetQty!=0)
		   {
		    if(iNWhileSetQty >=1000 || iNWhileSetQty <=-1000)
			  {out.println(df.format(iNWhileSetQty)); }
			 else 
			   {out.println(iNWhileSetQty); }
			}  
       else {out.println(0); } 
     %>
        </font></div></td>
  </tr>
  <%
  
                    rsSql_isEmpty = !rsSql.next();
					rsSql_hasData = !rsSql_isEmpty;
			
  				} // end of while
			
				rsSql.close();
				stateSql.close();
				
		   } // end of if
		
		} // end of try
		catch (Exception e)
		{ out.println("Exception:"+e.getMessage()); }
	
   %>
</table>

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>