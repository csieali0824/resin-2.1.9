<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="dateCodeRule.dto.DateCodeDto" %>
<%@ page contentType="text/html; charset=utf-8" %>
<!--=============以下區段為安全認證機制==========-->
<%@ page import="java.util.*" %>
<%@ page import="jxl.*" %>
<%@ page import="java.lang.Math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*,bean.DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="/jsp/ExceptionHandler.jsp" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="dateCodeRule.DateCodeYYWW" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.io.File" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp" %>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
<html>
<head>
    <title>Create Date Code Rule</title>
    <jsp:useBean id="dateBean" class="bean.DateBean"/>
    <jsp:useBean id="dateCodeYYWW" class="dateCodeRule.DateCodeYYWW"/>
    <jsp:useBean id="smartUpload" class="com.jspsmart.upload.SmartUpload"/>
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/bootstrap-select.min.css">
    <link rel="stylesheet" href="../../css/bootstrap-table.min.css">
    <link rel="stylesheet" href="../../jsp/tscDateCode/css/dateCodeRule.css">
    <link rel="stylesheet" href="../../jsp/css/bootstrap-icons.min.css">
</head>
<script src="../../js/jquery-3.6.0.min.js"></script>
<script src="../../js/bootstrap.bundle.min.js"></script>
<script src="../../js/bootstrap-table.min.js"></script>
<script src="../../js/bootstrap-select.min.js"></script>
<script>
    function showErrMsg() {
        setTimeout(function () {
            $(".custom-alert").fadeOut(500); // 500 毫秒淡出
            document.form.action = '';
            document.form.submit();
        }, 3000); // 3 秒後執行
    }
</script>
<body style="overflow: hidden; margin: 0; padding: 0">
<%
    // 避免 null 變成字串 "null"
    String initialDc = StringUtils.isNullOrEmpty(request.getParameter("dc")) ? "" : request.getParameter("dc");
    String dc = StringUtils.isNullOrEmpty(request.getParameter("dc")) ? null : request.getParameter("dc").substring(0,2);
    String dateCode = StringUtils.isNullOrEmpty(request.getParameter("dateCode")) ? null : request.getParameter("dateCode");
    String prodGroup = StringUtils.isNullOrEmpty(request.getParameter("prodGroup")) ? null : request.getParameter("prodGroup");
    String year = StringUtils.isNullOrEmpty(request.getParameter("year")) ? null : request.getParameter("year");
    System.out.println("year="+year);

    List dateCodeList = dateCodeYYWW.getDateCodeYYWW(con, null, dateCode, prodGroup, year); // todo  待和 jerry 討論是否 要將dc(6O1...) 帶入query
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
            String filePath = dateCodeYYWW.getUploadFilePath(con, startDateTime, fileName, UserName);
            file.saveAs(filePath);
        }
        dateCodeYYWW.writeExcel(request, response);
    }
%>

<form method="post" enctype="multipart/form-data" name="form">

    <div class="d-flex flex-row mt-4 justify-content-center">
        <%--        <h1 class="text-center"> Date Code Rule</h1>--%>
    </div>

    <div class="d-flex flex-row form-group">
        <div>
            <input type="file" accept=".xls" class="form-control uploadFile-control mb-3" id="fileInput" name="file"/>
        </div>

        <div class="form-group">
            <button type="button" class="btn btn-primary uploadBtn" id="uploadFile"
                    onclick="upload('<%=request.getRequestURL()%>')">
                <i class="bi bi-upload fs-4"></i>
            </button>
        </div>

        <!-- Loading 遮罩 -->
        <div id="loading" class="loadingOverlay">
            <div class="spinner-border" role="status"></div>
        </div>

