<%@ page contentType="text/html; charset=utf-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name="rPH" property="pgHOME" value="HOME"/>
<jsp:setProperty name="rPH" property="pgAllRepLog" value="ALL REPAIR LOG"/>
<jsp:setProperty name="rPH" property="pgTxLog" value="TRANSACTION LOG"/>
<jsp:setProperty name="rPH" property="pgAddWKF" value="Add new WorkFlow"/>
<jsp:setProperty name="rPH" property="pgRemark" value="Remark"/>

<jsp:setProperty name="rPH" property="pgFormID" value="FORM ID"/>
<jsp:setProperty name="rPH" property="pgWKFTypeNo" value="Type No"/>
<jsp:setProperty name="rPH" property="pgOriStat" value="Original Status"/>
<jsp:setProperty name="rPH" property="pgAction" value="EXECUTION"/> <!--Action to Execute-->
<jsp:setProperty name="rPH" property="pgChgStat" value="Changed Status"/>
<jsp:setProperty name="rPH" property="pgWKFDESC" value="Description"/>

<!--Push Button -->
<jsp:setProperty name="rPH" property="pgSelectAll" value="Select All"/>
<jsp:setProperty name="rPH" property="pgCancelSelect" value="Cancel Selected"/>
<jsp:setProperty name="rPH" property="pgPlsEnter" value="Please Enter"/>
<jsp:setProperty name="rPH" property="pgDelete" value="Delete"/>
<jsp:setProperty name="rPH" property="pgSave" value="Save"/>
<jsp:setProperty name="rPH" property="pgAdd" value="Add"/>
<jsp:setProperty name="rPH" property="pgOK" value="OK"/>
<jsp:setProperty name="rPH" property="pgFetch" value="Fetch"/>
<jsp:setProperty name="rPH" property="pgQuery" value="Query"/>
<jsp:setProperty name="rPH" property="pgSearch" value="Search"/>
<jsp:setProperty name="rPH" property="pgExecute" value="Execute"/>
<jsp:setProperty name="rPH" property="pgReset" value="Reset"/>

<!--Message of the list page-->
<jsp:setProperty name="rPH" property="pgPage" value="Page"/>
<jsp:setProperty name="rPH" property="pgPages" value="Pages"/>
<jsp:setProperty name="rPH" property="pgFirst" value="First"/>
<jsp:setProperty name="rPH" property="pgLast" value="Last"/>
<jsp:setProperty name="rPH" property="pgPrevious" value="Previous"/>
<jsp:setProperty name="rPH" property="pgNext" value="Next"/>
<jsp:setProperty name="rPH" property="pgTheNo" value="No."/>
<jsp:setProperty name="rPH" property="pgTotal" value="Total:"/>
<jsp:setProperty name="rPH" property="pgRecord" value="Records"/>
<jsp:setProperty name="rPH" property="pgRPProcess" value="REPAIR PROCESS"/>
<jsp:setProperty name="rPH" property="pgAllRecords" value="All Records"/>
<jsp:setProperty name="rPH" property="pgCode" value="Code"/>


<!--Repair Log -->
<jsp:setProperty name="rPH" property="pgRepTitle" value="REPAIR SERVICE LOG"/>
<jsp:setProperty name="rPH" property="pgRepNote" value="These fields must be filled"/>
<jsp:setProperty name="rPH" property="pgRepCenter" value="Repair Center"/>
<jsp:setProperty name="rPH" property="pgAgent" value="Agency"/>
<jsp:setProperty name="rPH" property="pgRecDate" value="Date to Receive"/>
<jsp:setProperty name="rPH" property="pgRecCenter" value="Reception"/>
<jsp:setProperty name="rPH" property="pgRecPerson" value="Receptionist"/>
<jsp:setProperty name="rPH" property="pgCustomer" value="Customer"/>
<jsp:setProperty name="rPH" property="pgTEL" value="Telephone"/>
<jsp:setProperty name="rPH" property="pgCell" value="Cell Phone"/>
<jsp:setProperty name="rPH" property="pgAddr" value="Address"/>
<jsp:setProperty name="rPH" property="pgZIP" value="ZIP"/>
<jsp:setProperty name="rPH" property="pgBuyingPlace" value="Place to Buy"/>
<jsp:setProperty name="rPH" property="pgBuyingDate" value="Date to Buy"/>
<jsp:setProperty name="rPH" property="pgSvrDocNo" value="Service No."/>
<jsp:setProperty name="rPH" property="pgPart" value="Part No."/>
<jsp:setProperty name="rPH" property="pgPartDesc" value="Part Description"/>
<jsp:setProperty name="rPH" property="pgModel" value="Model No."/>
<jsp:setProperty name="rPH" property="pgColor" value="Color"/>
<jsp:setProperty name="rPH" property="pgIMEI" value="IMEI"/>
<jsp:setProperty name="rPH" property="pgDSN" value="DSN/Serial No."/>
<jsp:setProperty name="rPH" property="pgRecItem" value="Items to Receive"/>
<jsp:setProperty name="rPH" property="pgJam" value="Faults"/>
<jsp:setProperty name="rPH" property="pgOtherJam" value="other Fault"/>
<jsp:setProperty name="rPH" property="pgFreq" value="Freq. of Fault"/>
<jsp:setProperty name="rPH" property="pgWarranty" value="Under Warranty"/>
<jsp:setProperty name="rPH" property="pgValid" value="Valid"/>
<jsp:setProperty name="rPH" property="pgInvalid" value="Invalid"/>
<jsp:setProperty name="rPH" property="pgWarrNo" value="Warranty No."/>
<jsp:setProperty name="rPH" property="pgSvrType" value="Service Type"/>
<jsp:setProperty name="rPH" property="pgRepStatus" value="Status"/>
<jsp:setProperty name="rPH" property="pgRepNo" value="Case No."/>
<jsp:setProperty name="rPH" property="pgRecItem2" value="Actual Items to Receive"/>
<jsp:setProperty name="rPH" property="pgWarranty2" value="Actual Warranty"/>
<jsp:setProperty name="rPH" property="pgRepLvl" value="Level of Repair"/>
<jsp:setProperty name="rPH" property="pgRepHistory" value="Case History"/>
<jsp:setProperty name="rPH" property="pgDOAPVerify" value="Verification of DOA/DAP"/>
<jsp:setProperty name="rPH" property="pgPreRPAct" value="Pre-Action"/>
<jsp:setProperty name="rPH" property="pgActualRPAct" value="Actual Action"/>
<jsp:setProperty name="rPH" property="pgSoftwareVer" value="Software Version"/>
<jsp:setProperty name="rPH" property="pgChgIMEI" value="Swapped IMEI"/>
<jsp:setProperty name="rPH" property="pgActualRPDesc" value="Description for Repair"/>
<jsp:setProperty name="rPH" property="pgPreUseMaterial" value="Material to be used"/>
<jsp:setProperty name="rPH" property="pgUseMaterial" value="Used Material"/>
<jsp:setProperty name="rPH" property="pgRPReason" value="Reason and Analysis"/>
<jsp:setProperty name="rPH" property="pgRPCost" value="Repair Cost"/>
<jsp:setProperty name="rPH" property="pgPartCost" value="Material Cost"/>
<jsp:setProperty name="rPH" property="pgTransCost" value="Transportation Cost"/>
<jsp:setProperty name="rPH" property="pgOtherCost" value="Other Cost"/>
<jsp:setProperty name="rPH" property="pgExecutor" value="Executor"/>
<jsp:setProperty name="rPH" property="pgExeTime" value="Exe. Time"/>
<jsp:setProperty name="rPH" property="pgAssignTo" value="ASSIGN TO"/>
<jsp:setProperty name="rPH" property="pgRepPerson" value="Repairer"/>
<jsp:setProperty name="rPH" property="pgTransferTo" value="TRANSFER TO"/>
<jsp:setProperty name="rPH" property="pgMailNotice" value="e-Mail Notice"/>
<jsp:setProperty name="rPH" property="pgWorkTime" value="Average Work Time "/>
<jsp:setProperty name="rPH" property="pgWorkTimeMsg" value="HOURS"/>
<jsp:setProperty name="rPH" property="pgLotNo" value="Lot Number"/>
<jsp:setProperty name="rPH" property="pgSymptom" value="Sypmtom"/>
<jsp:setProperty name="rPH" property="pgRecType" value="Type of Receipt"/>
<jsp:setProperty name="rPH" property="pgPCBA" value="PCB"/>
<jsp:setProperty name="rPH" property="pgRepeatRepInput" value="Repeat SDRQ. Input Page"/>
<jsp:setProperty name="rPH" property="pgWarrLimit" value="Warranty Limited"/>

