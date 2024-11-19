<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayListCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<%@ include file="/jsp/include/ConnMESPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function submitCheck(URL,field) {
	if (field==null) {
	   alert("您尚未輸入資料!!");   
	   return(false);

	}
	if (document.MYFORM.CUSTNAME.value=="" || document.MYFORM.CUSTNAME.value==null) { 
		alert("您尚未輸入對象!!");   
		return(false);
	} 
	if (document.MYFORM.WAREHOUSE.value=="" || document.MYFORM.WAREHOUSE.value=="--" || document.MYFORM.WAREHOUSE.value==null) { 
		alert("您尚未輸入倉別!!");   
		return(false);
	} 

	document.MYFORM.action=URL;
	document.MYFORM.submit();

}

</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>備機及備板借出</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="細明體"><strong>備機及備板借出</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<%
	String sReset=request.getParameter("RESET");
	String Warehouse = request.getParameter("WAREHOUSE");
	String CustName = request.getParameter("CUSTNAME"); 
	if (CustName==null) CustName = "";
	//out.println(Warehouse);
	//out.println(CustNo);
	String carIMEI = request.getParameter("CARIMEI");
	String [] aItems=request.getParameterValues("ITEMS");
	
	String sFlag = "N";
	String sIsCarton = "N";
	int iDim1 = 10; // max 10 imem
	int iDim2 = 6;
	String aCarton[][] = new String[iDim1][iDim2];
	String aIMEI[][] = {{"IMEI","MODEL","CARTON","PACKTIME","SERIAL","COUNT"}};
	
	
%>

<%

try
{
	// do not clear bean data if RESET flag on 
	if (sReset==null || sReset.equals(""))  { arrayListCheckBoxBean.setArray2DString(null); }


	if (aItems!=null) // if array bean selected for delete
	{
		String a[][]=arrayListCheckBoxBean.getArray2DContent();
		if (a!=null)
		{
			String t[][]=new String[a.length-aItems.length][iDim2];
			//out.println(a.length-aItems.length);
			if (a.length>aItems.length)
			{
				int i = 0;
				for (int x=0;x<a.length;x++)
				{
					String sFound = "N";
					for (int y=0;y<aItems.length && sFound.equals("N");y++)
					{
						if (aItems[y].equals(a[x][0])) { sFound = "Y"; }
						else { sFound = "N"; }
					}
					if (sFound.equals("N")) 
					{ 
						t[i][0]=a[x][0]; t[i][1]=a[x][1]; t[i][2]=a[x][2]; t[i][3]=a[x][3]; t[i][4]=a[x][4];t[i][5]=String.valueOf(i+1);
						i++; 
					} 
				} // end for x
				
				arrayListCheckBoxBean.setArray2DString(t);
			
			} // end if (a.length>aItems.length)
			
			else { arrayListCheckBoxBean.setArray2DString(null); }  

		} // end if (a!=null)
	} // end if (aItems!=null)
}  // end try
catch (Exception e) {out.println("Exception:"+e.getMessage());}

%> 
<FORM ACTION="WSShippingSpareInsert.jsp" METHOD="post" NAME="MYFORM">

