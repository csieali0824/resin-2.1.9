<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <link rel="stylesheet" href="css/jobFilter.css">
</head>
<script src="../../js/jquery-3.6.0.min.js"></script>
<body>
<form method="post" name="modalForm">
    <!-- Modal-table -->
    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" style="max-width: 850px">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="filterLabel">查詢</h5>
                    <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close" id="closeBtn">
                    </button>
                </div>
                <div class="modal-body" style="display: flex; gap: 50px; flex-wrap: nowrap; margin-left: 3rem">
                    <!-- 日期區間 -->
                    <div class="form-group">
                        <label for="date" style="font-weight: bold;">日期區間：</label>
                        <div class="input-group">
                            <input type="text" id="date" name="date" class="form-control" readonly>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary datePickerBtn" type="button"
                                        id="datePickerBtn">
                                    <i class="bi bi-calendar"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="filter-item">
                            <div id="filter-area-status"></div>
                            <div id="filter-area-owner"></div>
                        </div>
                        <!-- 這裡只放空的容器，select 會用 JS 動態產生 -->
<%--                        <div id="filter-area" class="filter-item"></div>--%>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="searchCancelBtn">取消
                    </button>
                    <!-- 查詢按鈕 -->
                    <button type="button" class="btn btn-success" id="searchBtn" style="margin-left: 10px;">查詢
                    </button>
                </div>
            </div>
        </div>
    </div>
    </div>
</form>
<script>
    // 封裝可重複使用的多選下拉建立方法
    function createMultiSelect(containerId, selectId, options, placeholder, onChangeCallback) {
        let $container = $("#" + containerId);
        <%--let $label = $(`<label for="${selectId}">${placeholder}</label>`);--%>
        let $select = $(`<select id="${selectId}" multiple="multiple"></select>`);
        // 清空再建立
        $container.empty().append($select);

        options.forEach(opt => {
            $select.append(`<option value="${opt}">${opt}</option>`);
        });

        $select.multiselect({
            includeSelectAllOption: true,
            selectAllText: '全選',
            enableFiltering: true,
            // buttonWidth: '300px',
            nonSelectedText: placeholder || '請選擇',
            onChange: function () {
                if (onChangeCallback) onChangeCallback($("#" + selectId).val());
            },
            onSelectAll: function () {
                if (onChangeCallback) onChangeCallback($("#" + selectId).val());
            },
            onDeselectAll: function () {
                if (onChangeCallback) onChangeCallback($("#" + selectId).val());
            }
        });
    }
    let currentFilters = {status: [], owner: []};
    $(function () {
        const format = {
            format: 'yyyy/mm/dd',
            startView: 0,
            minViewMode: 0,
            maxViewMode: 2,
            multidate: true,
            multidateSeparator: "-",
            autoClose: true,
            // todayHighlight: true,
            // beforeShowDay: highlightRange,
        };
        // const endDate = '';
        // const startDate = '';
        // todo default
        // 取得今天
        const today = dayjs();
        // 前一個月的第一天
        const startDate = today.subtract(1, 'month').startOf('month').toDate();
        // 前一個月的最後一天
        const endDate = today.subtract(1, 'month').endOf('month').toDate();

        $('#date').datepicker(format).datepicker('setDate', [startDate, endDate], format)
            .on("changeDate", function (event) {
                let dates = event.dates;
                let elem = $('#date');
                if (elem.data("selecteddates") === dates.join(",")) return;
                if (dates.length > 2) dates = dates.splice(dates.length - 1);
                dates.sort(function (a, b) {
                    return new Date(a).getTime() - new Date(b).getTime()
                });
                elem.data("selecteddates", dates.join(",")).datepicker('setDates', dates);
            });
        // $('#date').datepicker('hide');


        $('#date').datepicker().on('show', function (e) {
            e.preventDefault()
            // 取得 input 的座標與高度
            let $input = $('#date');
            let offset = $input.offset();
            let height = $input.outerHeight();

            // 動態定位日曆
            $('.datepicker').css({
                top: offset.top + height + 15, // 在 input 下方
                left: offset.left + 25,        // 和 input 對齊
                position: 'absolute'
            });
        });

        // 點擊 icon 才會打開日曆
        $('#datePickerBtn').on('click', function (e) {
            e.preventDefault()
            $('#date').datepicker('show');
        });

        // 查詢按鈕點擊事件
        $('#searchBtn').on('click', function () {
            let dateValue = $('#date').val();
            // console.log("選擇的日期字串:", dateValue);
            $(this).blur();
            queryFromDB(dateValue, currentFilters.status, currentFilters.owner);
            $('#filterModal').modal('hide'); // 關閉 Modal
        });

        // 取消按鈕
        $('#searchCancelBtn').on('click', function () {
            $(this).blur();
            $('#filterModal').modal('hide'); // 關閉 Modal
            $('#table').bootstrapTable('uncheckAll');
        });

        $('#closeBtn').on('click', function () {
            $('#filterModal').modal('hide');
            $('#table').bootstrapTable('uncheckAll');
        });

        // 頁面初始化時，載入下拉資料
        loadStatus();
        loadOwner();
    });

    function filterModal() {
        $('#filterModal').modal('show'); // 顯示確認 Modal
    }

    function loadStatus() {
        $.ajax({
            url: "<%=request.getContextPath()%>/task?action=status", // 後端 Servlet
            method: 'GET',
            dataType: "json",
            success: function (statuses) {
                // $('#table').bootstrapTable('refresh');
                // console.log("後端回來的 status =", statuses);
                createMultiSelect("filter-area-status", "statusSelect", statuses, "Status", function (values) {
                    currentFilters.status = values || [];
                });
            },
        });
    }

    // 從後端 Servlet 取 Owner
    function loadOwner() {
        $.ajax({
            url: "<%=request.getContextPath()%>/task?action=owner", // 後端 Servlet
            method: 'GET',
            dataType: "json", //自動 JSON.parse
            success: function (owners) {
                // console.log("後端回來的 owner =", owners);
                // $('#table').bootstrapTable('refresh');
                createMultiSelect("filter-area-owner", "ownerSelect", owners, "Owner", function (values) {
                    currentFilters.owner = values || [];
                });
            }
        });
    }

</script>
</body>
</html>