<%--        <div>--%>
<%--            <a class="mb-3 btn btn-outline-primary" style="margin-right: 10px;" href="/oradds/ORADDSMainMenu.jsp"--%>
<%--               role="button">--%>
<%--                <i class="bi bi-house fs-4"></i>--%>
<%--            </a>--%>
<%--        </div>--%>
    </div>
    <div style="height: 1%"></div>
    <%--    <div class="d-flex flex-row form-group"  style="padding: 0 10px;">--%>
    <%--        <button type="button" class="btn btn-success me-3" id="updateBtn" onclick="updateSelections('<%=request.getRequestURL()%>')" disabled>--%>
    <%--            <i class="bi bi-arrow-clockwise fs-4"></i>--%>
    <%--        </button>--%>
    <%--    </div>--%>

    <table id="table" class="table table-striped"
           data-pagination-h-align="right"
           data-pagination-v-align="bottom">
    </table>
    <%
        if (dateCodeYYWW.dateCodeDto != null && !dateCodeYYWW.dateCodeDto.getErrorList().isEmpty()) {
    %>
    <div class="alert alert-danger alert-dismissible fade show custom-alert" role="alert">
        <%=dateCodeYYWW.errList2String(dateCodeYYWW.dateCodeDto.getErrorList())%>
        <button id="errBtn" type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <script>
        showErrMsg();
    </script>
    <% }
        if (dateCodeYYWW.dateCodeDto != null && !dateCodeYYWW.dateCodeDto.getErrMsg().isEmpty()) {
    %>
    <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
        <strong><%="(" + dc + ")"%>
        </strong><%=dateCodeYYWW.dateCodeDto.getErrMsg()%>
        <button id="errMsgBtn" type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
        }
    %>
