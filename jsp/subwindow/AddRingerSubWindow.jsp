<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ArrayCheckBoxBean,ComboBoxBean"%>
<html>
<head>
<title>Page for choose Feature to add to Product Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
<jsp:useBean id="arrayCheckBoxBean4Ringer" scope="session" class="ArrayCheckBoxBean"/>
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
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function closeThisWindow(a)
{   
 this.window.close();
}
</script>
<body > 
<p> 
<!--以下是在處理刪除或上傳-->
<%
String [] addRingers=request.getParameterValues("ADDRINGERS");
String chooseRinger=request.getParameter("CHOOSERINGER"); 
String buttonContent=null; 
try 
{    
  if (addRingers!=null) //若有選取則表示要刪除
  {
   String a[][]=arrayCheckBoxBean4Ringer.getArray2DContent();//取得目前陣列內容   
    if (a!=null && addRingers.length>0)      
    { 	 
	 if (a.length>addRingers.length)
	 {	   	  
       String t[][]=new String[a.length-addRingers.length][a[0].length];     
	   int cc=0;
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addRingers.length;n++)  
		{
		 if (addRingers[n].equals(a[m][0])) inArray="Y";
		} //end of for addRingers.length  		 
		if (inArray.equals("N")) 
		{
		 t[cc][0]=a[m][0];
		 t[cc][1]=a[m][1];
		 cc++;			     
		}  
	   } //end of for a.length	   
	   arrayCheckBoxBean4Ringer.setArray2DString(t);
	 } else { 	   			 
	   arrayCheckBoxBean4Ringer.setArray2DString(null); //將陣列內容清空
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
<FORM METHOD="post" ACTION="AddRingerSubWindow.jsp">
  <font size="-1">RINGERS</font><font size="-1">: 
  <%
	  try
      {       
	   String a[][]=arrayCheckBoxBean4Ringer.getArray2DContent();//取得目前陣列內容
	   String aString="'"+chooseRinger+"'";
	   if (a!=null) 
	   {
	     for (int l=0;l<a.length;l++)
	     {
	      aString=aString+",'"+a[l][0]+"'";
	     }
	   }	 
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select RINGERCODE,RINGERNAME from PIRINGER where trim(RINGERCODE) not in ("+aString+") order by RINGERNAME");
       comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("CHOOSERINGER");	   
       out.println(comboBoxBean.getRsString());	   
	   
	   statement.close();
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  <INPUT TYPE="submit" NAME="submit2" value="新增">
  <BR>
  </font> <BR>
  <input name="button" type=button onClick="this.value=check(this.form.ADDRINGERS)" value="全部選取">
  -----CHOOSED RINGERS------ 
  <INPUT TYPE="submit" NAME="submit" value="刪除">--------------------------------------     
  <BR>
    <%	 	   
	  try
      { 
	     String a[][]=arrayCheckBoxBean4Ringer.getArray2DContent();//取得目前陣列內容	 	     		 	   			    
		 String ringerName="";
		 int i=0,j=0,k=0;
	     if (chooseRinger!=null && !chooseRinger.equals("--"))
		 {
		   Statement statement=con.createStatement();
           ResultSet rs=statement.executeQuery("select RINGERNAME from PIRINGER where trim(RINGERCODE)='"+chooseRinger+"'");	       
		   rs.next();
		   ringerName=rs.getString("RINGERNAME");
		   
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
			 b[k][0]=chooseRinger;
			 b[k][1]=ringerName;
			 arrayCheckBoxBean4Ringer.setArray2DString(b); 
			 arrayCheckBoxBean4Ringer.setFieldName("ADDRINGERS");			 			 	   			 
             out.println(arrayCheckBoxBean4Ringer.getArray2DString());
		   } else {		     			  
			 String c[][]={{chooseRinger,ringerName}};			 
		     arrayCheckBoxBean4Ringer.setArray2DString(c); 
			 arrayCheckBoxBean4Ringer.setFieldName("ADDRINGERS");  			    
             out.println(arrayCheckBoxBean4Ringer.getArray2DString());			 
		   }    
		  statement.close();                	                       		        		  
		  rs.close(); 
		 } else {
		   if (a!=null) 
		   {
		     arrayCheckBoxBean4Ringer.setArray2DString(a); 
        	 arrayCheckBoxBean4Ringer.setFieldName("ADDRINGERS");	   	   
             out.println(arrayCheckBoxBean4Ringer.getArray2DString());
		   } 
		 }
		 //end if of chooseRinger is null	 
		 String chk[][]=arrayCheckBoxBean4Ringer.getArray2DContent();//取得目前陣列內容		 		  
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
   <input name="button" type=button onClick="<%=buttonContent%>" value="確定">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
