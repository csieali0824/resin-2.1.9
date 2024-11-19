<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Switch CharacterSet==========-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="PageHeaderBean,ComboBoxBean,ArrayComboBoxBean,DateBean,CheckBoxBean,ArrayCheckBoxBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入Other Feature-->
<jsp:useBean id="arrayCheckBoxBean4Ringer" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入Other Feature-->
<%
  arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  arrayCheckBoxBean4Ringer.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  
  Statement statement=con.createStatement();
%>
<script language="JavaScript" type="text/JavaScript">
function btnAddFeatures()
{ 
  subWin=window.open("subwindow/AddFeaturesSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
function btnAddRinger()
{ 
  subWin=window.open("subwindow/AddRingerSubWindow.jsp","subwin","width=480,height=400,scrollbars=yes,menubar=no");  
}
</script>
<html>
<head>
<title>Product Information Input Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/PIInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
  <font color="#0080FF" size="4"><strong><jsp:getProperty name="pageHeader" property="pgTitleName"/></strong></font>
  &nbsp;&nbsp;&nbsp;&nbsp;<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='PIQueryAll.jsp'>Query all Product Information</A></font>
  <BR>
  <table width="97%">
    <tr bgcolor="e6bbff"> 
      <td width="29%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgProjectCode"/>
          </font></div></td>
      <td width="16%"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="PROJECTCODE" SIZE=8>
        </font></td>
      <td width="28%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgSalesCode"/>
          </font></div></td>
      <td width="27%"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="SALESCODE" SIZE=8>
        </font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; 
          <jsp:getProperty name="pageHeader" property="pgProductType"/>
          </font></div></td>
      <td><font size="2">        <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select PROD_CLASS A,PROD_CLASS B from MRPRODCLS order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("PRODUCTTYPE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
</font></td>
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgBrand"/>
          </font></div></td>
      <td><font size="2">
	 <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select BRAND A,BRAND B from PIBRAND order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("BRAND");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
</font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; TA Date</font></div></td>
      <td><font size="2"> 
        <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("TAYEAR");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);	      	   
	   arrayComboBoxBean.setFieldName("TAMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   
	   arrayComboBoxBean.setFieldName("TADAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
      <td><div align="right"><font size="2">TA Status</font></div></td>
      <td><font size="2"> 
        <INPUT TYPE="TEXT" NAME="TASTATUS" size="12">
        </font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; 
          <jsp:getProperty name="pageHeader" property="pgLaunchDate"/>
          </font></div></td>
      <td><font size="2"> 
        <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("LAUNCHYEAR");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);	      	   
	   arrayComboBoxBean.setFieldName("LAUNCHMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   
	   arrayComboBoxBean.setFieldName("LAUNCHDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgDeLaunchDate"/>
          </font></div></td>
      <td><font size="2"> 
        <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("DELAUNCHYEAR");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);	      	   
	   arrayComboBoxBean.setFieldName("DELAUNCHMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        / 
        <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   
	   arrayComboBoxBean.setFieldName("DELAUNCHDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6bbff">
      <td><div align="right">DESIGN HOUSE</div></td>
      <td><font size="2">
        <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select RDDPT A,RDDPT B from MRDPT order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("DESIGNHOUSE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
      <td><div align="right">SYSTEM MODE</div></td>
      <td><font size="2">
        <%      
	  try
      {      	         
       ResultSet rs=statement.executeQuery("select SYSTEMMODE A,SYSTEMMODE B from PISYSTEMMODE order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("SYSTEMMODE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
    </tr>
    <tr bgcolor="e6bbff">
      <td><div align="right">PLATFORM</div></td>
      <td><font size="2">
        <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select SPLATFM_NAME A,SPLATFM_NAME B from PRPROD_PLATFORM order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("PLATFORM");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <BR>
  <font color="#004080"><strong>SPECIFICATIONS</strong></font><BR>
  <table width="98%" border="0">
    <tr bgcolor="e6e6fa"> 
      <td width="15%"><div align="right"><font size="2">BAND MODE</font></div></td>
      <td colspan="2"> <font size="2"> 
        <%      
	  try
      {      	        
       ResultSet rs=statement.executeQuery("select BANDMODE A,BANDMODE B from PIBANDMODE order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("BANDMODE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgSize"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <jsp:getProperty name="pageHeader" property="pgLength"/>
        : 
        <INPUT TYPE="TEXT" NAME="LENGTH" size=5 value=0>
        &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgWidth"/>
        : 
        <INPUT TYPE="TEXT" NAME="WIDTH" size=5 value=0>
        &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgHeight"/>
        : 
        <INPUT TYPE="TEXT" NAME="HEIGHT" size=5 value=0>
        (mm) </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td> <div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgWeight"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="WEIGHT" size=5 value=0>
        (g) </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgDisplay"/>
          </font></div></td>
      <td colspan="2"><font size="2">MAIN: 
        <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select DISPLAYNAME A,DISPLAYNAME B from PIDISPLAY order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("DISPLAYMAIN");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        &nbsp;&nbsp;&nbsp;&nbsp; Sub: 
        <%      
	  try
      {      	         
       ResultSet rs=statement.executeQuery("select DISPLAYNAME A,DISPLAYNAME B from PIDISPLAY order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("DISPLAYSUB");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgCamera"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="radio" NAME="CAMERA" VALUE='Y'>
        YES 
        <INPUT TYPE="radio" NAME="CAMERA" VALUE='N' CHECKED>
        NO &nbsp;&nbsp;&nbsp;&nbsp; CAMERA Specifics: 
        <%      
	  try
      {      	         
       ResultSet rs=statement.executeQuery("select CAMERANAME A,CAMERANAME B from PICAMERA order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("CAMERACODE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgRingtone"/>
          </font></div></td>
      <td colspan="2"> <font size="2"> 
        <%      
	  try
      {      	         
       ResultSet rs=statement.executeQuery("select RINGTONECODE A,RINGTONECODE B from PIRINGTONE order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("RINGTONECODE");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgPhonebook"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="PHONEBOOK" size="5">
        (sets)</font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right">Connectivity</div></td>
      <td width="36%"><strong>WAP</strong>:<font size="2"> 
        <INPUT TYPE="radio" NAME="WAP" VALUE='Y'>
        YES 
        <INPUT TYPE="radio" NAME="WAP" VALUE='N' CHECKED>
        NO &nbsp;&nbsp; WAP Ver: 
        <%      
	  try
      {      	        
       ResultSet rs=statement.executeQuery("select CONNNAME A,CONNNAME B from PICONN order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("WAP_VER");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
      <td width="41%"><strong>GPRS</strong>:<font size="2"> 
        <INPUT TYPE="radio" NAME="GPRS" VALUE='Y'>
        YES 
        <INPUT TYPE="radio" NAME="GPRS" VALUE='N' CHECKED>
        NO &nbsp;&nbsp; GPRS Ver: 
        <%      
	  try
      {      	         
       ResultSet rs=statement.executeQuery("select CONNNAME A,CONNNAME B from PICONN order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("GPRS_VER");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2">Message Protocol</font></div></td>
      <td colspan="2"> <font size="2"> 
        <%		                  
              ResultSet rs=statement.executeQuery("select COMMNAME,COMMNAME from PICOMM");			 			 			  
              checkBoxBean.setRs(rs);
	          checkBoxBean.setFieldName("COMM");
	          checkBoxBean.setColumn(6); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());			  
			 
			  rs.close();
	    %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> </font></div></td>
      <td><font size="2">
        <input name="button" type=button onClick="btnAddFeatures()" value="Standard Features:">
        </font></td>
      <td><font size="2">
        <input name="button2" type=button onClick="btnAddRinger()" value="Add Ringer:">
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgRemark"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=40>
        </font></td>
    </tr>
  </table>  
  <BR>
  <font color="#004080"><strong>IMAGE FILE Upload</strong></font><BR>
  <table width="64%" border="1">
    <tr> 
      <td><div align="right"><font size="2">Front View</font></div></td>
      <td><font size="2"> 
        <INPUT TYPE="FILE" NAME="FRONTVIEWFILE">
        </font></td>
    </tr>
    <tr> 
      <td><div align="right"><font size="2">Side View</font></div></td>
      <td><font size="2"> 
        <INPUT TYPE="FILE" NAME="SIDEVIEWFILE">
        </font></td>
    </tr>
    <tr>
      <td><div align="right"><font size="2">Open View</font></div></td>
      <td><font size="2">
        <INPUT TYPE="FILE" NAME="OPENVIEWFILE">
        </font></td>
    </tr>
    <tr> 
      <td width="27%"><div align="right"><font size="2">Back View</font></div></td>
      <td width="73%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="BACKVIEWFILE">
        </font></td>
    </tr>
  </table>  
  <p> 
    <INPUT TYPE="submit" value="SAVE">
  </p>
</FORM>
</body>
</html>
<%
  statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
