<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ArrayChkBox4PITBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ForecastInputBean,ForePriCostInputBean,RsCountBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="ArrayChkBox4PITBean" scope="session" class="ArrayChkBox4PITBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<script language="JavaScript" type="text/JavaScript">
 versionArray=new Array();
 modelArray=new Array();		    
 productArray=new Array();
 
function setSubmit()
{  
   if (document.MYFORM.PRODUCT.value=="--" || document.MYFORM.PRODUCT.value==null || document.MYFORM.PRODUCT.value=="")
  { 
   alert("Please Check the PRODUCT!!It should not be null or blanked");   
   return(false);
  } 

   if (document.MYFORM.MODEL.value=="--" || document.MYFORM.MODEL.value==null || document.MYFORM.MODEL.value=="")
  { 
   alert("Please Check the MODEL!!It should not be null or blanked");   
   return(false);
  } 

  if (document.MYFORM.OBJECT.value=="--" || document.MYFORM.OBJECT.value==null || document.MYFORM.OBJECT.value=="")
  { 
   alert("Please Check the OBJECT!!It should not be null or blanked");   
   return(false);
  }  
  
  if (document.MYFORM.VERSION.value=="--" || document.MYFORM.VERSION.value==null || document.MYFORM.VERSION.value=="")
  { 
   alert("Please Check the VERSION!!It should not be null or blanked");   
   return(false);
  } 
     
  if (document.MYFORM.SOURCE.value=="--" || document.MYFORM.SOURCE.value==null || document.MYFORM.SOURCE.value=="")
  { 
   alert("Please Check the SOURCE!!It should not be null or blanked");   
   return(false);
  } 	 
	 
 document.MYFORM.submit();
}

function showSource()
{        
   var sourceObj;  
   sourceObj = document.MYFORM.SOURCE;   
   
   var str1=sourceObj.options[sourceObj.selectedIndex].text;
   document.MYFORM.SOURCENAME.value=str1; //將名稱寫入隱藏參數欄位  
}

function showVersion(gg)
{      
   var productObj,modelObj,objectObj;
   productObj = document.MYFORM.PRODUCT;
   modelObj = document.MYFORM.MODEL;
   objectObj = document.MYFORM.OBJECT;
   
   var str1=objectObj.options[objectObj.selectedIndex].text;
   document.MYFORM.OBJECTNAME.value=str1; //將名稱寫入隱藏參數欄位
  
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.VERSION.options[0].value!=null)
	 {         
       document.MYFORM.VERSION.options[0] =null;		
	 }  	   
   }

   if (objectObj.value=="--")
   {                  
     document.MYFORM.VERSION.options[0] = new Option("--","--");
   } else {            
      var j=0;
	  var pmoStr=productObj.value+"-"+modelObj.value+"-"+objectObj.value;	  
      for (gc=0;gc<versionArray.length;gc++)
      {  	     
         if (versionArray[gc][0]==pmoStr)
	     { 	        
	          document.MYFORM.VERSION.options[j] = new Option(versionArray[gc][1],""+versionArray[gc][1]);            
			  j++;
	     } 
      }	
   } //end of if  =>objectObj.value=="--"   
}

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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT Entry Form</title>
</head>
<body>
<FORM ACTION="WSPIT_EntryInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>產品問題輸入</strong></font> <BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>  
<%  
  ArrayChkBox4PITBean.setArray2DString(null); //將陣列內容清空    
  String productArray[]=null;
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs=null,subRs=null;	 
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="13%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>PRODUCT:</strong></font>
			<BR>  	 <font size="2">
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
			</font> </td> 
      <td width="16%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>MODEL:</strong></font> 
		<BR>
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
      </td>
      <td width="14%"><font color="#333399" face="Arial Black"><strong>OBJECT</strong></font>: 
	  <BR>
        <% 		 		 		 
	     try
         {   
		    rs=statement.executeQuery("select OBJECTID,NAME from PIT_OBJECT order by OBJECTID");	 	 	    		
			
	        comboBoxBean.setRs(rs);	   
			comboBoxBean.setOnChangeJS("showVersion(document.MYFORM.VERSION.length)"); 
	        comboBoxBean.setFieldName("OBJECT");	   
            out.println(comboBoxBean.getRsString());	   
	   
            rs.close();         		                   		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>      </td>
      <td width="25%"><font color="#333399" face="Arial Black"><strong>VERSION:</strong></font> <BR>
        <% 		 		 		 
	     try
         {   
		    int pmovi=0;
		    subRs=subStmt.executeQuery("select PRODUCT||'-'||MODEL||'-'||T_OBJECT as PMO,T_VERSION from PIT_VERSION where ACTIVE='Y' order by PMO,T_VERSION");	   	 	    				
			while (subRs.next())
			{
			   String cn1=(String)subRs.getString(1);//產品/機種/物件
			   String cn2=(String)subRs.getString(2);//版本
		   %>
             <script language="JavaScript" type="text/JavaScript">			  
		      versionArray[<%=pmovi%>]=new Array();
			  versionArray[<%=pmovi%>][0]="<%=cn1%>";		
			  versionArray[<%=pmovi%>][1]="<%=cn2%>";	    		      
		     </script>
           <%  		 
		       pmovi++;
		    }
			subRs.close();
			
		     out.println("<select NAME='VERSION'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");		  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td colspan="2"> <font color="#333399" face="Arial Black"><strong>SOURCE:</strong></font>
	  <BR> 
        <% 		 		 		 
	     try
         {   
		    rs=statement.executeQuery("select SOURCEID,NAME from PIT_SOURCE order by NAME");	   
	 	    			
	        comboBoxBean.setRs(rs);	   
			comboBoxBean.setOnChangeJS("showSource()"); 
	        comboBoxBean.setFieldName("SOURCE");	   
            out.println(comboBoxBean.getRsString());	   
	   
            rs.close();   	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>	 </td>  
	  <td width="17%" colspan="3"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit()'>
</td> 
	</tr>	
	<tr>
	    <td colspan="8"><div align="right">      </div></td>
	</tr>
    <tr bgcolor="#FFFFFF"> 	   
       <td colspan="8"><div align="right"></div></td>	 
    </tr>
</table>
<!-- 表單參數 -->  
    <input name="OBJECTNAME" type="HIDDEN" value="">	
	<input name="SOURCENAME" type="HIDDEN" value="">
</FORM>
</body>
<%
 subStmt.close();
 statement.close();  
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