<table border="1" cellspacing="0" cellpadding="0" bgcolor="#CCFFCC">
	
	<tr >
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Center</font></td>
			<!--<input name="CENTER" type="text" value="<%//=userActCenterNo%>"></font>-->
			<%
			
			try { // get center
			String sql = "select ALNAME from WSSHP_CENTER "+"where CENTERNO ='"+userActCenterNo+"'";
			//out.println(sql);
			Statement statC=con.createStatement();
		  	ResultSet rsC=statC.executeQuery(sql);
			boolean rs_isEmpty = !rsC.next();
			boolean rs_hasData = !rs_isEmpty;
			String Center = "";
			if (rs_hasData) { Center = rsC.getString("ALNAME");}
			%>
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black"><%=Center%></font></td>
		<%
			rsC.close();      
			statC.close();
			}
			catch (Exception e) {out.println("Exception:"+e.getMessage());}
			
		%>
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Warehouse</font></td>
		<td>
			<%
			
			try // get whs
			{
				
				out.println("<select NAME='WAREHOUSE'>");
				out.println("<OPTION VALUE=-->--");
				String sSql = "SELECT BLWHS FROM wsshp_center,wsshipper WHERE centerno=actcenterno and  username= '"+UserName+"' ORDER BY BLWHS";
				//String sSql = "SELECT BLWHS FROM wsshp_center WHERE centerno ='003' ORDER BY BLWHS";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sSql);
				while (rs.next())
				{
					String s1 = rs.getString("BLWHS");
					if (s1.equals(Warehouse)) { out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s1); }
					else { out.println("<OPTION VALUE='"+s1+"' >"+s1); }
					
				} // end of while
				
				out.println("</select>"); 	  		  		  
        
				rs.close();    
				statement.close(); 
				
			} // end of try get whs
			catch (Exception e) {out.println("Exception:"+e.getMessage());}
			
			%>
			</font>
		</td>
		
	</tr>
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">對象</font></td>
		<td colspan="3"><input type="text" name="CUSTNAME" size="50" maxlength="50" value="<%=CustName%>"></td>
	</tr>
	<tr>
		<td colspan="5"><font color="#333399" font size="2" face="Arial Black">Carton/IMEI
			<input type="text" name="CARIMEI"  size="30" maxlength="21">
            <input name="button3" type="button" onClick='setSubmit("../jsp/WSShippingSpareEntry.jsp?RESET=1")' value="Add">
</font>
		</td>
	</tr>

