<%@ page contentType="text/html; charset=utf-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name="rPH" property="pgHOME" value="回首頁"/>
<jsp:setProperty name="rPH" property="pgAllRepLog" value="查詢所有維修案件"/>
<jsp:setProperty name="rPH" property="pgTxLog" value="維修件異動記錄"/>
<jsp:setProperty name="rPH" property="pgAddWKF" value="新增流程"/>
<jsp:setProperty name="rPH" property="pgRemark" value="附註"/>

<jsp:setProperty name="rPH" property="pgFormID" value="流程表單識別"/>
<jsp:setProperty name="rPH" property="pgWKFTypeNo" value="流程種類編號"/>
<jsp:setProperty name="rPH" property="pgOriStat" value="原始狀態"/>
<jsp:setProperty name="rPH" property="pgAction" value="執行動作"/>
<jsp:setProperty name="rPH" property="pgChgStat" value="變動後狀態"/>
<jsp:setProperty name="rPH" property="pgWKFDESC" value="流程說明"/>

<!--以下為頁面按鈕 -->
<jsp:setProperty name="rPH" property="pgSelectAll" value="選擇全部"/>
<jsp:setProperty name="rPH" property="pgCancelSelect" value="取消選擇"/>
<jsp:setProperty name="rPH" property="pgPlsEnter" value="請輸入"/>
<jsp:setProperty name="rPH" property="pgDelete" value="刪除"/>
<jsp:setProperty name="rPH" property="pgSave" value="存檔"/>
<jsp:setProperty name="rPH" property="pgAdd" value="新增"/>
<jsp:setProperty name="rPH" property="pgOK" value="確定"/>
<jsp:setProperty name="rPH" property="pgFetch" value="帶入"/>
<jsp:setProperty name="rPH" property="pgQuery" value="查詢"/>
<jsp:setProperty name="rPH" property="pgSearch" value="搜尋"/>
<jsp:setProperty name="rPH" property="pgExecute" value="執行"/>
<jsp:setProperty name="rPH" property="pgReset" value="重置"/>

<!--清單頁面之相關訊息-->
<jsp:setProperty name="rPH" property="pgPage" value="頁"/>
<jsp:setProperty name="rPH" property="pgPages" value="頁"/>
<jsp:setProperty name="rPH" property="pgFirst" value="第一"/>
<jsp:setProperty name="rPH" property="pgLast" value="最後一"/>
<jsp:setProperty name="rPH" property="pgPrevious" value="上一"/>
<jsp:setProperty name="rPH" property="pgNext" value="下一"/>
<jsp:setProperty name="rPH" property="pgTheNo" value="第"/>
<jsp:setProperty name="rPH" property="pgTotal" value="總共"/>
<jsp:setProperty name="rPH" property="pgRecord" value="筆記錄"/>
<jsp:setProperty name="rPH" property="pgRPProcess" value="維修案件處理"/>
<jsp:setProperty name="rPH" property="pgAllRecords" value="所有記錄"/>
<jsp:setProperty name="rPH" property="pgCode" value="代碼"/>

<!--以下為維修案件表頭 -->
<jsp:setProperty name="rPH" property="pgRepTitle" value="產品功能維修單"/>
<jsp:setProperty name="rPH" property="pgRepNote" value="為必填欄位,請務必填入相關資料"/>
<jsp:setProperty name="rPH" property="pgRepCenter" value="維修點"/>
<jsp:setProperty name="rPH" property="pgAgent" value="經銷/代理商"/>
<jsp:setProperty name="rPH" property="pgRecDate" value="收件日期"/>
<jsp:setProperty name="rPH" property="pgRecCenter" value="收件單位"/>
<jsp:setProperty name="rPH" property="pgRecPerson" value="收件人"/>
<jsp:setProperty name="rPH" property="pgCustomer" value="顧客姓名"/>
<jsp:setProperty name="rPH" property="pgTEL" value="聯絡電話"/>
<jsp:setProperty name="rPH" property="pgCell" value="行動電話"/>
<jsp:setProperty name="rPH" property="pgAddr" value="地址"/>
<jsp:setProperty name="rPH" property="pgZIP" value="郵遞區號"/>
<jsp:setProperty name="rPH" property="pgBuyingPlace" value="購買地點"/>
<jsp:setProperty name="rPH" property="pgBuyingDate" value="購買日期"/>
<jsp:setProperty name="rPH" property="pgSvrDocNo" value="服務單號"/>
<jsp:setProperty name="rPH" property="pgPart" value="料號"/>
<jsp:setProperty name="rPH" property="pgPartDesc" value="規格說明"/>
<jsp:setProperty name="rPH" property="pgModel" value="產品型號"/>
<jsp:setProperty name="rPH" property="pgColor" value="手機顏色"/>
<jsp:setProperty name="rPH" property="pgIMEI" value="IMEI序號"/>
<jsp:setProperty name="rPH" property="pgDSN" value="產品序號"/>
<jsp:setProperty name="rPH" property="pgRecItem" value="收件項目"/>
<jsp:setProperty name="rPH" property="pgJam" value="故障描述"/>
<jsp:setProperty name="rPH" property="pgOtherJam" value="其他故障描述"/>
<jsp:setProperty name="rPH" property="pgFreq" value="故障頻率"/>
<jsp:setProperty name="rPH" property="pgWarranty" value="保固類別"/>
<jsp:setProperty name="rPH" property="pgValid" value="保內"/>
<jsp:setProperty name="rPH" property="pgInvalid" value="保外"/>
<jsp:setProperty name="rPH" property="pgWarrNo" value="保固卡號"/>
<jsp:setProperty name="rPH" property="pgSvrType" value="服務類型"/>
<jsp:setProperty name="rPH" property="pgRepStatus" value="狀態"/>
<jsp:setProperty name="rPH" property="pgRepNo" value="案件編號"/>
<jsp:setProperty name="rPH" property="pgRecItem2" value="後送維修收件項目"/>
<jsp:setProperty name="rPH" property="pgWarranty2" value="判定後保固類別"/>
<jsp:setProperty name="rPH" property="pgRepLvl" value="維修等級"/>
<jsp:setProperty name="rPH" property="pgRepHistory" value="維修歷史記錄"/>
<jsp:setProperty name="rPH" property="pgDOAPVerify" value="DOA/DAP判定結果明細"/>
<jsp:setProperty name="rPH" property="pgPreRPAct" value="預計維修方式"/>
<jsp:setProperty name="rPH" property="pgActualRPAct" value="實際維修方式"/>
<jsp:setProperty name="rPH" property="pgSoftwareVer" value="軟體版本"/>
<jsp:setProperty name="rPH" property="pgChgIMEI" value="更換之IMEI"/>
<jsp:setProperty name="rPH" property="pgActualRPDesc" value="實際維修描述"/>
<jsp:setProperty name="rPH" property="pgPreUseMaterial" value="預計維修耗料"/>
<jsp:setProperty name="rPH" property="pgUseMaterial" value="維修耗料"/>
<jsp:setProperty name="rPH" property="pgRPReason" value="維修項目或分析說明"/>
<jsp:setProperty name="rPH" property="pgRPCost" value="維修費用"/>
<jsp:setProperty name="rPH" property="pgPartCost" value="材料費用"/>
<jsp:setProperty name="rPH" property="pgTransCost" value="運費"/>
<jsp:setProperty name="rPH" property="pgOtherCost" value="其他費用"/>
<jsp:setProperty name="rPH" property="pgExecutor" value="動作執行者"/>
<jsp:setProperty name="rPH" property="pgExeTime" value="執行時間"/>
<jsp:setProperty name="rPH" property="pgAssignTo" value="指派人員"/>
<jsp:setProperty name="rPH" property="pgRepPerson" value="維修人員"/>
<jsp:setProperty name="rPH" property="pgTransferTo" value="欲轉移之維修點"/>
<jsp:setProperty name="rPH" property="pgMailNotice" value="e-Mail通知"/>
<jsp:setProperty name="rPH" property="pgWorkTime" value="平均工時"/>
<jsp:setProperty name="rPH" property="pgWorkTimeMsg" value="單位/小時"/>
<jsp:setProperty name="rPH" property="pgLotNo" value="批號"/>
<jsp:setProperty name="rPH" property="pgSymptom" value="故障症狀"/>
<jsp:setProperty name="rPH" property="pgRecType" value="收件來源型態"/>
<jsp:setProperty name="rPH" property="pgPCBA" value="機板"/>
<jsp:setProperty name="rPH" property="pgRepeatRepInput" value="重覆交期詢問輸入頁面"/>
<jsp:setProperty name="rPH" property="pgWarrLimit" value="保固期限"/>

