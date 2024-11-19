<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*,java.text.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Labor Rate and Overhead Rate Revise Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<script language="JavaScript" type="text/JavaScript">

function setDataReset(URL)
{  
   alert("資料清空!!!");
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

function setDataRevise(URL)
{
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

</script>
<body>
<A HREF="../jsp/TSCMfgSubelementRateReviseUpload.jsp">上一頁</A>
<FORM NAME="MYFORM" onsubmit='return submitCheck("是","否")' ACTION="../jsp/TSCMfgSubelementRateReviseInsert.jsp" METHOD="post">
  <strong><font color="#004080" size="4" face="Arial">Labor Rate and Overhead Rate Revise Process</font></strong> 
<%

// 20121128 Marvie Add : Check amount
// 20130109 Marvie Delete : Compile error
//public static double roundToDecimals(double d, int c) {
//  int temp=(int)(d*Math.pow(10,c));
//  return (((double)temp)/Math.pow(10,c));
//}

int loginUserId=0,dataCount=0,cntError=0,cntRevise=0;

String updateFlag = request.getParameter("UPDATEFLAG");       //判斷是否按了更新資料庫BUTTON
String dataError = request.getParameter("DATAERROR");        // 判斷資料是否有誤 Y / N
String pType = request.getParameter("PTYPE");   //  1: insert table ORADDMAN.TSC_OM_SALESORDERREVISE ,2:REVISE 3:CANCEL
int iPeriodId = 0;

if (updateFlag==null || updateFlag.equals("")) updateFlag="N";
if (dataError==null || dataError.equals("")) dataError="N";   //預設資料無誤
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);
String dateString="";
String errorFlag="N",colorStr="";

// 20121024 Marvie Add : TSC and YEW use
String sLegalEntityID = "";
// 20121128 Marvie Add : Check amount
int iPrecision = 0;

String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();

if ( pType == "1" || pType.equals("1") )    // Insert temp table , check , display
{
	mySmartUpload.initialize(pageContext); 
   	mySmartUpload.upload();

   	dateString=dateBean.getYearMonthDay();
   	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
   	upload_file.saveAs("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 


   	String uploadFile_name=upload_file.getFileName();
   	String uploadFilePath="d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName();

   	try {
    	String sqlid = " SELECT erp_user_id FROM ORADDMAN.WSUSER"+
 					 "  WHERE UPPER(USERNAME) = trim(upper('"+UserName+"')) " ;
	  	Statement stateid=con.createStatement();
      	ResultSet rsid=stateid.executeQuery(sqlid);
	  	if (rsid.next()) { 	
        	loginUserId=rsid.getInt("ERP_USER_ID");
      	}
	  	rsid.close();
      	stateid.close();
	} catch (Exception e) {
		out.println("Exception get loginUserId:"+e.getMessage());
	  	errorFlag="Y";
   	} 

	// 20121024 Marvie Add : TSC and YEW use
	if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("TSC_COST")>=0) {
		sLegalEntityID = "41";
	} else if (UserRoles.indexOf("YEW_COST")>=0) {
		sLegalEntityID = "325";
	} else {
		out.println("Exception get sLegalEntityID: setup error");
		errorFlag = "Y";
	}

   	if (errorFlag=="N") { 
   		try {
			// 20121024 Marvie Update : TSC and YEW use
    		//String sqlid = " SELECT pac_period_id FROM cst_pac_periods"+
 			//			   "  WHERE legal_entity = 325 AND cost_type_id = 1000 AND open_flag = 'Y' " ;
    		String sqlid = " SELECT pac_period_id FROM cst_pac_periods"+
 						   "  WHERE legal_entity = "+sLegalEntityID+" AND cost_type_id = 1000 AND open_flag = 'Y' " ;
	  		Statement stateid=con.createStatement();
      		ResultSet rsid=stateid.executeQuery(sqlid);
	  		if (rsid.next()) { 	
         		iPeriodId=rsid.getInt("PAC_PERIOD_ID");
      		}
	  		rsid.close();
      		stateid.close();
			if (iPeriodId==0) {
				out.println("Error : can not get open period. iPeriodId="+iPeriodId);
	  			errorFlag="Y";
			}
		} catch (Exception e) {
			out.println("Exception get iPeriodId:"+e.getMessage());
	  		errorFlag="Y";
   		}
	}
//out.println("<BR>iPeriodId="+iPeriodId);

	// 20121128 Marvie Add : Check amount
   	if (errorFlag=="N") { 
   		try {
    		String sqlid = " SELECT fc.precision FROM fnd_currencies fc, gl_sets_of_books gsob, cst_le_cost_types ct"+
 						    " WHERE ct.legal_entity = "+sLegalEntityID+" AND ct.cost_type_id = 1000"+
						      " AND ct.set_of_books_id = gsob.set_of_books_id AND gsob.currency_code = fc.currency_code";
	  		Statement stateid=con.createStatement();
      		ResultSet rsid=stateid.executeQuery(sqlid);
	  		if (rsid.next()) { 	
         		iPrecision=rsid.getInt("PRECISION");
      		}
	  		rsid.close();
      		stateid.close();
		} catch (Exception e) {
			out.println("Exception get iPrecision:"+e.getMessage());
	  		errorFlag="Y";
   		}
	}

    // Delete data tsc_cst_subelement_rate
	if (errorFlag=="N" && iPeriodId > 0) {
   		try {
	    	String sqld = "DELETE FROM tsc_cst_subelement_rate WHERE period_id = "+iPeriodId+"  ";
  	    	PreparedStatement seqstmtd=con.prepareStatement(sqld);
  	    	seqstmtd.executeUpdate();
   	    	seqstmtd.close();
		} catch (Exception e) {
			out.println("Exception Delete data tsc_cst_subelement_rate:"+e.getMessage());
	  		errorFlag="Y";
   		}
   	}

   	if (errorFlag=="N" && iPeriodId > 0) {
    	String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
      	String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
      	InputStream is = new FileInputStream("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 			
			
      	jxl.Workbook wb = Workbook.getWorkbook(is);  
      	jxl.Sheet sht = wb.getSheet(0);

      	String sheetName = sht.getName();    //抓SHEETNAME
    
      	int rowCount = sht.getRows();  // 取此次筆數
      	dataCount = 0;

      	int i = 1; //EXCEL 表由第2列開始讀入
		// 20121024 Marvie Add : TSC and YEW use
		int j = 0; // column number
         
      	try 
		{
        	while (i<rowCount && errorFlag=="N")
			{  
				// 20121024 Marvie Add : TSC and YEW use
            	String sOrganizationCode = "";
				if (sLegalEntityID.equals("41")) {
            		jxl.Cell wcDOrganizationCode = sht.getCell(0, i);         // Organization Code
            		sOrganizationCode = wcDOrganizationCode.getContents();
					j = 1;
				}

            	jxl.Cell wcDSubelement = sht.getCell(j, i);                   // Subelement
            	String sSubelement = wcDSubelement.getContents();

            	jxl.Cell wcDSubelementCode = sht.getCell(j+1, i);             // Subelement_Code
            	String sSubelementCode = wcDSubelementCode.getContents();

            	if (sSubelement!="" && sSubelementCode!="" && (sLegalEntityID.equals("325") || sOrganizationCode!="") && errorFlag=="N")
				{
		       		jxl.Cell wcDAmount = sht.getCell(j+3, i);                 // Amount
               		String sAmount = wcDAmount.getContents();
			   		double dAmount = 0.0d;
			   		if (wcDAmount.getType() == CellType.NUMBER) 
					{
                 		NumberCell nc = (NumberCell) wcDAmount;
                 		dAmount = nc.getValue();
			   		} 
					else sAmount = "";
//out.println("<BR>sSubelement="+sSubelement);
//out.println("<BR>sSubelementCode="+sSubelementCode);
//out.println("<BR>sAmount="+sAmount);
//out.println("<BR>dAmount="+dAmount+"<BR>");
					// 20121128 Marvie Add : Check amount
					int temp=(int)(dAmount*Math.pow(10,iPrecision));
					double dAmount1=((double)temp)/Math.pow(10,iPrecision);
					//if (sAmount==null || sAmount=="" || dAmount!=dAmount1) {
					//	out.println("<BR>Error : Amount data error. sSubelement="+sSubelement+" sSubelementCode="+sSubelementCode+
					//				" sAmount="+sAmount+" dAmount="+dAmount+" dAmount1="+dAmount1+" temp="+temp);
	  				//	errorFlag="Y";
					//}

		       		jxl.Cell wcDWork_Time = sht.getCell(j+4, i);              // Work_Time
               		String sWork_Time = wcDWork_Time.getContents();
			   		double dWork_Time = 0.0d;
			   		if (wcDWork_Time.getType() == CellType.NUMBER) 
					{
                 		NumberCell nc = (NumberCell) wcDWork_Time;
                 		dWork_Time = nc.getValue();
			   		} 
					else sWork_Time = "";
//out.println("<BR>sWork_Time="+sWork_Time);

		       		jxl.Cell wcDRate = sht.getCell(j+5, i);                   // Rate                      
               		String sRate = wcDRate.getContents();
			   		double dRate = 0.0d;
			   		if (wcDRate.getType() == CellType.NUMBER) 
					{
                 		NumberCell nc = (NumberCell) wcDRate;
                 		dRate = nc.getValue();
			   		} 
					else sRate = "";
//out.println("<BR>dRate="+dRate+"<BR>");

			        // 20121024 Marvie Update : TSC and YEW use
                    String sStep = "2";
					String sCnt = "9000";
					if (sLegalEntityID.equals("325")) {
                    	sStep = "1";
						sCnt = "2400";
						if (sSubelement.equals("Overhead")) {
                      		sStep = "3.76";
					  		sCnt = "132600";
						}
					}

				    // 20121024 Marvie Update : Add field  'organization_code' for TSC and YEW use
		       		String sqlTC = "INSERT INTO tsc_cst_subelement_rate(period_id, subelement, subelement_code, amount, work_time,"+
		                              " rate, step, cnt,"+
									  " creation_date, created_by, last_update_date, last_updated_by, organization_code)"+
                                   " VALUES("+iPeriodId+",'"+sSubelement+"','"+sSubelementCode+"', ?, ?,"+
						              " ?, "+sStep+", "+sCnt+","+
									  " SYSDATE, "+loginUserId+", SYSDATE, "+loginUserId+", '"+sOrganizationCode+"') ";
               		PreparedStatement seqstmt=con.prepareStatement(sqlTC);
               		if (sAmount==null || sAmount=="") seqstmt.setNull(1,java.sql.Types.FLOAT);
			   		else {
					  //seqstmt.setFloat(1,(float)dAmount);        20120502 Marvie Update : fix bug
					  seqstmt.setDouble(1,dAmount);
					}
               		if (sWork_Time==null || sWork_Time=="") seqstmt.setNull(2,java.sql.Types.FLOAT);
			   		else {
						//seqstmt.setFloat(2,Float.parseFloat(sWork_Time));        20121026 Marvie Update : fix bug
						seqstmt.setDouble(2,dWork_Time);
					}
               		if (sRate==null || sRate=="") seqstmt.setNull(3,java.sql.Types.FLOAT);
			   		else {
						//seqstmt.setFloat(3,(float)dRate);        20121026 Marvie Update : fix bug
			   			seqstmt.setDouble(3,dRate);
					}
               		seqstmt.executeUpdate();
			   		dataCount++;
		    	}
           		i++;
		 	} 
	  	} 
	  	catch (Exception e) 
		{
			out.println("Exception insert:"+e.getMessage());		  
	     	errorFlag="Y";
	  	}
   		wb.close(); 
   	}

   	// Update Resource or Overhead Rate
   	if (errorFlag=="N") {
    	try {
            String sSubelement="", sSubelementCode="", sOrganizationCode="", sOrganizationID="";
			//float fRate;        20121026 Marvie Update : fix bug
			double dRate;
			
			// 20121024 Marvie Update : Add field  'organization_code' for TSC and YEW use
			String sqlI= "SELECT subelement, subelement_code, rate, organization_code"+
				          " FROM tsc_cst_subelement_rate "+
   				         " WHERE period_id = "+iPeriodId+
    				     " ORDER BY 1, 2 ";
	        Statement stateI=con.createStatement();
            ResultSet rsI=stateI.executeQuery(sqlI);
	        while (rsI.next()) {
			  	sSubelement = rsI.getString("SUBELEMENT");
//out.println("<BR>sSubelement="+sSubelement);
			  	sSubelementCode = rsI.getString("SUBELEMENT_CODE");
//out.println("<BR>sSubelementCode="+sSubelementCode);
			  	//fRate = rsI.getFloat("RATE");        20121026 Marvie Update : fix bug
			  	dRate = rsI.getDouble("RATE");

				// 20121024 Marvie Update : Add field  'organization_code' for TSC and YEW use
			  	sOrganizationCode = rsI.getString("ORGANIZATION_CODE");
				sOrganizationID = "";
				if (sLegalEntityID.equals("325")) {
					sOrganizationID = "326,327";
				} else {
    				String sqlid = " SELECT organization_id FROM mtl_parameters"+
 								   "  WHERE organization_code = '"+sOrganizationCode+"' " ;
	  				Statement stateid=con.createStatement();
      				ResultSet rsid=stateid.executeQuery(sqlid);
	  				if (rsid.next()) { 	
        				sOrganizationID=rsid.getString("ORGANIZATION_ID");
      				}
	  				rsid.close();
      				stateid.close();
				}

				if (sSubelement.equals("Resource") || sSubelement.equals("Overhead")) {
					String sqlQtyCF="";
					if (sSubelement.equals("Resource")) {
		     			sqlQtyCF = "UPDATE cst_resource_costs"+
							         //" SET resource_rate = "+fRate+","+        20121026 Marvie Update : fix bug
							         " SET resource_rate = "+dRate+","+
										 " last_update_date = SYSDATE, last_updated_by ="+loginUserId+
					    		   " WHERE organization_id IN ("+sOrganizationID+")"+
					      			 " AND cost_type_id = 1001"+
									 //" AND resource_rate <> "+fRate+        20121026 Marvie Update : fix bug
									 " AND resource_rate <> "+dRate+
						  			 " AND resource_id IN (SELECT resource_id FROM bom_resources"+
											                     " WHERE organization_id IN ("+sOrganizationID+")"+
																   " AND cost_element_id = 3"+
																   " AND resource_code = '"+sSubelementCode+"') ";
                    }
					else if (sSubelement.equals("Overhead")) {
		     			sqlQtyCF = "UPDATE cst_department_overheads"+
							         //" SET rate_or_amount = "+fRate+","+        20121026 Marvie Update : fix bug
							         " SET rate_or_amount = "+dRate+","+
										 " last_update_date = SYSDATE, last_updated_by ="+loginUserId+
					    		   " WHERE organization_id IN ("+sOrganizationID+")"+
					      			 " AND cost_type_id = 1001"+
									 //" AND rate_or_amount <> "+fRate+        20121026 Marvie Update : fix bug
									 " AND rate_or_amount <> "+dRate+
						  			 " AND overhead_id IN (SELECT resource_id FROM bom_resources"+
											                     " WHERE organization_id IN ("+sOrganizationID+")"+
																   " AND cost_element_id = 5"+
																   " AND resource_code = '"+sSubelementCode+"') ";
					}
//out.println("<BR>sqlQtyCF="+sqlQtyCF+"<BR>");
             		PreparedStatement psQtyCF=con.prepareStatement(sqlQtyCF);
             		psQtyCF.executeUpdate();
				}
		    }  //end while
	        rsI.close();
	        stateI.close();
	  	}
	  	catch (Exception e) 
		{
			out.println("Exception Update Resource or Overhead Rate:"+e.getMessage());
	     	errorFlag="Y";
	  	}
   	} 

	// Display data
   	if (errorFlag=="N") {
    	try {     
        	String sSubelement="",sSubelementCode="",sAmount="",sWorkTime="",sRate="",sOrganizationCode="";
		 	int k=1;

         	cntRevise=0;
			// 20121024 Marvie Update : Add field  'organization_code' for TSC and YEW use
         	String sqlP = "SELECT subelement, subelement_code, amount, work_time, rate, organization_code"+
				           " FROM tsc_cst_subelement_rate "+
   				          " WHERE period_id = "+iPeriodId+
    				      " ORDER BY 1, 2 ";
	     	Statement stateSh=con.createStatement();
         	ResultSet rsSh=stateSh.executeQuery(sqlP);

%>
<hr>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  			  <tr bgcolor="#BBD3E1"  height="20"> 
<%
			if (!sLegalEntityID.equals("325")) {
%>
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Organization</font></div></td> 
<%
			}
%>
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Subelement</font></div></td> 
  		       <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Name</font></div></td>           
 		       <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Amount</font></div></td> 
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Hour</font></div></td>
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Rate</font></div></td>
              </tr>
<%
	     	while (rsSh.next()) 
			{
            	sSubelement=rsSh.getString("SUBELEMENT");
            	sSubelementCode=rsSh.getString("SUBELEMENT_CODE");
            	sAmount=rsSh.getString("AMOUNT");
            	sWorkTime=rsSh.getString("WORK_TIME");
            	sRate=rsSh.getString("RATE");
            	sOrganizationCode=rsSh.getString("ORGANIZATION_CODE");

	        	if ((k % 2) == 0) 
				{
	           		colorStr = "#D8E6E7";
				} 
				else 
				{
	           		colorStr = "#BBD3E1";
				}

%>
              <tr bgcolor="<%=colorStr%>" height="20"> 
<%
			if (!sLegalEntityID.equals("325")) {
%>
               <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sOrganizationCode%></font></div></td>
<%
			}
%>
               <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sSubelement%></font></div></td>
	 		   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sSubelementCode%></font></div></td>
			   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sAmount%></font></div></td>
			   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sWorkTime%></font></div></td>
			   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sRate%></font></div></td>
              </tr>
<%
            	k++; //項次使用
				cntRevise++;
         	} //END while(rsSh.next())
	     	rsSh.close();
    	 	stateSh.close();
      	} // end of try
	  	catch (Exception e) 
		{
			out.println("Exception display:"+e.getMessage());		  
	     	errorFlag="Y";
	  	}

%>
  </table>
<%

   		if (errorFlag=="N") {
			out.println("<BR>Labor Rate and Overhead Rate Revise Success<BR>");
		}
   	}  // end if (errorFlag=="N")
} //  end if (pType=1) 

if (pType == "2" || pType.equals("2")) 
{
}  // end if pType=='2' 

if (pType == "3" || pType.equals("3")) 
{
}  // end if pType=='3'

%>

</FORM>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
