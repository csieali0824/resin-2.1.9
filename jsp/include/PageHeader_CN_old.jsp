<%@ page contentType="text/html; charset=gb2312" %>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>

<jsp:setProperty name="rPH" property="pgHOME" value="����ҳ"/>
<jsp:setProperty name="rPH" property="pgAllRepLog" value="��ѯ����ά�ް���"/>
<jsp:setProperty name="rPH" property="pgTxLog" value="ά�޼��춯��¼"/>
<jsp:setProperty name="rPH" property="pgAddWKF" value="��������"/>
<jsp:setProperty name="rPH" property="pgRemark" value="��ע"/>
<jsp:setProperty name="rPH" property="pgFormID" value="���H����ʶ��"/>
<jsp:setProperty name="rPH" property="pgWKFTypeNo" value="����������"/>
<jsp:setProperty name="rPH" property="pgOriStat" value="ԭʼ״̬"/>
<jsp:setProperty name="rPH" property="pgAction" value="ִ�ж���"/>
<jsp:setProperty name="rPH" property="pgChgStat" value="�䶯��״̬"/>
<jsp:setProperty name="rPH" property="pgWKFDESC" value="����˵��"/>

<!--����Ϊҳ�水ť -->
<jsp:setProperty name="rPH" property="pgSelectAll" value="ѡ��ȫ��"/>
<jsp:setProperty name="rPH" property="pgCancelSelect" value="ȡ��ѡ��"/>
<jsp:setProperty name="rPH" property="pgPlsEnter" value="������"/>
<jsp:setProperty name="rPH" property="pgDelete" value="ɾ��"/>
<jsp:setProperty name="rPH" property="pgSave" value="����"/>
<jsp:setProperty name="rPH" property="pgAdd" value="����"/>
<jsp:setProperty name="rPH" property="pgOK" value="ȷ��"/>
<jsp:setProperty name="rPH" property="pgFetch" value="����"/>
<jsp:setProperty name="rPH" property="pgQuery" value="��ѯ"/>
<jsp:setProperty name="rPH" property="pgSearch" value="��Ѱ"/>
<jsp:setProperty name="rPH" property="pgExecute" value="ִ��"/>
<jsp:setProperty name="rPH" property="pgReset" value="����"/>

<!--�嵥ҳ��֮���ѶϢ-->
<jsp:setProperty name="rPH" property="pgPage" value="ҳ"/>
<jsp:setProperty name="rPH" property="pgPages" value="ҳ"/>
<jsp:setProperty name="rPH" property="pgFirst" value="��һ"/>
<jsp:setProperty name="rPH" property="pgLast" value="���һ"/>
<jsp:setProperty name="rPH" property="pgPrevious" value="��һ"/>
<jsp:setProperty name="rPH" property="pgNext" value="��һ"/>
<jsp:setProperty name="rPH" property="pgTheNo" value="��"/>
<jsp:setProperty name="rPH" property="pgTotal" value="�ܹ�"/>
<jsp:setProperty name="rPH" property="pgRecord" value="�ʼ�¼"/>
<jsp:setProperty name="rPH" property="pgRPProcess" value="ά�ް�������"/>
<jsp:setProperty name="rPH" property="pgAllRecords" value="���м�¼"/>
<jsp:setProperty name="rPH" property="pgCode" value="����"/>