<!--以下為維修處理中案件表頭 -->
<jsp:setProperty name="rPH" property="pgAddMaterial" value="選取維修料件"/>
<jsp:setProperty name="rPH" property="pgSituation" value="機況確認項目"/>
<jsp:setProperty name="rPH" property="pgSituationMsg" value="若要進行報價才需選填"/>

<!--關於子視窗的資訊-->
<jsp:setProperty name="rPH" property="pgRelevantInfo" value="相關資訊"/>
<jsp:setProperty name="rPH" property="pgEnterCustIMEI" value="請輸入客戶姓名或IMEI序號"/>
<jsp:setProperty name="rPH" property="pgSearchByAgency" value="依經銷商/代理商查詢"/>
<jsp:setProperty name="rPH" property="pgSearchByCustIMEI" value="依客戶/IMEI查詢"/>
<jsp:setProperty name="rPH" property="pgEnterAgency" value="請輸入經銷商/代理商名稱"/>
<jsp:setProperty name="rPH" property="pgInputPart" value="切換到料號輸入"/>
<jsp:setProperty name="rPH" property="pgChoosePart" value="切換到料號選取"/>
<jsp:setProperty name="rPH" property="pgQty" value="數量"/>

<!--JavaScript中之警告文句-->
<jsp:setProperty name="rPH" property="pgAlertAction" value="請先選擇您欲執行之動作後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertModel" value="請先選擇MODEL後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrDocNo" value="請先填入服務單號後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertCustomer" value="請先填入銷售客戶後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrType" value="請先選填後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertJam" value="請先選故障描述後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertIMEI" value="請輸入該手機之IMEI序號!!"/>
<jsp:setProperty name="rPH" property="pgAlertCancel" value="確定您要CANCEL??"/>
<jsp:setProperty name="rPH" property="pgAlertAssign" value="請先選擇您欲指派之生產地後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSubmit" value="請先選擇您欲執行之動作後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRepLvl" value="請先填入維修等級!!"/>
<jsp:setProperty name="rPH" property="pgAlertLvl3" value="您所決定的維修等級為3級,請進行後送(TRANSMIT)作業!!"/>
<jsp:setProperty name="rPH" property="pgAlertNonLvl3" value="您所決定的維修等級不為3級,不需進行後送(TRANSMIT)作業!!"/>
<jsp:setProperty name="rPH" property="pgAlertReassign" value="請先輸入重新指派原因於說明攔再進行重新指派(REASSIGN)!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransfer" value="請先選定欲轉移之維修點後再進行轉移(TRANSFER)!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecItem2" value="請一定要點選輸入後送維修收件項目!!"/>
<jsp:setProperty name="rPH" property="pgAlertSoftVer" value="依據您所選取的維修方式，請先填入軟體版本後再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertChgIMEI" value="依據您所選取的維修方式，請先填入更改之IMEI後再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertWorkTime" value="請輸入您實際完成的工時數(單位以小時計)"/>
<jsp:setProperty name="rPH" property="pgAlertRPMaterial" value="對應您所選取的維修方式,請先選取維修料件後再SubmitI!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPReason" value="請務必選擇重派/批退代碼並設定(Set)後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPAction" value="請務必選取實際維修方式後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSymptom" value="請務必選取故障特徵後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertQty" value="請先填入您實際收件之數量後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemNo" value="請先填入BPCS之真實料號後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgErrorQty" value="請先修改數量後再存檔,Handset或PCB一單只能1個!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecType" value="請先選取適當之收件來源型態後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertDOAPIMEI" value="因為您所選取的服務類型為DOA/DAP,故請先填入更換之IMEI!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgSvrType" value="確定要更改服務類型?"/>
<jsp:setProperty name="rPH" property="pgAlertPcba" value="請先填入機板之真實料號後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertMOGenSubmit" value="確定您要生成訂單嗎??"/>
<jsp:setProperty name="rPH" property="pgAlertPriceList" value="請先選擇客戶價格表後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipAddress" value="請先選擇出貨地址後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertBillAddress" value="請先選擇立帳地址後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertPayTerm" value="請先選擇付款條件後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertFOB" value="請先選擇FOB後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipMethod" value="請先選擇出貨方式後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertCheckLineFlag" value="請先選取其中一筆項目後再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertCreateDRQ" value="                   確認產生交期詢問單?\n 如欲存成草稿文件,請選擇TEMPORARY再存檔!!"/>
<jsp:setProperty name="rPH" property="pgAlertReProcessMsg" value="是否繼續處理本單據??"/>
<jsp:setProperty name="rPH" property="pgAlertShipBillMsg" value="                 請檢查該客戶之出貨/立帳地資訊!!\n 系統找不到您設定為 {主要} 出貨/立帳地內容,您需於此處重新給定.\n                    否則易導致生成訂單的錯誤!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemOrgAssignMsg" value="                 單據清單內含未指定之組織品號!!\n 請注意黃色項目品號或洽相關人員設定品號組織指派!!\n                (相對於選擇訂單類型)"/>
<jsp:setProperty name="rPH" property="pgAlertItemExistsMsg" value="                 訂單生成清單內含不存在於Oracle系統的品號 \n    請洽相關人員確認品號已建立!!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateMsg" value="          業務交期詢問單新增失敗!!,\n 請洽詢資訊部查明原因,或選擇不重覆輸入詢問單選項!!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateDtlMsg" value="          此業務交期詢問單無明細項!!,\n 請洽系統管理員,或選擇不重覆輸入詢問單選項查明原因!!"/>
<jsp:setProperty name="rPH" property="pgAlertInvCustDiffMOCust" value="發票客戶與銷售訂單客戶不同\n          請重新輸入!!"/>
<jsp:setProperty name="rPH" property="pgAlertNotExistsMO" value="不存在此銷售訂單號\n      請重新輸入!!"/>
<jsp:setProperty name="rPH" property="pgAlertDateSet" value="設定日期不得小於今日\n      請重新輸入!!"/>
<jsp:setProperty name="rPH" property="pgAlertCfmRjtMsg" value="                  本次處理內容明細含被批退之項目!!\n 請先個別處理需ABORT項目後,方能進行其餘正常單據客戶確認!!\n"/>
<jsp:setProperty name="rPH" property="pgAlertRejectMsg" value="請務必輸入批退原因說明後再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSampleCheckMsg" value="       先前已選定之樣品訂單設定,已依其SPQ/MOQ原則限制訂單輸入品項數量!!\n                           如欲重新設定,請刪除所有品項再行變更!!"/>

<!--submit後之提示句-->
<jsp:setProperty name="rPH" property="pgFreqReturn" value="返修次數"/>
<jsp:setProperty name="rPH" property="pgFreqReject" value="退修次數"/>

<!--頁面切換超連結-->
<jsp:setProperty name="rPH" property="pgPageAddRMA" value="新增維修收件記錄"/>
<jsp:setProperty name="rPH" property="pgPage3AddRMA" value="新增三級維修收件記錄"/>
<jsp:setProperty name="rPH" property="pgPageAssign" value="派工中維修案件"/>
<jsp:setProperty name="rPH" property="pgPage3Assign" value="三級派工中維修案件"/>

<!--Send Mail 之內容-->
<jsp:setProperty name="rPH" property="pgMailSubjectAssign" value="來自維修系統的指派"/>

