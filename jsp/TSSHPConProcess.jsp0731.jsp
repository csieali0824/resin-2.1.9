<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>


<html>
<head>
<title>Call RCV API Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSHPConProcess.jsp" METHOD="post" NAME="MYFORM">
<%
String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
String actionID=request.getParameter("ACTIONID");
String tsInvoiceNo=request.getParameter("TSINVOICENO");
String createBy = request.getParameter("CREATE_BY");
String poHeaderId = request.getParameter("POHEADERID");
String poLineId = request.getParameter("POLINEID");
String poLocationLineId = request.getParameter("POLOCATIONLINEID");
String shipDate = request.getParameter("SHIPDATE");
String systemDate = request.getParameter("SYSTEMDATE");
String rcvQty   = request.getParameter("RCVQTY");  
String employeeId   = request.getParameter("EMPLOYEE_ID");  
//String userName   = request.getParameter("USERNAME"); 
String periodStatus   = request.getParameter("PERIOD_STATUS");
int headerID   = 0;  
int requestID  = 0;
String errorMessageHeader ="";
String errorMessageLine ="";
String statusMessageHeader ="";
String statusMessageLine ="";
String processStatus="";
String countRate = request.getParameter("COUNTRATE");   //判斷出貨日的幣別轉換匯率是否存在


		
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }

// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
	   // 為存入日期格式為US考量,將語系先設為美國
	   String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
	   //完成存檔後回復


      //抓取系統日期
  
    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
	if (sd.next())
	 {
	   systemDate=sd.getString("SYSTEMDATE");	 
	  }
	sd.close();
    statesd.close();	


java.sql.Date shippingDate = null; //將SHIPDATE轉換成日期格式以符丟入API格式
 if (shipDate!=null && shipDate.length()>=8)
 {
   shippingDate = new java.sql.Date(Integer.parseInt(shipDate.substring(0,4))-1900,Integer.parseInt(shipDate.substring(4,6))-1,Integer.parseInt(shipDate.substring(6,8)));  // 給Shipping Date
 }   
