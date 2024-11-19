<%@ page contentType="text/html; charset=utf-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name="rPH" property="pgHOME" value="回首页"/>
<jsp:setProperty name="rPH" property="pgAllRepLog" value="查询所有维修案件"/>
<jsp:setProperty name="rPH" property="pgTxLog" value="维修件异动记录"/>
<jsp:setProperty name="rPH" property="pgAddWKF" value="新增流程"/>
<jsp:setProperty name="rPH" property="pgRemark" value="附注"/>
<jsp:setProperty name="rPH" property="pgFormID" value="流程表单识别"/>
<jsp:setProperty name="rPH" property="pgWKFTypeNo" value="流程种类编号"/>
<jsp:setProperty name="rPH" property="pgOriStat" value="原始状态"/>
<jsp:setProperty name="rPH" property="pgAction" value="执行动作"/>
<jsp:setProperty name="rPH" property="pgChgStat" value="变动后状态"/>
<jsp:setProperty name="rPH" property="pgWKFDESC" value="流程说明"/>

<!--以下为页面按钮 -->
<jsp:setProperty name="rPH" property="pgSelectAll" value="选择全部"/>
<jsp:setProperty name="rPH" property="pgCancelSelect" value="取消选择"/>
<jsp:setProperty name="rPH" property="pgPlsEnter" value="请输入"/>
<jsp:setProperty name="rPH" property="pgDelete" value="删除"/>
<jsp:setProperty name="rPH" property="pgSave" value="存盘"/>
<jsp:setProperty name="rPH" property="pgAdd" value="新增"/>
<jsp:setProperty name="rPH" property="pgOK" value="确定"/>
<jsp:setProperty name="rPH" property="pgFetch" value="带入"/>
<jsp:setProperty name="rPH" property="pgQuery" value="查询"/>
<jsp:setProperty name="rPH" property="pgSearch" value="搜寻"/>
<jsp:setProperty name="rPH" property="pgExecute" value="执行"/>
<jsp:setProperty name="rPH" property="pgReset" value="重置"/>

<!--清单页面之相关讯息-->
<jsp:setProperty name="rPH" property="pgPage" value="页"/>
<jsp:setProperty name="rPH" property="pgPages" value="页"/>
<jsp:setProperty name="rPH" property="pgFirst" value="第一"/>
<jsp:setProperty name="rPH" property="pgLast" value="最后一"/>
<jsp:setProperty name="rPH" property="pgPrevious" value="上一"/>
<jsp:setProperty name="rPH" property="pgNext" value="下一"/>
<jsp:setProperty name="rPH" property="pgTheNo" value="第"/>
<jsp:setProperty name="rPH" property="pgTotal" value="总共"/>
<jsp:setProperty name="rPH" property="pgRecord" value="笔记录"/>
<jsp:setProperty name="rPH" property="pgRPProcess" value="维修案件处理"/>
<jsp:setProperty name="rPH" property="pgAllRecords" value="所有记录"/>
<jsp:setProperty name="rPH" property="pgCode" value="代码"/>


<!--以下为维修案件表头 -->
<jsp:setProperty name="rPH" property="pgRepTitle" value="产品功能维修单"/>
<jsp:setProperty name="rPH" property="pgRepNote" value="为必填字段,请务必填入相关资料"/>
<jsp:setProperty name="rPH" property="pgRepCenter" value="维修点"/>
<jsp:setProperty name="rPH" property="pgAgent" value="经销/代理商"/>
<jsp:setProperty name="rPH" property="pgRecDate" value="收件日期"/>
<jsp:setProperty name="rPH" property="pgRecCenter" value="收件单位"/>
<jsp:setProperty name="rPH" property="pgRecPerson" value="收件人"/>
<jsp:setProperty name="rPH" property="pgCustomer" value="顾客姓名"/>
<jsp:setProperty name="rPH" property="pgTEL" value="联络电话"/>
<jsp:setProperty name="rPH" property="pgCell" value="行动电话"/>
<jsp:setProperty name="rPH" property="pgAddr" value="地址"/>
<jsp:setProperty name="rPH" property="pgZIP" value="邮政编码"/>
<jsp:setProperty name="rPH" property="pgBuyingPlace" value="购买地点"/>
<jsp:setProperty name="rPH" property="pgBuyingDate" value="购买日期"/>
<jsp:setProperty name="rPH" property="pgSvrDocNo" value="服务单号"/>
<jsp:setProperty name="rPH" property="pgPart" value="料号"/>
<jsp:setProperty name="rPH" property="pgPartDesc" value="规格说明"/>
<jsp:setProperty name="rPH" property="pgModel" value="产品型号"/>
<jsp:setProperty name="rPH" property="pgColor" value="手机颜色"/>
<jsp:setProperty name="rPH" property="pgIMEI" value="IMEI序号"/>
<jsp:setProperty name="rPH" property="pgDSN" value="产品序号"/>
<jsp:setProperty name="rPH" property="pgRecItem" value="收件项目"/>
<jsp:setProperty name="rPH" property="pgJam" value="故障描述"/>
<jsp:setProperty name="rPH" property="pgOtherJam" value="其它故障描述"/>
<jsp:setProperty name="rPH" property="pgFreq" value="故障频率"/>
<jsp:setProperty name="rPH" property="pgWarranty" value="保固类别"/>
<jsp:setProperty name="rPH" property="pgValid" value="保内"/>
<jsp:setProperty name="rPH" property="pgInvalid" value="保外"/>
<jsp:setProperty name="rPH" property="pgWarrNo" value="保固卡号"/>
<jsp:setProperty name="rPH" property="pgSvrType" value="服务类型"/>
<jsp:setProperty name="rPH" property="pgRepStatus" value="状态"/>
<jsp:setProperty name="rPH" property="pgRepNo" value="案件编号"/>
<jsp:setProperty name="rPH" property="pgRecItem2" value="后送维修收件项目"/>
<jsp:setProperty name="rPH" property="pgWarranty2" value="判定后保固类别"/>
<jsp:setProperty name="rPH" property="pgRepLvl" value="维修等级"/>
<jsp:setProperty name="rPH" property="pgRepHistory" value="维修历史记录"/>
<jsp:setProperty name="rPH" property="pgDOAPVerify" value="DOA/DAP判定结果明细"/>
<jsp:setProperty name="rPH" property="pgPreRPAct" value="预计维修方式"/>
<jsp:setProperty name="rPH" property="pgActualRPAct" value="实际维修方式"/>
<jsp:setProperty name="rPH" property="pgSoftwareVer" value="软件版本"/>
<jsp:setProperty name="rPH" property="pgChgIMEI" value="更换之IMEI"/>
<jsp:setProperty name="rPH" property="pgActualRPDesc" value="实际维修描述"/>
<jsp:setProperty name="rPH" property="pgPreUseMaterial" value="预计维修耗料"/>
<jsp:setProperty name="rPH" property="pgUseMaterial" value="维修耗料"/>
<jsp:setProperty name="rPH" property="pgRPReason" value="维修项目或分析说明"/>
<jsp:setProperty name="rPH" property="pgRPCost" value="维修费用"/>
<jsp:setProperty name="rPH" property="pgPartCost" value="材料费用"/>
<jsp:setProperty name="rPH" property="pgTransCost" value="运费"/>
<jsp:setProperty name="rPH" property="pgOtherCost" value="其它费用"/>
<jsp:setProperty name="rPH" property="pgExecutor" value="动作执行者"/>
<jsp:setProperty name="rPH" property="pgExeTime" value="执行时间"/>
<jsp:setProperty name="rPH" property="pgAssignTo" value="指派人员"/>
<jsp:setProperty name="rPH" property="pgRepPerson" value="维修人员"/>
<jsp:setProperty name="rPH" property="pgTransferTo" value="欲转移之维修点"/>
<jsp:setProperty name="rPH" property="pgMailNotice" value="e-Mail通知"/>
<jsp:setProperty name="rPH" property="pgWorkTime" value="平均工时"/>
<jsp:setProperty name="rPH" property="pgWorkTimeMsg" value="单位/小时"/>
<jsp:setProperty name="rPH" property="pgLotNo" value="批号"/>
<jsp:setProperty name="rPH" property="pgSymptom" value="故障症状"/>
<jsp:setProperty name="rPH" property="pgRecType" value="收件来源型态"/>
<jsp:setProperty name="rPH" property="pgPCBA" value="机板"/>
<jsp:setProperty name="rPH" property="pgRepeatRepInput" value="重复交期询问输入页面"/>
<jsp:setProperty name="rPH" property="pgWarrLimit" value="保固期限"/>

