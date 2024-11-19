<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<% String callMode=request.getParameter("CALLMODE"); %>
<!--=============To get the Authentication==========-->
<%  
  if (callMode==null || callMode.equals(""))
  { 
%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<% 
 }
%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>產品機種編碼</title>
<script language="JavaScript"> 
function submitCheck()
 {
  if(document.MYFORM.SPECFILE.value=="--" || document.MYFORM.SPECFILE.value==null) 
	{
	  alert("請選擇產品規格附件!");
	  return false;
    }
  else
    if(document.MYFORM.IMAGEFILE.value=="--" || document.MYFORM.IMAGEFILE.value==null)
      {
	    alert("請選擇產品附件圖形!");
	    return false;
	  }
    else
      { return true; } 
 }
</script>  
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> 
<%
  arrayCheckBoxBean.setArray2DString(null);
%>
</head>

<body>
    <%	    	     		 		 
       String appNo=request.getParameter("APPNO");      
       String modelno=null;      
       String specfile=null;      
       String imagfile=null;      
    %>
<FORM ACTION="WSDOCMNTInsert.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()' ENCTYPE="multipart/form-data">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong> 產品編碼系統-產品代碼<font color="#FF0000">規格補登</font></strong></font>&nbsp; 
  &nbsp; &nbsp;<BR>
  <A HREF="../WinsMainMenu.jsp">首頁</A> &nbsp;&nbsp;<A HREF="../jsp/WSModelEncodingSub.jsp">產品編碼管理作業</A>&nbsp;&nbsp;
  <BR>
  <%
       try
       {     
          String sSqlC = "select * from MRMODELAPP where APPNO='"+appNo+"' ";    		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          if ( rsC.next() )
          {
              modelno = rsC.getString("MODELNO");
              int modelLength = rsC.getString("MODELNO").length();
              if (modelLength<=8)
               { out.println("<font color='#990033' size='+2' face='標楷體'><strong>產品代碼 : </strong></font><font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(0,3)+"</strong></font>"+"<font size='+2' color='#FF0000' face='Arial'><strong><em>"+rsC.getString("MODELNO").substring(3,7)+"</em></strong></font>"+"<font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(7,8)+"</strong></font>"); }
              else if (modelLength==9)
			     { out.println("<font color='#990033' size='+2' face='標楷體'><strong>產品代碼 : </strong></font><font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(0,3)+"</strong></font>"+"<font size='+2' color='#FF0000' face='Arial'><strong><em>"+rsC.getString("MODELNO").substring(3,7)+"</em></strong></font>"+"<font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(7,9)+"</strong></font>"); } 
              else if (modelLength==10)
			     { out.println("<font color='#990033' size='+2' face='標楷體'><strong>產品代碼 : </strong></font><font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(0,3)+"</strong></font>"+"<font size='+2' color='#FF0000' face='Arial'><strong><em>"+rsC.getString("MODELNO").substring(3,7)+"</em></strong></font>"+"<font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO").substring(7,10)+"</strong></font>");  }      
                //out.println("<font color='#990033' size='+2' face='標楷體'><strong>產品代碼 : </strong></font><font color='#000099' size='+2' face='Arial'><strong>"+rsC.getString("MODELNO")+"</strong></font>");
	   
  %>      
  <table width="99%" border="1">
    <tr> 
      <td width="35%" height="31" bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif"> 
        申請人：</font><font color="#0000FF"> 
        <%	    	     		 		          	     
              		  		      
           Statement statePMUser=con.createStatement();		  
           ResultSet rsPMUser=statePMUser.executeQuery("select USER_NAME from MRPM_USER where WEBID='"+rsC.getString("APPLY_USER")+"'");
           if ( rsPMUser.next() ) { out.println("<strong>"+rsC.getString("APPLY_USER")+"("+rsPMUser.getString("USER_NAME")+")"+"</strong>");  }
           rsPMUser.close();
           statePMUser.close();      
  	    %>
        </font> </td>
      <td width="31%" bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">研發單位 ：</font><font color="#FF0000">&nbsp; 
        <%	    	     		 		 
         out.println("<strong>"+rsC.getString("RDESIGN_DPT")+"</strong>");
	    %>
        </font></td>
      <td width="34%" bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">申請日 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <%
          out.println("<strong>"+rsC.getString("APPLY_DATE")+"</strong>");     
        %>
        </font></td>
    </tr>
    <tr> 
      <td height="31" bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">產品別 
        :</font> <font face="Times New Roman, Times, serif">&nbsp; 
        <%	    	     		 		 
	     out.println("<strong>"+rsC.getString("PRODCLS")+"</strong>"); 
	    %>
        </font></td>
      <td bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">外觀　:</font><font face="Times New Roman, Times, serif">　<font >&nbsp; 
        <%	    	     		 		 
          try
          {  		 
		    String sSqlApp = "";
		    
		    out.println("<strong>"+rsC.getString("MODELNO").substring(2,3));
            sSqlApp = "select PROD_APPEAR from MRPROD_APRNCE where APPEAR_CODE='"+rsC.getString("MODELNO").substring(2,3)+"' ";
     	    
		  		      
            Statement stateApp=con.createStatement();		  
            ResultSet rsApp=stateApp.executeQuery(sSqlApp); 
            if ( rsApp.next() )          
            { out.println("("+rsApp.getString("PROD_APPEAR")+")"+"</strong>"); }
      
            rsApp.close();      
		    stateApp.close();		 
           } //end of try
           catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());		  
           }	    
	    %>
        </font></font></td>
      <td bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">發展平台<font size=2> 
        ：</font></font><font face="Times New Roman, Times, serif"> 
        <%	    	     		 		 
          try
          {  		 
		    String sSqlPlat= "";
		    
		    out.println("<strong>"+rsC.getString("MODELNO").substring(3,5));
            sSqlPlat = "select SPLATFM_NAME from PRPROD_PLATFORM where PLATFORM_CODE='"+rsC.getString("MODELNO").substring(3,5)+"' ";
     	    
		  		      
            Statement statePlat=con.createStatement();		  
            ResultSet rsPlat=statePlat.executeQuery(sSqlPlat); 
            if ( rsPlat.next() )          
            { out.println("("+rsPlat.getString("SPLATFM_NAME")+")"+"</strong>"); }
      
            rsPlat.close();      
		    statePlat.close();		 
           } //end of try
           catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());		  
           }			 
	    %>
        </font></td>
    </tr>
    <tr> 
      <td height="32" bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">主螢幕 
        ：</font><font face="Times New Roman, Times, serif"> 
        <%	    	     		 		 
          try
          {  		 
		    String sSqlDisplay= "";
		    
		    out.println("<strong>"+rsC.getString("MODELNO").substring(7,8));
            sSqlDisplay = "select PRODEXTEND from MRPROD_EXT where PRODEXT_CODE='"+rsC.getString("MODELNO").substring(7,8)+"' ";     	    
		  		      
            Statement stateDisplay=con.createStatement();		  
            ResultSet rsDisplay=stateDisplay.executeQuery(sSqlDisplay); 
            if ( rsDisplay.next() )          
            { out.println("("+rsDisplay.getString("PRODEXTEND")+")"+"</strong>"); }
      
            rsDisplay.close();      
		    stateDisplay.close();		 
           } //end of try
           catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());		  
           }			
	   %>
        </font></td>
      <td bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">延伸機種１：</font><font face="Times New Roman, Times, serif"> 
        <%
               
       	  modelLength = rsC.getString("MODELNO").length();
  	      if (modelLength>=9)
          {		 		 
	       try
           {  		 
		    String sSqlExt1= "";
		    
		    out.println("<strong>"+rsC.getString("MODELNO").substring(8,9));
            sSqlExt1 = "select FEATURE from MROTH_FEATURE where FTURE_CODE='"+rsC.getString("MODELNO").substring(8,9)+"' ";     	    
		  		      
            Statement stateExt1=con.createStatement();		  
            ResultSet rsExt1=stateExt1.executeQuery(sSqlExt1); 
            if ( rsExt1.next() )          
            { out.println("("+rsExt1.getString("FEATURE")+")"+"</strong>"); }
      
            rsExt1.close();      
		    stateExt1.close();		 
            } //end of try
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());		  
            }	
           } // end of if ( length() >= 9 )
           else { out.println("&nbsp;"); }		
	   %>
        </font></td>
      <td bgcolor="#FFFFFF">
