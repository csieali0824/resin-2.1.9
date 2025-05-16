<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="dateCodeRule.dto.DateCodeDto" %>
<%@ page contentType="text/html; charset=utf-8" %>
<!--=============以下區段為安全認證機制==========-->
<%@ page import="java.util.*" %>
<%@ page import="jxl.*" %>
<%@ page import="java.lang.Math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="dateCodeRule.DateCodeRuleSetting" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.io.File" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp" %>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
<html>
<head>
    <title>Create Date Code Rule</title>
    <jsp:useBean id="dateBean" class="DateBean"/>
    <jsp:include page="TSCDateCodeUpdate.jsp"/>
    <jsp:include page="TSCConfirm.jsp"/>
    <jsp:useBean id="dateCodeRule" class="dateCodeRule.DateCodeRuleSetting"/>
    <jsp:useBean id="smartUpload" class="com.jspsmart.upload.SmartUpload"/>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/bootstrap-select.min.css">
    <link rel="stylesheet" href="../css/bootstrap-table.min.css">
    <link rel="stylesheet" href="../jsp/css/dateCodeRule.css">
    <link rel="stylesheet" href="../jsp/css/bootstrap-icons.min.css">
</head>
<script src="../js/jquery-3.6.0.min.js"></script>
<script src="../js/bootstrap.bundle.min.js"></script>
<script src="../js/bootstrap-table.min.js"></script>
<script src="../js/bootstrap-select.min.js"></script>
<script>
    function showErrMsg() {
        setTimeout(function() {
            $(".custom-alert").fadeOut(500); // 500 毫秒淡出
            document.form.action = '';
            document.form.submit();
        }, 3000); // 3 秒後執行
    }
</script>
<body style="overflow: hidden">
<%
    String device = StringUtils.isNullOrEmpty(request.getParameter("device")) ? null : request.getParameter("device");
    String dateCode = StringUtils.isNullOrEmpty(request.getParameter("dateCode")) ? null : request.getParameter("dateCode");
    String marking = StringUtils.isNullOrEmpty(request.getParameter("marking")) ? null : request.getParameter("marking");

//    boolean isRefresh = !StringUtils.isNullOrEmpty(request.getParameter("refresh"));
    List dateCodeList = dateCodeRule.getItemDateCode(con, device, dateCode, marking);
    String action = StringUtils.isNullOrEmpty(request.getParameter("action")) ? "" : request.getParameter("action");
    if (action.equals("upload")) {
        smartUpload.initialize(pageContext);
        smartUpload.setAllowedFilesList("xls");
        smartUpload.upload();
        String startDate = dateBean.getYearMonthDay();
        String startDateTime = startDate + dateBean.getHourMinuteSecond();
        com.jspsmart.upload.File file = smartUpload.getFiles().getFile(0);
        // 取得檔案名稱
        String fileName = file.getFileName();
        if (fileName.isEmpty()) { // 判斷上傳檔案 device 有重複時，導頁時 fileName一定為empty，這時就不往下走，而回到一開始的頁面
            response.sendRedirect(request.getRequestURL().toString());
        } else {
            String filePath = dateCodeRule.getUploadFilePath(con, startDateTime, fileName, UserName);
            file.saveAs(filePath);
        }
        dateCodeRule.writeExcel(request, response);
//        if (DateCodeRuleSetting.dateCodeDto.getErrorList().isEmpty()) {
//            response.sendRedirect(request.getRequestURL().toString());
//        }

    } else if (action.equals("update")) {
        dateCodeRule.updateMultiTspmdItemDateCode(con, request, response, UserName);
//        dateCodeRule.updateTspmdItemDateCode(con, device, dateCode, marking);
//        if (StringUtils.isNullOrEmpty(DateCodeRuleSetting.dateCodeDto.getErrMsg())) {
//            response.sendRedirect("TSCDateCodeSetting.jsp?refresh=" + isRefresh);
//        }
    } else if (action.equals("delete")) {
        dateCodeRule.deleteItemDateCode(con, request, response);
    }
%>

<form method="post" enctype="multipart/form-data" name="form">

    <div class="d-flex flex-row mt-4 justify-content-center">
        <h1 class="text-center"> Date Code Rule</h1>
    </div>

    <div class="d-flex flex-row form-group">
        <div>
            <input type="file" accept=".xls" class="form-control uploadFile-control mb-3" id="fileInput" name="file"/>
        </div>

        <div class="form-group">
            <button type="button" class="btn btn-primary uploadBtn" id="uploadFile" onclick="upload('<%=request.getRequestURL()%>')">
                <i class="bi bi-upload fs-4"></i>
            </button>
        </div>

        <!-- Loading 遮罩 -->
        <div id="loading" class="loadingOverlay">
            <div class="spinner-border" role="status"></div>
        </div>

        <div>
            <a class="mb-3 btn btn-outline-primary" style="margin-right: 10px;" href="/oradds/ORADDSMainMenu.jsp" role="button">
                <i class="bi bi-house fs-4"></i>
            </a>
        </div>
    </div>
    <div style="height: 1%"></div>
        <div class="d-flex flex-row form-group"  style="padding: 0 10px;">
            <button type="button" class="btn btn-success me-3" id="updateBtn" onclick="updateSelections('<%=request.getRequestURL()%>')" disabled>
                <i class="bi bi-arrow-clockwise fs-4"></i>
            </button>
