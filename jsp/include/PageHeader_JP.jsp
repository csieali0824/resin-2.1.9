<%@ page contentType="text/html; charset=MS932" pageEncoding="euc-jp" %>
<meta http-equiv="Content-Type" content="text/html; charset=MS932">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name ="rPH" property ="pgHOME" value ="��²�ե����ȥ�-��"/>
<jsp:setProperty name ="rPH" property ="pgAllRepLog" value ="�䤤��碌���٤Ƥ��佤�ʾٻ���"/>
<jsp:setProperty name ="rPH" property ="pgTxLog" value ="�佤�����ư��Ͽ����"/>
<jsp:setProperty name ="rPH" property ="pgAddWKF" value ="���������ä���ή��"/>
<jsp:setProperty name ="rPH" property ="pgRemark" value ="��"/>

<jsp:setProperty name ="rPH" property ="pgFormID" value ="ή������ñ���̤���"/>
<jsp:setProperty name ="rPH" property ="pgWKFTypeNo" value ="ή�������ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgOriStat" value ="����Ū����"/>
<jsp:setProperty name ="rPH" property ="pgAction" value ="�»ܤ���ư��"/>
<jsp:setProperty name ="rPH" property ="pgChgStat" value ="��ư���뤢�Ⱦ���"/>
<jsp:setProperty name ="rPH" property ="pgWKFDESC" value ="ή����������"/>

<!--���ϥ�-���̤β����ܥ���Ǥ���  -->
<jsp:setProperty name ="rPH" property ="pgSelectAll" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgCancelSelect" value ="���ä����򤹤�"/>
<jsp:setProperty name ="rPH" property ="pgPlsEnter" value ="���Ԥ��������"/>
<jsp:setProperty name ="rPH" property ="pgDelete" value ="�ý�����"/>
<jsp:setProperty name ="rPH" property ="pgSave" value ="��ʸ���ե��������¸����"/>
<jsp:setProperty name ="rPH" property ="pgAdd" value ="���������ä���"/>
<jsp:setProperty name ="rPH" property ="pgOK" value ="���ꤹ��"/>
<jsp:setProperty name ="rPH" property ="pgFetch" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgQuery" value ="�䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgSearch" value ="�ܤ�"/>
<jsp:setProperty name ="rPH" property ="pgExecute" value ="�»ܤ���"/>
<jsp:setProperty name ="rPH" property ="pgReset" value ="�⤦���٤���"/>

<!--���ٽ��-���̤���ؾ��� -->
<jsp:setProperty name ="rPH" property ="pgPage" value ="��-��"/>
<jsp:setProperty name ="rPH" property ="pgPages" value ="��-��"/>
<jsp:setProperty name ="rPH" property ="pgFirst" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgLast" value ="�Ǹ��"/>
<jsp:setProperty name ="rPH" property ="pgPrevious" value ="�������"/>
<jsp:setProperty name ="rPH" property ="pgNext" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgTheNo" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgTotal" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgRecord" value ="ɮ��Ͽ������"/>
<jsp:setProperty name ="rPH" property ="pgRPProcess" value ="�佤�����ʾٻ����������"/>
<jsp:setProperty name ="rPH" property ="pgAllRecords" value ="���٤Ƥε�Ͽ����"/>
<jsp:setProperty name ="rPH" property ="pgCode" value ="��-��"/>

<!--�����ʾٻ���Υ�-��-���佤����  -->
<jsp:setProperty name ="rPH" property ="pgRepTitle" value ="���ʵ�ǽ�佤���դ�"/>
<jsp:setProperty name ="rPH" property ="pgRepNote" value ="���äȤ���˼ꤹ��ϰ��֤�������ǡ����ҵͤᤳ��ǲ���������ػ���"/>
<jsp:setProperty name ="rPH" property ="pgRepCenter" value ="�佤��ʸ����"/>
<jsp:setProperty name ="rPH" property ="pgAgent" value ="�輡���䤹��/����-����륨-�������"/>
<jsp:setProperty name ="rPH" property ="pgRecDate" value ="���������Ƥ����"/>
<jsp:setProperty name ="rPH" property ="pgRecCenter" value ="���������Ƥ뵡��"/>
<jsp:setProperty name ="rPH" property ="pgRecPerson" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgCustomer" value ="�ܵ�̾��"/>
<jsp:setProperty name ="rPH" property ="pgTEL" value ="Ϣ������"/>
<jsp:setProperty name ="rPH" property ="pgCell" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgAddr" value ="���ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgZIP" value ="͹���ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgBuyingPlace" value ="�㤦����"/>
<jsp:setProperty name ="rPH" property ="pgBuyingDate" value ="�㤦����"/>
<jsp:setProperty name ="rPH" property ="pgSvrDocNo" value ="��-�ӥ��������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgPart" value ="��¬�����"/>
<jsp:setProperty name ="rPH" property ="pgPartDesc" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgModel" value ="���ʥ�����"/>
<jsp:setProperty name ="rPH" property ="pgColor" value ="�������ÿ�"/>
<jsp:setProperty name ="rPH" property ="pgIMEI" value ="IMEI�����"/>
<jsp:setProperty name ="rPH" property ="pgDSN" value ="���ʽ����"/>
<jsp:setProperty name ="rPH" property ="pgRecItem" value ="���������Ƥ����"/>
<jsp:setProperty name ="rPH" property ="pgJam" value ="�ξ���������"/>
<jsp:setProperty name ="rPH" property ="pgOtherJam" value ="�ۤ��θξ���������"/>
<jsp:setProperty name ="rPH" property ="pgFreq" value ="�ξ�����"/>
<jsp:setProperty name ="rPH" property ="pgWarranty" value ="�ݾڤ����������"/>
<jsp:setProperty name ="rPH" property ="pgValid" value ="�ݾڤ���ʤ�"/>
<jsp:setProperty name ="rPH" property ="pgInvalid" value ="�ݾڤ��볰��"/>
<jsp:setProperty name ="rPH" property ="pgWarrNo" value ="�ݾڤ���ƻ���-�ɹ�"/>
<jsp:setProperty name ="rPH" property ="pgSvrType" value ="��-�ӥ������෿"/>
<jsp:setProperty name ="rPH" property ="pgRepStatus" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgRepNo" value ="�ʾٻ����ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgRecItem2" value ="���Ȥ������佤������������Ƥ����"/>
<jsp:setProperty name ="rPH" property ="pgWarranty2" value ="Ƚ�ꤹ�뤢���ݾڤ����������"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl" value ="�佤��������"/>
<jsp:setProperty name ="rPH" property ="pgRepHistory" value ="�佤������˵�Ͽ"/>
<jsp:setProperty name ="rPH" property ="pgDOAPVerify" value ="DOA /DAPȽ�ꤹ��Ȥ������٤�"/>
<jsp:setProperty name ="rPH" property ="pgPreRPAct" value ="���̤��佤������ˡ"/>
<jsp:setProperty name ="rPH" property ="pgActualRPAct" value ="�����佤������ˡ"/>
<jsp:setProperty name ="rPH" property ="pgSoftwareVer" value ="���եȥ���������"/>
<jsp:setProperty name ="rPH" property ="pgChgIMEI" value ="�������IMEI"/>
<jsp:setProperty name ="rPH" property ="pgActualRPDesc" value ="�º�Ū�佤��������"/>
<jsp:setProperty name ="rPH" property ="pgPreUseMaterial" value ="���̤��佤������䤹��¬����"/>
<jsp:setProperty name ="rPH" property ="pgUseMaterial" value ="�佤������䤹��¬����"/>
<jsp:setProperty name ="rPH" property ="pgRPReason" value ="�佤������ܤ��뤤��ʬ����������"/>
<jsp:setProperty name ="rPH" property ="pgQuotation" value ="���ե�-�������ѹ���"/>
<jsp:setProperty name ="rPH" property ="pgRPCost" value ="�佤��������"/>
<jsp:setProperty name ="rPH" property ="pgPartCost" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgTransCost" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgOtherCost" value ="�ۤ�������"/>
<jsp:setProperty name ="rPH" property ="pgExecutor" value ="ư��»ܼ�"/>
<jsp:setProperty name ="rPH" property ="pgExeTime" value ="�»ܤ������"/>
<jsp:setProperty name ="rPH" property ="pgAssignTo" value ="Ǥ̾���륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgRepPerson" value ="��-�ӥ��ޥ�"/>
<jsp:setProperty name ="rPH" property ="pgTransferTo" value ="�֤�����佤��ž�ܤ�����ʸ����ȴ�˾����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgMailNotice" value ="e-Mail�Τ餻��"/>
<jsp:setProperty name ="rPH" property ="pgWorkTime" value ="ʿ��ϫư����"/>
<jsp:setProperty name ="rPH" property ="pgWorkTimeMsg" value ="����/����"/>
<jsp:setProperty name ="rPH" property ="pgLotNo" value ="�ٸ��ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgSymptom" value ="�ξ��¾�"/>
<jsp:setProperty name ="rPH" property ="pgRecType" value ="���������Ƥ�н귿��"/>
<jsp:setProperty name ="rPH" property ="pgPCBA" value ="���ä�����"/>
<jsp:setProperty name ="rPH" property ="pgRepeatRepInput" value ="�ִ��¤�⤦����ʤ�ä��Ϥ��ƥ�-���̤������Ȥ����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgWarrLimit" value ="�ݾڤ�����״���"/>

