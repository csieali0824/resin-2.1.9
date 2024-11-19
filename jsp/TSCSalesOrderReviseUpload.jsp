<!--modify by Peggy 20140829,added to modify FOB,PAYMENT TERM,SHIP TO CONTACT-->
<!--modify by Peggy 20150618,add two columns "Hold Shipment" & "Remove Hold"-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Order Revise Upload</title>
</head>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" ACTION="../jsp/TSCSalesOrderReviseInsert.jsp?PTYPE=1" METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
  <strong><font color="#004080" size="4" face="Arial">Sales Order Revise Upload</font></strong> 
  <table width="80%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080" face="Arial"><strong><font color="#004080">File </font>    </strong></font></div></td>
      <td width="74%"><font size="2">
        <INPUT TYPE="FILE"NAME="UPLOADFILE" size="50">
        <INPUT name="submit" TYPE="submit" value="UPLOAD" >&nbsp;&nbsp;&nbsp;&nbsp;
      </font><a title="按下此連結，下載excel上傳範本" href='..//jsp/samplefiles/D4-009_OrderRevise_Samplefile.xls'><font style="font-size:14px;font-family:arial">Download Sample File</font></a></td>
    </tr>
  </table> 
<p><font style="color:#000099;font-size:14px;font-family:arial">
   01.上傳的Excel檔案,請勿開啟。<br>
   02.上傳EXCEL檔案請依以下格式,第一列為標題列,實際資料由第二列填起。<br>
   03.欄位依序排列好位置要正確,否則會抓錯資料。<br>
   04.請確認OM及Line是正確的,此為比對依據。<br>
   05.Item, Cusomter, Initial SSD參考用,不比對資料是否一致,不修改資料。<br>
   06.PO No, Qty, Price, Request pull in to, Shipping Method,若有任一資料與原資料不同,即可進行修改line資料,但不修改header資料。<br>
   07.PO No, Qty, Price, Request pull in to, Shipping Method,若有不填入資料(空值),表示該欄位資料不進行修改。<br>
   08.若修改成功,Version Number會加1,Remarks加入原REMARKS中。<br>
   09.Change Reason(O欄位)可輸入的值為:<font color="#ff0000">Related PO change</font>,Customer Require,<font color="#ff0000">Credit problem or insolvency</font>, <font color="#ff0000">Qty and SSD Move</font>, Part NO. Amend, Sales Key In Error六種,請由下拉選單中選擇,若輸入值非前述六項之一,則無法修改訂單。<font color='red'>(2015/5/29修訂)</font><br>
   10.新增Change Comments(P欄位),可輸入變更原因。<br>
   11.新增CRD(Q欄位),輸入欲變更的REQUEST DATE。<br>
   12.上傳修改欄位新增FOB(R欄),PAYMENT TERM(S欄),SHIP TO CONTACT ID(T欄)..等三個欄位。<br>
   13.新增<font color="#ff0000">Hold Shipment(U欄位),Hold Reason(V欄位)</font>,欲Hold訂單,請選擇Yes_Cancel或Yes_Push out,並於Hold Reason欄位填入原因,欲將Hold訂單取消,請選擇Remove Hold,非上述需求者,此兩欄請保持空白。<font color="#ff0000">(2015/6/22增訂)</font><br>
   14.範例格式如下所示:</font><br>
   <br>
  <img src="images/salesorderrevise.png" ></p>
<p>&nbsp;</p>
</FORM>
</body>
</html>

