<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All IQC Item Examine Information</title>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
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
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
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
 return "Select All"; }
}
function searchRepNo(pageURL) 
{   
  location.href="../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
}

function submitCheck(ms1,ms2)
{  
  if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  {       
   return(false);
  } 
  
   if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  } 

  if ( document.MYFORM.ACTIONID.value=="005" & (document.MYFORM.CHANGEREPPERSONID==null || document.MYFORM.CHANGEREPPERSONID.value=="--")  )
   { 
    alert(ms2);   
    return(false);
   }  
   return(true);      
}  
function setSubmit(URL)
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
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");    
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String classCode=request.getParameter("CLASS_CODE"); 
  String classID=request.getParameter("CLASS_ID"); 
  String itemID=request.getParameter("ITEM_ID");
  String examineItemID=request.getParameter("EXAMINE_ITEM_ID");  
  int maxrow=0;//查詢資料總筆數 
 try
  {   
   Statement statement=con.createStatement();
   /*
   ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from RPWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   String sql=null;
   rs.next();
   statusDesc=rs.getString("LOCALDESC");
   statusName=rs.getString("STATUSNAME");   
   
   rs.close();  
   */
  
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有檢驗類別存在之資料集
   ResultSet  rs=null;
   
      String sql = "select count(*) from ORADDMAN.TSCIQC_EXAMINE";
	  String sWhere = " where ( EXAMINE_ITEM_NAME='"+searchString+"' ) ";
	  if (classID!=null && !classID.equals("--")) sWhere =sWhere +" and CLASS_ID = '"+classID+"'  ";
	  if (itemID!=null && !itemID.equals("--")) sWhere = sWhere + "and ITEM_ID = '"+itemID+"' ";
   
     if (searchString!=null && !searchString.equals("")) //如果有搜尋檢驗類別則另下SQL
	 {
	   
		sql = sql + sWhere;
	    lotRs=lotStat.executeQuery(sql);	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {	
		   //if (searchString!=null && !searchString.equals("")) sWhere = sWhere + "and (EXAMINE_ITEM_NAME='"+searchString+"' or EXAMINE_ITEM_DESC ='"+searchString+"') ";	   
	       rs=statement.executeQuery(sql + " and (EXAMINE_ITEM_NAME='"+searchString+"' or EXAMINE_ITEM_DESC ='"+searchString+"') ");	
	    } else {
                    rs=statement.executeQuery(sql+" and (EXAMINE_ITEM_NAME='"+searchString+"' or EXAMINE_ITEM_DESC ='"+searchString+"') ");	 	 
                  } //end of lotRs if		  
     } else {
	             rs=statement.executeQuery(sql);
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
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" METHOD="POST"> 
<strong><font color="#0080C0" size="5">IQC品管檢驗測試項目查詢</font></strong>(總共<%=maxrow%>&nbsp;筆記錄)</FONT><BR>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr bgcolor="#B1D3A9">     
	  <td width="46%"><font color="#FF0066"><strong>檢驗類別代碼: 
        </strong></font><font> 
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
		  out.println("<select NAME='CLASS_ID' onChange='setSubmit("+'"'+"../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL="+pageURL+'"'+")'>");
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
        </font> 
      </td>
	<td width="54%"><font color="#FF0066"><strong>檢驗項目代碼: 
        </strong></font><font> 
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";	
		  String sOrderC = "order by x ";	  
		 	             		 
		  sSqlC = "select Unique ITEM_ID as x ,ITEM_CODE||'('||ITEM_NAME||')' from ORADDMAN.TSCIQC_ITEM ";		  
		  sWhereC= "where ITEM_ID is not null ";	
		  //sSqlC = sSqlC+sWhereC;	
		  if (classID !=null && !classID.equals("--")) sWhereC = sWhereC + "and CLASS_ID ='"+classID+"' ";
		  sSqlC = sSqlC + sWhereC + sOrderC;	  
		  //out.println(sSqlC);		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
		 /* 
          comboBoxBean.setRs(rsC);
		  if (itemID!=null && !itemID.equals("--")) comboBoxBean.setSelection(itemID);		  		  		  
	      comboBoxBean.setFieldName("ITEM_ID");	   
          out.println(comboBoxBean.getRsString());
		 */
		  out.println("<select NAME='ITEM_ID' onChange='setSubmit("+'"'+"../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL="+pageURL+"&CLASS_ID="+classID+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rsC.next())
             {            
              String s1=(String)rsC.getString(1); 
              String s2=(String)rsC.getString(2); 
                        
              if (s1.equals(itemID)) 
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
        </font> 
    </td>
	</tr>	
<tr bgcolor="#B1D3A9">	
 <td width="46%"><font color="#FF0066"><strong>檢驗測試項目代碼: 
        </strong></font><font> 
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";	
		  String sOrderC = "order by x ";	  
		 	             		 
		  sSqlC = "select Unique EXAMINE_ITEM_ID as x ,EXAMINE_ITEM_CODE||'('||EXAMINE_ITEM_NAME||')' from ORADDMAN.TSCIQC_EXAMINE ";		  
		  sWhereC= "where EXAMINE_ITEM_ID is not null ";	
		  //sSqlC = sSqlC+sWhereC;	
		  if (classID !=null && !classID.equals("--")) sWhereC = sWhereC + "and CLASS_ID ='"+classID+"' ";
		  if (itemID !=null && !itemID.equals("--")) sWhereC = sWhereC + "and ITEM_ID ='"+itemID+"' ";
		  sSqlC = sSqlC + sWhereC + sOrderC;	  
		  //out.println(sSqlC);		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (examineItemID!=null && !examineItemID.equals("--")) comboBoxBean.setSelection(examineItemID);		  		  		  
	      comboBoxBean.setFieldName("EXAMINE_ITEM_ID");	   
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
 <td width="54%"><strong><font color="#FFFFFF">檢驗測試項目名稱,測試項目說明:</font></strong>
 <INPUT type="text" name="SEARCHSTRING" size=25 <%if (searchString!=null) out.println("value="+searchString);%>>
 <input name="search" type=button onClick="searchRepNo('<%=pageURL%>')" value='<-查詢'> 
 </td> 
  </tr>
</table>
<A HREF="../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST"><font><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST"><font><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=100">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectExamineQuery.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-100">上一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
<%   
  try
  {   
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
          String sqlS = "select count(*) from ORADDMAN.TSCIQC_EXAMINE ";
		  String sWhereC = "where EXAMINE_ITEM_ID IS NOT NULL ";
		  if (classID!=null && !classID.equals("--")) sWhereC =sWhereC +" and CLASS_ID = '"+classID+"'  ";
		  if (itemID!=null && !itemID.equals("--")) sWhereC = sWhereC + "and ITEM_ID = '"+itemID+"' ";
		  sqlS = sqlS + sWhereC;
    
       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   {
	      String sWhereS = sWhereC + "and ( EXAMINE_ITEM_NAME='"+searchString+"' ) ";
	      lotRs=lotStat.executeQuery(sqlS+" and CLASS_ID IS NOT NULL and ITEM_ID is not null and ( EXAMINE_ITEM_NAME='"+searchString+"' ) ");	 // 如果存在檢驗測試項目代碼
 		  lotRs.next();
		  String sql1 = "select EXAMINE_ITEM_ID,EXAMINE_ITEM_CODE as 測試項目代碼,EXAMINE_ITEM_NAME as 測試項目名稱,EXAMINE_ITEM_DESC as 測試項目描述,EXM_REMARK as 測試項目備註,CREATION_DATE as 建檔日期,CREATED_BY as 建檔人員,LAST_UPDATE_DATE as 更新日期,LAST_UPDATED_BY as 更新人員 from ORADDMAN.TSCIQC_EXAMINE ";
		  sql1 = sql1 + sWhereS;
	      if (lotRs.getInt(1)>0) //如果存在業務員工號
	      {	
		    //out.println("sqlStep1="+sql1+" and ( EXAMINE_ITEM_NAME='"+searchString+"' ) order by EXAMINE_ITEM_ID");    
		    rs=statement.executeQuery(sql1+" and ( EXAMINE_ITEM_NAME='"+searchString+"' ) order by EXAMINE_ITEM_ID"); 
		  } else {	
		    //out.println("sqlStep2="+sql1+" and ( EXAMINE_ITEM_NAME='"+searchString+"' ) order by EXAMINE_ITEM_ID"); 	   
            rs=statement.executeQuery(sql1+" and ( EXAMINE_ITEM_NAME='"+searchString+"' or EXAMINE_ITEM_DESC='"+searchString+"') order by EXAMINE_ITEM_ID");	 	 
          }			
       } else {	 
	               String sql2 = "select EXAMINE_ITEM_ID,EXAMINE_ITEM_CODE as 測試項目代碼,EXAMINE_ITEM_NAME as 測試項目名稱,EXAMINE_ITEM_DESC as 測試項目描述,EXM_REMARK as 測試項目備註,CREATION_DATE as 建檔日期,CREATED_BY as 建檔人員,LAST_UPDATE_DATE as 更新日期,LAST_UPDATED_BY as 更新人員 from ORADDMAN.TSCIQC_EXAMINE ";
		           sql2 = sql2 + sWhereC;
				   //out.println("sqlStep3="+sql2+" order by EXAMINE_ITEM_ID");
	               rs=statement.executeQuery(sql2+" order by EXAMINE_ITEM_ID");
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
   qryAllChkBoxEditBean.setSearchKey("EXAMINE_ITEM_ID");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setHeadFontColor("#CCFFCC");
   qryAllChkBoxEditBean.setRowColor1("#CCFFFF");
   qryAllChkBoxEditBean.setRowColor2("#B1D3A9");    
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
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