</form>
<script>
    $(document).ready(function () {
        const $table = $('#table');
        const displayDc = '<%=initialDc%>'; // 取得後端傳來的參數
        const realSearchKey = displayDc.substring(0, 2);
        // 建立搜尋圖示
        // let $searchIcon = $('<i class="bi bi-search search-icon"></i>');
        // 讓搜尋框的父容器變為相對定位
        // $('.fixed-table-toolbar .search').css({
        //     'margin-top': '40px',
        //     'position': 'relative'
        // });
        // //插入搜尋圖示
        // $('.fixed-table-toolbar .search').append($searchIcon);

        // 1. 定義插入搜尋圖示的函式
        // function initSearchIcon() {
        //     const $searchContainer = $('.fixed-table-toolbar .search');
        //     // 避免重複插入 (檢查是否已經有 icon)
        //     if ($searchContainer.find('.search-icon').length === 0) {
        //         let $searchIcon = $('<i class="bi bi-search search-icon"></i>');
        //         $searchContainer.css({
        //             'position': 'relative',
        //             'margin-top': '40px'
        //         }).append($searchIcon);
        //     }
        // }

        // 2. 監聽表格渲染完成事件 (post-body)
        // 每次表格重繪 (例如換頁、搜尋) 都確保 icon 存在
        // $table.on('post-body.bs.table', function () {
        //     initSearchIcon();
        // });

        // todo 待和jerry 討論
        // 3. 執行「顯示 A 但搜尋 B」的邏輯
        // if (displayDc !== "") {
        //     setTimeout(function() {
        //         // 第一步：使用「實際關鍵字 (6B)」進行真正的過濾
        //         $table.bootstrapTable('resetSearch', realSearchKey);
        //
        //         // 第二步：強制將搜尋框的「顯示文字」改成原本的參數 (6B2)
        //         // 注意：這裡只改 .val() 而不 trigger 事件，所以表格不會重新過濾
        //         $('.fixed-table-toolbar .search input').val(displayDc);
        //
        //     }, 100); // 延遲確保表格初始化完畢
        // }

        // 3. 執行自動過濾
        // 使用 resetSearch 是最穩定的方法，它會自動填入搜尋框並觸發過濾
        // if (initialDc !== "") {
        //     // 稍微延遲一點點，確保表格已經初始化完畢
        //     setTimeout(function() {
        //         $table.bootstrapTable('resetSearch', displayDc);
        //     }, 100);
        // }

        $('#modal').on('hide.bs.modal', function () {
            document.activeElement.blur();
        });
        $('.selectpicker').selectpicker();
        $('.custom-alert').click(() => {
            $('.alert').alert('close');
        });
    });

    if (<%=dateCodeList.size() > 0%>) {
        query(<%=dateCodeYYWW.convertToJson(dateCodeList)%>);
    }

    function generateColumns(headers) {
        return headers.map(header => ({
            // checkbox: header === 'state',
            field: header,
            title: header === 'dateCode' ? 'Date Code' :
                header === 'creationDate' ? 'Creation Date' :
                    header === 'prodGroup' ? 'Prod Group' :
                        header.charAt(0).toUpperCase() + header.slice(1), // 首字母大寫
            sortable: true,
        }));
    }


    function query(data) {
        let columns = [
            // {
            //     checkbox: true,
            //     field: 'state',
            // },
            {
                field: 'dc',
                title: 'D/C', // 首字母大寫
                sortable: true
            },
            {
                field: 'dateCode',
                title: 'Date Code', // 首字母大寫
                sortable: true
            },
            {
                field: 'prodGroup',
                title: 'Prod Group', // 首字母大寫
                sortable: true,
            },
            {
                field: 'yyww',
                title: 'YYWW', // 首字母大寫
                sortable: true,
            },
            {
                field: 'year',
                title: 'Year', // 首字母大寫
                sortable: true,
            },
            // {
            //     field: 'marking',
            //     title: 'Marking',
            //     formatter: function (value) {
            //         return value === undefined ? '' : value;
            //     },
            //     sortable: true,
            // },
            // {
            //     field: 'remarks',
            //     title: 'Remarks',
            //     sortable: true,
            // },
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
            // {
            //     field: 'modifyBy',
            //     title: 'Modify By',
            //     formatter: function (value) {
            //         return value === undefined ? '' : value;
            //     },
            //     sortable: true
            // },
            // {
            //     field: 'updateDate',
            //     title: 'Update Date',
            //     sortable: true
            // }
        ];
        // 新增 checkbox 欄位，並放到第一個位置
        $("#table").bootstrapTable({
            height: 550, // 固定表格高度，出現滾動條
            columns: columns,
            data: data,
            search: true,
            formatSearch: function () {
                return '';
            },
            pagination: true,
            clickToSelect: true,
            onPostBody: function (data) {
                initSearchIcon();
            },
            formatShowingRows: function (from, to, total) {
                return '顯示第 ' + from + ' 到第 ' + to + ' 筆，共 ' + total + ' 筆';
            },
            formatRecordsPerPage: function (pageNumber) {
                return pageNumber + ' 筆/每頁';
            },
            sidePagination: 'client', // 使用前端分頁
            pageSize: 50,  // 每頁顯示 10 筆
            pageList: [50], // 可選擇每頁顯示數量
        });

        // $('#table').on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
        //     let selectedData = $('#table').bootstrapTable('getSelections');
        //     if (selectedData.length > 0 ) {
        //         $('#updateBtn').removeAttr('disabled');
        //         // $('#cancelBtn').removeAttr('disabled');
        //         $('#deleteBtn').removeAttr('disabled');
        //         $('#updateBtn').attr('disabled', false);
        //         $('#deleteBtn').attr('disabled', false);
        //     } else {
        //         $('#updateBtn').attr('disabled', true);
        //         // $('#cancelBtn').attr('disabled', true);
        //         $('#deleteBtn').attr('disabled', true);
        //     }
        // });
    }

    function initSearchIcon() {
        const $searchContainer = $('.fixed-table-toolbar .search');
        // 避免重複插入 (檢查是否已經有 icon)
        if ($searchContainer.find('.search-icon').length === 0) {
            let $searchIcon = $('<i class="bi bi-search search-icon"></i>');
            $searchContainer.css({
                'position': 'relative',
                'margin-top': '40px'
            }).append($searchIcon);
        }
    }

    function upload(url) {
        let formData = new FormData();
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
            success: function (response) {
                // console.log("後端回應: ", response);
                document.form.action = "?action=upload";
                document.form.submit();
            },
            error: function (error) {
                console.error("錯誤: ", error);
            }
        });
    }
</script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--=================================-->
</body>
</html>