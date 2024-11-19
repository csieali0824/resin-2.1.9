<%@ page contentType="text/html; charset=utf-8"  language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ArrayCheckBoxBean,ComboBoxBean"%>
<html>
<head>
<title>Page for choose Region Code to determine this Sales</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
<jsp:useBean id="regionArrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
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
  if (i>1) 
  { 
    alertflag= "true";
    field[i].checked = true;          
  }
 }
 if (alertflag == "true")
 { alert("Sorry,There are 3 REASON CODE in your input list,Your last choice will be replace!!"); }
 //return "cancel Selected"; } 
 */
}
function NeedConfirm()
{ 
 flag=confirm("Are you sure you want to Delete?"); 
 return flag;
}

/*  2004/07/08 加入限制維修師務必要選原因碼 By Kerwin
function closeThisWindow(a)
{  
 this.window.close();
}
*/ //2004/07/08 加入限制維修師務必要選原因碼 By Kerwin
function closeThisWindow(a)
{   
 if (a=="YES" ) 
 {
   window.opener.document.MYFORM.ISREGIONED.value="Y";
 } else {
   window.opener.document.MYFORM.ISREGIONED.value="N";
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
String chooseItem=request.getParameter("CHOOSEITEM"); 
String buttonContent=null; 
try 
{    
  if (addItems!=null) //若有選取則表示要刪除
  {
   String a[][]=regionArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容   
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
<FORM METHOD="post" ACTION="AddRegionSubWindow.jsp">
  <font size="-1">地區別選擇: 
  <%
	  try
      {       
	   String a[][]=regionArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容
	   String aString="'"+chooseItem+"'";
	   if (a!=null) 
	   {
	     for (int l=0;l<a.length;l++)
	     {
	      aString=aString+",'"+a[l][0]+"'";
	     }
	   }	
       String sSql = "select DISTINCT CONTINENT, CONTINENT_NAME from WSREGION,WSCONTINENT where trim(REGION)=CONT_ENG_NAME and CONTINENT not in ("+aString+")  order by 1";    

      //out.println(sSql);
       Statement statement=con.createStatement(); 	   
	   ResultSet rs=statement.executeQuery(sSql);
       comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("CHOOSEITEM");	   
       out.println(comboBoxBean.getRsString());	   
	   
	   statement.close();
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  <INPUT TYPE="submit" NAME="submit2" onClick="this.value=check3Input(this.form.ADDITEMS)" value='新增'>
  <BR>
  </font> <BR>
  <input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
  -----已選擇地區別------ 
  <INPUT TYPE="submit" NAME="submit" value='刪除'>------     
  <BR>
    <%	 	   
	  try
      { 	    
	     String a[][]=regionArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容	 	     		 	   			    
		 String jamDesc="";
		 int i=0,j=0,k=0;
	     if (chooseItem!=null && !chooseItem.equals("--"))
		 {
		   //out.println("select DISTINCT CONTINENT from WSREGION, WSCONTINENT where trim(REGION) = CONT_ENG_NAME and trim(CONTINENT)='"+chooseItem+"' ");
		   Statement statement=con.createStatement();
           ResultSet rs=statement.executeQuery("select CONTINENT_NAME from WSREGION, WSCONTINENT where trim(REGION) = CONT_ENG_NAME and trim(CONTINENT)='"+chooseItem+"' ");	       
		   rs.next();
		   jamDesc=rs.getString("CONTINENT_NAME");
		   
		   if (a!=null) 
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
			 b[k][0]=chooseItem;
			 b[k][1]=jamDesc;
			 regionArrayCheckBoxBean.setFontSize(3);
			 regionArrayCheckBoxBean.setArray2DString(b); 
			 regionArrayCheckBoxBean.setFieldName("ADDITEMS"); 	   			 
             out.println(regionArrayCheckBoxBean.getArray2DString());
		   } else {		     			  
			 String c[][]={{chooseItem,jamDesc}};			 
		     regionArrayCheckBoxBean.setArray2DString(c); 
			 regionArrayCheckBoxBean.setFieldName("ADDITEMS");  			    
             out.println(regionArrayCheckBoxBean.getArray2DString());			 
		   }    
		  statement.close();                	                       		        		  
		  rs.close(); 
		 } else {
		   if (a!=null) 
		   {
		     regionArrayCheckBoxBean.setArray2DString(a); 
        	 regionArrayCheckBoxBean.setFieldName("ADDITEMS");	   	   
             out.println(regionArrayCheckBoxBean.getArray2DString());
		   } 
		 }
		 //end if of chooseItem is null			
         String chk[][]=regionArrayCheckBoxBean.getArray2DContent();//取得目前陣列內容		 		  
		 if (chk!=null)
		 {
    		 buttonContent="this.value=closeThisWindow("+"'YES'"+")";		 
		 } else {
		     buttonContent="this.value=closeThisWindow("+"'NO'"+")";
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
