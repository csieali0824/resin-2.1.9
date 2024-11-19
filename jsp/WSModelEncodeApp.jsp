<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>

<title>產品機種編碼</title>

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
       String chooseItem=request.getParameter("chooseItem");
       String FTURE_CODE=request.getParameter("FTURE_CODE");
       String FTURE_CODE2=request.getParameter("FTURE_CODE2");
       String userName=request.getParameter("userName");
	   String nxSerNo=request.getParameter("NXSERNO");
       //String userID = "B01815"; 
    %>
<FORM NAME="MYFORM" ACTION="../jsp/WSModelCodeInsert.jsp" METHOD="post" onSubmit='return submitCheck()' ENCTYPE="multipart/form-data" >
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>  產品編碼系統-產品代碼新增 </strong></font> &nbsp; &nbsp; &nbsp; 
  &nbsp;<BR>
  <A HREF="../WinsMainMenu.jsp">首頁</A> &nbsp;&nbsp;<A HREF="../jsp/WSModelEncodingSub.jsp">產品編碼管理作業</A> 
  &nbsp;&nbsp;<A HREF="../jsp/WSModelCodeQuery.jsp">產品代碼註銷</A>&nbsp;&nbsp;<A HREF="../jsp/WSModelCodeActive.jsp">產品代碼復原</A>&nbsp;&nbsp;<A HREF="../jsp/WSMRModelEncodingInquiry.jsp">產品代碼查詢</A> 
  &nbsp;&nbsp;<A HREF="../jsp/WSDOCMNTQuery.jsp">補登產品規格</A> 
  <table width="99%" border="1">
    <tr> 
      <td width="35%" height="39" bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif"> 
        申請人：</font><font color="#0000FF" size=2> 
        <%	    	     		 		 
         String WEBID=request.getParameter("WEBID");  
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select WEBID as x, USER_NAME from MRPM_USER ";
     	   sWhereC= "where WEBID IS NOT NULL order by USER_NAME"; 
           sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(WEBID);		  		  		  
	      comboBoxBean.setFieldName("WEBID");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font> </td>
      <td width="31%" bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">研發單位 
        ：</font><font color="#FF0000" size=2>&nbsp; 
        <%	    	     		 		 
         String RD_CODE=request.getParameter("RD_CODE");
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select RD_CODE as x, RDDPT from MRDPT ";
     	   sWhereC= "where RD_CODE IS NOT NULL order by x"; 
		   sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(RD_CODE);		  		  		  
	      comboBoxBean.setFieldName("RD_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td width="34%" bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">申請日 
        :</font><font color="#0000FF" size=2 face="Times New Roman, Times, serif">&nbsp; 
        </font><font color="#0000FF" face="Arial, Helvetica, sans-serif"><%=dateBean.getYearMonthDay()%></font><font color="#0000FF" size=2 face="Times New Roman, Times, serif">&nbsp; 
        </font></td>
    </tr>
    <tr> 
      <td height="40" bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">產品別 
        :</font> <font size="2" face="Times New Roman, Times, serif">&nbsp; 
        <%	    	     		 		 
	     try
         {  		 
         String PCLS_CODE=request.getParameter("PCLS_CODE");
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select PCLS_CODE as x, PROD_CLASS from MRPRODCLS ";
     	   sWhereC= "where PCLS_CODE IS NOT NULL order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(PCLS_CODE);		  		  		  
	      comboBoxBean.setFieldName("PCLS_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">外觀　:</font><font face="Times New Roman, Times, serif">　<font size=2>&nbsp; 
        <%	    	     		 		 
         String APPEAR_CODE=request.getParameter("APPEAR_CODE");
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select APPEAR_CODE as x, PROD_APPEAR from MRPROD_APRNCE ";
     	   sWhereC= "where APPEAR_CODE IS NOT NULL order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(APPEAR_CODE);		  		  		  
	      comboBoxBean.setFieldName("APPEAR_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></font><font size="2">&nbsp; </font></td>
      <td bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">發展平台<font size=2> 
        ：</font></font><font size=2 face="Times New Roman, Times, serif"> 
        <%	    	     		 		 
         String PLATFORM_CODE=request.getParameter("PLATFORM_CODE");
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select PLATFORM_CODE as x, vnd_name || '('||SPLATFM_NAME ||')' from PRPROD_PLATFORM ";
     	   sWhereC= "where PLATFORM_CODE IS NOT NULL order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(PLATFORM_CODE);		  		  		  
	      comboBoxBean.setFieldName("PLATFORM_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
    </tr>
    <tr> 
      <td height="41" bgcolor="#FFFFFF"><font color="#FF0000" face="Times New Roman, Times, serif">主螢幕 
        ：</font><font size=2 face="Times New Roman, Times, serif"> 
        <%	    	     		 		 
         String PRODEXT_CODE=request.getParameter("PRODEXT_CODE");
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
          sSqlC = "select PRODEXT_CODE as x, PRODEXTEND from MRPROD_EXT ";
     	  sWhereC= "where PRODEXT_CODE IS NOT NULL order by x"; 
	      sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(PRODEXT_CODE);		  		  		  
	      comboBoxBean.setFieldName("PRODEXT_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td bgcolor="#FFFFFF"></font><font color="#FF0000" face="Times New Roman, Times, serif">延伸機種１：</font><font size=2 face="Times New Roman, Times, serif"> 
        <%	    	     		 		 
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";

          sSqlC = "select FTURE_CODE as x, FEATURE from MROTH_FEATURE ";
          sWhereC= "where FTURE_CODE IS NOT NULL "; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(FTURE_CODE);		  		  		  
	      comboBoxBean.setFieldName("FTURE_CODE");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td bgcolor="#FFFFFF"> 
        <p><font color="#FF0000" face="Times New Roman, Times, serif">延伸機種２：</font><font size=2 face="Times New Roman, Times, serif"> 
          <%	    	     		 		 
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";

          sSqlC = "select FTURE_CODE as x, FEATURE from MROTH_FEATURE ";
          sWhereC= "where FTURE_CODE IS NOT NULL order by x"; 
 		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);

          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(FTURE_CODE);		  		  		  
	      comboBoxBean.setFieldName("FTURE_CODE2");	   
          out.println(comboBoxBean.getRsString());
		   	  		  		  

      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
          </font></p>
      </td>
    </tr>
    <tr> 
      <td height="40" bgcolor="#FFFFFF"><font color="#0000FF">Buyer ：</font><font size=2> 
        <select name="BUYER">
          <option value="DBTEL">DBTEL</option>
        </select>
        </font></td>
      <td><font size=2>&nbsp; </font></td>
      <td bgcolor="#FFFFFF"><font color="#0000FF" face="Times New Roman, Times, serif">專案生效日 
        :</font><font size=2 face="Times New Roman, Times, serif"> 
        <%
         String PJTNYEAR=request.getParameter("PJTNYEAR");
         String PJTNMONTH=request.getParameter("PJTNMONTH");
         String PJTNHDAY=request.getParameter("PJTNHDAY");
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
       arrayComboBoxBean.setArrayString(a);	   
	   arrayComboBoxBean.setSelection(dateBean.getYearString());
	   arrayComboBoxBean.setFieldName("PJTNYEAR");	   
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
	   arrayComboBoxBean.setSelection(dateBean.getMonthString());     	   
	   arrayComboBoxBean.setFieldName("PJTNMONTH");	   
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
	   arrayComboBoxBean.setSelection(dateBean.getDayString());
	   arrayComboBoxBean.setFieldName("PJTNHDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </font></td>
    </tr>
    <tr> 
      <td height="38" bgcolor="#FFCCCC"><font color="#0000FF" face="Times New Roman, Times, serif">建檔人 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <%=userID
	   %></font></td>
      <td bgcolor="#FFCCCC"><font color="#0000FF" face="Arial, Helvetica, sans-serif">建檔日 
        :</font><font color="#0000FF" face="Arial, Helvetica, sans-serif"> 
        <%=dateBean.getYearMonthDay()%></font></td>
      <td bgcolor="#FFCCCC"><font color="#0000FF" face="Times New Roman, Times, serif">建檔時間 
        :</font><font color="#0000FF" face="Times New Roman, Times, serif"> 
        <%=dateBean.getHourMinuteSecond()%></font> </tr>
    <tr> 
      <td height="38"><font color="#0000FF">備註 ：</font> 
        <input name="REMARK" type="text" maxlength="30"></td>
      <td height="38" ><font color="#0000FF">往下序號：</font> 
        <input type="checkbox" name="NXSERNO" value="Y" checked onClick="submitCheck2('../jsp/WSModelEncodeApp.jsp')"></td>
      <td height="38"><font color="#0000FF">序號 ：</font> 
        <input name="SERNO" type="text" maxlength="2" value="--"></td>
    </tr>
   
  </table>
   <BR>
  <font color="#004080"><strong>DOCUMENT FILE Upload</strong></font><BR>
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
    </em> </p>
</form>
<p><em>　</em></p>
<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp; </p>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

<script language="JavaScript"> 
function submitCheck()
 {

  if(document.MYFORM.WEBID.value=="--" || document.MYFORM.WEBID.value==null) 
	{
	  alert("請選擇申請人!");
	  return false;
    }
  else
    if(document.MYFORM.RD_CODE.value=="--" || document.MYFORM.RD_CODE.value==null)
      {
	    alert("請選擇研發單位!");
	    return false;
	  }
 	else
 	  if(document.MYFORM.PCLS_CODE.value=="--" || document.MYFORM.PCLS_CODE.value==null)
	    {
	      alert("請選擇產品別!");
	      return false;
	    }
 	  else
        if(document.MYFORM.APPEAR_CODE.value=="--" || document.MYFORM.APPEAR_CODE.value==null)
	      {
	        alert("請選擇產品外觀!");
			return false;
	      }
 	    else
    	  if(document.MYFORM.PLATFORM_CODE.value=="--" || document.MYFORM.PLATFORM_CODE.value==null)
	        {
	          alert("請選擇發展平台!");
		      return false;
	        }
   	      else
    	    if(document.MYFORM.PRODEXT_CODE.value=="--" || document.MYFORM.PRODEXT_CODE.value==null)
	          {
	            alert("請選擇主螢幕!");
			    return false;
	          }
            else 
              if (document.MYFORM.NXSERNO.value !="Y" && document.MYFORM.NXSERNO.value!=null)
    	        {
                  if (document.MYFORM.SERNO.value=="--" || document.MYFORM.SERNO.value==null)
	                {
	                  alert("請輸入序號!");
                      return false;
	                }
			      else
				    {
                      if ((document.MYFORM.FTURE_CODE.value=="--" || document.MYFORM.FTURE_CODE.value==null) && (document.MYFORM.FTURE_CODE2.value=="--" || document.MYFORM.FTURE_CODE2.value==null))
                        {
            	            alert("請選擇延伸機種!");
            			    return false;
                        }
					  else
           			   return true;
					}   
				}
		      else
			    return true;		 		

 }
 
function submitCheck2()
{ 
  if (document.MYFORM.NXSERNO.checked)
     document.MYFORM.NXSERNO.value = 'Y';
  else
     document.MYFORM.NXSERNO.value = 'N';

//  alert(document.MYFORM.NXSERNO.value);
  document.MYFORM.action=URL;
  document.MYFORM.submit();
}
</script>  