<!--¥H¤U¬°ºû­?³B²z¤¤®?¥óªí?Y -->
<jsp:setProperty name="rPH" property="pgAddMaterial" value="Material to Repair"/>
<jsp:setProperty name="rPH" property="pgSituation" value="Product Situation"/>
<jsp:setProperty name="rPH" property="pgSituationMsg" value="These fields only for quotation"/>

<!--about sub windows-->
<jsp:setProperty name="rPH" property="pgRelevantInfo" value="Relevant Information"/>
<jsp:setProperty name="rPH" property="pgEnterCustIMEI" value="Please Enter the CUSTOMER or IMEI"/>
<jsp:setProperty name="rPH" property="pgSearchByAgency" value="SEARCH by AGENCY"/>
<jsp:setProperty name="rPH" property="pgSearchByCustIMEI" value="SEARCH by CUSTOMER or IMEI"/>
<jsp:setProperty name="rPH" property="pgEnterAgency" value="Please Enter the AGENCY"/>
<jsp:setProperty name="rPH" property="pgInputPart" value="To Input Part No."/>
<jsp:setProperty name="rPH" property="pgChoosePart" value="To Choose Part No."/>
<jsp:setProperty name="rPH" property="pgQty" value="Qty"/>

<!--JavaScript Alert Message-->
<jsp:setProperty name="rPH" property="pgAlertAction" value="Please make EXECUTION before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertModel" value="Please choose a MODEL before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrDocNo" value="Please fill the SERVICE NO. before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertCustomer" value="Please fill the CUSTOMER before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertSvrType" value="Please choose a proper ORDER TYPE before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertJam" value="Please choose the FAULT before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertIMEI" value="Please input the IMEI first!!"/>
<jsp:setProperty name="rPH" property="pgAlertCancel" value="Are you sure you want to CANCEL??"/>
<jsp:setProperty name="rPH" property="pgAlertAssign" value="Please choose manufactory to assign before you Submit!"/>
<jsp:setProperty name="rPH" property="pgAlertSubmit" value="Please make EXECUTION before you Submit this page!"/>
<jsp:setProperty name="rPH" property="pgAlertRepLvl" value="Please define the Repair Level, first!!"/>
<jsp:setProperty name="rPH" property="pgAlertLvl3" value="Please execute TRANSMIT because the Repair Level is 3!!"/>
<jsp:setProperty name="rPH" property="pgAlertNonLvl3" value="Please do not execute TRANSMIT because the Repair Level is not 3!!"/>
<jsp:setProperty name="rPH" property="pgAlertReassign" value="Please input the re-assign reason at Re-Assign Desc field to REASSIGN!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransfer" value="Please choose a Repair Center to TRANSFER!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecItem2" value="You must have Items to Receive!!"/>
<jsp:setProperty name="rPH" property="pgAlertSoftVer" value="Please input the Software Version before you COMPLETE this case!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgIMEI" value="Please input the Swapped IMEI before you COMPLETE this case!!"/>
<jsp:setProperty name="rPH" property="pgAlertWorkTime" value="Please input the actual Repair Work Time(Time Unit is Hour)!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPMaterial" value="Please choose Repair Material before you Submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPReason" value="Plaese choose Re-Assign/Reject Reason Code before you Submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertRPAction" value="Plaese choose Repair Action before you Submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertSymptom" value="Plaese choose Repair Symptom before you Submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertQty" value="Please fill the QTY of receipt before you save!!"/>
<jsp:setProperty name="rPH" property="pgErrorQty" value="Please Update QTY before you save, beacuse handset or PCB one piece on one order!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemNo" value="Please fill the ITEMNO field before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertRecType" value="Please choose the type of receipt before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertDOAPIMEI" value="Since the service type is DOA/DAP ,please input the IMEI first!!"/>
<jsp:setProperty name="rPH" property="pgAlertChgSvrType" value="Are you sure you want to change the service type?"/>
<jsp:setProperty name="rPH" property="pgAlertPcba" value="Please fill the PCB Item No. before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertMOGenSubmit" value="Are you sure you want to Generate Sales Order??"/>
<jsp:setProperty name="rPH" property="pgAlertPriceList" value="Please choose the Price List before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipAddress" value="Please choose the Ship to Address before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertBillAddress" value="Please choose the Bill to Address before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertPayTerm" value="Please choose the Payment Term before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertFOB" value="Please choose the FOB before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertShipMethod" value="Please choose the Shipping Method before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertCheckLineFlag" value="Please choose an item before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertCreateDRQ" value="Are you sure you want to Save this document?\n Choose action TEMPORARY if you gonna save it for temporary file!!"/>
<jsp:setProperty name="rPH" property="pgAlertReProcessMsg" value="Do you want continue process this RFQ No.??"/>
<jsp:setProperty name="rPH" property="pgAlertShipBillMsg" value="                 Please check the customer information !!\n It should be set the SHIP-TO / BILL-TO to primary.\n                    or you may get Error while generate Sales Order!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemOrgAssignMsg" value="            Please check Item Organization Assign !!\n It should be setting for Item to this Order Type!!"/>
<jsp:setProperty name="rPH" property="pgAlertItemExistsMsg" value="            Please Check Item Existence with respect to Oracle System\n    Contact with Item Configuration responsibility person!!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateMsg" value="          Sales RFQ Creation Fail !!,\n Please contact MIS Dept. find out Error reason,or choose 'non-Repeat Input RFQ option' !!"/>
<jsp:setProperty name="rPH" property="pgAlertRFQCreateDtlMsg" value="       There's no any detail item w.r.t this RFQ!!,\n Please contact sysadmin,or choose 'non-Repeat Input RFQ option' !!"/>
<jsp:setProperty name="rPH" property="pgAlertInvCustDiffMOCust" value="Invoice Customer different from Sales Order Customer\n          Please input again!!"/>
<jsp:setProperty name="rPH" property="pgAlertNotExistsMO" value="Sales Order No. not exists\n      Please input again!!"/>
<jsp:setProperty name="rPH" property="pgAlertDateSet" value="The setting Date is less than current date \n      Please input again!!"/>
<jsp:setProperty name="rPH" property="pgAlertCfmRjtMsg" value="                  Process contents was included reject line!!\n Please process reject line with abort action first!!\n"/>
<jsp:setProperty name="rPH" property="pgAlertRejectMsg" value="Please input Reject reason in remark field before you Submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertSampleCheckMsg" value="       You cann't change Sample Order check while you entered some itemes in the list under SPQ/MOQ rule,\n                  please delete all the list before you change it!! "/>

<!--prompt after submit-->
<jsp:setProperty name="rPH" property="pgFreqReturn" value="Frequency of Return"/>
<jsp:setProperty name="rPH" property="pgFreqReject" value="Frequency of Reject"/>

<!--Page Hyper-Link-->
<jsp:setProperty name="rPH" property="pgPageAddRMA" value="New Repair Log"/>
<jsp:setProperty name="rPH" property="pgPage3AddRMA" value="New Repair Log(Lv 3)"/>
<jsp:setProperty name="rPH" property="pgPageAssign" value="Case Assign"/>
<jsp:setProperty name="rPH" property="pgPage3Assign" value="Case Assign(Lv 3)"/>

<!--Content of Send Mail-->
<jsp:setProperty name="rPH" property="pgMailSubjectAssign" value="Assignment from the Repair System"/>

