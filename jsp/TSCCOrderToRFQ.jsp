<%@ page contentType="text/html; charset=utf-8" language="java"
         import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="tscc.TsccOrderToRfq" %>
<html>
<head>
    <title>TSCC Order To RFQ</title>
    <script src="../js/jquery-3.6.0.min.js"></script>
    <!--=============以下區段為安全認證機制==========-->
    <%@ include file="/jsp/include/AuthenticationPage.jsp" %>
    <%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
    <%@ page import="SalesDRQPageHeaderBean" %>
    <jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
    <jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
    <jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
    <jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
    <jsp:useBean id="dateBean" scope="page" class="DateBean"/>
    <jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
    <jsp:useBean id="tsccOrderToRfq" class="tscc.TsccOrderToRfq"/>
    <link rel="stylesheet" href="../jsp/css/tsccOrderToRfq.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
    String headerId = request.getParameter("HEADER_ID");
    String salesAreaNo = "018";
    boolean permission = false;
    try {
        permission = tsccOrderToRfq.checkPermission(con, UserName);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    if (!permission) {
%>
        <script>
            alert("您無此業務區權限,請重新確認,謝謝!");
            location.href = "../ORAddsMainMenu.jsp";
        </script>
<%
        return; // 中斷 JSP 執行
    }

    if (StringUtils.isNullOrEmpty(headerId)) {
%>
        <script>
            alert("Header ID can not empty!");
            window.close();
        </script>
<%
        return; // 中斷 JSP 執行
    }

    try {
        TsccOrderToRfq.filterDtoMap = new LinkedHashMap();
        tsccOrderToRfq.getTsccToRfqData(con, headerId, null, null);
    } catch (SQLException e) {
    e.printStackTrace();
    throw new RuntimeException(e);
    }

    if (!tsccOrderToRfq.errList.isEmpty()) { // todo 測事先把 ! 移除， 之後需還原，為了顯示error畫面
%>
        <script>
            $(document).ready(function () {
                valuesList = <%=tsccOrderToRfq.wrapAsJsonArray(tsccOrderToRfq.getErrorList()) %>;
                renderErrorTable(valuesList);
            });
        </script>
<%
    } else {
        tsccOrderToRfq.redirect2TsccIntermediate(response, headerId);
    }
%>

<div id="notice">資料異常,請參考下表Error Message欄位說明,謝謝!</div>
<table id="resultTable">
    <thead>
    <tr>
        <th>Line No</th>
        <th>Order Status</th>
        <th>TSC Item Name</th>
        <th>TSC Item Desc</th>
        <th>Item Status</th>
        <th>Customer Item</th>
        <th>Qty(K)</th>
        <th>Request Date</th>
        <th>Shipping Method</th>
        <th>FOB</th>
        <th>Plant Code</th>
        <th>Error Message</th>
    </tr>
    </thead>
    <tbody id="tableBody"></tbody>
</table>

<div class="center">
    <a href="/oradds/ORADDSMainMenu.jsp">回首頁</a>
</div>

<form action="../jsp/TSCCOrderToRFQ.jsp" method="post" name="form">
    <input type="hidden" name="HEADER_ID" value="<%=headerId%>">
</form>
<script>
    let valuesList = {
        lineNo: '',
        tsccOrderStatus: '',
        itemName: '',
        itemDesc: '',
        itemStatus: '',
        orderedItem: '',
        quantity: '',
        requestDate: '',
        shippingMethod: '',
        fobPointCode: '',
        factoryCode: '',
        errorList: ''
    }

    function renderErrorTable(data) {
        const $body = $("#tableBody");
        data.forEach(dto => {
            const $row = $("<tr>");
            $row.append($("<td>").text(dto.lineNo));
            $row.append($("<td>").text(dto.tsccOrderStatus));
            $row.append($("<td>").text(dto.itemName));
            $row.append($("<td>").text(dto.itemDesc));
            $row.append($("<td>").text(dto.itemStatus));
            $row.append($("<td>").text(dto.orderedItem));
            $row.append($("<td>").text(dto.quantity));
            $row.append($("<td>").text(dto.requestDate));
            $row.append($("<td>").text(dto.shippingMethod));
            $row.append($("<td>").text(dto.fobPointCode));
            $row.append($("<td>").text(dto.factoryCode));
            $row.append($("<td>").html("<span class='error'>" + dto.errorList.join("<br>") + "</span>"));
            $body.append($row);
        });
    }
</script>
</body>
</html>