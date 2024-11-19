<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ForePriCostInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
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
                                   document.MYFORM.MONTH4.value,document.MYFORM.MONTH5.value,document.MYFORM.MONTH6.value,
								   document.MYFORM.MONTH7.value,document.MYFORM.MONTH8.value,document.MYFORM.MONTH9.value,
								   document.MYFORM.MONTH10.value,document.MYFORM.MONTH11.value,document.MYFORM.MONTH12.value );   
   for (i=0;i<12;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the Monthly sales quota of forecast data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<12;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
            alert("Monthly sales quota of forecast data should be numerical!!");   
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
	     if (document.MYFORM.elements["MONTH"+i+"-"+j].value=="" || document.MYFORM.elements["MONTH"+i+"-"+j].value==null)
		 { 
           alert("Before you want to save , please do not let the Monthly sales quota of forecast  detail be Null !!");   
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
             alert("Monthly sales quota of forecast detail should be numerical!!");   
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
<title>Monthly Sales Quota Forecast Input Form</title>
</head>
<body>
<FORM ACTION="SASalesQuotaForecastInput.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> 業務員銷售業績額度輸入</strong></font> 
<BR><A HREF="/wins/WinsMainMenu.jsp">回首頁</A>
<%   
String vYear=request.getParameter("VYEAR");
String vMonth=request.getParameter("VMONTH");

if (vYear==null) vYear = dateBean.getYearString();
if (vMonth==null) vMonth = dateBean.getMonthString();
//
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
int commitmentMonth=0;
forePriCostInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");
String dept=request.getParameter("DEPT");
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String chooseItem2=request.getParameter("CHOOSEITEM2");
String month1=request.getParameter("MONTH1"),month2=request.getParameter("MONTH2"),month3=request.getParameter("MONTH3");
String month4=request.getParameter("MONTH4"),month5=request.getParameter("MONTH5"),month6=request.getParameter("MONTH6");
String month7=request.getParameter("MONTH7"),month8=request.getParameter("MONTH8"),month9=request.getParameter("MONTH9");
String month10=request.getParameter("MONTH10"),month11=request.getParameter("MONTH11"),month12=request.getParameter("MONTH12");
String [] allMonth={month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12};
//String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
String [] ymh={"","","","","","","","","","","",""};

out.println("<BR><font color='#330099' face='Arial Black'><strong>This Month is :"+thisDateBean.getYearString()+"/"+thisDateBean.getMonthString()+"</strong></font>");

if (curr ==null || curr.equals("")) curr = "USD";

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
		  for (int gg=0;gg<13;gg++) //置入陣列中元素數
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
/* 
  if ( bringLast!=null   && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
  {
    Statement blstat=con.createStatement();
    ResultSet blrs=null;
                for (int jj=0;jj<12;jj++)  //因為有12個月
				{			   				                          				
				  blrs=blstat.executeQuery("select FSALES,FPMVER FROM PSALES_HIERCHY_SQUOTA where FSHIERCHY='"+dept+"' and FSALES='"+chooseItem+"' and FPMONTH='"+dateBean.getMonthString()+"' and FPYEAR='"+dateBean.getYearString()+"' and FPCURR='"+curr+"' order by FPYEAR,FPMONTH DESC");                  				  
				  if (blrs!=null)
				  {				    					 
					 if ( blrs.next())
					 {
				       allMonth[jj]=blrs.getString("FSALES");					  					    						
					 } else {
					    allMonth[jj]="0";
					 }				  				    
				  } //end if of blrs!=null				  
				  blrs.close();
				  dateBean.setAdjMonth(1);	
				} //end for of tj loop      			
	  blstat.close();			
  } //enf of bringLast if   
*/
  dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("pp Exception:"+e.getMessage());
}  
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="40%" bordercolor="#FFFFFF"><font color="#330099" size="2" face="Arial Black"><strong>新增
     <INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/SASalesQuotaForecastInput.jsp?DEPT=<%=dept%>")' >
      </strong></font> </td>      
      <td width="60%"><font size="2" color="#333399" face="Arial Black"><strong>(幣別:美金 / 單位:千) 
        </strong></font><font  color="#ff0000" face="Arial Black"> (重複輸入將以本次輸入額度為標準)</font></td>     
  </tr>
</table>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr>      
      <td width="10%" bgcolor="#FFFFCC"><font size="2">業務員</font></td>	  
<!--	  <td width="7.5%" colspan="1" bgcolor="#FF6666"><div align="center"><font size="2">  -->
	  <%
	    for (int i=0;i<12;i++)   
		 {
   	       out.println("<td width='7.5%' colspan='1' bgcolor='#FFFFCC'><div align='center'><font  size='2'>"); 
   		   dateBean.setAdjMonth(i);
	       ymh[i]=dateBean.getYearString()+"/"+dateBean.getMonthString();
	       out.println(ymh[i]);
   		   dateBean.setAdjMonth(-i);
           out.println("</font></div></td>");
		 }
	  %>
<!--      </font></div></td> 
	  <td width="7.5%" colspan="1" bgcolor="#FFFFCC"><div align="center"><font  size="2"> -->
	    <%
/*		
		dateBean.setAdjMonth(1);
		ymh3=dateBean.getYearString()+"/"+dateBean.getMonthString();
	    out.println(ymh3);
*/
	  %>
    </tr>
  <tr>
    <td> <font size="2">
      <%	    	     		 		 
	     try
         {   
		   String modelArray[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容
		   String aString="'--'";
//		   if (bringLast==null || chooseItem.equals("--"))
		   if (chooseItem==null || chooseItem.equals("--"))
		   {            
   		     aString="'"+chooseItem+"'";
		   }			 
		   else
           {
   		     aString="'"+chooseItem.substring(0,chooseItem.indexOf("@"))+"'";
		   }		   
	        if (modelArray!=null) 
	        {
	           for (int k=0;k<modelArray.length;k++)
	          {
	            String ss=modelArray[k][0].substring(0,modelArray[k][0].indexOf("@")); 
				aString=aString+",'"+ss+"'";
   	          }
	        }		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		              		 
		  sSqlC = "select DISTINCT Trim(SMFAXN)||'@'||Trim(SNAME) as x, SNAME  from SSM ";		  
		  sWhereC= "where SMFAXN !='' and SID = 'SM' and SMFAXN not in ("+aString+") and szip ='"+dept+"'  order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=ifxTestCon.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (bringLast!=null && bringLast.equals("Y") && !chooseItem.equals("--"))  comboBoxBean.setSelection(chooseItem);		  		  		  
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
    <td><input type="text" name="MONTH1"  size="7"  <%if (allMonth[0]!=null) out.println("value="+allMonth[0]); else out.println("value=0");%> >
    </td>
    <td><input type="text" name="MONTH2"  size="7" <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=0");%> >
    </td>
    <td><input type="text" name="MONTH3"  size="7" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=0");%>>
    </td>
    <td><input type="text" name="MONTH4"  size="7" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value=0");%>>
    </td>
    <td><input type="text" name="MONTH5"  size="7" <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value=0");%>>
    </td>
    <td><input type="text" name="MONTH6"  size="7" <%if (allMonth[5]!=null) out.println("value="+allMonth[5]); else out.println("value=0");%>></td>
    <td><input type="text" name="MONTH7"  size="7"  <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value=0");%> ></td>
    <td><input type="text" name="MONTH8"  size="7"  <%if (allMonth[7]!=null) out.println("value="+allMonth[7]); else out.println("value=0");%> ></td>
    <td><input type="text" name="MONTH9"  size="7"  <%if (allMonth[8]!=null) out.println("value="+allMonth[8]); else out.println("value=0");%> ></td>
    <td><input type="text" name="MONTH10"  size="7"  <%if (allMonth[9]!=null) out.println("value="+allMonth[9]); else out.println("value=0");%> ></td>
    <td><input type="text" name="MONTH11"  size="7"  <%if (allMonth[10]!=null) out.println("value="+allMonth[10]); else out.println("value=0");%> ></td>
    <td><input type="text" name="MONTH12"  size="7"  <%if (allMonth[11]!=null) out.println("value="+allMonth[11]); else out.println("value=0");%> ></td>
    </tr>  
  <tr>  
    <td colspan="14"><BR><HR SIZE=2></td>
    </tr>
  <tr bgcolor="#FFFFCC">
    <td colspan="1"><div align="right">      <strong>
      <%
	  try
      {
//	    String oneDArray[]= {"","業務員",ymh1,ymh2,ymh3,ymh4,ymh5,ymh6,ymh7,ymh8,ymh9,ymh10,ymh11,ymh12}; 	 	     			  
	    String oneDArray[]= {"","業務員",ymh[0],ymh[1],ymh[2],ymh[3],ymh[4],ymh[5],ymh[6],ymh[7],ymh[8],ymh[9],ymh[10],ymh[11]}; 	 	     			  
    	forePriCostInputBean.setArrayString(oneDArray);
	     String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
//	     if (chooseItem!=null && !chooseItem.equals("--")  && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
	     if (chooseItem!=null && !chooseItem.equals("--")  ) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {               		    
		   if (a!=null && !a[a.length-1][0].equals(chooseItem) ) 
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
			 b[k][1]=month1;b[k][2]=month2;b[k][3]=month3;b[k][4]=month4;b[k][5]=month5;b[k][6]=month6;	
			 b[k][7]=month7;b[k][8]=month8;b[k][9]=month9;b[k][10]=month10;b[k][11]=month11;b[k][12]=month12;			 
		     forePriCostInputBean.setArray2DString(b); 	
		   } else {		     			  
			 String c[][]={{chooseItem,month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12}};			             			 
		     forePriCostInputBean.setArray2DString(c); 						 	                
		   }                   	                       		        		  
		 } else {
		   if (a!=null) 
		   {
			 if (!a[a.length-1][0].equals(chooseItem))
		       { 
                   forePriCostInputBean.setArray2DString(a);   
			   }
		   } 
		 }
		 //end if of chooseItem is null
		 
		 //###################針對目前陣列內容進行檢查機制#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  String tp[]=forePriCostInputBean.getArrayContent();
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
			
			 for (int ti=0;ti<temp.length;ti++)
			 {
			    for (int tj=1;tj<=commitmentMonth;tj++)  //因為只有n個月為commitment
				{
				  String tpym=tp[tj+1]; 				  
				  String tpy=tpym.substring(0,4); //get year String				  
				  String tpm=tpym.substring(5,7); //get month String	   								  
				  String fmSale=null;
				  fmSale=temp[ti][0].substring(1,temp[ti][0].indexOf("@"));
				  chkrs=chkstat.executeQuery("select FSQUOTA,FPMVER FROM PSALES_HIERCHY_SQUOTA where FSHIERCHY='"+dept+"'  and FSALES='"+fmSale+"' and FPYEAR='"+tpy+"' and FPMONTH='"+tpm+"' and FPCURR='"+curr+"' order by FPMVER DESC");                  				  
				  if (chkrs!=null)
				  {				    					 
					 if ( chkrs.next())
					 {					   
				       temp[ti][tj]=chkrs.getString("FSQUOTA");
					  } else {
					    temp[ti][tj]="0";						
					  }
				  } else {
				     temp[ti][tj]="0";					 
				  } //end if of chkrs!=null
				  chkrs.close();
				} //end for of tj loop
			 }  //end for of ti loop
 	         forePriCostInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  } else {    		      		     
			  forePriCostInputBean.setArray2DCheck(null);
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
      Total</strong></div></td>
	<% //2005-05-19
 	    for (int ck=1;ck<13;ck++)
	    {
//          if (ck == 1)
//		    { out.println("<td bgcolor='#FF3300'>");}
//		  else
		     out.println("<td bgcolor='#FFFFCC'>");
   	      try 
	  	   {
	         String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
		     float total=0;
		     if (a!=null) 
		     {
		       for (int cj=0;cj<a.length;cj++)
			   {
			     if (a[cj][ck] != null)
			       { total=total+Float.parseFloat(a[cj][ck]); }
			   } //end of for
		       out.println(total);
		     } //end of a!=null if		  
	       } //end of try
          catch (Exception e)
           {
             out.println("Exception:"+e.getMessage());		  
           }
          out.println("</td>");
		}  // end of for ck   
	%>
    </tr>
</table>
<input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
-----DETAIL you choosed to be saved----------------------------------------------------------<font color="#0000FF"><strong>------(Currency:
<font color="RED"><%=curr%></font><font color="#0000FF"> / Unit:</font><font color="RED">K</font>)--------</strong></font>------------------<BR>
<% 
     int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
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
        out.println("zz Exception:"+e.getMessage());
       }
       %>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/SASalesQuotaForecastInput.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/SASalesQuotaForecastInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" > 
    <input name="DEPT" type="HIDDEN" value="<%=dept%>" > 
	<input name="CURR" type="HIDDEN" value="<%=curr%>" > 
	<input name="VYEAR" type="HIDDEN" value="<%=vYear%>" > 
	<input name="VMONTH" type="HIDDEN" value="<%=vMonth%>" > 
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

</body>
</html>
