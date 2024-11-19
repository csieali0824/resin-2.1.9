<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean,ComboBoxBean"%>
<html>
<head>
<title>AddLotIssueSubWindow</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
<jsp:useBean id="arrayLotIssueCheckBean" scope="session" class="ArrayCheckBoxBean"/>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
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
 return "Select All";  }
}
function NeedConfirm(URL,accLotQty,field)
{ 
  var chkDelFlag="false";
  //alert(eval(field.length));
  for (i = 0; i < field.length; i++)
  { 
    //alert(field[i].checked);
    if (field[i].checked) chkDelFlag="true"; // 選擇特定
  }
  
  if (eval(field.length)==null || eval(field.length)=="") chkDelFlag="true"; // 選擇特定
  
  //alert(accLotQty);
 
  if (chkDelFlag=="true") // 選擇任一項目刪除
  {
    flag=confirm("Are you sure you want to delete?"); 
    if (flag)
    {
     var linkURL="&ACCLOTQTY="+accLotQty;
     document.SUBLOTFORM.ACCLOTQTY.value = accLotQty;  // 把減掉後的累計數給Form變數
     document.SUBLOTFORM.action=URL+linkURL;
     document.SUBLOTFORM.submit();   
    } else {
             return false;
           }
  } else if (chkDelFlag=="false") 
          { //  沒選擇任一項目刪除,則警告
            alert("請選擇項目作刪除!!!");   
          }
}
function closeThisWindow(a,accLotQty) 
{   
 //alert(accLotQty);
 window.opener.document.DISPLAYREPAIR.CHKBELOT.value="Y"; // 確認工單領料前段批號無誤
 window.opener.document.DISPLAYREPAIR.ACCLOTQTY.value=accLotQty;
 this.window.close();
}
function setWoQtyCheck(URL,woQty,accLotQty)
{       
    var accLotQty = eval(accLotQty) + eval(document.SUBLOTFORM.QTY.value);
	var linkURL="&ACCLOTQTY="+accLotQty;
	
	if (document.SUBLOTFORM.QTY.value=="0")
	{
	  alert("請確實輸入實際領用數量!!!");
	  document.SUBLOTFORM.QTY.focus();
	  return false;
	}
	
    if (eval(accLotQty) > eval(woQty))
	{
	  alert("累計批號數量已大於工令數量!!!");
	  document.SUBLOTFORM.button2.focus();
	  return false;
	}
	
    document.SUBLOTFORM.action=URL+linkURL;
    document.SUBLOTFORM.submit();
}
</script>
<body> 
<!--以下是在處理刪除或上傳-->
<%
String [] addFeatures=request.getParameterValues("ADDFEATURES");
String chooseFeature=request.getParameter("CHOOSEFEATURE"); 
//out.println("chooseFeature"+chooseFeature);
String wipEntityId=request.getParameter("WIPENTITYID");
String beEndItemID=request.getParameter("BENDITEM");
String woQty=request.getParameter("WOQTY");
String accLotQty=request.getParameter("ACCLOTQTY");
String qty=request.getParameter("QTY");
out.println("woQty="+woQty+"<BR>");
out.println("accLotQty="+accLotQty+"<BR>"+"beEndItemID="+beEndItemID);

String buttonContent=null; 

try 
{    
  if (addFeatures!=null) //若有選取則表示要刪除
  {
   String a[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前陣列內容   
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
		 cc++;			     
		}  
	   } //end of for a.length	   
	   arrayLotIssueCheckBean.setArray2DString(t);
	 } else { 	   			 
	   arrayLotIssueCheckBean.setArray2DString(null); //將陣列內容清空
	 }  
	}//end of if a!=null
  } 
}
catch (Exception e)
{
   out.println("Exception:"+e.getMessage());
}  