<!--以下为维修处理中案件表头 -->
<jsp:setProperty name="rPH" property="pgAddMaterial" value="选取维修料件"/>
<jsp:setProperty name="rPH" property="pgSituation" value="机况确认项目"/>
<jsp:setProperty name="rPH" property="pgSituationMsg" value="若要进行报价才需选填"/>

<!--关于子窗口的信息-->
<jsp:setProperty name="rPH" property="pgRelevantInfo" value="相关信息"/>
<jsp:setProperty name="rPH" property="pgEnterCustIMEI" value="请输入客户姓名或IMEI序号"/>
<jsp:setProperty name="rPH" property="pgSearchByAgency" value="依经销商/代理商查询"/>
<jsp:setProperty name="rPH" property="pgSearchByCustIMEI" value="依客户/IMEI查询"/>
<jsp:setProperty name="rPH" property="pgEnterAgency" value="请输入经销商/代理商名称"/>
<jsp:setProperty name="rPH" property="pgInputPart" value="切换到料号输入"/>
<jsp:setProperty name="rPH" property="pgChoosePart" value="切换到料号选取"/>
<jsp:setProperty name="rPH" property="pgQty" value="数量"/>

<!--JavaScript中之警告文句-->
<jsp:setProperty name="rPH" property="pgAlertAction" value="请先选择您欲执行之动作后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertModel" value="请先选择MODEL后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrDocNo" value="请先填入服务单号后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertCustomer" value="请先填入销售客户后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrType" value="请先选填订单类型后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertJam" value="请先选故障描述后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertIMEI" value="请输入该手机之IMEI序号!!"/>
<jsp:setProperty name="rPH" property="pgAlertCancel" value="确定您要CANCEL??"/>
<jsp:setProperty name="rPH" property="pgAlertAssign" value="请先选择您欲指派之生产地后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSubmit" value="请先选择您欲执行之动作后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRepLvl" value="请先填入维修等级!!"/>
<jsp:setProperty name="rPH" property="pgAlertLvl3" value="您所决定的维修等级为3级,请进行后送(TRANSMIT)作业!!"/>
<jsp:setProperty name="rPH" property="pgAlertNonLvl3" value="您所决定的维修等级不为3级,不需进行后送(TRANSMIT)作业!!"/>
<jsp:setProperty name="rPH" property="pgAlertReassign" value="请先输入重新指派原因于说明拦再进行重新指派(REASSIGN)!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransfer" value="请先选定欲转移之维修点后再进行转移(TRANSFER)!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecItem2" value="请一定要点选输入后送维修收件项目!!"/>
<jsp:setProperty name="rPH" property="pgAlertSoftVer" value="依据您所选取的维修方式，请先填入软件版本后再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertChgIMEI" value="依据您所选取的维修方式，请先填入更改之IMEI后再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertWorkTime" value="请输入您实际完成的工时数(单位以小时计)"/>
<jsp:setProperty name="rPH" property="pgAlertRPMaterial" value="对应您所选取的维修方式,请先选取维修料件后再SubmitI!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPReason" value="请务必选择重派/批退代码并设定(Set)后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPAction" value="请务必选取实际维修方式后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSymptom" value="请务必选取故障特征后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertQty" value="请先填入您实际收件之数量后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemNo" value="请先填入BPCS之真实料号后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgErrorQty" value="请先修改数量后再存盘,Handset或PCB一单只能1个!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecType" value="请先选取适当之收件来源型态后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertDOAPIMEI" value="因为您所选取的服务类型为DOA/DAP,故请先填入更换之IMEI!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgSvrType" value="确定要更改服务类型?"/>
<jsp:setProperty name="rPH" property="pgAlertPcba" value="请先填入机板之真实料号后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertMOGenSubmit" value="确定您要生成订单吗??"/>
<jsp:setProperty name="rPH" property="pgAlertPriceList" value="请先选择客户价格表后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipAddress" value="请先选择出货地址后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertBillAddress" value="请先选择立帐地址后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertPayTerm" value="请先选择付款条件后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertFOB" value="请先选择FOB后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipMethod" value="请先选择出货方式后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertCheckLineFlag" value="请先选取其中一笔项目后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertCreateDRQ" value="                   确认产生交期询问单?\n 如欲存成草稿文件,请选择TEMPORARY再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertReProcessMsg" value="是否继续处理本单据??"/>
<jsp:setProperty name="rPH" property="pgAlertShipBillMsg" value="                    请检查该客户之出货/立帐地信息!!\n 系统找不到您设定为 {主要} 出货/立帐地内容,您需于此处重新给定.\n                    否则易导致生成订单的错误!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemOrgAssignMsg" value="                 单据清单内含未指定之组织品号!!\n 请注意黄色项目品号或洽相关人员设定品号组织指派!!\n                (相对于选择订单类型)"/>
<jsp:setProperty name="rPH" property="pgAlertItemExistsMsg" value="                 订单生成清单内含不存在于Oracle系统的品号 \n    请洽相关人员确认品号已建立!!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateMsg" value="               业务交期询问单新增失败!!,\n 请洽询信息部查明原因,或选择不重复输入询问单选项!!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateDtlMsg" value="          此业务交期询问单无明细项!!,\n 请洽系统管理员,或选择不重复输入询问单选项查明原因!!"/>
<jsp:setProperty name="rPH" property="pgAlertInvCustDiffMOCust" value="发票客户与销售订单客户不同\n          请重新输入!!"/>
<jsp:setProperty name="rPH" property="pgAlertNotExistsMO" value="不存在此销售订单号\n      请重新输入!!"/>
<jsp:setProperty name="rPH" property="pgAlertDateSet" value="设定日期不得小于今日\n      请重新输入!!"/>
<jsp:setProperty name="rPH" property="pgAlertCfmRjtMsg" value="                  本次处理内容明细含被批退之项目!!\n 请先个别处理需ABORT项目后,方能进行其余正常单据客户确认!!\n"/>
<jsp:setProperty name="rPH" property="pgAlertRejectMsg" value="请务必输入批退原因说明后再Submit!!"/>
 <jsp:setProperty name="rPH" property="pgAlertSampleCheckMsg" value="       先前已选定之样品订单设定,已依其SPQ/MOQ原则限制订单输入品项数量!!\n                           如欲重新设定,请删除所有品项再行变更!!"/>

<!--submit后之提示句-->
<jsp:setProperty name="rPH" property="pgFreqReturn" value="返修次数"/>
<jsp:setProperty name="rPH" property="pgFreqReject" value="退修次数"/>

<!--页面切换超级链接-->
<jsp:setProperty name="rPH" property="pgPageAddRMA" value="新增维修收件记录"/>
<jsp:setProperty name="rPH" property="pgPage3AddRMA" value="新增三级维修收件记录"/>
<jsp:setProperty name="rPH" property="pgPageAssign" value="派工中维修案件"/>
<jsp:setProperty name="rPH" property="pgPage3Assign" value="三级派工中维修案件"/>

<!--Send Mail 之内容-->
<jsp:setProperty name="rPH" property="pgMailSubjectAssign" value="来自维修系统的指派"/>

<!--回件签收单之内容-->
<jsp:setProperty name="rPH" property="pgCustReceipt" value="维修品回件签收单"/>
<jsp:setProperty name="rPH" property="pgTransList" value="后送维修品清单"/>
<jsp:setProperty name="rPH" property="pgTransDate" value="后送日期"/>
<jsp:setProperty name="rPH" property="pgListNo" value="清单编号(批号)"/>
<jsp:setProperty name="rPH" property="pgReceiptNo" value="签收单号"/>
<jsp:setProperty name="rPH" property="pgShipDate" value="出货日期"/>
<jsp:setProperty name="rPH" property="pgShipper" value="经办人"/>
<jsp:setProperty name="rPH" property="pgCustSign" value="客户签收"/>
<jsp:setProperty name="rPH" property="pgPSMessage1" value="请于收到维修品确认无误后,在客户签收处签名回传;传真至"/>
<jsp:setProperty name="rPH" property="pgPSMessage2" value="如有任何问题请与我联络。联络电话"/>
<jsp:setProperty name="rPH" property="pgWarnMessage" value="本公司以寄件日为准,3日内未回传视同已收到;如有争议请各单位自行负责"/>

