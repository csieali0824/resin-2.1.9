<!--modify by Peggy 20140829,added to modify FOB,PAYMENT TERM,SHIP TO CONTACT-->
<!--modify by Peggy 20150618,add two columns "Hold Shipment" & "Remove Hold"-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.io.*" %>
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
      </font><a title="���U���s���A�U��excel�W�ǽd��" href='..//jsp/samplefiles/D4-009_OrderRevise_Samplefile.xls'><font style="font-size:14px;font-family:arial">Download Sample File</font></a></td>
    </tr>
  </table> 
<p><font style="color:#000099;font-size:14px;font-family:arial">
   01.�W�Ǫ�Excel�ɮ�,�ФŶ}�ҡC<br>
   02.�W��EXCEL�ɮ׽Ш̥H�U�榡,�Ĥ@�C�����D�C,��ڸ�ƥѲĤG�C��_�C<br>
   03.���̧ǱƦC�n��m�n���T,�_�h�|�����ơC<br>
   04.�нT�{OM��Line�O���T��,�������̾ڡC<br>
   05.Item, Cusomter, Initial SSD�Ѧҥ�,������ƬO�_�@�P,���ק��ơC<br>
   06.PO No, Qty, Price, Request pull in to, Shipping Method,�Y�����@��ƻP���Ƥ��P,�Y�i�i��ק�line���,�����ק�header��ơC<br>
   07.PO No, Qty, Price, Request pull in to, Shipping Method,�Y������J���(�ŭ�),��ܸ�����Ƥ��i��ק�C<br>
   08.�Y�ק令�\,Version Number�|�[1,Remarks�[�J��REMARKS���C<br>
   09.Change Reason(O���)�i��J���Ȭ�:<font color="#ff0000">Related PO change</font>,Customer Require,<font color="#ff0000">Credit problem or insolvency</font>, <font color="#ff0000">Qty and SSD Move</font>, Part NO. Amend, Sales Key In Error����,�ХѤU�Կ�椤���,�Y��J�ȫD�e�z�������@,�h�L�k�ק�q��C<font color='red'>(2015/5/29�׭q)</font><br>
   10.�s�WChange Comments(P���),�i��J�ܧ��]�C<br>
   11.�s�WCRD(Q���),��J���ܧ�REQUEST DATE�C<br>
   12.�W�ǭק����s�WFOB(R��),PAYMENT TERM(S��),SHIP TO CONTACT ID(T��)..���T�����C<br>
   13.�s�W<font color="#ff0000">Hold Shipment(U���),Hold Reason(V���)</font>,��Hold�q��,�п��Yes_Cancel��Yes_Push out,�é�Hold Reason����J��],���NHold�q�����,�п��Remove Hold,�D�W�z�ݨD��,������ЫO���ťաC<font color="#ff0000">(2015/6/22�W�q)</font><br>
   14.�d�Ү榡�p�U�ҥ�:</font><br>
   <br>
  <img src="images/salesorderrevise.png" ></p>
<p>&nbsp;</p>
</FORM>
</body>
</html>

