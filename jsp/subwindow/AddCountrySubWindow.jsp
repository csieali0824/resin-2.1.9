<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ArrayCheckBoxBean,ArrayCheckBox2DBean,ComboBoxBean"%>
<html>
<head>
<title>Page for choose Action Code to determine this repair case</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
<jsp:useBean id="regionArrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="countryArrayCheckBoxBean" scope="session" class="ArrayCheckBox2DBean"/>
<!--=================================-->
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function check3Input(field) 
{ /*
 var alertflg = "false";
 for (i = 0; i < field.length; i++) 
 {
  //field[i].checked = true;
  if (i>=0) 
  { 
    alertflag= "true";
    field[i].checked = true; 
    //alert("Sorry,There are 3 REASON CODE in your input list,Your last choice will be replace!!");         
  }
 }
 if (alertflag == "true")
 { alert("Sorry,There are 1 ACTION CODE in your input list,Your last choice will be replace!!"); }
 //return "cancel Selected"; } 
 */
}
function NeedConfirm()
{ 
 flag=confirm("Are you sure you want to Delete?"); 
 return flag;
}
function closeThisWindow(a,b)
{   
 if (a=="YES" ) 
 {
   window.opener.document.MYFORM.ISREGIONED.value="Y";
   window.opener.document.MYFORM.ISCOUNTRYED.value=b;
 } else {
   window.opener.document.MYFORM.ISCOUNTRYED.value="N";
 }

 this.window.close();
}
</script>
<body > 
<p> 
<!--以下是在處理刪除或上傳-->
<%
String repNo=request.getParameter("REPNO"); 
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseAct=request.getParameter("CHOOSEACT"); 
String choose = "N/A";
String buttonContent=null; 
try 
{    
  if (addItems!=null) //若有選取則表示要刪除
  {
   String a[][]=countryArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容   
    if (a!=null && addItems.length>0)      
    { 	 
	 if (a.length>addItems.length)
	 {	   	  
       String t[][]=new String[a.length-addItems.length][a[0].length];     
	   int cc=0;
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addItems.length;n++)  
		{
		 if (addItems[n].equals(a[m][0])) inArray="Y";
		} //end of for addItems.length  		 
		if (inArray.equals("N")) 
		{
		 t[cc][0]=a[m][0];
		 t[cc][1]=a[m][1];
		 cc++;			     
		}  
	   } //end of for a.length	   
	  // regionArrayCheckBoxBean.setArray2DString(t);
     // /*  加入判斷若大於輸入3個 Reason Code 2004/07/06
      if ( cc<=2 )        
      { regionArrayCheckBoxBean.setArray2DString(t); }
     //*/  //加入判斷若大於輸入3個 Reason Code 2004/07/06    
	 } else { 	   			 
	   regionArrayCheckBoxBean.setArray2DString(null); //將陣列內容清空
	 }  
	   
	}//end of if a!=null
  } 
}
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%> 
</p>
<FORM METHOD="post" ACTION="AddCountrySubWindow.jsp">
  <font size="-1">國別選擇: 
  <%
	  try
      {       
	   String a[][]=regionArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容
	   String aString="'"+choose+"'";
	   if (a!=null) 
	   {
	     for (int l=0;l<a.length;l++)
	     {
	      aString=aString+",'"+a[l][0]+"'";
	     }
	   }	 
	   String b[][]=countryArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容
	   String bString="'"+choose+"'";
	   if (b!=null) 
	   {
	     for (int l=0;l<b.length;l++)
	     {
	      bString=bString+",'"+b[l][0]+"'";
	     }
	   }	
	 //  out.println("select DISTINCT a.LOCALE,LOCALE_NAME from WSREGION a, WSCONTINENT b,WSLOCALE c where a.REGION = b.CONT_ENG_NAME and a.LOCALE = c.LOCALE  and  b.CONTINENT in ("+aString+") and a.LOCALE not in ("+bString+")   order by a.LOCALE ");
       Statement statement=con.createStatement(); 	   
	   ResultSet rs=statement.executeQuery("select DISTINCT a.LOCALE,LOCALE_NAME from WSREGION a, WSCONTINENT b,WSLOCALE c where a.REGION = b.CONT_ENG_NAME and a.LOCALE = c.LOCALE and  b.CONTINENT in ("+aString+") and a.LOCALE not in ("+bString+")  order by a.LOCALE ");
       comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("CHOOSEACT");	   
       out.println(comboBoxBean.getRsString());	   
	   
	   statement.close();
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  <INPUT TYPE="submit" NAME="submit2" value='新增'>
  <BR>
  </font> <BR>
  <input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
  -----已選擇國別------ 
  <INPUT TYPE="submit" NAME="submit" value='刪除'>------     
  <BR>
    <%	 	   
	  try
      { 	    
	     String a[][]=countryArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容	 	     		 	   			    
		 String jamDesc="";
		 int i=0,j=0,k=0;
	     if (chooseAct!=null && !chooseAct.equals("--"))
		 {
		   Statement statement=con.createStatement();
           ResultSet rs=statement.executeQuery("select DISTINCT LOCALE_NAME from WSREGION a, WSCONTINENT b,WSLOCALE c where a.REGION = b.CONT_ENG_NAME and a.LOCALE = c.LOCALE  and trim(a.LOCALE)='"+chooseAct+"'  ");	       
		   rs.next();
		   jamDesc=rs.getString("LOCALE_NAME");
		   
		   if (a!=null && a.length<1) 
		   {
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 {
			  for (j=0;j<a[i].length;j++)
			  {
			    b[i][j]=a[i][j];				
			  }
			  k++;
			 }
			 b[k][0]=chooseAct;
			 b[k][1]=jamDesc;
             //countryArrayCheckBoxBean.setFontSize(3);
             countryArrayCheckBoxBean.setArray2DString(b); 
			 countryArrayCheckBoxBean.setFieldName("ADDITEMS");	
             out.println(countryArrayCheckBoxBean.getArray2DString());
             
		   } else {	              	     			  
			        String c[][]={{chooseAct,jamDesc}};			 
		            countryArrayCheckBoxBean.setArray2DString(c); 
			        countryArrayCheckBoxBean.setFieldName("ADDITEMS");  			    
                    out.println(countryArrayCheckBoxBean.getArray2DString());	                  	 
		   }    
		  statement.close();                	                       		        		  
		  rs.close(); 
		 } else {
		   //if (a!=null && a.length<1) 
           if (a!=null) 
		   {
		     countryArrayCheckBoxBean.setArray2DString(a); 
        	 countryArrayCheckBoxBean.setFieldName("ADDITEMS");	   	   
             out.println(countryArrayCheckBoxBean.getArray2DString());            
		   } 
		 }
		 //end if of chooseItem is null		
         String chk[][]=countryArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容		 		  
		 if (chk!=null)
		 {
    		 buttonContent="this.value=closeThisWindow("+"'YES'"+",'"+chooseAct+"')";		 
		 } else {
		     buttonContent="this.value=closeThisWindow("+"'NO'"+",'"+chooseAct+"')";
		 }	
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>  
	   <BR>   
    <input name="button" type=button onClick="<%=buttonContent%>" value='確定'>
    <input name="REPNO" type="HIDDEN" value="<%=repNo%>" >  <!--做為傳給下一真的參數-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