<!--回件簽收單之內容-->
<jsp:setProperty name="rPH" property="pgCustReceipt" value="維修品回件簽收單"/>
<jsp:setProperty name="rPH" property="pgTransList" value="後送維修品清單"/>
<jsp:setProperty name="rPH" property="pgTransDate" value="後送日期"/>
<jsp:setProperty name="rPH" property="pgListNo" value="清單編號(批號)"/>
<jsp:setProperty name="rPH" property="pgReceiptNo" value="簽收單號"/>
<jsp:setProperty name="rPH" property="pgShipDate" value="出貨日期"/>
<jsp:setProperty name="rPH" property="pgShipper" value="經辦人"/>
<jsp:setProperty name="rPH" property="pgCustSign" value="客戶簽收"/>
<jsp:setProperty name="rPH" property="pgPSMessage1" value="請於收到維修品確認無誤後,在客戶簽收處簽名回傳;傳真至"/>
<jsp:setProperty name="rPH" property="pgPSMessage2" value="如有任何問題請與我聯絡。聯絡電話"/>
<jsp:setProperty name="rPH" property="pgWarnMessage" value="本公司以寄件日為準,3日內未回傳視同已收到;如有爭議請各單位自行負責"/>

<!--入庫簽收單之內容--> 
<jsp:setProperty name="rPH" property="pgInStockLotList" value="DOA/DAP工廠維修件入庫單"/>
<jsp:setProperty name="rPH" property="pgInStockNo" value="入庫單號"/>
<jsp:setProperty name="rPH" property="pgInStockDate" value="入庫日期"/>
<jsp:setProperty name="rPH" property="pgInStocker" value="入庫人員"/>
<jsp:setProperty name="rPH" property="pgWarehouserSign" value="倉庫人員簽收"/>

<!--維修流程處理後訊息畫面-->
<jsp:setProperty name="rPH" property="pgPrintCustReceipt" value="列印維修品回件簽收單"/>
<jsp:setProperty name="rPH" property="pgPrintShippedConfirm" value="列印RMA出貨確認單"/>
<jsp:setProperty name="rPH" property="pgRepairProcess" value="一般維修處理流程"/>
<jsp:setProperty name="rPH" property="pgDOAProcess" value="DOA處理流程"/>
<jsp:setProperty name="rPH" property="pgDAPProcess" value="DAP處理流程"/>

<!--領料申請單-->
<jsp:setProperty name="rPH" property="pgMaterialRequest" value="領料申請單"/>
<jsp:setProperty name="rPH" property="pgTransType" value="異動類型"/>
<jsp:setProperty name="rPH" property="pgConReg" value="國別/地區"/>
<jsp:setProperty name="rPH" property="pgDocNo" value="單據編號"/>
<jsp:setProperty name="rPH" property="pgWarehouseNo" value="倉別"/>
<jsp:setProperty name="rPH" property="pgLocation" value="儲位"/>
<jsp:setProperty name="rPH" property="pgPersonal" value="個人"/>
<jsp:setProperty name="rPH" property="pgInvTransInput" value="庫存異動輸入"/>
<jsp:setProperty name="rPH" property="pgInvTransQuery" value="庫存異動查詢"/>

<jsp:setProperty name="rPH" property="pgAllMRLog" value="查詢所有領料案件"/>
<jsp:setProperty name="rPH" property="pgAlertMRReason" value="請選擇領料原因"/>
<jsp:setProperty name="rPH" property="pgAlertMRChoose" value="請先選擇您欲申請的料件後再存檔"/>
<jsp:setProperty name="rPH" property="pgApDate" value="申請日期"/>
<jsp:setProperty name="rPH" property="pgApplicant" value="申請人"/>
<jsp:setProperty name="rPH" property="pgMRReason" value="領料原因"/>
<jsp:setProperty name="rPH" property="pgInvMagProcess" value="庫存管理作業"/>
<jsp:setProperty name="rPH" property="pgMRProcess" value="領料案件處理"/>
<jsp:setProperty name="rPH" property="pgApplyPart" value="申請料件"/>
<jsp:setProperty name="rPH" property="pgReceivePart" value="實領料件"/>
<jsp:setProperty name="rPH" property="pgMRDesc" value="料號說明"/>
<jsp:setProperty name="rPH" property="pgProvdTime" value="發料時間"/>

<jsp:setProperty name="rPH" property="pgMRR" value="料件退回申請單"/>
<jsp:setProperty name="rPH" property="pgReturnPart" value="退回料件"/>
<jsp:setProperty name="rPH" property="pgOriWhs" value="原歸屬倉別"/>
<jsp:setProperty name="rPH" property="pgAlertApplicant" value="請先選擇申請人!!"/>
<jsp:setProperty name="rPH" property="pgTransReason" value="異動原因"/>
<jsp:setProperty name="rPH" property="pgMAR" value="料件轉撥申請單"/>
<jsp:setProperty name="rPH" property="pgAllotPart" value="轉撥料件"/>
<jsp:setProperty name="rPH" property="pgAllottee" value="被轉撥人員"/>
<jsp:setProperty name="rPH" property="pgAlertAllottee" value="請先選擇被轉撥人員!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransReason" value="請先選擇異動原因!!"/>

<!--庫存異動-->
<!--以下為DOA/DAP表頭 -->
<jsp:setProperty name="rPH" property="pgVeriSvrType" value="判定服務類型"/>
<jsp:setProperty name="rPH" property="pgVerifyStandard" value="DOA/DAP判定標準"/>

 <!-- 維修件耗用料帳入BPCS(依料件明細) -->
<jsp:setProperty name="rPH" property="pgRepPostByItem" value="維修件耗用料帳入BPCS(依料件明細)"/>
<jsp:setProperty name="rPH" property="pgBPCSInvQty" value="BPCS庫存量"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDate" value="發料日期"/> 
<jsp:setProperty name="rPH" property="pgIssuePerson" value="發料人員"/> 
<jsp:setProperty name="rPH" property="pgTransComment" value="異動單據"/>
<jsp:setProperty name="rPH" property="pgBalanceQty" value="結餘數量"/>

 <!-- 維修件耗用料帳入BPCS(依領料單號) -->
<jsp:setProperty name="rPH" property="pgRepPostByMRequest" value="維修件耗用料帳入BPCS(依領料單號)"/>
<jsp:setProperty name="rPH" property="pgCheckItem" value="選取"/>
<jsp:setProperty name="rPH" property="pgPreparePost2BPCS" value="筆資料待入帳BPCS"/>

 <!-- 維修件耗用料帳入BPCS(依維修工程師) -->
<jsp:setProperty name="rPH" property="pgRepPostByRPEngineer" value="維修件耗用料帳入BPCS(依維修工程師)"/> 
<jsp:setProperty name="rPH" property="pgRepairEngineer" value="維修工程師"/> 
<jsp:setProperty name="rPH" property="pgItemQty" value="筆 料件項數"/> 
<jsp:setProperty name="rPH" property="pgMRItemQty" value="筆數"/> 

<!--以下為代理商/經銷商資料 -->
<jsp:setProperty name="rPH" property="pgInfo" value="基本資料"/>
<jsp:setProperty name="rPH" property="pgName" value="名稱"/>
<jsp:setProperty name="rPH" property="pgNo" value="編號"/>
<jsp:setProperty name="rPH" property="pgDepend" value="隸屬維修收件單位"/>
<jsp:setProperty name="rPH" property="pgContact" value="聯絡人"/>
<jsp:setProperty name="rPH" property="pgFAX" value="傳真"/>
<jsp:setProperty name="rPH" property="pgKeyAccount" value="關鍵經銷/代理商"/>
<jsp:setProperty name="rPH" property="pgEdit" value="編輯"/>

<!--以下為查詢頁面資料-->
  <!--維修中心每日已入帳BPCS查詢-->
