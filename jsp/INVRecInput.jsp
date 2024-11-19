<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>INVRecInputPage.jsp</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
var chkflag="false";
function buttonContent()
{ 
  subWin=window.open("subwindow/AddItemSubWindow.jsp","subwin","width=600,height=400,scrollbars=yes,menubar=no"); 
  chkflag = "true"; 
}

function submitCheck(URL,dim1,dim2)
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
    
  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert("請先選擇您欲執行之動作後再存檔!!");   
   return(false);
  }  


   if (chkflag=="false")  
   {
       alert("請先選擇料件後再存檔!!");   
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
<FORM ACTION="/wins/jsp/INVRecInsert.jsp" METHOD="post" NAME="MYFORM" onSubmit="return submitCheck()">
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <!--A HREF="file:///O|/webapps/repair/jsp/MRQAll.jsp">查詢所有領料案件</A--> 
  <BR>
  <font color="#0080FF" size="5"><strong>入庫單新增
  <% 
	    String project=request.getParameter("PROJECT");
	    String remark=request.getParameter("REMARK");		
   	    String actionID=request.getParameter("ACTIONID");		
		//String userID = "B02260";
		//String userName ="MARK CHEN";
  %>
  </strong></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong><font color="#0000FF" size="+2" face="Arial">
  </font></strong>  
  <table width="96%" border="1">
    <tr> 
      <td colspan="2">填表人: <%=userID+"("+UserName+")"%>       <BR> </td>   
	  <td width="28%"> 專案代碼:
      <INPUT TYPE="TEXT" NAME="PROJECT" SIZE=15 maxlength="15"></td>
    </tr>
	<tr>	  
	  <td width="34%"> 異動類型:P-採購入庫</td>
	  <td width="38%"> 事由:
      <INPUT TYPE="TEXT" NAME="REMARK" SIZE=30 maxlength="30"></td>
      <td colspan="3"><input name="button3" type=button onClick="buttonContent()" value="料號:">
      </td>	  
	</tr>
  </table>  
  <p>
    <strong><font color="#FF0000">可執行動作-&gt;</font></strong> 
    <%
	  try
      {       
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select distinct x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1,WSWFACTION x2 WHERE FORMID='RD'AND TYPENO='001' AND FROMSTATUSID='001' AND x1.ACTIONID=x2.ACTIONID");
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
<% 
      int div1=0,div2=0;      //¢FX¢Gg?¢FX1Boa|@|3|h?O-OrowcMcolumn?e?JAa|iaoAU?A
	  try
      {	//out.println("Step6");
	    String a[][]=arrayCheckBoxBean.getArray2DContent();//!Lu!Oo¢FDO?e¢FX}|C?oRe 
        	    		                       		    		  	   
         if (a!=null) 
		 {//out.println("Step7");
		        div1=a.length;
				div2=a[0].length;
	        	//arrayCheckBoxBean.setFieldName("ADDITEMS");			
                //out.println("Step8");   			 	   			 
                out.println(arrayCheckBoxBean.getArray2DString());
                //out.println("Step9");        		   	 				
		 }	//enf of a!=null if           
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
  </div>
  <p> 
    <INPUT TYPE="button" value='執行' onClick='submitCheck("../jsp/INVRecInsert.jsp",<%=div1%>,<%=div2%>)'>
  </p>
  <p>
  <!-- 表單參數 -->  
    <input name="FORMID" type="HIDDEN" value="RD">	
    <input name="FROMSTATUSID" type="HIDDEN" value="001">
  </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