<!--入库签收单之内容-->
<jsp:setProperty name="rPH" property="pgInStockLotList" value="DOA/DAP工厂维修件入库单"/>
<jsp:setProperty name="rPH" property="pgInStockNo" value="入库单号"/>
<jsp:setProperty name="rPH" property="pgInStockDate" value="入库日期"/>
<jsp:setProperty name="rPH" property="pgInStocker" value="入库人员"/>
<jsp:setProperty name="rPH" property="pgWarehouserSign" value="仓库人员签收"/>

<!--维修流程处理后讯息画面-->
<jsp:setProperty name="rPH" property="pgPrintCustReceipt" value="打印维修品回件签收单"/>
<jsp:setProperty name="rPH" property="pgPrintShippedConfirm" value="打印RMA出货确认单"/>
<jsp:setProperty name="rPH" property="pgRepairProcess" value="一般维修处理流程"/>
<jsp:setProperty name="rPH" property="pgDOAProcess" value="DOA处理流程"/>
<jsp:setProperty name="rPH" property="pgDAPProcess" value="DAP处理流程"/>

<!--领料申请单-->
<jsp:setProperty name="rPH" property="pgMaterialRequest" value="领料申请单"/>
<jsp:setProperty name="rPH" property="pgTransType" value="异动类型"/>
<jsp:setProperty name="rPH" property="pgConReg" value="国别/地区"/>
<jsp:setProperty name="rPH" property="pgDocNo" value="单据编号"/>
<jsp:setProperty name="rPH" property="pgWarehouseNo" value="仓别"/>
<jsp:setProperty name="rPH" property="pgLocation" value="储位"/>
<jsp:setProperty name="rPH" property="pgPersonal" value="个人/人员"/>
<jsp:setProperty name="rPH" property="pgInvTransInput" value="库存异动输入"/>
<jsp:setProperty name="rPH" property="pgInvTransQuery" value="库存异动查询"/>

<jsp:setProperty name="rPH" property="pgAllMRLog" value="查询所有领料案件"/>
<jsp:setProperty name="rPH" property="pgAlertMRReason" value="请选择领料原因"/>
<jsp:setProperty name="rPH" property="pgAlertMRChoose" value="请先选择您欲申请的料件后再存盘"/>
<jsp:setProperty name="rPH" property="pgApDate" value="申请日期"/>
<jsp:setProperty name="rPH" property="pgApplicant" value="申请人"/>
<jsp:setProperty name="rPH" property="pgMRReason" value="领料原因"/>
<jsp:setProperty name="rPH" property="pgInvMagProcess" value="库存管理作业"/>
<jsp:setProperty name="rPH" property="pgMRProcess" value="领料案件处理"/>
<jsp:setProperty name="rPH" property="pgApplyPart" value="申请料件"/>
<jsp:setProperty name="rPH" property="pgReceivePart" value="实领料件"/>
<jsp:setProperty name="rPH" property="pgMRDesc" value="料号说明"/>
<jsp:setProperty name="rPH" property="pgProvdTime" value="发料时间"/>

<jsp:setProperty name="rPH" property="pgMRR" value="料件退回申请单"/>
<jsp:setProperty name="rPH" property="pgReturnPart" value="退回料件"/>
<jsp:setProperty name="rPH" property="pgOriWhs" value="原归属仓别"/>
<jsp:setProperty name="rPH" property="pgAlertApplicant" value="请先选择申请人!"/>
<jsp:setProperty name="rPH" property="pgTransReason" value="异动原因"/>
<jsp:setProperty name="rPH" property="pgMAR" value="料件转拨申请单"/>
<jsp:setProperty name="rPH" property="pgAllotPart" value="转拨料件"/>
<jsp:setProperty name="rPH" property="pgAllottee" value="被转拨人员"/>
<jsp:setProperty name="rPH" property="pgAlertAllottee" value="请先选择被转拨人员!"/>
<jsp:setProperty name="rPH" property="pgAlertTransReason" value="请先选择异动原因!!"/>

<!--库存异动-->
 <!--以下为DOA/DAP表头 -->
<jsp:setProperty name="rPH" property="pgVeriSvrType" value="判定服务类型"/>
<jsp:setProperty name="rPH" property="pgVerifyStandard" value="DOA/DAP判定标准"/>

 <!-- 维修件耗用料帐入BPCS(依料件明细) -->
<jsp:setProperty name="rPH" property="pgRepPostByItem" value="维修件耗用料帐入BPCS(依料件明细)"/>
<jsp:setProperty name="rPH" property="pgBPCSInvQty" value="BPCS库存量"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDate" value="发料日期"/> 
<jsp:setProperty name="rPH" property="pgIssuePerson" value="发料人员"/> 
<jsp:setProperty name="rPH" property="pgTransComment" value="异动单据"/>
<jsp:setProperty name="rPH" property="pgBalanceQty" value="结余数量"/>

<!-- 维修件耗用料帐入BPCS(依领料单号) -->
<jsp:setProperty name="rPH" property="pgRepPostByMRequest" value="维修件耗用料帐入BPCS(依领料单号)"/>
<jsp:setProperty name="rPH" property="pgCheckItem" value="选取"/>
<jsp:setProperty name="rPH" property="pgPreparePost2BPCS" value="笔资料待入帐BPCS"/>

 <!-- 维修件耗用料帐入BPCS(依维修工程师) -->
<jsp:setProperty name="rPH" property="pgRepPostByRPEngineer" value="维修件耗用料帐入BPCS(依维修工程师)"/>
<jsp:setProperty name="rPH" property="pgRepairEngineer" value="维修工程师"/> 
<jsp:setProperty name="rPH" property="pgItemQty" value="笔 料件项数"/> 
<jsp:setProperty name="rPH" property="pgMRItemQty" value="笔数"/>



<!--以下为代理商/经销商数据 -->
<jsp:setProperty name="rPH" property="pgInfo" value="基本资料"/>
<jsp:setProperty name="rPH" property="pgName" value="名称"/>
<jsp:setProperty name="rPH" property="pgNo" value="编号"/>
<jsp:setProperty name="rPH" property="pgDepend" value="隶属维修收件单位"/>
<jsp:setProperty name="rPH" property="pgContact" value="联络人"/>
<jsp:setProperty name="rPH" property="pgFAX" value="传真"/>
<jsp:setProperty name="rPH" property="pgKeyAccount" value="关键经销/代理商"/>
<jsp:setProperty name="rPH" property="pgEdit" value="编辑"/>

<!--以下為查询面資料-->
<!--維修中心每日已入帳BPCS查询-->
<jsp:setProperty name="rPH" property="pgCentPBpcsTitle" value="维修中心每日已入帐BPCS查询"/>
<jsp:setProperty name="rPH" property="pgPostDateFr" value="入帐日起"/>
<jsp:setProperty name="rPH" property="pgPostDateTo" value="入帐日迄"/>
<jsp:setProperty name="rPH" property="pgPostDate" value="入帐日期"/>
<jsp:setProperty name="rPH" property="pgBelPerson" value="归属人员"/>
<jsp:setProperty name="rPH" property="pgTransTime" value="异动时间"/>
<jsp:setProperty name="rPH" property="pgExecPerson" value="执行人员"/>
<jsp:setProperty name="rPH" property="pgBPCSSerial" value="BPCS序号"/>
<!--维修机种月份耗料及成本查询-->
<jsp:setProperty name="rPH" property="pgModelConsumeTitle" value="维修机种月份耗料及成本查询"/>
<jsp:setProperty name="rPH" property="pgRpPartsCostTable" value="维修耗用料件成本价格表"/>
<jsp:setProperty name="rPH" property="pgAnItem" value="项次"/>
<jsp:setProperty name="rPH" property="pgPartsConsumQty" value="料件耗用量"/>
<jsp:setProperty name="rPH" property="pgCostPrice" value="成本价格"/>
<jsp:setProperty name="rPH" property="pgAccPartsPrice" value="料件价格小计"/>
<jsp:setProperty name="rPH" property="pgGTotal" value="总计"/>
<jsp:setProperty name="rPH" property="pgCostMainten" value="维修件维修费用表"/>
<jsp:setProperty name="rPH" property="pgRPQuantity" value="维修件数"/>
<jsp:setProperty name="rPH" property="pgStdServiceFee" value="标准维修费/小时"/>
<jsp:setProperty name="rPH" property="pgActServiceFee" value="实际维修费/小时"/>
<jsp:setProperty name="rPH" property="pgModelFeeSubTotal" value="机种费用小计"/>
 <!--月份故障原因分佈查询-->
<jsp:setProperty name="rPH" property="pgMonthFaultReasonTitle" value="月份故障原因分布查询"/>
<jsp:setProperty name="rPH" property="pgRate" value="比率"/>

 <!--维修领料单每日入帐BPCS对帐查询-->