<!--���Ͻ�������ˤ��ʾٻ���Υ�-��-���佤����  -->
<jsp:setProperty name ="rPH" property ="pgAddMaterial" value ="���򤹤��佤��¬����"/>
<jsp:setProperty name ="rPH" property ="pgSituation" value ="���ä����ޤ��Ƴ�ǧ�������"/>
<jsp:setProperty name ="rPH" property ="pgSituationMsg" value ="�֤⤷�ʤ�ƥ��ե�-��������󤵤�ƽ������ɬ�פ������"/>

<!--�ҤΥ�����ɥ��ˤĤ��Ƥξ��� -->
<jsp:setProperty name ="rPH" property ="pgRelevantInfo" value ="��ؾ���"/>
<jsp:setProperty name ="rPH" property ="pgEnterCustIMEI" value ="�ּ����������̾�����뤤��IMEI����ι���Ԥ���ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgSearchByAgency" value ="�����輡���侦/����-����륨-��������䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgSearchByCustIMEI" value ="���������/IMEI�䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgEnterAgency" value ="���Ԥ��������輡���侦/����-����륨-�������̾��"/>
<jsp:setProperty name ="rPH" property ="pgInputPart" value ="ž������˿�¬����������"/>
<jsp:setProperty name ="rPH" property ="pgChoosePart" value ="ž������˿�¬��������򤹤�"/>
<jsp:setProperty name ="rPH" property ="pgQty" value ="����"/>

<!--JavaScript����ηٹ�ʸ�ζ� -->
<jsp:setProperty name ="rPH" property ="pgAlertAction" value ="�ޤ����ʤ����»ܤ�����ư��Τ��ȤǤޤ���ʸ���ե��������¸�������Ȥ����򤷤Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertModel" value ="�ޤ�MODEL�����򤷤����Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertSvrDocNo" value ="�ޤ���-�ӥ��δ���ֹ��ͤᤳ������Ȥ���˸�ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertCustomer" value ="�ޤ����������ͤᤳ������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertSvrType" value ="�ޤ��������ʸ���෿������줿���Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertJam" value ="�ޤ��ξ������������������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertIMEI" value ="���η������ä�IMEI����ι������Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertCancel" value ="���ʤ���CANCEL���ۤ����ä��ȳ��ꤷ�ޤ������� ?" />
<jsp:setProperty name ="rPH" property ="pgAlertAssign" value ="�ޤ����ʤ���Ǥ̾���������Ϥ����򤷤Ƥ������������Ȥ����Submit�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertSubmit" value ="�ޤ����ʤ��»ܤ�����ư��Ȥ����Submit�����򤷤Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRepLvl" value ="�ޤ��ͤᤳ���������佤���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertLvl3" value ="���佤�����餬3�顤����(TRANSMIT)�˽��ꤪ����ǲ��������ʤ�����᤿�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertNonLvl3" value ="���佤�����餬3�顤����(TRANSMIT)�˽��ꤪ����ɬ�פ����뤢�ʤ�����᤿�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertReassign" value ="�⤦����Ǥ̾���븶����ޤ������������ߤ�Ƥޤ���Ƥ⤦����"��REASSIGN��"��Ǥ̾���롪 !" />
<jsp:setProperty name ="rPH" property ="pgAlertTransfer" value ="����ä�ž�ܤ����佤��ޤ����ꤵ��ƴ�˾���뤿���Ȥޤ�ž�ܤ���"��TRANSFER��"�ʤ��Ȥ� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRecItem2" value ="���äȤۤ����ä����󤷤����줿���Ȥ����ä��佤���ƹ��ܤ����Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertSoftVer" value ="���ʤ������򤷤��佤����ˡ�ˤ�äơ��ޤ����եȥ��������ܤ�ͤᤳ������Ȥޤ������ʾٻ���������Ƥ���������" />
<jsp:setProperty name ="rPH" property ="pgAlertChgIMEI" value ="���ʤ��佤���򤷤���ˡ�ˤ�äƤޤ��ͤᤳ��Ʋ����IMEI�Τ��Ȥޤ������ʾٻ����������ǲ�������" />
<jsp:setProperty name ="rPH" property ="pgAlertWorkTime" value ="�ּº�Ū�˴�������ϫư���֤򤢤ʤ���������"�ֵ��ؤϻ��ַ׻������"��������"/>
<jsp:setProperty name ="rPH" property ="pgAlertRPMaterial" value ="���ʤ������򤷤��佤����ˡ���б��������ޤ����򤷤��佤���Ƥ��¬���Ƥ������������Ȥ����SubmitI�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRPReason" value ="�������򤵤�Ƥ⤦�����ɸ�����Ʋ�����/���ϥ�-�����य��Ƥ����"��Set��"���Ȥˤ����Submit����ꤹ�롪 !" />
<jsp:setProperty name ="rPH" property ="pgAlertRPAction" value ="�������򤷤Ƽº�Ū����ˡ���佤���Ʋ��������Ȥ����Submit�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertSymptom" value ="���Ҹξ�����̤�ħ�����򤷤Ʋ��������Ȥ����Submit�� !" />
<jsp:setProperty name ="rPH" property ="pgAlertQty" value ="�ޤ����ʤ���ͤᤳ��Ǽº�Ū�ˤ�������̤Τ��ȤǤޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertItemNo" value ="�ޤ� BPCS�ο��¤�ͤᤳ��ǹ���¬�������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgErrorQty" value ="�ޤ����̤����������Ȥޤ���ʸ���ե��������¸���Ƥ�������Handset���뤤��PCB��Ĥν��դ�1�Ĥ����� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRecType" value ="�ޤ�Ŭ��Ū�ʽн�η��η����������򤷤����Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertDOAPIMEI" value ="���ʤ������򤷤���-�ӥ����෿��DOA / DAP�����顤�ޤ�������IMEI��ͤᤳ��Ǥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertChgSvrType" value ="��-�ӥ����෿����᤿�����ȳ��ꤷ�ޤ�������" />
<jsp:setProperty name ="rPH" property ="pgAlertPcba" value ="�ޤ����ä������Ĥο��¤�ͤᤳ��ǹ���¬�������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertMOGenSubmit" value ="���ʤ�����ʸ���������������ȳ��ꤷ�ޤ������� ?" />
<jsp:setProperty name ="rPH" property ="pgAlertPriceList" value ="�ץ饤���ꥹ�ȤΤ��ȼ��������򤷤Ƥ����ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertShipAddress" value ="�ޤ����ʤΥ��ɥ쥹������Ф������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertBillAddress" value ="���ꥢ�ɥ쥹�Τ���Ω�ä����Ȥ����򤷤Ƥ����ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertPayTerm" value ="�ޤ��٤Ϥ餤�������򤷤����Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertFOB" value ="�ޤ�FOB�����򤷤����Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertShipMethod" value ="�ޤ����ʤ���ˡ������Ф������Ȥޤ���ʸ���ե��������¸���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertCheckLineFlag" value ="�ޤ����򤷤Ƥ��Τʤ��˥ڥ�ι��ܤΤ��ȤǤޤ���ʸ���ե��������¸���롪 !" />
<jsp:setProperty name ="rPH" property ="pgAlertCreateDRQ" value ="���߽Ф��ƴ��¤��Ϥ��ư�ͤΤ������ȳ�ǧ���ޤ������� \n �⤷��˾�����¤�����Ƹ�ʸ��¸����ä���TEMPORARY���ޤ���ʸ���ե��������¸�������Ȥ����򤷤Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertReProcessMsg" value ="����³�����ξ�ɼ��������ޤ������� ?" />
<jsp:setProperty name ="rPH" property ="pgAlertShipBillMsg" value ="���Τ򸡺�����Ƽ����ΤϾ��ʤ��Ф�/Ω�Ĵ�����Ͼ��� ! \n �����Ϥ��ʤ������ꤷ�����Ȥ��դ��ʤ��Ǥ� {��Ǥ��� }����/���Ƥ��꤬Ω�ġ������⤦���ٷ��ꤢ�ʤ��Ϥ�������� \n                    ����ʤ�����ʸ���θ���������������Ȥ��褷�䤹���ä��� !" />
<jsp:setProperty name ="rPH" property ="pgAlertItemOrgAssignMsg" value ="��ɼ�����ٽ�����񤽤줬�����ֹ�򥢥�󥸤������Ȥ���ꤷ�ʤ��ä��Ǥ��� ! \n ����-���ܾ����ֹ�˵����ۤäƤ��뤤�����̤�����إ����åդϳ��ꤷ�ƾ����ֹ�ϥ���󥸤���Ǥ̾�������������� ! \n(���Ф������򤹤���ʸ���෿)"/>
<jsp:setProperty name ="rPH" property ="pgAlertItemExistsMsg" value ="��ʸ���������������ٽ������Oracle�����ξ����ֹ�\ n��¸�ߤ��ʤ��ä�     ���̤�����إ����åդϾ����ֹ椬�⤦�Ǥ����Ƥ��ȳ�ǧ���Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRFQCreateMsg" value ="��̳�ϴ��¤��Ϥ��ư�ͤο������⤦���ټ��Ԥ����Ȥ����ޤ����� ! ,\n �Ȳ񤷤ƾ������ϸ�����Ĵ�٤����餫�ˤ��Ƥ��������ޤ��Ϥ⤦����ʤ�ä�����ʤ��Ƥ���������󤷤��Ȥ������Ȥ����򤷤ޤ����� !" />
<jsp:setProperty name ="rPH" property ="pgAlertRFQCreateDtlMsg" value ="���ζ�̳�ϴ��¤��Ϥ��Ƥ������٤ιब�ʤ��Ȥ����ޤ����� ! ,\n �����Υ���ȥ�-������̤��Ƥ��������ޤ��Ϥ⤦����ʤ�ä�����ʤ��Ƥ����������Ǹ�����Ĵ�٤����餫�ˤ����Ȥ������Ȥ����򤷤ޤ����� !" />