<%--            <button type="button" class="btn me-3" style="background: #dee2e6" id="cancelBtn" onclick="cancelSelections()" disabled>--%>
<%--                <i class="bi bi-x fs-4"></i>--%>
<%--            </button>--%>
            <button type="button" class="btn btn-danger me-3" id="deleteBtn" onclick="deleteSelections('<%=request.getRequestURL()%>')" disabled>
                <i class="bi bi-trash fs-4"></i>
            </button>
        </div>

    <table id="table" class="table table-striped"
           data-pagination-h-align="right"
           data-pagination-v-align="bottom">
    </table>
    <%
        if (!DateCodeRuleSetting.dateCodeDto.getErrorList().isEmpty()) {
    %>
            <div class="alert alert-danger alert-dismissible fade show custom-alert" role="alert">
                <%=dateCodeRule.errList2String(DateCodeRuleSetting.dateCodeDto.getErrorList())%>
                <button id="errBtn" type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <script>
                showErrMsg();
            </script>
    <%      }
        if (!DateCodeRuleSetting.dateCodeDto.getErrMsg().isEmpty()) {
    %>
            <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
                <strong><%="(" + device + ")"%></strong><%=DateCodeRuleSetting.dateCodeDto.getErrMsg()%>
                <button id="errMsgBtn" type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
    <%
        }
    %>