<jsp:setProperty name="rPH" property="pgMaterialReqBPCSTitle" value="维修领料单每日入帐BPCS对帐查询"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDateFr" value="发料日期 起"/> 
<jsp:setProperty name="rPH" property="pgIssuePartsDateTo" value="发料日期 迄"/>
<jsp:setProperty name="rPH" property="pgMatRequestForm" value="领料单号"/>
<jsp:setProperty name="rPH" property="pgRepairNo" value="维修单号"/>
<jsp:setProperty name="rPH" property="pgDetail" value="明细"/>
<jsp:setProperty name="rPH" property="pgBPCSNo" value="BPCS单号"/>
<jsp:setProperty name="rPH" property="pgBPCSDetail" value="BPCS明细"/>

<!--维修工程师领料/仓管发料记录查询-->
<jsp:setProperty name="rPH" property="pgMaterialReqIssTitle" value="维修工程师领料/仓管发料纪录查询"/>

 <!--领料申请单打印-->
<jsp:setProperty name="rPH" property="pgMReqInquiryLink" value="至领料纪录查询页"/>
<jsp:setProperty name="rPH" property="pgYear" value="年"/>
<jsp:setProperty name="rPH" property="pgMonth" value="月"/>
<jsp:setProperty name="rPH" property="pgDay" value="日"/>
<jsp:setProperty name="rPH" property="pgS17DOAP" value="S17客户新品不良换货"/>
<jsp:setProperty name="rPH" property="pgS11MaterialReq" value="S11不良新品领料"/>
<jsp:setProperty name="rPH" property="pgS18WarrIn" value="S18保内维修领料"/>
<jsp:setProperty name="rPH" property="pgS19WarrOut" value="S19保外维修领料"/>
<jsp:setProperty name="rPH" property="pgEmpNo" value="员工编号"/>
<jsp:setProperty name="rPH" property="pgDeptNo" value="部门名称"/>
<jsp:setProperty name="rPH" property="pgAppDesc" value="申请说明"/>
<jsp:setProperty name="rPH" property="pgItemDesc" value="品名"/>
<jsp:setProperty name="rPH" property="pgItemColor" value="颜色"/>
<jsp:setProperty name="rPH" property="pgAppQty" value="申请数量"/>
<jsp:setProperty name="rPH" property="pgActQty" value="实际数量"/>
<jsp:setProperty name="rPH" property="pgApproval" value="核准"/>
<jsp:setProperty name="rPH" property="pgChief" value="主管"/>
<jsp:setProperty name="rPH" property="pgTreasurer" value="会计"/>
<jsp:setProperty name="rPH" property="pgPrintDate" value="打印日期"/>

 <!-- 手机生产信息查询-->
<jsp:setProperty name="rPH" property="pgIssDelivery" value="外包已交/未交"/>
<jsp:setProperty name="rPH" property="pgProdDateFr" value="生产日期起"/>
<jsp:setProperty name="rPH" property="pgProdDateTo" value="生产日期迄"/>
<jsp:setProperty name="rPH" property="pgSearchStr" value="IMEI、DSN、成品料号、箱号"/>
<jsp:setProperty name="rPH" property="pgMESSOrderNo" value="生产工单号"/>
<jsp:setProperty name="rPH" property="pgProdItemNo" value="成品料号"/>
<jsp:setProperty name="rPH" property="pgMobileSoftware" value="手机软件版本"/>
<jsp:setProperty name="rPH" property="pgLineName" value="产线名称"/>
<jsp:setProperty name="rPH" property="pgStationName" value="站别名称"/>
<jsp:setProperty name="rPH" property="pgSOrderIn" value="工单投产日期"/>
<jsp:setProperty name="rPH" property="pgPackingDTime" value="包装日期时间"/>
<jsp:setProperty name="rPH" property="pgOperator" value="包装员"/>
<jsp:setProperty name="rPH" property="pgPMCC" value="PMCC码"/>
<jsp:setProperty name="rPH" property="pgWorkOrder" value="工单"/>
<jsp:setProperty name="rPH" property="pgTestBay" value="生产测试站"/>
<jsp:setProperty name="rPH" property="pgCartonNo" value="包装箱号"/>
<jsp:setProperty name="rPH" property="pgProductDetail" value="单据历程"/>

 <!-- 经销商每日上传资料结转查询-->
<jsp:setProperty name="rPH" property="pgAgentUpfileInf" value="经销商每日上传资料结转查询"/>
<jsp:setProperty name="rPH" property="pgDateFr" value="日期 起"/> 
<jsp:setProperty name="rPH" property="pgDateTo" value="日期 迄"/>
<jsp:setProperty name="rPH" property="pgAgentNo" value="经销商编号"/>
<jsp:setProperty name="rPH" property="pgTransmitFlag" value="后送与否"/>
<jsp:setProperty name="rPH" property="pgChgIMEIFlag" value="更换IMEI否"/> 

 <!-- 维修案件资料查询 -->
<jsp:setProperty name="rPH" property="pgRepairCaseInf" value="维修案件资料查询"/>
<jsp:setProperty name="rPH" property="pgTransOption" value="后送/维修点转移"/>
<jsp:setProperty name="rPH" property="pgRetTimes" value="覆修次数"/>
<jsp:setProperty name="rPH" property="pgFinishStatus" value="完修状态"/>
<jsp:setProperty name="rPH" property="pgExcelButton" value="Excel"/>
<jsp:setProperty name="rPH" property="pgRecTime" value="收件时间"/>
<jsp:setProperty name="rPH" property="pgFinishDate" value="完修日期"/>
<jsp:setProperty name="rPH" property="pgFinishTime" value="完修时间"/>
<jsp:setProperty name="rPH" property="pgRepMethod" value="维修方式"/>
<jsp:setProperty name="rPH" property="pgLastMDate" value="最后处理日期"/>
<jsp:setProperty name="rPH" property="pgLastMPerson" value="最后处理人员"/>
<jsp:setProperty name="rPH" property="pgRepPercent" value="维修件比率"/>
<jsp:setProperty name="rPH" property="pgNotFoundMsg" value="目前数据库查无符合查询条件的资料"/>

<jsp:setProperty name="rPH" property="pgServiceLog" value="服务"/>
<jsp:setProperty name="rPH" property="pgReturnLog" value="客退"/>
<jsp:setProperty name="rPH" property="pgMobileRepair" value="手机维修"/>
<jsp:setProperty name="rPH" property="pgCType" value="类型"/>
<jsp:setProperty name="rPH" property="pgShipType" value="出货"/> 

<!--以下为首页及人员管理资料 -->
<jsp:setProperty name="rPH" property="pgMenuInstruction" value="维修系统说明文件"/>
<jsp:setProperty name="rPH" property="pgDownload" value="下载专区"/>
<jsp:setProperty name="rPH" property="pgMenuGroup" value="技术交流园地"/>
<jsp:setProperty name="rPH" property="pgChgPwd" value="修改密码"/>
<jsp:setProperty name="rPH" property="pgBulletin" value="留言板"/>
<jsp:setProperty name="rPH" property="pgLogin" value="登入"/>
<jsp:setProperty name="rPH" property="pgLogout" value="注销"/>
<jsp:setProperty name="rPH" property="pgMsgLicence" value="大霸电子股份有限公司版权所有"/>
<jsp:setProperty name="rPH" property="pgRole" value="角色"/>
<jsp:setProperty name="rPH" property="pgList" value="清单"/>
<jsp:setProperty name="rPH" property="pgNew" value="新增"/>
<jsp:setProperty name="rPH" property="pgRevise" value="修改"/>
<jsp:setProperty name="rPH" property="pgDesc" value="说明"/>
<jsp:setProperty name="rPH" property="pgSuccess" value="完成"/>
<jsp:setProperty name="rPH" property="pgAccount" value="人员"/>
<jsp:setProperty name="rPH" property="pgAccountWeb" value="人员WEB识别码"/>
<jsp:setProperty name="rPH" property="pgMail" value="电子邮件"/>
<jsp:setProperty name="rPH" property="pgProfile" value="基本设定"/>
<jsp:setProperty name="rPH" property="pgPasswd" value="密码"/>
<jsp:setProperty name="rPH" property="pgLocale" value="国别"/>
<jsp:setProperty name="rPH" property="pgLanguage" value="语系"/>
<jsp:setProperty name="rPH" property="pgModule" value="模块"/>
<jsp:setProperty name="rPH" property="pgSeq" value="排序号"/>
<jsp:setProperty name="rPH" property="pgFunction" value="功能"/>
<jsp:setProperty name="rPH" property="pgHref" value="连结地址"/>
<jsp:setProperty name="rPH" property="pgAuthoriz" value="授权"/>
<jsp:setProperty name="rPH" property="pgEmpID" value="工号"/>
<jsp:setProperty name="rPH" property="pgRepReceive" value="维修收件"/>
<jsp:setProperty name="rPH" property="pgBasicInf" value="基本资料"/>
<jsp:setProperty name="rPH" property="pgFLName" value="姓名"/>
<jsp:setProperty name="rPH" property="pgID" value="帐号"/>


