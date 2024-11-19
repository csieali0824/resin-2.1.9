<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
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
function btnCustomerInfo()
{ 
  subWin=window.open("subwindow/CustomerIMEISubWindow.jsp","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function setSubmit(URL)
{
   warray=new Array(document.MYFORM.CHOOSEITEM.value);   
   for (i=0;i<1;i++)
   {     
      if (warray[i]<="1" && warray[i]>="999999999999999")
     { 
      alert("Before you want to add , please be sure the IMEI data 15 digit !!");   
      return(false);
     } 
   } //end of for  null check
   
   
   for (i=0;i<1;i++)
   {     
     txt=warray[i];
	 for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	     if ("0123456789".indexOf(c,0)<0) 
         //  if ("0123456789.".indexOf(c,0)<0 && c.match(/[^a-z|^A-Z]/g)) 
	     {
            alert("IMEI data should be numerical !!");   
            document.MYFORM.CHOOSEITEM.focus();   
            return(false);
		 } 
      
      } 
    if (txt.length<=14)
    {
      alert("IMEI data length should be 15 digits !!!"); 
      document.MYFORM.CHOOSEITEM.focus();
      return(false);    
    }
   } //end of for  null check

   warray2=new Array(document.MYFORM.CUSTNAME.value);
   for (i=0;i<1;i++)
   {     
     custName=warray2[i];
	
	 //c=custName.charAt(j);
	 if (custName=="" || custName==null)         
	 {
       alert("CUSTOMER NAME data should been Input,Please check your list !!");   
       document.MYFORM.CUSTNAME.focus();
       return(false);
	 }   
   } //end of for  null check       

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit3(URL)
{
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
/*
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
*/   
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
</script>
<%
  int commitmentMonth=0;
array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");
String type=request.getParameter("TYPE");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");     
String curr=request.getParameter("CURR");
String [] addItems=request.getParameterValues("ADDITEMS");
String chooseItem=request.getParameter("CHOOSEITEM");
String imei=request.getParameter("IMEI");
String unitNo=request.getParameter("UNITNO");
String custName=request.getParameter("CUSTNAME");
String contactTel=request.getParameter("CONTACTTEL");
String contactFax=request.getParameter("CONTACTFAX");
String custAddress=request.getParameter("CUSTADDRESS");
String contact=request.getParameter("CONTACT");
//String brandChoose=request.getParameter("BRANDCHOOSE");
//String gmIndex=request.getParameter("GMINDEX"),cUser=request.getParameter("CUSER"),cDate=request.getParameter("CDATE");
String [] allMonth={chooseItem,unitNo,custName,contactTel,contactFax,custAddress,contact};
String back=request.getParameter("BACK");
    // String UserName="KERWIN CHEN";
     String UserID="B01815";
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
	 String repCenterNo="";
	 String locale ="";
	 String sendImeiFreq ="0";
	 String agentNo ="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WINS System-Sales Product Data Input Form</title>
</head>
<body onLoad="this.document.MYFORM.CHOOSEITEM.focus()">
<FORM ACTION="WSIMEITrackingInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>  經銷商/客戶優惠活動IMEI碼輸入 </strong></font> &nbsp; &nbsp; &nbsp; 
  &nbsp;<BR>
  <A HREF="../WinsMainMenu.jsp">HOME</A>
<%   
//String vYear=request.getParameter("VYEAR");
//String vMonth=request.getParameter("VMONTH");
//dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);

//out.println("Step0");
  try
  {
    String sql = "select REPCENTERNO, REPLOCALE from RPREPPERSON a, RPUSER b where a.USERID=b.USERID and b.WEBID='"+UserName+"' ";	
	Statement stateRepair=conREPAIR.createStatement();
	ResultSet rsRepair=stateRepair.executeQuery(sql);
	if (rsRepair.next())
	{ 
	   repCenterNo = rsRepair.getString("REPCENTERNO"); 
	   locale = rsRepair.getString("REPLOCALE"); 
	}
	else
	{
	   repCenterNo = "003";
	   locale = "886";
	}
	rsRepair.close();
	stateRepair.close(); 
   } //end of try
   catch (Exception e)
   {
    out.println(e.getMessage());
   }//end of catch     
  
  //if (back==null || back.equals("") )  { array2DimensionInputBean.setArray2DString(null); } 




//String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="";
//out.println("<BR><font color='#330099' face='Arial Black'><strong>This Year/Month is :"+thisDateBean.getYearString().substring(2,4)+"/"+thisDateBean.getMonthString()+"    USER :"+userID+"</strong></font>");

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
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td>&nbsp;</td>     
  </tr>
</table>
<table align="center" border="1" cellpadding="0" cellspacing="0" bgcolor="#CCFFCC">    
    <tr valign="baseline">             
      <td nowrap align="right" colspan="1"><strong><font color="#0000FF">客戶資料帶入</font></strong><font color="#0000FF">:</font></td>            
      <td colspan="2">&nbsp;&nbsp;
      <input name="button0" type=button onClick="btnCustomerInfo()" value="客戶資料"></td><td nowrap align="right"><strong>統一編號</strong>:</td>            
      <td colspan="2"><input type="text" name="UNITNO" size="8" maxlength="8" <%if (allMonth[1]!=null) out.println("value="+allMonth[1]); else out.println("value=");%> ></td>	
    </tr>       
	<tr valign="baseline"> 
	   <td nowrap align="right"><strong>客戶名稱</strong>:</td>            
       <td><input type="text" name="CUSTNAME" size="50" maxlength="50" <%if (allMonth[2]!=null) out.println("value="+allMonth[2]); else out.println("value=");%> ></td>	 
	   <td nowrap align="right"><strong>連絡電話</strong>:</td>            
       <td><input type="text" name="CONTACTTEL" size="20" maxlength="20" <%if (allMonth[3]!=null) out.println("value="+allMonth[3]); else out.println("value=");%> ></td>
	   <td nowrap align="right"><strong>傳真號碼</strong>:</td>            
       <td><input type="text" name="CONTACTFAX" size="20" maxlength="20" <%if (allMonth[4]!=null) out.println("value="+allMonth[4]); else out.println("value=");%> ></td>	 
    </tr> 
	<tr valign="baseline"> 
	   <td nowrap align="right"><strong>客戶地址</strong>:</td>            
       <td colspan="3"><input type="text" name="CUSTADDRESS" size="80" maxlength="80" <%if (allMonth[5]!=null) out.println("value="+allMonth[5]); else out.println("value=");%> ></td>
	   <td nowrap align="right"><strong>連絡人</strong>:</td>            
       <td colspan="1"><input type="text" name="CONTACT" size="20" maxlength="20" <%if (allMonth[6]!=null) out.println("value="+allMonth[6]); else out.println("value=");%> ></td>  
    </tr>  
    <tr>
      <td nowrap align="right" colspan="1"><strong><font color="#FF0000">IMEI號</font></strong><font color="#FF0000">:</font></td>            
      <td colspan="3"><div align="left"><input type="text" name="CHOOSEITEM"  size="30" maxlength="15"></div></td>  
    </tr>   
          <tr valign="baseline">             
            <td colspan="6"><div align="center"><INPUT name="button3" type="button" onClick='setSubmit("../jsp/WSIMEITrackingInput.jsp")' value="Add"></div></td>
          </tr>
</table><div align="center"><font color='#FF0000'><strong>
<table width="100%" border="1" cellspacing="0" cellpadding="0">       
  <tr bgcolor="#D0FFFF">
    <td colspan="5"><div align="center"><strong>
     <%

	  try
      {
	    //String oneDArray[]= {"","MODEL",ymh1,ymh2,ymh3,ymh4,ymh5,ymh6}; 
        String oneDArray[]= {"","IMEI","UNITNO","CUST NAME","CONTACT TEL","CONTACT FAX","CUST ADDRESS","CONTACT"}; 		 	     			  
    	array2DimensionInputBean.setArrayString(oneDArray);
         //out.println("step0"); 
	     String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";
	     if (chooseItem!=null && !chooseItem.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {  //out.println("step1");             		    
		   if (a!=null) 
		   { //out.println("step2");
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { //out.println("step3");
			  for (j=0;j<a[i].length;j++)
			  { //out.println("step4");
			    b[i][j]=a[i][j];			
                if (a[k][0].equals(chooseItem)) { dupFLAG = "TRUE"; }	
			  }
			  k++;
			 } 
             //out.println("a[k-1][0]="+a[k-1][0]+"/"+"a[k-1][1]="+a[k-1][1]);
             //out.println("chooseItem="+chooseItem+"/"+"=brandChoose"+brandChoose); 
			 //b[k][0]=chooseItem;
             // Check if there are same model/brand exists !
             Statement stateIMDUP=con.createStatement();
             String sqlIMDUP = "select * from IMEI_TRACKING where IMEI='"+chooseItem+"' ";
             //out.println(sqlIMDUP);     
             ResultSet rsIMDUP=stateIMDUP.executeQuery(sqlIMDUP);             
             if (rsIMDUP.next() || dupFLAG=="TRUE" || dupFLAG.equals("TRUE")) { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input : "+chooseItem+" on your list"+"</font>"); }
             else
             {
              b[k][0]=chooseItem;					 
			  b[k][1]=unitNo;b[k][2]=custName;b[k][3]=contactTel;b[k][4]=contactFax;b[k][5]=custAddress;b[k][6]=contact;
			  array2DimensionInputBean.setArray2DString(b);
              dupFLAG = "FALSE";     	
             } 	
             rsIMDUP.close();
             stateIMDUP.close();     	 						 			 	   			              
		   } else {// if (a!=null)	//out.println("step5");	     			  
			 //String c[][]={{chooseItem,month1,month2,month3,month4,month5,month6}};
              
             Statement stateIMDUP=con.createStatement();
             String sqlIMDUP = "select * from IMEI_TRACKING where IMEI='"+chooseItem+"' ";
             //out.println(sqlIMDUP);     
             ResultSet rsIMDUP=stateIMDUP.executeQuery(sqlIMDUP);             
             if (rsIMDUP.next() || dupFLAG=="TRUE" || dupFLAG.equals("TRUE")) { out.println("<font color='#FF0000' face='Arial Black'>"+"Duplicate last Input : "+chooseItem+" on your list"+"</font>"); }
             else
             {     
              String c[][]={{chooseItem,unitNo,custName,contactTel,contactFax,custAddress,contact}};						             			 
		      array2DimensionInputBean.setArray2DString(c);
             }
             rsIMDUP.close();
             stateIMDUP.close();    						 	                
		   }                   	                       		        		  
		 } else { //out.println("step6");
		   if (a!=null) 
		   { //out.println(array2DimensionInputBean.getArray2DString());
             //out.println("step7");
		     array2DimensionInputBean.setArray2DString(a);     			       	                
		   } 
          //out.println(array2DimensionInputBean.getArray2DString());     
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
      </strong></div></td>           
    </tr>
</table>
<input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
  -----DETAIL you choosed to be saved------------------------------------------<BR>
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
<INPUT name="button2" TYPE="button" onClick='setSubmit3("../jsp/WSIMEITrackingInput.jsp")'  value="DELETE" >
---------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/WSIMEITrackingInputInsert.jsp",<%=div1%>,<%=div2%>)' >
-----
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" > 
    <input name="TYPE" type="HIDDEN" value="<%=type%>" > 
	<input name="REGION" type="HIDDEN" value="<%=region%>" >
	<input name="COUNTRY" type="HIDDEN" value="<%=country%>" > 
	<input name="CURR" type="HIDDEN" value="<%=curr%>" >	
    <input type="hidden" name="CDATETIME" value=<%=strDateTime%> size="32" maxlength="14" >  
	<input type="hidden" name="USERID" value=<%=UserName%> size="32" maxlength="20" >
	<input type="hidden" name="REPCENTERNO" value=<%=repCenterNo%> size="3" maxlength="3" >
	<input type="hidden" name="LOCALE" value=<%=locale%> size="3" maxlength="3" >
	<input type="hidden" name="SENDIMEIFREQ" value=<%=sendImeiFreq%> size="5" maxlength="5" >
	<input type="hidden" name="AGENTNO" value=<%=agentNo%> size="7" maxlength="7" >
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
