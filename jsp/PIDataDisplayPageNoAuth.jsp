<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
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
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入Other Feature-->
<jsp:useBean id="queryAllBean" scope="page" class="QueryAllBean"/>
<%
  String  projectCode=request.getParameter("PROJECTCODE");
  String projectCodeTemp=projectCode;
  if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+"; 
  String salesCode="",productType="",brand="",taDate="--------",taStatus="",launchDate="--------",deLaunchDate="--------";
  String bandMode="",piLength="",piWidth="",piHeight="",piWeight="",displayMain="",displaySub="";
  String camera="",cameraCode="",ringtoneCode="",phoneBook="",remark="";
  String wap_ver="",gprs_ver="",designHouse="",systemMode="",platform="";
  arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作 
  Statement statement=con.createStatement();
  Statement docstatement=con.createStatement();
  
    try
    {      		   
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
	   displayMain=docrs.getString("DISPLAYMAIN");
	   displaySub=docrs.getString("DISPLAYSUB");
	   camera=docrs.getString("CAMERA");
	   cameraCode=docrs.getString("CAMERACODE");
	   ringtoneCode=docrs.getString("RINGTONECODE");
	   phoneBook=docrs.getString("PHONEBOOK");
	   remark=docrs.getString("REMARK");
	   wap_ver=docrs.getString("WAP_VER");
	   gprs_ver=docrs.getString("GPRS_VER");
	   designHouse=docrs.getString("DESIGNHOUSE");
	   systemMode=docrs.getString("SYSTEMMODE");	 
	   platform=docrs.getString("PLATFORM");  	  
	   }  //end of docrs if		 	   
       docrs.close();
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
%>
<script language="JavaScript" type="text/JavaScript">
function showImg(pc,wv)
{   
  subWin=window.open("ShowImg.jsp?PROJECTCODE="+pc+"&WHICHVIEW="+wv,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function playMidi(RC)
{   
  subWin=window.open("PlayRinger.jsp?RINGERCODE="+RC,"subwin","width=320,height=200,scrollbars=yes,menubar=no");  
}
</script>
<html>
<head>
<title>Product Information Input Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/PIUpdate.jsp" METHOD="post">
  <font color="#0080FF" size="4"><strong><jsp:getProperty name="pageHeader" property="pgTitleName"/></strong></font><BR>    
  <table width="94%">
    <tr bgcolor="e6bbff"> 
      <td width="29%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgProjectCode"/>
          </font></div></td>
      <td width="17%" bgcolor="#FFFFFF"><font size="2"> <%=projectCode%> </font></td>
      <td width="28%"><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgSalesCode"/>
          </font></div></td>
      <td width="26%" bgcolor="#FFFFFF"><font size="2"> <%=salesCode%> </font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; 
          <jsp:getProperty name="pageHeader" property="pgProductType"/>
          </font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"> <%=productType%> </font></td>
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgBrand"/>
          </font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"> <%=brand%> </font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; TA Date</font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=taDate.substring(0,4)%>/<%=taDate.substring(4,6)%>/<%=taDate.substring(6,8)%></font></td>
      <td><div align="right"><font size="2">TA Status</font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=taStatus%></font></td>
    </tr>
    <tr bgcolor="e6bbff"> 
      <td><div align="right"><font size="2">&nbsp; 
          <jsp:getProperty name="pageHeader" property="pgLaunchDate"/>
          </font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=launchDate.substring(0,4)%>/<%=launchDate.substring(4,6)%>/<%=launchDate.substring(6,8)%>
        </font></td>
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgDeLaunchDate"/>
          </font></div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=deLaunchDate.substring(0,4)%>/<%=deLaunchDate.substring(4,6)%>/<%=deLaunchDate.substring(6,8)%>
        </font></td>
    </tr>
    <tr bgcolor="e6bbff">
      <td><div align="right">DESIGN HOUSE</div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=designHouse%></font></td>
      <td><div align="right">SYSTEM MODE</div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=systemMode%></font></td>
    </tr>
    <tr bgcolor="e6bbff">
      <td><div align="right">PLATFORM</div></td>
      <td bgcolor="#FFFFFF"><font size="2"><%=platform%> </font></td>
      <td>&nbsp;</td>
      <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  </table>
  <BR>
  <font color="#004080"><strong>SPECIFICATIONS</strong></font><BR>
  <table width="94%" border="0">
    <tr bgcolor="e6e6fa"> 
      <td width="22%"><div align="right"><font size="2">BAND MODE</font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"> <font size="2"> <%=bandMode%> </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgSize"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"> 
        <jsp:getProperty name="pageHeader" property="pgLength"/>
        : <%=piLength%> &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgWidth"/>
        : <%=piWidth%> &nbsp;x&nbsp; 
        <jsp:getProperty name="pageHeader" property="pgHeight"/>
        : <%=piHeight%> (mm) </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td> <div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgWeight"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"> <%=piWeight%> (g) </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgDisplay"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"><strong>MAIN</strong>: 
        <%=displayMain%> &nbsp;&nbsp;&nbsp;&nbsp; <strong>Sub</strong>: <%=displaySub%> </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgCamera"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"> <%=cameraCode%> </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgRingtone"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"> <font size="2"> <%=ringtoneCode%> </font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgPhonebook"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"> <%=phoneBook%> (sets)</font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"><font size="2">Connectivity</font></div></td>
      <td width="30%" bgcolor="#FFFFFF"><strong>WAP</strong>:<font size="2"><%=wap_ver%></font></td>
      <td width="48%" bgcolor="#FFFFFF"><strong>GPRS</strong>:<font size="2">&nbsp;<%=gprs_ver%></font></td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right">Message Protocol</div></td>
      <td colspan="2" bgcolor="#FFFFFF"> <font size="2"> 
        <%
		  try
          { 		                  
              ResultSet rs=statement.executeQuery("select COMMNAME from PIPRODCOMM where PROJECTCODE='"+projectCode+"'");			 			 			                         	  
              queryAllBean.setRs(rs);			 
              out.println(queryAllBean.getRsTextString());			  
			 
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
      <td><div align="right"><font size="2"> Standard Features</font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"> <%		
		   try
           {                    
              ResultSet rs=statement.executeQuery("select FEATURENAME from PIPRODFEATURES x,PIFEATURES y where x.PROJECTCODE='"+projectCode+"' and x.FeatureCode=y.FeatureCode");			 			 			                         	  
              queryAllBean.setRs(rs);			 
              out.println(queryAllBean.getRsTextString());			  
			 
			  rs.close();
		       } //end of try
           catch (Exception e)
           {
             out.println("Exception:"+e.getMessage());
           }	  	  
	    %> </td>
    </tr>
    <tr bgcolor="e6e6fa"> 
      <td><div align="right"> <font size="2"> 
          <jsp:getProperty name="pageHeader" property="pgRemark"/>
          </font></div></td>
      <td colspan="2" bgcolor="#FFFFFF"><font size="2"> <%=remark%> </font></td>
    </tr>
  </table>    
  <BR>
  <BR>
  <table width="720" border="0">
    <tr> 
      <td colspan="4"><font color="#004080"><strong>PRODUCT PICTURES</strong></font></td>
      <td width="259"><font color="#004080"><strong>Items</strong></font> </td>
      <td width="219" bgcolor="#bbbbbb"><font color="#004080"><strong>Ringer</strong></font> </td>
    </tr>
    <tr> 
      <td width="63"><A href='javaScript:showImg("<%=projectCodeTemp%>","IMGFRONTVIEW")'><img src="ShowImg.jsp?PROJECTCODE=<%=projectCodeTemp%>&WHICHVIEW=IMGFRONTVIEW" width='54' height='90' alt='NO PIC'></td>
      <td width="45"><A href='javaScript:showImg("<%=projectCodeTemp%>","IMGSIDEVIEW")'><img src="ShowImg.jsp?PROJECTCODE=<%=projectCodeTemp%>&WHICHVIEW=IMGSIDEVIEW" width='34' height='90' alt='NO PIC'></td>
      <td width="47"><A href='javaScript:showImg("<%=projectCodeTemp%>","IMGOPENVIEW")'><img src="ShowImg.jsp?PROJECTCODE=<%=projectCodeTemp%>&WHICHVIEW=IMGOPENVIEW" width='34' height='90' alt='NO PIC'></td>
      <td width="61"><A href='javaScript:showImg("<%=projectCodeTemp%>","IMGBACKVIEW")'><img src="ShowImg.jsp?PROJECTCODE=<%=projectCodeTemp%>&WHICHVIEW=IMGBACKVIEW" width='54' height='90' alt='NO PIC'></td>
      <td width="259">
        <%
    try
    {      		   
       ResultSet docrs=docstatement.executeQuery("select  unique mitem,colordesc from prodmodel,picolor_master where mproj='"+projectCode+"' and mcolor=colorcode");
       out.println("<TABLE>");	 
	   out.println("<TR BGCOLOR='e6bbff'><TH><FONT COLOR=WHITE>ITEM NO.</TH><TH><FONT COLOR=WHITE>ITEM COLOR</TH></TR>");  
       while (docrs.next())
       {
	 	out.println("<TR BGCOLOR='e6bbff'>"); 
	    out.println("<TD>"+docrs.getString("mitem")+"</TD>");
		 out.println("<TD>"+docrs.getString("colordesc")+"</TD>");
	    out.println("</TR>");
	   } //end of docrs while		 
	   out.println("</TABLE>");	  
       docrs.close();	   
	   
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
      </td>
      <td width="219" bgcolor="#bbbbbb">
        <%
    try
    {      		   
       ResultSet docrs=docstatement.executeQuery("select ringerName,'<A href=javaScript:playMidi("+'"'+"'||x.RINGERCODE||'"+'"'+")><IMG src=../image/listen.gif></A>' from PIPRODRINGER x,PIRINGER y where x.PROJECTCODE='"+projectCode+"' and x.RINGERCODE=y.RINGERCODE");
       out.println("<TABLE>");	 
	   out.println("<TR BGCOLOR='a9a9a9'><TH><FONT COLOR=WHITE>Ringer Name</TH><TH><FONT COLOR=WHITE>Play Music</TH></TR>");  
       while (docrs.next())
       {
	 	out.println("<TR BGCOLOR='dcdcdc'>"); 
	    out.println("<TD>"+docrs.getString(1)+"</TD>");
		 out.println("<TD>"+docrs.getString(2)+"</TD>");
	    out.println("</TR>");
	   } //end of docrs while		 
	   out.println("</TABLE>");
	   
       docrs.close();	  	   
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	   
  %>
      </td>
    </tr>
  </table>
</FORM>
</body>
</html>
<%
  statement.close();
  docstatement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