<!--以下为留言版及讨论区等资料 -->
<jsp:setProperty name="rPH" property="pgBulletinNotice" value="公告/留言"/>
<jsp:setProperty name="rPH" property="pgPublishDate" value="发表日期"/>
<jsp:setProperty name="rPH" property="pgPublisher" value="发表人"/>
<jsp:setProperty name="rPH" property="pgPublish" value="我要留言"/>
<jsp:setProperty name="rPH" property="pgTopic" value="主题"/>
<jsp:setProperty name="rPH" property="pgContent" value="内容"/>
<jsp:setProperty name="rPH" property="pgClassOfTopic" value="主题类别"/>
<jsp:setProperty name="rPH" property="pgTopicOfDiscuss" value="讨论主题"/>
<jsp:setProperty name="rPH" property="pgHits" value="响应次数"/>
<jsp:setProperty name="rPH" property="pgNewTopic" value="发表新主题"/>
<jsp:setProperty name="rPH" property="pgClass" value="类别"/>
<jsp:setProperty name="rPH" property="pgResponse" value="回复"/>
<jsp:setProperty name="rPH" property="pgReturn" value="返回"/>
<jsp:setProperty name="rPH" property="pgRespond" value="响应"/>
<jsp:setProperty name="rPH" property="pgNewDiscuss" value="发表新的讨论主题"/>
<jsp:setProperty name="rPH" property="pgUserResponse" value="响应内容"/>
<jsp:setProperty name="rPH" property="pgTime" value="时间"/>
<jsp:setProperty name="rPH" property="pgResponder" value="响应者"/>
<jsp:setProperty name="rPH" property="pgInformation" value="信息"/>
<jsp:setProperty name="rPH" property="pgDocument" value="文件"/>


<!--以下为售服物料功能资料 -->
<jsp:setProperty name="rPH" property="pgASMaterial" value="物料"/>
<jsp:setProperty name="rPH" property="pgUpload" value="上载"/>
<jsp:setProperty name="rPH" property="pgFile" value="档案"/>
<jsp:setProperty name="rPH" property="pgCenter" value="中心"/>
<jsp:setProperty name="rPH" property="pgFormat" value="格式"/>
<jsp:setProperty name="rPH" property="pgFollow" value="请遵循"/>
<jsp:setProperty name="rPH" property="pgBelow" value="如下"/>
<jsp:setProperty name="rPH" property="pgAbove" value="如上"/>
<jsp:setProperty name="rPH" property="pgPreview" value="浏览"/>
<jsp:setProperty name="rPH" property="pgLevel" value="等级"/>
<jsp:setProperty name="rPH" property="pgLaunch" value="激活"/>
<jsp:setProperty name="rPH" property="pgSparePart" value="零件"/>
<jsp:setProperty name="rPH" property="pgModelSeries" value="机种"/>
<jsp:setProperty name="rPH" property="pgPicture" value="图形"/>
<jsp:setProperty name="rPH" property="pgImage" value="影像"/>
<jsp:setProperty name="rPH" property="pgInventory" value="库存"/>
<jsp:setProperty name="rPH" property="pgCalculate" value="计算"/>
<jsp:setProperty name="rPH" property="pgPrice" value="价格"/>
<jsp:setProperty name="rPH" property="pgConsumer" value="消费者"/>
<jsp:setProperty name="rPH" property="pgRetailer" value="店面"/>
<jsp:setProperty name="rPH" property="pgASMAuthFailMsg" value="抱歉!您无权限查询此资料"/>
<jsp:setProperty name="rPH" property="pgASMInfo" value="售后服务物料信息"/>
<jsp:setProperty name="rPH" property="pgMOQ" value="最小订购数量"/>
<jsp:setProperty name="rPH" property="pgSafeInv" value="安全库存数"/>
<jsp:setProperty name="rPH" property="pgCurrInv" value="目前库存数"/>
<jsp:setProperty name="rPH" property="pgFront" value="正面"/>
<jsp:setProperty name="rPH" property="pgBack" value="背面"/>
<jsp:setProperty name="rPH" property="pgAllASM" value="查询所有售服物料"/>
<jsp:setProperty name="rPH" property="pgChooseMdl" value="选取机种"/>
<jsp:setProperty name="rPH" property="pgASM_EC" value="售服物料EC"/>
<jsp:setProperty name="rPH" property="pgChange" value="变更"/>
<jsp:setProperty name="rPH" property="pgNewPart4EC" value="欲变更之新料号"/>
<jsp:setProperty name="rPH" property="pgCurrModelRef" value="现行适用机种"/>
<jsp:setProperty name="rPH" property="pgModelRefMsg" value="勾选之项目是做为料号变更欲一并更换之适用的机种"/>
<jsp:setProperty name="rPH" property="pgDelImage" value="删除图档"/>

 <!--以下为作业管理功能资料 -->
<jsp:setProperty name="rPH" property="pgAfterService" value="售服"/>
<jsp:setProperty name="rPH" property="pgInput" value="输入"/>
<jsp:setProperty name="rPH" property="pgMaintenance" value="维护"/>
<jsp:setProperty name="rPH" property="pgRefresh" value="更新"/>
<jsp:setProperty name="rPH" property="pgChinese" value="中文"/>
<jsp:setProperty name="rPH" property="pgDescription" value="说明"/>
<jsp:setProperty name="rPH" property="pgType" value="型态"/>
<jsp:setProperty name="rPH" property="pgDefinition" value="定义"/>
 
<jsp:setProperty name="rPH" property="pgASModelMainten" value="售服机种内外部型号维护"/>
<jsp:setProperty name="rPH" property="pgSalesModel" value="外部型号"/>
<jsp:setProperty name="rPH" property="pgLaunchDate" value="上市日期"/>
<jsp:setProperty name="rPH" property="pgDisannulDate" value="失效日期"/>
<jsp:setProperty name="rPH" property="pgProjHoldDate" value="有效日期"/>
<jsp:setProperty name="rPH" property="pgASCodeEntry" value="售服代码维护"/>
<jsp:setProperty name="rPH" property="pgRegion" value="区域"/>
<jsp:setProperty name="rPH" property="pgCodeClass" value="代码类别"/>

<jsp:setProperty name="rPH" property="pgASItemInput" value="售服料件输入"/>
<jsp:setProperty name="rPH" property="pgPartChDesc" value="料件中文说明"/>
<jsp:setProperty name="rPH" property="pgEnable" value="启用"/>
<jsp:setProperty name="rPH" property="pgDisable" value="停用"/>
<jsp:setProperty name="rPH" property="pgModelRef" value="适用机型"/>
<jsp:setProperty name="rPH" property="pgItemLoc" value="料件位置"/>

<jsp:setProperty name="rPH" property="pgASFaultSympInput" value="售服故障/特征代码输入"/>
<jsp:setProperty name="rPH" property="pgFaultCode" value="故障代码"/>
<jsp:setProperty name="rPH" property="pgSymptomCode" value="特征代码"/>
<jsp:setProperty name="rPH" property="pgCodeDesc" value="代码说明"/>
<jsp:setProperty name="rPH" property="pgCodeChDesc" value="代码中文说明"/>
<jsp:setProperty name="rPH" property="pgCUser" value="建立人员"/>
<jsp:setProperty name="rPH" property="pgCDate" value="建立日期"/>

<jsp:setProperty name="rPH" property="pgASResActInput" value="重派/批退代码选择"/>
<jsp:setProperty name="rPH" property="pgActionCode" value="维修方式代码"/>
<jsp:setProperty name="rPH" property="pgActionDesc" value="维修方式说明"/>
<jsp:setProperty name="rPH" property="pgActionChDesc" value="维修方式中文说明"/>
<jsp:setProperty name="rPH" property="pgReasonCode" value="维修原因代码"/>
<jsp:setProperty name="rPH" property="pgReasonDesc" value="批退原因说明"/>
<jsp:setProperty name="rPH" property="pgReasonChDesc" value="维修原因中文说明"/>