<!--Content of Customer Receipt-->
<jsp:setProperty name="rPH" property="pgCustReceipt" value="CUSTOMER RECEIPT"/>
<jsp:setProperty name="rPH" property="pgTransList" value="LIST OF TRANSMISSION"/>
<jsp:setProperty name="rPH" property="pgTransDate" value="TRANS. DATE"/>
<jsp:setProperty name="rPH" property="pgListNo" value="List(Lot) NO."/>
<jsp:setProperty name="rPH" property="pgReceiptNo" value="Receipt NO."/>
<jsp:setProperty name="rPH" property="pgShipDate" value="SHIP DATE"/>
<jsp:setProperty name="rPH" property="pgShipper" value="SHIPPER"/>
<jsp:setProperty name="rPH" property="pgCustSign" value="SIGNATURE"/>
<jsp:setProperty name="rPH" property="pgPSMessage1" value="After had materials received and confirmed,please sign your name and FAX back to "/>
<jsp:setProperty name="rPH" property="pgPSMessage2" value="If you have any furthur question,please don't hesitate contact me and CALL"/>
<jsp:setProperty name="rPH" property="pgWarnMessage" value="The date will base on the ship date of DBTEL.This material suppose to be received if you did not FAX back in 3 days.DBTEL would not be in charge if it has disputation"/>

<!--DOA/DAP In-Stock List-->
<jsp:setProperty name="rPH" property="pgInStockLotList" value="DOA/DAP IN-STOCK LIST"/>
<jsp:setProperty name="rPH" property="pgInStockNo" value="IN-STOCK NO."/>
<jsp:setProperty name="rPH" property="pgInStockDate" value="IN-STOCK DATE"/>
<jsp:setProperty name="rPH" property="pgInStocker" value="IN-STOCKER"/>
<jsp:setProperty name="rPH" property="pgWarehouserSign" value="WAREHOUSER SIGNATURE"/> 

<!--MESSAGE OF THE REPAIR PROCESS PAGE-->
<jsp:setProperty name="rPH" property="pgPrintCustReceipt" value="Print CUSTOMER RECEIPT"/>
<jsp:setProperty name="rPH" property="pgPrintShippedConfirm" value="Print SHIPPED CONFIRM LIST"/>
<jsp:setProperty name="rPH" property="pgRepairProcess" value="RMA PROCESS"/>
<jsp:setProperty name="rPH" property="pgDOAProcess" value="DOA PROCESS"/>
<jsp:setProperty name="rPH" property="pgDAPProcess" value="DAP PROCESS"/>

<!--Material Request-->
<jsp:setProperty name="rPH" property="pgMaterialRequest" value="MATERIAL REQUEST"/>
<jsp:setProperty name="rPH" property="pgTransType" value="Transaction Type"/>
<jsp:setProperty name="rPH" property="pgConReg" value="Country/Region"/>
<jsp:setProperty name="rPH" property="pgDocNo" value="Document No."/>
<jsp:setProperty name="rPH" property="pgWarehouseNo" value="Warehouse No."/>
<jsp:setProperty name="rPH" property="pgLocation" value="Location"/>
<jsp:setProperty name="rPH" property="pgPersonal" value="Personal"/>
<jsp:setProperty name="rPH" property="pgInvTransInput" value="Inventory Transaction Input"/>
<jsp:setProperty name="rPH" property="pgInvTransQuery" value="Inventory Transaction Query"/>

<jsp:setProperty name="rPH" property="pgAllMRLog" value="ALL MATERIAL REQUEST"/>
<jsp:setProperty name="rPH" property="pgAlertMRReason" value="Please choose material requisite reason before you submit this page!!"/>
<jsp:setProperty name="rPH" property="pgAlertMRChoose" value="Please choose the MATERIAL required before you save!!"/>
<jsp:setProperty name="rPH" property="pgApDate" value="Apply Date"/>
<jsp:setProperty name="rPH" property="pgApplicant" value="Applicant"/>
<jsp:setProperty name="rPH" property="pgMRReason" value="Requisite reason"/>
<jsp:setProperty name="rPH" property="pgInvMagProcess" value="Inventory Management"/>
<jsp:setProperty name="rPH" property="pgMRProcess" value="Material Request Process"/>
<jsp:setProperty name="rPH" property="pgApplyPart" value="Part Applied"/>
<jsp:setProperty name="rPH" property="pgReceivePart" value="Part Received"/>
<jsp:setProperty name="rPH" property="pgMRDesc" value="Part Description"/>
<jsp:setProperty name="rPH" property="pgProvdTime" value="Time to provide"/>

<jsp:setProperty name="rPH" property="pgMRR" value="Material Return Request"/>
<jsp:setProperty name="rPH" property="pgReturnPart" value="Return Part"/>
<jsp:setProperty name="rPH" property="pgOriWhs" value="Original Warehouse"/>
<jsp:setProperty name="rPH" property="pgAlertApplicant" value="Please choose applicant before you save!!"/>
<jsp:setProperty name="rPH" property="pgTransReason" value="Transaction reaon"/>
<jsp:setProperty name="rPH" property="pgMAR" value="Material Allotment Request"/>
<jsp:setProperty name="rPH" property="pgAllotPart" value="Allot Part"/>
<jsp:setProperty name="rPH" property="pgAllottee" value="Allottee"/>
<jsp:setProperty name="rPH" property="pgAlertAllottee" value="Please choose allottee before you save!!"/>
<jsp:setProperty name="rPH" property="pgAlertTransReason" value="Please choose transaction reason before you save!!"/>

<!--Invertory Transaction-->
<!--Content of DOA/DAP -->
<jsp:setProperty name="rPH" property="pgVeriSvrType" value="Verify Service Type"/>
<jsp:setProperty name="rPH" property="pgVerifyStandard" value="Verification Standard of DOA/DAP"/>

 <!-- Content of repair inventory consume (by item) -->
<jsp:setProperty name="rPH" property="pgRepPostByItem" value="Repair consumption post to BPCS(by item part)"/>
<jsp:setProperty name="rPH" property="pgBPCSInvQty" value="BPCS Item Inventory "/>
<jsp:setProperty name="rPH" property="pgIssuePartsDate" value="Issue Date"/> 
<jsp:setProperty name="rPH" property="pgIssuePerson" value="Issue Person"/> 
<jsp:setProperty name="rPH" property="pgTransComment" value="Trnasaction Ticket"/>
<jsp:setProperty name="rPH" property="pgBalanceQty" value="Balance Q'ty"/>

<!-- Content of repair inventory consume (by material request) -->
<jsp:setProperty name="rPH" property="pgRepPostByMRequest" value="Repair consumption post to BPCS(by material request)"/>
<jsp:setProperty name="rPH" property="pgCheckItem" value="Check"/>
<jsp:setProperty name="rPH" property="pgPreparePost2BPCS" value="Records for post BPCS"/>

 <!-- Content of repair inventory consume (by repair engineer) -->
<jsp:setProperty name="rPH" property="pgRepPostByRPEngineer" value="Repair consumption post to BPCS(by repair engineer)"/>
<jsp:setProperty name="rPH" property="pgRepairEngineer" value="Repair Engineer"/> 
<jsp:setProperty name="rPH" property="pgItemQty" value="Item Q'ty "/> 
<jsp:setProperty name="rPH" property="pgMRItemQty" value="Q'ty"/>

<!--Content of DISTRIBUTOR/Key Account -->
<jsp:setProperty name="rPH" property="pgInfo" value="Information"/>
<jsp:setProperty name="rPH" property="pgName" value="Name"/>
<jsp:setProperty name="rPH" property="pgNo" value="No."/>
<jsp:setProperty name="rPH" property="pgDepend" value="Dependency"/>
<jsp:setProperty name="rPH" property="pgContact" value="Contact"/>
<jsp:setProperty name="rPH" property="pgFAX" value="FAX"/>
<jsp:setProperty name="rPH" property="pgKeyAccount" value="Key Account"/>
<jsp:setProperty name="rPH" property="pgEdit" value="Edit"/>

<!--Content of Inquiry Page-->
  <!--Post to BPCS Page-->
<jsp:setProperty name="rPH" property="pgCentPBpcsTitle" value="Daily Post BPCS Inquiry"/>
<jsp:setProperty name="rPH" property="pgPostDateFr" value="Post Date Fr."/>
<jsp:setProperty name="rPH" property="pgPostDateTo" value="Post Date To."/>
<jsp:setProperty name="rPH" property="pgPostDate" value="Post Date"/>
<jsp:setProperty name="rPH" property="pgBelPerson" value="Resp. Person"/>
<jsp:setProperty name="rPH" property="pgTransTime" value="Transc. Time"/>
<jsp:setProperty name="rPH" property="pgExecPerson" value="Executor"/>
<jsp:setProperty name="rPH" property="pgBPCSSerial" value="BPCS Serial"/>
 <!--Content of Consume & Cost Page-->