<!--submit�Τ��Ȥ��󼨤ζ�Ǥ��� -->
<jsp:setProperty name ="rPH" property ="pgFreqReturn" value ="ľ�������"/>
<jsp:setProperty name ="rPH" property ="pgFreqReject" value ="�य����������"/>

<!--��-���̤�ž������Ķ���Ʒ�Ӥ��Ĥʤ��ä� -->
<jsp:setProperty name ="rPH" property ="pgPageAddRMA" value ="�ֿ����������ä�����佤����Ƶ�Ͽ����������Ƥ��"/>
<jsp:setProperty name ="rPH" property ="pgPage3AddRMA" value ="���������ä���ƻ�����佤������������Ƥ뵭Ͽ"/>
<jsp:setProperty name ="rPH" property ="pgPageAssign" value ="��ϫư�ԤϤ����ä��ʾٻ�����佤����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgPage3Assign" value ="�ֻ���Ϻ���������ϫư�ԤϤ�������ʾٻ�����佤�����"/>

<!--Send Mail������ -->
<jsp:setProperty name ="rPH" property ="pgMailSubjectAssign" value ="��������佤������Ǥ̾����"/>

<!--�֤��ư�ͤ����Ƥ��̾���Ƽ�����ä� -->
<jsp:setProperty name ="rPH" property ="pgCustReceipt" value ="���佤����̣���ư�ͤΤˤ��֤���ƽ�̾���Ƽ������ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgTransList" value ="���Ȥ������佤��ʪ���ٽ�"/>
<jsp:setProperty name ="rPH" property ="pgTransDate" value ="���Ȥ��������"/>
<jsp:setProperty name ="rPH" property ="pgListNo" value ="���ٽ��ֹ��Ĥ���(�ٸ��ֹ�)"/>
<jsp:setProperty name ="rPH" property ="pgReceiptNo" value ="��̾���Ƽ���������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgShipDate" value ="���ʴ���"/>
<jsp:setProperty name ="rPH" property ="pgShipper" value ="��Ǥ��"/>
<jsp:setProperty name ="rPH" property ="pgCustSign" value ="������̾���Ƽ������"/>
<jsp:setProperty name ="rPH" property ="pgPSMessage1" value ="в����˼�����ä��佤����̣�ä��٤줿�ʤ��ä����ȼ����ǽ���̾���Ƽ�����äƥ����󤷤ƥ꥿-��?�ѥ������ȳ�ǧ���Ƥ�餤�ޤ����� �˥ե���������"/>
<jsp:setProperty name ="rPH" property ="pgPSMessage2" value ="���Ȥ��Фɤ�����꤬���Ϣ�������Ȥ��Ԥ��ޤ����� Ϣ������"/>
<jsp:setProperty name ="rPH" property ="pgWarnMessage" value ="�ܼҤ����ۤ����뤿���ɸ�ष�ơ�3 ���Τ����˥꥿-��?�ѥ����ʤ��ä����Ƥ⤦������뤿�� �⤷����������ʤ�Ƥǲ������Ƶ��ؼ�ʬ����Ǥ���餦�ޤ���"/>

<!--���ˤ��ư�ͤ����Ƥ��̾���Ƽ�����ä� -->
<jsp:setProperty name ="rPH" property ="pgInStockLotList" value ="DOA / DAP�������佤����ޤ������ˤ�����դ�"/>
<jsp:setProperty name ="rPH" property ="pgInStockNo" value ="���ˤ������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgInStockDate" value ="���ˤ������"/>
<jsp:setProperty name ="rPH" property ="pgInStocker" value ="���ˤ��륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgWarehouserSign" value ="�Ҹ˥����åս�̾���Ƽ������"/>

<!--�佤����ή���Ͻ����������Ⱦ������ -->
<jsp:setProperty name ="rPH" property ="pgPrintCustReceipt" value ="����������佤����ʤ��Ȥ��¤֤ޤ�̣�����֤��ϰ�ͤΤ˽�̾���Ƽ������"/>
<jsp:setProperty name ="rPH" property ="pgPrintShippedConfirm" value ="����Υ����RMA�ξ��ʳ�ǧ����"/>
<jsp:setProperty name ="rPH" property ="pgRepairProcess" value ="�����佤��������ή��"/>
<jsp:setProperty name ="rPH" property ="pgDOAProcess" value ="DOA��������ή��"/>
<jsp:setProperty name ="rPH" property ="pgDAPProcess" value ="DAP��������ή��"/>

<!--���ӤϿ���ñ���¬���� -->
<jsp:setProperty name ="rPH" property ="pgMaterialRequest" value ="���¬���뿽��ñ"/>
<jsp:setProperty name ="rPH" property ="pgTransType" value ="��ư�෿"/>
<jsp:setProperty name ="rPH" property ="pgConReg" value ="��̾/�϶�"/>
<jsp:setProperty name ="rPH" property ="pgDocNo" value ="��ɼ�ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgWarehouseNo" value ="�����̤��"/>
<jsp:setProperty name ="rPH" property ="pgLocation" value ="�ߤ������"/>
<jsp:setProperty name ="rPH" property ="pgPersonal" value ="�Ŀ�"/>
<jsp:setProperty name ="rPH" property ="pgInvTransInput" value ="�߸��ʰ�ư�����"/>
<jsp:setProperty name ="rPH" property ="pgInvTransQuery" value ="�߸��ʰ�ư�䤤��碌��"/>

<jsp:setProperty name ="rPH" property ="pgAllMRLog" value ="�֤��٤ƤΤ��䤤��碌�������ʾٻ�����¬����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgAlertMRReason" value ="���Ӥ��Ԥ���Ƽ�������ƿ�¬����ޤ�����"/>
<jsp:setProperty name ="rPH" property ="pgAlertMRChoose" value ="�ޤ����򤷤�Ƥ��ʤ��Ͽ����Τ��˾����ޤ����ϤϤΤ��ȤˤϤޤ���ʸ���ե��������¸����"/>
<jsp:setProperty name ="rPH" property ="pgApDate" value ="�����Ф����"/>
<jsp:setProperty name ="rPH" property ="pgApplicant" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgMRReason" value ="���¬���븶��"/>
<jsp:setProperty name ="rPH" property ="pgInvMagProcess" value ="���ȥå�����ȥ�-�����"/>
<jsp:setProperty name ="rPH" property ="pgMRProcess" value ="���¬�����ʾٻ����������"/>
<jsp:setProperty name ="rPH" property ="pgApplyPart" value ="������¬����"/>
<jsp:setProperty name ="rPH" property ="pgReceivePart" value ="�������¬����"/>
<jsp:setProperty name ="rPH" property ="pgMRDesc" value ="��¬�������������"/>
<jsp:setProperty name ="rPH" property ="pgProvdTime" value ="ȯ��¬�������"/>

<jsp:setProperty name ="rPH" property ="pgMRR" value ="��¬�����֤�����ñ"/>
<jsp:setProperty name ="rPH" property ="pgReturnPart" value ="�ִԿ�¬����"/>
<jsp:setProperty name ="rPH" property ="pgOriWhs" value ="��Ȥ�ȵ�°���뤯���̤��"/>
<jsp:setProperty name ="rPH" property ="pgAlertApplicant" value ="�ޤ������ͤ����򤷤Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgTransReason" value ="��ư����"/>
<jsp:setProperty name ="rPH" property ="pgMAR" value ="��¬����ž������ñ"/>
<jsp:setProperty name ="rPH" property ="pgAllotPart" value ="ž����¬����"/>
<jsp:setProperty name ="rPH" property ="pgAllottee" value ="Ĵ�����륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgAlertAllottee" value ="�ޤ����Ӥϥ����åդ�Ĵ������Ƥ��������� !" />
<jsp:setProperty name ="rPH" property ="pgAlertTransReason" value ="�ޤ���ư�θ��������򤷤Ƥ��������� !" />

<!--�߸��ʤΰ�ư -->
<!--����DOA / DAP��-��-�Ǥ��� -->
<jsp:setProperty name ="rPH" property ="pgVeriSvrType" value ="Ƚ�ꤹ�륵-�ӥ������෿"/>
<jsp:setProperty name ="rPH" property ="pgVerifyStandard" value ="DOA /DAPȽ�ꤹ��ɸ��"/>

<!--�佤���ƺ����λȤ��δ������䤷��BPCS(���٤��¬�����ä�)�����ä�  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByItem" value ="�֤��佤�����BPCS(���٤��¬���뤳�Ȥ�ä�)������λȤ�����䤹��ƴ���������"/>
<jsp:setProperty name ="rPH" property ="pgBPCSInvQty" value ="BPCS�߸��ʿ���"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDate" value ="ȯ��¬�������"/>
<jsp:setProperty name ="rPH" property ="pgIssuePerson" value ="ȯ��¬���륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgTransComment" value ="��ư��ɼ"/>
<jsp:setProperty name ="rPH" property ="pgBalanceQty" value ="�����ڤ�Ĥ����"/>

