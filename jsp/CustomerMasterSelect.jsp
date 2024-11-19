<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
  function Submit(URL)
 {  
  document.MYFORM.action=URL;
  document.MYFORM.submit();
 } 
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer Master Inquiry</title>
</head>
<body>
<FORM ACTION="../jsp/CustomerMasterInquiry.jsp" METHOD="post" NAME="MYFORM" >
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <table width="100%" border="0">
    <tr> 
      <td align="center"><strong><font color="#0000FF" size="+2" face="Arial">客戶主檔查詢
        <%
          int rs1__numRows = 50;
          int rs1__index = 0;
          int rs_numRows = 0;
          rs_numRows += rs1__numRows;
        %> 
        <% 
	      String custno=request.getParameter("CUSTNO");			
		  String custname=request.getParameter("CUSTNAME"); 	   
		  String contact=request.getParameter("CONTACT");
		  String sarea = request.getParameter("SAREA");
	      String LoginID="T"+userID;
          String roleName = "";
		  //out.println(LoginID);
		  //out.print("userID"+userID);
		  
	      String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
	      String Query = "N";     
          int numRow = 0;
	      String colorStr = "";	   
	   %>
      </font></strong>    </td>
    </tr>
  </table>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
  <table width="100%" height="53" border="0" bordercolor="#CCFFFF" >
    <tr bgcolor="#66CCFF"> 
            	 
	  <td width="15%" nowrap><font color="#000000" face="Arial Black"><strong>Customer No:
	    <input type="text" name="CUSTNO"  size="6" maxlength="6">
      </strong></font>        
      </td>
	  <td width="30%" nowrap><font color="#000000" face="Arial Black"><strong>Customer 
        Name: 
        <input type="text" name="CUSTNAME"  size="30" maxlength="30">
        </strong></font> </td>	  
	  
      <td width="14%"><input name="Search"  type="submit" value="查詢" onClick='return Submit("../jsp/CustomerMasterShow.jsp")'></td>	  
    </tr>	   
	<tr bgcolor="#66CCFF">
	  <td width="30%" nowrap><font color="#000000" face="Arial Black"><strong>Contact: 
        <input type="text" name="CONTACT"  size="30" maxlength="30">
      </strong></font>        
      </td>	        
	 <td nowrap>
		         <font color="#330099" face="Arial Black">Sales Area</font> 
        <% 
		 
		 // Statement statement=ifxDbtelcon.createStatement();  // 正式區
		 Statement statement=ifxTestCon.createStatement();    // 測試區
         ResultSet rs=null;
		  
		 String  SAREA="";		 		 
	     try
         {   
		      String sSql = "";
		      String sWhere = "";
		      sSql ="select distinct  trim(a.BUSI)||trim(a.DEPT) as DEPT,trim(a.BUSI)||trim(a.DEPT)||' ('||d.SVLDES||')'  from ac3 a,gsvbu b,gsvdept d ";
		      sWhere ="where a.BUSI !='' and a.DEPT !='' and a.BUSI=b.SVSGVL and a.DEPT=d.SVSGVL "+
		                     "and trim(a.BUSI)||trim(a.DEPT) in (select trim(cmdpfx)||trim(cloc)  from RCM )  ";		 
		      sSql = sSql+sWhere;		  
		  		      
		      rs=statement.executeQuery(sSql);
		     comboBoxAllBean.setRs(rs);
		     comboBoxAllBean.setSelection(sarea);
	         comboBoxAllBean.setFieldName("SAREA");	   
             out.println(comboBoxAllBean.getRsString());
			/* 
		      out.println("<select NAME='SAREA' onChange='setSubmit("+'"'+"../jsp/CustomerMasterInquiry.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->ALL");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(sarea)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
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
		   </td>
		   <td></td>
	</tr>
  </table>  
  <input type="text" name="ROLENAME"  size="30">
  <input type="text" name="USERID" value="<%=userID%>"  size="30">
  </FORM>
  <font color="#FF0066">
說明:<BR>
    (1).可輸入<font face="標楷體" size="3"><strong>客戶代號、客戶名稱、客戶連絡人或<font color="#000099">利潤中心代碼</font></strong></font>作為查詢條件.<BR>
    (2).查詢條件客戶代號為<font face="標楷體" size="3"><strong>完整代碼(6碼)</strong></font>,客戶名稱或客戶連絡人可輸入內含字元作<font face="標楷體" size="3"><strong>關鍵字</strong></font>查詢.<BR>
    (3).客戶名稱及客戶連絡人<font face="標楷體" size="3"><strong>大小寫</strong></font>於系統查詢時視為<font face="標楷體" size="3"><strong>相異</strong></font>.<BR>
    (4).若查詢人員非負責該客戶之業務員,則將<font face="標楷體" size="3"><strong>看不到</strong></font>客戶電話及客戶連絡人資訊.  
</font><BR>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