<jsp:setProperty name="rPH" property="pgModelConsumeTitle" value="Repair Parts Consumption & Cost Inquiry by Model"/>
<jsp:setProperty name="rPH" property="pgRpPartsCostTable" value="Parts Cost Price List"/>
<jsp:setProperty name="rPH" property="pgAnItem" value="Item"/>
<jsp:setProperty name="rPH" property="pgPartsConsumQty" value="Parts Consumption"/>
<jsp:setProperty name="rPH" property="pgCostPrice" value="Cost Price"/>
<jsp:setProperty name="rPH" property="pgAccPartsPrice" value="Part Price Subtotal"/>
<jsp:setProperty name="rPH" property="pgGTotal" value="Grand Total"/>
<jsp:setProperty name="rPH" property="pgCostMainten" value="Repair Costs of Maintenance List"/>
<jsp:setProperty name="rPH" property="pgRPQuantity" value="Repair Quantity"/>
<jsp:setProperty name="rPH" property="pgStdServiceFee" value="Standard Service Fee/Hour"/>
<jsp:setProperty name="rPH" property="pgActServiceFee" value="Actual Service Fee/Hour"/>
<jsp:setProperty name="rPH" property="pgModelFeeSubTotal" value="Fee Subtotal by Model"/>
 <!--Content of Month Fault Reason Page-->
<jsp:setProperty name="rPH" property="pgMonthFaultReasonTitle" value="Fault Code Monthly Distribution Inquiry"/>
<jsp:setProperty name="rPH" property="pgRate" value="Rate"/>

 <!--Content of Material Request Form Post 2 BPCS Inquiry-->
<jsp:setProperty name="rPH" property="pgMaterialReqBPCSTitle" value="Material Request Form Post to BPCS Inquiry"/>
<jsp:setProperty name="rPH" property="pgIssuePartsDateFr" value="Parts Issue Fr."/> 
<jsp:setProperty name="rPH" property="pgIssuePartsDateTo" value="Parts Issue To."/>
<jsp:setProperty name="rPH" property="pgMatRequestForm" value="Material Request Form No."/>
<jsp:setProperty name="rPH" property="pgRepairNo" value="Repair No."/>
<jsp:setProperty name="rPH" property="pgDetail" value="Detail"/>
<jsp:setProperty name="rPH" property="pgBPCSNo" value="BPCS Com No."/>
<jsp:setProperty name="rPH" property="pgBPCSDetail" value="BPCS Detail"/>

 <!--Content of Engineer Material Request or Warehouser Issue Inquiry-->
<jsp:setProperty name="rPH" property="pgMaterialReqIssTitle" value="Material Request/Issue Inquiry"/> 

 <!--Print Material Request Form-->
<jsp:setProperty name="rPH" property="pgMReqInquiryLink" value="Material Request/Issue Inquiry"/>
<jsp:setProperty name="rPH" property="pgYear" value="Year"/>
<jsp:setProperty name="rPH" property="pgMonth" value="Month"/>
<jsp:setProperty name="rPH" property="pgDay" value="Day"/>
<jsp:setProperty name="rPH" property="pgS17DOAP" value="S17 DOAP swap"/>
<jsp:setProperty name="rPH" property="pgS11MaterialReq" value="S11 Defect New Product Material Request"/>
<jsp:setProperty name="rPH" property="pgS18WarrIn" value="S18 Warranty in Repair Material"/>
<jsp:setProperty name="rPH" property="pgS19WarrOut" value="S19 Warranty out Repair Material"/>
<jsp:setProperty name="rPH" property="pgEmpNo" value="Employee No."/>
<jsp:setProperty name="rPH" property="pgDeptNo" value="Dept. No."/>
<jsp:setProperty name="rPH" property="pgAppDesc" value="Application Desc."/>
<jsp:setProperty name="rPH" property="pgItemDesc" value="Item Description"/>
<jsp:setProperty name="rPH" property="pgItemColor" value="Color"/>
<jsp:setProperty name="rPH" property="pgAppQty" value="Application Q'ty"/>
<jsp:setProperty name="rPH" property="pgActQty" value="Actual Q'ty"/>
<jsp:setProperty name="rPH" property="pgApproval" value="Approval"/>
<jsp:setProperty name="rPH" property="pgChief" value="Chief"/>
<jsp:setProperty name="rPH" property="pgTreasurer" value="Treasurer"/>
<jsp:setProperty name="rPH" property="pgPrintDate" value="Print Date"/>

 <!-- Content of MES Manufacture Execution System Inquiry -->
<jsp:setProperty name="rPH" property="pgIssDelivery" value="Receiption achieve "/>
<jsp:setProperty name="rPH" property="pgProdDateFr" value="Manuf. Date Fr."/>
<jsp:setProperty name="rPH" property="pgProdDateTo" value="Manuf. Date To."/>
<jsp:setProperty name="rPH" property="pgSearchStr" value="IMEI?DSN?Prod. No.?Carton No."/>
<jsp:setProperty name="rPH" property="pgMESSOrderNo" value="MES Shop Order No."/>
<jsp:setProperty name="rPH" property="pgProdItemNo" value="Product No."/>
<jsp:setProperty name="rPH" property="pgMobileSoftware" value="Mobile Software"/>
<jsp:setProperty name="rPH" property="pgLineName" value="Line"/>
<jsp:setProperty name="rPH" property="pgStationName" value="Station"/>
<jsp:setProperty name="rPH" property="pgSOrderIn" value="S.Order On Stream Date"/>
<jsp:setProperty name="rPH" property="pgPackingDTime" value="Packing Date Time"/>
<jsp:setProperty name="rPH" property="pgOperator" value="Operator"/>
<jsp:setProperty name="rPH" property="pgPMCC" value="PMCC"/>
<jsp:setProperty name="rPH" property="pgWorkOrder" value="Discrete JOB "/>
<jsp:setProperty name="rPH" property="pgTestBay" value="Testbay Name"/>
<jsp:setProperty name="rPH" property="pgCartonNo" value="Carton No."/>
<jsp:setProperty name="rPH" property="pgProductDetail" value="Doc. History "/>

 <!-- Content of Agent Upload file Inquiry-->
<jsp:setProperty name="rPH" property="pgAgentUpfileInf" value="Agency Upload file data Inquiry"/>
<jsp:setProperty name="rPH" property="pgDateFr" value="Date From"/> 
<jsp:setProperty name="rPH" property="pgDateTo" value="Date To"/>
<jsp:setProperty name="rPH" property="pgAgentNo" value="Agent No."/>
<jsp:setProperty name="rPH" property="pgTransmitFlag" value="Transmit?"/>
<jsp:setProperty name="rPH" property="pgChgIMEIFlag" value="SWAP IMEI?"/> 

 <!-- Content of Repair Case Information Inquiry Page -->
<jsp:setProperty name="rPH" property="pgRepairCaseInf" value="Repair Information Inquiry"/>
<jsp:setProperty name="rPH" property="pgTransOption" value="Transmit/Transfer"/>
<jsp:setProperty name="rPH" property="pgRetTimes" value="Return Times"/>
<jsp:setProperty name="rPH" property="pgFinishStatus" value="Finish Status"/>
<jsp:setProperty name="rPH" property="pgExcelButton" value="Excel"/>
<jsp:setProperty name="rPH" property="pgRecTime" value="Receive Time"/>
<jsp:setProperty name="rPH" property="pgFinishDate" value="Finish Date"/>
<jsp:setProperty name="rPH" property="pgFinishTime" value="Finish Time"/>
<jsp:setProperty name="rPH" property="pgRepMethod" value="Method"/>
<jsp:setProperty name="rPH" property="pgLastMDate" value="Last M.Date"/>
<jsp:setProperty name="rPH" property="pgLastMPerson" value="Last M.Person"/>
<jsp:setProperty name="rPH" property="pgRepPercent" value="Case Percentage"/>
<jsp:setProperty name="rPH" property="pgNotFoundMsg" value="No Record Found"/>

<jsp:setProperty name="rPH" property="pgServiceLog" value="Service Log"/>
<jsp:setProperty name="rPH" property="pgReturnLog" value="Returns Log"/>
<jsp:setProperty name="rPH" property="pgMobileRepair" value="Mobile Repair"/>
<jsp:setProperty name="rPH" property="pgCType" value=" Service Type "/>
<jsp:setProperty name="rPH" property="pgShipType" value=" Shipping "/>