<jsp:setProperty name="rPH" property="pgCentPBpcsTitle" value="維修中心每日已入帳BPCS查詢"/>
<jsp:setProperty name="rPH" property="pgPostDateFr" value="入帳日起"/>
<jsp:setProperty name="rPH" property="pgPostDateTo" value="入帳日迄"/>
<jsp:setProperty name="rPH" property="pgPostDate" value="入帳日期"/>
<jsp:setProperty name="rPH" property="pgBelPerson" value="歸屬人員"/>
<jsp:setProperty name="rPH" property="pgTransTime" value="異動時間"/>
<jsp:setProperty name="rPH" property="pgExecPerson" value="執行人員"/>
<jsp:setProperty name="rPH" property="pgBPCSSerial" value="BPCS序號"/>
<!--維修機種月份耗料及成本查詢-->
<jsp:setProperty name="rPH" property="pgModelConsumeTitle" value="維修機種月份耗料及成本查詢"/>
<jsp:setProperty name="rPH" property="pgRpPartsCostTable" value="維修耗用料件成本價格表"/>
<jsp:setProperty name="rPH" property="pgAnItem" value="項次"/>
<jsp:setProperty name="rPH" property="pgPartsConsumQty" value="料件耗用量"/>
<jsp:setProperty name="rPH" property="pgCostPrice" value="成本價格"/>
<jsp:setProperty name="rPH" property="pgAccPartsPrice" value="料件價格小計"/>
<jsp:setProperty name="rPH" property="pgGTotal" value="總計"/>
<jsp:setProperty name="rPH" property="pgCostMainten" value="維修件維修費用表"/>
<jsp:setProperty name="rPH" property="pgRPQuantity" value="維修件數"/>
<jsp:setProperty name="rPH" property="pgStdServiceFee" value="標準維修費/小時"/>
<jsp:setProperty name="rPH" property="pgActServiceFee" value="實際維修費/小時"/>
<jsp:setProperty name="rPH" property="pgModelFeeSubTotal" value="機種費用小計"/>
 <!--月份故障原因分佈查詢-->
<jsp:setProperty name="rPH" property="pgMonthFaultReasonTitle" value="月份故障原因分佈查詢"/>
<jsp:setProperty name="rPH" property="pgRate" value="比率"/>

 <!--維修領料單每日入帳BPCS對帳查詢-->
<jsp:setProperty name="rPH" property="pgMaterialReqBPCSTitle" value="維修領料單每日入帳BPCS對帳查詢"/> 
<jsp:setProperty name="rPH" property="pgIssuePartsDateFr" value="發料日期 起"/> 
<jsp:setProperty name="rPH" property="pgIssuePartsDateTo" value="發料日期 迄"/> 
<jsp:setProperty name="rPH" property="pgMatRequestForm" value="領料單號"/> 
<jsp:setProperty name="rPH" property="pgRepairNo" value="維修單號"/> 
<jsp:setProperty name="rPH" property="pgDetail" value="明細"/> 
<jsp:setProperty name="rPH" property="pgBPCSNo" value="BPCS單號"/> 
<jsp:setProperty name="rPH" property="pgBPCSDetail" value="BPCS明細"/> 

  <!--維修工程師領料/倉管發料紀錄查詢-->
<jsp:setProperty name="rPH" property="pgMaterialReqIssTitle" value="維修工程師領料/倉管發料紀錄查詢"/> 
 
  <!--領料申請單列印-->
<jsp:setProperty name="rPH" property="pgMReqInquiryLink" value="至領料紀錄查詢頁"/>
<jsp:setProperty name="rPH" property="pgYear" value="年"/>
<jsp:setProperty name="rPH" property="pgMonth" value="月"/>
<jsp:setProperty name="rPH" property="pgDay" value="日"/>
<jsp:setProperty name="rPH" property="pgS17DOAP" value="S17客戶新品不良換貨"/>
<jsp:setProperty name="rPH" property="pgS11MaterialReq" value="S11不良新品領料"/>
<jsp:setProperty name="rPH" property="pgS18WarrIn" value="S18保內維修領料"/>
<jsp:setProperty name="rPH" property="pgS19WarrOut" value="S19保外維修領料"/>
<jsp:setProperty name="rPH" property="pgEmpNo" value="員工編號"/>
<jsp:setProperty name="rPH" property="pgDeptNo" value="部門名稱"/>
<jsp:setProperty name="rPH" property="pgAppDesc" value="申請說明"/>
<jsp:setProperty name="rPH" property="pgItemDesc" value="品名"/>
<jsp:setProperty name="rPH" property="pgItemColor" value="顏色"/>
<jsp:setProperty name="rPH" property="pgAppQty" value="申請數量"/>
<jsp:setProperty name="rPH" property="pgActQty" value="實際數量"/>
<jsp:setProperty name="rPH" property="pgApproval" value="核准"/>
<jsp:setProperty name="rPH" property="pgChief" value="主管"/>
<jsp:setProperty name="rPH" property="pgTreasurer" value="會計"/>
<jsp:setProperty name="rPH" property="pgPrintDate" value="列印日期"/>

 <!-- 手機生產資訊查詢-->
<jsp:setProperty name="rPH" property="pgIssDelivery" value="外包已交/未交"/>
<jsp:setProperty name="rPH" property="pgProdDateFr" value="生產日期起"/>
<jsp:setProperty name="rPH" property="pgProdDateTo" value="生產日期迄"/>
<jsp:setProperty name="rPH" property="pgSearchStr" value="IMEI、DSN、成品料號、箱號"/>
<jsp:setProperty name="rPH" property="pgMESSOrderNo" value="生產工單號"/>
<jsp:setProperty name="rPH" property="pgProdItemNo" value="成品料號"/>
<jsp:setProperty name="rPH" property="pgMobileSoftware" value="手機軟體版本"/>
<jsp:setProperty name="rPH" property="pgLineName" value="產線名稱"/>
<jsp:setProperty name="rPH" property="pgStationName" value="站別名稱"/>
<jsp:setProperty name="rPH" property="pgSOrderIn" value="工單投產日期"/>
<jsp:setProperty name="rPH" property="pgPackingDTime" value="包裝日期時間"/>
<jsp:setProperty name="rPH" property="pgOperator" value="包裝員"/>
<jsp:setProperty name="rPH" property="pgPMCC" value="PMCC碼"/>
<jsp:setProperty name="rPH" property="pgWorkOrder" value="工令"/>
<jsp:setProperty name="rPH" property="pgTestBay" value="生產測試站"/>
<jsp:setProperty name="rPH" property="pgCartonNo" value="包裝箱號"/>
<jsp:setProperty name="rPH" property="pgProductDetail" value="單據歷程"/>

 <!-- 經銷商每日上傳資料結轉查詢-->
<jsp:setProperty name="rPH" property="pgAgentUpfileInf" value="經銷商每日上傳資料結轉查詢"/>
<jsp:setProperty name="rPH" property="pgDateFr" value="日期 起"/> 
<jsp:setProperty name="rPH" property="pgDateTo" value="日期 迄"/> 
<jsp:setProperty name="rPH" property="pgAgentNo" value="經銷商編號"/>
<jsp:setProperty name="rPH" property="pgTransmitFlag" value="後送與否"/>  
<jsp:setProperty name="rPH" property="pgChgIMEIFlag" value="更換IMEI否"/>  

 <!-- 維修案件資料查詢 -->
<jsp:setProperty name="rPH" property="pgRepairCaseInf" value="維修案件資料查詢"/> 
<jsp:setProperty name="rPH" property="pgTransOption" value="後送/維修點轉移"/> 
<jsp:setProperty name="rPH" property="pgRetTimes" value="覆修次數"/> 
<jsp:setProperty name="rPH" property="pgFinishStatus" value="完修狀態"/>
<jsp:setProperty name="rPH" property="pgExcelButton" value="Excel"/>
<jsp:setProperty name="rPH" property="pgRecTime" value="收件時間"/>
<jsp:setProperty name="rPH" property="pgFinishDate" value="完修日期"/>
<jsp:setProperty name="rPH" property="pgFinishTime" value="完修時間"/>
<jsp:setProperty name="rPH" property="pgRepMethod" value="維修方式"/>
<jsp:setProperty name="rPH" property="pgLastMDate" value="最後處理日期"/>
<jsp:setProperty name="rPH" property="pgLastMPerson" value="最後處理人員"/>
<jsp:setProperty name="rPH" property="pgRepPercent" value="維修件比率"/>
<jsp:setProperty name="rPH" property="pgNotFoundMsg" value="目前資料庫查無符合查詢條件的資料"/>