<!--�佤���ƺ����λȤ��δ������䤷��BPCS������(���Ӥ�äƴ���ֹ���¬����)  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByMRequest" value ="�֤δ��������λȤ�����䤹�������BPCS"�֤��Ӥ�äƴ���ֹ���¬�����"���佤����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgCheckItem" value ="���򤹤�"/>
<jsp:setProperty name ="rPH" property ="pgPreparePost2BPCS" value ="�ڥ�����Ԥĵ�Ģ����BPCS"/>

<!--�佤���ƺ����λȤ��δ������䤷��BPCS������(��-�ӥ����󥸥˥�򤿤��)  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByRPEngineer" value ="�ִ��������BPCS"�֥�-�ӥ����󥸥˥�򤿤���"���佤���ƤϺ����λȤ�����䤹��"�Ǥ�/>
<jsp:setProperty name ="rPH" property ="pgRepairEngineer" value ="��-�ӥ����󥸥˥�"/>
<jsp:setProperty name ="rPH" property ="pgItemQty" value ="�֥ڥ�����ϤΤΤ��ʤ��������"�Ǥ�/>
<jsp:setProperty name ="rPH" property ="pgMRItemQty" value ="����"/>

<!--���ϥ���-����륨-�������/�輡���侦�λ����Ǥ��� -->
<jsp:setProperty name ="rPH" property ="pgInfo" value ="����Ū����"/>
<jsp:setProperty name ="rPH" property ="pgName" value ="̾��"/>
<jsp:setProperty name ="rPH" property ="pgNo" value ="�ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgDepend" value ="°�����佤������������Ƥ뵡��"/>
<jsp:setProperty name ="rPH" property ="pgContact" value ="Ϣ�����"/>
<jsp:setProperty name ="rPH" property ="pgFAX" value ="�ե��å���"/>
<jsp:setProperty name ="rPH" property ="pgKeyAccount" value ="�����輡���䤹��/����-����륨-�������"/>
<jsp:setProperty name ="rPH" property ="pgEdit" value ="�Խ���"/>

<!--���ϥ�-���̤λ������䤤��碌�� -->
<!--�佤����-�������⤦BPCS�䤤��碌�˵�Ģ���� -->
<jsp:setProperty name ="rPH" property ="pgCentPBpcsTitle" value ="�佤����-�����⤦��Ģ����BPCS�䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgPostDateFr" value ="��Ģ�������������"/>
<jsp:setProperty name ="rPH" property ="pgPostDateTo" value ="��Ģ�������ܤޤ�"/>
<jsp:setProperty name ="rPH" property ="pgPostDate" value ="��Ģ�������"/>
<jsp:setProperty name ="rPH" property ="pgBelPerson" value ="��°���륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgTransTime" value ="��ư����"/>
<jsp:setProperty name ="rPH" property ="pgExecPerson" value ="�»ܤ��륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgBPCSSerial" value ="BPCS�����"/>
<!--��ǥ���佤���Ʒ����䤷�ޤ�������ӥ������䤤��碌��¬���ޤ��� -->
<jsp:setProperty name ="rPH" property ="pgModelConsumeTitle" value ="�佤���ޤ���ǥ�η����䤹��Ƥ���ӥ������䤤��碌��ȿ�¬����ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgRpPartsCostTable" value ="�佤������䤹�����λȤ������ȥץ饤���ꥹ��"/>
<jsp:setProperty name ="rPH" property ="pgAnItem" value ="���ʤ���"/>
<jsp:setProperty name ="rPH" property ="pgPartsConsumQty" value ="��¬������䤹������"/>
<jsp:setProperty name ="rPH" property ="pgCostPrice" value ="�����Ȳ���"/>
<jsp:setProperty name ="rPH" property ="pgAccPartsPrice" value ="��¬������ʼ㤤�׻�����"/>
<jsp:setProperty name ="rPH" property ="pgGTotal" value ="��פ���"/>
<jsp:setProperty name ="rPH" property ="pgCostMainten" value ="�佤�����佤��������ɽ"/>
<jsp:setProperty name ="rPH" property ="pgRPQuantity" value ="�佤������"/>
<jsp:setProperty name ="rPH" property ="pgStdServiceFee" value ="ɸ���佤��/����"/>
<jsp:setProperty name ="rPH" property ="pgActServiceFee" value ="����Ū�佤��/����"/>
<jsp:setProperty name ="rPH" property ="pgModelFeeSubTotal" value ="��ǥ����Ѽ㤤�׻�����"/>
<!--��ξ�θ�����ʬ�ۤ����䤤��碌�Ǥ��� -->
<jsp:setProperty name ="rPH" property ="pgMonthFaultReasonTitle" value ="��ξ㸶��ʬ���䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgRate" value ="��Ψ"/>

<!--BPCS����Ȳ񤹤��䤤��碌���佤���Ƥ��Ӥϰ�ͤ�������Ģ�����ȿ�¬���� -->
<jsp:setProperty name ="rPH" property ="pgMaterialReqBPCSTitle" value ="�佤���뤯�ӤϿ�¬�����ͤ�������Ģ����BPCS�ϴ���Ȳ񤵤���䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDateFr" value ="�ۤäƴ������¬����  ������"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDateTo" value ="�ۤäƴ������¬����  �ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgMatRequestForm" value ="���¬�������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgRepairNo" value ="�佤�������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgDetail" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgBPCSNo" value ="BPCS����ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgBPCSDetail" value ="BPCS����"/>

<!--��-�ӥ����󥸥˥�Τ��ӤϿ�¬����/������̻������ۤ�ƿ�¬���뵪Ͽ�����䤤��碌 -->
<jsp:setProperty name ="rPH" property ="pgMaterialReqIssTitle" value ="��-�ӥ����󥸥˥�Τ��ӤϿ�¬����/������̻������ۤ��ƿ�¬�����Ƶ�Ͽ������䤤��碌��"/>

<!--���ӤϿ���ñ�������������Ȥ��¤���ȿ�¬���� -->
<jsp:setProperty name ="rPH" property ="pgMReqInquiryLink" value ="�絪Ͽ����ȿ�¬����ޤ���-�����䤤��碌��ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgYear" value ="ǯ"/>
<jsp:setProperty name ="rPH" property ="pgMonth" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgDay" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgS17DOAP" value ="S17����迷�������ʰ���ʪ�ʤ��괹����"/>
<jsp:setProperty name ="rPH" property ="pgS11MaterialReq" value ="S11�����������������¬����"/>
<jsp:setProperty name ="rPH" property ="pgS18WarrIn" value ="�����Ϥ򤯤Ӥ��佤��S18�Ϥ������ݾڤ���ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgS19WarrOut" value ="�����Ϥ򤯤Ӥ�S19�ϳ������佤���ݾڤ���ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgEmpNo" value ="���Ȱ��ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgDeptNo" value ="����̾��"/>
<jsp:setProperty name ="rPH" property ="pgAppDesc" value ="������������"/>
<jsp:setProperty name ="rPH" property ="pgItemDesc" value ="��̾"/>
<jsp:setProperty name ="rPH" property ="pgItemColor" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgAppQty" value ="�����Ф����"/>
<jsp:setProperty name ="rPH" property ="pgActQty" value ="�¿�"/>
<jsp:setProperty name ="rPH" property ="pgApproval" value ="�������Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgChief" value ="��ɤ���"/>
<jsp:setProperty name ="rPH" property ="pgTreasurer" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgPrintDate" value ="������������"/>

<!--�������äϾ����䤤��碌���������� -->
<jsp:setProperty name ="rPH" property ="pgMESMobileInf" value ="��������������������䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgProdDateFr" value ="�����������������"/>
<jsp:setProperty name ="rPH" property ="pgProdDateTo" value ="������������ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgSearchStr" value ="��IMEI��DSN�������ʤ����Ϥι桢���"/>
<jsp:setProperty name ="rPH" property ="pgMESSOrderNo" value ="��������ϫư�Դ���ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgProdItemNo" value ="�����ʿ�¬�����"/>
<jsp:setProperty name ="rPH" property ="pgMobileSoftware" value ="�������å��եȥ���������"/>
<jsp:setProperty name ="rPH" property ="pgLineName" value ="������̾��"/>
<jsp:setProperty name ="rPH" property ="pgStationName" value ="Ω����̾����"/>
<jsp:setProperty name ="rPH" property ="pgSOrderIn" value ="ϫư�Ԥ���������Ϥ�����"/>
<jsp:setProperty name ="rPH" property ="pgPackingDTime" value ="���������������"/>
<jsp:setProperty name ="rPH" property ="pgOperator" value ="��������Ͱ�"/>
<jsp:setProperty name ="rPH" property ="pgPMCC" value ="PMCC��-��"/>
<jsp:setProperty name ="rPH" property ="pgBPCSOrder" value ="BPCS ϫư�Դ���ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgTestBay" value ="��������ƥ���Ω��"/>
<jsp:setProperty name ="rPH" property ="pgCartonNo" value ="�ѥå��󥰥�-����"/>
<jsp:setProperty name ="rPH" property ="pgProductDetail" value ="��ɼ����"/>

<!--�輡���侦���������åץ�-�ɻ������䤤��碌�򤯤�ۤ����� -->
<jsp:setProperty name ="rPH" property ="pgAgentUpfileInf" value ="�輡���侦�������åץ�-�ɻ�������ۤ������䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgDateFr" value ="����  ������"/>
<jsp:setProperty name ="rPH" property ="pgDateTo" value ="����  �ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgAgentNo" value ="�輡���侦�ֹ��Ĥ���"/>
<jsp:setProperty name ="rPH" property ="pgTransmitFlag" value ="���Ȥ����뤫�ɤ���"/>
<jsp:setProperty name ="rPH" property ="pgChgIMEIFlag" value ="������IMEI���ꤹ��"/>