<!--����Ϊά�ް�����ͷ -->
<jsp:setProperty name="rPH" property="pgRepTitle" value="��Ʒ����ά�޵�"/>
<jsp:setProperty name="rPH" property="pgRepNote" value="Ϊ�����ֶ�,����������������"/>
<jsp:setProperty name="rPH" property="pgRepCenter" value="ά�޵�"/>
<jsp:setProperty name="rPH" property="pgAgent" value="����/������"/>
<jsp:setProperty name="rPH" property="pgRecDate" value="�ռ�����"/>
<jsp:setProperty name="rPH" property="pgRecCenter" value="�ռ���λ"/>
<jsp:setProperty name="rPH" property="pgRecPerson" value="�ռ���"/>
<jsp:setProperty name="rPH" property="pgCustomer" value="�˿�����"/>
<jsp:setProperty name="rPH" property="pgTEL" value="����绰"/>
<jsp:setProperty name="rPH" property="pgCell" value="�ж��绰"/>
<jsp:setProperty name="rPH" property="pgAddr" value="��ַ"/>
<jsp:setProperty name="rPH" property="pgZIP" value="��������"/>
<jsp:setProperty name="rPH" property="pgBuyingPlace" value="����ص�"/>
<jsp:setProperty name="rPH" property="pgBuyingDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgSvrDocNo" value="���񵥺�"/>
<jsp:setProperty name="rPH" property="pgPart" value="�Ϻ�"/>
<jsp:setProperty name="rPH" property="pgPartDesc" value="���˵��"/>
<jsp:setProperty name="rPH" property="pgModel" value="��Ʒ�ͺ�"/>
<jsp:setProperty name="rPH" property="pgColor" value="�ֻ���ɫ"/>
<jsp:setProperty name="rPH" property="pgIMEI" value="IMEI���"/>
<jsp:setProperty name="rPH" property="pgDSN" value="��Ʒ���"/>
<jsp:setProperty name="rPH" property="pgRecItem" value="�ռ���Ŀ"/>
<jsp:setProperty name="rPH" property="pgJam" value="��������"/>
<jsp:setProperty name="rPH" property="pgOtherJam" value="������������"/>
<jsp:setProperty name="rPH" property="pgFreq" value="����Ƶ��"/>
<jsp:setProperty name="rPH" property="pgWarranty" value="�������"/>
<jsp:setProperty name="rPH" property="pgValid" value="����"/>
<jsp:setProperty name="rPH" property="pgInvalid" value="����"/>
<jsp:setProperty name="rPH" property="pgWarrNo" value="���̿���"/>
<jsp:setProperty name="rPH" property="pgSvrType" value="��������"/>
<jsp:setProperty name="rPH" property="pgRepStatus" value="״̬"/>
<jsp:setProperty name="rPH" property="pgRepNo" value="�������"/>
<jsp:setProperty name="rPH" property="pgRecItem2" value="����ά���ռ���Ŀ"/>
<jsp:setProperty name="rPH" property="pgWarranty2" value="�ж��󱣹����"/>
<jsp:setProperty name="rPH" property="pgRepLvl" value="ά�޵ȼ�"/>
<jsp:setProperty name="rPH" property="pgRepHistory" value="ά����ʷ��¼"/>
<jsp:setProperty name="rPH" property="pgDOAPVerify" value="DOA/DAP�ж������ϸ"/>
<jsp:setProperty name="rPH" property="pgPreRPAct" value="Ԥ��ά�޷�ʽ"/>
<jsp:setProperty name="rPH" property="pgActualRPAct" value="ʵ��ά�޷�ʽ"/>
<jsp:setProperty name="rPH" property="pgSoftwareVer" value="����汾"/>
<jsp:setProperty name="rPH" property="pgChgIMEI" value="����֮IMEI"/>
<jsp:setProperty name="rPH" property="pgActualRPDesc" value="ʵ��ά������"/>
<jsp:setProperty name="rPH" property="pgPreUseMaterial" value="Ԥ��ά�޺���"/>
<jsp:setProperty name="rPH" property="pgUseMaterial" value="ά�޺���"/>
<jsp:setProperty name="rPH" property="pgRPReason" value="ά����Ŀ�����˵��"/>
<jsp:setProperty name="rPH" property="pgQuotation" value="���۷�����Ŀ"/>
<jsp:setProperty name="rPH" property="pgRPCost" value="ά�޷���"/>
<jsp:setProperty name="rPH" property="pgPartCost" value="���Ϸ���"/>
<jsp:setProperty name="rPH" property="pgTransCost" value="�˷�"/>
<jsp:setProperty name="rPH" property="pgOtherCost" value="��������"/>
<jsp:setProperty name="rPH" property="pgExecutor" value="����ִ����"/>
<jsp:setProperty name="rPH" property="pgExeTime" value="ִ��ʱ��"/>
<jsp:setProperty name="rPH" property="pgAssignTo" value="ָ����Ա"/>
<jsp:setProperty name="rPH" property="pgRepPerson" value="ά����Ա"/>
<jsp:setProperty name="rPH" property="pgTransferTo" value="��ת��֮ά�޵�"/>
<jsp:setProperty name="rPH" property="pgMailNotice" value="e-Mail֪ͨ"/>
<jsp:setProperty name="rPH" property="pgWorkTime" value="ά�޹�ʱ"/>
<jsp:setProperty name="rPH" property="pgWorkTimeMsg" value="��λ/Сʱ"/>
<jsp:setProperty name="rPH" property="pgLotNo" value="����"/>
<jsp:setProperty name="rPH" property="pgSymptom" value="����֢״"/>
<jsp:setProperty name="rPH" property="pgRecType" value="�ռ���Դ��̬"/>
<jsp:setProperty name="rPH" property="pgPCBA" value="����"/>
<jsp:setProperty name="rPH" property="pgRepeatRepInput" value="�ظ�ά���ռ�����ҳ��"/>
<jsp:setProperty name="rPH" property="pgWarrLimit" value="��������"/>

<!--����Ϊά�޴����а�����ͷ -->
<jsp:setProperty name="rPH" property="pgAddMaterial" value="ѡȡά���ϼ�"/>
<jsp:setProperty name="rPH" property="pgSituation" value="����ȷ����Ŀ"/>
<jsp:setProperty name="rPH" property="pgSituationMsg" value="��Ҫ���б��۲���ѡ��"/>

<!--�����Ӵ��ڵ���Ϣ-->
<jsp:setProperty name="rPH" property="pgRelevantInfo" value="�����Ϣ"/>
<jsp:setProperty name="rPH" property="pgEnterCustIMEI" value="������ͻ�������IMEI���"/>
<jsp:setProperty name="rPH" property="pgSearchByAgency" value="��������/�����̲�ѯ"/>
<jsp:setProperty name="rPH" property="pgSearchByCustIMEI" value="���ͻ�/IMEI��ѯ"/>
<jsp:setProperty name="rPH" property="pgEnterAgency" value="�����뾭����/����������"/>
<jsp:setProperty name="rPH" property="pgInputPart" value="�л����Ϻ�����"/>
<jsp:setProperty name="rPH" property="pgChoosePart" value="�л����Ϻ�ѡȡ"/>
<jsp:setProperty name="rPH" property="pgQty" value="����"/>

