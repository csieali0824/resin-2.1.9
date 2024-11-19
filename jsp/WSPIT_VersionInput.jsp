<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,RsCountBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<script language="JavaScript" type="text/JavaScript"> 
 modelArray=new Array();		    
 productArray=new Array();
 
function showModel(gg)
{   
  //先將OBJECT之值歸零
   document.MYFORM.OBJECT.selectedIndex=0; 
  
  //以下為處理動態show出model   
   var productObj;
   productObj = document.MYFORM.PRODUCT;              
   
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.MODEL.options[0].value!=null)
	 {         
       document.MYFORM.MODEL.options[0] =null;		
	 }  	   
   }    
   
   if (productObj.value=="--")
   {                  
     document.MYFORM.MODEL.options[0] = new Option("--","--");
   } else {            
      for (i=0;i<productArray.length;i++)
      {  
         if (productArray[i]==productObj.value)
	     { 
	        for (j=0;j<modelArray[i].length;j++)
		    {			   			  
	          document.MYFORM.MODEL.options[j] = new Option(modelArray[i][j],""+modelArray[i][j]);
            }
	     } 
      }	
   } //end of if  =>productObj.value=="--"     
}
</script>
<html>
<head>
<title>PIT VERSION INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=null,subRs=null;
String productArray[]=null;
%>
<FORM NAME="MYFORM" ACTION="../jsp/WSPIT_VersionInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>測試發行 版本資訊</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">PRODUCT:<font size="2">
     <%      
	  try
      {     	         
        rs=statement.executeQuery("select PROD_CLASS A,PROD_CLASS B from MRPRODCLS order by A");	   
	    rsCountBean.setRs(rs); //取得其line detail總筆數
	    productArray=new String[rsCountBean.getRsCount()]; //宣告為符合其總筆數大小之陣列
			  		  		  
		  int pi=0; 
          while (rs.next())
          {     
		   int mi=0;//代表共有多少筆屬於該product的model       
           String s1=(String)rs.getString(1);            
		   productArray[pi]=s1;
		   %>
             <script language="JavaScript" type="text/JavaScript">
			  productArray[<%=pi%>]="<%=s1%>";
		      modelArray[<%=pi%>]=new Array();			    		      
		     </script>
           <%   		   		   		   		  			
			 subRs=subStmt.executeQuery("select PROJECTCODE from PIMASTER where PRODUCTTYPE='"+s1+"' order by PROJECTCODE");  
		     while (subRs.next())
		     {
		       String cn1=(String)subRs.getString(1);//專案/機種代碼 	 					   
			   %>
               <script language="JavaScript" type="text/JavaScript">			    		        			    
		        modelArray[<%=pi%>][<%=mi%>]="<%=cn1%>";
		       </script>
           <%			 			 
			   mi++;
		     } //end of while=>subRs.next()	 
		     subRs.close();
		     pi++;
           } //end of while => rs.next();
		   rs.close(); 		 		
	   
	       arrayComboBoxBean.setArrayString(productArray); 		   
		   arrayComboBoxBean.setOnChangeJS("showModel(document.MYFORM.MODEL.length)");
	       arrayComboBoxBean.setFieldName("PRODUCT");
	       out.println(arrayComboBoxBean.getArrayString());	      	           
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
      <td width="55%">MODEL:<font size="2">
      <%      
	  try
      {     	         
             out.println("<select NAME='MODEL'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");    
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
    </tr>
    <tr>
      <td>OBJECT:<font size="2">
      <%      
	  try
      {     	         
       rs=statement.executeQuery("select OBJECTID,NAME from PIT_OBJECT order by OBJECTID");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("OBJECT");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
    <td>COUNTY:<font size="2">
      <%      
	  try
      {     	         
       rs=statement.executeQuery("select LOCALE,LOCALE_ENG_NAME||'('||LOCALE||')' from WSLOCALE order by LOCALE_ENG_NAME");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("COUNTRY");	   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception ee)
       {
	     %>
		  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
		 <%
        out.println("Exception:"+ee.getMessage());
       }
       %>
    </font></td>
    </tr>
    <tr>
      <td colspan="2">VERSION :
      <INPUT TYPE="text" NAME="VERSION" size="40"></td>
    </tr>
    <tr> 
      <td colspan="2">Description of VERSION : 
        <INPUT TYPE="text" NAME="DESC" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
</FORM>
  <A HREF="WSPIT_VersionQueryAll.jsp">測試發行版本 清單</A> 
</body>
</html>
<%
  statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->