<!--�ʾٻ���λ������䤤��碌���佤����  -->
<jsp:setProperty name ="rPH" property ="pgRepairCaseInf" value ="�佤�ʾٻ�������䤤��碌��"/>
<jsp:setProperty name ="rPH" property ="pgTransOption" value ="���Ȥ�����/�佤������ʸ����ž�ܤ���"/>
<jsp:setProperty name ="rPH" property ="pgRetTimes" value ="ʤ������������"/>
<jsp:setProperty name ="rPH" property ="pgFinishStatus" value ="���ޤ������������"/>
<jsp:setProperty name ="rPH" property ="pgExcelButton" value =" Excel" />
<jsp:setProperty name ="rPH" property ="pgRecTime" value ="���������Ƥ����"/>
<jsp:setProperty name ="rPH" property ="pgFinishDate" value ="���ޤ������������"/>
<jsp:setProperty name ="rPH" property ="pgFinishTime" value ="���ޤ������������"/>
<jsp:setProperty name ="rPH" property ="pgRepMethod" value ="�佤������ˡ"/>
<jsp:setProperty name ="rPH" property ="pgLastMDate" value ="�Ǹ�����������"/>
<jsp:setProperty name ="rPH" property ="pgLastMPerson" value ="�Ǹ�������륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgRepPercent" value ="�佤������Ψ"/>
<jsp:setProperty name ="rPH" property ="pgNotFoundMsg" value ="���ܲ��ΤȤ�������ˤ�Ĵ�٤ƾ��λ�������פ�����䤤��碌��ʤ���"/>

<jsp:setProperty name ="rPH" property ="pgServiceLog" value ="��-�ӥ�"/>
<jsp:setProperty name ="rPH" property ="pgReturnLog" value ="���य"/>
<jsp:setProperty name ="rPH" property ="pgMobileRepair" value ="���������佤����"/>
<jsp:setProperty name ="rPH" property ="pgCType" value ="�෿"/>
<jsp:setProperty name ="rPH" property ="pgShipType" value ="����"/>

<!--���Υե����ȥ�-������ӥ����åդΤ���˻�����������ޤ���  -->
<jsp:setProperty name ="rPH" property ="pgMenuInstruction" value ="�佤��������������륭��ӥͥå�"/>
<jsp:setProperty name ="rPH" property ="pgDownload" value ="�������-�����"/>
<jsp:setProperty name ="rPH" property ="pgMenuGroup" value ="���Ѹ�ή����"/>
<jsp:setProperty name ="rPH" property ="pgChgPwd" value ="��������ѥ���-��"/>
<jsp:setProperty name ="rPH" property ="pgBulletin" value ="����/��������"/>
<jsp:setProperty name ="rPH" property ="pgLogin" value ="�Τܤ�����"/>
<jsp:setProperty name ="rPH" property ="pgLogout" value ="�кܤ���"/>
<jsp:setProperty name ="rPH" property ="pgMsgLicence" value ="�礭���Ƽ��Żҳ���ͭ�²���Ǹ���ͭ����"/>
<jsp:setProperty name ="rPH" property ="pgRole" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgList" value ="���ٽ�"/>
<jsp:setProperty name ="rPH" property ="pgNew" value ="���������ä���"/>
<jsp:setProperty name ="rPH" property ="pgRevise" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgDesc" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgSuccess" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgAccount" value ="�����å�"/>
<jsp:setProperty name ="rPH" property ="pgAccountWeb" value ="WEB���̥�-��"/>
<jsp:setProperty name ="rPH" property ="pgMail" value ="�Żҥ�-��"/>
<jsp:setProperty name ="rPH" property ="pgProfile" value ="���γ��ꤹ��"/>
<jsp:setProperty name ="rPH" property ="pgPasswd" value ="�ѥ���-��"/>
<jsp:setProperty name ="rPH" property ="pgLocale" value ="��̾"/>
<jsp:setProperty name ="rPH" property ="pgLanguage" value ="��²"/>
<jsp:setProperty name ="rPH" property ="pgModule" value ="�⥸��-��"/>
<jsp:setProperty name ="rPH" property ="pgSeq" value ="����¤٤��"/>
<jsp:setProperty name ="rPH" property ="pgFunction" value ="��ǽ"/>
<jsp:setProperty name ="rPH" property ="pgRoot" value ="��������դ�"/>
<jsp:setProperty name ="rPH" property ="pgHref" value ="�Ĥʤ��������ڤ륢�ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgAuthoriz" value ="�������Ǥ����"/>
<jsp:setProperty name ="rPH" property ="pgEmpID" value ="�����å�?�ʥ��-"/>
<jsp:setProperty name ="rPH" property ="pgRepReceive" value ="�佤��������Ȥ�"/>
<jsp:setProperty name ="rPH" property ="pgBasicInf" value ="����Ū����"/>
<jsp:setProperty name ="rPH" property ="pgFLName" value ="̾��"/>
<jsp:setProperty name ="rPH" property ="pgID" value ="�����ֹ�"/>

<!--���������Ǥ����Ƥ������������Ǥ���  -->
<jsp:setProperty name ="rPH" property ="pgBulletinNotice" value ="����/��������"/>
<jsp:setProperty name ="rPH" property ="pgPublishDate" value ="ȯɽ�������"/>
<jsp:setProperty name ="rPH" property ="pgPublisher" value ="ȯɽ�����"/>
<jsp:setProperty name ="rPH" property ="pgPublish" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgTopic" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgContent" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgClassOfTopic" value ="��-������"/>
<jsp:setProperty name ="rPH" property ="pgTopicOfDiscuss" value ="Ƥ�������-��"/>
<jsp:setProperty name ="rPH" property ="pgHits" value ="ȿ��������"/>
<jsp:setProperty name ="rPH" property ="pgNewTopic" value ="ȯɽ���뿷������-��"/>
<jsp:setProperty name ="rPH" property ="pgClass" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgResponse" value ="�֤�ʤ��"/>
<jsp:setProperty name ="rPH" property ="pgReturn" value ="����-��"/>
<jsp:setProperty name ="rPH" property ="pgRespond" value ="ȿ������"/>
<jsp:setProperty name ="rPH" property ="pgNewDiscuss" value ="ȯɽ���뿷������Ƥ����-��"/>
<jsp:setProperty name ="rPH" property ="pgUserResponse" value ="ȿ����������"/>
<jsp:setProperty name ="rPH" property ="pgTime" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgResponder" value ="ȿ����"/>
<jsp:setProperty name ="rPH" property ="pgInformation" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgDocument" value ="��ʸ��"/>

<!--������뤿��˺����ε�ǽ�λ�����ĤȤ�ޤ���  -->
<jsp:setProperty name ="rPH" property ="pgASMaterial" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgUpload" value ="�ܤ���"/>
<jsp:setProperty name ="rPH" property ="pgFile" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgCenter" value ="�濴"/>
<jsp:setProperty name ="rPH" property ="pgFormat" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgFollow" value ="�ǲ��������ޤ�˽���"/>
<jsp:setProperty name ="rPH" property ="pgBelow" value ="���ΤȤ����"/>
<jsp:setProperty name ="rPH" property ="pgAbove" value ="�ʾ�ΤȤ���"/>
<jsp:setProperty name ="rPH" property ="pgPreview" value ="���ä��ܤ��̤�"/>
<jsp:setProperty name ="rPH" property ="pgLevel" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgLaunch" value ="��ư����"/>
<jsp:setProperty name ="rPH" property ="pgSparePart" value ="��ʬ��"/>
<jsp:setProperty name ="rPH" property ="pgModelSeries" value ="��ǥ�"/>
<jsp:setProperty name ="rPH" property ="pgPicture" value ="�޷�"/>
<jsp:setProperty name ="rPH" property ="pgImage" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgInventory" value ="�߸���"/>
<jsp:setProperty name ="rPH" property ="pgLack" value ="����­"/>
<jsp:setProperty name ="rPH" property ="pgCalculate" value ="�׻�����"/>
<jsp:setProperty name ="rPH" property ="pgPrice" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgConsumer" value ="�����"/>
<jsp:setProperty name ="rPH" property ="pgRetailer" value ="Ź"/>
<jsp:setProperty name ="rPH" property ="pgASMAuthFailMsg" value ="���ߤޤ��� ���ʤ��ˤʤ�ƻ����򸢸¤Ϥ��Τ��䤤��碌��ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgASMInfo" value ="���ե�-?��-�ӥ���������"/>
<jsp:setProperty name ="rPH" property ="pgMOQ" value ="���־�������ʸ�������"/>
<jsp:setProperty name ="rPH" property ="pgSafeInv" value ="�����߸˿�����"/>
<jsp:setProperty name ="rPH" property ="pgCurrInv" value ="�ܲ��ΤȤ���߸��ʿ�����"/>
<jsp:setProperty name ="rPH" property ="pgFront" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgBack" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgAllASM" value ="�䤤��碌���٤Ƥ����������"/>

