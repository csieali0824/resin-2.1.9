<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,ArrayListCheckBoxBean" %>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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

	document.MYFORM.action=URL;
	document.MYFORM.submit();

}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>樣品繳回</title>
</head>

<body>
<font color="#3366FF" size="+2" face="Arial"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Arial"><strong>樣品繳回</strong></font>

<form ACTION="WSShippingSampleUpdate.jsp" METHOD="post" NAME="MYFORM" >
<A HREF="/wins/WinsMainMenu.jsp">HOME</A> 
<br><font color="#333399" font size="2" face="Arial Black">Carton No./IMEI No.</font>
<input type="text" name="CARIMEI"  size="30" maxlength="21">
<input name="ADD" type="button" onClick='setSubmit("../jsp/WSShippingSampleReturn.jsp?RESET=1")' value="ADD">
<table border="1" bgcolor="#CCFFCC" cellpadding="0" cellspacing="0" >
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">IMEI</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">MODEL</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CARTON</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">SHIPPING</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CUST</font></td>
	</tr>
	<%
	
	// get parameter
	String sReset=request.getParameter("RESET");  // reset flag
	String carIMEI = request.getParameter("CARIMEI");
	String [] aItems=request.getParameterValues("ITEMS");
	
	String sIMEI = "";
	String sCarton = "";
	String sShip = "";
	String sModel = "";
	String sCust = "";
	
	String sFlag = "N";
	String sIsCarton = "N";
	String sMessage = "";
	
	int iDim1 = 10; // max 10 imem
	int iDim2 = 6;	
	String aCarton[][] = new String[iDim1][iDim2];
	String aIMEI[][] = {{"IMEI","MODEL","CARTON","SHIP","CUST","COUNT"}};
	
	try // try 1
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
						//out.println(aItems[y]); out.println(a[x][0]);
					} // end for y
					//out.println(sFound); 
					if (sFound.equals("N")) 
					{ 
						//for (int z=0;z<iDim2;z++){ t[i][z]=a[x][z]; }
						t[i][0]=a[x][0]; t[i][1]=a[x][1]; t[i][2]=a[x][2]; t[i][3]=a[x][3]; t[i][4]=a[x][4];t[i][5]=String.valueOf(i+1);
						i++; 
					} 
				} // end for x
				
				arrayListCheckBoxBean.setArray2DString(t);
			
			} // end if (a.length>aItems.length)
			
			else { arrayListCheckBoxBean.setArray2DString(null); }  

		} // end if (a!=null)
	} // end if (aItems!=null)


		if (carIMEI!=null && !carIMEI.equals(""))
		{
			if (carIMEI.length()==15) { sIsCarton = "N"; sFlag = "Y"; }
			else if (carIMEI.length()==21) { sIsCarton = "Y"; sFlag = "Y";}
			else { sFlag = "N"; }
			
			if (sFlag.equals("Y")) // check imei exist
			{
				String sqlExist = "select * from WSSHIP_IMEI_T "+
				" where (IMEI = '"+carIMEI+"' or MES_CARTON_NO='"+carIMEI+"') "+
				" AND trim(SHP_NOTES)='S01' "; // S01 = 樣品領用
				//out.println(sqlExist);
				Statement stateExist=con.createStatement();
				ResultSet rsExist=stateExist.executeQuery(sqlExist); 
				if (rsExist.next()) { sFlag = "Y"; }
				else { sMessage = "DATA NOT FOUND"; sFlag = "N"; }
			} // end if check imei exist
			
			if (sFlag.equals("Y"))
			{
			
				String sqlIMEI = "select IMEI,ERP_ITEMNO,MES_CARTON_NO,INSERT_DTIME,ERP_CUSTNAME as CUST from WSSHIP_IMEI_T WHERE " +
				" SHP_NOTES='S01' ";
				if (carIMEI.length()==15) { sqlIMEI = sqlIMEI + " and IMEI='" + carIMEI + "' "; }
				if (carIMEI.length()==21) { sqlIMEI = sqlIMEI + " and MES_CARTON_NO='"+carIMEI+"' "; }
				//out.println(sqlIMEI);
				Statement stateIMEI=con.createStatement();
				ResultSet rsIMEI=stateIMEI.executeQuery(sqlIMEI);
				int i = 0;
				while (rsIMEI.next() && i<iDim1) // 最多只能有10個IMEI
				{
					sShip = rsIMEI.getString("INSERT_DTIME");
					sCarton = rsIMEI.getString("MES_CARTON_NO");
					sIMEI = rsIMEI.getString("IMEI");
					sModel = rsIMEI.getString("ERP_ITEMNO");
					sCust = rsIMEI.getString("CUST");
					
				%>
				
				<tr>
				<td><font color="#333399" font size="2" face="Arial Black"><%=sIMEI%></font></td>
				<td><font color="#333399" font size="2" face="Arial Black"><%=sModel%></font></td>
				<td><font color="#333399" font size="2" face="Arial Black"><%=sCarton%></font></td>
				<td><font color="#333399" font size="2" face="Arial Black"><%=sShip%></font></td>
				<td><font color="#333399" font size="2" face="Arial Black"><%=sCust%></font></td>
				</tr>
				
				<%
					if (sIsCarton.equals("Y")) { aCarton[i][0]=sIMEI; aCarton[i][1]=sModel; aCarton[i][2]=sCarton; aCarton[i][3]=sShip; aCarton[i][4]=sCust; }
					else { aIMEI[0][0]=sIMEI; aIMEI[0][1]=sModel; aIMEI[0][2]=sCarton; aIMEI[0][3]=sShip; aIMEI[0][4]=sCust; }
					
					i++;
				}
				
				rsIMEI.close();
				stateIMEI.close();

			}
			else { out.println("<tr><td colspan ='5'><font color='#333399' font size='2' face='Arial Black'>"+sMessage+"</font></td></tr>"); }
			
			
		} // end if (carIMEI!=null && !carIMEI.equals(""))
	
	} // end try 1
	catch (Exception e) {out.println("Exception:"+e.getMessage());}
	
	%>
	