<!--JavaScript��֮�����ľ�-->
<jsp:setProperty name="rPH" property="pgAlertAction" value="����ѡ������ִ��֮�������ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertModel" value="����ѡ��MODEL���ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrDocNo" value="����������񵥺ź��ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertCustomer" value="��������˿��������ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrType" value="����ѡ��������ͺ��ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertJam" value="����ѡ�����������ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertIMEI" value="��������ֻ�֮IMEI���!!"/>
<jsp:setProperty name="rPH" property="pgAlertCancel" value="ȷ����ҪCANCEL??"/>
<jsp:setProperty name="rPH" property="pgAlertAssign" value="����ѡ������ָ��֮ά����Ա����Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSubmit" value="����ѡ������ִ��֮��������Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRepLvl" value="��������ά�޵ȼ�!!"/>
<jsp:setProperty name="rPH" property="pgAlertLvl3" value="����������ά�޵ȼ�Ϊ3��,����к���(TRANSMIT)��ҵ!!"/>
<jsp:setProperty name="rPH" property="pgAlertNonLvl3" value="����������ά�޵ȼ���Ϊ3��,������к���(TRANSMIT)��ҵ!!"/>
<jsp:setProperty name="rPH" property="pgAlertReassign" value="����ѡ��һλά�޹���ʦ���ٽ���ָ��(REASSIGN)!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransfer" value="����ѡ����ת��֮ά�޵���ٽ���ת��(TRANSFER)!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecItem2" value="��һ��Ҫ��ѡ�������ά���ռ���Ŀ!!"/>
<jsp:setProperty name="rPH" property="pgAlertSoftVer" value="��������ѡȡ��ά�޷�ʽ��������������汾������ɱ�������"/>
<jsp:setProperty name="rPH" property="pgAlertChgIMEI" value="��������ѡȡ��ά�޷�ʽ�������������֮IMEI������ɱ�������"/>
<jsp:setProperty name="rPH" property="pgAlertWorkTime" value="��������ʵ����ɵĹ�ʱ��(��λ��Сʱ��)"/>
<jsp:setProperty name="rPH" property="pgAlertRPMaterial" value="��Ӧ����ѡȡ��ά�޷�ʽ,����ѡȡά���ϼ�����SubmitI!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPReason" value="�����ѡȡά����Ŀ�����˵������Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPAction" value="�����ѡȡʵ��ά�޷�ʽ����Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertSymptom" value="�����ѡȡ������������Submit!!"/>
<jsp:setProperty name="rPH" property="pgAlertQty" value="����������ʵ���ռ�֮�������ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemNo" value="��������BPCS֮��ʵ�Ϻź��ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgErrorQty" value="�����޸��������ٴ���,Handset��PCBһ��ֻ��1��!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecType" value="����ѡȡ�ʵ�֮�ռ���Դ��̬���ٴ���!!"/>
<jsp:setProperty name="rPH" property="pgAlertDOAPIMEI" value="��Ϊ����ѡȡ�ķ�������ΪDOA/DAP,�������������֮IMEI!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgSvrType" value="ȷ��Ҫ���ķ�������?"/>
<jsp:setProperty name="rPH" property="pgAlertPcba" value="�����������֮��ʵ�Ϻź��ٴ���!!"/>


<!--submit��֮��ʾ��-->
<jsp:setProperty name="rPH" property="pgFreqReturn" value="���޴���"/>
<jsp:setProperty name="rPH" property="pgFreqReject" value="���޴���"/>

<!--ҳ���л���������-->
<jsp:setProperty name="rPH" property="pgPageAddRMA" value="����ά���ռ���¼"/>
<jsp:setProperty name="rPH" property="pgPage3AddRMA" value="��������ά���ռ���¼"/>
<jsp:setProperty name="rPH" property="pgPageAssign" value="�ɹ���ά�ް���"/>
<jsp:setProperty name="rPH" property="pgPage3Assign" value="�����ɹ���ά�ް���"/>

<!--Send Mail ֮����-->
<jsp:setProperty name="rPH" property="pgMailSubjectAssign" value="����ά��ϵͳ��ָ��"/>

<!--�ؼ�ǩ�յ�֮����-->
<jsp:setProperty name="rPH" property="pgCustReceipt" value="ά��Ʒ�ؼ�ǩ�յ�"/>
<jsp:setProperty name="rPH" property="pgTransList" value="����ά��Ʒ�嵥"/>
<jsp:setProperty name="rPH" property="pgTransDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgListNo" value="�嵥���(����)"/>
<jsp:setProperty name="rPH" property="pgReceiptNo" value="ǩ�յ���"/>
<jsp:setProperty name="rPH" property="pgShipDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgShipper" value="������"/>
<jsp:setProperty name="rPH" property="pgCustSign" value="�ͻ�ǩ��"/>
<jsp:setProperty name="rPH" property="pgPSMessage1" value="�����յ�ά��Ʒȷ�������,�ڿͻ�ǩ�մ�ǩ���ش�;������"/>
<jsp:setProperty name="rPH" property="pgPSMessage2" value="�����κ��������������硣����绰"/>
<jsp:setProperty name="rPH" property="pgWarnMessage" value="����˾�Լļ���Ϊ׼,3����δ�ش���ͬ���յ�;�������������λ���и���"/>

<!--���ǩ�յ�֮����-->
<jsp:setProperty name="rPH" property="pgInStockLotList" value="DOA/DAP����ά�޼���ⵥ"/>
<jsp:setProperty name="rPH" property="pgInStockNo" value="��ⵥ��"/>
<jsp:setProperty name="rPH" property="pgInStockDate" value="�������"/>
<jsp:setProperty name="rPH" property="pgInStocker" value="�����Ա"/>
<jsp:setProperty name="rPH" property="pgWarehouserSign" value="�ֿ���Աǩ��"/>

<!--ά�����̴����ѶϢ����-->
<jsp:setProperty name="rPH" property="pgPrintCustReceipt" value="��ӡά��Ʒ�ؼ�ǩ�յ�"/>
<jsp:setProperty name="rPH" property="pgPrintShippedConfirm" value="��ӡRMA����ȷ�ϵ�"/>
<jsp:setProperty name="rPH" property="pgRepairProcess" value="һ��ά�޴�������"/>
<jsp:setProperty name="rPH" property="pgDOAProcess" value="DOA��������"/>
<jsp:setProperty name="rPH" property="pgDAPProcess" value="DAP��������"/>

<!--�������뵥-->
<jsp:setProperty name="rPH" property="pgMaterialRequest" value="�������뵥"/>
<jsp:setProperty name="rPH" property="pgTransType" value="�춯����"/>
<jsp:setProperty name="rPH" property="pgConReg" value="����/����"/>
<jsp:setProperty name="rPH" property="pgDocNo" value="���ݱ��"/>
<jsp:setProperty name="rPH" property="pgWarehouseNo" value="�ֱ�"/>
<jsp:setProperty name="rPH" property="pgLocation" value="��λ"/>
<jsp:setProperty name="rPH" property="pgPersonal" value="����/��Ա"/>
<jsp:setProperty name="rPH" property="pgInvTransInput" value="����춯����"/>
<jsp:setProperty name="rPH" property="pgInvTransQuery" value="����춯��ѯ"/>

