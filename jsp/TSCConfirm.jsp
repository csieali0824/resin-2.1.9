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
</html>