<!--Content of Main Menu & Acoount Maintain -->
<jsp:setProperty name="rPH" property="pgMenuInstruction" value="System Instruction"/>
<jsp:setProperty name="rPH" property="pgDownload" value="Download"/>
<jsp:setProperty name="rPH" property="pgMenuGroup" value="User Group"/>
<jsp:setProperty name="rPH" property="pgChgPwd" value="Change Password"/>
<jsp:setProperty name="rPH" property="pgBulletin" value="Bulletin Board"/>
<jsp:setProperty name="rPH" property="pgLogin" value="Login"/>
<jsp:setProperty name="rPH" property="pgLogout" value="Logout"/>
<jsp:setProperty name="rPH" property="pgMsgLicence" value="DBTEL Incorporated. All Rights Reserved."/>
<jsp:setProperty name="rPH" property="pgRole" value="Role"/>
<jsp:setProperty name="rPH" property="pgList" value="List"/>
<jsp:setProperty name="rPH" property="pgNew" value="New"/>
<jsp:setProperty name="rPH" property="pgRevise" value="Revise"/>
<jsp:setProperty name="rPH" property="pgDesc" value="Description"/>
<jsp:setProperty name="rPH" property="pgSuccess" value="Success"/>
<jsp:setProperty name="rPH" property="pgAccount" value="Account ID"/>
<jsp:setProperty name="rPH" property="pgAccountWeb" value="Account Web ID"/>
<jsp:setProperty name="rPH" property="pgMail" value="e-Mail Address"/>
<jsp:setProperty name="rPH" property="pgProfile" value="Profile"/>
<jsp:setProperty name="rPH" property="pgPasswd" value="Password"/>
<jsp:setProperty name="rPH" property="pgLocale" value="Country"/>
<jsp:setProperty name="rPH" property="pgLanguage" value="Language"/>
<jsp:setProperty name="rPH" property="pgModule" value="Module"/>
<jsp:setProperty name="rPH" property="pgSeq" value="Sort Sequence"/>
<jsp:setProperty name="rPH" property="pgFunction" value="Function"/>
<jsp:setProperty name="rPH" property="pgHref" value="Href"/>
<jsp:setProperty name="rPH" property="pgAuthoriz" value="Authorization"/>
<jsp:setProperty name="rPH" property="pgEmpID" value="Employee ID"/>
<jsp:setProperty name="rPH" property="pgRepReceive" value=" Repair Receive "/>
<jsp:setProperty name="rPH" property="pgBasicInf" value=" Basic Information "/>
<jsp:setProperty name="rPH" property="pgFLName" value=" Name "/>
<jsp:setProperty name="rPH" property="pgID" value="Account"/>

<!--Content of Bulletin & Discussion -->
<jsp:setProperty name="rPH" property="pgBulletinNotice" value=" Notice/Message"/>
<jsp:setProperty name="rPH" property="pgPublishDate" value="Published Date"/>
<jsp:setProperty name="rPH" property="pgPublisher" value="Publisher"/>
<jsp:setProperty name="rPH" property="pgPublish" value="Publish"/>
<jsp:setProperty name="rPH" property="pgTopic" value="Topic"/>
<jsp:setProperty name="rPH" property="pgContent" value="Content"/>
<jsp:setProperty name="rPH" property="pgClassOfTopic" value="Class of Topic"/>
<jsp:setProperty name="rPH" property="pgTopicOfDiscuss" value="Topic of Discussion"/>
<jsp:setProperty name="rPH" property="pgHits" value="Hits"/>
<jsp:setProperty name="rPH" property="pgNewTopic" value="New Topic"/>
<jsp:setProperty name="rPH" property="pgClass" value="Class"/>
<jsp:setProperty name="rPH" property="pgResponse" value="Response"/>
<jsp:setProperty name="rPH" property="pgReturn" value="Return"/>
<jsp:setProperty name="rPH" property="pgRespond" value="Respond"/>
<jsp:setProperty name="rPH" property="pgNewDiscuss" value="New Discussion"/>
<jsp:setProperty name="rPH" property="pgUserResponse" value="User Response"/>
<jsp:setProperty name="rPH" property="pgTime" value="Time"/>
<jsp:setProperty name="rPH" property="pgResponder" value="Responder"/>
<jsp:setProperty name="rPH" property="pgInformation" value="Information"/>
<jsp:setProperty name="rPH" property="pgDocument" value="Document"/>

 <!--Content of After Service Material Management Data -->
<jsp:setProperty name="rPH" property="pgASMaterial" value=" Material "/>
<jsp:setProperty name="rPH" property="pgUpload" value=" Upload "/>
<jsp:setProperty name="rPH" property="pgFile" value=" File "/>
<jsp:setProperty name="rPH" property="pgCenter" value=" Center "/>
<jsp:setProperty name="rPH" property="pgFormat" value=" Format "/>
<jsp:setProperty name="rPH" property="pgFollow" value=" Please follow "/>
<jsp:setProperty name="rPH" property="pgBelow" value=" as below "/>
<jsp:setProperty name="rPH" property="pgAbove" value=" as above "/>
<jsp:setProperty name="rPH" property="pgPreview" value=" View "/>
<jsp:setProperty name="rPH" property="pgLevel" value=" Level "/>
<jsp:setProperty name="rPH" property="pgLaunch" value="Launch"/>
<jsp:setProperty name="rPH" property="pgSparePart" value=" Spare Part "/>
<jsp:setProperty name="rPH" property="pgModelSeries" value=" Model "/>
<jsp:setProperty name="rPH" property="pgPicture" value=" Picture "/>
<jsp:setProperty name="rPH" property="pgImage" value=" Image "/>
<jsp:setProperty name="rPH" property="pgInventory" value=" Inventory "/>
<jsp:setProperty name="rPH" property="pgCalculate" value="Calcualte"/>
<jsp:setProperty name="rPH" property="pgPrice" value=" Price"/>
<jsp:setProperty name="rPH" property="pgConsumer" value=" Consumer"/>
<jsp:setProperty name="rPH" property="pgRetailer" value=" Retailer"/>
<jsp:setProperty name="rPH" property="pgASMAuthFailMsg" value="Sorry!You are not authorized to query the data."/>
<jsp:setProperty name="rPH" property="pgASMInfo" value="Information of After Service Material"/>
<jsp:setProperty name="rPH" property="pgMOQ" value="Min. Ordered Qty."/>
<jsp:setProperty name="rPH" property="pgSafeInv" value="Safety Inventory"/>
<jsp:setProperty name="rPH" property="pgCurrInv" value="On Hand"/>
<jsp:setProperty name="rPH" property="pgFront" value="Front Side"/>
<jsp:setProperty name="rPH" property="pgBack" value="Back Side"/>
<jsp:setProperty name="rPH" property="pgAllASM" value="All After Service Material"/>
<jsp:setProperty name="rPH" property="pgChooseMdl" value="Choose Model"/>
<jsp:setProperty name="rPH" property="pgASM_EC" value="EC for After Service Material"/>
<jsp:setProperty name="rPH" property="pgChange" value="Change"/>
<jsp:setProperty name="rPH" property="pgNewPart4EC" value="New Part No. for EC"/>
<jsp:setProperty name="rPH" property="pgCurrModelRef" value="Currently Model Ref."/>
<jsp:setProperty name="rPH" property="pgModelRefMsg" value="Items selected are the Model Ref. which needs to be changed for EC"/>
<jsp:setProperty name="rPH" property="pgDelImage" value="Delete Image/Picture"/>


 <!--Content of Management of function Data -->
<jsp:setProperty name="rPH" property="pgAfterService" value="After Service "/>
<jsp:setProperty name="rPH" property="pgInput" value=" Input "/>
<jsp:setProperty name="rPH" property="pgMaintenance" value=" Maintenance "/>
<jsp:setProperty name="rPH" property="pgRefresh" value="Refresh"/>
<jsp:setProperty name="rPH" property="pgChinese" value=" Chinese "/>
<jsp:setProperty name="rPH" property="pgDescription" value=" Description"/>
<jsp:setProperty name="rPH" property="pgType" value=" Type "/>
<jsp:setProperty name="rPH" property="pgDefinition" value=" Definition "/>
 
