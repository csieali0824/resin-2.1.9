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
                    document.MYFORM.MONTH4.value,document.MYFORM.MONTH5.value,document.MYFORM.MONTH6.value,
				    document.MYFORM.MONTH7.value,document.MYFORM.MONTH8.value,document.MYFORM.MONTH9.value,
				    document.MYFORM.MONTH10.value,document.MYFORM.MONTH11.value,document.MYFORM.MONTH12.value,
                    document.MYFORM.MONTH13.value,document.MYFORM.MONTH14.value,document.MYFORM.MONTH15.value,
                    document.MYFORM.MONTH16.value,document.MYFORM.MONTH17.value,document.MYFORM.MONTH18.value,
				    document.MYFORM.MONTH19.value,document.MYFORM.MONTH20.value,document.MYFORM.MONTH21.value,
					document.MYFORM.MONTH22.value,document.MYFORM.MONTH23.value,document.MYFORM.MONTH24.value);   
   for (i=0;i<24;i++)
   {     
      if (warray[i]=="" || warray[i]==null)
     { 
      alert("Before you want to add , please do not let the Monthly Cost of forecast data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<24;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
            alert("Monthly forecast data should be numerical!!");   
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
           alert("Before you want to save , please do not let the Price Segment detail be Null !!");   
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
             alert("Monthly cost of forecast detail should be numerical!!");   
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
<title>WINS System - Price Segment Input Form</title>
</head>
<body>
<FORM ACTION="WSForecastCostInput.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>  Price Segment Input </strong></font><BR> 
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSPriceSegmentMaintenance.jsp">PRICE SEGMENT MAINTENANCE</A>  
<%   

String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String type=request.getParameter("TYPE");
String regionNo=request.getParameter("REGION");    
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String month1=request.getParameter("MONTH1"),month2=request.getParameter("MONTH2"),month3=request.getParameter("MONTH3");
String month4=request.getParameter("MONTH4"),month5=request.getParameter("MONTH5"),month6=request.getParameter("MONTH6");
String month7=request.getParameter("MONTH7"),month8=request.getParameter("MONTH8"),month9=request.getParameter("MONTH9");
String month10=request.getParameter("MONTH10"),month11=request.getParameter("MONTH11"),month12=request.getParameter("MONTH12");
String month13=request.getParameter("MONTH13"),month14=request.getParameter("MONTH14"),month15=request.getParameter("MONTH15");
String month16=request.getParameter("MONTH16"),month17=request.getParameter("MONTH17"),month18=request.getParameter("MONTH18");
String month19=request.getParameter("MONTH19"),month20=request.getParameter("MONTH20"),month21=request.getParameter("MONTH21");
String month22=request.getParameter("MONTH22"),month23=request.getParameter("MONTH23"),month24=request.getParameter("MONTH24");
String [] allMonth={month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12,month13,month14,month15,month16,month17,month18,month19,month20,month21,month22,month23,month24};

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
		  for (int gg=0;gg<25;gg++) //置入陣列中元素數
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
      <td width="25%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" size="2" face="Arial Black"><strong>Forecast Type:
          <% 				 		 
	     try
         {		  		  		 	    		  		 		 		  
		  Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery("select TYPE_DESC_GBL  from WSTYPE_CODE where TYPE='"+type+"'");
          if (rs.next())  out.println(rs.getString("TYPE_DESC_GBL"));		
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
	    </strong></font> 
      </td>
      <td width="23%"><font color="#333399" size="2" face="Arial Black"><strong>Region: <%=regionNo%>  </strong></font>        
      </td>
      <td width="26%"><font size="2">&nbsp;	  </font></td> 
   <td width="26%"><font size="2">  
     </strong></font> <INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/WSPriceSegmentInput.jsp")' ></td>    
  </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="84" bgcolor="#FFFFCC"><font size="2" face="Arial"><strong>Country</strong></font></td>       
	  <td width="68" colspan="1" bgcolor="#FFFF66"><div align="center"><font size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">1</font></strong>
       <!--%
		ymh1=dateBean.getYearString()+"/"+dateBean.getMonthString();
		out.println(ymh1);
	   %-->
      </font></div>
      </td> 
	  <td width="71" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">2</font></strong>	   
      </font></div></td> 
	  <td width="70" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">3</font></strong>
	 
      </font></div></td>
	  <td width="74" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">4</font></strong>
	 
      </font></div></td> 
	  <td width="76" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">5</font></strong>
	   
      </font></div></td> 
	  <td width="71" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">6</font></strong>
          <!--%dateBean.setAdjMonth(1);
		 ymh6=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh6);
	 %-->
      </font></div></td>
	  <td width="70" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">7</font></strong>
	      <!--%dateBean.setAdjMonth(1);
		 ymh7=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh7);
	 %-->
      </font></div></td>
	  <td width="74" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">8</font></strong>
	      <!--%dateBean.setAdjMonth(1);
		 ymh8=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh8);
	 %-->
      </font></div></td>
	  <td width="66" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">9</font></strong>
	      <!--%dateBean.setAdjMonth(1);
		 ymh9=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh9);
	 %-->
      </font></div></td>
	  <td width="76" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">10</font></strong>
	      <!--%dateBean.setAdjMonth(1);
		 ymh10=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh10);
	 %-->
      </font></div></td>
	  <td width="72" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">11</font></strong>
	      <!--%dateBean.setAdjMonth(1);
		 ymh11=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh11);
	 %-->
      </font></div></td>
	  <td width="72" colspan="1" bgcolor="#FFFF66"><div align="center"><font  size="2" color="#0000FF" face="Arial"><strong>Segment<BR><font color="#FF0000">12</font></strong>	   
      </font></div></td>	  
    </tr>
  <tr>
    <td> <font size="2">
      <%	    	     		 		 
	     try
         {  		   
		   String modelArray[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容		   
		   String aString="'--'";			     		  
		    if (chooseItem!=null && !chooseItem.equals("--"))
		   {            
   		     aString="'"+chooseItem+"'";
		   }					   
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
     <input type="text" name="MONTH1"  size="7"  <%if (allMonth[0]!=null) out.println("value="+allMonth[0]); else out.println("value=0");%> ><BR>
     <input type="text" name="MONTH2"  size="7"  <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=0");%> >
    </td>
    <td>
     <input type="text" name="MONTH3"  size="7" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=0");%> ><BR>
     <input type="text" name="MONTH4"  size="7" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value=0");%> >    
    </td>
    <td>
     <input type="text" name="MONTH5"  size="7" <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value=0");%>><BR>
     <input type="text" name="MONTH6"  size="7" <%if (allMonth[5]!=null) out.println("value="+allMonth[5]); else out.println("value=0");%>>   
    </td>
    <td>
      <input type="text" name="MONTH7"  size="7" <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value=0");%>>
      <input type="text" name="MONTH8"  size="7" <%if (allMonth[7]!=null) out.println("value="+allMonth[7]); else out.println("value=0");%>>   
    </td>
    <td>
      <input type="text" name="MONTH9"  size="7" <%if (allMonth[8]!=null) out.println("value="+allMonth[8]); else out.println("value=0");%>>
      <input type="text" name="MONTH10"  size="7" <%if (allMonth[9]!=null) out.println("value="+allMonth[9]); else out.println("value=0");%>> 
    </td>
    <td>
      <input type="text" name="MONTH11"  size="7" <%if (allMonth[10]!=null) out.println("value="+allMonth[10]); else out.println("value=0");%>>
      <input type="text" name="MONTH12"  size="7" <%if (allMonth[11]!=null) out.println("value="+allMonth[11]); else out.println("value=0");%>>    
    </td>
    <td>
      <input type="text" name="MONTH13"  size="7"  <%if (allMonth[12]!=null) out.println("value="+allMonth[12]); else out.println("value=0");%> >
      <input type="text" name="MONTH14"  size="7"  <%if (allMonth[13]!=null) out.println("value="+allMonth[13]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH15"  size="7"  <%if (allMonth[14]!=null) out.println("value="+allMonth[14]); else out.println("value=0");%> >
      <input type="text" name="MONTH16"  size="7"  <%if (allMonth[15]!=null) out.println("value="+allMonth[15]); else out.println("value=0");%> >    
    </td>
    <td>
      <input type="text" name="MONTH17"  size="7"  <%if (allMonth[16]!=null) out.println("value="+allMonth[16]); else out.println("value=0");%> >
      <input type="text" name="MONTH18"  size="7"  <%if (allMonth[17]!=null) out.println("value="+allMonth[17]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH19"  size="7"  <%if (allMonth[18]!=null) out.println("value="+allMonth[18]); else out.println("value=0");%> >
      <input type="text" name="MONTH20"  size="7"  <%if (allMonth[19]!=null) out.println("value="+allMonth[19]); else out.println("value=0");%> > 
    </td>
    <td>
      <input type="text" name="MONTH21"  size="7"  <%if (allMonth[20]!=null) out.println("value="+allMonth[20]); else out.println("value=0");%> >
      <input type="text" name="MONTH22"  size="7"  <%if (allMonth[21]!=null) out.println("value="+allMonth[21]); else out.println("value=0");%> >
    </td>
    <td>
      <input type="text" name="MONTH23"  size="7"  <%if (allMonth[22]!=null) out.println("value="+allMonth[22]); else out.println("value=0");%> >
      <input type="text" name="MONTH24"  size="7"  <%if (allMonth[23]!=null) out.println("value="+allMonth[23]); else out.println("value=0");%> >  
    </td>
    </tr>
</table>
<strong>
<%
	  try
      { //out.println("step1");
	    String oneDArray[]= {"","COUNTRY","SGMT 1 FR","SGMT 1 TO","SGMT 2 FR","SGMT 2 TO","SGMT 3 FR","SGMT 3 TO","SGMT 4 FR","SGMT 4 TO","SGMT 5 FR","SGMT 5 TO","SGMT 6 FR","SGMT 6 TO","SGMT 7 FR","SGMT 7 TO","SGMT 8 FR","SGMT 8 TO","SGMT 9 FR","SGMT 9 TO","SGMT 10 FR","SGMT 10 TO","SGMT 11 FR","SGMT 11 TO","SGMT 12 FR","SGMT 12 TO"}; 	 	     			  
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
			 b[k][1]=month1;b[k][2]=month2;b[k][3]=month3;b[k][4]=month4;b[k][5]=month5;b[k][6]=month6;	
			 b[k][7]=month7;b[k][8]=month8;b[k][9]=month9;b[k][10]=month10;b[k][11]=month11;b[k][12]=month12;
             b[k][13]=month13;b[k][14]=month14;b[k][15]=month15;b[k][16]=month16;b[k][17]=month17;b[k][18]=month18;	
			 b[k][19]=month19;b[k][20]=month20;b[k][21]=month21;b[k][22]=month22;b[k][23]=month23;b[k][24]=month24;				 
			 forePriCostInputBean.setArray2DString(b); 			 						 			 	   			              
		   } else {	//out.println("step6");	     			  
			 String c[][]={{chooseItem,month1,month2,month3,month4,month5,month6,month7,month8,month9,month10,month11,month12,month13,month14,month15,month16,month17,month18,month19,month20,month21,month22,month23,month24}};			             			 
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
</strong><BR>
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
                //out.println(forePriCostInputBean.getArray2DFrToString()); 				
				out.println(forePriCostInputBean.getArray2DString()); 		   	 				
		 }	//enf of a!=null if
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit("../jsp/WSPriceSegmentInput.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSPriceSegmentInsert.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="TYPE" type="HIDDEN" value="<%=type%>" > 
	<input name="REGION" type="HIDDEN" value="<%=regionNo%>" >	
	<input name="CURR" type="HIDDEN" value="<%=curr%>" > 
	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
