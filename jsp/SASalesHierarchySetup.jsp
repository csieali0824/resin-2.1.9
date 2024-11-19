<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!--%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All Salesperson Hierarchy</title>
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
  location.href="../jsp/SASalesHierarchySetup.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
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
  String ssal=request.getParameter("SSAL"); 
  int maxrow=0;//查詢資料總筆數 
 try
  {   
   Statement statement=ifxTestCon.createStatement();
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
  
   Statement lotStat=ifxTestCon.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   ResultSet  rs=null;
   
     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	 {	   
	    lotRs=lotStat.executeQuery("select count(*) from SSM where SMFAXN !='' and SMFAXN='"+searchString+"'");	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {		   
	       rs=statement.executeQuery("select count(*) from SSM where SID = 'SM' and SMFAXN !='' and trim(SMFAXN)='"+searchString+"'  ");	
	    } else {
                    rs=statement.executeQuery("select count(*) from SSM where SMFAXN !='' and SID = 'SM' and (trim(SMFAXN) like '%"+searchString+"%' or SMDATN like '"+searchString+"%' or SNAME like '"+searchString+"%') ");	 	 
                  } //end of lotRs if		  
     } else {
	             rs=statement.executeQuery("select count(*) from SSM where SMFAXN !='' and SID = 'SM' ");
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
<FORM NAME="MYFORM" onsubmit='return submitCheck("取消確認","指派")' ACTION="../jsp/RepairMBatchProcess.jsp?FORMID=RP&SVRTYPENO=<%=svrTypeNo%>&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 
<strong><font color="#0080C0" size="5">業務員組織查詢</font></strong>(總共<%=maxrow%>&nbsp;筆記錄)</FONT><BR>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr>     
	  <td width="42%" bgcolor="#006699"><font color="#FF0066" size="2"><strong>業務員編號: 
        </strong></font><font size="2"> 
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique ssal as x ,ssal||'('||sname||')' from ssm ";		  
		  sWhereC= "where SMFAXN !=''  order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=ifxTestCon.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (ssal!=null && !ssal.equals("--")) comboBoxBean.setSelection(ssal);		  		  		  
	      comboBoxBean.setFieldName("SSAL");	   
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
    <td width="58%" bgcolor="#006699"><strong><font color="#FFFFFF" size="2">業務員工號,姓名,電子郵件帳號:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=25 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchRepNo('<%=pageURL%>')" value='<-查詢'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/SASalesHierarchySetup.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/SASalesHierarchySetup.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST"><font size="2"><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/SASalesHierarchySetup.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=100">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/SASalesHierarchySetup.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-100">上一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
<%   
  try
  {   
   Statement lotStat=ifxTestCon.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
    
       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   {
	      lotRs=lotStat.executeQuery("select count(*) from SSM where SMFAXN is not null and SMFAXN='"+searchString+"'");	 // 如果存在業務員工號
 		  lotRs.next();
	      if (lotRs.getInt(1)>0) //如果存在業務員工號
	      {
		    rs=statement.executeQuery("select SSAL as 業務員編號,SNAME as 業務員姓名,SAD1 as 地址1,SAD2 as 地址2,SAD3 as 地址3,SPHON as 連絡電話,SZIP as 業務組別,SMFAXN as 員工編號,SMDATN as 電子郵件 from SSM where SMFAXN !='' and SID = 'SM' and trim(SMFAXN)='"+searchString+"'  order by SZIP,SSAL,SNAME ASC"); 
		  } else {		   
            rs=statement.executeQuery("select SSAL as 業務員編號,SNAME as 業務員姓名,SAD1 as 地址1,SAD2 as 地址2,SAD3 as 地址3,SPHON as 連絡電話,SZIP as 業務組別,SMFAXN as 員工編號,SMDATN as 電子郵件 from SSM where SMFAXN !='' and SID = 'SM' and (trim(SMFAXN) like '%"+searchString+"%' or SMDATN like '"+searchString+"%' or SNAME like '"+searchString+"%') order by SZIP,SSAL,SNAME ASC");	 	 
          }			
       } else {	//out.println("sql="+"select SSAL,SNAME,SAD1,SAD2,SAD3,SPHON,SMFAXN,SMDATN from SSM where SID = 'SM' order by SSAL,SNAME ASC");   
	               rs=statement.executeQuery("select SSAL as 業務員編號,SNAME as 業務員姓名,SAD1 as 地址1,SAD2 as 地址2,SAD3 as 地址3,SPHON as 連絡電話,SZIP as 業務組別,SMFAXN as 員工編號,SMDATN as 電子郵件 from SSM where SMFAXN !='' and SID = 'SM' and SZIP != '' order by SZIP,SSAL,SNAME ASC");
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
   qryAllChkBoxEditBean.setSearchKey("業務員編號");
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
 %>
  
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--=================================-->
</html>

