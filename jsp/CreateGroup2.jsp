<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,PoolBean,CheckBoxBean,ArrayLstChkBoxInputBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateGroup.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="arrayLstChkBoxInputBean" scope="session" class="ArrayLstChkBoxInputBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}

   function validate(){
     if (document.signform.GROUPNAME.value == "") {
	      alert("請輸入群組名稱!");
		  return (false);
	 }else if(document.signform.GROUPDESC.value == ""){
	      alert("請輸入群組說明!");
			return (false);
	  }else {
	      document.signform.submit();
	  }
   }
   
   function change_acton(){
	var chks = signform.USERNAME;
        var checkItems = 0;
	 for (var len = 0; len <chks.length;len++){
		if (chks[len].checked){
			checkItems++;
		}
	 }
	 var chks1 = signform.ROLENAME;
        var checkItems1 = 0;
	 for (var len1 = 0; len1 < chks1.length ; len1++){
		if (chks1[len1].checked){
			checkItems1++;
		}
	 }
	if (document.signform.GROUPNAME.value == "") {
	      alert("請輸入群組名稱!");
		  return (false);
	 }else if(document.signform.GROUPDESC.value == ""){
	      alert("請輸入群組說明!");
			return (false);
	 }else if ( checkItems == 0 ) {
		alert("請選擇成員!!");
	    return (false);
	 }else if ( checkItems1 == 0 ){
	     alert("請選擇角色!!");
	     return (false);  
	 }else {
	      document.signform.submit();
     }
   }
function setSubmit(URL)
{
   warray=new Array(document.signform.CHOOSEITEM.value);   
   for (i=0;i<1;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the Monthly Cost of forecast data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=1;i<1;i++)
   {     
      txt=warray[i];
	  
   } //end of for  null check
 document.signform.action=URL;
 document.signform.submit();
}

function setSubmit2(URL,dim1,dim2)
{    
   if (dim1<1)  //若沒有任何資料則不能存檔
   {
       alert("No Need to Save because there is no any data being Added!!");   
       return(false);
   }
 document.signform.action=URL;
 document.signform.submit();
}


</script>
<%   
  String GROUPNAME=request.getParameter("GROUPNAME");
  String GROUPDESC=request.getParameter("GROUPDESC");
  String GROUPPROFILE=request.getParameter("GROUPPROFILE");
  String [] addItems=request.getParameterValues("ADDITEMS");
  String chooseItem=request.getParameter("CHOOSEITEM");


