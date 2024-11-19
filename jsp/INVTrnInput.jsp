<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>TrnInputPage.jsp</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function submitCheck(URL)
{ 
  if (document.MYFORM.PROJECT.value=="" || document.MYFORM.PROJECT.value==null)
  { 
   alert("請先輸入專案代碼後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.REMARK.value=="" || document.MYFORM.REMARK.value==null)
  { 
   alert("請先輸入事由後再存檔!!");   
   return(false);
  } 
  
  if (document.MYFORM.ITEM1.value=="" || document.MYFORM.ITEM1.value==null)
  { 
   alert("請先輸入您欲轉出之料號後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.WHS1.value=="" || document.MYFORM.WHS1.value==null)
  { 
   alert("請先輸入轉出倉別後再存檔!!");   
   return(false);
  } 
 
  if (document.MYFORM.LOC1.value=="" || document.MYFORM.LOC1.value==null)
  { 
   alert("請先輸入轉出架位後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.ITEM6.value=="" || document.MYFORM.ITEM6.value==null)
  { 
   alert("請先輸入您欲轉入之料號後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.WHS6.value=="" || document.MYFORM.WHS6.value==null)
  { 
   alert("請先輸入轉入倉別後再存檔!!");   
   return(false);
  } 
 
  if (document.MYFORM.LOC6.value=="" || document.MYFORM.LOC6.value==null)
  { 
   alert("請先輸入轉入架位後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert("請先選擇您欲執行之動作後再存檔!!");   
   return(false);
  }  
       
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入故障描述-->
<%
  arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
</head>
<body>
<FORM ACTION="/wins/jsp/INVTrnInsert.jsp" METHOD="post" NAME="MYFORM" onSubmit="return submitCheck()">
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <!--A HREF="file:///O|/webapps/repair/jsp/MRQAll.jsp">查詢所有領料案件</A--> 
  <BR>
  <font color="#0080FF" size="5"><strong>移轉單作業
  <% 
	    String project=request.getParameter("PROJECT");
	    String remark=request.getParameter("REMARK");		
   	    String actionID=request.getParameter("ACTIONID");		
  %>
  </strong></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong><font color="#0000FF" size="+2" face="Arial">
  </font></strong>  
  <table width="96%" border="1">
    <tr>
      <td colspan="2">填表人: <%=userID+"("+UserName+")"%> <br>
      </td>
      <td colspan="2"> 專案代碼:
          <input type="TEXT" name="PROJECT" size=15 maxlength="15"></td>
      <td colspan="1"> 異動類型:T-轉撥</td>
      <td colspan="3"> 事由:
          <input type="TEXT" name="REMARK" size=30 maxlength="30"></td>
    </tr>
    <tr>
      <td colspan="4">From</td>
      <td colspan="4">To</td>
    </tr>
    <tr>
      <td> 1:</td>	
      <td> 料號:
          <input type="TEXT" name="ITEM1" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS1" size="2" maxlength="2" value="CE" ></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC1" size="6" maxlength="6"></td>
      <td> 料號:
          <input type="TEXT" name="ITEM6" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS6" size="2" maxlength="2"value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC6" size="6" maxlength="6"></td>
      <td> 數量
      <input type="text" name="QTY6" SIZE=3 VALUE=1></td>  	  
    </tr>
    <tr>
      <td> 2:</td>		
      <td> 料號:
          <input type="TEXT" name="ITEM2" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS2" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC2" size="6" maxlength="6"></td>	  
      <td> 料號:
          <input type="TEXT" name="ITEM7" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS7" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC7" size="6" maxlength="6"></td>
      <td> 數量
      <input type="text" name="QTY7" SIZE=3 VALUE=1></td>  	  
    </tr>
    <tr>
      <td> 3:</td>		
      <td> 料號:
          <input type="TEXT" name="ITEM3" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS3" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC3" size="6" maxlength="6"></td> 	  
      <td> 料號:
          <input type="TEXT" name="ITEM8" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS8" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC8" size="6" maxlength="6"></td>
      <td> 數量
      <input type="text" name="QTY8" SIZE=3 VALUE=1></td>  	  
    </tr>
    <tr>
      <td> 4:</td>		
      <td> 料號:
          <input type="TEXT" name="ITEM4" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS4" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC4" size="6" maxlength="6"></td>	  
      <td> 料號:
          <input type="TEXT" name="ITEM9" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS9" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC9" size="6" maxlength="6"></td>
      <td> 數量
      <input type="text" name="QTY9" SIZE=3 VALUE=1></td>  	  
    </tr>
    <tr>
      <td> 5:</td>		
      <td> 料號:
          <input type="TEXT" name="ITEM5" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS5" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC5" size="6" maxlength="6"></td>	  
      <td> 料號:
          <input type="TEXT" name="ITEM10" size=20 maxlength="20"></td>
      <td> 倉別
      <INPUT TYPE="text" NAME="WHS10" size="2" maxlength="2" value="CE"></td>
      <td> 架位      
      <INPUT TYPE="text" NAME="LOC10" size="6" maxlength="6"></td>
      <td> 數量
      <input type="text" name="QTY10" SIZE=3 VALUE=1></td>  	  
    </tr>					
  </table>
  <BR>
  <strong><font color="#FF0000">可執行動作-&gt;</font></strong>
<%
	  try
      {       
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select distinct x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1,WSWFACTION x2 WHERE FORMID='RD'AND TYPENO='001' AND FROMSTATUSID='009' AND x1.ACTIONID=x2.ACTIONID");
       comboBoxBean.setRs(rs);
	   comboBoxBean.setFieldName("ACTIONID");	   
       out.println(comboBoxBean.getRsString());
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>

  <p> 
	<INPUT TYPE="button" value='執行' onClick='submitCheck("../jsp/INVTrnInsert.jsp")'>
  </p>
  <p>
  <!-- 表單參數 -->  
    <input name="FORMID" type="HIDDEN" value="RD">	
    <input name="FROMSTATUSID" type="HIDDEN" value="009">
  </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