//java.sql.Date shipDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
%>
<A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>&nbsp;&nbsp; 
<A href="/oradds/jsp/TSSHPInvoiceQuery.jsp"><jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgQuery"/></A>&nbsp;&nbsp;
<A href="/oradds/jsp/TSSHPShipConfirm.jsp"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgConfirm"/></A>
<BR><HR>
<%
  try
  {
  
  if( shipDate !=null )  //檢查shipdate是否為open的GL PERIOD
  {
    String sql=" select UPPER(STATUS) as PERIOD_STATUS from APPS.ORG_ACCT_PERIODS_V "+
               " where ORGANIZATION_ID="+organizationId+" and PERIOD_NAME = TO_CHAR(TO_DATE("+shipDate+",'YYYYMMDD'),'MON-YY') ";
  
    Statement statest=con.createStatement();
	ResultSet st=statest.executeQuery(sql);
	//out.println("sql"+sql);
	if (st.next())
	 {
	   periodStatus=st.getString("PERIOD_STATUS");	 
	  }
	//out.print("shipDate"+shipDate+"periodStatus="+periodStatus+"<br>");
	st.close();
    statest.close();	
   }// end if( shipDate !=null ) 

if (tsInvoiceNo!=null)
{
	     //判斷此shipdate的幣別?率是否存在
         String sqlcurr="  select COUNT(A.FROM_CURRENCY) as COUNTRATE from  APPS.GL_DAILY_RATES_V A   "+
  						"    where A.FROM_CURRENCY in ('USD','EUR') and A.USER_CONVERSION_TYPE='TSC-Export'  "+
      					"      and A.CONVERSION_DATE = TO_DATE('"+shipDate+"','YYYY/MM/DD') ";
         Statement statefndsc=con.createStatement();
         ResultSet rsfndsc=statefndsc.executeQuery(sqlcurr);
		 if (rsfndsc.next())
		   { countRate     = rsfndsc.getString("COUNTRATE");  }
		  rsfndsc.close();
          statefndsc.close();	
         // out.println("countRate"+countRate);
}

  } //end of try
  catch (Exception e)
      {
         out.println("Exception:"+e.getMessage());
      }    
	 
 try
 {
   if (periodStatus==null || periodStatus=="" || periodStatus.equals("") ) 
   { out.print("<font color='#0000cc'><strong>ShipDate="+shipDate+" the Period is Future!!<br>Can not ship confirm!!</font></strong>"); 
     }
   else if (periodStatus=="CLOSED" || periodStatus.equals("CLOSED"))
   { out.print("<font color='#0000cc'><strong>ShipDate="+shipDate+" the Period has been Closed!!<br>Can not ship confirm!!</font></strong>");}

  // else if (shipDate > systemDate )
   else if ( Integer.parseInt(shipDate) > Integer.parseInt(systemDate) )
   { out.print("<font color='#0000cc'><strong>ShipDate over Today!! </font></strong>");}

   else if ( countRate=="0" || countRate.equals("0") )
   { out.print("<font color='#0000cc'><strong>ShipDate= "+shipDate+"<br>  Missing Currency Rate,Please Contact Finance Create!! </font></strong>");}
  
   else if (periodStatus=="OPEN" || periodStatus.equals("OPEN"))
   {
              Statement statement=con.createStatement();
			  String sql1a=  " select B.SALESORDERNO||'-'|| B.LINE_NO as SELECTFLAG, A.TSINVOICENO,B.RCVQTY ,A.CREATE_BY,B.PO_HEADER_ID,B.PO_LINE_ID,B.PO_LOCATION_LINE_ID,A.EMPLOYEE_ID,B.ORGANIZATION_ID  "+
                            " from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B  "+
                            " where  A.TSINVOICENO=B.TSINVOICENO   and NVL(A.STATUS,'OPEN') != 'CLOSED'  and NVL(A.PRINTED_FLAG,'N') = 'Y'  and NVL(b.line_STATUS,'OPEN') != 'CLOSED' "+  
                            "         and A.TSINVOICENO = upper('"+tsInvoiceNo+"')" ; 
              ResultSet rs=statement.executeQuery(sql1a);  
			  //out.println("sql1a="+sql1a);
              while (rs.next())
              {  // out.println("Step2="+"<BR>");
			    
                 CallableStatement cs3 = con.prepareCall("{call TSC_RCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
				 //cs3.setInt(1,Integer.parseInt(tsInvoiceNo));  //發票號碼
				 cs3.setString(1,tsInvoiceNo.toUpperCase());  //發票號碼
				 cs3.setDate(2,shippingDate);                     //收料日期
				 cs3.setInt(3,Integer.parseInt(rs.getString("CREATE_BY")));     
				 cs3.setInt(4,Integer.parseInt(rs.getString("PO_HEADER_ID")));  
				 cs3.setInt(5,Integer.parseInt(rs.getString("PO_LINE_ID")));  
				 cs3.setFloat(6,Float.parseFloat(rs.getString("RCVQTY")));  
	             cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
				 cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
				 cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
				 cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
				 cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
				 cs3.setInt(12,Integer.parseInt(rs.getString("PO_LOCATION_LINE_ID")));   //PO_LOCATION_LINE_ID
				 cs3.setInt(13,Integer.parseInt(rs.getString("EMPLOYEE_ID")));   //EMPLOYEE_ID
			     cs3.setInt(14,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   //ORGANIZATION_ID
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
				 statusMessageHeader = cs3.getString(7);	             
				 statusMessageLine = cs3.getString(8);
				 headerID = cs3.getInt(9);   // 把第二次的更新 Header ID 取到
				 errorMessageHeader = cs3.getString(10);	             
				 errorMessageLine = cs3.getString(11);
                 cs3.close();			
				 	  
	             if (errorMessageHeader==null ) 
				 { errorMessageHeader = "&nbsp;";}				
				 if (errorMessageLine==null ) 
				 { errorMessageLine = "&nbsp;";}		
				// out.println("Step2="+"<BR>");   
 %>
 			   <input type="text" size="15" name="TSINVOICENO" value="<%=tsInvoiceNo%>" readonly>
			   <input type="text" size="15" name="SHIPDATE" value="<%=shipDate%>" readonly>
			   <input type="text" size="15" name="CREATEBY" value="<%=createBy%>" readonly>
			   <input type="text" size="15" name="POHEADERID" value="<%=rs.getInt("PO_HEADER_ID")%>" readonly>
			   <input type="text" size="15" name="POLINEID" value="<%=rs.getInt("PO_LINE_ID")%>" readonly>
			   <input type="text" size="15" name="POLOCATIONLINEID" value="<%=rs.getInt("PO_LOCATION_LINE_ID")%>" readonly>
			   <input type="text" size="15" name="EMPLOYEEID" value="<%=rs.getInt("EMPLOYEE_ID")%>" readonly>
			   <input type="text" size="15" name="ORGANIZATIONID" value="<%=rs.getInt("ORGANIZATION_ID")%>" readonly>
			   <input type="text" size="15" name="RCVQTY" value="<%=rs.getInt("RCVQTY")%>" readonly>  
			   <input type="text" size="15" name="ERRORH" value="<%=errorMessageHeader%>" readonly> 	
			   <input type="text" size="15" name="ERRORL" value="<%=errorMessageLine%>" readonly> <BR>			      
			   
 <%            
				} // End of while ()
  
			  rs.close();
              statement.close();


%> <table bgcolor='#FFFFCC'><font color='#000099'>
					 <TR><TD colspan=2> <font color='#000099'>Process Status </font></TD><TD colspan=4><%=statusMessageHeader+statusMessageLine%></TD></TR>
					 <TR><TD><font color='#000099'> Invoice No= </font></TD><TD colspan=3><%=tsInvoiceNo%> </TD> <TD> Po_Line_ID </TD><TD> <%=headerID%></TD></TR></FONT> 
    </table>
<%					  
					  if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
					  {
					    
					     errorMessageHeader = "&nbsp;"; 
						 errorMessageLine = "&nbsp;"; 
					     // 依成功內容作資料檔之更新 STATUS='CLOSED' 
				        String sql1=" update APPS.TSC_DROPSHIP_SHIP_HEADER "+
                                    " set STATUS='CLOSED',CONFIRM_DATE=SYSDATE,SHIPDATE="+shipDate+",CONFIRM_BY ='"+UserName+"' "+
                                    " where TSINVOICENO= upper('"+tsInvoiceNo+"') and STATUS !='CLOSED' AND NVL(PRINTED_FLAG,'N') ='Y'  ";
				        String sql2=" update APPS.TSC_DROPSHIP_SHIP_LINE  set LINE_STATUS='CLOSED' "+
                                    " where TSINVOICENO= upper('"+tsInvoiceNo+"') and LINE_STATUS !='CLOSED' ";								   
                         PreparedStatement pstmt=con.prepareStatement(sql1);
                         pstmt.executeUpdate(); 
                         pstmt.close();						 
                         PreparedStatement pstmt2=con.prepareStatement(sql2);
                         pstmt2.executeUpdate(); 
                         pstmt2.close();
						 

						//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor
						 String sqlfnd = " select USER_ID   from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 									     " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
						 Statement stateFndId=con.createStatement();
                         ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 //out.println("sqlfnd="+sqlfnd);
		                 if (rsFndId.next())
		                    {
		                      						
						       // run "Receiving Transaction Processor"
						       CallableStatement cs4 = con.prepareCall("{call TSC_CALL_RCV_REQUEST_JSP(?,?)}");			 
			  	               cs4.setInt(1,Integer.parseInt(rsFndId.getString("USER_ID")));       //USER REQUEST 
				               cs4.registerOutParameter(2, Types.VARCHAR);                  //回傳 REQUEST_ID
						       cs4.execute();
               	   		       requestID = cs4.getInt(2);   //  回傳 REQUEST_ID
				               cs4.close();			
						       out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");
							   rsFndId.close();
                               stateFndId.close();
						       //out.println("sqlfnd="+sqlfnd);	
						     }  //end if (rsFndId.next()) 
					  }
							 
					  else {  
					        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Invoice No Success!! </FONT></TD><TD colspan=3>"+tsInvoiceNo+"</TD></TR>");
					        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
					       }								     


     }//end if (periodStatus=="OPEN" || periodStatus.equals("OPEN"))
	
	 
 } //end of try 
	 


catch (Exception e)
{
	e.printStackTrace();
   out.println(e.getMessage());
}



%>
<input type="hidden" size="5" name="SYSTEMDATE" value="<%=systemDate%>">
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