<jsp:setProperty name="rPH" property="pgAllMRLog" value="��ѯ�������ϰ���"/>
<jsp:setProperty name="rPH" property="pgAlertMRReason" value="��ѡ������ԭ��"/>
<jsp:setProperty name="rPH" property="pgAlertMRChoose" value="����ѡ������������ϼ����ٴ���"/>
<jsp:setProperty name="rPH" property="pgApDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgApplicant" value="������"/>
<jsp:setProperty name="rPH" property="pgMRReason" value="����ԭ��"/>
<jsp:setProperty name="rPH" property="pgInvMagProcess" value="��������ҵ"/>
<jsp:setProperty name="rPH" property="pgMRProcess" value="���ϰ�������"/>
<jsp:setProperty name="rPH" property="pgApplyPart" value="�����ϼ�"/>
<jsp:setProperty name="rPH" property="pgReceivePart" value="ʵ���ϼ�"/>
<jsp:setProperty name="rPH" property="pgMRDesc" value="�Ϻ�˵��"/>
<jsp:setProperty name="rPH" property="pgProvdTime" value="����ʱ��"/>

<jsp:setProperty name="rPH" property="pgMRR" value="�ϼ��˻����뵥"/>
<jsp:setProperty name="rPH" property="pgReturnPart" value="�˻��ϼ�"/>
<jsp:setProperty name="rPH" property="pgOriWhs" value="ԭ�����ֱ�"/>
<jsp:setProperty name="rPH" property="pgAlertApplicant" value="����ѡ��������!"/>
<jsp:setProperty name="rPH" property="pgTransReason" value="�춯ԭ��"/>
<jsp:setProperty name="rPH" property="pgMAR" value="�ϼ�ת�����뵥"/>
<jsp:setProperty name="rPH" property="pgAllotPart" value="ת���ϼ�"/>
<jsp:setProperty name="rPH" property="pgAllottee" value="��ת����Ա"/>
<jsp:setProperty name="rPH" property="pgAlertAllottee" value="����ѡ��ת����Ա!"/>
<jsp:setProperty name="rPH" property="pgAlertTransReason" value="����ѡ���춯ԭ��!!"/>

<!--����춯-->
 <!--����ΪDOA/DAP��ͷ -->
<jsp:setProperty name="rPH" property="pgVeriSvrType" value="�ж���������"/>
<jsp:setProperty name="rPH" property="pgVerifyStandard" value="DOA/DAP�ж���׼"/>

 <!-- ά�޼�����������BPCS(���ϼ���ϸ) -->
<jsp:setProperty name="rPH" property="pgRepPostByItem" value="ά�޼�����������BPCS(���ϼ���ϸ)"/>
<jsp:setProperty name="rPH" property="pgBPCSInvQty" value="BPCS�����"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDate" value="��������"/> 
<jsp:setProperty name="rPH" property="pgIssuePerson" value="������Ա"/> 
<jsp:setProperty name="rPH" property="pgTransComment" value="�춯����"/>
<jsp:setProperty name="rPH" property="pgBalanceQty" value="��������"/>

<!-- ά�޼�����������BPCS(�����ϵ���) -->
<jsp:setProperty name="rPH" property="pgRepPostByMRequest" value="ά�޼�����������BPCS(�����ϵ���)"/>
<jsp:setProperty name="rPH" property="pgCheckItem" value="ѡȡ"/>
<jsp:setProperty name="rPH" property="pgPreparePost2BPCS" value="�����ϴ�����BPCS"/>

 <!-- ά�޼�����������BPCS(��ά�޹���ʦ) -->
<jsp:setProperty name="rPH" property="pgRepPostByRPEngineer" value="ά�޼�����������BPCS(��ά�޹���ʦ)"/>
<jsp:setProperty name="rPH" property="pgRepairEngineer" value="ά�޹���ʦ"/> 
<jsp:setProperty name="rPH" property="pgItemQty" value="�ϼ�����"/> 
<jsp:setProperty name="rPH" property="pgMRItemQty" value="���ϵ�����"/>



<!--����Ϊ������/���������� -->
<jsp:setProperty name="rPH" property="pgInfo" value="��������"/>
<jsp:setProperty name="rPH" property="pgName" value="����"/>
<jsp:setProperty name="rPH" property="pgNo" value="���"/>
<jsp:setProperty name="rPH" property="pgDepend" value="����ά���ռ���λ"/>
<jsp:setProperty name="rPH" property="pgContact" value="������"/>
<jsp:setProperty name="rPH" property="pgFAX" value="����"/>
<jsp:setProperty name="rPH" property="pgKeyAccount" value="�ؼ�����/������"/>
<jsp:setProperty name="rPH" property="pgEdit" value="�༭"/>

<!--�����??���Y��-->
  <!--�S������ÿ�����뎤BPCS��?-->
<jsp:setProperty name="rPH" property="pgCentPBpcsTitle" value="ά������ÿ��������BPCS��ѯ"/>
<jsp:setProperty name="rPH" property="pgPostDateFr" value="��������"/>
<jsp:setProperty name="rPH" property="pgPostDateTo" value="��������"/>
<jsp:setProperty name="rPH" property="pgPostDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgBelPerson" value="������Ա"/>
<jsp:setProperty name="rPH" property="pgTransTime" value="�춯ʱ��"/>
<jsp:setProperty name="rPH" property="pgExecPerson" value="ִ����Ա"/>
<jsp:setProperty name="rPH" property="pgBPCSSerial" value="BPCS���"/>
<!--ά�޻����·ݺ��ϼ��ɱ���ѯ-->
<jsp:setProperty name="rPH" property="pgModelConsumeTitle" value="ά�޻����·ݺ��ϼ��ɱ���ѯ"/>
<jsp:setProperty name="rPH" property="pgRpPartsCostTable" value="ά�޺����ϼ��ɱ��۸��"/>
<jsp:setProperty name="rPH" property="pgAnItem" value="���"/>
<jsp:setProperty name="rPH" property="pgPartsConsumQty" value="�ϼ�������"/>
<jsp:setProperty name="rPH" property="pgCostPrice" value="�ɱ��۸�"/>
<jsp:setProperty name="rPH" property="pgAccPartsPrice" value="�ϼ��۸�С��"/>
<jsp:setProperty name="rPH" property="pgGTotal" value="�ܼ�"/>
<jsp:setProperty name="rPH" property="pgCostMainten" value="ά�޼�ά�޷��ñ�"/>
<jsp:setProperty name="rPH" property="pgRPQuantity" value="ά�޼���"/>
<jsp:setProperty name="rPH" property="pgStdServiceFee" value="��׼ά�޷�/Сʱ"/>
<jsp:setProperty name="rPH" property="pgActServiceFee" value="ʵ��ά�޷�/Сʱ"/>
<jsp:setProperty name="rPH" property="pgModelFeeSubTotal" value="���ַ���С��"/>
 <!--�·ݹ���ԭ��ցѲ�?-->
