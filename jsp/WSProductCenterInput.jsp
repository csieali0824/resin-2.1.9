<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
   warray=new Array(document.MYFORM.INTMODEL.value,document.MYFORM.EXTMODEL.value,document.MYFORM.PRODDESC.value,
                    document.MYFORM.LUANCHDATE.value);   
   for (i=0;i<4;i++)
   {     
      if (warray[i]=="" || warray[i]==null || warray[i]=="--" )
     { 
      alert("Before you want to add , please do not let the any fields of Product data be Null !!");   
      return(false);
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
	     if (document.MYFORM.elements["MONTH"+i+"-"+j].value=="" || document.MYFORM.elements["MONTH"+i+"-"+j].value==null)
		 { 
           alert("Before you want to save , please do not let the any filed of product detail be Null !!");   
           return(false);
		 }  
	  } //enf for of jj             
   } //end of for null check   

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WINS System-Sales Product Data Input Form</title>
</head>
<body>
<FORM ACTION="WSForecastCostInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>   Product Data Input </strong></font> &nbsp; &nbsp; &nbsp; 
  &nbsp;<BR>
  <A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>&nbsp;&nbsp;<A HREF="../jsp/WSProductCenterMaintenance.jsp">PRODUCT DATA MAINTENANCE</A> 
<%   

int commitmentMonth=0;
array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String comp=request.getParameter("COMP");
String type=request.getParameter("TYPE");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");     
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String designHouse=request.getParameter("DESIGNHOUSE");
String intModel=request.getParameter("INTMODEL"),extModel=request.getParameter("EXTMODEL"),prodDesc=request.getParameter("PRODDESC");
String brand=request.getParameter("BRAND"),platForm=request.getParameter("PLATFORM"),luanchDate=request.getParameter("LUANCHDATE");
String [] allMonth={intModel,extModel,prodDesc,brand,chooseItem,designHouse,luanchDate};
String back=request.getParameter("BACK"); 

out.println("<BR><font color='#330099' face='Arial Black'><strong>This Year/Month is :"+thisDateBean.getYearString().substring(2,4)+"/"+thisDateBean.getMonthString()+"    USER :"+userID+"</strong></font>");