<jsp:setProperty name ="rPH" property ="pgChooseMdl" value ="���򤹤��ǥ�"/>
<jsp:setProperty name ="rPH" property ="pgASM _ EC" value ="���������EC"/>
<jsp:setProperty name ="rPH" property ="pgChange" value ="�ѹ�"/>
<jsp:setProperty name ="rPH" property ="pgNewPart4EC" value ="�ߵ���ѹ��Τ��줬���������Ϥι�"/>
<jsp:setProperty name ="rPH" property ="pgCurrModelRef" value ="���ԤλȤ����ǥ�"/>
<jsp:setProperty name ="rPH" property ="pgModelRefMsg" value ="��¬���뤿��˹���ѹ���������Ŭ�ѤΥ�ǥ���˹�碌�Ƥ��˾���뤪�������ֹ��ܤ���"/>
<jsp:setProperty name ="rPH" property ="pgDelImage" value ="�ý�����ͤ��륭��ӥͥå�"/>

<!--���Ͻ��������ǽ�λ����Ǥ���  -->
<jsp:setProperty name ="rPH" property ="pgAfterService" value ="���ĤȤ��"/>
<jsp:setProperty name ="rPH" property ="pgInput" value ="�����"/>
<jsp:setProperty name ="rPH" property ="pgMaintenance" value ="�ݤ�"/>
<jsp:setProperty name ="rPH" property ="pgRefresh" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgChinese" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgDescription" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgType" value ="�����׷�"/>
<jsp:setProperty name ="rPH" property ="pgDefinition" value ="�������"/>


<jsp:setProperty name ="rPH" property ="pgASModelMainten" value ="�֥�ǥ���⳰���Υ����������������ݤĤޤ���"/>
<jsp:setProperty name ="rPH" property ="pgSalesModel" value ="����������"/>
<jsp:setProperty name ="rPH" property ="pgLaunchDate" value ="�о����"/>
<jsp:setProperty name ="rPH" property ="pgDisannulDate" value ="�����������"/>
<jsp:setProperty name ="rPH" property ="pgProjHoldDate" value ="�Х��-��-��"/>

<jsp:setProperty name ="rPH" property ="pgASCodeEntry" value ="�������-���ݤ�"/>
<jsp:setProperty name ="rPH" property ="pgRegion" value ="�ϰ�"/>
<jsp:setProperty name ="rPH" property ="pgCodeClass" value ="��-������"/>

<jsp:setProperty name ="rPH" property ="pgASItemInput" value ="�������¬����͢��"/>
<jsp:setProperty name ="rPH" property ="pgPartChDesc" value ="��¬����������������"/>
<jsp:setProperty name ="rPH" property ="pgEnable" value ="���Ѥ��Ϥ��"/>
<jsp:setProperty name ="rPH" property ="pgDisable" value ="�ߤޤ����"/>
<jsp:setProperty name ="rPH" property ="pgModelRef" value ="�Ȥ����ǥ�"/>
<jsp:setProperty name ="rPH" property ="pgItemLoc" value ="��¬�������"/>

<jsp:setProperty name ="rPH" property ="pgASFaultSympInput" value ="�ָξ�/���̤�ħ�Υ�-����͢������äư����"/>
<jsp:setProperty name ="rPH" property ="pgFaultCode" value ="�ξ��-��"/>
<jsp:setProperty name ="rPH" property ="pgSymptomCode" value ="����ħ��-��"/>
<jsp:setProperty name ="rPH" property ="pgCodeDesc" value ="��-����������"/>
<jsp:setProperty name ="rPH" property ="pgCodeChDesc" value ="��-��������������"/>
<jsp:setProperty name ="rPH" property ="pgCUser" value ="�Ǥ����Ƥ륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgCDate" value ="�Ǥ����Ƥ����"/>

<jsp:setProperty name ="rPH" property ="pgASResActInput" value ="�⤦���٥�����/�����य�ޤ���-�������򤹤�"/>
<jsp:setProperty name ="rPH" property ="pgActionCode" value ="�佤������ˡ��-��"/>
<jsp:setProperty name ="rPH" property ="pgActionDesc" value ="�佤������ˡ��������"/>
<jsp:setProperty name ="rPH" property ="pgActionChDesc" value ="�佤������ˡ������������"/>
<jsp:setProperty name ="rPH" property ="pgReasonCode" value ="�佤���븶����-��"/>
<jsp:setProperty name ="rPH" property ="pgReasonDesc" value ="���य������������"/>
<jsp:setProperty name ="rPH" property ="pgReasonChDesc" value ="�佤���븶��������������"/>

<jsp:setProperty name ="rPH" property ="pgASMLauStatusTitle" value ="�����������ǥ��̾/���Ѥ��Ϥ�����"/>
<jsp:setProperty name ="rPH" property ="pgUpdateLaunch" value ="���Ѥ��Ϥ�빹��"/>


<!--���ϥץ��������֤Υ�-���λ����Ǥ���  -->
<jsp:setProperty name ="rPH" property ="pgProgressStsBar" value ="���������� ..." />

<!--�������ɽ�����Ǥ���  -->
<jsp:setProperty name ="rPH" property ="pgReport" value ="���ɽ"/>
<jsp:setProperty name ="rPH" property ="pgTransaction" value ="��ư"/>
<jsp:setProperty name ="rPH" property ="pgLogQty" value ="��Ͽ���������"/>
<jsp:setProperty name ="rPH" property ="pgRepair" value ="�佤����"/>
<jsp:setProperty name ="rPH" property ="pgProcess" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgNotInclude" value ="��ͭ����"/>
<jsp:setProperty name ="rPH" property ="pgRepCompleteRate" value ="����뽤��Ψ"/>
<jsp:setProperty name ="rPH" property ="pgRepaired" value ="�⤦�佤����"/>
<jsp:setProperty name ="rPH" property ="pgRepairing" value ="�佤���������"/>
<jsp:setProperty name ="rPH" property ="pgRepGeneral" value ="���̤����뽤������"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl1" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl2" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl3" value ="���ĵ�"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl12" value ="�졢���"/>
<jsp:setProperty name ="rPH" property ="pgNorth" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgMiddle" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgSouth" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgAll" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgArea" value ="�ϰ�"/>
<jsp:setProperty name ="rPH" property ="pgServiceCenter" value ="�������"/>
<jsp:setProperty name ="rPH" property ="pgSubTotal" value ="�������׻�����"/>
<jsp:setProperty name ="rPH" property ="pgLogModelPerm" value ="��Ͽ�����ǥ���"/>
<jsp:setProperty name ="rPH" property ="pgPermutDetail" value ="����¤٤�����"/>
<jsp:setProperty name ="rPH" property ="pgModelDetail" value ="��ǥ�����"/>
<jsp:setProperty name ="rPH" property ="pgLvl12FinishTrendChart" value ="�ְ졢���Ͽ���������ϰ�Ͻ���äƤ����ٶ������"/>
<jsp:setProperty name ="rPH" property ="pgLvl3FinishTrendChart" value ="�ֻ���ϳƳ���������ϰ�Ͻ���äƤ����ٶ�����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgRepFinishTrendChart" value ="���ޤ��ٶ����������"/>
<jsp:setProperty name ="rPH" property ="pgRepAreaSummaryReport" value ="�������ٽ�"/>


<!--¿��¿�ͤʥ�-�ɥХ�  -->
<jsp:setProperty name ="rPH" property ="pgCase" value ="�ʾٻ���"/>
<jsp:setProperty name ="rPH" property ="pgRecords" value ="��Ͽ����"/>
<jsp:setProperty name ="rPH" property ="pgTo" value ="�ޤ�"/>

<!--WINS��Ȥε�ǽ�Υ�-�ɥХ�  -->
<jsp:setProperty name =" pageHeader" property ="pgTitleName" value ="�������̽������פ��������।��ե�-��-����󥷥��ƥ�"/>
<jsp:setProperty name =" pageHeader" property ="pgSalesCode" value ="�Ծ쥵����"/>
<jsp:setProperty name =" pageHeader" property ="pgProjectCode" value ="���ä���������"/>
<jsp:setProperty name =" pageHeader" property ="pgProductType" value ="��������"/>
<jsp:setProperty name =" pageHeader" property ="pgBrand" value ="����"/>
<jsp:setProperty name =" pageHeader" property ="pgLength" value ="Ĺ��"/>
<jsp:setProperty name =" pageHeader" property ="pgWidth" value ="����"/>
<jsp:setProperty name =" pageHeader" property ="pgHeight" value ="�⤤"/>
<jsp:setProperty name =" pageHeader" property ="pgWeight" value ="����"/>

<jsp:setProperty name =" pageHeader" property ="pgLaunchDate" value ="�о����"/>
<jsp:setProperty name =" pageHeader" property ="pgDeLaunchDate" value ="�ߤ�Դ���"/>
<jsp:setProperty name =" pageHeader" property ="pgSize" value ="����"/>
<jsp:setProperty name =" pageHeader" property ="pgDisplay" value ="����"/>
<jsp:setProperty name =" pageHeader" property ="pgCamera" value ="�����"/>
<jsp:setProperty name =" pageHeader" property ="pgRingtone" value ="�����β�"/>
<jsp:setProperty name =" pageHeader" property ="pgPhonebook" value ="����Ģ"/>

<jsp:setProperty name =" pageHeader" property ="pgRemark" value ="��"/>