</form>
<script>
    $(document).ready(function () {
        // 建立搜尋圖示
        let $searchIcon = $('<i class="bi bi-search search-icon"></i>');
        // 讓搜尋框的父容器變為相對定位
        $('.fixed-table-toolbar .search').css('position', 'relative');
        // 插入搜尋圖示
        $('.fixed-table-toolbar .search').append($searchIcon);
        $('#modal').on('hide.bs.modal', function () {
            document.activeElement.blur();
        });
        $('.selectpicker').selectpicker();
        $('.custom-alert').click(() => {
            $('.alert').alert('close');
        });
    });

    if (<%=dateCodeList.size() > 0%>) {
        query(<%=dateCodeRule.convertToJson(dateCodeList)%>, <%=dateCodeRule.writeValueToString(dateCodeRule.headers())%>);
        <%--if (<%=isRefresh%>) {--%>
        <%--    query(<%=dateCodeRule.writeValueToString(dateCodeList)%>);--%>
        <%--} else {--%>
        <%--    $("#queryBtn").on("click", function () {--%>
        <%--        query(<%=dateCodeRule.writeValueToString(dateCodeList)%>);--%>
        <%--    });--%>
        <%--}--%>
    }

    function generateColumns(headers) {
        return headers.map(header => ({
            checkbox: header === 'state',
            field: header,
            title: header === 'dateCode' ? 'Date Code':
                   header === 'creationDate' ? 'Creation Date':
                   header.charAt(0).toUpperCase() + header.slice(1), // 首字母大寫
            sortable: true,
        }));
    }


    function query(data, headers) {
        // let columns = generateColumns(headers);
        let columns = [
            {
                checkbox: true,
                field: 'state',
            },
            {
                field: 'no',
                title: 'No', // 首字母大寫
                sortable: true
            },
            {
                field: 'device',
                title: 'Device', // 首字母大寫
                sortable: true
            },
            {
                field: 'dateCode',
                title: 'Date Code', // 首字母大寫
                sortable: true,
                // formatter: function (value, row, index) {
                //     return setInputInfo(value, index);
                // }
            },
            {
                field: 'marking',
                title: 'Marking',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true,
            },
            {
                field: 'remarks',
                title: 'Remarks',
                sortable: true,
            },
            {
                field: 'creationDate',
                title: 'Creation Date',
                sortable: true
            },
            {
                field: 'uploadBy',
                title: 'Upload By',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true
            },
            {
                field: 'modifyBy',
                title: 'Modify By',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true
            },
            {
                field: 'updateDate',
                title: 'Update Date',
                sortable: true
            }
            // {
            //     field: 'actions',
            //     formatter: 'deleteFormatter',
            //     event: 'window.operateEvents'
            // }
        ];
        // 新增 checkbox 欄位，並放到第一個位置
        // columns.unshift({ field: "state", checkbox: true });
        $("#table").bootstrapTable({
            height: 520, // 固定表格高度，出現滾動條
            columns: columns,
            data: data,
            search: true,
            formatSearch: function () {
                return '';
            },
            pagination: true,
            clickToSelect: true,
            formatShowingRows: function (from, to, total) {
                return '顯示第 ' + from + ' 到第 ' + to + ' 筆，共 ' + total + ' 筆';
            },
            formatRecordsPerPage: function (pageNumber) {
                return pageNumber + ' 筆/每頁';
            },
            sidePagination: 'client', // 使用後端分頁
            pageSize: 10,  // 每頁顯示 5 筆
            pageList: [10, 15, 20], // 可選擇每頁顯示數量
            // onClickRow: function (row, $element) {
                //     // 更新 Modal 內容
            //     // $("#modal-id").text(row.id);
            //     $("#modal_device").val(row.device);
            //     $("#modal_dateCode").val(row.dateCode);
            //     $("#modal_marking").val(row.marking);
            //     $("#modal_remarks").val(row.remarks);
            //
            //     // 顯示 Modal
            //     $('#modal').modal('show');
            //     save();
            // }
        });

        $('#table').on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
            let selectedData = $('#table').bootstrapTable('getSelections');
            if (selectedData.length > 0 ) {
                $('#updateBtn').removeAttr('disabled');
                // $('#cancelBtn').removeAttr('disabled');
                $('#deleteBtn').removeAttr('disabled');
                $('#updateBtn').attr('disabled', false);
                $('#deleteBtn').attr('disabled', false);
            } else {
                $('#updateBtn').attr('disabled', true);
                // $('#cancelBtn').attr('disabled', true);
                $('#deleteBtn').attr('disabled', true);
            }
        });
    }

    // 定義刪除 icon 欄位
    // function deleteFormatter(value, row, index) {
    //     return `
    //         <button class="btn btn-danger btn-sm deleteRow">
    //             <i class="fas fa-trash"></i>
    //         </button>
    //     `;
    // }

    function updateSelections(url) {
        let selectedData = $('#table').bootstrapTable('getSelections'); // 取得選取的資料
        $('#modal').modal('show');
        setTableData(selectedData, url);

        $('.bs-checkbox input[type="checkbox"]').prop('checked', false);
        $('#table input[type="checkbox"]').prop('checked', false);
        $('#table').bootstrapTable('uncheckAll');

        // $('#modal').on('hide.bs.modal', function () {
        //     $('#table').bootstrapTable('uncheckAll');
        //     document.activeElement.blur();
        // });
    }

    // function cancelSelections() {
    //     $('#table').bootstrapTable('uncheckAll');
    // }

    function deleteSelections(url) {
        let selectedRows = [];
        selectedRows = $('#table').bootstrapTable('getSelections'); // 取得已勾選的資料

        $('#deleteConfirmModal').modal('show'); // 顯示確認 Modal
        $('#closeBtn').on('click', function () {
            $('#deleteConfirmModal').modal('hide'); // 關閉 Modal
            $('#table').bootstrapTable('uncheckAll');
        });
        $('#confirmCancelBtn').on('click', function () {
            $('#deleteConfirmModal').modal('hide'); // 關閉 Modal
            $('#table').bootstrapTable('uncheckAll');
        });

        $('#confirmDeleteBtn').on('click', function () {
            let deviceToDelete = selectedRows.map(row => row.device);// 假設資料有 `id` 欄位
            $(".loadingOverlay").css('display', 'flex');
            $.ajax({
                preload: $(".loadingOverlay").show(),
                type: "POST",
                url: "" + url + "?action=delete",
                data: deviceToDelete.toString(),  // 轉換成 JSON 字串
                contentType: "application/json",
                success: function(response) {
                    // console.log("後端回應: ", response);
                    // document.form.action=";
                    document.form.submit();
                },
                error: function(error) {
                    console.error("錯誤: ", error);
                }
            });
            $('#deleteConfirmModal').modal('hide'); // 關閉 Modal
        });
    }

    // function upload() {
    //     let file = $("#fileInput").get(0).files;
    //     if (!file.length) {
    //         alert("請選擇檔案！");
    //         return;
    //     }
    //     $(".loadingOverlay").css('display', 'flex');
    //     $(".loadingOverlay").show(); // 顯示遮罩
    //     document.form.action = "?action=upload";
    //     document.form.submit();
    // }

    function upload(url) {
        let formData = new FormData();
        // let file = $("#fileInput").get(0).files;
        let file = $("#fileInput")[0].files[0]
        if (!file) {
            alert("請選擇檔案！");
            return;
        }
        formData.append("file", file); // 將檔案加入 FormData
        $(".loadingOverlay").css('display', 'flex');
        $.ajax({
            preload: $(".loadingOverlay").show(),
            type: "POST",
            data: formData,
            processData: false,  // 不要轉換成 Query String
            contentType: false,  // 不要自動設定 Content-Type
            success: function(response) {
                // console.log("後端回應: ", response);
                document.form.action = "?action=upload";
                document.form.submit();
            },
            error: function(error) {
                console.error("錯誤: ", error);
            }
        });
        // $(".loadingOverlay").css('display', 'flex');
        // $(".loadingOverlay").show(); // 顯示遮罩
        // document.form.action = "?action=upload";
        // document.form.submit();
    }
</script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--=================================-->
</body>
</html>