</table>
<%%>
<table width="327" border="1" cellpadding="0" cellspacing="0">
	<tr bgcolor="#CCFFCC">
		<td width="60"><font color="#333399" font size="2" face="Arial Black">COUNT</font></td>
		<td width="140"><font color="#333399" font size="2" face="Arial Black">IMEI</font></td>
		<td width="100"><font color="#333399" font size="2" face="Arial Black">CARTON NO.</font></td>
		<td width="100"><font color="#333399" font size="2" face="Arial Black">MES PACKING TIME</font></td>
	</tr>
	<tr nowrap>
		<%
			try { // get imem or carton
			
				String sTable = "";
				String sIMEI = "";
				String sCarton = "";
				String sPackTime = "";
				String sModel = "";
				String sSerial = "";
		%>
		<td height="30" nowrap><font size="2" face="Arial Black"> <!-- Check-->
			<% 
				//out.println(carIMEI);
				
				if (carIMEI!=null && !carIMEI.equals("")) {
					String sMessage = "";
					sFlag = "Y";
					if (sFlag.equals("Y")) {
						if (carIMEI.length()==15) { sMessage = "Count IMEI : 1"; sIsCarton = "N"; //sFlag = "Y";
						} else if (carIMEI.length()==21) { sMessage = "Count IMEI : 10"; sIsCarton = "Y"; //sFlag = "Y";
						} else { sMessage = "IMEI OR CARTON ERROR"; sFlag = "N"; }
					} // end if
					//檢查IMEI/CARTON是否已存在Array中
					String a[][]=arrayListCheckBoxBean.getArray2DContent(); //取得陣列內容
					if (a!=null) {
						for (int i=0;i<a.length;i++) {
							//out.println("["+i+"]"+a[i][0]+""+a[i][2]);
							if (sIsCarton.equals("Y")) {
								if (carIMEI.equals(a[i][2])) {
									sMessage = "Input IMEI/CARTON duplicate!!"; sFlag = "N";
									break;
								}
							} else if (carIMEI.equals(a[i][0])) {
								sMessage = "Input IMEI/CARTON duplicate!!"; sFlag = "N";
								break;
							}// end if-else
						} // end for
					} // ene if
					if (sFlag.equals("Y")) { // check imei exist
					
						Statement stateR = conMES.createStatement(); 
						String s = "select distinct IMEI from SFISM4.R_WIP_TRACKING_T "
						+" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') ";
						//+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'"); //備品及備板可能不會經過Packing站
						//out.println(s);
						ResultSet rsR = stateR.executeQuery(s);
						if (rsR.next()) { // exist R table	
							 sTable = "SFISM4.R_WIP_TRACKING_T"; 
						} else {
							Statement stateH = conMES.createStatement();
							ResultSet rsH=stateH.executeQuery("select distinct IMEI from SFISM4.H_WIP_TRACKING_T "
							+" where (IMEI = '"+carIMEI+"' or MCARTON_NO='"+carIMEI+"') ");
							//+" and GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'"); //備機及備板可能不會經過Packing站
							if (rsH.next()) {// exist H table
								sTable = "SFISM4.H_WIP_TRACKING_T";
							} else { sMessage = "IMEI OR CARTON IS NOT EXIST"; sFlag = "N";  
							}
							rsH.close();
							stateH.close();
						}
						rsR.close();
						stateR.close();
					} // end if check imei exist
					
					if (sFlag.equals("Y"))  { // check imei has been shipped
						String sqlExist = "select * from WSSHIP_IMEI_T "+
						" WHERE (SHP_NOTES IS NULL OR SHP_NOTES='X' OR SHP_NOTES='S' OR SHP_NOTES='S01' OR SHP_NOTES='T')";
						// null = shipped, X = DOA/DAP exchange out, S =  Consign out, S01=樣品領用, T=備品借出
						if (sIsCarton.equals("Y")) { sqlExist = sqlExist+" AND MES_CARTON_NO='"+carIMEI+"' "; }
						else { sqlExist = sqlExist+" AND IMEI = '"+carIMEI+"' "; }
						Statement stateExist=con.createStatement();
						ResultSet rsExist=stateExist.executeQuery(sqlExist); 
						if (rsExist.next()) { sMessage = "IMEI OR CARTON HAS SHIPPED"; sFlag = "N"; }
						else { sFlag = "Y"; }
					} // end if check imei has been shipped
					out.println(sMessage);
					
			%></font>
		</td>
		<td><font size="2" face="Arial Black"> <!-- IMEI-->
			<%
				if (sFlag.equals("Y")) {
					String sqlIMEI = "select MCARTON_NO,IMEI,TO_CHAR(IN_STATION_TIME,'YYYY-MM-DD HH24-MI-SS') IN_STATION_TIME,MODEL_NAME,SERIAL_NUMBER from "+sTable
					+" WHERE IMEI is not null ";
					//+" AND GROUP_NAME='AC_PACKING' and PALLET_FULL_FLAG='Y'";//備機及備板可能不會經過Packing站
					if (carIMEI.length()==15) { sqlIMEI = sqlIMEI + " and IMEI='" + carIMEI + "' "; }
					if (carIMEI.length()==21) { sqlIMEI = sqlIMEI + " and MCARTON_NO='"+carIMEI+"' "; }
					//out.println(sqlIMEI);
					Statement stateIMEI=conMES.createStatement();
					ResultSet rsIMEI=stateIMEI.executeQuery(sqlIMEI);
			%>
			<table>
			<%
					int i = 0;
					while (rsIMEI.next() && i<iDim1) {// 最多只能有10個IMEI
						sPackTime = rsIMEI.getString("IN_STATION_TIME");
						sCarton = rsIMEI.getString("MCARTON_NO");
						sIMEI = rsIMEI.getString("IMEI");
						sModel = rsIMEI.getString("MODEL_NAME");
						sSerial = rsIMEI.getString("SERIAL_NUMBER");
			%>
				<tr>
				<td><font size="2" face="Arial Black"><%=sIMEI%></font></td>
				</tr>
			<%
						if (sIsCarton.equals("Y")) { aCarton[i][0]=sIMEI; aCarton[i][1]=sModel; aCarton[i][2]=sCarton; aCarton[i][3]=sPackTime; aCarton[i][4]=sSerial; }
						else { aIMEI[0][0]=sIMEI; aIMEI[0][1]=sModel; aIMEI[0][2]=sCarton; aIMEI[0][3]=sPackTime; aIMEI[0][4]=sSerial; }
						i++;
					} //end while rsIMEI.next()
					rsIMEI.close();
					stateIMEI.close();
				} // end if sFlag.equals("Y")
			%>
			</table>
			</font>
		</td>
		<td><font size="2" face="Arial Black"> <!--CARTON NO -->
			<%=sCarton%></font>
		</td>
		<td><font size="2" face="Arial Black"> <!-- PACKING TIME-->
			<%=sPackTime%></font>
		</td>
		<%
				} // end of carIMEI!=null
			} catch (Exception e) {out.println("Exception:"+e.getMessage());
			}// end of try get imem or carton
		%>
	</tr>