<jsp:setProperty name="rPH" property="pgMonthFaultReasonTitle" value="�·ݹ���ԭ��ֲ���ѯ"/>
<jsp:setProperty name="rPH" property="pgRate" value="����"/>

 <!--ά�����ϵ�ÿ������BPCS���ʲ�ѯ-->
<jsp:setProperty name="rPH" property="pgMaterialReqBPCSTitle" value="ά�����ϵ�ÿ������BPCS���ʲ�ѯ"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDateFr" value="�������� ��"/> 
<jsp:setProperty name="rPH" property="pgIssuePartsDateTo" value="�������� ��"/>
<jsp:setProperty name="rPH" property="pgMatRequestForm" value="���ϵ���"/>
<jsp:setProperty name="rPH" property="pgRepairNo" value="ά�޵���"/>
<jsp:setProperty name="rPH" property="pgDetail" value="��ϸ"/>
<jsp:setProperty name="rPH" property="pgBPCSNo" value="BPCS����"/>
<jsp:setProperty name="rPH" property="pgBPCSDetail" value="BPCS��ϸ"/>

 <!--�S�޹���?�I��/�}�ܰl�ϼo?��?-->
<jsp:setProperty name="rPH" property="pgMaterialReqIssTitle" value="ά�޹���ʦ����/�ֹܷ��ϼ�¼��ѯ"/>

 <!--�������뵥��ӡ-->
<jsp:setProperty name="rPH" property="pgMReqInquiryLink" value="�����ϼ�¼��ѯҳ"/>
<jsp:setProperty name="rPH" property="pgYear" value="��"/>
<jsp:setProperty name="rPH" property="pgMonth" value="��"/>
<jsp:setProperty name="rPH" property="pgDay" value="��"/>
<jsp:setProperty name="rPH" property="pgS17DOAP" value="S17�ͻ���Ʒ��������"/>
<jsp:setProperty name="rPH" property="pgS11MaterialReq" value="S11������Ʒ����"/>
<jsp:setProperty name="rPH" property="pgS18WarrIn" value="S18����ά������"/>
<jsp:setProperty name="rPH" property="pgS19WarrOut" value="S19����ά������"/>
<jsp:setProperty name="rPH" property="pgEmpNo" value="Ա�����"/>
<jsp:setProperty name="rPH" property="pgDeptNo" value="��������"/>
<jsp:setProperty name="rPH" property="pgAppDesc" value="����˵��"/>
<jsp:setProperty name="rPH" property="pgItemDesc" value="Ʒ��"/>
<jsp:setProperty name="rPH" property="pgItemColor" value="��ɫ"/>
<jsp:setProperty name="rPH" property="pgAppQty" value="��������"/>
<jsp:setProperty name="rPH" property="pgActQty" value="ʵ������"/>
<jsp:setProperty name="rPH" property="pgApproval" value="��׼"/>
<jsp:setProperty name="rPH" property="pgChief" value="����"/>
<jsp:setProperty name="rPH" property="pgTreasurer" value="���"/>
<jsp:setProperty name="rPH" property="pgPrintDate" value="��ӡ����"/>

 <!-- �ֻ�������Ϣ��ѯ-->
<jsp:setProperty name="rPH" property="pgMESMobileInf" value="�ֻ�������Ϣ��ѯ"/>
<jsp:setProperty name="rPH" property="pgProdDateFr" value="����������"/>
<jsp:setProperty name="rPH" property="pgProdDateTo" value="����������"/>
<jsp:setProperty name="rPH" property="pgSearchStr" value="IMEI��DSN����Ʒ�Ϻš����"/>
<jsp:setProperty name="rPH" property="pgMESSOrderNo" value="����������"/>
<jsp:setProperty name="rPH" property="pgProdItemNo" value="��Ʒ�Ϻ�"/>
<jsp:setProperty name="rPH" property="pgMobileSoftware" value="�ֻ�����汾"/>
<jsp:setProperty name="rPH" property="pgLineName" value="��������"/>
<jsp:setProperty name="rPH" property="pgStationName" value="վ������"/>
<jsp:setProperty name="rPH" property="pgSOrderIn" value="����Ͷ������"/>
<jsp:setProperty name="rPH" property="pgPackingDTime" value="��װ����ʱ��"/>
<jsp:setProperty name="rPH" property="pgOperator" value="��װԱ"/>
<jsp:setProperty name="rPH" property="pgPMCC" value="PMCC��"/>
<jsp:setProperty name="rPH" property="pgBPCSOrder" value="BPCS������"/>
<jsp:setProperty name="rPH" property="pgTestBay" value="��������վ"/>
<jsp:setProperty name="rPH" property="pgCartonNo" value="��װ���"/>
<jsp:setProperty name="rPH" property="pgProductDetail" value="����������ϸ"/>

 <!-- ������ÿ���ϴ����Ͻ�ת��ѯ-->