<jsp:setProperty name="rPH" property="pgASModelMainten" value="After Service Project/Sales Model Maintenance"/>
<jsp:setProperty name="rPH" property="pgSalesModel" value="Sales Model"/>
<jsp:setProperty name="rPH" property="pgLaunchDate" value="Launch Date"/>
<jsp:setProperty name="rPH" property="pgDisannulDate" value="Disannul Date"/>
<jsp:setProperty name="rPH" property="pgProjHoldDate" value="Proj. Hold Date"/>
<jsp:setProperty name="rPH" property="pgASCodeEntry" value="After Service Code Input Entry"/>
<jsp:setProperty name="rPH" property="pgRegion" value="Region"/>
<jsp:setProperty name="rPH" property="pgCodeClass" value="Code Class"/>

<jsp:setProperty name="rPH" property="pgASItemInput" value="After Service Item Code Input"/>
<jsp:setProperty name="rPH" property="pgPartChDesc" value="Part Description(Chinese)"/>
<jsp:setProperty name="rPH" property="pgEnable" value="Enable"/>
<jsp:setProperty name="rPH" property="pgDisable" value="Disable"/>
<jsp:setProperty name="rPH" property="pgModelRef" value="Model Ref."/>
<jsp:setProperty name="rPH" property="pgItemLoc" value="Location"/>

<jsp:setProperty name="rPH" property="pgASFaultSympInput" value="After Service Fault/Symptom Code input"/>
<jsp:setProperty name="rPH" property="pgFaultCode" value="Fault Code"/>
<jsp:setProperty name="rPH" property="pgSymptomCode" value="Symptom Code"/>
<jsp:setProperty name="rPH" property="pgCodeDesc" value="Code Description"/>
<jsp:setProperty name="rPH" property="pgCodeChDesc" value="Code Chinese Description"/>
<jsp:setProperty name="rPH" property="pgCUser" value="Create user"/>
<jsp:setProperty name="rPH" property="pgCDate" value="Create Date"/>

<jsp:setProperty name="rPH" property="pgASResActInput" value="Re-Assign/Reject Reason Code Input "/>
<jsp:setProperty name="rPH" property="pgActionCode" value="Action Code"/>
<jsp:setProperty name="rPH" property="pgActionDesc" value="Action Description"/>
<jsp:setProperty name="rPH" property="pgActionChDesc" value="Action Chinese Description"/>
<jsp:setProperty name="rPH" property="pgReasonCode" value="Reason Code"/>
<jsp:setProperty name="rPH" property="pgReasonDesc" value="Reject Reason Description"/>
<jsp:setProperty name="rPH" property="pgReasonChDesc" value="Reason Chinese Description"/>

<jsp:setProperty name="rPH" property="pgASMLauStatusTitle" value="MODEL of After Service Material to Country/Launch Status"/>
<jsp:setProperty name="rPH" property="pgUpdateLaunch" value="Update Launch"/>


<!--Content of Progress Status Bar Message -->
<jsp:setProperty name="rPH" property="pgProgressStsBar" value="Processing..."/>

<!----Content of Report Data -->
<jsp:setProperty name="rPH" property="pgReport" value=" Report "/>
<jsp:setProperty name="rPH" property="pgTransaction" value=" Transaction "/>
<jsp:setProperty name="rPH" property="pgLogQty" value=" Log Q'ty "/>
<jsp:setProperty name="rPH" property="pgRepair" value=" Repair "/>
<jsp:setProperty name="rPH" property="pgProcess" value=" Process "/>
<jsp:setProperty name="rPH" property="pgNotInclude" value=" Exclusness "/>
<jsp:setProperty name="rPH" property="pgRepCompleteRate" value=" Repair Complete Rate "/>
<jsp:setProperty name="rPH" property="pgRepaired" value=" Repaired "/>
<jsp:setProperty name="rPH" property="pgRepairing" value=" Repairing "/>
<jsp:setProperty name="rPH" property="pgRepGeneral" value=" General "/>
<jsp:setProperty name="rPH" property="pgRepLvl1" value=" Level 1 "/>
<jsp:setProperty name="rPH" property="pgRepLvl2" value=" Level 2 "/>
<jsp:setProperty name="rPH" property="pgRepLvl3" value=" Level 3 "/>
<jsp:setProperty name="rPH" property="pgRepLvl12" value=" Level 1/2 "/>
<jsp:setProperty name="rPH" property="pgNorth" value=" North "/>
<jsp:setProperty name="rPH" property="pgMiddle" value=" Middle "/>
<jsp:setProperty name="rPH" property="pgSouth" value=" South "/>
<jsp:setProperty name="rPH" property="pgAll" value=" All "/>
<jsp:setProperty name="rPH" property="pgArea" value=" Area "/>
<jsp:setProperty name="rPH" property="pgServiceCenter" value=" After Service Center "/>
<jsp:setProperty name="rPH" property="pgSubTotal" value=" Sub. Total "/>
<jsp:setProperty name="rPH" property="pgLogModelPerm" value=" Log Model Permutation "/>
<jsp:setProperty name="rPH" property="pgPermutDetail" value=" Permutation Detail "/>
<jsp:setProperty name="rPH" property="pgModelDetail" value=" Model Detail "/>
<jsp:setProperty name="rPH" property="pgLvl12FinishTrendChart" value=" Lvl. 1/2 Repair Complete Trend Chart(by Area) "/>
<jsp:setProperty name="rPH" property="pgLvl3FinishTrendChart" value=" Lvl. 3 Repair Complete Trend Chart(by Area) "/>
<jsp:setProperty name="rPH" property="pgRepFinishTrendChart" value=" Repair Complete Trend Chart "/>
<jsp:setProperty name="rPH" property="pgRepAreaSummaryReport" value=" Data Summary Report "/>


 <!-- Content of  Misc . library of Data -->
<jsp:setProperty name="rPH" property="pgCase" value=" Case "/>
<jsp:setProperty name="rPH" property="pgRecords" value=" Record "/>
<jsp:setProperty name="rPH" property="pgTo" value=" To "/>

  <!-- WINS Original function library of Data -->
<jsp:setProperty name="pageHeader" property="pgTitleName" value="PRODUCT INFORMATION"/>
<jsp:setProperty name="pageHeader" property="pgSalesCode" value="Sales Code"/>
<jsp:setProperty name="pageHeader" property="pgProjectCode" value="Project Code"/>
<jsp:setProperty name="pageHeader" property="pgProductType" value="Product Type"/>
<jsp:setProperty name="pageHeader" property="pgBrand" value="Brand"/>
<jsp:setProperty name="pageHeader" property="pgLength" value="Length"/>
<jsp:setProperty name="pageHeader" property="pgWidth" value="Width"/>
<jsp:setProperty name="pageHeader" property="pgHeight" value="Height"/>
<jsp:setProperty name="pageHeader" property="pgWeight" value="Weight"/>

<jsp:setProperty name="pageHeader" property="pgLaunchDate" value="Launch Date"/>
<jsp:setProperty name="pageHeader" property="pgDeLaunchDate" value="DeLaunch Date"/>
<jsp:setProperty name="pageHeader" property="pgSize" value="SIZE"/>
<jsp:setProperty name="pageHeader" property="pgDisplay" value="DISPLAY"/>
<jsp:setProperty name="pageHeader" property="pgCamera" value="CAMERA"/>
<jsp:setProperty name="pageHeader" property="pgRingtone" value="RINGTONE"/>
<jsp:setProperty name="pageHeader" property="pgPhonebook" value="PHONEBOOK"/>

<jsp:setProperty name="pageHeader" property="pgRemark" value="REMARK"/>