<jsp:setProperty name="rPH" property="pgServiceLog" value="服務"/>
<jsp:setProperty name="rPH" property="pgReturnLog" value="客退"/>
<jsp:setProperty name="rPH" property="pgMobileRepair" value="手機維修"/>
<jsp:setProperty name="rPH" property="pgCType" value="類型"/>
<jsp:setProperty name="rPH" property="pgShipType" value="出貨"/>

<!--以下為首頁及人員管理資料 -->
<jsp:setProperty name="rPH" property="pgMenuInstruction" value="維修系統說明檔"/>
<jsp:setProperty name="rPH" property="pgDownload" value="下載專區"/>
<jsp:setProperty name="rPH" property="pgMenuGroup" value="技術交流園地"/>
<jsp:setProperty name="rPH" property="pgChgPwd" value="修改密碼"/>
<jsp:setProperty name="rPH" property="pgBulletin" value="公告/留言"/>
<jsp:setProperty name="rPH" property="pgLogin" value="登入"/>
<jsp:setProperty name="rPH" property="pgLogout" value="登出"/>
<jsp:setProperty name="rPH" property="pgMsgLicence" value="大霸電子股份有限公司版權所有"/>
<jsp:setProperty name="rPH" property="pgRole" value="角色"/>
<jsp:setProperty name="rPH" property="pgList" value="清單"/>
<jsp:setProperty name="rPH" property="pgNew" value="新增"/>
<jsp:setProperty name="rPH" property="pgRevise" value="修改"/>
<jsp:setProperty name="rPH" property="pgDesc" value="說明"/>
<jsp:setProperty name="rPH" property="pgSuccess" value="完成"/>
<jsp:setProperty name="rPH" property="pgAccount" value="人員"/>
<jsp:setProperty name="rPH" property="pgAccountWeb" value="WEB識別碼"/>
<jsp:setProperty name="rPH" property="pgMail" value="電子郵件"/>
<jsp:setProperty name="rPH" property="pgProfile" value="基本設定"/>
<jsp:setProperty name="rPH" property="pgPasswd" value="密碼"/>
<jsp:setProperty name="rPH" property="pgLocale" value="國別"/>
<jsp:setProperty name="rPH" property="pgLanguage" value="語系"/>
<jsp:setProperty name="rPH" property="pgModule" value="模組"/>
<jsp:setProperty name="rPH" property="pgSeq" value="排序號"/>
<jsp:setProperty name="rPH" property="pgFunction" value="功能"/>
<jsp:setProperty name="rPH" property="pgRoot" value="根選單"/>
<jsp:setProperty name="rPH" property="pgHref" value="連結位址"/>
<jsp:setProperty name="rPH" property="pgAuthoriz" value="授權"/>
<jsp:setProperty name="rPH" property="pgEmpID" value="工號"/>
<jsp:setProperty name="rPH" property="pgRepReceive" value="維修收件"/>
<jsp:setProperty name="rPH" property="pgBasicInf" value="基本資料"/>
<jsp:setProperty name="rPH" property="pgFLName" value="姓名"/>
<jsp:setProperty name="rPH" property="pgID" value="帳號"/>

 <!--以下為留言版及討論區等資料 -->
<jsp:setProperty name="rPH" property="pgBulletinNotice" value="公告/留言"/>
<jsp:setProperty name="rPH" property="pgPublishDate" value="發表日期"/>
<jsp:setProperty name="rPH" property="pgPublisher" value="發表人"/>
<jsp:setProperty name="rPH" property="pgPublish" value="留言"/>
<jsp:setProperty name="rPH" property="pgTopic" value="主旨"/>
<jsp:setProperty name="rPH" property="pgContent" value="內容"/>
<jsp:setProperty name="rPH" property="pgClassOfTopic" value="主題類別"/>
<jsp:setProperty name="rPH" property="pgTopicOfDiscuss" value="討論主題"/>
<jsp:setProperty name="rPH" property="pgHits" value="回應次數"/>
<jsp:setProperty name="rPH" property="pgNewTopic" value="發表新主題"/>
<jsp:setProperty name="rPH" property="pgClass" value="類別"/>
<jsp:setProperty name="rPH" property="pgResponse" value="回覆"/>
<jsp:setProperty name="rPH" property="pgReturn" value="返回"/>
<jsp:setProperty name="rPH" property="pgRespond" value="回應"/>
<jsp:setProperty name="rPH" property="pgNewDiscuss" value="發表新的討論主題"/>
<jsp:setProperty name="rPH" property="pgUserResponse" value="回應內容"/>
<jsp:setProperty name="rPH" property="pgTime" value="時間"/>
<jsp:setProperty name="rPH" property="pgResponder" value="回應者"/>
<jsp:setProperty name="rPH" property="pgInformation" value="資訊"/>
<jsp:setProperty name="rPH" property="pgDocument" value="文件"/>

 <!--以下為售服物料功能資料 -->
<jsp:setProperty name="rPH" property="pgASMaterial" value="物料"/>
<jsp:setProperty name="rPH" property="pgUpload" value="上載"/>
<jsp:setProperty name="rPH" property="pgFile" value="檔案"/>
<jsp:setProperty name="rPH" property="pgCenter" value="中心"/>
<jsp:setProperty name="rPH" property="pgFormat" value="格式"/>
<jsp:setProperty name="rPH" property="pgFollow" value="請遵循"/>
<jsp:setProperty name="rPH" property="pgBelow" value="如下"/>
<jsp:setProperty name="rPH" property="pgAbove" value="如上"/>
<jsp:setProperty name="rPH" property="pgPreview" value="瀏覽"/>
<jsp:setProperty name="rPH" property="pgLevel" value="等級"/>
<jsp:setProperty name="rPH" property="pgLaunch" value="啟動"/>
<jsp:setProperty name="rPH" property="pgSparePart" value="零件"/>
<jsp:setProperty name="rPH" property="pgModelSeries" value="機種"/>
<jsp:setProperty name="rPH" property="pgPicture" value="圖形"/>
<jsp:setProperty name="rPH" property="pgImage" value="影像"/>
<jsp:setProperty name="rPH" property="pgInventory" value="庫存"/>
<jsp:setProperty name="rPH" property="pgCalculate" value="計算"/>
<jsp:setProperty name="rPH" property="pgPrice" value="價格"/>
<jsp:setProperty name="rPH" property="pgConsumer" value="消費者"/>
<jsp:setProperty name="rPH" property="pgRetailer" value="店面"/>
<jsp:setProperty name="rPH" property="pgASMAuthFailMsg" value="抱歉!您無權限查詢此資料"/>
<jsp:setProperty name="rPH" property="pgASMInfo" value="售後服務物料資訊"/>
<jsp:setProperty name="rPH" property="pgMOQ" value="最小訂購數量"/>
<jsp:setProperty name="rPH" property="pgSafeInv" value="安全庫存數"/>
<jsp:setProperty name="rPH" property="pgCurrInv" value="目前庫存數"/>
<jsp:setProperty name="rPH" property="pgFront" value="正面"/>
<jsp:setProperty name="rPH" property="pgBack" value="背面"/>
<jsp:setProperty name="rPH" property="pgAllASM" value="查詢所有售服物料"/>

<jsp:setProperty name="rPH" property="pgChooseMdl" value="選取機種"/>
<jsp:setProperty name="rPH" property="pgASM_EC" value="售服物料EC"/>
<jsp:setProperty name="rPH" property="pgChange" value="變更"/>
<jsp:setProperty name="rPH" property="pgNewPart4EC" value="欲變更之新料號"/>
<jsp:setProperty name="rPH" property="pgCurrModelRef" value="現行適用機種"/>
<jsp:setProperty name="rPH" property="pgModelRefMsg" value="勾選之項目是做為料號變更欲一併更換之適用的機種"/>
<jsp:setProperty name="rPH" property="pgDelImage" value="刪除圖檔"/>

 <!--以下為作業管理功能資料 -->