<jsp:setProperty name="rPH" property="pgASMLauStatusTitle" value="售服物料机种国别/启用状态"/>
<jsp:setProperty name="rPH" property="pgUpdateLaunch" value="启用更新"/>


<!--以下为程序运行状态页资料 -->
<jsp:setProperty name="rPH" property="pgProgressStsBar" value="处理中..."/>

<!--以下为报表数据 -->
<jsp:setProperty name="rPH" property="pgReport" value="报表"/>
<jsp:setProperty name="rPH" property="pgTransaction" value="异动"/>
<jsp:setProperty name="rPH" property="pgLogQty" value="登录数"/>
<jsp:setProperty name="rPH" property="pgRepair" value="维修"/>
<jsp:setProperty name="rPH" property="pgProcess" value="处理"/>
<jsp:setProperty name="rPH" property="pgNotInclude" value="不含"/>
<jsp:setProperty name="rPH" property="pgRepCompleteRate" value="完修率"/>
<jsp:setProperty name="rPH" property="pgRepaired" value="已维修"/>
<jsp:setProperty name="rPH" property="pgRepairing" value="维修处理中"/>
<jsp:setProperty name="rPH" property="pgRepGeneral" value="一般送修"/>
<jsp:setProperty name="rPH" property="pgRepLvl1" value="一级"/>
<jsp:setProperty name="rPH" property="pgRepLvl2" value="二级"/>
<jsp:setProperty name="rPH" property="pgRepLvl3" value="三级"/>
<jsp:setProperty name="rPH" property="pgRepLvl12" value="一、二级"/>
<jsp:setProperty name="rPH" property="pgNorth" value="北"/>
<jsp:setProperty name="rPH" property="pgMiddle" value="中"/>
<jsp:setProperty name="rPH" property="pgSouth" value="南"/>
<jsp:setProperty name="rPH" property="pgAll" value="全"/>
<jsp:setProperty name="rPH" property="pgArea" value="区"/>
<jsp:setProperty name="rPH" property="pgServiceCenter" value="售服部"/>
<jsp:setProperty name="rPH" property="pgSubTotal" value="小计"/>
<jsp:setProperty name="rPH" property="pgLogModelPerm" value="登录机型排名"/>
<jsp:setProperty name="rPH" property="pgPermutDetail" value="排名明细"/>
<jsp:setProperty name="rPH" property="pgModelDetail" value="机型明细"/>
<jsp:setProperty name="rPH" property="pgLvl12FinishTrendChart" value="一、二级各区完修趋势图"/>
<jsp:setProperty name="rPH" property="pgLvl3FinishTrendChart" value="三级各区完修趋势图"/>
<jsp:setProperty name="rPH" property="pgRepFinishTrendChart" value="完修趋势图"/>
<jsp:setProperty name="rPH" property="pgRepAreaSummaryReport" value="资料汇总表"/>


 <!-- 杂项词库 -->
<jsp:setProperty name="rPH" property="pgCase" value="案件"/>
<jsp:setProperty name="rPH" property="pgRecords" value="记录"/>
<jsp:setProperty name="rPH" property="pgTo" value="至"/>

<!-- WINS 原功能词库 -->
<jsp:setProperty name="pageHeader" property="pgTitleName" value="产品项目信息系统"/>
<jsp:setProperty name="pageHeader" property="pgSalesCode" value="市场型号"/>
<jsp:setProperty name="pageHeader" property="pgProjectCode" value="机种型号"/>
<jsp:setProperty name="pageHeader" property="pgProductType" value="产品类别"/>
<jsp:setProperty name="pageHeader" property="pgBrand" value="品牌"/>
<jsp:setProperty name="pageHeader" property="pgLength" value="长"/>
<jsp:setProperty name="pageHeader" property="pgWidth" value="宽"/>
<jsp:setProperty name="pageHeader" property="pgHeight" value="高"/>
<jsp:setProperty name="pageHeader" property="pgWeight" value="重量"/>

<jsp:setProperty name="pageHeader" property="pgLaunchDate" value="上市日期"/>
<jsp:setProperty name="pageHeader" property="pgDeLaunchDate" value="下市日期"/>
<jsp:setProperty name="pageHeader" property="pgSize" value="体积"/>
<jsp:setProperty name="pageHeader" property="pgDisplay" value="显示"/>
<jsp:setProperty name="pageHeader" property="pgCamera" value="相机"/>
<jsp:setProperty name="pageHeader" property="pgRingtone" value="铃声"/>
<jsp:setProperty name="pageHeader" property="pgPhonebook" value="电话簿"/>

<jsp:setProperty name="pageHeader" property="pgRemark" value="附注"/>

<!--start for common use -->
<jsp:setProperty name="pageHeader" property="pgHOME" value="回首页"/>
<jsp:setProperty name="pageHeader" property="pgSelectAll" value="选择全部"/>
<jsp:setProperty name="pageHeader" property="pgCancelSelect" value="取消选择"/>
<jsp:setProperty name="pageHeader" property="pgDelete" value="删除"/>
<jsp:setProperty name="pageHeader" property="pgSave" value="存盘"/>
<jsp:setProperty name="pageHeader" property="pgAdd" value="新增"/>
<jsp:setProperty name="pageHeader" property="pgOK" value="确定"/>
<jsp:setProperty name="pageHeader" property="pgSearch" value="搜寻"/>
<jsp:setProperty name="pageHeader" property="pgPlsEnter" value="请输入"/>
<!--end for common use -->

<!--start for page list -->
<jsp:setProperty name="pageHeader" property="pgPage" value="页"/>
<jsp:setProperty name="pageHeader" property="pgPages" value="页"/>
<jsp:setProperty name="pageHeader" property="pgFirst" value="第一"/>
<jsp:setProperty name="pageHeader" property="pgLast" value="最后一"/>
<jsp:setProperty name="pageHeader" property="pgPrevious" value="上一"/>
<jsp:setProperty name="pageHeader" property="pgNext" value="下一"/>
<jsp:setProperty name="pageHeader" property="pgTheNo" value="第"/>
<jsp:setProperty name="pageHeader" property="pgTotal" value="总共"/>
<jsp:setProperty name="pageHeader" property="pgRecord" value="笔记录"/>
<!--end for page list -->

<!--start for account management -->
<jsp:setProperty name="pageHeader" property="pgChgPwd" value="修改密码"/>
<jsp:setProperty name="pageHeader" property="pgLogin" value="登入"/>
<jsp:setProperty name="pageHeader" property="pgLogout" value="注销"/>
<jsp:setProperty name="pageHeader" property="pgMsgLicence" value="台湾半导体股份有限公司版权所有"/>
<jsp:setProperty name="pageHeader" property="pgRole" value="角色"/>
<jsp:setProperty name="pageHeader" property="pgList" value="清单"/>
<jsp:setProperty name="pageHeader" property="pgNew" value="新增"/>
<jsp:setProperty name="pageHeader" property="pgRevise" value="修改"/>
<jsp:setProperty name="pageHeader" property="pgDesc" value="说明"/>
<jsp:setProperty name="pageHeader" property="pgSuccess" value="完成"/>
<jsp:setProperty name="pageHeader" property="pgFail" value="失败"/>
<jsp:setProperty name="pageHeader" property="pgAccount" value="人员"/>
<jsp:setProperty name="pageHeader" property="pgAccountWeb" value="WEB识别码"/>
<jsp:setProperty name="pageHeader" property="pgMail" value="电子邮件"/>
<jsp:setProperty name="pageHeader" property="pgProfile" value="基本设定"/>
<jsp:setProperty name="pageHeader" property="pgPasswd" value="密码"/>
<jsp:setProperty name="pageHeader" property="pgLocale" value="国别"/>
<jsp:setProperty name="pageHeader" property="pgLanguage" value="语系"/>
<jsp:setProperty name="pageHeader" property="pgModule" value="模块"/>
<jsp:setProperty name="pageHeader" property="pgSeq" value="排序号"/>
<jsp:setProperty name="pageHeader" property="pgFunction" value="功能"/>
<jsp:setProperty name="pageHeader" property="pgHref" value="连结地址"/>
<jsp:setProperty name="pageHeader" property="pgRoot" value="根选单"/>
<jsp:setProperty name="pageHeader" property="pgAuthoriz" value="授权"/>
<jsp:setProperty name="pageHeader" property="pgID" value="帐号"/>


