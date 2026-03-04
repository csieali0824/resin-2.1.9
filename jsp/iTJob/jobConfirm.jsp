<%@ page contentType="text/html; charset=utf-8" %>
<html>
<body>
<form method="post" name="confirmForm">
    <!-- 刪除確認 Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmLabel">確認刪除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" id="closeBtn"></button>
                </div>
                <div class="modal-body">
                    你確定要刪除選取的資料嗎?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="confirmCancelBtn">取消</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">確定刪除</button>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
<script>
    $(function () {
        // ====== 刪除確認 Modal ======
        $('#confirmDeleteBtn').on('click', function () {
            let selectedRows = $('#table').bootstrapTable('getSelections');
            let noList = selectedRows.map(row => row.no);

            if (noList.length === 0) {
                alert("請先選取要刪除的資料！");
                return;
            }

            $(".loadingOverlay").css('display', 'flex');
            $.ajax({
                method: "POST",
                url: "<%=request.getContextPath()%>/task?action=delete",
                data: JSON.stringify(noList),
                contentType: "application/json; charset=UTF-8",
                success: function (res) {
                    let data = JSON.parse(res);
                    if (data.status === 'error') {
                        showErrMsg(data.message);
                    } else if (data.message === '') {
                        showErrMsg('No: ' + noList + ' 不存在');
                    }

                    $('#table').bootstrapTable('load', data);
                    $('#table').bootstrapTable('uncheckAll');

                    // let data = JSON.parse(res);
                    // $('#table').bootstrapTable('load', data);
                    // $('#table').bootstrapTable('uncheckAll');
                    // if (data.status === "error") {
                    //     alert(res.message || "刪除失敗");
                    // }
                },
                error: function (xhr) {
                    let res = JSON.parse(xhr.responseText);
                    console.error("刪除失敗: ", res.error);
                    alert("刪除時發生錯誤！");
                },
                complete: function () {
                    $('#deleteConfirmModal').modal('hide');
                    $(".loadingOverlay").hide();
                }
            });
        });

        $('#confirmCancelBtn').on('click', function () {
            $('#deleteConfirmModal').modal('hide');
            $('#table').bootstrapTable('uncheckAll');
        });

        $('#closeBtn').on('click', function () {
            $('#deleteConfirmModal').modal('hide');
            $('#table').bootstrapTable('uncheckAll');
        });
    });

    function deleteModal() {
        $('#deleteConfirmModal').modal('show'); // 顯示確認 Modal
    }
</script>
</html>