<!-- 交期詢問單輸入詞庫 -->
<jsp:setProperty name="rPH" property="pgSalesDRQ" value="Sales Delivery Request Questionnaire "/>
<jsp:setProperty name="rPH" property="pgQDocNo" value="Doc.No."/>
<jsp:setProperty name="rPH" property="pgSalesArea" value="Sales Area"/>
<jsp:setProperty name="rPH" property="pgCustInfo" value="Customer "/>
<jsp:setProperty name="rPH" property="pgSalesMan" value="Sales Person"/>
<jsp:setProperty name="rPH" property="pgInvItem" value="Model"/>
<jsp:setProperty name="rPH" property="pgDeliveryDate" value="Delivery Date"/>
<jsp:setProperty name="rPH" property="pgSalesOrderNo" value="Sales Order No."/>
<jsp:setProperty name="rPH" property="pgCustPONo" value="Customer PO No."/>
<jsp:setProperty name="rPH" property="pgCustPOLineNo" value="Customer PO Line No."/>
<jsp:setProperty name="rPH" property="pgCurr" value="Currency"/>
<jsp:setProperty name="rPH" property="pgPreOrderType" value="Pre. Order Type"/>
<jsp:setProperty name="rPH" property="pgProcessUser" value="Process User"/>
<jsp:setProperty name="rPH" property="pgProcessDate" value="Process Date"/>
<jsp:setProperty name="rPH" property="pgProcessTime" value="Process Time"/>
<jsp:setProperty name="rPH" property="pgDRQInputPage" value="Input Page"/>
<jsp:setProperty name="rPH" property="pgProdManufactory" value="Default Manufactory"/>
<jsp:setProperty name="rPH" property="pgDeptArea" value="Area "/>
<jsp:setProperty name="rPH" property="pgNoBlankMsg" value="Fields marked with a pen are required"/>
<jsp:setProperty name="rPH" property="pgRFQType" value="RFQ TYPE"/>

<jsp:setProperty name="rPH" property="pgTSDRQNoHistory" value="Delevery Request Questionnaire Doc. History"/>
<jsp:setProperty name="rPH" property="pgCustNo" value="Customer No."/>
<jsp:setProperty name="rPH" property="pgCustomerName" value="Customer name"/>
<jsp:setProperty name="rPH" property="pgRequireReason" value="Delivery Require Reason"/>
<jsp:setProperty name="rPH" property="pgProcessMark" value="Process Remark"/>
<jsp:setProperty name="rPH" property="pgCreateFormUser" value="Create User"/>
<jsp:setProperty name="rPH" property="pgCreateFormDate" value="Create Date"/>
<jsp:setProperty name="rPH" property="pgCreateFormTime" value="Create Time"/>
<jsp:setProperty name="rPH" property="pgPreProcessUser" value="PreProcess User"/>
<jsp:setProperty name="rPH" property="pgPreProcessDate" value="PreProcess Date"/>
<jsp:setProperty name="rPH" property="pgPreProcessTime" value="PreProcess Time"/>
<jsp:setProperty name="rPH" property="pgProdTransferTo" value="Prod. Transfer To "/>
<jsp:setProperty name="rPH" property="pgDocTotAssignFac" value="Doc. Total assign Manufactory "/>
<jsp:setProperty name="rPH" property="pgDocAssignFac" value="Assign Manufactory "/>
<jsp:setProperty name="rPH" property="pgDRQDocProcess" value="Delevery Request Questionnaire Process "/>
<jsp:setProperty name="rPH" property="pgDRQInquiryReport" value="Delevery Request Inquiry and Reporting "/>
<jsp:setProperty name="rPH" property="pgSalesOrder" value="Sales Order "/>
<jsp:setProperty name="rPH" property="pgFirmOrderType" value="Order Type"/>
<jsp:setProperty name="rPH" property="pgIdentityCode" value="Customer Identifier"/>
<jsp:setProperty name="rPH" property="pgSoldToOrg" value="Sold To Org. "/>
<jsp:setProperty name="rPH" property="pgPriceList" value="Price List "/>
<jsp:setProperty name="rPH" property="pgShipToOrg" value="Ship To Location "/>
<jsp:setProperty name="rPH" property="pgGenerateInf" value="Refer. Information "/>
<jsp:setProperty name="rPH" property="pgWait" value="Wait for "/>
<jsp:setProperty name="rPH" property="pgConfirm" value="Book "/>
<jsp:setProperty name="rPH" property="pgTSCAlias" value="TSC "/>
<jsp:setProperty name="rPH" property="pgOrderedItem" value="Ordered Item "/>
<jsp:setProperty name="rPH" property="pgOR" value="Or "/>
<jsp:setProperty name="rPH" property="pgBillTo" value="Bill To Location "/>
<jsp:setProperty name="rPH" property="pgDeliverTo" value="Deliver To Location "/>
<jsp:setProperty name="rPH" property="pgPaymentTerm" value="Payment Terms "/>
<jsp:setProperty name="rPH" property="pgFOB" value="FOB "/>
<jsp:setProperty name="rPH" property="pgShippingMethod" value="Shipping Method "/>
<jsp:setProperty name="rPH" property="pgIntExtPurchase" value="Int. / Ext. Purchase "/>
<jsp:setProperty name="rPH" property="pgPackClass" value="Packing Class "/>
<jsp:setProperty name="rPH" property="pgKPC" value="(KPC)"/>
<jsp:setProperty name="rPH" property="pgUOM" value="UOM"/>
<jsp:setProperty name="rPH" property="pgNewRequestDate" value="Reset Request Date "/>
<jsp:setProperty name="rPH" property="pgTempDRQDoc" value="Temporary Document "/>
<jsp:setProperty name="rPH" property="pgExceedValidDate" value="Customer Confirm date > Sales Planner Responding for 4 Days "/>
<jsp:setProperty name="rPH" property="pgMark" value="Mark "/>
<jsp:setProperty name="rPH" property="pgDenote" value="Means "/>
<jsp:setProperty name="rPH" property="pgInvalidDoc" value="This Document is already invalid "/>
<jsp:setProperty name="rPH" property="pgProdPC" value="Factory PC "/>
<jsp:setProperty name="rPH" property="pgSalesPlanner" value="Sales Planner "/>
<jsp:setProperty name="rPH" property="pgProdFactory" value="Product Factory "/>
<jsp:setProperty name="rPH" property="pgSalesPlanDept" value="Sales Plan Dept. "/>
<jsp:setProperty name="rPH" property="pgReAssign" value="Re-Assign "/>
<jsp:setProperty name="rPH" property="pgRequestDate" value="Request Date "/>
<jsp:setProperty name="rPH" property="pgFDeliveryDate" value="Factory Delivery Date "/>
<jsp:setProperty name="rPH" property="pgReturnTWN" value="Return to TWN"/>
<jsp:setProperty name="rPH" property="pgCustItemNo" value="Customer Item No. "/>
<jsp:setProperty name="rPH" property="pgPCAssignDate" value="PC Assignment Date "/>
<jsp:setProperty name="rPH" property="pgFTArrangeDate" value="Factory Arrange Delivery Date "/>
<jsp:setProperty name="rPH" property="pgFTConfirmDate" value="Factory Confirm Delivery Date "/>
<jsp:setProperty name="rPH" property="pgPCConfirmDate" value="PC Confirm Delivery Date "/>
<jsp:setProperty name="rPH" property="pgOrdCreateDate" value="Sales Order Create Date "/>
<jsp:setProperty name="rPH" property="pgAlertSysNotAllowGen" value="System not allow to generate "/>
<jsp:setProperty name="rPH" property="pgReject" value="Reject "/>
<jsp:setProperty name="rPH" property="pgAbortToTempDRQ" value="Copy contents to new RFQ Doc. "/>
<jsp:setProperty name="rPH" property="pgChoice" value="Choose "/>
<jsp:setProperty name="rPH" property="pgAbortBefore" value="Abort the original "/>
<jsp:setProperty name="rPH" property="pgSetup" value="Setup "/>
<jsp:setProperty name="rPH" property="pgOrdCreate" value="Sales Order Generate "/>
<jsp:setProperty name="rPH" property="pgOrgOrder" value="Org. Order No."/>
<jsp:setProperty name="rPH" property="pgOrgOrderDesc" value="Please Choose a created MO to append new line..."/>
<jsp:setProperty name="rPH" property="pgFactDiffMsg" value="You can not choose a different Manufactory process MO Combine!!!"/>
<jsp:setProperty name="rPH" property="pgOrderChMsg" value="Choose an OPEN and non-BOOK MO"/>
<jsp:setProperty name="rPH" property="pgQALLToolTipMsg" value="Please follow PC assignment factory batch generate MO"/>
<jsp:setProperty name="rPH" property="pgAppendMOMsg" value="Please choose an exixtence MO to combine process!!!"/>
<jsp:setProperty name="rPH" property="pgEndCustPO" value="End Customer PO"/>
<jsp:setProperty name="rPH" property="pgAlertMOCmbSubmit" value="Are you sure you want to Combine Sales Order??"/>
<jsp:setProperty name="rPH" property="pgAlterGenAbort" value="Are you sure you want Abort generate Order??\n You can re-Create RFQ by click Copy contents to new RFQ Doc. checkbox!!!"/>
<jsp:setProperty name="rPH" property="pgAlertBranchConfirm" value="Please check the branch office had processed the branch confirm action on Invoice System !!!"/>
<jsp:setProperty name="rPH" property="pgSystemHint" value="System Hint"/>