<jsp:setProperty name="rPH" property="pgAgentUpfileInf" value="������ÿ���ϴ����Ͻ�ת��ѯ"/>
<jsp:setProperty name="rPH" property="pgDateFr" value="���� ��"/> 
<jsp:setProperty name="rPH" property="pgDateTo" value="���� ��"/>
<jsp:setProperty name="rPH" property="pgAgentNo" value="�����̱��"/>
<jsp:setProperty name="rPH" property="pgTransmitFlag" value="�������"/>
<jsp:setProperty name="rPH" property="pgChgIMEIFlag" value="����IMEI��"/> 

 <!-- ά�ް������ϲ�ѯ -->
<jsp:setProperty name="rPH" property="pgRepairCaseInf" value="ά�ް������ϲ�ѯ"/>
<jsp:setProperty name="rPH" property="pgTransOption" value="����/ά�޵�ת��"/>
<jsp:setProperty name="rPH" property="pgRetTimes" value="���޴���"/>
<jsp:setProperty name="rPH" property="pgFinishStatus" value="����״̬"/>
<jsp:setProperty name="rPH" property="pgExcelButton" value="Excel"/>
<jsp:setProperty name="rPH" property="pgRecTime" value="�ռ�ʱ��"/>
<jsp:setProperty name="rPH" property="pgFinishDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgFinishTime" value="����ʱ��"/>
<jsp:setProperty name="rPH" property="pgRepMethod" value="ά�޷�ʽ"/>
<jsp:setProperty name="rPH" property="pgLastMDate" value="���������"/>
<jsp:setProperty name="rPH" property="pgLastMPerson" value="�������Ա"/>
<jsp:setProperty name="rPH" property="pgRepPercent" value="ά�޼�����"/>
<jsp:setProperty name="rPH" property="pgNotFoundMsg" value="Ŀǰ���ݿ���޷��ϲ�ѯ����������"/>

<jsp:setProperty name="rPH" property="pgServiceLog" value="����"/>
<jsp:setProperty name="rPH" property="pgReturnLog" value="����"/>
<jsp:setProperty name="rPH" property="pgMobileRepair" value="�ֻ�ά��"/>
<jsp:setProperty name="rPH" property="pgCType" value="����"/>
<jsp:setProperty name="rPH" property="pgShipType" value="������ʽ"/> 

<!--����Ϊ��ҳ����Ա�������� -->
<jsp:setProperty name="rPH" property="pgMenuInstruction" value="ά��ϵͳ˵���ļ�"/>
<jsp:setProperty name="rPH" property="pgDownload" value="����ר��"/>
<jsp:setProperty name="rPH" property="pgMenuGroup" value="��������԰��"/>
<jsp:setProperty name="rPH" property="pgChgPwd" value="�޸�����"/>
<jsp:setProperty name="rPH" property="pgBulletin" value="���԰�"/>
<jsp:setProperty name="rPH" property="pgLogin" value="����"/>
<jsp:setProperty name="rPH" property="pgLogout" value="ע��"/>
<jsp:setProperty name="rPH" property="pgMsgLicence" value="��Ե��ӹɷ����޹�˾��Ȩ����"/>
<jsp:setProperty name="rPH" property="pgRole" value="��ɫ"/>
<jsp:setProperty name="rPH" property="pgList" value="�嵥"/>
<jsp:setProperty name="rPH" property="pgNew" value="����"/>
<jsp:setProperty name="rPH" property="pgRevise" value="�޸�"/>
<jsp:setProperty name="rPH" property="pgDesc" value="˵��"/>
<jsp:setProperty name="rPH" property="pgSuccess" value="���"/>
<jsp:setProperty name="rPH" property="pgAccount" value="��Ա"/>
<jsp:setProperty name="rPH" property="pgAccountWeb" value="��ԱWEBʶ����"/>
<jsp:setProperty name="rPH" property="pgMail" value="�����ʼ�"/>
<jsp:setProperty name="rPH" property="pgProfile" value="�����趨"/>
<jsp:setProperty name="rPH" property="pgPasswd" value="����"/>
<jsp:setProperty name="rPH" property="pgLocale" value="����"/>
<jsp:setProperty name="rPH" property="pgLanguage" value="��ϵ"/>
<jsp:setProperty name="rPH" property="pgModule" value="ģ��"/>
<jsp:setProperty name="rPH" property="pgSeq" value="�����"/>
<jsp:setProperty name="rPH" property="pgFunction" value="����"/>
<jsp:setProperty name="rPH" property="pgHref" value="�����ַ"/>
<jsp:setProperty name="rPH" property="pgAuthoriz" value="��Ȩ"/>
<jsp:setProperty name="rPH" property="pgEmpID" value="����"/>
<jsp:setProperty name="rPH" property="pgRepReceive" value="ά���ռ�"/>
<jsp:setProperty name="rPH" property="pgBasicInf" value="��������"/>
<jsp:setProperty name="rPH" property="pgFLName" value="����"/>
<jsp:setProperty name="rPH" property="pgID" value="�ʺ�"/>


<!--����Ϊ���԰漰������������ -->
<jsp:setProperty name="rPH" property="pgBulletinNotice" value="����/����"/>
<jsp:setProperty name="rPH" property="pgPublishDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgPublisher" value="������"/>
<jsp:setProperty name="rPH" property="pgPublish" value="��Ҫ����"/>
<jsp:setProperty name="rPH" property="pgTopic" value="����"/>
<jsp:setProperty name="rPH" property="pgContent" value="����"/>
<jsp:setProperty name="rPH" property="pgClassOfTopic" value="�������"/>
<jsp:setProperty name="rPH" property="pgTopicOfDiscuss" value="��������"/>
<jsp:setProperty name="rPH" property="pgHits" value="��Ӧ����"/>
<jsp:setProperty name="rPH" property="pgNewTopic" value="����������"/>
<jsp:setProperty name="rPH" property="pgClass" value="���"/>
<jsp:setProperty name="rPH" property="pgResponse" value="�ظ�"/>
<jsp:setProperty name="rPH" property="pgReturn" value="����"/>
<jsp:setProperty name="rPH" property="pgRespond" value="��Ӧ"/>
<jsp:setProperty name="rPH" property="pgNewDiscuss" value="�����µ���������"/>
<jsp:setProperty name="rPH" property="pgUserResponse" value="��Ӧ����"/>
<jsp:setProperty name="rPH" property="pgTime" value="ʱ��"/>
<jsp:setProperty name="rPH" property="pgResponder" value="��Ӧ��"/>
<jsp:setProperty name="rPH" property="pgInformation" value="��Ϣ"/>
<jsp:setProperty name="rPH" property="pgDocument" value="�ļ�"/>