<!-- 交期询问单输入词库 -->
<jsp:setProperty name="rPH" property="pgSalesDRQ" value="业务交期询问单"/>
<jsp:setProperty name="rPH" property="pgQDocNo" value="询问单号"/>
<jsp:setProperty name="rPH" property="pgSalesArea" value="业务地区别"/>
<jsp:setProperty name="rPH" property="pgCustInfo" value="客户信息"/>
<jsp:setProperty name="rPH" property="pgSalesMan" value="业务人员"/>
<jsp:setProperty name="rPH" property="pgInvItem" value="型号"/>
<jsp:setProperty name="rPH" property="pgDeliveryDate" value="交货日期"/>
<jsp:setProperty name="rPH" property="pgSalesOrderNo" value="销售订单号"/>
<jsp:setProperty name="rPH" property="pgCustPONo" value="客户订购单号"/>
<jsp:setProperty name="rPH" property="pgCustPOLineNo" value="客户订单项次"/>
<jsp:setProperty name="rPH" property="pgCurr" value="币别"/>
<jsp:setProperty name="rPH" property="pgPreOrderType" value="预计订单类型"/>
<jsp:setProperty name="rPH" property="pgProcessUser" value="处理人员"/>
<jsp:setProperty name="rPH" property="pgProcessDate" value="处理日期"/>
<jsp:setProperty name="rPH" property="pgProcessTime" value="处理时间"/>
<jsp:setProperty name="rPH" property="pgDRQInputPage" value="输入页面"/>
<jsp:setProperty name="rPH" property="pgProdManufactory" value="预定生产地"/>
<jsp:setProperty name="rPH" property="pgDeptArea" value="地区"/>
<jsp:setProperty name="rPH" property="pgNoBlankMsg" value="为必填字段,请务必输入"/>
<jsp:setProperty name="rPH" property="pgRFQType" value="RFQ类型"/>

<jsp:setProperty name="rPH" property="pgTSDRQNoHistory" value="交期询问单据历程记录"/>
<jsp:setProperty name="rPH" property="pgCustNo" value="客户代号"/>
<jsp:setProperty name="rPH" property="pgCustomerName" value="客户名称"/>
<jsp:setProperty name="rPH" property="pgRequireReason" value="交期需求原因说明"/>
<jsp:setProperty name="rPH" property="pgProcessMark" value="本次处理说明"/>
<jsp:setProperty name="rPH" property="pgCreateFormUser" value="开单人员"/>
<jsp:setProperty name="rPH" property="pgCreateFormDate" value="开单日期"/>
<jsp:setProperty name="rPH" property="pgCreateFormTime" value="开单时间"/>
<jsp:setProperty name="rPH" property="pgPreProcessUser" value="前次处理人员"/>
<jsp:setProperty name="rPH" property="pgPreProcessDate" value="前次处理日期"/>
<jsp:setProperty name="rPH" property="pgPreProcessTime" value="前次处理时间"/>
<jsp:setProperty name="rPH" property="pgProdTransferTo" value="生产地移转至"/>
<jsp:setProperty name="rPH" property="pgDocTotAssignFac" value="单据所有指派生产地"/>
<jsp:setProperty name="rPH" property="pgDocAssignFac" value="本项指派生产地"/>
<jsp:setProperty name="rPH" property="pgDRQDocProcess" value="交期询问单据处理流程"/>
<jsp:setProperty name="rPH" property="pgDRQInquiryReport" value="交期询问查询及报表作业"/>
<jsp:setProperty name="rPH" property="pgSalesOrder" value="销售订单"/>
<jsp:setProperty name="rPH" property="pgFirmOrderType" value="订单类型"/>
<jsp:setProperty name="rPH" property="pgIdentityCode" value="客户识别码"/>
<jsp:setProperty name="rPH" property="pgSoldToOrg" value="销售客户"/>
<jsp:setProperty name="rPH" property="pgPriceList" value="价格表"/>
<jsp:setProperty name="rPH" property="pgShipToOrg" value="销售地"/>
<jsp:setProperty name="rPH" property="pgGenerateInf" value="产生信息"/>
<jsp:setProperty name="rPH" property="pgWait" value="等待"/>
<jsp:setProperty name="rPH" property="pgConfirm" value="确认"/>
<jsp:setProperty name="rPH" property="pgTSCAlias" value="台半"/>
<jsp:setProperty name="rPH" property="pgOrderedItem" value="品号"/>
<jsp:setProperty name="rPH" property="pgOR" value="或"/>
<jsp:setProperty name="rPH" property="pgBillTo" value="立帐地址"/>
<jsp:setProperty name="rPH" property="pgDeliverTo" value="交货地址"/>
<jsp:setProperty name="rPH" property="pgPaymentTerm" value="付款条件"/>
<jsp:setProperty name="rPH" property="pgFOB" value="FOB"/>
<jsp:setProperty name="rPH" property="pgShippingMethod" value="出货方式"/>
<jsp:setProperty name="rPH" property="pgIntExtPurchase" value="内/外购"/>
<jsp:setProperty name="rPH" property="pgPackClass" value="包装分类"/>
<jsp:setProperty name="rPH" property="pgKPC" value="千(KPC)"/>
<jsp:setProperty name="rPH" property="pgUOM" value="单位"/>
<jsp:setProperty name="rPH" property="pgNewRequestDate" value="新交期需求日"/>
<jsp:setProperty name="rPH" property="pgTempDRQDoc" value="草稿文件"/>
<jsp:setProperty name="rPH" property="pgExceedValidDate" value="客户交期确认超过企划回复4日"/>
<jsp:setProperty name="rPH" property="pgMark" value="符号"/>
<jsp:setProperty name="rPH" property="pgDenote" value="表示"/>
<jsp:setProperty name="rPH" property="pgInvalidDoc" value="本单据已失效"/>
<jsp:setProperty name="rPH" property="pgProdPC" value="工厂生管人员"/>
<jsp:setProperty name="rPH" property="pgSalesPlanner" value="销售企划人员"/>
<jsp:setProperty name="rPH" property="pgProdFactory" value="生产厂区"/>
<jsp:setProperty name="rPH" property="pgSalesPlanDept" value="销售企划区"/>
<jsp:setProperty name="rPH" property="pgReAssign" value="重新指派"/>
<jsp:setProperty name="rPH" property="pgRequestDate" value="交期需求日"/>
<jsp:setProperty name="rPH" property="pgFDeliveryDate" value="工厂交货日"/>
<jsp:setProperty name="rPH" property="pgReturnTWN" value="回T"/>
<jsp:setProperty name="rPH" property="pgCustItemNo" value="客户品号"/>
<jsp:setProperty name="rPH" property="pgPCAssignDate" value="企划分派日期"/>
<jsp:setProperty name="rPH" property="pgFTArrangeDate" value="工厂排定交货日"/>
<jsp:setProperty name="rPH" property="pgFTConfirmDate" value="工厂确认交货日"/>
<jsp:setProperty name="rPH" property="pgPCConfirmDate" value="企划确认交货日"/>
<jsp:setProperty name="rPH" property="pgOrdCreateDate" value="订单生成日期"/>
<jsp:setProperty name="rPH" property="pgAlertSysNotAllowGen" value="系统不允许生成"/>
<jsp:setProperty name="rPH" property="pgReject" value="批退"/>
<jsp:setProperty name="rPH" property="pgAbortToTempDRQ" value="原单内容产生新交期询问单"/>
<jsp:setProperty name="rPH" property="pgChoice" value="选择"/>
<jsp:setProperty name="rPH" property="pgAbortBefore" value="舍弃先前"/>
<jsp:setProperty name="rPH" property="pgSetup" value="设定"/>
<jsp:setProperty name="rPH" property="pgOrdCreate" value="订单生成"/>
<jsp:setProperty name="rPH" property="pgOrgOrder" value="原订单号"/>
<jsp:setProperty name="rPH" property="pgOrgOrderDesc" value="请输入客户(相同PO号)已产生的MO单\n将项次内容清单批次增加于原MO单后"/>
<jsp:setProperty name="rPH" property="pgFactDiffMsg" value="您不能选择与原订单不同的生产地作订单合并!!!"/>
<jsp:setProperty name="rPH" property="pgOrderChMsg" value="选择尚未结案且未BOOK之MO单"/>
<jsp:setProperty name="rPH" property="pgQALLToolTipMsg" value="请依企划指派之生产地批次生成MO单"/>
<jsp:setProperty name="rPH" property="pgAppendMOMsg" value="您必需先选择MO单作合并订单作业"/>
<jsp:setProperty name="rPH" property="pgEndCustPO" value="终端客户订购单号"/>
<jsp:setProperty name="rPH" property="pgAlertMOCmbSubmit" value="确定您要合并订单吗?"/>
<jsp:setProperty name="rPH" property="pgAlterGenAbort" value="确定您要放弃生成订单并将选定项目结案吗?\n如需以选定内容重新询问交期\n请勾选生成新交期询问单确认框!!!"/>
<jsp:setProperty name="rPH" property="pgAlertBranchConfirm" value="请您确定分公司已执行发票系统确认(Branch Confirm),否则易导致系统收料/出货异常!!!"/>
<jsp:setProperty name="rPH" property="pgSystemHint" value="系统提示"/>
<jsp:setProperty name="rPH" property="pgVendorSSD" value="供货商交期"/>