<jsp:setProperty name="rPH" property="pgItemContent" value="An Item "/>
<jsp:setProperty name="rPH" property="pgRFQProcessStatus" value="RFQ Process Status "/>

<jsp:setProperty name="rPH" property="pgRFQProcessSummary" value="RFQ Status Summary "/>
<jsp:setProperty name="rPH" property="pgRFQProcessing" value="Processing "/>
<jsp:setProperty name="rPH" property="pgRFQDOCNoClosed" value="Closed "/>
<jsp:setProperty name="rPH" property="pgRFQCompleteRate" value="Complete Rate "/>
<jsp:setProperty name="rPH" property="pgSPCProcessSummary" value="PC Process Summary "/>
<jsp:setProperty name="rPH" property="pgFCTProcessSummary" value="Factory Process Summary "/>
<jsp:setProperty name="rPH" property="pgTTEW" value="T-TEW "/>
<jsp:setProperty name="rPH" property="pgYYEW" value="Y-YEW "/>
<jsp:setProperty name="rPH" property="pgIILAN" value="I-ILAN "/>
<jsp:setProperty name="rPH" property="pgSILAN" value="S-ILAN "/>
<jsp:setProperty name="rPH" property="pgOILAN" value="O-ILAN "/>
<jsp:setProperty name="rPH" property="pgNTaipei" value="N-NBU "/>
<jsp:setProperty name="rPH" property="pgRFQTemporary" value="Temporary Creating "/>
<jsp:setProperty name="rPH" property="pgRFQAssigning" value="Assigning "/>
<jsp:setProperty name="rPH" property="pgRFQEstimating" value="Estimating "/>
<jsp:setProperty name="rPH" property="pgRFQArrenged" value="Arranged "/>
<jsp:setProperty name="rPH" property="pgRFQResponding" value="Responding "/>
<jsp:setProperty name="rPH" property="pgRFQConfirmed" value="Confirmed "/>
<jsp:setProperty name="rPH" property="pgRFQGenerating" value="Generating "/>
<jsp:setProperty name="rPH" property="pgRFQClosed" value="Closed "/>
<jsp:setProperty name="rPH" property="pgRFQAborted" value="Aborted "/>
<jsp:setProperty name="rPH" property="pgProcessQty" value="Process Q'ty "/>
<jsp:setProperty name="rPH" property="pgNewNo" value="New "/>
<jsp:setProperty name="rPH" property="pgALogDesc" value="RFQ Record Count in datetime period by Sales Area "/>
<jsp:setProperty name="rPH" property="pgYellowItem" value="Yellow Item "/>
<jsp:setProperty name="rPH" property="pgItemExistsMsg" value="The Item does not exists for that ORG. with respect to choose Order Type "/>
<jsp:setProperty name="rPH" property="pgWorkHour" value="Working Hour "/>
<jsp:setProperty name="rPH" property="pgtheItem" value="The Item "/>
<jsp:setProperty name="rPH" property="pgRFQRequestDateMsg" value="Request Date cannot less today!!"/>
<jsp:setProperty name="rPH" property="pgNonProcess" value="Non-Process"/>
<jsp:setProperty name="rPH" property="pgPlanRspPeriod" value="PC Response RFQ for/Hours"/>

<jsp:setProperty name="rPH" property="pgDeliverCustomer" value="Deliver To Customer "/>
<jsp:setProperty name="rPH" property="pgDeliverLocation" value="Deliver To Location "/>
<jsp:setProperty name="rPH" property="pgDeliverContact" value="Deliver to Contact "/>
<jsp:setProperty name="rPH" property="pgDeliveryTo" value="Deliver To "/>
<jsp:setProperty name="rPH" property="pgDeliverAddress" value="Deliver To Contact "/>
<jsp:setProperty name="rPH" property="pgNotifyContact" value="Notify To Contact "/>
<jsp:setProperty name="rPH" property="pgNotifyLocation" value="Notify To Location "/>
<jsp:setProperty name="rPH" property="pgShipContact" value="Ship To Contact "/>
<jsp:setProperty name="rPH" property="pgMain" value="Main "/>
<jsp:setProperty name="rPH" property="pgOthers" value="Others "/>
<jsp:setProperty name="rPH" property="pgFactoryResponse" value="Factory Response "/>
<jsp:setProperty name="rPH" property="pgWith" value="With "/>
<jsp:setProperty name="rPH" property="pgDetailRpt" value="Detail Report "/>
<jsp:setProperty name="rPH" property="pgDateType" value="Date Type "/>
<jsp:setProperty name="rPH" property="pgFr" value="From "/>
<jsp:setProperty name="rPH" property="pgTo_" value="To "/>
<jsp:setProperty name="rPH" property="pgSSD" value="Schedule Ship Date "/>
<jsp:setProperty name="rPH" property="pgOrdD" value="Ordered Date"/>
<jsp:setProperty name="rPH" property="pgItmFly" value="Item Family"/>
<jsp:setProperty name="rPH" property="pgItmPkg" value="Item Package"/>
<jsp:setProperty name="rPH" property="pgLDetailSave" value="DETAIL you choosed to be saved"/>
<jsp:setProperty name="rPH" property="pgLCheckDelete" value="CLICK checkbox and choice to delete"/>
<jsp:setProperty name="rPH" property="pgThAccShpQty" value="Acc. Ship Q'ty"/>
<jsp:setProperty name="rPH" property="pgFactoryDeDate" value="Factory Delivery Date "/>
<jsp:setProperty name="rPH" property="pgNoResponse" value="No Response "/>
<jsp:setProperty name="rPH" property="pgAccWorkHours" value="History accumulative working hour/Hours "/>
<jsp:setProperty name="rPH" property="pgPlanRejectItem" value="Reject By Planner items "/>
<jsp:setProperty name="rPH" property="pgSetSampleOrder" value="Sample Order SPQ Check "/>
<jsp:setProperty name="rPH" property="pgSampleOrderCh" value="Sample Order "/>
<jsp:setProperty name="rPH" property="pgQuotation" value="Charge"/>
<jsp:setProperty name="rPH" property="pgLack" value="No "/>
<jsp:setProperty name="rPH" property="pgCRDate" value="Customer Request Date"/>
<jsp:setProperty name="rPH" property="pgSRDate" value="Sales Request Date"/>
<jsp:setProperty name="rPH" property="pgVendorSSD" value="Vendor Delivery Date"/>

<!--start for 出貨發票收料管理 list -->
<jsp:setProperty name="rPH" property="pgInvoiceNo" value="Invoice No. "/>
<jsp:setProperty name="rPH" property="pgPoNo" value="PO. "/>
<jsp:setProperty name="rPH" property="pgAvailableShip" value="Available Ship "/>
<jsp:setProperty name="rPH" property="pgContiune" value="Contiune "/>
<jsp:setProperty name="rPH" property="pgInvBranchConfirm" value="Branch Confirm Requirement(Invoice System)"/>
<!--start for MFG list -->
<jsp:setProperty name="rPH" property="pgInSales" value="Internal Sales "/>
<jsp:setProperty name="rPH" property="pgExpSales" value="Export Sales "/>
<jsp:setProperty name="rPH" property="pgSchStartDate" value="Schedule Start Date "/>
<jsp:setProperty name="rPH" property="pgSchCompletDate" value="Schedule Complet Date "/>
<jsp:setProperty name="rPH" property="pgWafer" value="Wafer "/>
<jsp:setProperty name="rPH" property="pgYield" value="Yield "/>
<jsp:setProperty name="rPH" property="pgEleres" value="Resistance "/>
<jsp:setProperty name="rPH" property="pgVendor" value="Vendor "/>
<jsp:setProperty name="rPH" property="pgInspectNo" value="Inspection No "/>
<jsp:setProperty name="rPH" property="pgRunCardNo" value="Run Card No "/>
<jsp:setProperty name="rPH" property="pgAmpere" value="Ampere "/>
<jsp:setProperty name="rPH" property="pgSingleLot" value="Single Lot "/>
<!-- other-->
<jsp:setProperty name="rPH" property="pgContZero" value="Contain stock is zero "/>