<!--����Ϊ�۷����Ϲ������� -->
<jsp:setProperty name="rPH" property="pgASMaterial" value="����"/>
<jsp:setProperty name="rPH" property="pgUpload" value="����"/>
<jsp:setProperty name="rPH" property="pgFile" value="����"/>
<jsp:setProperty name="rPH" property="pgCenter" value="����"/>
<jsp:setProperty name="rPH" property="pgFormat" value="��ʽ"/>
<jsp:setProperty name="rPH" property="pgFollow" value="����ѭ"/>
<jsp:setProperty name="rPH" property="pgBelow" value="����"/>
<jsp:setProperty name="rPH" property="pgAbove" value="����"/>
<jsp:setProperty name="rPH" property="pgPreview" value="���"/>
<jsp:setProperty name="rPH" property="pgLevel" value="�ȼ�"/>
<jsp:setProperty name="rPH" property="pgLaunch" value="����"/>
<jsp:setProperty name="rPH" property="pgSparePart" value="���"/>
<jsp:setProperty name="rPH" property="pgModelSeries" value="����"/>
<jsp:setProperty name="rPH" property="pgPicture" value="ͼ��"/>
<jsp:setProperty name="rPH" property="pgImage" value="Ӱ��"/>
<jsp:setProperty name="rPH" property="pgInventory" value="���"/>
<jsp:setProperty name="rPH" property="pgLack" value="����"/>
<jsp:setProperty name="rPH" property="pgCalculate" value="����"/>
<jsp:setProperty name="rPH" property="pgPrice" value="�۸�"/>
<jsp:setProperty name="rPH" property="pgConsumer" value="������"/>
<jsp:setProperty name="rPH" property="pgRetailer" value="����"/>
<jsp:setProperty name="rPH" property="pgASMAuthFailMsg" value="��Ǹ!����Ȩ�޲�ѯ������"/>
<jsp:setProperty name="rPH" property="pgASMInfo" value="�ۺ����������Ϣ"/>
<jsp:setProperty name="rPH" property="pgMOQ" value="��С��������"/>
<jsp:setProperty name="rPH" property="pgSafeInv" value="��ȫ�����"/>
<jsp:setProperty name="rPH" property="pgCurrInv" value="Ŀǰ�����"/>
<jsp:setProperty name="rPH" property="pgFront" value="����"/>
<jsp:setProperty name="rPH" property="pgBack" value="����"/>
<jsp:setProperty name="rPH" property="pgAllASM" value="��ѯ�����۷�����"/>
<jsp:setProperty name="rPH" property="pgChooseMdl" value="ѡȡ����"/>
<jsp:setProperty name="rPH" property="pgASM_EC" value="�۷�����EC"/>
<jsp:setProperty name="rPH" property="pgChange" value="���"/>
<jsp:setProperty name="rPH" property="pgNewPart4EC" value="�����֮���Ϻ�"/>
<jsp:setProperty name="rPH" property="pgCurrModelRef" value="�������û���"/>
<jsp:setProperty name="rPH" property="pgModelRefMsg" value="��ѡ֮��Ŀ����Ϊ�Ϻű����һ������֮���õĻ���"/>
<jsp:setProperty name="rPH" property="pgDelImage" value="ɾ��ͼ��"/>

 <!--�������I�������Y�� -->
<jsp:setProperty name="rPH" property="pgAfterService" value="�۷�"/>
<jsp:setProperty name="rPH" property="pgInput" value="����"/>
<jsp:setProperty name="rPH" property="pgMaintenance" value="ά��"/>
<jsp:setProperty name="rPH" property="pgRefresh" value="����"/>
<jsp:setProperty name="rPH" property="pgChinese" value="����"/>
<jsp:setProperty name="rPH" property="pgDescription" value="˵��"/>
<jsp:setProperty name="rPH" property="pgType" value="��̬"/>
<jsp:setProperty name="rPH" property="pgDefinition" value="����"/>
 
<jsp:setProperty name="rPH" property="pgASModelMainten" value="�۷��������ⲿ�ͺ�ά��"/>
<jsp:setProperty name="rPH" property="pgSalesModel" value="�ⲿ�ͺ�"/>
<jsp:setProperty name="rPH" property="pgLaunchDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgDisannulDate" value="ʧЧ����"/>
<jsp:setProperty name="rPH" property="pgProjHoldDate" value="��Ч����"/>
<jsp:setProperty name="rPH" property="pgASCodeEntry" value="�۷�����ά��"/>
<jsp:setProperty name="rPH" property="pgRegion" value="����"/>
<jsp:setProperty name="rPH" property="pgCodeClass" value="�������"/>

<jsp:setProperty name="rPH" property="pgASItemInput" value="�۷��ϼ�����"/>
<jsp:setProperty name="rPH" property="pgPartChDesc" value="�ϼ�����˵��"/>
<jsp:setProperty name="rPH" property="pgEnable" value="����"/>
<jsp:setProperty name="rPH" property="pgDisable" value="ͣ��"/>
<jsp:setProperty name="rPH" property="pgModelRef" value="���û���"/>
<jsp:setProperty name="rPH" property="pgItemLoc" value="�ϼ�λ��"/>

