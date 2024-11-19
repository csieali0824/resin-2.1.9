<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<%@ include file="/jsp/include/ConnMESPoolPage.jsp/"%>
<!--%@ page import="DateBean,ForecastInputBean,WorkingDateBean" %-->
<%@ page import="DateBean,ArrayListCheckBoxBean"%>
<!--jsp:useBean id="forecastInputBean" scope="session" class="ForecastInputBean"/-->
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>新增IMEI內容</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Shipping Information </strong></font>
<br><br>
<%
String custOrder = request.getParameter("CORDER");
//String model = request.getParameter("MODEL");
String custNo = request.getParameter("CUSTNO"); 
String custName = request.getParameter("CUSTNAME");
String custAddress = request.getParameter("CUSTADDRESS");
String ordQty = request.getParameter("ORDERQTY");
//String userID=request.getParameter("USERID");
//String imei=request.getParameter("IMEI");
//String repCenterNo=request.getParameter("WSCENTERNO");
//String locale=request.getParameter("WSLOCALE");
//String carIMEI = request.getParameter("CARIMEI");	
//String model = request.getParameter("MODEL"); 

//String UserID=request.getParameter("USERID");	 
String CenterNo=request.getParameter("CENTERNO");
String locale=request.getParameter("LOCALE");

// 取文件新增日期時間 //
String strDateTime ="SH"+CenterNo+dateBean.getYearMonthDay();   

//String a[][]=forecastInputBean.getArray2DContent();//取得目前陣列內容
String a[][]=arrayListCheckBoxBean.getArray2DContent();//取得目前陣列內容

String shippNo="";
String shippNo1 = "00001";
String time = "";
String sTime = "";
String imei = "";
String carton = "";
String model = "";
int iSales = 0;
String sales = "";
String sales_name = "";
int aLength = 0;
String serial_number = "";
String version = "";
String HTable = "N";

