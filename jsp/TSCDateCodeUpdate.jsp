<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <link rel="stylesheet" href="../jsp/css/dateCodeModal.css">
</head>
<script src="../js/jquery-3.6.0.min.js"></script>
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
    function setTableData(selectedData, url) {
        let map = new Map();
        let columns = [
            {
                field: 'no',
                title: 'No',
                sortable: true,
            },
            {
                field: 'device',
                title: 'Device',
                id: 'modal-device',
                sortable: true,
            },
            {
                field: 'dateCode',
                title: 'Date Code',
                sortable: true,
                formatter: function (value, row, index) {
                    return setInputInfo(value, index, 'dateCode');
                }
            },
            {
                field: 'marking',
                title: 'Marking',
                sortable: true,
                formatter: function (value, row, index) {
                    value = value === undefined ? '' : value;
                    return setInputInfo(value, index, 'marking');
                }
            },
            {
                field: 'remarks',
                title: 'Remarks',
                sortable: true,
                formatter: function (value, row, index) {
                    return setInputInfo(value, index, 'remarks');
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
        });

        $("#saveBtn").on("click", function () {
            $('#modal-table').bootstrapTable('getData').forEach(data => {
                map.set(data.device,
                    {
                        dateCode: data.dateCode,
                        marking: data.marking,
                        remarks: data.remarks,
                    }
                );
            });
            let obj = Object.fromEntries(map);
            $(".loadingOverlay").css('display', 'flex');
            $.ajax({
                preload: $(".loadingOverlay").show(),
                type: "POST",
                url: "" + url + "?action=update",
                data: JSON.stringify(obj),  // 轉換成 JSON 字串
                contentType: "application/json",
                success: function(response) {
                    // console.log("後端回應: ", response);
                    document.form.submit();
                },
                error: function(error) {
                    console.error("錯誤: ", error);
                }
            });

            $('#modal').modal('hide'); // 關閉 Modal

            // document.modalForm.action = '?action=save' +
            //     '&device=' + $("[id='modal-device']").val() +
            //     '&dateCode=' + $("[id^='modal-dateCode']").val() +
            //     '&marking=' + $("#modal-marking").val() +
            //     '&refresh=true';
            // document.modalForm.submit();
            // window.location.href='/oradds/jsp/TSCDateCodeSetting.jsp';
        });
    }

    // 定義一個全域函數來更新欄位
    function updateStatus(index, field) {
        const selectField = field === 'dateCode' ? '#modal-dateCode' : field === 'marking' ? '#modal-marking' : '#modal-remarks';
        $('#modal-table').bootstrapTable('updateCell', {
            index: index,
            field: field,
            value: $(selectField + index).val()
        });
    }

    function setInputInfo(value, index, field) {
        return `<input type="text" class="form-control" style="font-size: 14px" id="modal-${field+index}" onchange="updateStatus(${index}, '${field}')" value="${value}" data-index="${index}">`;
    }
</script>
</body>
</html>