<!--start for common use -->
<jsp:setProperty name =" pageHeader" property ="pgHOME" value ="��²�ե����ȥ�-��"/>
<jsp:setProperty name =" pageHeader" property ="pgSelectAll" value ="��������"/>
<jsp:setProperty name =" pageHeader" property ="pgCancelSelect" value ="���ä����򤹤�"/>
<jsp:setProperty name =" pageHeader" property ="pgDelete" value ="�ý�����"/>
<jsp:setProperty name =" pageHeader" property ="pgSave" value ="��ʸ���ե��������¸����"/>
<jsp:setProperty name =" pageHeader" property ="pgAdd" value ="���������ä���"/>
<jsp:setProperty name =" pageHeader" property ="pgOK" value ="���ꤹ��"/>
<jsp:setProperty name =" pageHeader" property ="pgSearch" value ="�ܤ�"/>
<jsp:setProperty name =" pageHeader" property ="pgPlsEnter" value ="���Ԥ��������"/>
<!--end for common use -->

<!--start for page list -->
<jsp:setProperty name =" pageHeader" property ="pgPage" value ="��-��"/>
<jsp:setProperty name =" pageHeader" property ="pgPages" value ="��-��"/>
<jsp:setProperty name =" pageHeader" property ="pgFirst" value ="������"/>
<jsp:setProperty name =" pageHeader" property ="pgLast" value ="�Ǹ��"/>
<jsp:setProperty name =" pageHeader" property ="pgPrevious" value ="�������"/>
<jsp:setProperty name =" pageHeader" property ="pgNext" value ="����"/>
<jsp:setProperty name =" pageHeader" property ="pgTheNo" value ="��"/>
<jsp:setProperty name =" pageHeader" property ="pgTotal" value ="������"/>
<jsp:setProperty name =" pageHeader" property ="pgRecord" value ="ɮ��Ͽ������"/>
<!--end for page list -->

<!--start for account management -->
<jsp:setProperty name =" pageHeader" property ="pgChgPwd" value ="��������ѥ���-��"/>
<jsp:setProperty name =" pageHeader" property ="pgLogin" value ="�Τܤ�����"/>
<jsp:setProperty name =" pageHeader" property ="pgLogout" value ="�кܤ���"/>
<jsp:setProperty name =" pageHeader" property ="pgMsgLicence" value ="�礭���Ƽ��Żҳ���ͭ�²���Ǹ���ͭ����"/>
<jsp:setProperty name =" pageHeader" property ="pgRole" value ="��"/>
<jsp:setProperty name =" pageHeader" property ="pgList" value ="���ٽ�"/>
<jsp:setProperty name =" pageHeader" property ="pgNew" value ="���������ä���"/>
<jsp:setProperty name =" pageHeader" property ="pgRevise" value ="��������"/>
<jsp:setProperty name =" pageHeader" property ="pgDesc" value ="��������"/>
<jsp:setProperty name =" pageHeader" property ="pgSuccess" value ="��������"/>
<jsp:setProperty name =" pageHeader" property ="pgFail" value ="���Ԥ���"/>
<jsp:setProperty name =" pageHeader" property ="pgAccount" value ="�����å�"/>
<jsp:setProperty name =" pageHeader" property ="pgAccountWeb" value ="WEB���̥�-��"/>
<jsp:setProperty name =" pageHeader" property ="pgMail" value ="�Żҥ�-��"/>
<jsp:setProperty name =" pageHeader" property ="pgProfile" value ="���γ��ꤹ��"/>
<jsp:setProperty name =" pageHeader" property ="pgPasswd" value ="�ѥ���-��"/>
<jsp:setProperty name =" pageHeader" property ="pgLocale" value ="��̾"/>
<jsp:setProperty name =" pageHeader" property ="pgLanguage" value ="��²"/>
<jsp:setProperty name =" pageHeader" property ="pgModule" value ="�⥸��-��"/>
<jsp:setProperty name =" pageHeader" property ="pgSeq" value ="����¤٤��"/>
<jsp:setProperty name =" pageHeader" property ="pgFunction" value ="��ǽ"/>
<jsp:setProperty name =" pageHeader" property ="pgHref" value ="�Ĥʤ��������ڤ륢�ɥ쥹"/>
<jsp:setProperty name =" pageHeader" property ="pgRoot" value ="��������դ�"/>
<jsp:setProperty name =" pageHeader" property ="pgAuthoriz" value ="�������Ǥ����"/>
<jsp:setProperty name =" pageHeader" property ="pgID" value ="�����ֹ�"/>

<!--���¤��Ϥ��Ƥ�����-�ɥХ󥯤����줿�Ȥ�����  -->
<jsp:setProperty name ="rPH" property ="pgSalesDRQ" value ="��̳���Ϥ���Ϥ���ñ����"/>
<jsp:setProperty name ="rPH" property ="pgQDocNo" value ="��������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgSalesArea" value ="��̳�϶��̤��"/>
<jsp:setProperty name ="rPH" property ="pgCustInfo" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgSalesMan" value ="��̳��"/>
<jsp:setProperty name ="rPH" property ="pgInvItem" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgDeliveryDate" value ="��ʪ������"/>
<jsp:setProperty name ="rPH" property ="pgSalesOrderNo" value ="�����ʸ����"/>
<jsp:setProperty name ="rPH" property ="pgCustPONo" value ="�������ʸ�������ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgCurr" value ="��ʾ�̤��"/>
<jsp:setProperty name ="rPH" property ="pgPreOrderType" value ="���ۤ�����ʸ���෿"/>
<jsp:setProperty name ="rPH" property ="pgProcessUser" value ="�������륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgProcessDate" value ="�����������"/>
<jsp:setProperty name ="rPH" property ="pgProcessTime" value ="�ʼ�����"/>
<jsp:setProperty name ="rPH" property ="pgDRQInputPage" value ="������-����"/>
<jsp:setProperty name ="rPH" property ="pgProdManufactory" value ="ͽ�ꤹ�뻺��"/>
<jsp:setProperty name ="rPH" property ="pgDeptArea" value ="�϶�"/>
<jsp:setProperty name ="rPH" property ="pgNoBlankMsg" value ="���äȼꤹ��ϰ��֤������롤��������Ʋ�����"/>

<jsp:setProperty name ="rPH" property ="pgTSDRQNoHistory" value ="�Ϥ��ƹ�Ϥ����ޤ���ɼ�����ϵ�Ͽ����"/>
<jsp:setProperty name ="rPH" property ="pgCustNo" value ="�����ά��"/>
<jsp:setProperty name ="rPH" property ="pgCustomerName" value ="�����̾��"/>
<jsp:setProperty name ="rPH" property ="pgRequireReason" value ="�Ϥ����¼��׸�����������"/>
<jsp:setProperty name ="rPH" property ="pgProcessMark" value ="���٤ν�����������"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormUser" value ="�ޤ���դ������å�"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormDate" value ="�ޤ���դ�����"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormTime" value ="�ޤ���դ�����"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessUser" value ="�����֤ν������륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessDate" value ="�����֤ν����������"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessTime" value ="�����ʼ�����"/>
<jsp:setProperty name ="rPH" property ="pgProdTransferTo" value ="���ϰܤ�ž�ܤ���"/>
<jsp:setProperty name ="rPH" property ="pgDocTotAssignFac" value ="��ɼ���٤Ƥ�Ǥ̾���뻺��"/>
<jsp:setProperty name ="rPH" property ="pgDocAssignFac" value ="��Ȥ�ȹ�Ǥ̾���뻺��"/>
<jsp:setProperty name ="rPH" property ="pgDRQDocProcess" value ="�ִ��¤��䤤�礻�ξ�ɼ������ή�����Ϥ��ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgDRQInquiryReport" value ="���¤��Ϥ��Ƥ����ޤ����ɽ������䤤��碌���夯"/>
<jsp:setProperty name ="rPH" property ="pgSalesOrder" value ="�����ʸ��"/>
<jsp:setProperty name ="rPH" property ="pgFirmOrderType" value ="��ʸ���෿"/>
<jsp:setProperty name ="rPH" property ="pgIdentityCode" value ="����輱�̥�-��"/>
<jsp:setProperty name ="rPH" property ="pgSoldToOrg" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgPriceList" value ="�ץ饤���ꥹ��"/>
<jsp:setProperty name ="rPH" property ="pgShipToOrg" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgGenerateInf" value ="���ޤ�����"/>
<jsp:setProperty name ="rPH" property ="pgWait" value ="����-��"/>
<jsp:setProperty name ="rPH" property ="pgConfirm" value ="��ǧ����"/>
<jsp:setProperty name ="rPH" property ="pgTSCAlias" value ="��ۤ�Τ�����"/>
<jsp:setProperty name ="rPH" property ="pgOrderedItem" value ="�����ֹ�"/>
<jsp:setProperty name ="rPH" property ="pgOR" value ="�ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgBillTo" value ="Ω�Ĵ��ꥢ�ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgDeliverTo" value ="��ʪ���Ϥ����ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgPaymentTerm" value ="�٤Ϥ餤���"/>
<jsp:setProperty name ="rPH" property ="pgFOB" value =" FOB" />
<jsp:setProperty name ="rPH" property ="pgShippingMethod" value ="������ˡ"/>
<jsp:setProperty name ="rPH" property ="pgIntExtPurchase" value ="�ʤ�/�����㤦"/>
<jsp:setProperty name ="rPH" property ="pgPackClass" value ="����ʬ�ह��"/>
<jsp:setProperty name ="rPH" property ="pgKPC" value ="��(KPC)"/>
<jsp:setProperty name ="rPH" property ="pgUOM" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgNewRequestDate" value ="���餷��ͧ�������¼�����"/>
<jsp:setProperty name ="rPH" property ="pgTempDRQDoc" value ="��Ƹ�ʸ��"/>
<jsp:setProperty name ="rPH" property ="pgExceedValidDate" value ="�����ϴ��¤��Ϥ���ǧ���Ǳۤ����ƻ��Ȥ�����֤����4 ����ʤ���ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgMark" value ="���"/>
<jsp:setProperty name ="rPH" property ="pgDenote" value ="ɽ��"/>
<jsp:setProperty name ="rPH" property ="pgInvalidDoc" value ="���ξ�ɼ�⤦��������"/>
<jsp:setProperty name ="rPH" property ="pgProdPC" value ="�����Ϥ�Ƥ��ʤ��������륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgSalesPlanner" value ="������Ȥ��륹���å�"/>
<jsp:setProperty name ="rPH" property ="pgProdFactory" value ="�������빩��"/>
<jsp:setProperty name ="rPH" property ="pgSalesPlanDept" value ="������Ȥ����ϰ�"/>
<jsp:setProperty name ="rPH" property ="pgReAssign" value ="�⤦����Ǥ̾����"/>
<jsp:setProperty name ="rPH" property ="pgRequestDate" value ="�Ϥ����¼�����"/>
<jsp:setProperty name ="rPH" property ="pgFDeliveryDate" value ="������ʪ�μ��Ϥ���"/>
<jsp:setProperty name ="rPH" property ="pgReturnTWN" value ="����T"/>
<jsp:setProperty name ="rPH" property ="pgCustItemNo" value ="������¬�����"/>
<jsp:setProperty name ="rPH" property ="pgPCAssignDate" value ="�Ĥޤ��Ķ�ʬ�ɸ��������"/>
<jsp:setProperty name ="rPH" property ="pgFTArrangeDate" value ="�����¤٤��ʪ�μ��Ϥ���"/>
<jsp:setProperty name ="rPH" property ="pgPCConfirmDate" value ="���Ȥ����ǧ�����ʪ�μ��Ϥ���"/>
<jsp:setProperty name ="rPH" property ="pgOrdCreateDate" value ="��ʸ�������������"/>
<jsp:setProperty name ="rPH" property ="pgAlertSysNotAllowGen" value ="����������������������"/>
<jsp:setProperty name ="rPH" property ="pgReject" value ="���य"/>
<jsp:setProperty name ="rPH" property ="pgAbortToTempDRQ" value ="��Ȥν��դ����Ƥ����ޤ��ƿ��餷��ͧ�����δ��¤ϰ�ͤΤȤ���"/>
<jsp:setProperty name ="rPH" property ="pgChoice" value ="���򤹤�"/>
<jsp:setProperty name ="rPH" property ="pgAbortBefore" value ="�����������"/>
<jsp:setProperty name ="rPH" property ="pgSetup" value ="���ꤹ��"/>
<jsp:setProperty name ="rPH" property ="pgOrdCreate" value ="��ʸ����������"/>