try
{  
  //計算SHIPPNO
  String sqlS = "select trim(to_char(substr(max(SHIPPNO),14,5)+1,'00000')) SHIPPNO from WSSHIP_IMEI_T ";
  String sWhere = " where substr(SHIPPNO,1,13)='"+strDateTime+"' ";		 
  sqlS = sqlS+sWhere;	  
  Statement stateS=con.createStatement();
  ResultSet rsS=stateS.executeQuery(sqlS);
  if (rsS.next()==false)
  { 
    shippNo1 = "00001";
  }
  else
  { 
    shippNo1 = rsS.getString("SHIPPNO");				 
    if (shippNo1==null || shippNo1.equals(""))
	{
	  shippNo1 = "00001";
	}
  }  
  rsS.close();
  stateS.close();

  shippNo = strDateTime + shippNo1;  //取得新的shippNo

  String sql="";
  PreparedStatement pstmt=null;
  	   
sql="insert into WSSHIP_IMEI_T(IMEI,IN_DATETIME,IN_USER,IN_CENTERNO,IN_LOCALE,SHIPPNO,ERP_CONO,ERP_ITEMNO,ERP_DEST,ERP_CUSTNO,ERP_CUSTNAME,MES_CARTON_NO,SALES,SALES_NAME,VERSION,SHP_NOTES) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
pstmt=con.prepareStatement(sql);  

for (int i=0;i<a.length;i++) {
	String q_in_array=a[i][0];
	aLength = q_in_array.length();		  
	if (aLength==15) {
		String sqlIMEI = "select TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME,MCARTON_NO,MODEL_NAME from SFISM4.R_WIP_TRACKING_T where IMEI='"+q_in_array+"' ";
		Statement stateIMEI=conMES.createStatement();
		ResultSet rsIMEI=stateIMEI.executeQuery(sqlIMEI);
		if (rsIMEI.next()) { 
			time = rsIMEI.getString("IN_STATION_TIME");		
			carton = rsIMEI.getString("MCARTON_NO");		
			model = rsIMEI.getString("MODEL_NAME"); 
		}  else { //H Table
			String sqlIMEIH = "select TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME,MCARTON_NO,MODEL_NAME from SFISM4.H_WIP_TRACKING_T where IMEI='"+q_in_array+"' ";
			Statement stateIMEIH=conMES.createStatement();
			ResultSet rsIMEIH=stateIMEIH.executeQuery(sqlIMEIH);
			if (rsIMEIH.next()) {
			  time = rsIMEIH.getString("IN_STATION_TIME");		
			  carton = rsIMEIH.getString("MCARTON_NO");		
			  model = rsIMEIH.getString("MODEL_NAME");
			  HTable = "Y";		
			}
			rsIMEIH.close();
			stateIMEIH.close();
		} // end if
		rsIMEI.close();
		stateIMEI.close();
	  
		//get sales & sales name
		String sqlSAL = "select a.SSAL SALES,trim(a.SNAME) SALESNAME from SSM a,ECH b where a.SID = 'SM' AND A.ssal = b.HSAL and b.HORD = '"+custOrder+"' ";
		Statement stateSAL=bpcscon.createStatement();
		ResultSet rsSAL=stateSAL.executeQuery(sqlSAL);
		if (rsSAL.next()) { 	    
			sales = rsSAL.getString("SALES");	
			sales_name = rsSAL.getString("SALESNAME");		
		}  
		rsSAL.close();
		stateSAL.close();	  

		//get DSN
		if (HTable == "N") {
			String sqlDSN = "select SERIAL_NUMBER DSN from SFISM4.R_WIP_TRACKING_T where IMEI = '"+q_in_array+"' ";
			Statement stateDSN=conMES.createStatement();
			ResultSet rsDSN=stateDSN.executeQuery(sqlDSN);
			if (rsDSN.next()) { 	    
				serial_number = rsDSN.getString("DSN");	
			}  
			rsDSN.close();
			stateDSN.close();
		} else { //H Table
			String sqlDSN = "select SERIAL_NUMBER DSN from SFISM4.H_WIP_TRACKING_T where IMEI = '"+q_in_array+"' ";
			Statement stateDSN=conMES.createStatement();
			ResultSet rsDSN=stateDSN.executeQuery(sqlDSN);
			if (rsDSN.next()) { 	    
				serial_number = rsDSN.getString("DSN");	
			}  
			rsDSN.close();
			stateDSN.close();	  
		} // end if
			
	  //get version
		if (HTable == "N") {
			String sqlVER = "select VERSION VERSION from SFISM4.R_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+serial_number+"' ";
			Statement stateVER=conMES.createStatement();
			ResultSet rsVER=stateVER.executeQuery(sqlVER);
			if (rsVER.next()) { 	    
				version = rsVER.getString("VERSION");	
			}  
			rsVER.close();
			stateVER.close();	
		} else {
			String sqlVER = "select VERSION VERSION from SFISM4.H_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+serial_number+"' ";
			Statement stateVER=conMES.createStatement();
			ResultSet rsVER=stateVER.executeQuery(sqlVER);
			if (rsVER.next()) { 	    
				version = rsVER.getString("VERSION");	
			}  
			rsVER.close();
			stateVER.close();		  
		} // end if
	  
		pstmt.setString(1,q_in_array);
		pstmt.setString(2,time);
		pstmt.setString(3,userID);
		pstmt.setString(4,CenterNo);
		pstmt.setString(5,locale);
		pstmt.setString(6,shippNo);//shippNo
		pstmt.setString(7,custOrder);
		pstmt.setString(8,model);  
		pstmt.setString(9,custAddress);
		pstmt.setString(10,custNo);
		pstmt.setString(11,custName);
		pstmt.setString(12,carton);
		pstmt.setString(13,sales);		
		pstmt.setString(14,sales_name);
		pstmt.setString(15,version);			
		pstmt.setString(16,"");     
		pstmt.executeUpdate();

	} else if (aLength==21) {
		String sqlIMEI = "select IMEI,TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME,MODEL_NAME from SFISM4.R_WIP_TRACKING_T where MCARTON_NO='"+q_in_array+"' ";
		Statement stateIMEI=conMES.createStatement();
		ResultSet rsIMEI=stateIMEI.executeQuery(sqlIMEI);
		boolean rsHasData = rsIMEI.next();
		if (rsHasData) {
			while (rsHasData) { 
				time = rsIMEI.getString("IN_STATION_TIME");
				imei = rsIMEI.getString("IMEI");		
				model = rsIMEI.getString("MODEL_NAME");
		
				//get sales & sales name
				String sqlSAL = "select a.SSAL SALES,trim(a.SNAME) SALESNAME from SSM a,ECH b where a.SID = 'SM' AND A.ssal = b.HSAL and b.HORD = '"+custOrder+"' ";
				Statement stateSAL=bpcscon.createStatement();
				ResultSet rsSAL=stateSAL.executeQuery(sqlSAL);
				if (rsSAL.next()) { 
					sales = rsSAL.getString("SALES");	
					sales_name = rsSAL.getString("SALESNAME");		
				}  
				rsSAL.close();
				stateSAL.close();	
		
				//get DSN
				String sqlDSN = "select SERIAL_NUMBER DSN from SFISM4.R_WIP_TRACKING_T where IMEI = '"+imei+"' ";
				Statement stateDSN=conMES.createStatement();
				ResultSet rsDSN=stateDSN.executeQuery(sqlDSN);
				if (rsDSN.next()) { 	    
					serial_number = rsDSN.getString("DSN");	
				}  
				rsDSN.close();
				stateDSN.close();
				
				//get version
				String sqlVER = "select VERSION VERSION from SFISM4.R_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+serial_number+"' ";
				Statement stateVER=conMES.createStatement();
				ResultSet rsVER=stateVER.executeQuery(sqlVER);
				if (rsVER.next()) { 	    
				version = rsVER.getString("VERSION");	
				}  
				rsVER.close();
				stateVER.close();	
	  
				pstmt.setString(1,imei);
				pstmt.setString(2,time);
				pstmt.setString(3,userID);
				pstmt.setString(4,CenterNo);
				pstmt.setString(5,locale);
				pstmt.setString(6,shippNo);//shippNo
				pstmt.setString(7,custOrder); 
				pstmt.setString(8,model); 
				pstmt.setString(9,custAddress);
				pstmt.setString(10,custNo);
				pstmt.setString(11,custName);
				pstmt.setString(12,q_in_array);
				pstmt.setString(13,sales);		
				pstmt.setString(14,sales_name);
				pstmt.setString(15,version);			
				pstmt.setString(16,"");      
				pstmt.executeUpdate();		
				
				rsHasData = rsIMEI.next();
			}  // end while
			rsIMEI.close();
			stateIMEI.close();		
		}//end of if
		else  { //H Table
			String sqlIMEIH = "select IMEI,TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME,MODEL_NAME from SFISM4.H_WIP_TRACKING_T where MCARTON_NO='"+q_in_array+"' ";
			Statement stateIMEIH=conMES.createStatement();
			ResultSet rsIMEIH=stateIMEIH.executeQuery(sqlIMEIH);
			while (rsIMEIH.next()) { 
				time = rsIMEIH.getString("IN_STATION_TIME");
				imei = rsIMEIH.getString("IMEI");		
				model = rsIMEIH.getString("MODEL_NAME");
		
				//get sales & sales name
				String sqlSAL = "select a.SSAL SALES,trim(a.SNAME) SALESNAME from SSM a,ECH b where a.SID = 'SM' AND A.ssal = b.HSAL and b.HORD = '"+custOrder+"' ";
				Statement stateSAL=bpcscon.createStatement();
				ResultSet rsSAL=stateSAL.executeQuery(sqlSAL);
				if (rsSAL.next()) { 
					sales = rsSAL.getString("SALES");	
					sales_name = rsSAL.getString("SALESNAME");		
				}  
				rsSAL.close();
				stateSAL.close();	
		
				//get DSN
				String sqlDSN = "select SERIAL_NUMBER DSN from SFISM4.H_WIP_TRACKING_T where IMEI = '"+imei+"' ";
				Statement stateDSN=conMES.createStatement();
				ResultSet rsDSN=stateDSN.executeQuery(sqlDSN);
				if (rsDSN.next()) { 	    
					serial_number = rsDSN.getString("DSN");	
				}  
				rsDSN.close();
				stateDSN.close();
				
				//get version
				String sqlVER = "select VERSION VERSION from SFISM4.H_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+serial_number+"' ";
				Statement stateVER=conMES.createStatement();
				ResultSet rsVER=stateVER.executeQuery(sqlVER);
				if (rsVER.next()) { 	    
					version = rsVER.getString("VERSION");	
				}  
				rsVER.close();
				stateVER.close();	
	  
				pstmt.setString(1,imei);
				pstmt.setString(2,time);
				pstmt.setString(3,userID);
				pstmt.setString(4,CenterNo);
				pstmt.setString(5,locale);
				pstmt.setString(6,shippNo);//shippNo
				pstmt.setString(7,custOrder); 
				pstmt.setString(8,model); 
				pstmt.setString(9,custAddress);
				pstmt.setString(10,custNo);
				pstmt.setString(11,custName);
				pstmt.setString(12,q_in_array);
				pstmt.setString(13,sales);		
				pstmt.setString(14,sales_name);
				pstmt.setString(15,version);			
				pstmt.setString(16,"");      
				pstmt.executeUpdate();
			}  // end while
			rsIMEIH.close();
			stateIMEIH.close();		  
		}//end else
	}// end else	(aLength==21)
}//end of for
pstmt.close();
  
  out.println("Input Shipping Data Successfully!!<BR><BR>");
  //out.println("<A HREF=../jsp/WSShippingInputEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Customer Activity IMEI Authorization Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForePriCostEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Price & Cost of Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to C&F Sub Menu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("<A HREF=../jsp/WSShippingEntry.jsp>Shipping Entry Form<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  pstmt.close();
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><BR><FONT color='BLUE'>==============Detail of Data Input =====================</FONT>");				 			 	   			 
     out.println(arrayListCheckBoxBean.getResultString());		  		   	 
   }	//enf of a!=null if         

} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnMESPage.jsp"%>
<!--=================================-->
</html>