try 
{   
 
   String at[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容     
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
   	 array2DimensionInputBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************

  if (addItems!=null) //若有選取則表示要刪除
  {
    String a[][]=array2DimensionInputBean.getArray2DContent();//重新取得陣列內容        
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
		  for (int gg=0;gg<7;gg++) //置入陣列中元素數
		  {
    		 t[cc][gg]=a[m][gg];
	      }
		 cc++;			     
		}  
	   } //end of for a.length	   
	   array2DimensionInputBean.setArray2DString(t);
	 } else { 	   			 
	   array2DimensionInputBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  }  
  
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<table width="100%" border="0">
    <tr>
      <td width="24%"><font size="2"> <font color="#333399" face="Arial Black"><strong>        
	   </strong></font>
        <INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/WSProductCenterInput.jsp")' >
	  </font></td>     
  </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="15%" bgcolor="#FF6666"><div align="center"><font face="Arial" color="#000066" size="2"><strong>INTERNAL MODEL</strong></font></div></td>
	  <td width="15%" colspan="1" bgcolor="#FF6666"><div align="center"><font face="Arial" color="#000066" size="2"><strong>EXTERNAL MODEL</strong></font></div></td> 
      <td width="7%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>DESCRIPTION</strong></font></div></td> 
	  <td width="7%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>BRAND</strong></font></div></td>       
	  <td width="15%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>PLATFORM</strong></font></div></td>
      <td width="15%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>DESIGN HOUSE</strong></font></div></td> 
	  <td width="18%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>LAUNCH DATE</strong></font></div></td> 	 
    </tr>
  <tr>
    <td>    
    <input type="text" name="INTMODEL"  size="15" maxlength="15" <%if (allMonth[0]!=null) out.println("value="+allMonth[0]); else out.println("value=");%>>
    </td>
    <td><input type="text" name="EXTMODEL"  size="15" maxlength="15"   <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=");%> >
    </td>
    <td><input type="text" name="PRODDESC"  size="20" maxlength="25"   <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=");%> >
    </td>
    <td> 
        <select name="BRAND">
            <option value="DBTEL">DBTEL</option>
            <option value="Dbtel">Dbtel</option>			
        </select>       
    </td>
    <td>
     <font size="2">
      <%	    	     		 		 
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
           sSqlC = "select PLATFORM as x, PLATFORM from PRPROD_PLATFORM ";
     	   sWhereC= "where PLATFORM IS NOT NULL order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(chooseItem);		  		  		  
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
    </font>  
    </td>
    <td>
     <font size="2">
      <%	    	     		 		 
	     try
         {  		 
		  String sSqlD = "";
		  String sWhereD = "";
		  
           sSqlD = "select DISTINCT DESIGNHOUSE as x, DESIGNHOUSE from PIMASTER ";
     	   sWhereD= "where DESIGNHOUSE IS NOT NULL AND DESIGNHOUSE NOT IN('null') order by x"; 
		   sSqlD = sSqlD+sWhereD;		  
		  		      
          Statement statementD=con.createStatement();
          ResultSet rsD=statementD.executeQuery(sSqlD);
          comboBoxBean.setRs(rsD);
		  if (designHouse!=null && !designHouse.equals("--"))  comboBoxBean.setSelection(designHouse);		  		  		  
	      comboBoxBean.setFieldName("DESIGNHOUSE");	   
          out.println(comboBoxBean.getRsString());
      
          rsD.close();      
		  statementD.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
    </font>  
    </td>
    <td nowrap><input type="text" name="LUANCHDATE"  size="10" maxlength="6" <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value="+dateBean.getMonthString()+dateBean.getYearString());%>>                
    </td>    
    </tr>
</table>
<strong>
<%
	  try
      {
	   
        String oneDArray[]= {"","INTERNAL MODEL","EXTERNAL MODEL","DESCRIPTION","BRAND","PLATFORM","DESIGN HOUSE","LAUNCH DATE"}; 		 	     			  
    	array2DimensionInputBean.setArrayString(oneDArray);
	     String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
	     if (chooseItem!=null && !chooseItem.equals("--") && designHouse!=null && !designHouse.equals("--")) 
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
             b[k][4]=chooseItem;					 
			 b[k][0]=intModel;b[k][1]=extModel;b[k][2]=prodDesc;b[k][3]=brand;b[k][5]=designHouse;b[k][6]=luanchDate;
			 array2DimensionInputBean.setArray2DString(b); 			 						 			 	   			              
		   } else {	   			  			
             String c[][]={{intModel,extModel,prodDesc,brand,chooseItem,designHouse,luanchDate}};						             			 
		     array2DimensionInputBean.setArray2DString(c); 						 	                
		   }                   	                       		        		  
		 } else { 
		   if (a!=null) 
		   { 
		     array2DimensionInputBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null
		 
		 //###################針對目前陣列內容進行檢查機制#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  String tp[]=array2DimensionInputBean.getArrayContent();
		  if  (T2!=null) 
		  {  		   
		    //-------------------------取得轉存用陣列-------------------- 		    
	        String temp[][]=new String[T2.length][T2[0].length];		    
			 for (int ti=0;ti<T2.length;ti++)
			 {
			    for (int tj=0;tj<T2[ti].length;tj++)  
			   {				 
				  temp[ti][tj]=T2[ti][tj];
				}
		      }		
		    //--------------------------------------------------------------------
			int ti = 0;
            int tj = 0;
      
             temp[ti][tj]="N";	
		     array2DimensionInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  } else {    		      		     
		      array2DimensionInputBean.setArray2DCheck(null);
		  }	 //end if of T2!=null	   
		  if (chkrs!=null) chkrs.close();
		  chkstat.close();		  
		 //##############################################################	    	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
</strong><BR>
<input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
  -----DETAIL you choosed to be saved---------------------------------------------------------------------------------------------------<BR>
<% 
     int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {
		        div1=a.length;
				div2=a[0].length;
	        	array2DimensionInputBean.setFieldName("ADDITEMS");			 			 	   			 
                out.println(array2DimensionInputBean.getArray2DString());  		   	 				
		 }	//enf of a!=null if
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/WSProductCenterInput.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSProductCenterInputInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" > 
    <input name="TYPE" type="HIDDEN" value="<%=type%>" > 
	<input name="REGION" type="HIDDEN" value="<%=region%>" >
	<input name="COUNTRY" type="HIDDEN" value="<%=country%>" >	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
