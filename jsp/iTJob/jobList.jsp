 <%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>IT JOB LIST</title>
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../css/bootstrap-select.min.css">
    <link rel="stylesheet" href="../../css/bootstrap-table.min.css">
    <link rel="stylesheet" href="css/jobList.css">
    <link rel="stylesheet" href="../../jsp/css/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../../css/bootstrap-datepicker.min.css">
    <link rel="stylesheet" href="../../css/resizableColumns.css">
    <link rel="stylesheet" href="../../css/bootstrap-multiselect.css">
    <jsp:include page="../iTJob/jobInsert.jsp"/>
    <jsp:include page="../iTJob/jobUpdate.jsp"/>
    <jsp:include page="../iTJob/jobConfirm.jsp"/>
    <jsp:include page="../iTJob/filter.jsp"/>
</head>
<script src="../../js/jquery-3.6.0.min.js"></script>
<script src="../../js/bootstrap.bundle.min.js"></script>
<script src="../../js/bootstrap-table.min.js"></script>
<script src="../../js/bootstrap-select.min.js"></script>
<script src="../../js/bootstrap-datepicker.min.js"></script>
<script src="../../js/resizableColumns.min.js"></script>
<script src="../../js/bootstrap-table-resizable.min.js"></script>
<script src="../../js/highcharts.js"></script>
<script src="../../js/bootstrap-multiselect.js"></script>
<script src="../../js/dayjs.min.js"></script>
<script>
    function showErrMsg(message) {
        $(".custom-alert").css("display", "block");
        // $("#alertMessage").text(message);
        // 用正則表達式抓出括號內的數字
        let formattedMessage = message.replace(/\((\d+)\)/, function(_, num) {
            return `(<b>${num}</b>)`;
        });

        $("#alertMessage").html(formattedMessage);
        $(".custom-alert").fadeOut(5000); // 500 毫秒淡出
    }

</script>
<!-- Loading 遮罩 -->
<div id="loading" class="loadingOverlay">
    <div class="spinner-border" role="status"></div>
</div>

<body style="overflow: hidden">
<form method="post" enctype="multipart/form-data" name="form">
    <div class="d-flex flex-row mt-4 justify-content-center">
        <h1 class="text-center"> IT JOB LIST</h1>
    </div>

    <div class="d-flex flex-row form-group">
        <div>
            <input type="file" accept=".xls" class="form-control uploadFile-control mb-3" id="fileInput" name="file"/>
        </div>

        <div class="form-group">
            <button type="button" class="btn btn-primary uploadBtn" id="uploadFile" onclick="upload()">
                <i class="bi bi-upload fs-4"></i>
            </button>
        </div>

        <div class="d-flex flex-row form-group justify-content-end">
            <div>
                <a class="mb-3 btn me-3 btn-chart" href="../iTJob/highcharts.jsp" role="button" target="_blank">
                    <i class="bi bi-pie-chart-fill fs-4"></i>
                </a>
            </div>
            <div>
                <a class="mb-3 btn btn-outline-primary me-3" href="/oradds/ORADDSMainMenu.jsp" role="button">
                    <i class="bi bi-house fs-4"></i>
                </a>
            </div>
        </div>
    </div>

    <div style="height: 1%"></div>
    <div class="d-flex flex-row form-group"  style="padding: 0 10px;">
        <button type="button" class="btn btn-primary me-3" id="insertBtn" onclick="insert()">
            <i class="bi bi-plus-lg fs-4"></i>
        </button>

        <button type="button" class="btn btn-success me-3" id="updateBtn" onclick="updateSelections()" disabled>
            <i class="bi bi-pencil-square fs-4"></i>
        </button>

        <button type="button" class="btn btn-danger me-3" id="deleteBtn" onclick="deleteSelections()" disabled>
            <i class="bi bi-trash fs-4"></i>
        </button>

        <button type="button" class="btn btn-warning me-3" id="filterBtn" onclick="filter()">
            <i class="bi bi-funnel-fill fs-4"></i>
        </button>
    </div>

    <table id="table" class="table table-striped"
           data-pagination-h-align="right"
           data-resizable="true"
           data-pagination-v-align="bottom"
    >
    </table>
    <div class="alert alert-danger alert-dismissible fade show custom-alert" role="alert" style="display: none">
        <span id="alertMessage"></span>
        <button id="errBtn" type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close">
        </button>
    </div>