<p><font color="#FF0000" face="Times New Roman, Times, serif">延伸機種２：</font><font face="Times New Roman, Times, serif"> 
        <%
         if (modelLength>=10)
         {		  	    	     		 		 
	      try
          {  		 
		    String sSqlExt2= "";
		    
		    out.println("<strong>"+rsC.getString("MODELNO").substring(9,10));
            sSqlExt2 = "select FEATURE from MROTH_FEATURE where FTURE_CODE='"+rsC.getString("MODELNO").substring(9,10)+"' ";     	    
		  		      
            Statement stateExt2=con.createStatement();		  
            ResultSet rsExt2=stateExt2.executeQuery(sSqlExt2); 
            if ( rsExt2.next() )          
            { out.println("("+rsExt2.getString("FEATURE")+")"+"</strong>"); }
      
            rsExt2.close();      
		    stateExt2.close();		 
           } //end of try
           catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());		  
           }			
         } // end of if (length() >= 10 )
         else {  out.println("&nbsp;");  }
	   %>
          </font></p>
      </td>
    </tr>
    <tr> 
      <td height="29" bgcolor="#FFFFFF"><font color="#0000FF">Buyer ：</font><font size=2> 
        <%  out.println("<strong>"+rsC.getString("BUYER")+"</strong>"); %>
        </font></td>
      <td bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">專案生效日 
        :</font><font face="Times New Roman, Times, serif"> 
        <%
          out.println("<strong>"+"("+rsC.getString("PJTTNON_DATE")+")"+"</strong>");
        %>
        </font></font></td>
      <td bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">專案截止日 
        :</font><font face="Times New Roman, Times, serif"> 
        <%
          if (rsC.getString("PJTTNOFF_DATE") != null ) { out.println("<strong>"+rsC.getString("PJTTNOFF_DATE")+"</strong>"); }
          else { out.println("&nbsp;"); }
        %>
        </font></td>
    </tr>
    <tr> 
      <td height="29" bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">建檔人 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <%   
           Statement stateEnUser=con.createStatement();		  
           ResultSet rsEnUser=stateEnUser.executeQuery("select USERNAME from WSUSER where WEBID='"+rsC.getString("ENUSER")+"'");
           if ( rsEnUser.next() ) { out.println("<strong>"+rsC.getString("ENUSER")+"("+rsEnUser.getString("USERNAME")+")"+"</strong>");  }
           rsEnUser.close();
           stateEnUser.close(); 
           //out.println("<strong>"+rsC.getString("ENUSER")+"</strong>"); 
        %></font></td>
      <td bgcolor="#FFFFFF"><font color="#0000FF" face="Arial, Helvetica, sans-serif">建檔日 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <% out.println("<strong>"+rsC.getString("ENDTIME").substring(0,8)+"</strong>"); %></font></td>
      <td bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">建檔時間 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <% out.println("<strong>"+rsC.getString("ENDTIME").substring(8,14)+"</strong>");%></font> </tr>
    <tr> 
      <td height="29" colspan="3"><font color="#0000FF" size="+1">備註 ：</font> 
        <% out.println("<strong>"+rsC.getString("REMARK")+"</strong>");%></td>
    </tr> 
     <%     
            }  // End of if (rsC.next())

            sSqlC = "select SPECFILE_NAME,IMAGEVIEW_NAME from MRMODEL_DOCMNT where APPNO='"+appNo+"' ";    		  		      
            statementC=con.createStatement();		  
            rsC=statementC.executeQuery(sSqlC);
            if ( rsC.next() )
             {
               specfile = rsC.getString("SPECFILE_NAME");
               imagfile = rsC.getString("IMAGEVIEW_NAME");
             }					   
            rsC.close();      
		    statementC.close();		 
           } //end of try
           catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());		  
           }			      
     %>       
  </table>