%> 
<FORM name="SUBLOTFORM" METHOD="post" ACTION="TSMfgWipIssueLotFind.jsp">
<A HREF="TSMfgWipIssueLotFind2.jsp?WIPENTITYID=<%=wipEntityId%>&BENDITEM=<%=beEndItemID%>&ACCLOTQTY=<%=accLotQty%>&WOQTY=<%=woQty%>">輸入方式選擇前段半成品批號</A><BR>
  <font size="-1">半成品批號(前段完工流程卡)</font><font size="-1">: 
  <%
	  try
      {       
	   String a[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前陣列內容
	   String aString="'"+chooseFeature+"'";
	   if (a!=null) 
	   {
	     for (int l=0;l<a.length;l++)
	     { 
		   float remainQty = 0;
		   Statement stateRem=con.createStatement();
		   ResultSet rsRem=stateRem.executeQuery("select abs(sum(PRIMARY_QUANTITY)) from MTL_TRANSACTION_LOT_NUMBERS where LOT_NUMBER='"+a[l][0]+"' ");
		   if (rsRem.next())
		   {
		     remainQty = rsRem.getFloat(1);
		   }
		   rsRem.close();
		   stateRem.close();
		   
		   if (remainQty<=0)
		   { //剩餘數小於等於零的不入清單內
	              aString=aString+",'"+a[l][0]+"'";
		   }
	     }
	   }	
	   
       Statement statement=con.createStatement();
	   /*
       String sql=" select b.LOT_NUMBER, b.LOT_NUMBER ||'(數量:'|| abs(b.TRANSACTION_QUANTITY)||',領料日期:'||to_char(b.TRANSACTION_DATE,'YYYY/MM/DD HH24:MI:SS')||')'  "+
	              "  from MTL_MATERIAL_TRANSACTIONS a, MTL_TRANSACTION_LOT_NUMBERS b "+ 
				  " where a.TRANSACTION_ID = b.TRANSACTION_ID  and a.TRANSACTION_SOURCE_ID = b.TRANSACTION_SOURCE_ID "+ 
				  "   and a.TRANSACTION_TYPE_ID = 35 "+
				  "   and b.LOT_NUMBER not in ("+aString+") and a.TRANSACTION_SOURCE_ID = "+wipEntityId+" "+
				  " order by b.TRANSACTION_DATE ";
	   */
	   String sql=" select b.RUNCARD_NO, b.RUNCARD_NO ||'(數量:'|| c.REMAIN_QTY ||',完工日期:'||to_char(to_date(b.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS')||')'  "+
	              "  from YEW_WORKORDER_ALL a, YEW_RUNCARD_ALL b, "+ 
				  "       (select abs(sum(PRIMARY_QUANTITY)) as REMAIN_QTY, LOT_NUMBER from MTL_TRANSACTION_LOT_NUMBERS group by LOT_NUMBER) c "+
				  " where a.WO_NO = b.WO_NO and b.STATUSID >= '048' "+        // 已完工前段批號,才能被挑入清單內
				  "   and b.RUNCARD_NO = c.LOT_NUMBER "+
				  "   and a.WORKORDER_TYPE = '2' and b.CLOSED_DATE IS NOT NULL "+ // 屬於前段的工令
				  "   and b.RUNCARD_NO not in ("+aString+") and b.COMPLETION_QTY > 0 "+ // 完工數大於0 , 且已挑選的不在清單內
				  "   and b.PRIMARY_ITEM_ID in ( select /* + ORDERED index(c BOM_COMPONENTS_B_N2)  */ COMPONENT_ITEM_ID "+   // 相同後段工令BOM表下的
				                                "  from BOM_COMPONENTS_B c, BOM_STRUCTURES_B d "+
				                                " where c.BILL_SEQUENCE_ID = d.BILL_SEQUENCE_ID "+
				                                "   and d.ASSEMBLY_ITEM_ID  = "+beEndItemID+" "+         // 前段半成品料號
										       // "   and d.ORGANIZATION_ID = b.ORGANIZATION_ID "+
												" ) "+
				  "   and b.RUNCARD_NO not in (select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_TYPE ='3') "+								
				  " order by b.CLOSED_DATE ";
       //out.println(sql);             
       ResultSet rs=statement.executeQuery(sql);
       comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("CHOOSEFEATURE");	   
       out.println(comboBoxBean.getRsString());	   
	   
	   statement.close();
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
<BR><strong>
<font color="#FF0000">實際領用數量: 
<input type="text" name="QTY" SIZE=3 VALUE=0>
</font></strong> </font>
  <INPUT TYPE="button" NAME="submit1" value='加入' onClick='setWoQtyCheck("TSMfgWipIssueLotFind.jsp?WIPENTITYID=<%=wipEntityId%>&BENDITEM=<%=beEndItemID%>&WOQTY=<%=woQty%>","<%=woQty%>","<%=accLotQty%>")'>
  <BR>
  </font> <BR>
  <input name="button" type=button onClick="this.value=check(this.form.ADDFEATURES)" value='選擇全部'>
  -------工令已領用半成品批號-------
  ----------------     
  <BR>
     <%	 
	    String oneDArray[]= {"","領用批號","數量","領用日期","ERP領用"}; 		 	     			  
    	arrayLotIssueCheckBean.setArrayString(oneDArray);	 
		
		float newAccLotQty = 0;
	 	   
	  try
      { 
	     String a[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前陣列內容	 	     		 	   			    
		 String featureName="";
		 int i=0,j=0,k=0;
	     if (chooseFeature!=null && !chooseFeature.equals("--"))
		 {
		   /*Statement statement=con.createStatement();
           ResultSet rs=statement.executeQuery("select QTY from RPMRITEM where trim(ITEMNO)='"+chooseFeature+"'");	       
		   rs.next();
		   featureName=rs.getString("QTY");*/
		   
		   if (a!=null) 
		   { 
		     newAccLotQty = 0; // 重新算過
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { 
			  for (j=0;j<a[i].length;j++)
			  {
			    b[i][j]=a[i][j];				
			  }	
			  k++;	
			  newAccLotQty = newAccLotQty + Float.parseFloat(b[i][1]); 			  
			 }
			 b[k][0]=chooseFeature;
			 b[k][1]=qty;  // 第k 筆被加進來的批號
			 b[k][2]="N";  // 由人工選擇實際批號領用
			
			 newAccLotQty = newAccLotQty + Float.parseFloat(qty);
			 accLotQty = Float.toString(Float.parseFloat(accLotQty)+Float.parseFloat(qty));
			 
			 if (b[k][0]!=null && !b[k][0].equals(""))
			 {
			  Statement statement=con.createStatement();
			  //out.println("陣列多筆"+"select to_char(to_date(CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), COMPLETION_QTY from YEW_RUNCARD_ALL where RUNCARD_NO='"+b[k][0]+"' ");
              ResultSet rs=statement.executeQuery("select to_char(to_date(CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), COMPLETION_QTY from YEW_RUNCARD_ALL where RUNCARD_NO='"+b[k][0]+"' ");	       
		      rs.next();
		      b[k][2]=rs.getString(1);
			  //b[k][1]=rs.getString(2);
			  b[k][1]=qty;
			  b[k][3]="N";  //不是由ERP領料作業加入的 
			  rs.close();
			  statement.close();
			  //out.println("陣列多筆  b[k][2]="+b[k][2]);
			  //out.println("陣列多筆  b[k][1]="+b[k][1]);
			 }
			 
			 arrayLotIssueCheckBean.setArray2DString(b); 
			 arrayLotIssueCheckBean.setFontSize(2);  
			 arrayLotIssueCheckBean.setFieldName("ADDFEATURES");			 			 	   			 
             out.println(arrayLotIssueCheckBean.getArrayWip2DString());             
		   } else {	  
		            //out.println("陣列NULL,newAccLotQty="+newAccLotQty);
		            String trxDate = dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString()+" "+dateBean.getHourString()+":"+dateBean.getMinuteString()+":"+dateBean.getSecondString();
					 //newAccLotQty = 0;
					 if (newAccLotQty==0) newAccLotQty = Float.parseFloat(accLotQty); 		
					 Statement statement=con.createStatement();	
					 ResultSet rs=statement.executeQuery("select COMPLETION_QTY from YEW_RUNCARD_ALL where RUNCARD_NO='"+chooseFeature+"' ");	       
		             if (rs.next())
					 { //out.println("newAccLotQty = "+newAccLotQty);
					   if (rs.getFloat(1)>Float.parseFloat(woQty))
					   {
					     qty = Float.toString(rs.getFloat(1)-Float.parseFloat(woQty));
					   } else {
					            qty=rs.getString(1); // 取使用者挑選的批號完工數量
							  }
					 }
					 rs.close();	
					 statement.close();	
		            String c[][]={{chooseFeature,qty,trxDate}};							
					 
		             arrayLotIssueCheckBean.setArray2DString(c);  
			         arrayLotIssueCheckBean.setFontSize(2);    
			         arrayLotIssueCheckBean.setFieldName("ADDFEATURES");
                     out.println(arrayLotIssueCheckBean.getArrayWip2DString() );			  
		          }    
		  //statement.close();                	                       		        		  
		  //rs.close(); 
		  //out.println("陣列多筆333");
		 } else
		  {
		    if (a!=null) 
		    { 
			  newAccLotQty = 0; // 重新計算累計批量
		      for (int m=0;m<a.length;m++)
			  { //out.println("選擇某欄且陣列不為NULL,newAccLotQty="+newAccLotQty);
			    if (a[m][1]!=null && !a[m][1].equals("null"))
				{
		         newAccLotQty = newAccLotQty + Float.parseFloat(a[m][1]);				
				 accLotQty = Float.toString(Float.parseFloat(accLotQty)+Float.parseFloat(a[m][1]));
				}
		      }
			  
			//out.println("陣列多筆444");  
		      arrayLotIssueCheckBean.setArray2DString(a);  
			  arrayLotIssueCheckBean.setFontSize(2);
        	  arrayLotIssueCheckBean.setFieldName("ADDFEATURES");	    	   
              out.println(arrayLotIssueCheckBean.getArrayWip2DString() );			 
		    } 
		  }
		  //end if of chooseFeature is null	 
		 String chk[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前陣列內容		 		  
		 if (chk!=null)
		 {   
    		 buttonContent="this.value=closeThisWindow("+"'YES'"+","+accLotQty+")";		 
		 } else { 
		     buttonContent="this.value=closeThisWindow("+"'NO'"+","+accLotQty+")";
		 }		 	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %> 
	   <BR>
  <INPUT TYPE="button" NAME="submit2" value='刪除' onClick='NeedConfirm("TSMfgWipIssueLotFind.jsp?WIPENTITYID=<%=wipEntityId%>&BENDITEM=<%=beEndItemID%>&WOQTY=<%=woQty%>","<%=newAccLotQty%>",this.form.ADDFEATURES)'> 
      <hr>	   
  <input name="button2" type=button onClick="<%=buttonContent%>" value='確認'>
  <input name="WIPENTITYID" type="HIDDEN" value="<%=wipEntityId%>">	
  <input name="BENDITEM" type="HIDDEN" value="<%=beEndItemID%>">
  <input name="WOQTY" type="HIDDEN" value="<%=woQty%>">
  <input name="ACCLOTQTY" type="HIDDEN" value="<%=accLotQty%>">
</FORM>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
