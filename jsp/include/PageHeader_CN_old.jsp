<%@ page contentType="text/html; charset=gb2312" %>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>

<jsp:setProperty name="rPH" property="pgHOME" value="回首页"/>
<jsp:setProperty name="rPH" property="pgAllRepLog" value="查询所有维修案件"/>
<jsp:setProperty name="rPH" property="pgTxLog" value="维修件异动记录"/>
<jsp:setProperty name="rPH" property="pgAddWKF" value="新增流程"/>
<jsp:setProperty name="rPH" property="pgRemark" value="附注"/>
<jsp:setProperty name="rPH" property="pgFormID" value="流桯窗体识别"/>
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
<jsp:setProperty name="rPH" property="pgQuotation" value="报价费用项目"/>
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
<jsp:setProperty name="rPH" property="pgWorkTime" value="维修工时"/>
<jsp:setProperty name="rPH" property="pgWorkTimeMsg" value="单位/小时"/>
<jsp:setProperty name="rPH" property="pgLotNo" value="批号"/>
<jsp:setProperty name="rPH" property="pgSymptom" value="故障症状"/>
<jsp:setProperty name="rPH" property="pgRecType" value="收件来源型态"/>
<jsp:setProperty name="rPH" property="pgPCBA" value="机板"/>
<jsp:setProperty name="rPH" property="pgRepeatRepInput" value="重复维修收件输入页面"/>
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
<jsp:setProperty name="rPH" property="pgAlertCustomer" value="请先填入顾客姓名后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrType" value="请先选填服务类型后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertJam" value="请先选故障描述后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertIMEI" value="请输入该手机之IMEI序号!!"/>
<jsp:setProperty name="rPH" property="pgAlertCancel" value="确定您要CANCEL??"/>
<jsp:setProperty name="rPH" property="pgAlertAssign" value="请先选择您欲指派之维修人员后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSubmit" value="请先选择您欲执行之动作后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRepLvl" value="请先填入维修等级!!"/>
<jsp:setProperty name="rPH" property="pgAlertLvl3" value="您所决定的维修等级为3级,请进行后送(TRANSMIT)作业!!"/>
<jsp:setProperty name="rPH" property="pgAlertNonLvl3" value="您所决定的维修等级不为3级,不需进行后送(TRANSMIT)作业!!"/>
<jsp:setProperty name="rPH" property="pgAlertReassign" value="请先选定一位维修工程师后再进行指派(REASSIGN)!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransfer" value="请先选定欲转移之维修点后再进行转移(TRANSFER)!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecItem2" value="请一定要点选输入后送维修收件项目!!"/>
<jsp:setProperty name="rPH" property="pgAlertSoftVer" value="依据您所选取的维修方式，请先填入软件版本后再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertChgIMEI" value="依据您所选取的维修方式，请先填入更改之IMEI后再完成本案件！"/>
<jsp:setProperty name="rPH" property="pgAlertWorkTime" value="请输入您实际完成的工时数(单位以小时计)"/>
<jsp:setProperty name="rPH" property="pgAlertRPMaterial" value="对应您所选取的维修方式,请先选取维修料件后再SubmitI!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPReason" value="请务必选取维修项目或分析说明后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPAction" value="请务必选取实际维修方式后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSymptom" value="请务必选取故障特征后再Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertQty" value="请先填入您实际收件之数量后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemNo" value="请先填入BPCS之真实料号后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgErrorQty" value="请先修改数量后再存盘,Handset或PCB一单只能1个!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecType" value="请先选取适当之收件来源型态后再存盘!!"/>
<jsp:setProperty name="rPH" property="pgAlertDOAPIMEI" value="因为您所选取的服务类型为DOA/DAP,故请先填入更换之IMEI!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgSvrType" value="确定要更改服务类型?"/>
<jsp:setProperty name="rPH" property="pgAlertPcba" value="请先填入机板之真实料号后再存盘!!"/>


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
<jsp:setProperty name="rPH" property="pgItemQty" value="料件笔数"/> 
<jsp:setProperty name="rPH" property="pgMRItemQty" value="领料单笔数"/>



<!--以下为代理商/经销商数据 -->
<jsp:setProperty name="rPH" property="pgInfo" value="基本资料"/>
<jsp:setProperty name="rPH" property="pgName" value="名称"/>
<jsp:setProperty name="rPH" property="pgNo" value="编号"/>
<jsp:setProperty name="rPH" property="pgDepend" value="隶属维修收件单位"/>
<jsp:setProperty name="rPH" property="pgContact" value="联络人"/>
<jsp:setProperty name="rPH" property="pgFAX" value="传真"/>
<jsp:setProperty name="rPH" property="pgKeyAccount" value="关键经销/代理商"/>
<jsp:setProperty name="rPH" property="pgEdit" value="编辑"/>

<!--以下為查??面資料-->
  <!--維修中心每日已入帳BPCS查?-->
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
 <!--月份故障原因分佈查?-->
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

 <!--維修工程?領料/倉管發料紀?查?-->
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
<jsp:setProperty name="rPH" property="pgMESMobileInf" value="手机生产信息查询"/>
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
<jsp:setProperty name="rPH" property="pgBPCSOrder" value="BPCS工单号"/>
<jsp:setProperty name="rPH" property="pgTestBay" value="生产测试站"/>
<jsp:setProperty name="rPH" property="pgCartonNo" value="包装箱号"/>
<jsp:setProperty name="rPH" property="pgProductDetail" value="生产历程明细"/>

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
<jsp:setProperty name="rPH" property="pgShipType" value="出货方式"/> 

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
<jsp:setProperty name="rPH" property="pgLack" value="不足"/>
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

 <!--以下為作業管理功能資料 -->
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

<jsp:setProperty name="rPH" property="pgASResActInput" value="售服维修原因/方式代码输入"/>
<jsp:setProperty name="rPH" property="pgActionCode" value="维修方式代码"/>
<jsp:setProperty name="rPH" property="pgActionDesc" value="维修方式说明"/>
<jsp:setProperty name="rPH" property="pgActionChDesc" value="维修方式中文说明"/>
<jsp:setProperty name="rPH" property="pgReasonCode" value="维修原因代码"/>
<jsp:setProperty name="rPH" property="pgReasonDesc" value="维修原因说明"/>
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
<jsp:setProperty name="rPH" property="pgRepAreaSummaryReport" value="维修案件资料汇总表"/>


 <!-- 杂项词库 -->
<jsp:setProperty name="rPH" property="pgCase" value="案件"/>
<jsp:setProperty name="rPH" property="pgRecords" value="记录"/>
<jsp:setProperty name="rPH" property="pgTo" value="至"/>

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
<jsp:setProperty name="rPH" property="pgCurr" value="币别"/>
<jsp:setProperty name="rPH" property="pgPreOrderType" value="预计订单类型"/>
<jsp:setProperty name="rPH" property="pgProcessUser" value="处理人员"/>
<jsp:setProperty name="rPH" property="pgProcessDate" value="处理日期"/>
<jsp:setProperty name="rPH" property="pgProcessTime" value="处理时间"/>
<jsp:setProperty name="rPH" property="pgDRQInputPage" value="输入页面"/>
<jsp:setProperty name="rPH" property="pgProdManufactory" value="预定生产地"/>


