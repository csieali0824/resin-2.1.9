<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ArrayCheckInputBoxBean,ComboBoxBean"%>
<html>
<head>
<title>AddMaterialSubWindow</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
<jsp:useBean id="arrayCheckInputBoxBean" scope="session" class="ArrayCheckInputBoxBean"/>
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
function setSubmit(URL)
{ 
 //document.MYFORM.action=URL;
 this.form.submit();
 document.MYFORM.submit();
}

function btnItemInfo()
{ 
  
    //subWin=window.open("INVTempWindows.jsp","subwin","width=600,height=400,scrollbars=yes,menubar=no");  
}

</script>
<body > 
<p> 
<!--以下是在處理刪除或上傳-->
<%
String [] addFeatures=request.getParameterValues("ADDFEATURES");
String chooseFeature=request.getParameter("CHOOSEFEATURE"); 
String qty=request.getParameter("QTY");
String first=request.getParameter("FIRST");
String buttonContent=null; 
String itemno=request.getParameter("ITEM");
if (itemno==null) itemno="";

String whs="";
String loc="";

try 
{    
  if (addFeatures!=null) //若有選取則表示要刪除
  {
   String a[][]=arrayCheckInputBoxBean.getArray2DContent();//取得目前陣列內容   

    if (a!=null && addFeatures.length>0)      
    { 	 
	 if (a.length>addFeatures.length)
	 {	   	  
       String t[][]=new String[a.length-addFeatures.length][a[0].length];     
	   int cc=0;
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addFeatures.length;n++)  
		{
		 if (addFeatures[n].equals(a[m][0])) inArray="Y";
		} //end of for addItems.length  		 
		if (inArray.equals("N")) 
		{
		 t[cc][0]=a[m][0];
		 t[cc][1]=a[m][1];
		 t[cc][2]=a[m][2];
		 t[cc][3]=a[m][3];	
		 cc++;			     
		}  
	   } //end of for a.length	   
	   arrayCheckInputBoxBean.setArray2DString(t);
	 } else { 	   			
	   arrayCheckInputBoxBean.setArray2DString(null); //將陣列內容清空
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
<FORM ACTION="../subwindow/AddMaterialSubWindow.jsp" METHOD="post" NAME="MYFORM">
  <p><font size="-1"><strong><font color="#FF0000">
    <input type="text" name="ITEM" SIZE=15 value=<%=itemno%>>
    </font></strong></font>
    <INPUT TYPE="submit" NAME="submit3" value="查詢">
    <font size="-1">料號</font><font size="-1">: 
    <%
	  try
      {  
	   String a[][]=arrayCheckInputBoxBean.getArray2DContent();//取得目前陣列內容
	   String aString="'"+chooseFeature+"'";

	   if (a!=null) 
	   {
	     for (int l=0;l<a.length;l++)
	     {
	      aString=aString+",'"+a[l][0]+"'";
	     }
	   }	  

	   if (itemno==null || itemno.equals(""))
	   {
	     itemno="NULL";
	   }   
	   
         Statement statement=con.createStatement();
	     String sql="select trim(ITEMNO) as ITEMNO,ITEMNO||'('||ITEMDESC||')' from INV_ITEM where trim(ITEMNO) not in ("+aString+") and trim(ITEMNO) like '%' || ('"+itemno+"') || '%' order by ITEMNO";		             
         ResultSet rs=statement.executeQuery(sql);
         comboBoxBean.setRs(rs);	   
	     comboBoxBean.setFieldName("CHOOSEFEATURE");		      
         out.println(comboBoxBean.getRsString());	   
	   
	     statement.close();
         rs.close(); 	   

       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
  </font></p>
  <p><font size="-1"><BR>
    <strong>
    <font color="#FF0000">數量: 
    <input type="text" name="QTY" SIZE=3 VALUE=1>
    </font></strong> </font>
    <INPUT TYPE="submit" NAME="submit2" value="新增">
    <BR>
    </font> <BR>
    <input name="button" type=button onClick="this.value=check(this.form.ADDFEATURES)" value="全部選取">
    -----領用料件------ 
    <INPUT TYPE="submit" NAME="submit" value="取消" onClick="return NeedConfirm()">
    --------------------------------------     
    <BR>
      <%	 	   
	  try
      { 
	     String a[][]=arrayCheckInputBoxBean.getArray2DContent();//取得目前陣列內容	 	  		 	   			    
		 String featureName="";	
		    
		 int i=0,j=0,k=0;
		 //out.println(itemno);
		 //if (itemno=="NULL")
	     if (chooseFeature!=null && !chooseFeature.equals("--"))
		 {	  
		   if (a!=null) 
		   {
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 {
			   whs=request.getParameter("WHS"+i);
			   loc=request.getParameter("LOC"+i);
			   for (j=0;j<a[i].length;j++)
			   {			   	
			     if (j==2 || j==3 )
				 {				
			       b[i][2]=whs;	
				   b[i][3]=loc;			
				 } 
				 else 
				 {
				   b[i][j]=a[i][j];	
				 }				  
			   }
			   k++;
			 }

		     b[k][0]=chooseFeature;
		     b[k][1]=qty;
		     b[k][2]="";
   		     b[k][3]="";       		 

			 arrayCheckInputBoxBean.setArray2DString(b); 
			 arrayCheckInputBoxBean.setFieldName("ADDFEATURES");					 	   			 
             out.println(arrayCheckInputBoxBean.getArray2DString());
		   } 
		   else 
		   {		     			  
			 String c[][]={{chooseFeature,qty,"",""}};			 
		     arrayCheckInputBoxBean.setArray2DString(c); 
			 arrayCheckInputBoxBean.setFieldName("ADDFEATURES");   			    
             out.println(arrayCheckInputBoxBean.getArray2DString());			 
		   }    
		 } //end of if
		 
		 else //chooseFeature=null
		 {
		   if (a!=null) 
		   {    			
		     //out.println(itemno);  	   
		      String b[][]=new String[a.length][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 {
			   whs=request.getParameter("WHS"+i);
			   loc=request.getParameter("LOC"+i);
			   //out.println(whs);
			   //out.println(loc);
			   for (j=0;j<a[i].length;j++)
			   {
				 if (first==null || !first.equals("Y") )
				 {			   	
			       if (j==2 || j==3 )
				   {				
			         if (whs==null)
				     {whs="";}
			         if (loc==null)
				     {loc="";}				   
				     b[i][2]=whs;	
				     b[i][3]=loc;			
				   } 
				   else
				   {
				     b[i][j]=a[i][j];
				   }
				 }//end of first==null
				 else
				 {
				   b[i][j]=a[i][j];	
				   /*
				   if (b[i][j]==null)
				   {
				     b[i][j]="";
				   }
				   */
				 }		
			   }//end of for		  
			     k++;
	 		 }//end of for
			 arrayCheckInputBoxBean.setArray2DString(b);         	       
			 arrayCheckInputBoxBean.setFieldName("ADDFEATURES");	            	   
             out.println(arrayCheckInputBoxBean.getArray2DString());			 
		   } //end of (a!=null)
		 } //end else 
		
		 String chk[][]=arrayCheckInputBoxBean.getArray2DContent();//取得目前陣列內容		
		 //out.println(chk); 		  
		 if (chk!=null)
		 {
    		 buttonContent="this.value=closeThisWindow("+"'YES'"+")";		 
		 } 
		 else 
		 {
		     buttonContent="this.value=closeThisWindow("+"'NO'"+")";
		 }		 	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>  
	     <BR>
         <!--<input type='button' onClick='btnItemInfo()' value="確定">-->   
		<INPUT TYPE="submit" NAME="submit2" value="存檔"> 
         <input name="button1" type='button' onClick="<%=buttonContent%>" value="離開">
</p>
    </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
