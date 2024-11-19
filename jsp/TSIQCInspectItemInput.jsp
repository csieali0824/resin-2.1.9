<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All IQC Item Information</title>
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
.style1 {
	color: #666600;
	font-weight: bold;
}
.style3 {color: #4E5309; font-weight: bold; }
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function searchItemCode(classID) 
{   
  location.href="../jsp/TSIQCInspectItemInput.jsp?CLASSID="+classID+"&ITEMCODE="+document.MYFORM.ITEMCODE.value;
}
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmitSave(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%     
  //String statusID=request.getParameter("STATUSID");  
  //String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  
  //String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  //String queryDateFrom="",queryDateTo=""; 
  
  String classID=request.getParameter("CLASSID"); 
      if (classID==null) classID="";
  String itemID=request.getParameter("ITEMID"); 
      if (itemID==null) itemID="";
  String itemCode=request.getParameter("ITEMCODE");
      if (itemCode==null) itemCode="";	  
  String itemName = null;
  String itemDesc = null;
  String itemRemark = null;
  String createDate = null;
  String createdBy = null;
  String updateDate = null;
  String updatedBy = null;
  String maintMode=request.getParameter("MODE");	  
  if (maintMode==null)  maintMode = "INSERT";
  
  int maxrow=0;//查詢資料總筆數 
  
  try
  {   
   if (classID!= null  && !classID.equals("--") && itemCode!=null && !itemCode.equals("")) // 若已選類別碼及輸入項目代碼作查詢,則查詢已存在的內容並顯示
   {
     String sqlItemCode = "select * from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and ( ITEM_CODE like '%"+itemCode+"%' or ITEM_CODE = '"+itemCode+"') ";
     Statement stateItemCode=con.createStatement();
     ResultSet rsItemCode=stateItemCode.executeQuery(sqlItemCode);
     if (rsItemCode.next())
     {
	  classID = rsItemCode.getString("CLASS_ID");
      itemID = rsItemCode.getString("ITEM_ID");
      itemCode = rsItemCode.getString("ITEM_CODE");
	  itemName = rsItemCode.getString("ITEM_NAME");
	  itemDesc = rsItemCode.getString("ITEM_DESC");
	  itemRemark = rsItemCode.getString("ITM_REMARK");
	  createDate = rsItemCode.getString("CREATION_DATE");
	  createdBy = rsItemCode.getString("CREATED_BY");
	  updateDate = rsItemCode.getString("LAST_UPDATE_DATE");
	  updatedBy = rsItemCode.getString("LAST_UPDATED_BY");
	  maintMode = "UPDATE"; // 如有使用者存檔,則為Update模式
     } // rsItemCode.next()
	 else {
	        %>
	        <script language="JavaScript" type="text/JavaScript"> 
			    window.status = "查無此檢驗項目,可輸入各檢驗內容存檔後新增...";
			    //window.defaultStatus("無此檢驗項目...");
			</script>
		   <%
		   maintMode = "INSERT"; // 否則為新增模式
	      }
    } // End of if (classID != null && itemID)
	else {
	        %>
	        <script language="JavaScript" type="text/JavaScript"> 
			    window.status = "請選擇檢驗類別代碼,執行檢驗內容查詢或新增..."
				//window.defaultStatus = "請選擇檢驗類別代碼...";
			</script>
		   <%
	     }
		 
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  } 
  
/*  
  try
  {   
   Statement statement=con.createStatement();
   
  
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有檢驗類別存在之資料集
   ResultSet  rs=null;
   
     if (itemCode!=null && !itemCode.equals("")) //如果有搜尋檢驗類別則另下SQL
	 {	   
	    lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and ( ITEM_NAME='"+itemCode+"' )");	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {		   
	       rs=statement.executeQuery("select count(*) from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and (ITEM_NAME='"+itemCode+"' or ITEM_DESC ='"+itemCode+"') ");	
	    } else {
                    rs=statement.executeQuery("select count(*) from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and (ITEM_NAME='"+itemCode+"' or ITEM_DESC ='"+itemCode+"') ");	 	 
                  } //end of lotRs if		  
     } else {
	             rs=statement.executeQuery("select count(*) from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' ");
	           }	 
   
   rs.next();   
   maxrow=rs.getInt(1);
    
   statement.close();
   rs.close();   
   if (lotRs!=null) lotRs.close();
   lotStat.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  } 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-100;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/100+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/101+1;  
  } else {
    currentPageNumber=rowNumber/100+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
  
 */ 
  
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" METHOD="POST" action="TSIQCInspectItemInsert.jsp"> 
<strong><font color="#0080C0" size="5">IQC品管檢驗項目新增</font></strong><BR>
&nbsp;<A HREF="/oradds/jsp/TSIQCInspectItemQuery.jsp">檢驗項目資料查詢</A>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr bgcolor="#C7D273">     
	  <td width="17%"><font color="#767B35"><strong>檢驗類別代碼: </strong></font></td>
	<td width="83%"><font color="#FF0066"><strong>
	 <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique CLASS_ID as x ,CLASS_CODE||'('||CLASS_NAME||')' from ORADDMAN.TSCIQC_CLASS ";		  
		  sWhereC= "where CLASS_ID IS NOT NULL  order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  //out.println(sSqlC);		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
		  /*
          comboBoxBean.setRs(rsC);
		  if (classCode!=null && !classCode.equals("--")) comboBoxBean.setSelection(classCode);		  		  		  
	      comboBoxBean.setFieldName("CLASS_CODE");	   
          out.println(comboBoxBean.getRsString());
		  */
		  out.println("<select NAME='CLASSID' onChange='setSubmit("+'"'+"../jsp/TSIQCInspectItemInput.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
             while (rsC.next())
             {            
              String s1=(String)rsC.getString(1); 
              String s2=(String)rsC.getString(2); 
                        
              if (s1.equals(classID)) 
              {
                out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
              }   
			  else 
			  {
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
              }        
            } //end of while
          out.println("</select>"); 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </strong></font>
		<%
		   if (itemID==null || itemID.equals(""))
		   {
		     // 取下一號ITEM ID識別碼_起
             String sSql = "select lpad(max(ITEM_ID)+1,2,'0') as ITEM_ID from ORADDMAN.TSCIQC_ITEM ";		  
	         String sWhere = "where CLASS_ID ='"+classID+"' ";		 
	         sSql = sSql+sWhere;		 		      
             Statement statement=con.createStatement();
             ResultSet rs=statement.executeQuery(sSql);
             if (rs.next() ) 
             { 
              itemID = rs.getString("ITEM_ID"); 
              //out.println("<strong class='style3'>"+"Next ItemID value="+itemID+"</strong>"+"<BR>");
             }
             rs.close();
             statement.close();
		   } 
	   
	// 取下一號ITEM ID識別碼_迄  
		%>	
		<INPUT type="text" name="ITEMID" size=15 <%if (itemID==null || itemID.equals("")) out.println("value="); else out.println("value="+itemID);%>>	 
    </td>
	</tr>
<tr bgcolor="#C7D273">
   <td><strong class="style3">檢驗項目代碼:</strong></td>
   <td>
     <INPUT type="text" name="ITEMCODE" size=15 <%if (itemCode==null || itemCode.equals("")) out.println("value="); else out.println("value="+itemCode);%>><input name="search" type=button onClick="searchItemCode('<%=classID%>')" value='<-查詢'> 
   </td>
</tr>	
<tr bgcolor="#C7D273">	
 <td width="17%"><strong class="style3">檢驗項目名稱:</strong> </td>
 <td>
      <INPUT type="text" name="ITEMNAME" size=25 maxlength="15" <%if (itemName==null || itemName.equals("")) out.println("value="); else out.println("value="+itemName);%> >
    </td>
</tr>
<tr bgcolor="#C7D273">	
 <td width="17%"><strong class="style3">檢驗項目說明:</strong> </td>
 <td>
      <INPUT type="text" name="ITEMDESC" size=40 maxlength="30" <%if (itemDesc==null || itemDesc.equals("")) out.println("value="); else out.println("value="+itemDesc);%> >
    </td>
</tr>
<tr bgcolor="#C7D273">	
 <td width="17%"><strong class="style3">備註:</strong> </td>
 <td>
      <INPUT type="text" name="ITEMREMARK" size=50 maxlength="50" <%if (itemRemark==null || itemRemark.equals("")) out.println("value="); else out.println("value="+itemRemark);%> >
    </td>
</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF">
 <tr bgcolor="#C7D273">
  <td><span class="style3">建檔日期</span></td><td><INPUT type="text" name="CREATEDATE" size=15 <%if (createDate!=null) out.print("value="+createDate); else out.print("value="+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());%> maxlength="14" readonly></td>
  <td><span class="style3">建檔人員</span></td><td><input type="text" name="CREATEDBY" size=15 <%if (createdBy!=null) out.print("value="+createdBy); else out.print("value="+UserName);%> maxlength="20" readonly></td>
  <td><span class="style3">前次處理日期</span></td><td><INPUT type="text" name="UPDATEDATE" size=15 <%if (updateDate!=null) out.print("value="+updateDate); else out.print("value="+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());%> maxlength="14" readonly></td>
  <td><span class="style3">前次處理檔人員</span></td><td><input type="text" name="UPDATEDBY" size=15 <%if (updatedBy!=null) out.print("value="+updatedBy); else out.print("value="+UserName);%> maxlength="20" readonly></td>
 </tr>
 <tr><td colspan="8"><INPUT type="submit" name="Save" value="存檔"></td></tr>
</table>
<% 
 /*  
  try
  {   
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
    
       if (itemCode!=null && !itemCode.equals("")) //如果有搜尋特定單號則另下SQL
	   {
	      lotRs=lotStat.executeQuery("select count(*) from ORADDMAN.TSCIQC_ITEM where CLASS_ID IS NOT NULL and ( ITEM_NAME='"+itemCode+"' ) ");	 // 如果存在檢驗類別代碼
 		  lotRs.next();
	      if (lotRs.getInt(1)>0) //如果存在業務員工號
	      {
		    rs=statement.executeQuery("select ITEM_ID,ITEM_CODE as 檢驗項目代碼,ITEM_NAME as 檢驗項目名稱,ITEM_DESC as 檢驗項目描述,ITM_REMARK as 檢驗項目備註,CREATION_DATE as 建檔日期,CREATED_BY as 建檔人員,LAST_UPDATE_DATE as 更新日期,LAST_UPDATED_BY as 更新人員 from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and ( ITEM_NAME='"+itemCode+"' ) order by ITEM_ID"); 
		  } else {		   
            rs=statement.executeQuery("select ITEM_ID,ITEM_CODE as 檢驗項目代碼,ITEM_NAME as 檢驗項目名稱,ITEM_DESC as 檢驗項目描述,ITM_REMARK as 檢驗項目備註,CREATION_DATE as 建檔日期,CREATED_BY as 建檔人員,LAST_UPDATE_DATE as 更新日期,LAST_UPDATED_BY as 更新人員 from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' and ( ITEM_NAME='"+itemCode+"' or ITEM_DESC='"+itemCode+"') order by ITEM_ID");	 	 
          }			
       } else {	 
	               rs=statement.executeQuery("select ITEM_ID,ITEM_CODE as 檢驗項目代碼,ITEM_NAME as 檢驗項目名稱,ITEM_DESC as 檢驗項目描述,ITM_REMARK as 檢驗項目備註,CREATION_DATE as 建檔日期,CREATED_BY as 建檔人員,LAST_UPDATE_DATE as 更新日期,LAST_UPDATED_BY as 更新人員 from ORADDMAN.TSCIQC_ITEM where CLASS_ID = '"+classID+"' order by ITEM_ID");
	             }	  		        
	
   if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);
   qryAllChkBoxEditBean.setSearchKey("ITEM_ID");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");   
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(100);
       
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();
   rs.close();
   if (lotRs!=null) lotRs.close();
   lotStat.close();
   //取得維修處理狀態      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 */
%>
<input type="text" name="MODE" value="<%=maintMode%>">
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