<BR>
<table border="0" width="100%">
    <tr> 
      <td height="116"><font color="#004080"><strong>DOCUMENT FILE Upload      </strong></font>
	  <%
               out.println("<font  color='#9900FF'>"); 
			   out.println("spec : "+specfile);
               out.println("</font>&nbsp; &nbsp;"); 
               out.println("<font  color='#990000'>"); 
			   out.println("imag : "+imagfile);
               out.println("</font>"); 
      %>
    <BR> 
        <table width="64%" border="1">
          <tr> 
            <td><div align="right"><font size="2">Specification File </font></div></td>
            <td><font size="2"> 
              <INPUT TYPE="FILE" NAME="SPECFILE">
              </font></td>
          </tr>
          <tr> 
            <td><div align="right"><font size="2">Image View</font></div></td>
            <td><font size="2"> 
              <INPUT TYPE="FILE" NAME="IMAGEFILE">
              </font></td>
          </tr>
        </table>
        <p> 
          <input type="submit" name="submit" value="存檔" >
          <em>　 
          <input type="reset" name="reset" value="取消">
          <input type="hidden" name="APPNO" value="<%= appNo %>" >
          <input type="hidden" name="MODELNO" value="<%= modelno %>" >
          </em></p></td>
  </tr> 
</table>
  
</form>
<p><em>　</em></p>
<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp; </p>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>


