<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <link rel="stylesheet" href="css/jobUpdate.css">
</head>
<script src="../../js/jquery-3.6.0.min.js"></script>
<body>
<form method="post" name="modalForm">
    <!-- Modal-table -->
    <div class="modal fade" id="modal" tabindex="-1" aria-labelledby="modalTableLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" style="max-width: 1180px">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTableLabel">修改</h5>
                    <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close">
                    </button>
                </div>
                <table id="modal-table" class="table table-striped"
                       data-pagination-h-align="right"
                       data-pagination-v-align="bottom">
                </table>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">關閉</button>
                    <button id="saveBtn" type="button" class="btn btn-primary">儲存</button>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    $(function () {
        let map = new Map();
        $("#saveBtn").on("click", function () {
            // 驗證欄位
            let isValid = true;
            let dateRegex = /^\d{4}[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12]\d|3[01])$/;

            // 清除所有錯誤樣式
            $("#modal").find("input, select").removeClass("is-invalid");

            // 驗證必填欄位
            $("#modal").find("input[id*='taskDescription'], select[id*='status'], input[id*='owner'], input[id*='closedDate'], input[id*='class']").each(function () {
                let val = $(this).val()?.trim();
                let name = $(this).attr("id");

                // 空值驗證
                if (!val) {
                    $(this).addClass("is-invalid");
                    isValid = false;
                    return; // 下一個
                }

                // 日期格式驗證 (只對日期欄位)
                if (name === "requestDate" || name === "closedDate") {
                    if (!dateRegex.test(val)) {
                        $(this).addClass("is-invalid");
                        isValid = false;
                    }
                }
            });

            // 若驗證未通過，停止執行
            if (!isValid) {
                console.warn("驗證未通過");
                return;
            }

            $('#modal-table').bootstrapTable('getData').forEach(data => {
                map.set(data.no,
                    {
                        requestDate: data.requestDate,
                        taskDescription: data.taskDescription,
                        memo: data.memo,
                        status: data.status,
                        owner: data.owner,
                        closedDate: data.closedDate,
                        severity: data.severity,
                        class: data.class,
                    }
                );
            });
            let obj = Object.fromEntries(map);
            $(".loadingOverlay").css('display', 'flex');
            $.ajax({
                method: "POST",
                url: "<%=request.getContextPath()%>/task?action=update", // 送到 Servlet
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(obj),  // 轉換成 JSON 字串
                beforeSend: function() {
                    $(".loadingOverlay").show();
                },
                success: function(res) {
                    let data = JSON.parse(res);
                    if (data.status === 'error') {
                        showErrMsg(data.message);
                    }

                    $('#table').bootstrapTable('load', data);
                    $('#table').bootstrapTable('uncheckAll');
                },
                error: function(xhr) {
                    let res = JSON.parse(xhr.responseText);
                    console.error("更新失敗: ", res.error);
                    alert("更新時發生錯誤！");
                },
                complete: function() {
                    // 無論成功或失敗，都隱藏 overlay
                    $('#modal').modal('hide'); // 關閉 Modal
                    $(".loadingOverlay").hide();
                }
            });
            $('.bs-checkbox input[type="checkbox"]').prop('checked', false);
            $('#table input[type="checkbox"]').prop('checked', false);
            $('#table').bootstrapTable('uncheckAll');
        });
    });

    function updateModal() {
        $('#modal').modal('show');
        let selectedData = $('#table').bootstrapTable('getSelections'); // 取得選取的資料
        let columns = [
            {
                field: 'no',
                title: 'No',
                sortable: true,
            },
            // {
            //     field: 'requestDate',
            //     title: 'Request Date',
            //     id: 'modal-requestDate',
            //     sortable: true,
            // },
            // {
            //     field: 'taskDescription',
            //     title: 'Task Description',
            //     sortable: true,
            // },
            {
                field: 'memo',
                title: 'Memo',
                width: 500,
                // sortable: true,
                formatter: function (value, row, index) {
                    value = value === undefined ? '' : value;
                    return textareaFormatter (value, index, 'memo');
                    // return setInputInfo(value, index, 'memo');
                }
            },
            {
                field: 'status',
                title: 'Status',
                sortable: true,
                // width: 120,
                formatter: function (value, row, index) {
                    let statuses = ["Done", "Closed", "In Progress", "Open", "Pending", "UAT"];
                    return selectOption(value, index, 'status', statuses);
                }
            },
            {
                field: 'owner',
                title: 'Owner',
                sortable: true,
                width: 150,
                formatter: function (value, row, index) {
                    return setInputInfo(value, index, 'owner');
                }
            },
            {
                field: 'closedDate',
                title: 'Closed Date',
                sortable: true,
                width: 180,
                formatter: function (value, row, index) {
                    value = value ? value : '';
                    // value = value === undefined ? '' : value;
                    return dateFormatter(value, index, 'closedDate');
                }
            },
            {
                field: 'severity',
                title: 'Severity',
                sortable: true,
                formatter: function (value, row, index) {
                    return setInputInfo(value, index, 'severity');
                }
            },
            {
                field: 'class',
                title: 'Class',
                sortable: true,
                formatter: function (value, row, index) {
                    value = value === undefined ? '' : value;
                    return setInputInfo(value, index, 'class');
                }
            }
        ];

        $("#modal-table").bootstrapTable("destroy").bootstrapTable({
            height: 400, // 固定表格高度，出現滾動條
            columns: columns,
            data: selectedData,
            pagination: false,
            // formatShowingRows: function (from, to, total) {
            //     return '顯示第 ' + from + ' 到第 ' + to + ' 筆，共 ' + total + ' 筆';
            // },
            sidePagination: 'client', // server: 使用後端分頁
            onPostBody: function() {
                // 重新初始化 datepicker
                $('.datepicker-input').datepicker({
                    format: 'yyyy/mm/dd',
                    startView: 0,
                    minViewMode: 0,
                    maxViewMode: 2,
                    autoClose: true,
                    container: '#modal'
                }).on('changeDate', function (e) {
                    let index = $(this).data('index');
                    let closedDate = $(this).val();
                    let row = $('#modal-table').bootstrapTable('getData')[index];
                    if (row) {
                        row.closedDate = closedDate; // 直接更新 row
                    }
                });
            }
        });
        
        $(".datepicker-input").each(function () {
            let $input = $(this);

            // 初始化 datepicker
            $input.datepicker({
                format: "yyyy/mm/dd",
                autoclose: true
            }).on("show", function (e) {
                e.preventDefault();
                let offset = $input.offset();
                let height = $input.outerHeight();

                // 動態定位 (讓日曆顯示在 input 下方)
                $(".datepicker").css({
                    top: offset.top + height + 20,
                    left: offset.left,
                    position: "absolute"
                });
            });
        });

        // 點擊 icon 時，開啟對應 input 的 datepicker
        $(".datepicker-toggle").on("click", function (e) {
            e.preventDefault();
            $(this).closest('.input-group').find('.datepicker-input').datepicker('show');
        });

// textarea 輸入即時更新 row
        $(document).on('input', '.remark-textarea', function () {
            let index = $(this).data('index');
            let memo = $(this).val();
            let row = $('#modal-table').bootstrapTable('getData')[index];
            if (row) {
                row.memo = memo;
            }
        });

        $(document).on("change", ".statusSelect", function () {
            let index = $(this).data("index");
            let status = $(this).val();
            let row = $('#modal-table').bootstrapTable('getData')[index];
            if (row) {
                row.status = status;
            }
        });
    }

    // 定義一個全域函數來更新欄位
    function updateColumnInfo(index, field) {
        let selectField = '';
        switch (field) {
            case 'memo':
                selectField = '#modal-memo';
                break;
            case 'status':
                selectField = '#modal-status';
                break;
            case 'owner':
                selectField = '#modal-owner';
                break;
            case 'closedDate':
                selectField = '#modal-closedDate';
                break;
            case 'severity':
                selectField = '#modal-severity';
                break;
            case 'class':
                selectField = '#modal-class';
                break;
        }

        $('#modal-table').bootstrapTable('updateCell', {
            index: index,
            field: field,
            value: $(selectField + index).val()
        });
    }

    function selectOption(value, index, field, selectOption) {
        let options = selectOption.map(s =>
            `<option value="${s}" ${value == s ? 'selected' : ''}>${s}</option>`
        ).join("");
        return `<select class="form-control statusSelect" id="modal-${field+index}" data-index="${index}">${options}</select>`;
    }

    function setInputInfo(value, index, field) {
        return `<input type="text" class="form-control" style="font-size: 14px" id="modal-${field+index}" onchange="updateColumnInfo(${index}, '${field}')" value="${value}" data-index="${index}">`;
    }

    function textareaFormatter(value, index, field) {
        return '<textarea class="form-control remark-textarea" rows="2" style="font-size: 14px" id="modal-' + field+index+ '" data-index="' + index + '">' + value + '</textarea>';
    }

    function dateFormatter(value, index, field) {
        return '' +
            '<div class="input-group datepicker-group">' +
            '   <input type="text" class="form-control datepicker-input dateFormatter" id="modal-' + field + index+ '" data-index="' + index + '" value="' + value + '" readonly>' +
            '   <div class="input-group-append">' +
            '       <span class="input-group-text datepicker-toggle">' +
            '           <i class="bi bi-calendar"></i>' +
            '       </span>' +
            '   </div>' +
            '</div>';
    }
</script>
</body>
</html>