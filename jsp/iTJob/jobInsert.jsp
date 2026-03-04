<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <link rel="stylesheet" href="css/jobUpdate.css">
</head>
<script src="../../js/jquery-3.6.0.min.js"></script>
<body>
<form method="post" name="modalForm">
    <!-- Modal-table -->
    <div class="modal fade" id="insertModal" tabindex="-1" aria-labelledby="insertModalTableLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" style="max-width: 1500px">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="insertModalTableLabel">新增</h5>
                    <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close">
                    </button>
                </div>

                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th>Request Date</th>
                            <th>Task Description</th>
                            <th>Memo</th>
                            <th>Status</th>
                            <th>Owner</th>
                            <th>Closed Date</th>
                            <th>Severity</th>
                            <th>Class</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td><input type="date" id="requestDate" class="form-control" style="width: 150px"/></td>
                            <td><input type="text" id="taskDescription" class="form-control" style="width: 200px"></td>
                            <td><textarea id="memo" class="form-control"  rows="1" style="width: 400px"></textarea></td>
                            <td>
                                <select id="status" class="form-select" style="width: 120px">
                                    <option value="Open">Open</option>
                                    <option value="In Progress">In Progress</option>
                                    <option value="UAT">UAT</option>
                                    <option value="Closed">Closed</option>
                                    <option value="Done">Done</option>
                                    <option value="Pending">Pending</option>
                                </select>
                            </td>
                            <td><input type="text" id="owner" class="form-control" style="width: 120px"/></td>
                            <td><input type="date" id="closedDate" class="form-control" style="width: 150px"/></td>
                            <td><input type="number" id="severity" class="form-control"/></td>
                            <td><input type="text" id="category" class="form-control" style="width: 120px"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">關閉</button>
                    <button id="insertBtn" type="button" class="btn btn-primary">儲存</button>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    $(function () {
        $("#insertBtn").on("click", function () {
            // 驗證欄位
            let isValid = true;
            let dateRegex = /^\d{4}[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12]\d|3[01])$/;

            // 清除所有錯誤樣式
            $("#insertModal").find("input, select").removeClass("is-invalid");

            // 驗證必填欄位
            $("#insertModal").find("input[id='taskDescription'], input[id='requestDate'], select[id='status'], input[id='owner'], input[id='closedDate']").each(function () {
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

            // 取得輸入的值
            let data = {
                requestDate: $("#requestDate").val(),
                taskDescription : $("#taskDescription").val(),
                memo: $("#memo").val(),
                status: $("#status").val(),
                owner: $("#owner").val(),
                closedDate: $("#closedDate").val(),
                severity: $("#severity").val(),
                category: $("#category").val()
            };
            console.log(data);
            $(".loadingOverlay").css('display', 'flex');
            $.ajax({
                method: "POST",
                url: "<%=request.getContextPath()%>/task?action=insert", // 送到 Servlet
                data: data,
                beforeSend: function() {
                    $(".loadingOverlay").show();
                },
                success: function(res) {
                    let data = JSON.parse(res);
                    if (data.status === 'error') {
                        showErrMsg(data.message);
                    }
                    queryFromDB();
                },
                error: function(xhr) {
                    let res = JSON.parse(xhr.responseText);
                    console.error("新增失敗: ", res.error);
                    alert("新增時發生錯誤！");
                },
                complete: function() {
                    // 無論成功或失敗，都隱藏 overlay
                    $('#insertModal').modal('hide'); // 關閉 Modal
                    $(".loadingOverlay").hide();
                }
            });
            // $('.bs-checkbox input[type="checkbox"]').prop('checked', false);
            // $('#table input[type="checkbox"]').prop('checked', false);
            // $('#table').bootstrapTable('uncheckAll');
        });
    });

    function insertModal() {
        $('#insertModal').modal('show');
        // 先清除所有錯誤樣式
        $("#insertModal").find("input, select").removeClass("is-invalid");
        // 清空所有輸入值
        $('#insertModal').find('input:not([type="button"]):not([type="submit"]):not([type="reset"]), textarea, select')
            .each(function () {
                $(this).val('');
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
    }

</script>
</body>
</html>