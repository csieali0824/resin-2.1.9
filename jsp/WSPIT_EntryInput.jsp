<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ArrayChkBox4PITBean,ComboBoxBean,DateBean,ArrayComboBoxBean,RsCountBean" %>
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
 subfunctionlArray=new Array();		
 subfunctionlArrayCode=new Array();		
 functionArray=new Array();
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "SELECT CANCEL"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "SELECT ALL"; }
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

function setSubmit()
{  

  if (document.MYFORM.FUNCTYPE.value=="--" || document.MYFORM.FUNCTYPE.value==null || document.MYFORM.FUNCTYPE.value=="")
  { 
   alert("Please Check the MAIN FUNCTION!!It should not be null or blanked");   
   return(false);
  } 	 
  if (document.MYFORM.FUNCTYPESUB.value=="--" || document.MYFORM.FUNCTYPESUB.value==null || document.MYFORM.FUNCTYPESUB.value=="")
  { 
   alert("Please Check the SUB FUNCTION!!It should not be null or blanked");   
   return(false);
  } 	 
  if (document.MYFORM.SERLE.value=="--" || document.MYFORM.SERLE.value==null || document.MYFORM.SERLE.value=="")
  { 
   alert("Please Check the SERIOUS LEVEL!!It should not be null or blanked");   
   return(false);
  } 	 
  if (document.MYFORM.PROBABILITY.value=="--" || document.MYFORM.PROBABILITY.value==null || document.MYFORM.PROBABILITY.value=="")
  { 
   alert("Please Check the PROBABILITY!!It should not be null or blanked");   
   return(false);
  } 	 

  if (document.MYFORM.RESULT.value=="--" || document.MYFORM.RESULT.value==null || document.MYFORM.RESULT.value=="")
  { 
   alert("Please Check the RESULT!!It should not be null or blanked");   
   return(false);
  } 	 
  
  if (document.MYFORM.LOCATION.value=="--" || document.MYFORM.LOCATION.value==null || document.MYFORM.LOCATION.value=="")
  { 
   alert("Please Check the LOCATION!!It should not be null or blanked");   
   return(false);
  } 	 

  if (document.MYFORM.PHENOMENON.value=="--" || document.MYFORM.PHENOMENON.value==null || document.MYFORM.PHENOMENON.value=="")
  { 
   alert("Please Check the PHENOMENON!!It should not be null or blanked");   
   return(false);
  } 	 
 document.MYFORM.FUNCTYPESUBNAME.value =document.MYFORM.FUNCTYPESUB.options[document.MYFORM.FUNCTYPESUB.selectedIndex].text ;
 document.MYFORM.submit();

}
function setSubmit2(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function showSubfunction(gg)
{   
  //以下為處理動態show出sub unction
   var functionObj;
   functionObj = document.MYFORM.FUNCTYPE;  
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.FUNCTYPESUB.options[0].value!=null)
	 {         
       document.MYFORM.FUNCTYPESUB.options[0] =null;		
	 }  	   
   }    
   
   if (functionObj.value=="--")
   {                  
     document.MYFORM.FUNCTYPESUB.options[0] = new Option("--","--");
   } else {    
      for (i=0;i<functionArray.length;i++)
      {  
         if (functionArray[i]==functionObj.value)
	     {   			
  			document.MYFORM.FUNCTYPENAME.value= document.MYFORM.FUNCTYPE.options[i+1].text;
	        for (j=0;j<subfunctionlArray[i].length;j++)
		    {			   			  
	        document.MYFORM.FUNCTYPESUB.options[j] = new Option(subfunctionlArray[i][j],""+subfunctionlArrayCode[i][j]);
        //    document.MYFORM.SUBFUNCTYPECODE.value=document.MYFORM.FUNCTYPESUB.value;
       //     document.MYFORM.SUBFUNCTYPENAME.value=document.MYFORM.FUNCTYPESUB.options[j].text;
            }
	     }
      }	
   } //end of if  =>functionObj.value=="--"  

}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT Entry Form</title>
</head>
<body>
<%
String product=request.getParameter("PRODUCT");
String model=request.getParameter("MODEL");
String objectname=request.getParameter("OBJECTNAME");
String object=request.getParameter("OBJECT");
String version=request.getParameter("VERSION");
String sourcename=request.getParameter("SOURCENAME");
String source=request.getParameter("SOURCE");
String functypename=request.getParameter("FUNCTYPENAME");
String functype=request.getParameter("FUNCTYPE");
String functypeSub=request.getParameter("FUNCTYPESUB");
String functypeSubName=request.getParameter("FUNCTYPESUBNAME");
String functypesubcode=request.getParameter("FUNCTYPESUB");
String serle=request.getParameter("SERLE");
String probability=request.getParameter("PROBABILITY");
String sim=request.getParameter("SIM");
String sim1=request.getParameter("SIM1");
if (sim1!=null){
	if  (!sim1.equals("") )
	{
 		sim=sim1;
	}
}
String network=request.getParameter("NETWORK");
String network1=request.getParameter("NETWORK1");
if (network1!=null){
	if  (!network1.equals("") )
	{
 		network=network1;
	}
}
String result=request.getParameter("RESULT");
String compha=request.getParameter("COMPHA");
String location=request.getParameter("LOCATION");
String phenomenon=request.getParameter("PHENOMENON");
String funccode="";
String d[]={"","M FUNCTION CODE","M FUNCTION NAME","S FUNCTION CODE","S FUNCTION NAME","S.LEVEL","PROBABILITY","SIM","NETWORK","RESULT","COMPARISON HANDSET","LOCATION","PHENOMENON"};
ArrayChkBox4PITBean.setHeaderArray(d);
ResultSet rs=null,subRs=null;	  	
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
String functionArray[][]=null;
%>
<FORM ACTION="WSPIT_EntryInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>產品問題輸入</strong></font><BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>  
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="18%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>PRODUCT:</strong></font>
			<BR><%=product%></td> 
      <td width="22%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>MODEL:</strong></font> 
		<BR><%=model%></td>
      <td width="20%"><font color="#333399" face="Arial Black"><strong>OBJECT</strong></font>: 
	  <BR><%=objectname%></td>
      <td width="22%" bgcolor="#D0FFFF"><font color="#333399" face="Arial Black"><strong>VERSION:</strong></font> 
        <BR>
                <%=version%></td>
      <td width="18%" colspan="2" bgcolor="#D0FFFF"> <font color="#333399" face="Arial Black"><strong>SOURCE:</strong></font> 
        <BR>
        <%=sourcename%></td>  
	  <!--td width="17%" colspan="3"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit()'>