<jsp:setProperty name ="rPH" property ="pgItemContent" value ="����"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessStatus" value ="���䤤�礻���֤򤿤������������٤Ρ�"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessSummary" value ="����������ֽ��ޤ봰��"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessing" value ="�ֽ���������ޤꤿ����"/>
<jsp:setProperty name ="rPH" property ="pgRFQDOCNoClosed" value ="�⤦���郎���뤹��"/>
<jsp:setProperty name ="rPH" property ="pgRFQCompleteRate" value ="����Ψ"/>
<jsp:setProperty name ="rPH" property ="pgSPCProcessSummary" value ="���Ȥ������������ֽ��ޤ봰��"/>
<jsp:setProperty name ="rPH" property ="pgFCTProcessSummary" value ="��������������ֽ��ޤ봰��"/>
<jsp:setProperty name ="rPH" property ="pgTTEW" value ="ŷ����Ĺ����Ҹ�"/>
<jsp:setProperty name ="rPH" property ="pgYYEW" value ="�ۿ���Ĺ����Ҹ�"/>
<jsp:setProperty name ="rPH" property ="pgIILAN" value ="�����߸���"/>
<jsp:setProperty name ="rPH" property ="pgSILAN" value ="����SKY"/>
<jsp:setProperty name ="rPH" property ="pgOILAN" value ="�������㤦"/>
<jsp:setProperty name ="rPH" property ="pgNTaipei" value ="NBU���㤦"/>
<jsp:setProperty name ="rPH" property ="pgRFQTemporary" value ="��Ƹ�ʸ��"/>
<jsp:setProperty name ="rPH" property ="pgRFQAssigning" value ="�Ĥޤ���ʬ���륿������"/>
<jsp:setProperty name ="rPH" property ="pgRFQEstimating" value ="�ֹ�򹩡����Ϥ����¤٤�ޤ����"/>
<jsp:setProperty name ="rPH" property ="pgRFQArrenged" value ="�����¤٤��Ԥĳ�ǧ����"/>
<jsp:setProperty name ="rPH" property ="pgRFQResponding" value ="�ֻ��Ȥ����Ϥ���ʤ����˹���֤���"/>
<jsp:setProperty name ="rPH" property ="pgRFQConfirmed" value ="�Ż���ˤ���äƼ�����ǧ����"/>
<jsp:setProperty name ="rPH" property ="pgRFQGenerating" value ="�����ʸ������������"/>
<jsp:setProperty name ="rPH" property ="pgRFQClosed" value ="�ִ��¤��Ϥ��Ƥ�����ñ����Ϥ⤦���郎���뤹���"�Ǥ�/>
<jsp:setProperty name ="rPH" property ="pgRFQAborted" value ="�����"/>
<jsp:setProperty name ="rPH" property ="pgProcessQty" value ="����������"/>
<jsp:setProperty name ="rPH" property ="pgNewNo" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgALogDesc" value ="�ִ����ζ�֤Ϲߤ�Ƴ��ϰ�Ϥ�����Ƥ�����Ͽ����ƾ�ɼ�ϥڥ󤬿�����ޤ���"/>
<jsp:setProperty name ="rPH" property ="pgYellowItem" value ="����-����"/>
<jsp:setProperty name ="rPH" property ="pgItemExistsMsg" value ="�־����ֹ����򤹤���ʸ�����෿��ORG���б������¸�ߤ����"/>
<jsp:setProperty name ="rPH" property ="pgWorkHour" value ="ϫư����"/>
<jsp:setProperty name ="rPH" property ="pgtheItem" value ="��Ȥ�ȹ�"/>
<jsp:setProperty name ="rPH" property ="pgRFQRequestDateMsg" value ="��ʪ�������Ϻ�����꾮�����ƤϤ����ʤ��Ǥ��� !" />

<jsp:setProperty name ="rPH" property ="pgDeliverCustomer" value ="��ʪ���Ϥ������"/>
<jsp:setProperty name ="rPH" property ="pgDeliverLocation" value ="��ʪ���Ϥ����ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgDeliverContact" value ="��ʪ���Ϥ�Ϣ�����"/>
<jsp:setProperty name ="rPH" property ="pgDeliveryTo" value ="��ʪ���Ϥ���-��"/>
<jsp:setProperty name ="rPH" property ="pgDeliverAddress" value ="��ʪ���Ϥ����ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgNotifyContact" value ="�Τ餻��Ϣ�����"/>
<jsp:setProperty name ="rPH" property ="pgNotifyLocation" value ="�Τ餻��Ϣ���륢�ɥ쥹"/>
<jsp:setProperty name ="rPH" property ="pgShipContact" value ="����Ϣ�����"/>
<jsp:setProperty name ="rPH" property ="pgMain" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgOthers" value ="�ۤ���"/>
<jsp:setProperty name ="rPH" property ="pgFactoryResponse" value ="�����֤�ʤ��"/>
<jsp:setProperty name ="rPH" property ="pgWith" value ="��"/>
<jsp:setProperty name ="rPH" property ="pgDetailRpt" value ="����ɽ"/>
<jsp:setProperty name ="rPH" property ="pgDateType" value ="��������"/>
<jsp:setProperty name ="rPH" property ="pgFr" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgTo _"value ="�ޤ�"/>
<jsp:setProperty name ="rPH" property ="pgSSD" value ="���̤��Ф뾦����"/>
<jsp:setProperty name ="rPH" property ="pgOrdD" value ="��ʸ������"/>
<jsp:setProperty name ="rPH" property ="pgItmFly" value =" Item Family" />
<jsp:setProperty name ="rPH" property ="pgItmPkg" value =" Item Package" />
<jsp:setProperty name ="rPH" property ="pgLDetailSave" value ="�ֺ��٤Τθ��̤������٤Τ�ί�뤦�Ȥ����"/>
<jsp:setProperty name ="rPH" property ="pgLCheckDelete" value ="����ʸ���Ƽ���Ȣ���ǧ����Ƥƾý������"/>
<jsp:setProperty name ="rPH" property ="pgThAccShpQty" value ="��������Ф�����"/>


<!--start for�ϽФ��ޤ������ʤ�������ϼ����list����������ȿ�¬���ޤ��� -->
<jsp:setProperty name ="rPH" property ="pgInvoiceNo" value ="�����"/>
<jsp:setProperty name ="rPH" property ="pgPoNo" value ="������"/>
<jsp:setProperty name ="rPH" property ="pgAvailableShip" value ="���Ȥ��Ǥ��뾦��"/>
