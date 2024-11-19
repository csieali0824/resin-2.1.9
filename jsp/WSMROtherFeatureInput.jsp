<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean" %>
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
   warray=new Array(document.MYFORM.FEATURECODE.value,document.MYFORM.FEATURE.value,document.MYFORM.FEATUREDESC.value);   
   for (i=0;i<3;i++)
   {     
      if (warray[i]=="" || warray[i]==null || warray[i]=="--" )
     { 
      alert("Before you want to add , please do not let the any fields of Sales Product data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<3;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    //if ("0123456789.".indexOf(c,0)<0) 
        /*
         if ("0123456789.".indexOf(c,0)<0 && c.match(/[^a-z|^A-Z]/g)) 
	     {
            alert("Product Information of Price detail should be numerical or character!!");   
            return(false);
		 } 
       */
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
   
    for (i=0;i<dim1;i++)
   {     
      for (k=1;k<dim2;k++)
	  {
         txt=document.MYFORM.elements["MONTH"+i+"-"+k].value;
	     for (j=0;j<txt.length;j++)      
         { 
	       c=txt.charAt(j);
	       // if ("0123456789.".indexOf(c,0)<0) 
          /*
           if ("0123456789.".indexOf(c,0)<0 && c.match(/[^a-z|^A-Z]/g)) 
	       {
             alert("Product Information of Price detail should be numerical or character!!");   
             return(false);
		  }
         */
         }
	   } //enf for of k
   } //end of for  null check

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit3(URL)
{
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
<title>WINS System-產品其他特徵資料新增</title>
</head>
<body>
<FORM ACTION="WSMRProdAprnceInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>  產品編碼系統-其他特徵代碼新增 </strong></font> &nbsp; &nbsp; &nbsp; 
  &nbsp;<BR>
  <A HREF="../WinsMainMenu.jsp">首頁</A> &nbsp;&nbsp;<A HREF="../jsp/WSModelEncodingSub.jsp">產品編碼管理作業</A> &nbsp;&nbsp;<A HREF="../jsp/WSMRProdAprnceInquiry.jsp">產品其他特徵代碼資料查詢</A> 
<%   
//String vYear=request.getParameter("VYEAR");
//String vMonth=request.getParameter("VMONTH");
//dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);
int commitmentMonth=0;
array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");
//String type=request.getParameter("TYPE");
//String region=request.getParameter("REGION");
//String country=request.getParameter("COUNTRY");     
//String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
//String chooseItem=request.getParameter("CHOOSEITEM");
//String designHouse=request.getParameter("DESIGNHOUSE");
String featureCode=request.getParameter("FEATURECODE"),feature=request.getParameter("FEATURE"),featureDesc=request.getParameter("FEATUREDESC");
//String brand=request.getParameter("BRAND"),platForm=request.getParameter("PLATFORM"),luanchDate=request.getParameter("LUANCHDATE");
//String cUser=request.getParameter("CUSER"),cDate=request.getParameter("CDATE");
String [] allMonth={featureCode,feature,featureDesc};
String entry=request.getParameter("ENTRY");
  
          
  
if (entry==null || entry.equals("") )  {  }
else { array2DimensionInputBean.setArray2DString(null); } 




//String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="";
 
   String sSql = "select WEBID from WSUSER ";
   String sWhere= "where USERNAME='"+UserName+"' "; 
   sSql = sSql+sWhere;		  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery(sSql);
   if (rs.next()) { userID = rs.getString(1); }
   rs.close();
   statement.close();

out.println("<BR><font color='#330099' face='Arial Black'><strong>  USER :"+userID+"</strong></font>");

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
		  for (int gg=0;gg<3;gg++) //置入陣列中元素數
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
 
  if ( bringLast!=null   && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
  {
    /*
    Statement blstat=con.createStatement();
    ResultSet blrs=null;
                for (int jj=0;jj<6;jj++)  //因為有6個月
				{		   				  				
				  blrs=blstat.executeQuery("select FCCOST,FCMVER FROM PSALES_FORE_COST where FCCOMP='"+comp+"' and FCTYPE='"+type+"' and FCREG='"+region+"' and FCCOUN='"+country+"' and FCPRJCD='"+chooseItem+"' and FCMONTH='"+dateBean.getMonthString()+"' and FCYEAR='"+dateBean.getYearString()+"' and FCCURR='"+curr+"' order by FCMVER DESC");                  				  
				  if (blrs!=null)
				  {				    					 
					 if ( blrs.next())
					 {
				       allMonth[jj]=blrs.getString("FCCOST");					  					    						
					 } else {
					    allMonth[jj]="0";
					 }				  				    
				  } //end if of blrs!=null				  
				  blrs.close();
				  dateBean.setAdjMonth(1);
				} //end for of tj loop      			
	  blstat.close();		
   */	
  } //enf of bringLast if   
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<table width="60%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="18%" bgcolor="#003366"><div align="center"><font face="Arial" color="#FFFFFF" size="3"><strong>特徵代碼</strong></font></div></td>
	  <td width="18%" colspan="1" bgcolor="#003366"><div align="center"><font face="Arial" color="#FFFFFF" size="3"><strong>產品其他特徵</strong></font></div></td> 
      <td width="48%" colspan="1" bgcolor="#003366"><div align="center"><font face="Arial" color="#FFFFFF" size="3"><strong>備註</strong></font></div></td> 	  
	  <!--%<td width="15%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>INPUT USER </strong></font></div></td> %-->
	  <!--%<td width="15%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font face="Arial" size="2"><strong>INPUT DATE TIME </strong></font></div></td>%-->
      <td width="16%" rowspan="3" ><div align="center"><INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/WSMROtherFeatureInput.jsp")'></div></td> 
    </tr>
  <tr>
    <td>    
    <input type="text" name="FEATURECODE"  size="15" maxlength="1" <%if (allMonth[0]!=null) out.println("value="); else out.println("value=");%>>
    </td>
    <td><input type="text" name="FEATURE"  size="15" maxlength="15"   <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%> >
    </td>
    <td><input type="text" name="FEATUREDESC"  size="25" maxlength="25"   <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%> >
    </td>    
    </tr>    
  <tr bgcolor="#003366">
    <td colspan="3"><div align="center"><strong>
     <%
	  try
      {
	    //String oneDArray[]= {"","MODEL",ymh1,ymh2,ymh3,ymh4,ymh5,ymh6}; 
        String oneDArray[]= {"增項","特徵代碼","產品其他特徵","備註"}; 		 	     			  
    	array2DimensionInputBean.setArrayString(oneDArray);
	     String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";
	     if (featureCode!=null && !featureCode.equals("") && feature!=null && !feature.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {  //out.println("step1");             		    
		   if (a!=null) 
		   { //out.println("step2");
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { //out.println("step3");
			  for (j=0;j<a[i].length;j++)
			  { //out.println("step4");
			    b[i][j]=a[i][j];	
                if (a[k][0].equals(featureCode)) { dupFLAG = "TRUE"; }				
			  }
			  k++;
			 }
			 //b[k][0]=chooseItem;
             //b[k][4]=chooseItem;	
             Statement stateIMDUP=con.createStatement();
             String sqlIMDUP = "select * from MROTH_FEATURE where FTURE_CODE='"+featureCode+"' ";
             //out.println(sqlIMDUP);     
             ResultSet rsIMDUP=stateIMDUP.executeQuery(sqlIMDUP);             
             if (rsIMDUP.next() )
             { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input :</font><font color='#FFFFFF' face='Arial Black'> "+featureCode+"</font><font color='#FF0000' face='Arial Black'> on Database history"+"</font>"); }
             else if (dupFLAG=="TRUE" || dupFLAG.equals("TRUE")) { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input :</font><font color='#FFFFFF' face='Arial Black'> "+featureCode+"</font><font color='#FF0000' face='Arial Black'> on Your list"+"</font>"); }
             else
             {
              b[k][0]=featureCode;b[k][1]=feature;b[k][2]=featureDesc;
			  array2DimensionInputBean.setArray2DString(b); 
			  //array2DimensionInputBean.setArray2DString(b);
              dupFLAG = "FALSE";     	
             } 	
             rsIMDUP.close();
             stateIMDUP.close();
				 
			 			 						 			 	   			              
		   } else {	//out.println("step5");	     			  
			 //String c[][]={{chooseItem,month1,month2,month3,month4,month5,month6}};             	

             Statement stateIMDUP=con.createStatement();
             String sqlIMDUP = "select * from MROTH_FEATURE where FTURE_CODE='"+featureCode+"' ";
             //out.println(sqlIMDUP);     
             ResultSet rsIMDUP=stateIMDUP.executeQuery(sqlIMDUP);             
             if (rsIMDUP.next() )
             { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input :</font><font color='#FFFFFF' face='Arial Black'> "+featureCode+"</font><font color='#FF0000' face='Arial Black'> on Database history"+"</font>"); }
             else if (dupFLAG=="TRUE" || dupFLAG.equals("TRUE")) { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input :</font><font color='#FFFFFF' face='Arial Black'> "+featureCode+"</font><font color='#FF0000' face='Arial Black'> on your list"+"</font>"); }
             else
             {
              String c[][]={{featureCode,feature,featureDesc}};						             			 
		      array2DimensionInputBean.setArray2DString(c); 			  
             } 	
             rsIMDUP.close();
             stateIMDUP.close();   
					 	                
		   }                   	                       		        		  
		 } else { //out.println("step6");
		   if (a!=null) 
		   { //out.println("step7");
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
            /*
			 for (int ti=0;ti<temp.length;ti++)
			 {
			    for (int tj=1;tj<=commitmentMonth;tj++)  //因為只有1月為commitment
				{
                 
				  String tpym=tp[tj+1]; 				  
				  String tpy=tpym.substring(0,4); //get year String				  
				  String tpm=tpym.substring(5,7); //get month String	   								  
				  chkrs=chkstat.executeQuery("select FCCOST,FCMVER FROM PSALES_FORE_COST where FCCOMP='"+comp+"' and FCTYPE='"+type+"' and FCREG='"+region+"' and FCCOUN='"+country+"' and FCPRJCD='"+temp[ti][0]+"' and FCYEAR='"+tpy+"' and FCMONTH='"+tpm+"' order by FCMVER DESC");                  				  
				  if (chkrs!=null)
				  {				    					 
					 if ( chkrs.next())
					 {					   
				       temp[ti][tj]=chkrs.getString("FCCOST");
					  } else {
					    temp[ti][tj]="N";						
					  }
				  } else {
				     temp[ti][tj]="N";					 
				  } //end if of chkrs!=null
				  chkrs.close();
                
			  } //end for of tj loop
			 }  //end for of ti loop  
           */      
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
	 <%
	    try 
		{
	      String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
		  float total=0;
		  /* 
           if (a!=null) 
		   {
		     for (int cj=0;cj<a.length;cj++)
			 {
			   total=total+Float.parseFloat(a[cj][1]);
			 } //end of for
			 ////out.println(total);
		  } //end of a!=null if		
        */  
	    } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
	 %>	
	 <%
	    try 
		{
	      String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
		  float total=0;
		  /* 
           if (a!=null) 
		   {
		     for (int cj=0;cj<a.length;cj++)
			 {
			   total=total+Float.parseFloat(a[cj][1]);
			 } //end of for
			 ////out.println(total);
		  } //end of a!=null if		
        */  
	    } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
	 %></strong></div>
	</td>        
    </tr>
</table>
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
<INPUT name="button2" TYPE="button" onClick='setSubmit3("../jsp/WSMROtherFeatureInput.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSMROtherFeatureInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" >     
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