</td--> 
	</tr>	
</TABLE>
 <table width="100%" border="0">
    <tr bgcolor="#D0FFFF" > 
      <td height="23" bordercolor="#FFFFFF"><p><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>MAIN 
          FUNCTION:</strong></font> 
          <%      
	  try
      {     	         
        rs=statement.executeQuery("select CODE A,name B from pit_function where class='M' order by A");	   
	    rsCountBean.setRs(rs); //取得其line detail總筆數
	    functionArray=new String[2][rsCountBean.getRsCount()]; //宣告為符合其總筆數大小之陣列
		  int pi=0; 
          while (rs.next())
          {     
		   int mi=0;//代表共有多少筆屬於該main_function的sub_function       
           String s1=(String)rs.getString(1); //code
           String s2=(String)rs.getString(2); //name
		   functionArray[0][pi]=s2;
		   functionArray[1][pi]=s1;
   	   %>
          <script language="JavaScript" type="text/JavaScript">
			  functionArray[<%=pi%>]="<%=s1%>";
		      subfunctionlArray[<%=pi%>]=new Array();			
		      subfunctionlArrayCode[<%=pi%>]=new Array();			   		      
		</script>
          <%   //將所有sub放入陣列		   		   		   		  			
			 subRs=subStmt.executeQuery("select code,name from pit_function where ref='"+s1+"' and class='S' order by name");  
		     while (subRs.next())
		     {
		       String cn1=(String)subRs.getString(2);//sub function name
		       String cn2=(String)subRs.getString(1);//sub function code
			   %>
          <script language="JavaScript" type="text/JavaScript">			    		        			    
		        subfunctionlArray[<%=pi%>][<%=mi%>]="<%=cn1%>";
		        subfunctionlArrayCode[<%=pi%>][<%=mi%>]="<%=cn2%>";
		</script>
          <%			 			 
			   mi++;
		     } //end of while=>subRs.next()	 
		     subRs.close();
		     pi++;
           } //end of while => rs.next();
		   rs.close(); 		 		
	       arrayComboBoxBean.setArrayString2D(functionArray); 	
		   arrayComboBoxBean.setOnChangeJS("showSubfunction(document.MYFORM.FUNCTYPESUB.length)");
	       arrayComboBoxBean.setFieldName("FUNCTYPE");
	       out.println(arrayComboBoxBean.getArrayString2D());	      	           
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </p>
        <p><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>SUB 
          FUNCTION:</strong></font> 
          <% 		 		 		 
	     try
         {   
		     out.println("<select NAME='FUNCTYPESUB'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");		  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
        </p><td height="23" colspan="2"><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>SERIOUS 
        LEVEL:</strong></font> 
        <select name="SERLE">
          <option value="--">--</option>
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="C">C</option>
        </select> <font color="#330099" face="Arial Black"><strong> </strong></font> 
      <td width="28%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>PROBABILITY:</strong></font> 
        <font color="#330099" face="Arial Black"><strong> 
        <input name="PROBABILITY" type="text" size="5" maxlength="5" >
        % </strong></font><font color="#330099" face="Arial Black"><strong> </strong></font></td>
    </tr>
    <tr bgcolor="#D0FFFF"> 
      <td height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>SIM:</strong></font> 
        <font color="#330099" face="Arial Black"><strong> 
        <select name="SIM">
          <option value="--">--</option>
          <option value="中華">中華</option>
          <option value="遠傳">遠傳</option>
          <option value="台哥大">台哥大</option>
        </select>
        </strong></font> <input name="SIM1" type="text" size="10"> <font color="#330099" face="Arial Black"><strong> 
        </strong></font> <div align="left"></div></td>
      <td width="14%" height="23" bordercolor="#FFFFFF" > <font color="#330099" face="Arial Black" size="+2"><strong> 
        </strong></font><font color="#330099" face="Arial Black" size="2"><strong>NE</strong></font><font color="#330099" face="Arial Black" size="2"><strong>TWORK:</strong></font> 
      </td>
      <td width="21%" height="23" bordercolor="#FFFFFF"> <div align="left"><font color="#330099" face="Arial Black"><strong> 
          <select name="NETWORK">
            <option value="--">--</option>
            <option value="中華">中華</option>
            <option value="遠傳">遠傳</option>
            <option value="台哥大">台哥大</option>
          </select>
          </strong></font> 
          <input name="NETWORK1" type="text" size="10">
        </div></td>
      <td width="28%" height="23" bordercolor="#FFFFFF"> <div align="left"><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>RESULT: 
          <select name="RESULT">
            <option value="--">--</option>
            <option value="OK">OK</option>
            <option value="NG">NG</option>
          </select>
          </strong></font> </div></td>
    </tr>
    <tr bgcolor="#D0FFFF"> 
      <td height="22" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>COMPARISON 
        HANDSET :</strong></font> <font color="#330099" face="Arial Black"><strong> 
        </strong></font> <input name="COMPHA" type="text" size="10"> <font color="#330099" face="Arial Black"><strong> 
        </strong></font> <div align="left"></div></td>
      <td height="22" bordercolor="#FFFFFF" > <font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>LOCATION:</strong></font> 
      </td>
      <td height="22" bordercolor="#FFFFFF"> <div align="left"><font color="#330099" face="Arial Black"><strong> 
          </strong></font> 
          <input name="LOCATION" type="text" size="10">
        </div></td>
      <td height="22" bordercolor="#FFFFFF"> <div align="left"> </div></td>
    </tr>
    <tr align="center" valign="top" bgcolor="#D0FFFF"> 
      <td colspan="3" > <div align="left"> 
          <p><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>PHENOMENON: 
            <textarea name="PHENOMENON" cols="60"></textarea>
            </strong></font></p>
        </div></td>
      <td valign="middle"> <div align="center"> 
          <input type="submit" name="SubmitADD" value="ADD" onClick='return setSubmit()'>
        </div></td>
          <input type="hidden" name="FUNCTYPENAME" value="">
          <input type="hidden" name="FUNCTYPESUBNAME" value="">
          <input type="hidden" name="PRODUCT" value=<%=product%>>
          <input type="hidden" name="MODEL" value=<%=model%>>
          <input type="hidden" name="OBJECTNAME" value=<%=objectname%>>
          <input type="hidden" name="OBJECT" value=<%=object%>>
          <input type="hidden" name="VERSION" value=<%=version%>>
          <input type="hidden" name="SOURCENAME" value=<%=sourcename%>>
          <input type="hidden" name="SOURCE" value=<%=source%>>
	      <input name="FROMSTATUS" type="HIDDEN" value="100">		
	      <input name="FORMID" type="HIDDEN" value="PIT">
	     <input name="TYPENO" type="HIDDEN" value="001">
	     <input name="ACTION" type="HIDDEN" value="006">    </tr>
  </table>
  <%/*-----------------------------------------------------------------------*/%>
<!--以下是在處理刪除或上傳-->
<%
String strDateTime =dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
String [] addFeatures=request.getParameterValues("ADDFEATURES");
String submitadd=request.getParameter("SubmitADD");
String buttonContent=null; 
try 
{    
  if (addFeatures!=null) //若有選取則表示要刪除
  {
   String a[][]=ArrayChkBox4PITBean.getArray2DContent();//取得目前陣列內容   
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
		 t[cc][4]=a[m][4];
		 t[cc][5]=a[m][5];
		 t[cc][6]=a[m][6];
		 t[cc][7]=a[m][7];
		 t[cc][8]=a[m][8];
		 t[cc][9]=a[m][9];
		 t[cc][10]=a[m][10];
		 t[cc][11]=a[m][11];
		 t[cc][12]=a[m][12];
    	 cc++;	
		}  
	   } //end of for a.length	   
	    ArrayChkBox4PITBean.setArray2DString(t);
	 } else { 	   			 
	   ArrayChkBox4PITBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  } 
}
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%></font>
  <input name="button" type=button onClick="this.value=check(this.form.ADDFEATURES)" value="SELECT ALL">
  <INPUT TYPE="submit" NAME="SubmitDEL" value="DEL">
  <BR>
  <%	 	
	  try
      { 
	     String a[][]=ArrayChkBox4PITBean.getArray2DContent();//取得目前陣列內容	
		 String featureName="";
		 int i=0,j=0,k=0;
	    if (submitadd!=null ) //新增資料
		 {
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
			 b[k][0]=strDateTime;
			 b[k][1]=functype;
			 b[k][2]=functypename;
			 b[k][3]=functypesubcode;
			 b[k][4]=functypeSubName;
			 b[k][5]=serle;
			 b[k][6]=probability;
			 b[k][7]=sim;
			 b[k][8]=network;
			 b[k][9]=result;
			 b[k][10]=compha;
			 b[k][11]=location;
			 b[k][12]=phenomenon;
			 ArrayChkBox4PITBean.setArray2DString(b); 
			 ArrayChkBox4PITBean.setFieldName("ADDFEATURES");			 			 	   			 
             out.println(ArrayChkBox4PITBean.getArray2DString());
		   } else {		    
			 String c[][]={{strDateTime,functype,functypename,functypesubcode,functypeSubName,serle,probability,sim,network,result,compha,location,phenomenon}};
     	     ArrayChkBox4PITBean.setArray2DString(c); 
			 ArrayChkBox4PITBean.setFieldName("ADDFEATURES");  			    
             out.println(ArrayChkBox4PITBean.getArray2DString());			 
		   }    
		
		 } else {
		   if (a!=null) 
		   {
		     ArrayChkBox4PITBean.setArray2DString(a); 
        	 ArrayChkBox4PITBean.setFieldName("ADDFEATURES");	
             out.println(ArrayChkBox4PITBean.getArray2DString());
		   } 
		 }
		 		  	 
       } //end of try
      catch (Exception e)
       {
        out.println("Exceptionadd:"+e.getMessage());
       }
       %>
  <BR>
   <INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSPIT_EntryInsert.jsp")' >
  <%/*-----------------------------------------------------------------------*/%>



</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