</table>
<BR>
<input name="sel" type="button" onClick="this.value=check(this.form.ITEMS)" value="Select All">
<BR>	

<%
try // try 2
{
	if (sFlag.equals("Y"))
	{
		String a[][]=arrayListCheckBoxBean.getArray2DContent(); //取得陣列內容
		int iDim = 0;
		if (a==null) { iDim = 0; }
		else { iDim = a.length; }
	
		int n = 0;
		if (sIsCarton.equals("Y")) { n = iDim1;} // 10 IMEI for each carton
		else { n = 1; }
		
		
		String b[][]=new String[iDim+n][iDim2];
		  			 
		int i=0, j=0;
		for (i=0;i<iDim;i++) // 存儲目前array bean 內容
		{
			for (j=0;j<iDim2;j++)
			{
				b[i][j]=a[i][j];
			} // end for j
		} // end for i
		
		int k = 0;
		while (k<n) // 加入本次新增內容
		{
			if (sIsCarton.equals("Y")) 
			{ 
				b[i][0] = aCarton[k][0]; b[i][1] = aCarton[k][1]; 
				b[i][2] = aCarton[k][2]; b[i][3] = aCarton[k][3]; 
				b[i][4] = aCarton[k][4]; b[i][5] = String.valueOf(i+1);
			}
			else 
			{ 
				b[i][0] = aIMEI[k][0]; b[i][1] = aIMEI[k][1]; 
				b[i][2] = aIMEI[k][2]; b[i][3] = aIMEI[k][3]; 
				b[i][4] = aIMEI[k][4]; b[i][5] = String.valueOf(i+1);
			}
			i++;
			k++;
		}

		arrayListCheckBoxBean.setArray2DString(b);
		


	} // end if (sFlag.equals("Y"))



	String a[][]=arrayListCheckBoxBean.getArray2DContent();//取得陣列內容
	if (a!=null )
	{
		arrayListCheckBoxBean.setFieldName("ITEMS");

		// set array bean title
		String oneDArray[]= {"","IMEI","MODEL","CARTON","SHIP","CUST","COUNT"}; 	 	     			  
		arrayListCheckBoxBean.setArrayString(oneDArray);
 	   	// show array 
		out.println(arrayListCheckBoxBean.getArray2DString());  	 				

	} // end if (a!=null )
} // end try 2
catch (Exception e) {out.println("Exception:"+e.getMessage());}


%>

<BR>
<input name="del" type="button" onClick='setSubmit("../jsp/WSShippingSampleReturn.jsp?RESET=1")'  value="DELETE" >

<div align="center"><input name="confirm" type="submit" value="確認送出" onClick='return submitCheck("../jsp/WSShippingSampleUpdate.jsp",this.form.ITEMS)'></div>


</form>

</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