try 
{    
   String at[][]=arrayLstChkBoxInputBean.getArray2DContent();//取得目前陣列內容     

  if (addItems!=null) //若有選取則表示要刪除
  {

    String a[][]=arrayLstChkBoxInputBean.getArray2DContent();//重新取得陣列內容      
     out.println("step2"); 
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
		  for (int gg=0;gg<25.;gg++) //置入陣列中元素數
		  {
    		 t[cc][gg]=a[m][gg];
	      }
		 cc++;			     
		}  
	   } //end of for a.length	   
	   arrayLstChkBoxInputBean.setArray2DString(t);
	 } 
	 else 
	 { 	   			 
	   arrayLstChkBoxInputBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  }   
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<form action="CreateGroupDb.jsp" method="post" name="signform"  >
  <table border="1" align="center" bordercolor="#6699CC"">
    <tr> 
      <td width="630" height="69" colspan="2" background="../image/back5.gif"> 
        <p><A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp">查詢群組記錄</A></p>
        <p><font color="#FF0000"><strong>新建群組</strong></font></p></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#DEF5FE">群組名稱: 
        <input type="text" name="GROUPNAME" size="12" maxlength="30"> <br>
        群組說明: 
        <input type="text" name="GROUPDESC" size="15" maxlength="60"> <br>
        群組系統基本設定: 
        <input type="text" name="GROUPPROFILE" size="3" maxlength="4"> </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#66CCFF"><font color="#FF0000"><strong>角色:</strong></font></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#DEF5FE"> <%
	          Statement statement=con.createStatement();
			  ResultSet rs1=statement.executeQuery("select ROLENAME,ROLENAME from Wsrole ");
              checkBoxBean.setRs(rs1);
	          checkBoxBean.setFieldName("ROLENAME");
	          checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  statement.close();
			  rs1.close();
	          %> </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#66CCFF"><font color="#FF0000"><strong>成員:</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> <p> <font size="2"> 
          <%	    	     		 		 
	     try
         {  		   
		   String memberArray[][]=arrayLstChkBoxInputBean.getArray2DContent();//取得目前陣列內容		   
		   String aString="'--'";			     		  
		    if (chooseItem!=null && !chooseItem.equals("--"))
		   {            
   		     aString="'"+chooseItem+"'";
		   }					   
	        if (memberArray!=null) 
	        {
	           for (int l=0;l<memberArray.length;l++)
	          {
	            aString=aString+",'"+memberArray[l][0]+"'";
				//out.println(aString); 
   	          }
	        }			   
					  
		  String sSqlC = "";
		  String sWhereC = "";
		   sSqlC = "select Distinct USERNAME,USERNAME|| '--' || WEBID  from Wsuser"; 
		  sSqlC = sSqlC+sWhereC;		  
		  //out.println(sSqlC);	      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);		  	  		  		  
	      comboBoxBean.setFieldName("CHOOSEITEM");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
          </font> </td>
      <td bgcolor="#DEF5FE"><input name="button"  type="button" onClick='return setSubmit("../jsp/CreateGroup2.jsp") ' value="Add" ></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#DEF5FE"><strong>
        <%
	  try
      { //out.println("step1");
	     String oneDArray[]= {"","USERNAME"}; 	 	     			  
       	arrayLstChkBoxInputBean.setArrayString(oneDArray);
	    //out.println("step3"); 

	     String a[][]=arrayLstChkBoxInputBean.getArray2DContent();//取得目前陣列內容  
		 int i=0,j=0,k=0;
	     if (chooseItem!=null && !chooseItem.equals("--")) 
		 {  
             		    
		   if (a!=null) 
		   {  //out.println("step4"); 
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { //out.println("step4");
			  for (j=0;j<a[i].length;j++)
			  { //out.println("step5");
			    b[i][j]=a[i][j];				
			  }
			  k++;
			 }
			 b[k][0]=chooseItem;			 			 
			 			 
			 arrayLstChkBoxInputBean.setArray2DString(b); 			 						 			 	   			              
		   } 
		   else {	//out.println("step6");	     			  
			        String c[][]={{chooseItem}};			             			 
		     arrayLstChkBoxInputBean.setArray2DString(c); 						 	                
		   }                   	                       		        		  
		 } else {
		   if (a!=null) 
		   {  //out.println("step7");
		     arrayLstChkBoxInputBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null		 		 	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        </strong><BR> <input name="button2" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
        -----DETAIL you choosed to be saved--------------------------------------------------------------------------------------------------------- 
        <BR> 
        <%       			 	   			 

	 int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {     //out.println("step5"); 
	    String a[][]=arrayLstChkBoxInputBean.getArray2DContent();//取得目前陣列內容 
		//arrayLstChkBoxInputBean.setArray2DCheck(a);
		
				    		                       		    		  	   
         if (a!=null) 
		 {
		        div1=a.length;
				//out.println("a length:"+a.length);
				div2=a[0].length;
				 //out.println("step6"); 
	        	arrayLstChkBoxInputBean.setFieldName("ADDITEMS");
	        	arrayLstChkBoxInputBean.setInputBoxFieldName("ROW");
			    arrayLstChkBoxInputBean.setInputBoxFieldLength("16");			 			 	   			 
			 			 	   			 
				 //out.println("step7:"+a[0][0]+":"+a[0][1]+":"+a[0][2]+":"+a[0][3]+"|"); 
  			    out.println(arrayLstChkBoxInputBean.getArray2DString()); 		 
				 //out.println("step8"); 				
		 }	//enf of a!=null if
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
        <BR> <INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/CreateGroup2.jsp")'  value="DELETE" >
        ------------------------------------------------------------------------------------------------------------ 
        <INPUT name="button3" TYPE="button" onClick='setSubmit2("../jsp/CreateGroupDb.jsp",<%=div1%>,<%=div2%>)' value="SAVE"  > 
      </td>
    </tr>
  </table>
  <tr vAlign="top" align="middle">
    <H4>&nbsp; </H4>
    <td width="383" height="311" bgcolor=#CCFFFF> <br>      
    </form>    
	    <input name="GROUPNAME" type="HIDDEN" value="<%=GROUPNAME%>" > 
        <input name="GROUPDESC" type="HIDDEN" value="<%=GROUPDESC%>" > 
        <input name="GROUPPROFILE" type="HIDDEN" value="<%=GROUPPROFILE%>" >
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

  
 