<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e){
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
   warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ORDERQTY.value,document.MYFORM.LINETYPE.value);   
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
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle AddsOn System Order Multip-Line Import Create Test Page</title>
</head>
<body>
<FORM ACTION="WSMRProdAprnceInput.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>  Order Create API </strong></font>&nbsp; &nbsp; &nbsp; 
  &nbsp;<BR>
  &nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../WinsMainMenu.jsp">首頁</A> &nbsp;&nbsp;<A HREF="../jsp/TestOrderMultiLineImportCreate.jsp"> 新增訂單測試 </A> 
<%   

int commitmentMonth=0;
array2DimensionInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");

String [] addItems=request.getParameterValues("ADDITEMS");

String invItem=request.getParameter("INVITEM"),orderQty=request.getParameter("ORDERQTY"),lineType=request.getParameter("LINETYPE");

String [] allMonth={invItem,orderQty,lineType};
String entry=request.getParameter("ENTRY");          
  
if (entry==null || entry.equals("") )  {  }
else { array2DimensionInputBean.setArray2DString(null); } 

  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");
  //String requestDate=YearFr+MonthFr+DayFr;  
  String requestDate=request.getParameter("REQUESTDATE");;

   String organizationId =request.getParameter("ORGPARID");
   String orderType=request.getParameter("ORDERTYPE");
   String soldToOrg=request.getParameter("SOLDTOORG");
   String priceList=request.getParameter("PRICELIST");
   String shipToOrg=request.getParameter("SHIPTOORG");       
   if (shipToOrg==null) {  shipToOrg = ""; }
   
   String customer=request.getParameter("CUSTOMER");
   if (customer==null) {  customer = ""; }
   
   String partyID=request.getParameter("PARTYID");
   if (partyID==null) {  partyID = ""; }
   
   if (requestDate==null) requestDate = dateBean.getYearMonthDay();
      
  // java.sql.Date shipdate = new java.sql.Date(2005-1900,10,7);	
  // String schShipDate = shipdate.toString();
 //  out.println("schShipDate="+schShipDate);
   
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
   
  } //enf of bringLast if   
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<table cellSpacing="0" borderColorDark="#FF9933"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
     <tbody>
	     <tr><td colspan="6"><font color="#FF3300">Sales Order Header</font></td></tr>
		 <tr><td bgcolor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Organization</font></td>
		 <td>
		   <%
			       try
                   {   
		             Statement statement=con.createStatement();
                     ResultSet rs=null;	
			         String sql = "select DISTINCT c.organization_id_parent, c.organization_id_parent || '('||d.name|| ')' "+
			                            "from mtl_parameters a, hr_organization_units b, per_org_structure_elements c, hr_organization_units d "+
			                            "where a.organization_id = b.organization_id and a.organization_id = c.organization_id_child "+		
										"and c.organization_id_parent = d.organization_id "+						  
								        "order by 1 ";  			  
                     rs=statement.executeQuery(sql);
		             comboBoxBean.setRs(rs);
		             comboBoxBean.setSelection(organizationId);
	                 comboBoxBean.setFieldName("ORGPARID");	   
                     out.println(comboBoxBean.getRsString());				    
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }                     
			   %>
	       </td>
			 <td width="20%" bgcolor="#FFCC99"><font size="2" face="Arial"><span class="style1">&nbsp;</span>Order Type</font></td>
           <td width="23%" bgColor="#ffffff"><font face="Arial"><!--%<input maxLength="40" size="15" name="ORDERTYPE">%-->
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
		           comboBoxBean.setSelection(orderType);
	               comboBoxBean.setFieldName("ORDERTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   /*
		           out.println("<select NAME='ORDERTYPE' onChange='setSubmit("+'"'+"../jsp/TestOrderImportCreate.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rs.next())
		           {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                        
		             if (s1.equals(organizationId)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					  organizationCode = s2;                                  
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 	
					*/  		  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
		   </font></td>
		   <td width="14%" bgcolor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Request Date</font></td>		   
		   <td width="16%" bgColor="#ffffff">
		       <input name="REQUESTDATE" type="text" size="8" value="<%=requestDate%>"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>	 
		   </td>
		 </tr>
	     <tr>		   
           <td width="8%" bgColor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Sold to Org</font></td>
           <td width="19%" bgColor="#ffffff"><font face="Arial">
		      <%
			     try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;				      									  
				   String sqlSold = "select CUSTOMER_ID, CUSTOMER_ID||'('||SALES_CHANNEL_CODE||')' as TRANSACTION_TYPE_CODE, CUSTOMER_NUMBER||'('||CUSTOMER_NAME||')', PARTY_ID "+
			                        "from RA_CUSTOMERS "+
			                        "where status = 'A' "+
									//"and PRICE_LIST_ID IS NOT NULL  "+								  
								     "order by CUSTOMER_ID "; 					   
			  
                   rs=statement.executeQuery(sqlSold);
		           out.println("<select NAME='SOLDTOORG' onChange='setSubmit3("+'"'+"../jsp/TestOrderMultiLineImportCreate.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rs.next())
		           {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                     
		             if (s1.equals(soldToOrg)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					  soldToOrg = s2; 					  
					  customer = rs.getString(3);   
					  partyID = rs.getString(4);                               
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 
				    statement.close();		  		  
		            rs.close();        	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }       
			  %><BR></font></td>
           <td width="20%" bgColor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Price List</font></td>
           <td width="23%" bgColor="#ffffff"><font face="Arial">
		      <%		     			 
				 try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;		      
									  
				   String sql = "select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE "+
			                    "from qp_list_headers_tl "+
			                    "where LANGUAGE = 'US' and TO_CHAR(LIST_HEADER_ID) > '0' "; 					   
			  
                   rs=statement.executeQuery(sql);
		           out.println("<select NAME='PRICELIST' onChange='setSubmit3("+'"'+"../jsp/TestOrderMultiLineImportCreate.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rs.next())
		           {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                     
		             if (s1==priceList || s1.equals(priceList)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
					  //priceListCode = s1; 					                                 
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 
				    statement.close();		  		  
		            rs.close();        	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
			  %>		  
		   </font></td>
		   <td width="14%" bgColor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Ship To Org</font></td>
           <td width="16%" bgColor="#ffffff"><font face="Arial">	
		    <%
			     //String shipToCode = "";
			     try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = "select a.SITE_USE_ID, a.SITE_USE_ID||'('||b.COUNTRY||')' "+
			                    "from RA_SITE_USES_ALL a, RA_ADDRESSES_ALL b "+
			                    //"where a.ADDRESS_ID = b.ADDRESS_ID and b.PARTY_ID = '"+partyID+"' "+ // 2005/11/18 開放自行選擇 Ship Tp Org
								"where a.ADDRESS_ID = b.ADDRESS_ID and b.PARTY_ID > 0 "+
								"and a.STATUS='A' and a.SITE_USE_CODE = 'SHIP_TO' and a.PRIMARY_FLAG = 'Y' "+
								"and to_char(a.PRICE_LIST_ID)='"+priceList+"' "+								
								"and a.SITE_USE_ID IS NOT NULL "+
								"order by a.SITE_USE_ID ";
				   //out.println(sql);
                   rs=statement.executeQuery(sql);
		           //if (rs.next())
				   //{ shipToOrg = rs.getString(1); }
				   comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(shipToOrg);
	               comboBoxBean.setFieldName("SHIPTOORG");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
			  %>	      		  
		   <input type="hidden" size="25" name="SHIPTOORG" value="<%=shipToOrg%>" readonly>		  
		   </font></td>  
	     </tr>			
		 <tr>
		    <td width="8%" bgColor="#FFCC99"><font face="Arial" size="2"><span class="style1">&nbsp;</span>Customer</font></td> 
			<td colspan="5"><input size="80" name="CUSTOMER" value="<%=customer%>"></td>   
         </tr> 
    </tbody>
   </table>
<table cellSpacing="0" borderColorDark="#FF9933"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
  <tr>      
      <td width="18%" bgcolor="#FFCC99"><div align="center"><font face="Arial" size="3">Inventory Item</font></div></td>
	  <td width="18%" colspan="1" bgcolor="#FFCC99"><div align="center"><font face="Arial" size="3">Order Q'ty</font></div></td> 
      <td width="48%" colspan="1" bgcolor="#FFCC99"><div align="center"><font face="Arial" size="3">Line Type</font></div></td> 	  	  
      <td width="16%" rowspan="2" ><div align="center"><INPUT TYPE="button"  value="Line Add" onClick='setSubmit("../jsp/TestOrderMultiLineImportCreate.jsp")'></div></td> 
    </tr>
  <tr>
    <td>    
    <input type="text" name="INVITEM"  size="30" maxlength="30" <%if (allMonth[0]!=null) out.println("value="); else out.println("value=");%>>
    </td>
    <td><div align="right"><input type="text" name="ORDERQTY"  size="15" maxlength="15"   <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%> ></div>
    </td>
    <td><input type="text" name="LINETYPE"  size="25" maxlength="25"   <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%> >
    </td>    
    </tr>    
  <tr bgcolor="#FFCC99">
    <td colspan="4"><div align="center"><strong>
     <%
	  try
      {
	    //String oneDArray[]= {"","MODEL",ymh1,ymh2,ymh3,ymh4,ymh5,ymh6}; 
        String oneDArray[]= {"","Inventory Item","Order Qty","Line Type"}; 		 	     			  
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
			 /*
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
			*/ 
			  b[k][0]=invItem;b[k][1]=orderQty;b[k][2]=lineType;
			  array2DimensionInputBean.setArray2DString(b);
			 			 						 			 	   			              
		   } else {	//out.println("step5");	
            /*
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
		   */
			 String c[][]={{invItem,orderQty,lineType}};						             			 
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
<table cellSpacing="0" borderColorDark="#FF9933"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
<tr>
  <td>
     <input name="button" type=button onClick="this.value=check(this.form.ADDITEMS)" value="Select All">
     -----DETAIL you choosed to be saved-------------------------------------------------------------------------------------------------------------------- 
  </td>
</tr>
<tr>
  <td>  
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
	   </td>
	  </tr>
	 </table>
<BR>
<INPUT name="button2" TYPE="button" onClick='setSubmit3("../jsp/TestOrderMultiLineImportCreate.jsp")'  value="DELETE" >
------------------------------------------------------------------------------------------------------------
<INPUT TYPE="button"  value="SAVE" onClick='setSubmit2("../jsp/TestOrderMultiLineImportCreateSubmit.jsp",<%=div1%>,<%=div2%>)' >
---------------------
<!-- 表單參數 -->  
    <input name="COMP" type="HIDDEN" value="<%=comp%>" >
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>