<jsp:setProperty name="rPH" property="pgAfterService" value="售服"/>
<jsp:setProperty name="rPH" property="pgInput" value="輸入"/>
<jsp:setProperty name="rPH" property="pgMaintenance" value="維護"/>
<jsp:setProperty name="rPH" property="pgRefresh" value="更新"/>
<jsp:setProperty name="rPH" property="pgChinese" value="中文"/>
<jsp:setProperty name="rPH" property="pgDescription" value="說明"/>
<jsp:setProperty name="rPH" property="pgType" value="型態"/>
<jsp:setProperty name="rPH" property="pgDefinition" value="定義"/>

 
<jsp:setProperty name="rPH" property="pgASModelMainten" value="售服機種內外部型號維護"/>
<jsp:setProperty name="rPH" property="pgSalesModel" value="外部型號"/>
<jsp:setProperty name="rPH" property="pgLaunchDate" value="上市日期"/>
<jsp:setProperty name="rPH" property="pgDisannulDate" value="失效日期"/>
<jsp:setProperty name="rPH" property="pgProjHoldDate" value="有效日期"/>

<jsp:setProperty name="rPH" property="pgASCodeEntry" value="售服代碼維護"/>
<jsp:setProperty name="rPH" property="pgRegion" value="區域"/>
<jsp:setProperty name="rPH" property="pgCodeClass" value="代碼類別"/>

<jsp:setProperty name="rPH" property="pgASItemInput" value="售服料件輸入"/>
<jsp:setProperty name="rPH" property="pgPartChDesc" value="料件中文說明"/>
<jsp:setProperty name="rPH" property="pgEnable" value="啟用"/>
<jsp:setProperty name="rPH" property="pgDisable" value="停用"/>
<jsp:setProperty name="rPH" property="pgModelRef" value="適用機型"/>
<jsp:setProperty name="rPH" property="pgItemLoc" value="料件位置"/>

<jsp:setProperty name="rPH" property="pgASFaultSympInput" value="售服故障/特徵代碼輸入"/>
<jsp:setProperty name="rPH" property="pgFaultCode" value="故障代碼"/>
<jsp:setProperty name="rPH" property="pgSymptomCode" value="特徵代碼"/>
<jsp:setProperty name="rPH" property="pgCodeDesc" value="代碼說明"/>
<jsp:setProperty name="rPH" property="pgCodeChDesc" value="代碼中文說明"/>
<jsp:setProperty name="rPH" property="pgCUser" value="建立人員"/>
<jsp:setProperty name="rPH" property="pgCDate" value="建立日期"/>

<jsp:setProperty name="rPH" property="pgASResActInput" value="重派/批退代碼選擇"/>
<jsp:setProperty name="rPH" property="pgActionCode" value="維修方式代碼"/>
<jsp:setProperty name="rPH" property="pgActionDesc" value="維修方式說明"/>
<jsp:setProperty name="rPH" property="pgActionChDesc" value="維修方式中文說明"/>
<jsp:setProperty name="rPH" property="pgReasonCode" value="維修原因代碼"/>
<jsp:setProperty name="rPH" property="pgReasonDesc" value="批退原因說明"/>
<jsp:setProperty name="rPH" property="pgReasonChDesc" value="維修原因中文說明"/>

<jsp:setProperty name="rPH" property="pgASMLauStatusTitle" value="售服物料機種國別/啟用狀態"/>
<jsp:setProperty name="rPH" property="pgUpdateLaunch" value="啟用更新"/>


 <!--以下為程式運行狀態頁資料 -->
<jsp:setProperty name="rPH" property="pgProgressStsBar" value="處理中..."/>

 <!--以下為報表資料 -->
<jsp:setProperty name="rPH" property="pgReport" value="報表"/>
<jsp:setProperty name="rPH" property="pgTransaction" value="異動"/>
<jsp:setProperty name="rPH" property="pgLogQty" value="登錄數"/>
<jsp:setProperty name="rPH" property="pgRepair" value="維修"/>
<jsp:setProperty name="rPH" property="pgProcess" value="處理"/>
<jsp:setProperty name="rPH" property="pgNotInclude" value="不含"/>
<jsp:setProperty name="rPH" property="pgRepCompleteRate" value="完修率"/>
<jsp:setProperty name="rPH" property="pgRepaired" value="已維修"/>
<jsp:setProperty name="rPH" property="pgRepairing" value="維修處理中"/>
<jsp:setProperty name="rPH" property="pgRepGeneral" value="一般送修"/>
<jsp:setProperty name="rPH" property="pgRepLvl1" value="一級"/>
<jsp:setProperty name="rPH" property="pgRepLvl2" value="二級"/>
<jsp:setProperty name="rPH" property="pgRepLvl3" value="三級"/>
<jsp:setProperty name="rPH" property="pgRepLvl12" value="一、二級"/>
<jsp:setProperty name="rPH" property="pgNorth" value="北"/>
<jsp:setProperty name="rPH" property="pgMiddle" value="中"/>
<jsp:setProperty name="rPH" property="pgSouth" value="南"/>
<jsp:setProperty name="rPH" property="pgAll" value="全"/>
<jsp:setProperty name="rPH" property="pgArea" value="區"/>
<jsp:setProperty name="rPH" property="pgServiceCenter" value="售服部"/>
<jsp:setProperty name="rPH" property="pgSubTotal" value="小計"/>
<jsp:setProperty name="rPH" property="pgLogModelPerm" value="登錄機型排名"/>
<jsp:setProperty name="rPH" property="pgPermutDetail" value="排名明細"/>
<jsp:setProperty name="rPH" property="pgModelDetail" value="機型明細"/>
<jsp:setProperty name="rPH" property="pgLvl12FinishTrendChart" value="一、二級各區完修趨勢圖"/>
<jsp:setProperty name="rPH" property="pgLvl3FinishTrendChart" value="三級各區完修趨勢圖"/>
<jsp:setProperty name="rPH" property="pgRepFinishTrendChart" value="完修趨勢圖"/>
<jsp:setProperty name="rPH" property="pgRepAreaSummaryReport" value="資料彙總表"/>


 <!-- 雜項詞庫 -->
<jsp:setProperty name="rPH" property="pgCase" value="案件"/>
<jsp:setProperty name="rPH" property="pgRecords" value="記錄"/>
<jsp:setProperty name="rPH" property="pgTo" value="至"/>

  <!-- WINS 原功能詞庫 -->
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

<!-- 交期詢問單輸入詞庫 -->
<jsp:setProperty name="rPH" property="pgSalesDRQ" value="業務交期詢問單"/>
<jsp:setProperty name="rPH" property="pgQDocNo" value="詢問單號"/>
<jsp:setProperty name="rPH" property="pgSalesArea" value="業務地區別"/>
<jsp:setProperty name="rPH" property="pgCustInfo" value="客戶資訊"/>
<jsp:setProperty name="rPH" property="pgSalesMan" value="業務人員"/>
<jsp:setProperty name="rPH" property="pgInvItem" value="型號"/>
<jsp:setProperty name="rPH" property="pgDeliveryDate" value="交貨日期"/>
<jsp:setProperty name="rPH" property="pgSalesOrderNo" value="銷售訂單號"/>
<jsp:setProperty name="rPH" property="pgCustPONo" value="客戶訂購單號"/>
<jsp:setProperty name="rPH" property="pgCustPOLineNo" value="客戶訂單項次"/>
<jsp:setProperty name="rPH" property="pgCurr" value="幣別"/>
<jsp:setProperty name="rPH" property="pgPreOrderType" value="預計訂單類型"/>
<jsp:setProperty name="rPH" property="pgProcessUser" value="處理人員"/>
<jsp:setProperty name="rPH" property="pgProcessDate" value="處理日期"/>
<jsp:setProperty name="rPH" property="pgProcessTime" value="處理時間"/>
<jsp:setProperty name="rPH" property="pgDRQInputPage" value="輸入頁面"/>
<jsp:setProperty name="rPH" property="pgProdManufactory" value="預定生產地"/>
<jsp:setProperty name="rPH" property="pgDeptArea" value="地區"/>
<jsp:setProperty name="rPH" property="pgNoBlankMsg" value="為必填欄位,請務必輸入"/>
<jsp:setProperty name="rPH" property="pgRFQType" value="RFQ類型"/>