<jsp:setProperty name="rPH" property="pgASFaultSympInput" value="�۷�����/������������"/>
<jsp:setProperty name="rPH" property="pgFaultCode" value="���ϴ���"/>
<jsp:setProperty name="rPH" property="pgSymptomCode" value="��������"/>
<jsp:setProperty name="rPH" property="pgCodeDesc" value="����˵��"/>
<jsp:setProperty name="rPH" property="pgCodeChDesc" value="��������˵��"/>
<jsp:setProperty name="rPH" property="pgCUser" value="������Ա"/>
<jsp:setProperty name="rPH" property="pgCDate" value="��������"/>

<jsp:setProperty name="rPH" property="pgASResActInput" value="�۷�ά��ԭ��/��ʽ��������"/>
<jsp:setProperty name="rPH" property="pgActionCode" value="ά�޷�ʽ����"/>
<jsp:setProperty name="rPH" property="pgActionDesc" value="ά�޷�ʽ˵��"/>
<jsp:setProperty name="rPH" property="pgActionChDesc" value="ά�޷�ʽ����˵��"/>
<jsp:setProperty name="rPH" property="pgReasonCode" value="ά��ԭ�����"/>
<jsp:setProperty name="rPH" property="pgReasonDesc" value="ά��ԭ��˵��"/>
<jsp:setProperty name="rPH" property="pgReasonChDesc" value="ά��ԭ������˵��"/>

<jsp:setProperty name="rPH" property="pgASMLauStatusTitle" value="�۷����ϻ��ֹ���/����״̬"/>
<jsp:setProperty name="rPH" property="pgUpdateLaunch" value="���ø���"/>


<!--����Ϊ��������״̬ҳ���� -->
<jsp:setProperty name="rPH" property="pgProgressStsBar" value="������..."/>

<!--����Ϊ�������� -->
<jsp:setProperty name="rPH" property="pgReport" value="����"/>
<jsp:setProperty name="rPH" property="pgTransaction" value="�춯"/>
<jsp:setProperty name="rPH" property="pgLogQty" value="��¼��"/>
<jsp:setProperty name="rPH" property="pgRepair" value="ά��"/>
<jsp:setProperty name="rPH" property="pgProcess" value="����"/>
<jsp:setProperty name="rPH" property="pgNotInclude" value="����"/>
<jsp:setProperty name="rPH" property="pgRepCompleteRate" value="������"/>
<jsp:setProperty name="rPH" property="pgRepaired" value="��ά��"/>
<jsp:setProperty name="rPH" property="pgRepairing" value="ά�޴�����"/>
<jsp:setProperty name="rPH" property="pgRepGeneral" value="һ������"/>
<jsp:setProperty name="rPH" property="pgRepLvl1" value="һ��"/>
<jsp:setProperty name="rPH" property="pgRepLvl2" value="����"/>
<jsp:setProperty name="rPH" property="pgRepLvl3" value="����"/>
<jsp:setProperty name="rPH" property="pgRepLvl12" value="һ������"/>
<jsp:setProperty name="rPH" property="pgNorth" value="��"/>
<jsp:setProperty name="rPH" property="pgMiddle" value="��"/>
<jsp:setProperty name="rPH" property="pgSouth" value="��"/>
<jsp:setProperty name="rPH" property="pgAll" value="ȫ"/>
<jsp:setProperty name="rPH" property="pgArea" value="��"/>
<jsp:setProperty name="rPH" property="pgServiceCenter" value="�۷���"/>
<jsp:setProperty name="rPH" property="pgSubTotal" value="С��"/>
<jsp:setProperty name="rPH" property="pgLogModelPerm" value="��¼��������"/>
<jsp:setProperty name="rPH" property="pgPermutDetail" value="������ϸ"/>
<jsp:setProperty name="rPH" property="pgModelDetail" value="������ϸ"/>
<jsp:setProperty name="rPH" property="pgLvl12FinishTrendChart" value="һ������������������ͼ"/>
<jsp:setProperty name="rPH" property="pgLvl3FinishTrendChart" value="����������������ͼ"/>
<jsp:setProperty name="rPH" property="pgRepFinishTrendChart" value="��������ͼ"/>
<jsp:setProperty name="rPH" property="pgRepAreaSummaryReport" value="ά�ް������ϻ��ܱ�"/>


 <!-- ����ʿ� -->
<jsp:setProperty name="rPH" property="pgCase" value="����"/>
<jsp:setProperty name="rPH" property="pgRecords" value="��¼"/>
<jsp:setProperty name="rPH" property="pgTo" value="��"/>

<!-- ����ѯ�ʵ�����ʿ� -->
<jsp:setProperty name="rPH" property="pgSalesDRQ" value="ҵ����ѯ�ʵ�"/>
<jsp:setProperty name="rPH" property="pgQDocNo" value="ѯ�ʵ���"/>
<jsp:setProperty name="rPH" property="pgSalesArea" value="ҵ�������"/>
<jsp:setProperty name="rPH" property="pgCustInfo" value="�ͻ���Ϣ"/>
<jsp:setProperty name="rPH" property="pgSalesMan" value="ҵ����Ա"/>
<jsp:setProperty name="rPH" property="pgInvItem" value="�ͺ�"/>
<jsp:setProperty name="rPH" property="pgDeliveryDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgSalesOrderNo" value="���۶�����"/>
<jsp:setProperty name="rPH" property="pgCustPONo" value="�ͻ���������"/>
<jsp:setProperty name="rPH" property="pgCurr" value="�ұ�"/>
<jsp:setProperty name="rPH" property="pgPreOrderType" value="Ԥ�ƶ�������"/>
<jsp:setProperty name="rPH" property="pgProcessUser" value="������Ա"/>
<jsp:setProperty name="rPH" property="pgProcessDate" value="��������"/>
<jsp:setProperty name="rPH" property="pgProcessTime" value="����ʱ��"/>
<jsp:setProperty name="rPH" property="pgDRQInputPage" value="����ҳ��"/>
<jsp:setProperty name="rPH" property="pgProdManufactory" value="Ԥ��������"/>