</table>

<input name="sel" type="button" onClick="this.value=check(this.form.ITEMS)" value="Select All">
<BR>		        


<%
try {


	if (sFlag.equals("Y")) {
		String a[][]=arrayListCheckBoxBean.getArray2DContent(); //取得陣列內容
		int iDim = 0;
		if (a==null) { iDim = 0; }
		else { iDim = a.length; }
	
		int n = 0;
		if (sIsCarton.equals("Y")) { n = iDim1;} // 10 IMEI for each carton
		else { n = 1; }
		
		
		String b[][]=new String[iDim+n][iDim2];
		  			 
		int i=0, j=0;
		for (i=0;i<iDim;i++) { // 存儲目前array bean 內容
			for (j=0;j<iDim2;j++) {
				b[i][j]=a[i][j];
			} // end for j
		} // end for i
		
		int k = 0;
		while (k<n) {// 加入本次新增內容
			if (sIsCarton.equals("Y")) { 
				b[i][0] = aCarton[k][0]; b[i][1] = aCarton[k][1]; 
				b[i][2] = aCarton[k][2]; b[i][3] = aCarton[k][3]; 
				b[i][4] = aCarton[k][4]; b[i][5] = String.valueOf(i+1);
			} else  {
				b[i][0] = aIMEI[k][0]; b[i][1] = aIMEI[k][1]; 
				b[i][2] = aIMEI[k][2]; b[i][3] = aIMEI[k][3]; 
				b[i][4] = aIMEI[k][4]; b[i][5] = String.valueOf(i+1);
			}
			i++;
			k++;
		} // end while

		arrayListCheckBoxBean.setArray2DString(b);
	} // end if (sFlag.equals("Y"))

	String a[][]=arrayListCheckBoxBean.getArray2DContent();//取得陣列內容
	if (a!=null ) {
		arrayListCheckBoxBean.setFieldName("ITEMS");
		// set array bean title
		String oneDArray[]= {"","IMEI","MODEL","CARTON","PACK","SERIAL","COUNT"}; 	 	     			  
		arrayListCheckBoxBean.setArrayString(oneDArray);
 	   	// show array 
		out.println(arrayListCheckBoxBean.getArray2DString());  	 				
	} // end if (a!=null )

} catch (Exception e) {out.println("Exception:"+e.getMessage());
}// end of try-catch
%>

<BR>
<input name="del" type="button" onClick='setSubmit("../jsp/WSShippingSpareEntry.jsp?RESET=1")'  value="DELETE" >

<div align="center">
<input name="confirm" type="submit" value="確認送出" onClick='return submitCheck("../jsp/WSShippingSpareInsert.jsp",this.form.ITEMS)'>
</div>

</FORM>
</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnMESPage.jsp"%>
<!--=================================-->
