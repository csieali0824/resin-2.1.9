<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name="pageHeader" property="pgTitleName" value="產品專案資訊系統"/>
<jsp:setProperty name="pageHeader" property="pgSalesCode" value="市場型號"/>
<jsp:setProperty name="pageHeader" property="pgProjectCode" value="機種型號"/>
<jsp:setProperty name="pageHeader" property="pgProductType" value="產品類別"/>
<jsp:setProperty name="pageHeader" property="pgBrand" value="品牌"/>
<jsp:setProperty name="pageHeader" property="pgLength" value="長"/>
<jsp:setProperty name="pageHeader" property="pgWidth" value="寬"/>
<jsp:setProperty name="pageHeader" property="pgHeight" value="高"/>
<jsp:setProperty name="pageHeader" property="pgWeight" value="重量"/>

<jsp:setProperty name="pageHeader" property="pgLaunchDate" value="上市日期"/>
<jsp:setProperty name="pageHeader" property="pgDeLaunchDate" value="下市日期"/>
<jsp:setProperty name="pageHeader" property="pgSize" value="體積"/>
<jsp:setProperty name="pageHeader" property="pgDisplay" value="顯示"/>
<jsp:setProperty name="pageHeader" property="pgCamera" value="相機"/>
<jsp:setProperty name="pageHeader" property="pgRingtone" value="鈴聲"/>
<jsp:setProperty name="pageHeader" property="pgPhonebook" value="電話簿"/>

<jsp:setProperty name="pageHeader" property="pgRemark" value="附註"/>

<!--start for common use -->
<jsp:setProperty name="pageHeader" property="pgHOME" value="回首頁"/>
<jsp:setProperty name="pageHeader" property="pgSelectAll" value="選擇全部"/>
<jsp:setProperty name="pageHeader" property="pgCancelSelect" value="取消選擇"/>
<jsp:setProperty name="pageHeader" property="pgDelete" value="刪除"/>
<jsp:setProperty name="pageHeader" property="pgSave" value="存檔"/>
<jsp:setProperty name="pageHeader" property="pgAdd" value="新增"/>
<jsp:setProperty name="pageHeader" property="pgOK" value="確定"/>
<jsp:setProperty name="pageHeader" property="pgSearch" value="搜尋"/>
<jsp:setProperty name="pageHeader" property="pgPlsEnter" value="請輸入"/>
<!--end for common use -->

<!--start for page list -->
<jsp:setProperty name="pageHeader" property="pgPage" value="頁"/>
<jsp:setProperty name="pageHeader" property="pgPages" value="頁"/>
<jsp:setProperty name="pageHeader" property="pgFirst" value="第一"/>
<jsp:setProperty name="pageHeader" property="pgLast" value="最後一"/>
<jsp:setProperty name="pageHeader" property="pgPrevious" value="上一"/>
<jsp:setProperty name="pageHeader" property="pgNext" value="下一"/>
<jsp:setProperty name="pageHeader" property="pgTheNo" value="第"/>
<jsp:setProperty name="pageHeader" property="pgTotal" value="總共"/>
<jsp:setProperty name="pageHeader" property="pgRecord" value="筆記錄"/>
<!--end for page list -->

<!--start for account management -->
<jsp:setProperty name="pageHeader" property="pgChgPwd" value="修改密碼"/>
<jsp:setProperty name="pageHeader" property="pgLogin" value="登入"/>
<jsp:setProperty name="pageHeader" property="pgLogout" value="登出"/>
<jsp:setProperty name="pageHeader" property="pgMsgLicence" value="大霸電子股份有限公司版權所有"/>
<jsp:setProperty name="pageHeader" property="pgRole" value="角色"/>
<jsp:setProperty name="pageHeader" property="pgList" value="清單"/>
<jsp:setProperty name="pageHeader" property="pgNew" value="新增"/>
<jsp:setProperty name="pageHeader" property="pgRevise" value="修改"/>
<jsp:setProperty name="pageHeader" property="pgDesc" value="說明"/>
<jsp:setProperty name="pageHeader" property="pgSuccess" value="完成"/>
<jsp:setProperty name="pageHeader" property="pgFail" value="失敗"/>
<jsp:setProperty name="pageHeader" property="pgAccount" value="人員"/>
<jsp:setProperty name="pageHeader" property="pgAccountWeb" value="WEB識別碼"/>
<jsp:setProperty name="pageHeader" property="pgMail" value="電子郵件"/>
<jsp:setProperty name="pageHeader" property="pgProfile" value="基本設定"/>
<jsp:setProperty name="pageHeader" property="pgPasswd" value="密碼"/>
<jsp:setProperty name="pageHeader" property="pgLocale" value="國別"/>
<jsp:setProperty name="pageHeader" property="pgLanguage" value="語系"/>
<jsp:setProperty name="pageHeader" property="pgModule" value="模組"/>
<jsp:setProperty name="pageHeader" property="pgSeq" value="排序號"/>
<jsp:setProperty name="pageHeader" property="pgFunction" value="功能"/>
<jsp:setProperty name="pageHeader" property="pgHref" value="連結位址"/>
<jsp:setProperty name="pageHeader" property="pgRoot" value="根選單"/>
<jsp:setProperty name="pageHeader" property="pgAuthoriz" value="授權"/>
<jsp:setProperty name="pageHeader" property="pgID" value="帳號"/>

<!--end for account management -->
