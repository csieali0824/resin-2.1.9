<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page contentType="text/html; charset=utf-8" %>
<script>

    function downloadExcel() {
        let selectedValue = $('input[name="dataType"]:checked').val();
        const form = document.createElement('form');
        form.action = 'TSCSalesPrice.jsp';
        form.method = 'POST'; // 或 'GET'，根據您的 Servlet 設定
        form.target = '_blank' // 關鍵：避免關閉當前頁面時被取消

        // 新增隱藏的 input 欄位來傳遞參數
        const itemInput = document.createElement('input');
        itemInput.type = 'hidden';
        itemInput.name = 'item'; // 傳遞選取的資料類型
        itemInput.value = selectedValue;
        form.appendChild(itemInput);

        function appendParam(name, value) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            form.appendChild(input);
        }

        // 新增多個參數
        appendParam('type', 'excel');
        appendParam('item', selectedValue);

        document.body.appendChild(form);
        form.submit();

        // 建議保留一段時間再移除 form，讓請求穩定送出
        setTimeout(() => {
            form.remove();
        }, 1500); // 1.5 秒後移除
    }
</script>
<html>
<head>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/bootstrap-select.min.css">
    <link rel="stylesheet" href="../css/bootstrap-table.min.css">
    <link rel="stylesheet" href="../jsp/css/dateCodeRule.css">
    <link rel="stylesheet" href="../jsp/css/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../css/bootstrap-datepicker.min.css">
    <script src="../js/jquery-3.6.0.min.js"></script>
    <script src="../js/bootstrap-datepicker.min.js"></script>
    <script src="../js/bootstrap.bundle.min.js"></script>
    <title>TSC Item Price</title>
    <!--=============以下區段為安全認證機制==========-->
    <jsp:useBean id="tscSalesPrice" class="tscSalesPrice.TscSalesPrice"/>
    <%@ include file="/jsp/include/AuthenticationPage.jsp" %>
    <%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
</head>
<body>
<%
    String type = request.getParameter("type");
    if ("POST".equalsIgnoreCase(request.getMethod()) && !StringUtils.isNullOrEmpty(type)) {
        try {
            String item = request.getParameter("item");
            tscSalesPrice.downloadTscSalesPrice(con, response, item);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
%>
<form action="../jsp/TSCSalesPrice.jsp" method="post" name="form">
    <div class="d-flex flex-row form-group mb-3 justify-content-between">
        <div class="d-flex flex-row mt-3 justify-content-start" style="color:#000099;">
            <h3 class="text-center">TSC Sales Price List</h3>
        </div>
        <div>
            <a class="btn btn-outline-primary mt-3" href="/oradds/ORADDSMainMenu.jsp"
               role="button">
                <i class="bi bi-house fs-4"></i>
            </a>
        </div>
    </div>
    <div class="container-fluid">
        <div class="row g-3 align-items-center flex-wrap">
            <div class="col-auto">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" id="TSC" name="dataType" checked value="TSC">
                    <label class="form-check-label" for="TSC">TSC Distribution Price Book</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" id="TS" name="dataType" value="TS">
                    <label class="form-check-label" for="TS">TS Item Price Report</label>
                </div>
            </div>

            <!-- Download Button -->
            <div class="col-auto">
                <button type="button" class="btn btn-primary" onclick="downloadExcel()">
                    <i class="bi bi-download"></i>
                </button>
            </div>
        </div>

    </div>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--=================================-->
</body>
</html>

