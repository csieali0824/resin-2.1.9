<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<html>
<head>
<title>Item Create FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function submitCheck()
{  
  if (document.MYFORM.ITEM.value==null || document.MYFORM.ITEM.value=="")
  { 
   alert("請先輸入您欲新增的料號後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.ITEMDESC.value==null || document.MYFORM.ITEMDESC.value=="")
  { 
   alert("請先輸入您欲新增的敘述後再存檔!!");   
   return(false);
  }
  if (document.MYFORM.UOMCODE.value=="--" || document.MYFORM.UOMCODE.value==null)
  { 
   alert("請先選擇您欲新增之單位後再存檔!!");   
   return(false);
  } 
      
   return(true);      
}  
</script>
<body>
<FORM NAME="MYFORM" onsubmit='return submitCheck()' ACTION="INVItemInsert.jsp" METHOD="post">
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <!--A HREF="file:///O|/webapps/repair/jsp/MRQAll.jsp">查詢所有領料案件</A--> 
<BR>
<%
  String item=request.getParameter("ITEM");
  String itemDesc=request.getParameter("ITEMDESC");
  String uomcode = request.getParameter("UOMCODE");	
%>
  <font color="#0080FF" size="5"><strong>新增料號</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td>Item: 
        <INPUT NAME="ITEM" TYPE="text" size="15" maxlength="15"> </td>
    </tr>
    <tr> 
      <td>Item Desc: 
        <INPUT NAME="ITEMDESC" TYPE="text" size="30" maxlength="30"></td>	
    </tr>
    <tr> 
      <td>Item Uom:         
        <font color="#000000" face="Arial Black"><strong>
</strong></font><font size="2">&nbsp;
</font><font color="#000000" face="Arial Black"><strong>
<% 		 		 		 
	     try
         {		  		  
		  	      
          Statement statement=con.createStatement();
          String sql = "select unique UOMCODE as CODE,UOMCODE from INV_UOM ORDER BY CODE";     
          //out.println(sql);	      
          ResultSet rs=statement.executeQuery(sql);
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(uomcode);
	      comboBoxBean.setFieldName("UOMCODE");	   
          out.println(comboBoxBean.getRsString());		
		  if (rs.next())
		  {		   
           uomcode= rs.getString("UOMCODE");
           out.println(uomcode);	            
		  }		    
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
</strong></font><font color="#000000" face="Arial Black"><strong>        </strong></font></td>	
    </tr>	
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <!--A HREF="INVItemQueryAll.jsp">Query All Item</A--> 
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
