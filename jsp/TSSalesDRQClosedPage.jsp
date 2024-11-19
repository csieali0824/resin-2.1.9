<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="array2DCloseRFQUpdBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DCloseRFQNewBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>
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
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function setSubmit1(URL)
{ //alert();      
  var linkURL = "#ACTION";
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();  
}
function setSubmit2(URL)
{    
 document.DISPLAYREPAIR.action=URL;
 document.DISPLAYREPAIR.submit();
}
function setSubmit4(URL,dnDocNo)
{  var InsertPage="?DNDOCNO="+dnDocNo+"&LSTATUSID=001&INSERT=Y"; 
   warray=new Array(document.DISPLAYREPAIR.INVITEM.value,document.DISPLAYREPAIR.ITEMDESC.value,document.DISPLAYREPAIR.ORDERQTY.value,document.DISPLAYREPAIR.REQUESTDATE.value);   
   for (i=0;i<4;i++)
   {  
    if (i<=1)  
     {
	   if ((warray[0]=="" || warray[0]==null || warray[0]=="--") && (warray[1]=="" || warray[1]==null || warray[1]=="--"))
	   { 
	    alert("TSC Item or Item Description must input,please do not let them's data be Null !!");
		document.DISPLAYREPAIR.ITEMDESC.focus();
	    return(false); 
	   }
	 }	 
	 else if (i==2)
     {	 
	   if (warray[i]=="" || warray[i]==null)
	   {  
        alert("Please Input Order Quantity!!");   
	    document.DISPLAYREPAIR.ORDERQTY.focus();  
	    return(false);	 
	   }	    
     } // End of else if (warray[i]=="")
	 else if (i==3)
     {	
	   if (warray[i]=="" || warray[i]==null)
	   {   
        alert("Please Input Request Date!!");   
	    document.DISPLAYREPAIR.REQUESTDATE.focus();  
	    return(false);	    
	   } 
     } // End of else if (warray[i]=="")
	 
   } //end of for  null check
     
   for (i=2;i<3;i++)
   {     
     txt=warray[i];
	 for (j=0;j<txt.length;j++)      
     { 
	  c=txt.charAt(j);	   
     } 
	  if ("0123456789.".indexOf(c,0)<0) 
	 {
	  alert("The Quantity data that you inputed should be numerical!!");    
	  return(false);
	 }
   } //end of for  null check

 document.DISPLAYREPAIR.action=URL+InsertPage;
 document.DISPLAYREPAIR.submit();
}
function setSubmit5(URL,invitem)
{ 
  var markDelete="&MARKDELETE="+document.DISPLAYREPAIR.MARKDELETE.value; 
  var linkURL = "#"+LINKREF;
  document.DISPLAYREPAIR.action=URL+markDelete+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit6(URL,dnDocNo,delFlag)
{  
 var InsertPage="?DNDOCNO="+dnDocNo+"&INSERT=Y"+"&DELMODE="+delFlag;   

 document.DISPLAYREPAIR.action=URL+InsertPage;
 document.DISPLAYREPAIR.submit();
}
function subWindowItemFind(invItem,itemDesc)
{    
  subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function setItemFindCheck(invItem,itemDesc)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 
   }
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
 if((year%4==0&&year%100!=0)||(year%400==0)) 
 { 
 return true; 
 }  
 return false; 
} 
function setSPQCheck(xORDERQTY,xSPQP)
{
   if (event.keyCode==13 || event.keyCode==9 )
   { 
      if (xSPQP!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
      {
         if (xSPQP==0) //若系統取得0, 表示尚未設定該料號最小包裝量, 不得詢問
	     {
	        alert("The Item SPQP not be defaule, Please contact with Item Administroatr!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
            document.DISPLAYREPAIR.REQUESTDATE.focus();  
	        //return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
         } else
	     {
            base=xSPQP;
            n=xORDERQTY/base;
	        if ((""+n).indexOf(".")>-1) 
	        { 
	           alert("The Order Q'ty which you input not acceptence by SPQP rule !!!\n                          SPQP= "+base+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
               document.DISPLAYREPAIR.ORDERQTY.focus();  
	           return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
	         }
	      } // end if
	      document.DISPLAYREPAIR.REQUESTDATE.focus();  
      } //end null if
   } //end keydown if	  
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<%
   String dnDocNo=request.getParameter("DNDOCNO");
   String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   String factoryDate=request.getParameter("FACTORYDATE"); 
   String actionID = request.getParameter("ACTIONID"); 
   String line_No = request.getParameter("LINE_NO");   
   //response.sendRedirect("../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo); 
   
 // 2006/12/23 已結案RFQ單據再 Append MO Line  
   String [] check=request.getParameterValues("CHKFLAG");
   String quantity=request.getParameter("QUANTITY");
   String setRequestDate = request.getParameter("SETREQUESTDATE");
   String markDelete = request.getParameter("MARKDELETE"); 
   String isModelSelected=request.getParameter("ISMODELSELECTED");  
   String insertPage=request.getParameter("INSERT"); 
   int commitmentMonth=0;
   array2DCloseRFQNewBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
   String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料 
   
   String [] addItems=request.getParameterValues("ADDITEMS");
   String delMode = request.getParameter("DELMODE");
   
   String remark=request.getParameter("REMARK");
  
   String custINo=request.getParameter("CUSTINO"),iNo=request.getParameter("INO"),invItem=request.getParameter("INVITEM"),itemDescription=request.getParameter("ITEMDESC"),orderQty=request.getParameter("ORDERQTY"),uom=request.getParameter("UOM"),requestDate=request.getParameter("REQUESTDATE"),lnRemark=request.getParameter("LNREMARK"),sPQP=request.getParameter("SPQP"),custPONo=request.getParameter("CUSTPONO");
   String [] allMonth={iNo,invItem,itemDescription,orderQty,uom,requestDate,lnRemark,custPONo};
   String entry=request.getParameter("ENTRY");         
   if (entry==null || entry.equals("") )  {  }
   else { array2DCloseRFQNewBean.setArray2DString(null); } 
   
   if (custINo==null || custINo.equals("")) custINo = "1";
   if (iNo==null || iNo.equals("")) iNo = "1"; 
   if (lineNo==null) { lineNo=""; }
   
   if (markDelete==null) {markDelete = "N";}
   if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
   
   if (delMode==null) delMode="N";
   
   if (remark==null) { remark=""; }
   
   
  if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
  {    
	array2DCloseRFQNewBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  }
  
 try 
 {   
 
   String at[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容     
  //*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
   if (at!=null) 
   {
      for (int ac=0;ac<at.length;ac++)
	  {    	        
          for (int subac=1;subac<at[ac].length;subac++)
	      {   //out.println(request.getParameter("MONTH"+ac+"-"+subac));
		      at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
		   }  //end for array second layer count
	  } //end for array first layer count
   	 array2DCloseRFQNewBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************
   
   // 把 at.length() 值給 custINo作為目前預設的項次編號 kerwin 2006/02/17
   //if (custINo==null || custINo.equals("")) custINo="1";
   //else custINo = at.length();
 
  if (addItems!=null && delMode.equals("Y")) //若有選取且為刪除鍵則表示要刪除
  { 
  
    String a[][]=array2DCloseRFQNewBean.getArray2DContent();//重新取得陣列內容
	
	//out.println("a.length=DAMM IT"); 
	if (a==null)
	{ 
	  if (addItems.length>0)
	  {   //需判斷 addItems的內容,作為刪除的依據 (addItems即是 line_no)		     
		   for (int x=0;x<addItems.length;x++)
		   { 
		     String sqlDelTemp="delete from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO) = '"+addItems[x]+"' and LSTATUSID = '001' ";		                                 
	         PreparedStatement stmtDelTemp=con.prepareStatement(sqlDelTemp);
			 stmtDelTemp.executeUpdate();   
             stmtDelTemp.close();
		   }
		   if (a==null)	
		   {
		      out.println("a object Array is NULL !!!");
		   }
	  }  // End of if (addItems) 
	}       
    else if (a!=null && addItems.length>0)      
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
		  for (int gg=0;gg<7;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
		  {                          // 目前共7個{ iNo,invItem,itemDescription,orderQty,uom,requestDate,lnRemark }      
    		 // t[cc][gg]=a[m][gg];  //原先直接將暫存內容置入,
			 if (gg==0)
			 {
			   t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算
			 }
			 else {
			        t[cc][gg]=a[m][gg];         
			      }
	       } // End of for
		   cc++;			     
		}   //end of if a.inArray.equals("N")	
	   }   // End of for  
	   array2DCloseRFQNewBean.setArray2DString(t);	  
	 } else { 	//else (a.length > addItems.length )  			 
	           /*
			   out.println("Delete from ORADDMAN.TSDELIVERY_NOTICE_DETAIL"); 
			   if (a.length==addItems.length) // 就表示使用者全選( 因為原Array的Entites數 = User選擇的 Entites數 )
			   { 
			     array2DCloseRFQNewBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空
				 
				 String sqlDelTemp="delete from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' ";
		                                 
	             PreparedStatement stmtDelTemp=con.prepareStatement(sqlDelTemp);
				 stmtDelTemp.executeUpdate();   
                 stmtDelTemp.close();	
			   } // End of if (a.length==addItems.length)
			   */
	        }  
	}//end of if ( a!=null && addItems.length>0)
	
	   
  } 
   
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }    
   
   
 // 2006/12/23 已結案RFQ單據再 Append MO Line  
   
 if (factoryDate==null) { factoryDate="";}
   
  int rs1__numRows = 200;
  int rs1__index = 0;
  int rs_numRows = 0;

  rs_numRows += rs1__numRows; 
  String sSql = "";
  String sSqlCNT = "";
  String sWhere = "";
  String sWhereGP = "";
  String sOrder = "";


  int CASECOUNT=0;
  float CASECOUNTPCT=0;
  String sCSCountPCT="";
  int idxCSCount=0;

  float CASECOUNTORG=0;

  //String RepLocale=(String)session.getAttribute("LOCALE"); 		
  String SWHERECOND = "";
  int CaseCount = 0;
  int CaseCountORG =0;
  float CaseCountPCT = 0;

  String colorStr = "";

  String dateStringBegin=request.getParameter("DATEBEGIN");
  String dateStringEnd=request.getParameter("DATEEND");

  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");
  String dateSetBegin=YearFr+MonthFr+DayFr;  

  String YearTo=request.getParameter("YEARTO");
  String MonthTo=request.getParameter("MONTHTO");
  String DayTo=request.getParameter("DAYTO");
  String dateSetEnd=YearTo+MonthTo+DayTo; 

  String organizationId=request.getParameter("ORGPARID");
  String orderType=request.getParameter("ORDERTYPE");
  String sqlGlobal = "";


   
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>")' ACTION="../jsp/TSSalesDRQOrderProcessBook.jsp" METHOD="post">
  <!--=============以下區段為取得維修基本資料==========-->
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<HR>

<table border="1" cellpadding="0" cellspacing="0" align="center" width="97%" bordercolor="#996633"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
    <tr bgcolor="#D5D8A7"> 
    <td colspan="3">
      <jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/>
      :&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600" size="2"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/><BR>
      <%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	array2DCloseRFQUpdBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
		
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"'  ");	// 訂單已CLOSED 狀態但尚未生成MO單的項目
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();	 
		 
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][7]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DCloseRFQNewBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE border='1' cellpadding='0' cellspacing='0' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	   out.println("<tr>");	   
	   out.println("<td nowrap><font color='#FFFFFF'>&nbsp;");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	   <%
	   out.println("</td>");
	   out.println("<td width='1%'><font color='#FFFFFF'>&nbsp;</td>");
	   out.println("<td><div align='center'><img src='../image/point.gif'>Assign Factory</div>");
	   try
        { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select MANUFACTORY_NO, MANUFACTORY_NAME as PRODMANUFACTORY "+
			                        "from ORADDMAN.TSPROD_MANUFACTORY "+
			                        "where MANUFACTORY_NO > 0 "+																  
								     "order by MANUFACTORY_NO "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxBean.setRs(rsGetP);
		           comboBoxBean.setSelection(prodManufactory);
	               comboBoxBean.setFieldName("PRODMANUFACTORY");					     
                   out.println(comboBoxBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	   } //end of try		 
       catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	   out.println("</td>");
	   out.println("<td width='1%' nowrap>");
	   %><jsp:getProperty name="rPH" property="pgAnItem"/>
	   <%
	   out.println("</td><td>");
	   %>
	   <jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   <%
	   out.println("</td><td>");
	   %><jsp:getProperty name="rPH" property="pgQty"/>
	   <%
	   out.println("</td><td>");
	   %>
	   <jsp:getProperty name="rPH" property="pgUOM"/>
	   <%
	   out.println("</td><td>");
	   %><jsp:getProperty name="rPH" property="pgRequestDate"/>
	   <%
	   out.println("</td><td>");
	   %><jsp:getProperty name="rPH" property="pgRemark"/>
	   <%
	   out.println("</td>"); 
	   //out.println("<td width='2%'>Line No</td><td>Item Description</td><td>Qty.</td><td>UOM</td><td>Request Date</td><td>Remark</td>");    
	   int k=0;
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO");	   
	   //out.println("select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO");
	   while (rs.next())
	   {   
	    out.print("<TR>");	
		                      								  
	    out.println("<TD width='1%'><div align='center'>"); 
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{ 
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生管交期確認即設定欲結轉
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生管交期確認即設定欲結轉  
		if (rowLength==1) out.println("checked >"); else out.println(" >");
		out.println("</div></TD>");
					
		out.println("<TD width='1%'>");
		out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit3("+'"'+"../jsp/TSSalesDRQAssigningPage.jsp?LINENO="+rs.getString("LINE_NO")+"&DNDOCNO="+dnDocNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");	
		out.println("</div></TD>");
		
		out.println("<TD width='5%' nowrap>");   
		out.println("&nbsp;");   
		out.println("");
		out.println("</TD>");
		
		out.println("<TD><a name="+rs.getString("LINE_NO")+">");
		out.println(rs.getString("LINE_NO")+"</a></TD><TD>"+rs.getString("ITEM_DESCRIPTION")+"</TD><TD>"+rs.getString("QUANTITY")+"</TD><TD>"+rs.getString("UOM")+"</TD><TD>"+rs.getString("REQUEST_DATE").substring(0,8)+"</TD><TD>"+rs.getString("REMARK")+"</TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("ASSIGN_MANUFACT");		 
		 array2DCloseRFQUpdBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DCloseRFQNewBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && prodManufactory!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ASSIGN_MANUFACT=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,prodManufactory);  // 詢問單號
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String d[][]=array2DCloseRFQUpdBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (d!=null) 
		 {		  
		        //out.println("ROW="+a.length+" ");
				//out.println("COLUMN="+a[0].length+"<BR>");
						
				//out.println(a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");	
				//out.println(a[1][0]+ " " +a[1][1]+" " +a[1][2]+" " +a[1][3]+" " +a[1][4]+" " +a[1][5]+" " +a[1][6]+"<BR>");
				//out.println(a[2][0]+ " " +a[2][1]+" " +a[2][2]+" " +a[2][3]+" " +a[2][4]+" " +a[2][5]+" " +a[2][6]+"<BR>");
				//out.println(a[3][0]+ " " +a[3][1]+" " +a[3][2]+" " +a[3][3]+" " +a[3][4]+" " +a[3][5]+" " +a[3][6]+"<BR>");
				//out.println(a[4][0]+ " " +a[4][1]+" " +a[4][2]+" " +a[4][3]+" " +a[4][4]+" " +a[4][5]+" " +a[4][6]+"<BR>");
				//out.println(a[5][0]+ " " +a[5][1]+" " +a[5][2]+" " +a[5][3]+" " +a[5][4]+" " +a[5][5]+" " +a[5][6]+"<BR>");
				
	        	//array2DCloseRFQNewBean.setFieldName("ADDITEMS");			
				//out.println(array2DCloseRFQNewBean.getArray2DString()); // 把內容印出來  		
				//out.println(array2DCloseRFQNewBean.getCheckContent()); 				
		 }	//enf of a!=null if		
		
    %>       
  </tr>    
  <tr bgcolor="#D5D8A7"> 
      <td colspan="3"><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 >           
     </td>
    </tr>
    <tr bgcolor="#D5D8A7">
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><%=userID+"("+UserName+")"%></td>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessDate"/>:</font><%=dateBean.getYearMonthDay()%></td>    
      <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessTime"/>:</font> 
	   <%=dateBean.getHourMinuteSecond()%>
      </td>
    </tr>       
</table>
 
<table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr bgcolor="#99CCFF">      
      <td width="27%"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><img src="../image/point.gif"></font></div></td>
	  <td width="22%"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><img src="../image/point.gif"></font></div></td>
	  <td width="17%" colspan="1"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgQty"/><img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000"><jsp:getProperty name="rPH" property="pgKPC"/></font></div></td> 
      <td width="13%" colspan="1"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgDeliveryDate"/><img src="../image/point.gif"></font></div></td>
	  <td width="17%" colspan="1"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgRemark"/></font></div></td> 
	  <td width="17%" colspan="1"><div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustPONo"/></font></div></td>	 	  	  
      <!--%<td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/TSSalesDRQ_Create.jsp")'></div></td> %-->
	  <td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button" tabindex="11"  value="Add" onClick='setSubmit4("../jsp/TSSalesDRQTemporaryPage.jsp","<%=dnDocNo%>")'></div></td>	  
    </tr>	
  <tr bgcolor="#99CCFF">
    <td>    
    <input type="text" name="INVITEM" tabindex="1"  size="20" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' maxlength="30" <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%>>
	<INPUT TYPE="button" tabindex="2" value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'>
    </td>
	<td>    
	<input name="INO" tabindex="3" type="hidden" size="2" <%if (iNo==null) out.println("value=1"); else out.println("value="+iNo);%>> 
    <input type="text" name="ITEMDESC" tabindex="4" size="20" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' maxlength="60" <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%>>
	<INPUT TYPE="button" tabindex="5" value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'>
    </td>
    <td nowrap><div align="center">	
	<input type="text" name="ORDERQTY" tabindex="6" size="10" onKeyDown='setSPQCheck(this.form.ORDERQTY.value,this.form.SPQP.value)' maxlength="60"  <%if (allMonth[3]!=null) out.println("value="); else out.println("value=");%> >
	 <%
	    out.println("<font color='#FF0000' size='2'>");
	    out.println("MOQ: ");
		%>
      <input type="text" name="SPQP" tabindex="7" size="3" align="right" readonly class="gogo" <%if (sPQP!=null) out.println("value="); else out.println("value=");%>>      
      <%
	    out.println(" K");
	    out.println("");
	  %>
	</div>
    </td>
	<td width="13%" bgColor="#ffffff">
	   <input name="UOM" tabindex="8" type="hidden" size="8" <%if (allMonth[4]!=null) out.println("value="); else out.println("value=");%>>
	   <input name="REQUESTDATE" tabindex="9" type="text" size="8" <%if (allMonth[5]!=null) out.println("value="); else out.println("value=");%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>   	   
    </td>
	<td><div align="center">
	     <input type="text" name="LNREMARK" tabindex="10"  size="10" maxlength="60"  <%if (allMonth[6]!=null) out.println("value="); else out.println("value=");%>>			 	 
		 </div>
    </td>   
	<td><div align="center">
	     <input type="text" name="CUSTPONO" tabindex="10"  size="10" maxlength="60"  <%if (allMonth[7]!=null) out.println("value="); else out.println("value=");%>>			 	 
		 </div>
    </td> 
    </tr>
	<tr>
	  <td colspan="7"><div align="center"><strong>
      <%
	   try
       {
	    //String oneDArray[]= {"","<jsp:getProperty name='rPH' property='pgInvItem'/>","<jsp:getProperty name='rPH' property='pgQty'/>","<jsp:getProperty name='rPH' property='pgDeliveryDate'/>","<jsp:getProperty name='rPH' property='pgRemark'/>"}; 
        String oneDArray[]= {"","Line No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark","Customer PO No."}; 		 	     			  
    	array2DCloseRFQNewBean.setArrayString(oneDArray);
	     String a[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";
	     if (( (invItem!=null && !invItem.equals("")) || (itemDescription!=null && !itemDescription.equals("")) ) && orderQty!=null && !orderQty.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {  out.println("step1"); 
		 
		   String sqlUOM = ""; 
		   if (invItem!=null && !invItem.equals("")) // 若輸入料號,抓說明及單位
		   { 
		    sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and SEGMENT1 = '"+invItem+"' ";  
		   }       
		   else { // 否則若輸入料號說明,抓料號及單位
		          sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+itemDescription+"' ";     
		        } 					
		      // 依使用者輸入的料號ID取其單位
			  Statement stateUOM=con.createStatement();			  
              ResultSet rsUOM=stateUOM.executeQuery(sqlUOM); 
              //===(
              if (rsUOM.next())
              {
			   uom =  rsUOM.getString("PRIMARY_UOM_CODE");   
			   invItem = rsUOM.getString("SEGMENT1"); 
			   itemDescription = rsUOM.getString("DESCRIPTION"); 
			  } else 
			       { %>
				       <script LANGUAGE="JavaScript">                        
					   subWindowItemFind("<%=invItem%>","<%=itemDescription%>");                        
                       </script> 
                     <%
					 // 若找不到,則呼叫料號尋找視窗,並將料號及料號說明給沒填入的欄位
					 if (itemDescription==null || itemDescription.equals("")) itemDescription = invItem;
					 else if (invItem==null || invItem.equals("")) invItem = itemDescription;
					 uom = "KPC";
				   }
			  rsUOM.close();
			  stateUOM.close();
		     // 依使用者輸入的料號ID取其單位 			    
		   if (a!=null) 
		   { out.println("step2");
		    
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { out.println("step3");
			  for (j=0;j<a[i].length;j++)
			  { out.println("step4");
			    b[i][j]=a[i][j];
                //if (a[k][0].equals(orderQty)) { dupFLAG = "TRUE"; }					 			
			  } // End of for (j=0)
			  k++;
			 }// End of for (i=0) 
			  
			  
			  iNo = Integer.toString(k);  // 把料項序號給第一個位置
			  //out.println(iNo);
			  //out.println("b[k][0]="+iNo);
			  //out.println("b[k][1]="+invItem);out.println("b[k][2]="+itemDescription);out.println("b[k][3]="+orderQty);out.println("b[k][4]="+uom);out.println("b[k][5]="+requestDate);out.println("b[k][6]="+lnRemark);
			  b[k-1][0]=iNo;
			  b[k-1][1]=invItem;b[k-1][2]=itemDescription;b[k-1][3]=orderQty;b[k-1][4]=uom;b[k-1][5]=requestDate;b[k-1][6]=lnRemark;b[k-1][7]=custPONo;
			  array2DCloseRFQNewBean.setArray2DString(b);
		      array2DCloseRFQNewBean.setArray2DCheck(b);
			  
			  //out.println(array2DCloseRFQNewBean.getArray2DTempString());
			 			 			 			 						 			 	   			              
		   } else {	out.println("step5: 若為第一筆資料,則填入抬頭");	            
			 String c[][]={{iNo,invItem,itemDescription,orderQty,uom,requestDate,lnRemark,custPONo}};						             			 
		     array2DCloseRFQNewBean.setArray2DString(c);  
					 	                
		   }                   	                       		        		  
		 } else { //out.println("step6:未輸入欄位內容作 Add ,表示點擊刪除鍵");
		   if (a!=null) 
		   { //out.println("step7:若陣列內原已有存入內容,則把內容在置入");
		     array2DCloseRFQNewBean.setArray2DString(a);     			       	                
		   } 
		 }
		 //end if of chooseItem is null
		 
		 custINo = Integer.toString(Integer.parseInt(custINo) + 1);
		 //out.println("custINo="+custINo);
		 if (custINo==iNo)
		 {		 
		   //custINo = iNo;
		 } else {
		          custINo = iNo;
		        }
		 //out.println("custINo="+custINo);
		 //out.println("iNo="+iNo);
		 
		 
		 //###################針對目前陣列內容進行檢查機制#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  String tp[]=array2DCloseRFQNewBean.getArrayContent();
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
		     array2DCloseRFQNewBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  } else {    		      		     
		      array2DCloseRFQNewBean.setArray2DCheck(null);
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
	      String a[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
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
	      String a[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
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
<table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
<tr bgcolor="#99CCFF">
  <td>
     <input name="button" tabindex='12' type=button onClick="this.value=check(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
     <font color="#336699" size="2">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
  </td>
</tr>
<tr bgcolor="#99CCFF">
  <td> 
  <font color="#000066"><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></font>
      : <font color="#666666"><jsp:getProperty name="rPH" property="pgQDocNo"/>:</font><font color="#006699"><%=dnDocNo%></font>
	  <BR> 
  <% 
      int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容 
		//out.println("Stp0.11");		    		                       		    		  	   
         if (a!=null) 
		 {		 
		        div1=a.length;
				div2=a[0].length;				
	        	array2DCloseRFQNewBean.setFieldName("ADDITEMS");					
				//out.println(array2DCloseRFQNewBean.getArray2DString());
				out.println(array2DCloseRFQNewBean.getArray2DClosedString());  // 用Item 及Item Description 作為Key 的Method				
				//out.println(array2DCloseRFQNewBean.getArray2D2KeyString());  // 用Item 及Item Description 作為Key 的Method				

				isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y" 		
				
				//out.println("Stp0.14");			
			    //out.println(array2DCloseRFQNewBean.getArray2DContent()); 		 				
		 }	//enf of a!=null if		
		 else if (a==null)    // 2006/02/20 判斷若陣列內為空值,則取於資料庫內的 Temporary內容置入鎮列
		      {
			       array2DCloseRFQNewBean.setFieldName("ADDITEMS");
			       int k=0;
				   String oneDArray[]= {"","Line No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark","Customer PO No."}; 		 	     			  
    	           array2DCloseRFQNewBean.setArrayString(oneDArray);				  
	               // 先取 該詢問單筆數
	               int rowLength = 0;
	               Statement stateCNT=con.createStatement();
                   ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' ");	
	               if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	               rsCNT.close();
	               stateCNT.close();
	        
	               //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	               String r[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
				   
	               String sqlEst = "";
	               if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	               { 
				     sqlEst = "  select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE,EDIT_CODE,CUST_PO_NUMBER "+ 
				              "    from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
							  "   where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' "+
							  "     and ORDERNO = 'N/A' "+ // 只帶出那些尚未生成MO單的項次
				              "   order by LINE_NO"; 
				   }
	               else {   
	                     sqlEst = " select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE,EDIT_CODE,CUST_PO_NUMBER "+
						          " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
								  " where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' "+
								   "  and ORDERNO = 'N/A' "+ // 只帶出那些尚未生成MO單的項次
								  " order by LINE_NO"; 
			            }
	   
                   Statement statement=con.createStatement();
                   ResultSet rs=statement.executeQuery(sqlEst);	   
	               while (rs.next())
	               {//out.println("0"); 				       
				       iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
			           //out.println(iNo);
					   //r[k][0]= "";
			           r[k][0]=rs.getString("LINE_NO");
			           r[k][1]=rs.getString("ITEM_SEGMENT1");r[k][2]=rs.getString("ITEM_DESCRIPTION");r[k][3]=Float.toString(rs.getFloat("QUANTITY"));r[k][4]=rs.getString("UOM");r[k][5]=rs.getString("REQUEST_DATE").substring(0,8);r[k][6]=rs.getString("REMARK");r[k][7]=rs.getString("CUST_PO_NUMBER");
			           array2DCloseRFQNewBean.setArray2DString(r); 					   
					   k++;
				   }
				   rs.close();
				   statement.close();
				   
				   String q[][]=array2DCloseRFQNewBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
                   if (q!=null) 
		           {//out.println("<BR>");		  
				    //out.println(q[0][0]+ " " +q[0][1]+" " +q[0][2]+" " +q[0][3]+" " +q[0][4]+" " +q[0][5]+" " +q[0][7]+"<BR>");	
				    //out.println(q[1][0]+ " " +q[1][1]+" " +q[1][2]+" " +q[1][3]+" " +q[1][4]+" " +q[1][5]+" " +q[1][7]+"<BR>");
				    //out.println(q[2][0]+ " " +q[2][1]+" " +q[2][2]+" " +q[2][3]+" " +q[2][4]+" " +q[2][5]+" " +q[2][7]+"<BR>");	
					//out.println(q[3][0]+ " " +q[3][1]+" " +q[3][2]+" " +q[3][3]+" " +q[3][4]+" " +q[3][5]+" " +q[3][7]+"<BR>");				   
					out.println(array2DCloseRFQNewBean.getArray2DClosedString());
				   }
				   
			  } // end of if (a==null)
			  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </td>
    </tr>
	  <tr bgcolor="#99CCFF">
	    <td>
		  <INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmit6("../jsp/TSSalesDRQTemporaryPage.jsp","<%=dnDocNo%>","<%="Y"%>")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
          <% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699' size='2'>-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------"); 
		  %>
   </td>
  </tr>
</table>

<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</strong> 
   <a name='#ACTION'>
    <%
	  try
      {  
	        
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQTemporaryPage.jsp?LSTATUSID=001&INSERT=Y&DNDOCNO="+dnDocNo+'"'+")'>");				  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
          out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
               }        
	   } //end of while
	   out.println("</select>"); 
	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   {
         //out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='submitCheck("+'"'+"../jsp/TSSalesDRQMProcess.jsp?DNDOCNO="+dnDocNo+'"'+","+'"'+"");
		          %><jsp:getProperty name="rPH" property="pgAlertCancel"/><%out.print(""+'"'+","+'"'+""); 				 
				  %><jsp:getProperty name="rPH" property="pgAlertSubmit"/><%out.print(""+'"'+","+'"'+"");
				  %><jsp:getProperty name="rPH" property="pgAlertAssign"/><%out.print(""+'"'+","+'"'+"");				  
				  %><jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/><%out.print(""+'"'+")'>");
		 
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
	   } 
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></a></td></tr></table>
<!-- 表單參數 --> 
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%

//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>