<jsp:setProperty name="rPH" property="pgItemContent" value="项目"/>
<jsp:setProperty name="rPH" property="pgRFQProcessStatus" value="询问单处理状态"/>

<jsp:setProperty name="rPH" property="pgRFQProcessSummary" value="处理状态汇整"/>
<jsp:setProperty name="rPH" property="pgRFQProcessing" value="开单处理中"/>
<jsp:setProperty name="rPH" property="pgRFQDOCNoClosed" value="已结案"/>
<jsp:setProperty name="rPH" property="pgRFQCompleteRate" value="完成率"/>
<jsp:setProperty name="rPH" property="pgSPCProcessSummary" value="企划处理状态汇整"/>
<jsp:setProperty name="rPH" property="pgFCTProcessSummary" value="工厂处理状态汇整"/>
<jsp:setProperty name="rPH" property="pgTTEW" value="天津长威"/>
<jsp:setProperty name="rPH" property="pgYYEW" value="阳信长威"/>
<jsp:setProperty name="rPH" property="pgIILAN" value="宜兰库存"/>
<jsp:setProperty name="rPH" property="pgSILAN" value="宜兰SKY"/>
<jsp:setProperty name="rPH" property="pgOILAN" value="宜兰外购"/>
<jsp:setProperty name="rPH" property="pgNTaipei" value="NBU外购"/>
<jsp:setProperty name="rPH" property="pgRFQTemporary" value="草稿文件"/>
<jsp:setProperty name="rPH" property="pgRFQAssigning" value="企划分派中"/>
<jsp:setProperty name="rPH" property="pgRFQEstimating" value="工厂交期排定中"/>
<jsp:setProperty name="rPH" property="pgRFQArrenged" value="工厂排定待确认"/>
<jsp:setProperty name="rPH" property="pgRFQResponding" value="企划交期回复中"/>
<jsp:setProperty name="rPH" property="pgRFQConfirmed" value="业务待客户确认"/>
<jsp:setProperty name="rPH" property="pgRFQGenerating" value="销售订单生成中"/>
<jsp:setProperty name="rPH" property="pgRFQClosed" value="交期询问单已结案"/>
<jsp:setProperty name="rPH" property="pgRFQAborted" value="放弃"/>
<jsp:setProperty name="rPH" property="pgProcessQty" value="处理数"/>
<jsp:setProperty name="rPH" property="pgNewNo" value="新"/>
<jsp:setProperty name="rPH" property="pgALogDesc" value="日期区间下各区询问单登录单据笔数"/>
<jsp:setProperty name="rPH" property="pgYellowItem" value="黄色项目"/>
<jsp:setProperty name="rPH" property="pgItemExistsMsg" value="品号不存在于ORG对应所选择之订单类型"/>
<jsp:setProperty name="rPH" property="pgWorkHour" value="工时"/>
<jsp:setProperty name="rPH" property="pgtheItem" value="本项"/>
<jsp:setProperty name="rPH" property="pgRFQRequestDateMsg" value="交货日期不得小于今日!!"/>
<jsp:setProperty name="rPH" property="pgNonProcess" value="未处理"/>
<jsp:setProperty name="rPH" property="pgPlanRspPeriod" value="企划回复至目前已历时/小时"/>

<jsp:setProperty name="rPH" property="pgDeliverCustomer" value="交货客户"/>
<jsp:setProperty name="rPH" property="pgDeliverLocation" value="交货位址"/>
<jsp:setProperty name="rPH" property="pgDeliverContact" value="交货连络人"/>
<jsp:setProperty name="rPH" property="pgDeliveryTo" value="交货代码"/>
<jsp:setProperty name="rPH" property="pgDeliverAddress" value="交货地址"/>
<jsp:setProperty name="rPH" property="pgNotifyContact" value="通知连络人"/>
<jsp:setProperty name="rPH" property="pgNotifyLocation" value="通知连络地址"/>
<jsp:setProperty name="rPH" property="pgShipContact" value="出货连络人"/>
<jsp:setProperty name="rPH" property="pgMain" value="主要"/>
<jsp:setProperty name="rPH" property="pgOthers" value="其它"/>
<jsp:setProperty name="rPH" property="pgFactoryResponse" value="工厂回复"/>
<jsp:setProperty name="rPH" property="pgWith" value="与"/>
<jsp:setProperty name="rPH" property="pgDetailRpt" value="明细表"/>
<jsp:setProperty name="rPH" property="pgDateType" value="日期种类"/>
<jsp:setProperty name="rPH" property="pgFr" value="起"/>
<jsp:setProperty name="rPH" property="pgTo_" value="迄"/>
<jsp:setProperty name="rPH" property="pgSSD" value="预计出货日"/>
<jsp:setProperty name="rPH" property="pgOrdD" value="订单日期"/>
<jsp:setProperty name="rPH" property="pgItmFly" value="Item Family"/>
<jsp:setProperty name="rPH" property="pgItmPkg" value="Item Package"/>
<jsp:setProperty name="rPH" property="pgLDetailSave" value="本次预计将储存明细"/>
<jsp:setProperty name="rPH" property="pgLCheckDelete" value="点取确认盒可作删除"/>
<jsp:setProperty name="rPH" property="pgThAccShpQty" value="本次累出数量"/>
<jsp:setProperty name="rPH" property="pgFactoryDeDate" value="工厂交期"/>
<jsp:setProperty name="rPH" property="pgNoResponse" value="未回复"/>
<jsp:setProperty name="rPH" property="pgAccWorkHours" value="开单至目前已历时/小时"/>
<jsp:setProperty name="rPH" property="pgPlanRejectItem" value="被企划生管批退之项目"/>
<jsp:setProperty name="rPH" property="pgSetSampleOrder" value="此单据为样品订单"/>
<jsp:setProperty name="rPH" property="pgSampleOrderCh" value="样品订单设定"/>
<jsp:setProperty name="rPH" property="pgQuotation" value="收费样品"/>
<jsp:setProperty name="rPH" property="pgLack" value="不"/>
<jsp:setProperty name="rPH" property="pgCRDate" value="客户需求日"/>
<jsp:setProperty name="rPH" property="pgSRDate" value="业务需求日"/>

<!--start for 出货发票收料管理 list -->
<jsp:setProperty name="rPH" property="pgInvoiceNo" value="发票"/>
<jsp:setProperty name="rPH" property="pgPoNo" value="采购单"/>
<jsp:setProperty name="rPH" property="pgAvailableShip" value="可出货"/>
<jsp:setProperty name="rPH" property="pgContiune" value="继续"/>
<jsp:setProperty name="rPH" property="pgInvBranchConfirm" value="分公司尚未执行发票系统确认(Branch Confirm)"/>

<!--start for MFG list -->
<jsp:setProperty name="rPH" property="pgInSales" value="内销"/>
<jsp:setProperty name="rPH" property="pgExpSales" value="外销"/>
<jsp:setProperty name="rPH" property="pgSchStartDate" value="预计投入日"/>
<jsp:setProperty name="rPH" property="pgSchCompletDate" value="预计完工日"/>
<jsp:setProperty name="rPH" property="pgWafer" value="芯片"/>
<jsp:setProperty name="rPH" property="pgYield" value="良率"/>
<jsp:setProperty name="rPH" property="pgEleres" value="电阻系数"/>
<jsp:setProperty name="rPH" property="pgVendor" value="供货商"/>
<jsp:setProperty name="rPH" property="pgInspectNo" value="检验单号"/>
<jsp:setProperty name="rPH" property="pgRunCardNo" value="流程卡号"/>
<jsp:setProperty name="rPH" property="pgAmpere" value="安培数"/>
<jsp:setProperty name="rPH" property="pgSingleLot" value="单批"/>

<!--other -->
<jsp:setProperty name="rPH" property="pgContZero" value="包含库存为零的数据"/>
