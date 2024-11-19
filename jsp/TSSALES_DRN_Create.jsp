<%@ page language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
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
function submitCheck(field)
{       
  //檢查是否選取的資料有填入相對應的DATA
  if (field.length==null)
  {
     if (field.checked==true)
	 {
	    if (document.MYFORM.elements["DUEDATE-"+field.value].value=="" || document.MYFORM.elements["DUEDATE-"+field.value].value==null || document.MYFORM.elements["QTY-"+field.value].value=="" || document.MYFORM.elements["QTY-"+field.value].value==null)
			{ 
			  alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  return(false);
			}  
			
			txt1=document.MYFORM.elements["QTY-"+field.value].value;	
			txt2=document.MYFORM.elements["DUEDATE-"+field.value].value;	
			for (j=0;j<txt1.length;j++)      
			{ 
			   c=txt1.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
			
			for (j=0;j<txt2.length;j++)      
			{ 
			   c=txt2.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
	 }
  } else {
	  for (i = 0; i < field.length; i++)  
	  {	   
		if (field[i].checked == true)
		{	   		  			
			if (document.MYFORM.elements["DUEDATE-"+field[i].value].value=="" || document.MYFORM.elements["DUEDATE-"+field[i].value].value==null || document.MYFORM.elements["QTY-"+field[i].value].value=="" || document.MYFORM.elements["QTY-"+field[i].value].value==null)
			{ 
			  alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  return(false);
			}  
			
			txt1=document.MYFORM.elements["QTY-"+field[i].value].value;	
			txt2=document.MYFORM.elements["DUEDATE-"+field[i].value].value;	
			for (j=0;j<txt1.length;j++)      
			{ 
			   c=txt1.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
			
			for (j=0;j<txt2.length;j++)      
			{ 
			   c=txt2.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}							
		} //end of if =>if (field[i].checked == true)
	  } //END OF 檢查是否選取的資料有填入相對應的DATA
  }	//end of if=>field.length==null  

  var pass = "NO"; 
  if (field.length==null)
  {
     if (field.checked==true) pass="YES";
  } else {
	  for (i = 0; i < field.length; i++) 
	  {    
		if (field[i].checked == true)
		{
		  pass="YES";
		  break;
		}
	  }
  }
  
  if (pass == "NO")
  {
    alert("You can not submit while you are not choosing any one!!");
    return false;
  }
  
  document.MYFORM.submit();   
}
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
   warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value,document.MYFORM.LNREMARK.value);   
   for (i=0;i<3;i++)
   {     
      if (warray[i]=="" || warray[i]==null || warray[i]=="--" )
     { 
      alert("Before you want to add , please do not let the any fields of Model data be Null !!");   
      return(false);
      } 
   } //end of for  null check
   
   for (i=0;i<3;i++)
   {     
      txt=warray[i];
	  for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);
	   
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
<%    
  String docNo=request.getParameter("DOCNO"); 
  String targetYear=""; 
  String targetMonth=""; 
   
  String customerId=request.getParameter("CUSTOMERID"); 
  String salesAreaNo=request.getParameter("SALESAREANO"); 
  String salesPersonID=request.getParameter("SALESPERSONID"); 
  String customerPO=request.getParameter("CUSTOMERPO"); 
  String receptDate=request.getParameter("RECEPTDATE");
  String curr=request.getParameter("CURR"); 
  String remark=request.getParameter("REMARK"); 
  String preOrderType=request.getParameter("PREORDERTYPE");
  String isModelSelected=request.getParameter("ISMODELSELECTED");  
  
  int commitmentMonth=0;
  array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
  String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
  String comp=request.getParameter("COMP");

  String [] addItems=request.getParameterValues("ADDITEMS");
  
  String invItem=request.getParameter("INVITEM"),orderQty=request.getParameter("ORDERQTY"),requestDate=request.getParameter("REQUESTDATE"),lnRemark=request.getParameter("LNREMARK");
  String [] allMonth={invItem,orderQty,requestDate,lnRemark};
  String entry=request.getParameter("ENTRY");         
  if (entry==null || entry.equals("") )  {  }
  else { array2DimensionInputBean.setArray2DString(null); } 
  
  if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
  if (curr==null || curr.equals("")) curr="";
  if (remark==null || remark.equals("")) remark="";
  if (customerPO==null || customerPO.equals("")) customerPO="";
  if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
  
  String seqno=null;
  String seqkey=null;
  String dateString=null;
  
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
		  for (int gg=0;gg<4;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
		  { 
    		 t[cc][gg]=a[m][gg];
	      }
		 cc++;			     
		}  
	   } //end of if a.length		     
	   array2DimensionInputBean.setArray2DString(t);	  
	 } else { 	//else (a!=null && addItems.length>0 )  			 
	          //array2DimensionInputBean.setArray2DString(null); //若陣列內容不為空,且addItems.length>0,則將陣列內容清空
			   if (a.length==addItems.length)
			   { 
			     array2DimensionInputBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空 
			   } // End of if (a.length==addItems.length)
	        }  
	}//end of if a!=null
  } 
 
  if ( bringLast!=null  && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
  {
   
  } //enf of bringLast if   
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
  
 // 若單號未取得,則呼叫取號程序
 try
 { 
  if (docNo==null || docNo.equals(""))
  {  
   dateString=dateBean.getYearMonthDay();
   seqkey="TS"+userActCenterNo+dateString;
   //====先取得流水號=====  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
  
   if (rs.next()==false)
   {   
    String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";   
    PreparedStatement seqstmt=con.prepareStatement(seqSql);     
    seqstmt.setString(1,seqkey);
    seqstmt.setInt(2,1);   
	
    seqstmt.executeUpdate();
    seqno=seqkey+"-001";
    seqstmt.close();   
   } 
   else 
   {
    int lastno=rs.getInt("LASTNO");
      
    String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
    ResultSet rs2=statement.executeQuery(sql); 
    //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
    if (rs2.next())
    {         
      lastno++;
      String numberString = Integer.toString(lastno);
      String lastSeqNumber="000"+numberString;
      lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
      seqno=seqkey+"-"+lastSeqNumber;     
   
      String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
      PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      seqstmt.setInt(1,lastno);   
	
      seqstmt.executeUpdate();   
      seqstmt.close(); 
    } 
    else
    {
      //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
      String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
      ResultSet rs3=statement.executeQuery(sSql);
	 
	  if (rs3.next()==true)
	  {
       int lastno_r=rs3.getInt("LASTNO");
	  
	   lastno_r++;
	  
	   String numberString_r = Integer.toString(lastno_r);
       String lastSeqNumber_r="000"+numberString_r;
       lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	   String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
       PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       seqstmt.setInt(1,lastno_r);   
	
       seqstmt.executeUpdate();   
       seqstmt.close();  
	  }  // End of if (rs3.next()==true)
   
     } // End of Else  //===========(處理跳號問題)
    } // End of Else    
	docNo = seqno; // 把取到的號碼給本次輸入
  } // End of if (docNo==null || docNo.equals(""))	
  else {
  
       }	 
 } //end of try
 catch (Exception e)
 {
  out.println("Exception:"+e.getMessage());
 } 
%>

<html>
<head>
<title>Material Request Comfirmation Form</title>
</head>
<body>
<FORM ACTION="TSSALES_DRN_Create.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font  color="#000099" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/></strong></font>
<BR>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHome"/></A>
<table cellSpacing="0" bordercolordark="#3366FF" cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
    <tr bgcolor="#6699FF">      
      <td width="19%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><strong><jsp:getProperty name="rPH" property="pgQDocNo"/></strong></font><font face="Arial" size="2" color="#FF0000"><span class="style1">&nbsp;</span><strong><%=docNo%></strong></font></td>      	 
	</tr>
 </table>
 <table cellSpacing="0" bordercolordark="#3366FF"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1"> 
    <tr>
	  <td width="12%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></td> 
      <td width="17%"> 
	    <%		 
	       try
           {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA WHERE SALES_AREA_NO='"+userActCenterNo+"' ";
				   //out.println(sql);
                   rs=statement.executeQuery(sql);
		           //if (rs.next())
				   //{ shipToOrg = rs.getString(1); }
				   comboBoxBean.setRs(rs);
				   if (salesAreaNo==null)
		           { comboBoxBean.setSelection(userActCenterNo); }
				   else { comboBoxBean.setSelection(salesAreaNo); }
	               comboBoxBean.setFieldName("SALESAREANO");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close(); 
		    } //end of try
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }		   
       %>
	 </td>
	 <td width="15%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRecDate"/></font></td>		   
		   <td width="15%" bgColor="#ffffff">
		       <input name="RECEPTDATE" type="text" size="8" value="<%=receptDate%>"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> 
		   </td>  
	 <td width="16%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSalesMan"/></font></td>
	 <td width="25%">
      <font size="2"><%out.println(userID+"("+UserName+")"); salesPersonID = userID; %></font>
	 </td>
    </tr>	
	<tr>
	    <td width="12%" height="22" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPreOrderType"/></font></td>
           <td width="17%" bgColor="#ffffff"><font face="Arial">
		      <%
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select TRANSACTION_TYPE_ID, TRANSACTION_TYPE_ID||'('||NAME||')' as TRANSACTION_TYPE_CODE "+
			                          "from oe_transaction_types_tl "+
			                          "where LANGUAGE = 'US'  "+								  
								      "order by 2 ";  
			  
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(preOrderType);
	               comboBoxBean.setFieldName("PREORDERTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
			 </font>
		 </td>
		 <td width="15%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustPONo"/></font></td> 
		 <td colspan="1"><input size="20" name="CUSTOMERPO" value="<%=customerPO%>"></td> 
		 <td width="16%" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCurr"/></font></td> 
		 <td colspan="1"><input size="20" name="CURR" value="<%=curr%>"></td> 
	</tr>   
	<tr>
	   <td width="12%" height="22" bgcolor="#6699FF"><font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustInfo"/></font></td>
       <td bgColor="#ffffff" colspan="3"><font face="Arial">
		      <%
			     try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;				      									  
				   String sqlCustomer = "select CUSTOMER_ID, CUSTOMER_NUMBER||'('||CUSTOMER_NAME||')' "+
			                        "from RA_CUSTOMERS "+
			                        "where status = 'A' "+																  
								    "order by CUSTOMER_ID "; 					   
			  
                   rs=statement.executeQuery(sqlCustomer);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(customerId);
	               comboBoxBean.setFieldName("CUSTOMERID");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }       
	        %></font>
		 </td>
		 <td colspan="2" bgcolor="#6699FF">
           <font face="Arial" size="2" color="#FFFFFF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRemark"/></font>
	       <input name="REMARK" type="text" size="40" value="<%=remark%>">	
		 </td>  
	 </tr>	 
 </table>
 <table cellSpacing="0" bordercolordark="#3366FF"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
  <tr>      
      <td width="22%" bgcolor="#6699FF"><div align="center"><font face="Arial" size="2" color="#FFFFFF"><img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgInvItem"/></font></div></td>
	  <td width="11%" colspan="1" bgcolor="#6699FF"><div align="center"><font face="Arial" size="2" color="#FFFFFF"><jsp:getProperty name="rPH" property="pgQty"/></font></div></td> 
      <td width="17%" colspan="1" bgcolor="#6699FF"><div align="center"><font face="Arial" size="2" color="#FFFFFF"><jsp:getProperty name="rPH" property="pgDeliveryDate"/></font></div></td>
	  <td width="43%" colspan="1" bgcolor="#6699FF"><div align="center"><font face="Arial" size="2" color="#FFFFFF"><jsp:getProperty name="rPH" property="pgRemark"/></font></div></td> 	 	  	  
      <td width="7%" rowspan="2" ><div align="center"><INPUT TYPE="button"  value="Line Add" onClick='setSubmit("../jsp/TSSALES_DRN_Create.jsp")'></div></td> 
    </tr>
  <tr>
    <td>    
    <input type="text" name="INVITEM"  size="30" maxlength="30" <%if (allMonth[0]!=null) out.println("value="); else out.println("value=");%>>
    </td>
    <td><div align="center"><input type="text" name="ORDERQTY"  size="15" maxlength="15"   <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%> ></div>
    </td>
	<td width="17%" bgColor="#ffffff">
	   <input name="REQUESTDATE" type="text" size="8" <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>	   
    </td>
	<td><div align="center"><input type="text" name="LNREMARK"  size="50" maxlength="15"   <%if (allMonth[3]!=null) out.println("value="); else out.println("value=");%> ></div>
    </td>    
    </tr>    
  <tr bgcolor="#6699FF">
    <td colspan="5"><div align="center"><strong>
     <%
	  try
      {
	    //String oneDArray[]= {"","<jsp:getProperty name='rPH' property='pgInvItem'/>","<jsp:getProperty name='rPH' property='pgQty'/>","<jsp:getProperty name='rPH' property='pgDeliveryDate'/>","<jsp:getProperty name='rPH' property='pgRemark'/>"}; 
        String oneDArray[]= {"","Inventory Item","Order Qty","Request Date","Remark"}; 		 	     			  
    	array2DimensionInputBean.setArrayString(oneDArray);
	     String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";
	     if (invItem!=null && !invItem.equals("") && orderQty!=null && !orderQty.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {  //out.println("step1");             		    
		   if (a!=null) 
		   { //out.println("step2");
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { //out.println("step3");
			  for (j=0;j<a[i].length;j++)
			  { //out.println("step4");
			    b[i][j]=a[i][j];	
                if (a[k][0].equals(orderQty)) { dupFLAG = "TRUE"; }				
			  }
			  k++;
			 }
			 
			  b[k][0]=invItem;b[k][1]=orderQty;b[k][2]=requestDate;b[k][3]=lnRemark;
			  array2DimensionInputBean.setArray2DString(b);
			 			 						 			 	   			              
		   } else {	//out.println("step5");	            
			 String c[][]={{invItem,orderQty,requestDate,lnRemark}};						             			 
		     array2DimensionInputBean.setArray2DString(c);  
					 	                
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
		 
	    } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
	 %></strong></div>
	</td>        
    </tr>
  </table>
  <HR>
  <table cellSpacing="0" bordercolordark="#3366FF"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
<tr>
  <td>
     <input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
     -----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------
  </td>
</tr>
<tr>
  <td bgcolor="#6699FF">  
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
				isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y"  	
		  		 				
		 }	//enf of a!=null if		
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
	   </td>
	  </tr>
	  <tr>
	    <td>
		  <INPUT name="button2" TYPE="button" onClick='setSubmit3("../jsp/TSSALES_DRN_Create.jsp")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
		  <% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------"); 
		  %>
		</td>
	  </tr>
 </table>
<HR>
<table cellSpacing="0" bordercolordark="#3366FF"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
<tr>
 <td width="17%" bgcolor="#6699FF">
  <strong><font color="#000099"><jsp:getProperty name="rPH" property="pgProcessUser"/></font></strong> 
 </td>
 <td width="15%"> 
    <font color="#000099"><strong><%=userID+"("+UserName+")"%></strong></font>	 
 </td>
 <td width="19%" bgcolor="#6699FF">
  <strong><font color="#000099"><jsp:getProperty name="rPH" property="pgProcessDate"/></font></strong> 
 </td>
 <td width="15%"> 
   <font color="#000099"><strong><%=dateBean.getYearMonthDay()%></strong></font>	 
 </td> 
 <td width="19%" bgcolor="#6699FF">
  <strong><font color="#000099"><jsp:getProperty name="rPH" property="pgProcessTime"/></font></strong> 
 </td>
 <td width="15%"> 
    <font color="#000099"><strong><%=dateBean.getHourMinuteSecond()%></strong></font>	 
 </td>  
</tr>
<tr>
 <td width="17%" bgcolor="#6699FF">
  <strong><font color="#000099"><jsp:getProperty name="rPH" property="pgAction"/></font></strong> 
 </td>
 <td colspan="2"> 
    <%
	  try
      {       
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS'AND TYPENO='001' AND FROMSTATUSID='001' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
       comboBoxBean.setRs(rs);
	   comboBoxBean.setFieldName("ACTIONID");	   
	   comboBoxBean.setSelection("002"); // 2005/04/18
	   
       out.println(comboBoxBean.getRsString());
	   
	    
	   
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
	   &nbsp;&nbsp;&nbsp;&nbsp;
   </td>
   <td colspan="3" bgcolor="#6699FF"><INPUT TYPE="button"  value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit2("../jsp/TSSALES_DRN_MInsert.jsp",<%=div1%>,<%=div2%>)' ></td>
 </tr>
</table>
<!-- 表單參數 -->  
    <input name="FORMID" type="HIDDEN" value="TS">	
    <input name="FROMSTATUSID" type="HIDDEN" value="001">
	<input name="ISMODELSELECTED" type="HIDDEN" value="<%=isModelSelected%>" size=2>  <!--做為判斷是否已選取新增機型明細-->
	<input name="FROMPAGE" type="HIDDEN" value="TSSALES_DRN_Create.jsp">  	
	<input name="SALESPERSONID" type="HIDDEN" value="<%=salesPersonID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