<jsp:setProperty name="rPH" property="pgTSDRQNoHistory" value="交期詢問單據歷程記錄"/>
<jsp:setProperty name="rPH" property="pgCustNo" value="客戶代號"/>
<jsp:setProperty name="rPH" property="pgCustomerName" value="客戶名稱"/>
<jsp:setProperty name="rPH" property="pgRequireReason" value="交期需求原因說明"/>
<jsp:setProperty name="rPH" property="pgProcessMark" value="本次處理說明"/>
<jsp:setProperty name="rPH" property="pgCreateFormUser" value="開單人員"/>
<jsp:setProperty name="rPH" property="pgCreateFormDate" value="開單日期"/>
<jsp:setProperty name="rPH" property="pgCreateFormTime" value="開單時間"/>
<jsp:setProperty name="rPH" property="pgPreProcessUser" value="前次處理人員"/>
<jsp:setProperty name="rPH" property="pgPreProcessDate" value="前次處理日期"/>
<jsp:setProperty name="rPH" property="pgPreProcessTime" value="前次處理時間"/>
<jsp:setProperty name="rPH" property="pgProdTransferTo" value="生產地移轉至"/>
<jsp:setProperty name="rPH" property="pgDocTotAssignFac" value="單據所有指派生產地"/>
<jsp:setProperty name="rPH" property="pgDocAssignFac" value="本項指派生產地"/>
<jsp:setProperty name="rPH" property="pgDRQDocProcess" value="交期詢問單據處理流程"/>
<jsp:setProperty name="rPH" property="pgDRQInquiryReport" value="交期詢問查詢及報表作業"/>
<jsp:setProperty name="rPH" property="pgSalesOrder" value="銷售訂單"/>
<jsp:setProperty name="rPH" property="pgFirmOrderType" value="訂單類型"/>
<jsp:setProperty name="rPH" property="pgIdentityCode" value="客戶識別碼"/>
<jsp:setProperty name="rPH" property="pgSoldToOrg" value="銷售客戶"/>
<jsp:setProperty name="rPH" property="pgPriceList" value="價格表"/>
<jsp:setProperty name="rPH" property="pgShipToOrg" value="銷售地"/>
<jsp:setProperty name="rPH" property="pgGenerateInf" value="產生資訊"/>
<jsp:setProperty name="rPH" property="pgWait" value="等待"/>
<jsp:setProperty name="rPH" property="pgConfirm" value="確認"/>
<jsp:setProperty name="rPH" property="pgTSCAlias" value="台半"/>
<jsp:setProperty name="rPH" property="pgOrderedItem" value="品號"/>
<jsp:setProperty name="rPH" property="pgOR" value="或"/>
<jsp:setProperty name="rPH" property="pgBillTo" value="立帳地址"/>
<jsp:setProperty name="rPH" property="pgDeliverTo" value="交貨地址"/>
<jsp:setProperty name="rPH" property="pgPaymentTerm" value="付款條件"/>
<jsp:setProperty name="rPH" property="pgFOB" value="FOB"/>
<jsp:setProperty name="rPH" property="pgShippingMethod" value="出貨方式"/>
<jsp:setProperty name="rPH" property="pgIntExtPurchase" value="內/外購"/>
<jsp:setProperty name="rPH" property="pgPackClass" value="包裝分類"/>
<jsp:setProperty name="rPH" property="pgKPC" value="千(KPC)"/>
<jsp:setProperty name="rPH" property="pgUOM" value="單位"/>
<jsp:setProperty name="rPH" property="pgNewRequestDate" value="新交期需求日"/>
<jsp:setProperty name="rPH" property="pgTempDRQDoc" value="草稿文件"/>
<jsp:setProperty name="rPH" property="pgExceedValidDate" value="客戶交期確認超過工廠回覆3日"/>
<jsp:setProperty name="rPH" property="pgMark" value="符號"/>
<jsp:setProperty name="rPH" property="pgDenote" value="表示"/>
<jsp:setProperty name="rPH" property="pgInvalidDoc" value="本單據已失效"/>
<jsp:setProperty name="rPH" property="pgProdPC" value="工廠生管人員"/>
<jsp:setProperty name="rPH" property="pgSalesPlanner" value="銷售企劃人員"/>
<jsp:setProperty name="rPH" property="pgProdFactory" value="生產廠區"/>
<jsp:setProperty name="rPH" property="pgSalesPlanDept" value="銷售企劃區"/>
<jsp:setProperty name="rPH" property="pgReAssign" value="重新指派"/>
<jsp:setProperty name="rPH" property="pgRequestDate" value="交期需求日"/>
<jsp:setProperty name="rPH" property="pgFDeliveryDate" value="工廠交貨日"/>
<jsp:setProperty name="rPH" property="pgReturnTWN" value="回T"/>
<jsp:setProperty name="rPH" property="pgCustItemNo" value="客戶品號"/>
<jsp:setProperty name="rPH" property="pgPCAssignDate" value="企劃分派日期"/>
<jsp:setProperty name="rPH" property="pgFTArrangeDate" value="工廠排定交貨日"/>
<jsp:setProperty name="rPH" property="pgFTConfirmDate" value="工廠確定交貨日"/>
<jsp:setProperty name="rPH" property="pgPCConfirmDate" value="企劃確認交貨日"/>
<jsp:setProperty name="rPH" property="pgOrdCreateDate" value="訂單生成日期"/>
<jsp:setProperty name="rPH" property="pgAlertSysNotAllowGen" value="系統不允許生成"/>
<jsp:setProperty name="rPH" property="pgReject" value="批退"/>
<jsp:setProperty name="rPH" property="pgAbortToTempDRQ" value="原單內容產生新交期詢問單"/>
<jsp:setProperty name="rPH" property="pgChoice" value="選擇"/>
<jsp:setProperty name="rPH" property="pgAbortBefore" value="捨棄先前"/>
<jsp:setProperty name="rPH" property="pgSetup" value="設定"/>
<jsp:setProperty name="rPH" property="pgOrdCreate" value="訂單生成"/>
<jsp:setProperty name="rPH" property="pgOrgOrder" value="原訂單號"/>
<jsp:setProperty name="rPH" property="pgOrgOrderDesc" value="請輸入客戶(相同PO號)已產生的MO單\n將項次內容清單批次增加於原MO單後"/>
<jsp:setProperty name="rPH" property="pgFactDiffMsg" value="您不能選擇與原訂單不同的生產地作訂單合併!!!"/>
<jsp:setProperty name="rPH" property="pgOrderChMsg" value="選擇尚未結案且未BOOK之MO單"/>
<jsp:setProperty name="rPH" property="pgQALLToolTipMsg" value="請依企劃指派之生產地批次生成MO單"/>
<jsp:setProperty name="rPH" property="pgAppendMOMsg" value="您必需先選擇MO單作合併訂單作業"/>
<jsp:setProperty name="rPH" property="pgEndCustPO" value="終端客戶訂購單號"/>
<jsp:setProperty name="rPH" property="pgAlertMOCmbSubmit" value="確定您要合併訂單嗎?"/>
<jsp:setProperty name="rPH" property="pgAlterGenAbort" value="確定您要放棄生成訂單並將選擇項目結案嗎?\n如需以選擇內容重新詢問交期\n請勾選產生新交期詢問單確認盒!!!"/>
<jsp:setProperty name="rPH" property="pgAlertBranchConfirm" value="請您確定分公司已執行發票系統確認(Branch Confirm),否則易導致系統收料/出貨異常!!!"/>
<jsp:setProperty name="rPH" property="pgSystemHint" value="系統提示"/>
<jsp:setProperty name="rPH" property="pgVendorSSD" value="供應商交期"/>

