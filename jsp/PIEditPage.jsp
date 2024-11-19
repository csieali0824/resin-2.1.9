<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Switch CharacterSet==========-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="PageHeaderBean,ComboBoxBean,ArrayComboBoxBean,DateBean,CheckBoxBean,ArrayCheckBoxBean,QueryAllBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="queryAllBean" scope="page" class="QueryAllBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入Other Feature-->
<jsp:useBean id="arrayCheckBoxBean4Ringer" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入Ringer-->
<%
  String  projectCode=request.getParameter("PROJECTCODE");
  String projectCodeTemp=projectCode;
  if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
  String salesCode="",productType="",brand="",taDate="",taStatus="",launchDate="",deLaunchDate="";
  String bandMode="",piLength="",piWidth="",piHeight="",piWeight="",displayMain="",displaySub="";
  String camera="",cameraCode="",ringtoneCode="",phoneBook="",remark="",comm="";
  String wap="",wap_ver="",gprs="",gprs_ver="",designHouse="",systemMode="",platform="";  
  
  Statement statement=con.createStatement();
  
   try
   {      		   
       Statement docstatement=con.createStatement();  
       ResultSet docrs=docstatement.executeQuery("select * from PIMASTER WHERE PROJECTCODE='"+projectCode+"'");
       if  (docrs.next())
	   {
	   salesCode=docrs.getString("SALESCODE");
	   productType=docrs.getString("PRODUCTTYPE");
	   brand=docrs.getString("BRAND");
	   taDate=docrs.getString("TADATE");
	   if (taDate==null)  taDate="--------"; 
	   taStatus=docrs.getString("TASTATUS");
	   launchDate=docrs.getString("LAUNCHDATE");
	   if (launchDate==null)  launchDate="--------";
	   deLaunchDate=docrs.getString("DELAUNCHDATE");
	   if (deLaunchDate==null) deLaunchDate="--------"; 
	   bandMode=docrs.getString("BANDMODE");
	   piLength=docrs.getString("LENGTH");
	   piWidth=docrs.getString("WIDTH");
	   piHeight=docrs.getString("HEIGHT");	   
	   piWeight=docrs.getString("WEIGHT");
	   if (piWeight==null) piWeight="";
	   displayMain=docrs.getString("DISPLAYMAIN");
	   displaySub=docrs.getString("DISPLAYSUB");
	   camera=docrs.getString("CAMERA");
	   cameraCode=docrs.getString("CAMERACODE");
	   ringtoneCode=docrs.getString("RINGTONECODE");
	   phoneBook=docrs.getString("PHONEBOOK");
	   remark=(String)docrs.getString("REMARK");
	   wap=docrs.getString("WAP");
	   wap_ver=docrs.getString("WAP_VER");
	   gprs=docrs.getString("GPRS");
	   gprs_ver=docrs.getString("GPRS_VER");
	   designHouse=docrs.getString("DESIGNHOUSE");
	   systemMode=docrs.getString("SYSTEMMODE");	
	   platform=docrs.getString("PLATFORM");   	   	  
	   }  //end of docrs if		 
	  
       docrs.close(); 	  
	   docstatement.close();       
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
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
<FORM NAME="MYFORM" ACTION="../jsp/PIUpdate.jsp?PROJECTCODE=<%=projectCodeTemp%>" METHOD="post" ENCTYPE="multipart/form-data">
  <font color="#0080FF" size="4"><strong><jsp:getProperty name="pageHeader" property="pgTitleName"/>
  </strong></font>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='/wins/WinsMainMenu.jsp'><font size="2">HOME</font></A>
  &nbsp;&nbsp;&nbsp;&nbsp;<A HREF='PIQueryAll.jsp'><font size="2">Query all Product Information </font></A><BR>
  <table width="94%">
    <tr bgcolor="e6bbff"> 
      <td width="27%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgProjectCode"/>
          </font></div></td>
      <td width="18%"><font size="2"> <%=projectCode%> </font></td>
      <td width="25%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgSalesCode"/>
          </font></div></td>
      <td width="30%"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="SALESCODE" SIZE=8 value="<%=salesCode%>">
        </font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; 
          <jsp:getProperty name="pageHeader" property="pgProductType"/>
          </font></div></td>
      <td><font size="2">         
        <%      
	  try
      {     	         
       ResultSet rs= statement.executeQuery("select PROD_CLASS A,PROD_CLASS B from MRPRODCLS order by A");	   
	   comboBoxBean.setRs(rs);	
	   comboBoxBean.setSelection(productType);   
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
	    comboBoxBean.setSelection(brand);
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
	   arrayComboBoxBean.setSelection(taDate.substring(0,4));
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
	   arrayComboBoxBean.setSelection(taDate.substring(4,6)); 	   
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
	   arrayComboBoxBean.setSelection(taDate.substring(6,8)); 	   
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
        <INPUT TYPE="TEXT" NAME="TASTATUS" size="12" value="<%=taStatus%>">
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
	   arrayComboBoxBean.setSelection(launchDate.substring(0,4));	   
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
	   arrayComboBoxBean.setSelection(launchDate.substring(4,6));	   
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
	   arrayComboBoxBean.setSelection(launchDate.substring(6,8));  
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
	   arrayComboBoxBean.setSelection(deLaunchDate.substring(0,4));	  
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
	   arrayComboBoxBean.setSelection(deLaunchDate.substring(4,6));	 
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
	   arrayComboBoxBean.setSelection(deLaunchDate.substring(6,8));	 	   
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
      <td><font size="2">        <%      
	  try
      {     	         
       ResultSet rs=statement.executeQuery("select RDDPT A,RDDPT B from MRDPT order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setSelection(designHouse);
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
	   comboBoxBean.setSelection(systemMode);
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
	   comboBoxBean.setSelection(platform);
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
  <table width="94%" border="0">
    <tr bgcolor="e6e6fa"> 
      <td width="15%"><div align="right"><font size="2">BAND MODE</font></div></td>
      <td colspan="2"> <font size="2"> 
        <%      
	  try
      {       	         
       ResultSet rs=statement.executeQuery("select BANDMODE AA,BANDMODE BB from PIBANDMODE order by AA");	   
	   comboBoxBean.setRs(rs);
	   comboBoxBean.setSelection(bandMode);	   
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
        <INPUT TYPE="TEXT" NAME="LENGTH" size=5 value="<%=piLength%>">
        &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgWidth"/>
        : 
        <INPUT TYPE="TEXT" NAME="WIDTH" size=5 value="<%=piWidth%>">
        &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgHeight"/>
        : 
        <INPUT TYPE="TEXT" NAME="HEIGHT" size=5 value="<%=piHeight%>">
        (mm) </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td> <div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgWeight"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="WEIGHT" size=5 value="<%=piWeight%>">
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
	   comboBoxBean.setSelection(displayMain);
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
	   comboBoxBean.setSelection(displaySub);
	   comboBoxBean.setFieldName("DISPLAYSUB");	   
       out.println(comboBoxBean.getRsString());	   
	  
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        &nbsp; </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgCamera"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <%
	    if (camera.equals("Y"))
		{
		  out.println("<INPUT TYPE='radio' NAME='CAMERA' VALUE='Y' CHECKED>YES<INPUT TYPE='radio' NAME='CAMERA' VALUE='N'>NO");
		} else {
		  out.println("<INPUT TYPE='radio' NAME='CAMERA' VALUE='Y'>YES<INPUT TYPE='radio' NAME='CAMERA' VALUE='N' CHECKED>NO");
		}
	  %>
        &nbsp;&nbsp;&nbsp;&nbsp; CAMERA Specifics: 
        <%      
	  try
      {       	        
       ResultSet rs=statement.executeQuery("select CAMERANAME A1,CAMERANAME B1 from PICAMERA order by A1");	   
	   comboBoxBean.setRs(rs);	 
	   comboBoxBean.setSelection(cameraCode);	  
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
       ResultSet rs=statement.executeQuery("select RINGTONECODE A2,RINGTONECODE B2 from PIRINGTONE order by A2");	   
	   comboBoxBean.setRs(rs);	 
	   comboBoxBean.setSelection(ringtoneCode);  
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
        <INPUT TYPE="TEXT" NAME="PHONEBOOK" size="5" value="<%=phoneBook%>">
        (sets)</font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right">Connectivity</div></td>
      <td width="37%"><strong>WAP</strong>:<font size="2"> 
        <%
	    if (wap.equals("Y"))
		{
		  out.println("<INPUT TYPE='radio' NAME='WAP' VALUE='Y' CHECKED>YES<INPUT TYPE='radio' NAME='WAP' VALUE='N'>NO");
		} else {
		  out.println("<INPUT TYPE='radio' NAME='WAP' VALUE='Y'>YES<INPUT TYPE='radio' NAME='WAP' VALUE='N' CHECKED>NO");
		}
  %>
        &nbsp;&nbsp; WAP Ver: 
        <%      
	  try
      {       	         
       ResultSet rs=statement.executeQuery("select CONNNAME A3,CONNNAME B3 from PICONN order by A3");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("WAP_VER");	   
	   comboBoxBean.setSelection(wap_ver);
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
        <%
	    if (gprs.equals("Y"))
		{
		  out.println("<INPUT TYPE='radio' NAME='GPRS' VALUE='Y' CHECKED>YES<INPUT TYPE='radio' NAME='GPRS' VALUE='N'>NO");
		} else {
		  out.println("<INPUT TYPE='radio' NAME='GPRS' VALUE='Y'>YES<INPUT TYPE='radio' NAME='GPRS' VALUE='N' CHECKED>NO");
		}
	  %>
        &nbsp;&nbsp; GPRS Ver: 
        <%      
	  try
      {       	         
       ResultSet rs=statement.executeQuery("select CONNNAME A4,CONNNAME B4 from PICONN order by A4");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("GPRS_VER");
	   comboBoxBean.setSelection(gprs_ver);	   
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
		 try 
		 {		     		    
             ResultSet rs=statement.executeQuery("select COMMNAME from PIPRODCOMM where PROJECTCODE='"+projectCode+"'");			 			 			                         	  
             queryAllBean.setRs(rs);			 
             comm=queryAllBean.getRsTextString();			  
    		 rs.close();				
              
              rs=statement.executeQuery("select COMMNAME,COMMNAME from PICOMM");			 			 			  
              checkBoxBean.setRs(rs);
			  checkBoxBean.setChecked(comm);
	          checkBoxBean.setFieldName("COMM");
	          checkBoxBean.setColumn(6); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  			 
			  rs.close();
		   }
		    catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());
            }	  
	    %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <input name="button" type=button onClick="btnAddFeatures()" value="Standard Features:">
          </font></div></td>
      <td><font size="2"> 
        <%
		  //this field means to get the all features to arrayCheckBoxBean		     
		  try
		  {		     
             ResultSet rs=statement.executeQuery("select count (*) from PIPRODFEATURES where PROJECTCODE='"+projectCode+"'");			 			 			                         	  
			 rs.next();
             int featureCount=rs.getInt(1);			 
             rs.close();
			 if (featureCount>0) //if there are some features exists
			 {
    			 String t[][]=new String[featureCount][2];
	     		 rs=statement.executeQuery("select x1.FEATURECODE,x2.FEATURENAME from PIPRODFEATURES x1,PIFEATURES x2 where x1.PROJECTCODE='"+projectCode+"' and x1.FEATURECODE=x2.FEATURECODE order by x1.FEATURECODE");			  
                 int i=0;			 
			     while (rs.next())
			     {
			      t[i][0]=rs.getString("FEATURECODE");
			      t[i][1]=rs.getString("FEATURENAME");
			      i++;
			     }    		
    		     arrayCheckBoxBean.setArray2DString(t);			     
			     rs.close();
			  } else {
			     arrayCheckBoxBean.setArray2DString(null);
			  } 	 
		  } //end of try
		  catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }	  
	    %>
        </font></td>
      <td><font size="2"> 
        <input name="button2" type=button onClick="btnAddRinger()" value="Add Ringer:">
        <%
		  //this field means to get the all ringers to arrayCheckBoxBean		     
		  try
		  {		     
             ResultSet rs=statement.executeQuery("select count (*) from PIPRODRINGER where PROJECTCODE='"+projectCode+"'");			 			 			                         	  
			 rs.next();
             int ringerCount=rs.getInt(1);			 
             rs.close();
			 if (ringerCount>0) //if there are some ringer exists
			 {
    			 String t[][]=new String[ringerCount][2];
	     		 rs=statement.executeQuery("select x1.RINGERCODE,x2.RINGERNAME from PIPRODRINGER x1,PIRINGER x2 where x1.PROJECTCODE='"+projectCode+"' and x1.RINGERCODE=x2.RINGERCODE order by x1.RINGERCODE");			  
                 int i=0;			 
			     while (rs.next())
			     {
			      t[i][0]=rs.getString("RINGERCODE");
			      t[i][1]=rs.getString("RINGERNAME");
			      i++;
			     }    		
    		     arrayCheckBoxBean4Ringer.setArray2DString(t);			     
			     rs.close();
			  } else {
			     arrayCheckBoxBean4Ringer.setArray2DString(null);
			  } 	 
		  } //end of try
		  catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }	  
	    %>
        </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgRemark"/>
          </font></div></td>
      <td colspan="2"><font size="2"> 
        <INPUT TYPE="TEXT" NAME="REMARK" size=40 value="<%=remark%>">
        </font></td>
    </tr>
  </table>  
  <BR>
  <font color="#004080"><strong>IMAGE FILE Upload</strong></font>
  &nbsp;&nbsp;<input type="checkbox" name="DELEXAMPLE" value="Y" checked>
  <strong><font color="#FF0000">Delete the picture!!</font></strong><BR>
  <table width="67%" border="1">
    <tr>
      <td width="6%"><input type="checkbox" name="DELFRONTVIEW" value="Y">
      </td>
      <td width="16%"><div align="right"><font size="2">Front View</font></div></td>
      <td width="78%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="FRONTVIEWFILE">
        </font></td>
    </tr>
    <tr>
      <td><input type="checkbox" name="DELSIDEVIEW" value="Y"></td>
      <td><div align="right"><font size="2">Side View</font></div></td>
      <td><font size="2"> 
        <INPUT TYPE="FILE" NAME="SIDEVIEWFILE">
        </font></td>
    </tr>
    <tr>
      <td><input type="checkbox" name="DELOPENVIEW" value="Y"></td>
      <td><div align="right"><font size="2">Open View</font></div></td>
      <td><font size="2"> 
        <INPUT TYPE="FILE" NAME="OPENVIEWFILE">
        </font></td>
    </tr>
    <tr>
      <td><input type="checkbox" name="DELBACKVIEW" value="Y"></td>
      <td><div align="right"><font size="2">Back View</font></div></td>
      <td><font size="2"> 
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