</form>
<script>
    $(document).ready(function() {
        // 一開始先查詢 (參數都為 null)
        queryFromDB(null, null, null);
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

    function initQuery(data) {
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
                field: 'requestDate',
                title: 'Request Date',
                sortable: true
            },
            {
                field: 'taskDescription',
                title: 'Task Description',
                sortable: true,
            },
            {
                field: 'memo',
                title: 'Memo',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true,
            },
            {
                field: 'status',
                title: 'Status',
                sortable: true,
                cellStyle: function() {
                    return {
                        css: {
                            "white-space": "nowrap",
                            "overflow": "hidden",
                            "text-overflow": "ellipsis",
                        }
                    };
                }
            },
            {
                field: 'owner',
                title: 'Owner',
                sortable: true
            },
            {
                field: 'closedDate',
                title: 'Closed Date',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true
            },
            {
                field: 'severity',
                title: 'Severity',
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                sortable: true
            },
            {
                field: 'class',
                title: 'Class',
                sortable: true,
                formatter: function (value) {
                    return value === undefined ? '' : value;
                },
                cellStyle: function() {
                    return {
                        css: {
                            "white-space": "nowrap",
                            "overflow": "hidden",
                            "text-overflow": "ellipsis",
                        }
                    };
                }
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
            // resizable: true,
            height: 520, // 固定表格高度，出現滾動條
            columns: columns,
            data: data,
            search: true,
            formatSearch: function () {
                return '';
            },
            // 覆寫 "沒有資料" 的顯示內容
            formatNoMatches: function () {
                return "";
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

    function insert() {
        insertModal();
    }

    function updateSelections() {
        updateModal();
    }

    // function cancelSelections() {
    //     $('#table').bootstrapTable('uncheckAll');
    // }
    function filter() {
        filterModal();
    }

    function deleteSelections() {
        deleteModal();
    }

    function upload() {
        let formData = new FormData();
        let file = $("#fileInput")[0].files[0]
        if (!file) {
            alert("請選擇檔案！");
            return;
        }
        formData.append("file", file); // 將檔案加入 FormData
        $(".loadingOverlay").css('display', 'flex');
        $.ajax({
            method: "POST",
            data: formData,
            url: "<%=request.getContextPath()%>/task?action=upload", // 送到 Servlet
            processData: false,  // 不要轉換成 Query String
            contentType: false,  // 不要自動設定 Content-Type
            beforeSend: function() {
                $(".loadingOverlay").show();
            },
            success: function(res) {
                console.log(res)
                let data = JSON.parse(res);
                if (data.status === 'error') {
                    showErrMsg(data.message);
                }

                queryFromDB();
                // console.log('res=',typeof res)
                // if (typeof res === 'object') {
                //     let parseData = JSON.parse(res);
                //     if (parseData.status === 'success') {
                //         queryFromDB();
                //     } else {
                //         showErrMsg(parseData.message);
                //     }
                // } else {
                //     let stringToParseData = JSON.parse(res);
                //     if (stringToParseData.status === 'error') {
                //         showErrMsg(stringToParseData.message);
                //     }
                // }
            },
            error: function(xhr) {
                let res = JSON.parse(xhr.responseText);
                console.error("上傳錯誤: ", res.error);
            },
            complete: function() {
                // 無論成功或失敗，都隱藏 overlay
                $(".loadingOverlay").hide();
            }
        });
    }

    function queryFromDB(dateValue, status, owner) {
        $(".loadingOverlay").css('display', 'flex');
        $.ajax({
            url: "<%=request.getContextPath()%>/task?action=search", // 送到 Servlet
            method: 'POST',
            data: {
                dates: dateValue || '',
                status: status || '',
                owner: owner || ''
            },
            traditional: true,
            dataType: 'json',
            beforeSend: function() {
                $(".loadingOverlay").show();
            },
            success: function (res) {
                if (dateValue === null && status === null && owner === null) {
                    initQuery(JSON.parse(res));
                } else {
                    $('#table').bootstrapTable('load', JSON.parse(res)); // 更新表格
                }
            },
            error: function (xhr) {
                let res = JSON.parse(xhr.responseText);
                alert("查詢失敗：" + res.error);
            },
            complete: function() {
                // 無論成功或失敗，都隱藏 overlay
                $(".loadingOverlay").hide();
            }
        });
    }
</script>
</body>
</html>