<jsp:setProperty name="rPH" property="pgItemContent" value="項目"/>
<jsp:setProperty name="rPH" property="pgRFQProcessStatus" value="詢問單處理狀態明細"/>
<jsp:setProperty name="rPH" property="pgRFQProcessSummary" value="處理狀態彙整"/>
<jsp:setProperty name="rPH" property="pgRFQProcessing" value="開單處理中"/>
<jsp:setProperty name="rPH" property="pgRFQDOCNoClosed" value="已結案"/>
<jsp:setProperty name="rPH" property="pgRFQCompleteRate" value="完成率"/>
<jsp:setProperty name="rPH" property="pgSPCProcessSummary" value="企劃處理狀態彙整"/>
<jsp:setProperty name="rPH" property="pgFCTProcessSummary" value="工廠處理狀態彙整"/>
<jsp:setProperty name="rPH" property="pgTTEW" value="天津長威"/>
<jsp:setProperty name="rPH" property="pgYYEW" value="陽信長威"/>
<jsp:setProperty name="rPH" property="pgIILAN" value="宜蘭庫存"/>
<jsp:setProperty name="rPH" property="pgSILAN" value="宜蘭SKY"/>
<jsp:setProperty name="rPH" property="pgOILAN" value="宜蘭外購"/>
<jsp:setProperty name="rPH" property="pgNTaipei" value="NBU外購"/>
<jsp:setProperty name="rPH" property="pgRFQTemporary" value="草稿文件"/>
<jsp:setProperty name="rPH" property="pgRFQAssigning" value="企劃分派中"/>
<jsp:setProperty name="rPH" property="pgRFQEstimating" value="工廠交期排定中"/>
<jsp:setProperty name="rPH" property="pgRFQArrenged" value="工廠排定待確認"/>
<jsp:setProperty name="rPH" property="pgRFQResponding" value="企劃交期回覆中"/>
<jsp:setProperty name="rPH" property="pgRFQConfirmed" value="業務待客戶確認"/>
<jsp:setProperty name="rPH" property="pgRFQGenerating" value="銷售訂單生成中"/>
<jsp:setProperty name="rPH" property="pgRFQClosed" value="交期詢問單已結案"/>
<jsp:setProperty name="rPH" property="pgRFQAborted" value="放棄"/>
<jsp:setProperty name="rPH" property="pgProcessQty" value="處理數"/>
<jsp:setProperty name="rPH" property="pgNewNo" value="新"/>
<jsp:setProperty name="rPH" property="pgALogDesc" value="日期區間下各區詢問單登錄單據筆數"/>
<jsp:setProperty name="rPH" property="pgYellowItem" value="黃色項目"/>
<jsp:setProperty name="rPH" property="pgItemExistsMsg" value="品號不存在於ORG對應所選擇之訂單類型"/>
<jsp:setProperty name="rPH" property="pgWorkHour" value="工時"/>
<jsp:setProperty name="rPH" property="pgtheItem" value="本項"/>
<jsp:setProperty name="rPH" property="pgRFQRequestDateMsg" value="交貨日期不得小於今日!!"/>
<jsp:setProperty name="rPH" property="pgNonProcess" value="未處理"/>
<jsp:setProperty name="rPH" property="pgPlanRspPeriod" value="企劃回覆至目前已歷時/小時"/>

<jsp:setProperty name="rPH" property="pgDeliverCustomer" value="交貨客戶"/>
<jsp:setProperty name="rPH" property="pgDeliverLocation" value="交貨位址"/>
<jsp:setProperty name="rPH" property="pgDeliverContact" value="交貨連絡人"/>
<jsp:setProperty name="rPH" property="pgDeliveryTo" value="交貨代碼"/>
<jsp:setProperty name="rPH" property="pgDeliverAddress" value="交貨地址"/>
<jsp:setProperty name="rPH" property="pgNotifyContact" value="通知連絡人"/>
<jsp:setProperty name="rPH" property="pgNotifyLocation" value="通知連絡位址"/>
<jsp:setProperty name="rPH" property="pgShipContact" value="出貨連絡人"/>
<jsp:setProperty name="rPH" property="pgMain" value="主要"/>
<jsp:setProperty name="rPH" property="pgOthers" value="其他"/>
<jsp:setProperty name="rPH" property="pgFactoryResponse" value="工廠回覆"/>
<jsp:setProperty name="rPH" property="pgWith" value="與"/>
<jsp:setProperty name="rPH" property="pgDetailRpt" value="明細表"/>
<jsp:setProperty name="rPH" property="pgDateType" value="日期種類"/>
<jsp:setProperty name="rPH" property="pgFr" value="起"/>
<jsp:setProperty name="rPH" property="pgTo_" value="迄"/>
<jsp:setProperty name="rPH" property="pgSSD" value="預計出貨日"/>
<jsp:setProperty name="rPH" property="pgOrdD" value="訂單日期"/>
<jsp:setProperty name="rPH" property="pgItmFly" value="Item Family"/>
<jsp:setProperty name="rPH" property="pgItmPkg" value="Item Package"/>
<jsp:setProperty name="rPH" property="pgLDetailSave" value="本次預計將儲存明細"/>
<jsp:setProperty name="rPH" property="pgLCheckDelete" value="點取確認盒可作刪除"/>
<jsp:setProperty name="rPH" property="pgThAccShpQty" value="本次累出數量"/>
<jsp:setProperty name="rPH" property="pgFactoryDeDate" value="工廠交期"/>
<jsp:setProperty name="rPH" property="pgNoResponse" value="未回覆"/>
<jsp:setProperty name="rPH" property="pgAccWorkHours" value="開單至目前已歷時/小時"/>
<jsp:setProperty name="rPH" property="pgPlanRejectItem" value="被企劃生管批退之項目"/>
<jsp:setProperty name="rPH" property="pgSetSampleOrder" value="此單據為樣品訂單"/>
<jsp:setProperty name="rPH" property="pgSampleOrderCh" value="樣品訂單設定"/>
<jsp:setProperty name="rPH" property="pgQuotation" value="收費樣品"/>
<jsp:setProperty name="rPH" property="pgLack" value="不"/>
<jsp:setProperty name="rPH" property="pgCRDate" value="客戶需求日"/>
<jsp:setProperty name="rPH" property="pgSRDate" value="業務需求日"/>

<!--start for 出貨發票收料管理 list -->
<jsp:setProperty name="rPH" property="pgInvoiceNo" value="發票"/>
<jsp:setProperty name="rPH" property="pgPoNo" value="採購單"/>
<jsp:setProperty name="rPH" property="pgAvailableShip" value="可出貨"/>
<jsp:setProperty name="rPH" property="pgContiune" value="繼續"/>
<jsp:setProperty name="rPH" property="pgInvBranchConfirm" value="分公司尚未執行發票系統確認(Branch Confirm)"/>

<!--start for MFG list -->
<jsp:setProperty name="rPH" property="pgInSales" value="內銷"/>
<jsp:setProperty name="rPH" property="pgExpSales" value="外銷"/>
<jsp:setProperty name="rPH" property="pgSchStartDate" value="預計投入日"/>
<jsp:setProperty name="rPH" property="pgSchCompletDate" value="預計完工日"/>
<jsp:setProperty name="rPH" property="pgWafer" value="晶片"/>
<jsp:setProperty name="rPH" property="pgYield" value="良率"/>
<jsp:setProperty name="rPH" property="pgEleres" value="電阻系數"/>
<jsp:setProperty name="rPH" property="pgVendor" value="供應商"/>
<jsp:setProperty name="rPH" property="pgInspectNo" value="檢驗單號"/>
<jsp:setProperty name="rPH" property="pgRunCardNo" value="流程卡號"/>
<jsp:setProperty name="rPH" property="pgAmpere" value="安培數"/>
<jsp:setProperty name="rPH" property="pgSingleLot" value="單批"/>
<!-- other-->
<jsp:setProperty name="rPH" property="pgContZero" value="包含庫存為零的資料"/>


