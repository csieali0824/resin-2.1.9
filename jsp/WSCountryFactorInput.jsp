<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ForePriCostInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function setSubmit(URL)
{
   warray=new Array(document.MYFORM.MONTH1.value,document.MYFORM.MONTH2.value,document.MYFORM.MONTH3.value,
                    document.MYFORM.MONTH4.value,document.MYFORM.MONTH5.value);   
   for (i=0;i<5;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<5;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
            alert("data should be numerical!!");   
            return(false);
		 }
      } 
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit2(URL,dim1,dim2)
{    
   if (dim1<1)  //若沒有任何資料則不能存檔
   {
       alert("No Need to Save because there is no any data being Added!!");   
       return(false);
   }

   for (i=0;i<dim1;i++)
   {     
      for (j=1;j<dim2;j++)
	  {
	     if (document.MYFORM.elements["MONTH"+i+"-"+j]==null || document.MYFORM.elements["MONTH"+i+"-"+j].value=="" )
		 { 
           alert("Before you want to save , please do not let the Data be Null !!");   
           return(false);
		 }  
	  } //enf for of jj             
   } //end of for null check
   
    for (i=0;i<dim1;i++)
   {     
      for (k=1;k<dim2;k++)
	  {
         txt=document.MYFORM.elements["MONTH"+i+"-"+k].value;
	     for (j=0;j<txt.length;j++)      
         { 
	       c=txt.charAt(j);
	        if ("0123456789.".indexOf(c,0)<0) 
	       {
             alert("Data detail should be numerical!!");   
             return(false);
		    }
         }
	   } //enf for of k
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WINS System - Sales Country factor Input Form</title>
</head>
<body>
<FORM ACTION="WSCountryFactorInput.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>  Country Factor Input </strong></font><BR> 
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>  
<% 
String baseCountry=request.getParameter("BASECOUNTRY");
String baseCountryName="";
String regionNo=request.getParameter("REGION");
String brand=request.getParameter("BRAND");      
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String month1=request.getParameter("MONTH1"),month2=request.getParameter("MONTH2"),month3=request.getParameter("MONTH3");
String month4=request.getParameter("MONTH4"),month5=request.getParameter("MONTH5");
String [] allMonth={month1,month2,month3,month4,month5};

out.println("<BR><font color='#330099' face='Arial Black'><strong>This Month is :"+thisDateBean.getYearString()+"/"+thisDateBean.getMonthString()+"</strong></font>");

try 
{    
   String at[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容     
  //*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
   if (at!=null) 
   {
      for (int ac=0;ac<at.length;ac++)
	  {    	        
            for (int subac=1;subac<at[ac].length;subac++)
	      {
		      at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
		   }  //end for array second layer count
	  } //end for array first layer count
   	 forePriCostInputBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************

  if (addItems!=null) //若有選取則表示要刪除
  {
    String a[][]=forePriCostInputBean.getArray2DContent();//重新取得陣列內容        
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
		  for (int gg=0;gg<6;gg++) //置入陣列中元素數
		  {
    		 t[cc][gg]=a[m][gg];
	      }
		 cc++;			     
		}  
	   } //end of for a.length	   
	   forePriCostInputBean.setArray2DString(t);
	 } else { 	   			 
	   forePriCostInputBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  }   
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">   
      <td width="31%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" size="2" face="Arial Black"><strong>Base Country:
        <% 				 		 
	     try
         {		  		  		 	    		  		 		 		  
		  Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select trim(LOCALE_ENG_NAME) AS COUNTRYNAME from WSLOCALE where LOCALE='"+baseCountry+"'");
          if (rs.next())  
		  {		   
			baseCountryName=rs.getString("COUNTRYNAME");				
			out.println(baseCountryName);	
		  }	
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
	    </strong></font>      </td>
      <td width="25%"><font color="#333399" size="2" face="Arial Black"><strong>Region: <%=regionNo%>  </strong></font>        
      </td>
      <td width="14%"><font size="2"> <font color="#333399" face="Arial Black"><strong>Brand:</strong></font><font color="#333399" size="2" face="Arial Black"><strong><%=brand%></strong></font>	    
        
	  </font></td> 
      <td width="17%"><font size="2"><font color="#333399" face="Arial Black"><strong>Currency:</strong></font><font color="#333399" size="2" face="Arial Black"><strong><%=curr%></strong></font></font></td>
      <td width="13%"><font size="2">  
     </strong></font> <INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/WSCountryFactorInput.jsp")' ></td>    
  </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="20%" bgcolor="#FFFFCC"><font size="2" face="Arial"><strong>Country</strong></font></td>       
	  <td width="18%" colspan="1" bgcolor="#FFFF66"><div align="center"><font size="2" color="#0000FF" face="Arial"><strong>Ship-out
	          Price           Adjust<BR>
	  </strong>
       
      </font></div>
      </td> 
	  <td width="12%" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>VAT(%)<BR>
	  </strong>	   
      </font></div></td> 
	  <td width="18%" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>L&amp;L
	          of <%=baseCountryName%><BR>
	  </strong></font></div></td>
	  <td width="18%" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>L&amp;L
	          Adjust <BR>
	  </strong>
	 
      </font></div></td> 
	  <td width="24%" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Exchange
	          Rate<BR>
	  </strong></font></div></td> 
    </tr>
  <tr>
    <td> <font size="2">
      <%	    	     		 		 
	     try
         {  		   
		   String modelArray[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容		   
		   String aString="'--'";		  
	        if (modelArray!=null) 
	        {
	           for (int l=0;l<modelArray.length;l++)
	          {
	            aString=aString+",'"+modelArray[l][0]+"'";
   	          }
	        }		 
		 
		  String sSqlC = "";
		  String sWhereC = "";
		  
		  sSqlC = "select trim(x.LOCALE), trim(LOCALE_ENG_NAME)||'('||trim(x.LOCALE)||')' as LOCALENAME from WSREGION x,WSLOCALE y";		  
		  sWhereC= " where REGION='"+regionNo+"' and trim(x.LOCALE)=trim(y.LOCALE) and trim(x.LOCALE) not in ("+aString+") order by LOCALENAME";		             		 
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
    <td>
     <input type="text" name="MONTH1"  size="7"  <%if (allMonth[0]!=null) out.println("value="+allMonth[0]); else out.println("value=0");%> >
    </td>
    <td>
     <input type="text" name="MONTH2"  size="7" <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=0");%> >
     %
    </td>
    <td>
     <input type="text" name="MONTH3"  size="7" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=0");%>>
    </td>
    <td>
      <input type="text" name="MONTH4"  size="7" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value=0");%>>
    </td>
    <td>
      <input type="text" name="MONTH5"  size="7" <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value=0");%>>
    </td>
    </tr>
</table>
<strong>
<%
	  try
      { //out.println("step1");
	    String oneDArray[]= {"","Country","EXW Adjust of "+baseCountryName,"VAT(%)","L&L "+baseCountryName,"L&L Adjust","Ex. Rate"}; 	 	     			  
    	forePriCostInputBean.setArrayString(oneDArray);
	     String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
	     if (chooseItem!=null && !chooseItem.equals("--")) 
		 { //out.println("step2");              		    
		   if (a!=null) 
		   { //out.println("step3");
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
			 b[k][1]=month1;b[k][2]=month2;b[k][3]=month3;b[k][4]=month4;b[k][5]=month5;	
			 		 
			 forePriCostInputBean.setArray2DString(b); 			 						 			 	   			              
		   } else {	//out.println("step6");	     			  
			 String c[][]={{chooseItem,month1,month2,month3,month4,month5}};			             			 
		     forePriCostInputBean.setArray2DString(c); 						 	                
		   }                   	                       		        		  
		 } else {
		   if (a!=null) 
		   {  //out.println("step7");
		     forePriCostInputBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null		 		 	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
</strong>
<BR>
<input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
-----DETAIL you choosed to be saved---------------------------------------------------------------------------------------------------------<BR>
<% 
     int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容 
		forePriCostInputBean.setArray2DCheck(a);		    		                       		    		  	   
         if (a!=null) 
		 {
		        div1=a.length;
				div2=a[0].length;
	        	forePriCostInputBean.setFieldName("ADDITEMS");			 			 	   			                  				
				out.println(forePriCostInputBean.getArray2DString()); 		   	 				
		 }	//enf of a!=null if
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/WSCountryFactorInput.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSCountryFactorInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="BASECOUNTRY" type="HIDDEN" value="<%=baseCountry%>" >      
	<input name="REGION" type="HIDDEN" value="<%=regionNo%>" >
	<input name="BRAND" type="HIDDEN" value="<%=brand%>" > 
	<input name="CURR" type="HIDDEN" value="<%=curr%>" > 	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
