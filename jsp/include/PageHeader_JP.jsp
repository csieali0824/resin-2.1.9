<%@ page contentType="text/html; charset=MS932" pageEncoding="euc-jp" %>
<meta http-equiv="Content-Type" content="text/html; charset=MS932">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name ="rPH" property ="pgHOME" value ="回族ファストペ-ジ"/>
<jsp:setProperty name ="rPH" property ="pgAllRepLog" value ="問い合わせすべての補修訴訟事件"/>
<jsp:setProperty name ="rPH" property ="pgTxLog" value ="補修する異動記録する"/>
<jsp:setProperty name ="rPH" property ="pgAddWKF" value ="新しさ増加する流程"/>
<jsp:setProperty name ="rPH" property ="pgRemark" value ="注"/>

<jsp:setProperty name ="rPH" property ="pgFormID" value ="流れる時計単識別する"/>
<jsp:setProperty name ="rPH" property ="pgWKFTypeNo" value ="流程種類番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgOriStat" value ="原始的状態"/>
<jsp:setProperty name ="rPH" property ="pgAction" value ="実施する動作"/>
<jsp:setProperty name ="rPH" property ="pgChgStat" value ="変動するあと状態"/>
<jsp:setProperty name ="rPH" property ="pgWKFDESC" value ="流程説明する"/>

<!--次はペ-ジ面の押しボタンでした  -->
<jsp:setProperty name ="rPH" property ="pgSelectAll" value ="選び全部"/>
<jsp:setProperty name ="rPH" property ="pgCancelSelect" value ="取り消す選択する"/>
<jsp:setProperty name ="rPH" property ="pgPlsEnter" value ="招待する入れる"/>
<jsp:setProperty name ="rPH" property ="pgDelete" value ="消除する"/>
<jsp:setProperty name ="rPH" property ="pgSave" value ="公文書をファイルに保存する"/>
<jsp:setProperty name ="rPH" property ="pgAdd" value ="新しさ増加する"/>
<jsp:setProperty name ="rPH" property ="pgOK" value ="確定する"/>
<jsp:setProperty name ="rPH" property ="pgFetch" value ="持ちこむ"/>
<jsp:setProperty name ="rPH" property ="pgQuery" value ="問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgSearch" value ="捜す"/>
<jsp:setProperty name ="rPH" property ="pgExecute" value ="実施する"/>
<jsp:setProperty name ="rPH" property ="pgReset" value ="もう一度おく"/>

<!--明細書ペ-ジ面の相関情報 -->
<jsp:setProperty name ="rPH" property ="pgPage" value ="ペ-ジ"/>
<jsp:setProperty name ="rPH" property ="pgPages" value ="ペ-ジ"/>
<jsp:setProperty name ="rPH" property ="pgFirst" value ="一番目"/>
<jsp:setProperty name ="rPH" property ="pgLast" value ="最後一"/>
<jsp:setProperty name ="rPH" property ="pgPrevious" value ="受ける一"/>
<jsp:setProperty name ="rPH" property ="pgNext" value ="作る一"/>
<jsp:setProperty name ="rPH" property ="pgTheNo" value ="第"/>
<jsp:setProperty name ="rPH" property ="pgTotal" value ="全部で"/>
<jsp:setProperty name ="rPH" property ="pgRecord" value ="筆記録音する"/>
<jsp:setProperty name ="rPH" property ="pgRPProcess" value ="補修する訴訟事件処理する"/>
<jsp:setProperty name ="rPH" property ="pgAllRecords" value ="すべての記録する"/>
<jsp:setProperty name ="rPH" property ="pgCode" value ="マ-ク"/>

<!--次は訴訟事件のメ-タ-を補修した  -->
<jsp:setProperty name ="rPH" property ="pgRepTitle" value ="制品機能補修書き付け"/>
<jsp:setProperty name ="rPH" property ="pgRepNote" value ="きっとために手すりは位置を書き入れるで，ぜひ詰めこんで下さいた相関資料"/>
<jsp:setProperty name ="rPH" property ="pgRepCenter" value ="補修注文する"/>
<jsp:setProperty name ="rPH" property ="pgAgent" value ="取次販売する/コマ-シャルエ-ジェント"/>
<jsp:setProperty name ="rPH" property ="pgRecDate" value ="引き取りを育てる期日"/>
<jsp:setProperty name ="rPH" property ="pgRecCenter" value ="引き取りを育てる機関"/>
<jsp:setProperty name ="rPH" property ="pgRecPerson" value ="受け取り人"/>
<jsp:setProperty name ="rPH" property ="pgCustomer" value ="顧客名前"/>
<jsp:setProperty name ="rPH" property ="pgTEL" value ="連絡電話"/>
<jsp:setProperty name ="rPH" property ="pgCell" value ="携帯電話"/>
<jsp:setProperty name ="rPH" property ="pgAddr" value ="アドレス"/>
<jsp:setProperty name ="rPH" property ="pgZIP" value ="郵便番号"/>
<jsp:setProperty name ="rPH" property ="pgBuyingPlace" value ="買う地点"/>
<jsp:setProperty name ="rPH" property ="pgBuyingDate" value ="買う期日"/>
<jsp:setProperty name ="rPH" property ="pgSvrDocNo" value ="サ-ビスする奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgPart" value ="推測する号"/>
<jsp:setProperty name ="rPH" property ="pgPartDesc" value ="規格説明"/>
<jsp:setProperty name ="rPH" property ="pgModel" value ="制品サイズ"/>
<jsp:setProperty name ="rPH" property ="pgColor" value ="携帯電話色"/>
<jsp:setProperty name ="rPH" property ="pgIMEI" value ="IMEI順序号"/>
<jsp:setProperty name ="rPH" property ="pgDSN" value ="制品順序号"/>
<jsp:setProperty name ="rPH" property ="pgRecItem" value ="引き取りを育てる項目"/>
<jsp:setProperty name ="rPH" property ="pgJam" value ="故障説明する"/>
<jsp:setProperty name ="rPH" property ="pgOtherJam" value ="ほかの故障説明する"/>
<jsp:setProperty name ="rPH" property ="pgFreq" value ="故障頻度"/>
<jsp:setProperty name ="rPH" property ="pgWarranty" value ="保証する丈夫類別"/>
<jsp:setProperty name ="rPH" property ="pgValid" value ="保証するなか"/>
<jsp:setProperty name ="rPH" property ="pgInvalid" value ="保証する外部"/>
<jsp:setProperty name ="rPH" property ="pgWarrNo" value ="保証する再三カ-ド号"/>
<jsp:setProperty name ="rPH" property ="pgSvrType" value ="サ-ビスする類型"/>
<jsp:setProperty name ="rPH" property ="pgRepStatus" value ="状態"/>
<jsp:setProperty name ="rPH" property ="pgRepNo" value ="訴訟事件番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgRecItem2" value ="あとおくる補修する引き取りを育てる項目"/>
<jsp:setProperty name ="rPH" property ="pgWarranty2" value ="判定するあと保証する丈夫類別"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl" value ="補修する等級"/>
<jsp:setProperty name ="rPH" property ="pgRepHistory" value ="補修する歴史記録"/>
<jsp:setProperty name ="rPH" property ="pgDOAPVerify" value ="DOA /DAP判定するところが明細の"/>
<jsp:setProperty name ="rPH" property ="pgPreRPAct" value ="見通し補修する方法"/>
<jsp:setProperty name ="rPH" property ="pgActualRPAct" value ="現実補修する方法"/>
<jsp:setProperty name ="rPH" property ="pgSoftwareVer" value ="ソフトウェア版本"/>
<jsp:setProperty name ="rPH" property ="pgChgIMEI" value ="換えるのIMEI"/>
<jsp:setProperty name ="rPH" property ="pgActualRPDesc" value ="実際的補修説明する"/>
<jsp:setProperty name ="rPH" property ="pgPreUseMaterial" value ="見通し補修する費やす推測する"/>
<jsp:setProperty name ="rPH" property ="pgUseMaterial" value ="補修する費やす推測する"/>
<jsp:setProperty name ="rPH" property ="pgRPReason" value ="補修する項目あるいは分析説明する"/>
<jsp:setProperty name ="rPH" property ="pgQuotation" value ="オファ-する費用項目"/>
<jsp:setProperty name ="rPH" property ="pgRPCost" value ="補修する費用"/>
<jsp:setProperty name ="rPH" property ="pgPartCost" value ="材料費用"/>
<jsp:setProperty name ="rPH" property ="pgTransCost" value ="運搬費"/>
<jsp:setProperty name ="rPH" property ="pgOtherCost" value ="ほかの費用"/>
<jsp:setProperty name ="rPH" property ="pgExecutor" value ="動作実施者"/>
<jsp:setProperty name ="rPH" property ="pgExeTime" value ="実施する時間"/>
<jsp:setProperty name ="rPH" property ="pgAssignTo" value ="任名するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgRepPerson" value ="サ-ビスマン"/>
<jsp:setProperty name ="rPH" property ="pgTransferTo" value ="「それの補修を転移する注文すると希望するます」"/>
<jsp:setProperty name ="rPH" property ="pgMailNotice" value ="e-Mail知らせる"/>
<jsp:setProperty name ="rPH" property ="pgWorkTime" value ="平均労動時間"/>
<jsp:setProperty name ="rPH" property ="pgWorkTimeMsg" value ="機関/時間"/>
<jsp:setProperty name ="rPH" property ="pgLotNo" value ="荷口番号"/>
<jsp:setProperty name ="rPH" property ="pgSymptom" value ="故障病状"/>
<jsp:setProperty name ="rPH" property ="pgRecType" value ="引き取りを育てる出所型形"/>
<jsp:setProperty name ="rPH" property ="pgPCBA" value ="きっかけ板"/>
<jsp:setProperty name ="rPH" property ="pgRepeatRepInput" value ="「期限をもう一度覆って渡すてペ-ジ面に入れるときくます」"/>
<jsp:setProperty name ="rPH" property ="pgWarrLimit" value ="保証する丈夫期限"/>

<!--次は処理の中にの訴訟事件のメ-タ-を補修した  -->
<jsp:setProperty name ="rPH" property ="pgAddMaterial" value ="選択する補修推測する"/>
<jsp:setProperty name ="rPH" property ="pgSituation" value ="きっかけまして確認する項目"/>
<jsp:setProperty name ="rPH" property ="pgSituationMsg" value ="「もしならてオファ-するて選挙されて書き入れる必要がある」"/>

<!--子のウェンドスについての情報 -->
<jsp:setProperty name ="rPH" property ="pgRelevantInfo" value ="相関情報"/>
<jsp:setProperty name ="rPH" property ="pgEnterCustIMEI" value ="「取引先に入れる名前あるいはIMEI順序の号を招待するます」"/>
<jsp:setProperty name ="rPH" property ="pgSearchByAgency" value ="たよる取次販売商/コマ-シャルエ-ジェント問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgSearchByCustIMEI" value ="たよる取引先/IMEI問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgEnterAgency" value ="招待する入れる取次販売商/コマ-シャルエ-ジェント名称"/>
<jsp:setProperty name ="rPH" property ="pgInputPart" value ="転換するに推測する号入れる"/>
<jsp:setProperty name ="rPH" property ="pgChoosePart" value ="転換するに推測する号選択する"/>
<jsp:setProperty name ="rPH" property ="pgQty" value ="数量"/>

<!--JavaScriptの中の警告文の句 -->
<jsp:setProperty name ="rPH" property ="pgAlertAction" value ="まずあなたが実施したい動作のあとでまた公文書をファイルに保存したことを選択してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertModel" value ="まずMODELを選択したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertSvrDocNo" value ="まずサ-ビスの奇数番号を詰めこんだあとさらに公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertCustomer" value ="まず販売取引先を詰めこんだあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertSvrType" value ="まず選んで注文状類型を書き入れたあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertJam" value ="まず故障を選んで説明したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertIMEI" value ="この携帯電話のIMEI順序の号に入れてください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertCancel" value ="あなたはCANCELがほしかったと確定しましたか。 ?" />
<jsp:setProperty name ="rPH" property ="pgAlertAssign" value ="まずあなたの任名したい産地を選択してくださいたあとさらにSubmit！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertSubmit" value ="まずあなた実施したい動作あとさらにSubmitを選択してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRepLvl" value ="まず詰めこんで等級を補修してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertLvl3" value ="「補修は等級が3級，あと(TRANSMIT)に宿題おくるで下さいあなたが決めた！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertNonLvl3" value ="「補修は等級が3級，あと(TRANSMIT)に宿題おくる必要があるあなたが決めた！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertReassign" value ="もう一度任名する原因をまず入れるて説明止めてまたれてもう一度"「REASSIGN」"を任名する！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertTransfer" value ="ちょっと転移する補修をまず選定されて希望するたあとまた転移する"「TRANSFER」"なことを！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRecItem2" value ="きっとほしがって選挙して入れたあとおくって補修して項目を収めてください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertSoftVer" value ="あなたの選択した補修の方法によって，まずソフトウェア版本を詰めこんだあとまたこの訴訟事件を完成してください！" />
<jsp:setProperty name ="rPH" property ="pgAlertChgIMEI" value ="あなた補修選択した方法によってまず詰めこんて改めるIMEIのあとまたこの訴訟事件を完成するで下さい！" />
<jsp:setProperty name ="rPH" property ="pgAlertWorkTime" value ="「実際的に完成する労動時間をあなたに入れるて"「機関は時間計算する」"を数える」"/>
<jsp:setProperty name ="rPH" property ="pgAlertRPMaterial" value ="あなたの選択した補修の方法が対応した，まず選択して補修してを推測してくださいたあとさらにSubmitI！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRPReason" value ="ぜひ選択されてもう一度派遣するて下さい/口はマ-クが退くれてそれに"「Set」"あとにさらにSubmitを確定する！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRPAction" value ="ぜひ選択して実際的に方法を補修して下さいあとさらにSubmit！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertSymptom" value ="ぜひ故障の特別な徴を選択して下さいあとさらにSubmit！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertQty" value ="まずあなたを詰めこんで実際的にを収める数量のあとでまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertItemNo" value ="まず BPCSの真実を詰めこんで号を推測したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgErrorQty" value ="まず数量を修正したあとまた公文書をファイルに保存してくださいHandsetあるいはPCB一つの書き付け1個だけ！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRecType" value ="まず適当的な出所の型の形を収めを選択したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertDOAPIMEI" value ="あなたの選択したサ-ビスの類型はDOA / DAPだから，まず換えたIMEIを詰めこんでください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertChgSvrType" value ="サ-ビスの類型を改めたくたと確定しましたか。" />
<jsp:setProperty name ="rPH" property ="pgAlertPcba" value ="まずきっかけの板の真実を詰めこんで号を推測したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertMOGenSubmit" value ="あなたは注文状を生成したいと確定しましたか。 ?" />
<jsp:setProperty name ="rPH" property ="pgAlertPriceList" value ="プライスリストのあと取引先を選択してから公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertShipAddress" value ="まず商品のアドレスを選択出したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertBillAddress" value ="勘定アドレスのあと立ったことを選択してから公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertPayTerm" value ="まず支はらい条件を選択したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertFOB" value ="まずFOBを選択したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertShipMethod" value ="まず商品の方法を選択出したあとまた公文書をファイルに保存してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertCheckLineFlag" value ="まず選択してそのなかにペンの項目のあとでまた公文書をファイルに保存する！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertCreateDRQ" value ="生み出して期限を渡して一人のきいたと確認しましたか。 \n もし希望して預ける草稿公文書実現すった，TEMPORARYがまた公文書をファイルに保存したことを選択してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertReProcessMsg" value ="引き続きこの証票を処理しましたか。 ?" />
<jsp:setProperty name ="rPH" property ="pgAlertShipBillMsg" value ="このを検査するて取引先のは商品が出る/立つ勘定は地情報！ ! \n 系統はあなたが確定したことを見付けないです {主でした }商品/内容を勘定が立つ，ここもう一度決定あなたはかかるだ。 \n                    さもないと注文状の誤ちを生成したことを招来しやすかった！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertItemOrgAssignMsg" value ="証票の明細書は内包それが商品番号をアレンジしたことを指定しなかったです！ ! \n エロ-項目商品番号に気を配ってあるいは相談して相関スタッフは確定して商品番号はアレンジして任名したください！ ! \n(相対する選択する注文状類型)"/>
<jsp:setProperty name ="rPH" property ="pgAlertItemExistsMsg" value ="注文状は生成して明細書は内包Oracle系統の商品番号\ nに存在しなかった     相談して相関スタッフは商品番号がもう打ち建てたと確認してください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRFQCreateMsg" value ="業務は期限を渡して一人の新しくもう一度失敗したとききました！ ! ,\n 照会して情報部は原因を調べて明らかにしてくださいまたはもう一度覆って入れなくてただ項を選挙したときくことを選択しました！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertRFQCreateDtlMsg" value ="この業務は期限を渡してただ明細の項がないとききました！ ! ,\n 系統のコントロ-ラを相談してくださいまたはもう一度覆って入れなくてただ項を選んで原因を調べて明らかにしたときくことを選択しました！ !" />

<!--submitのあとの提示の句でした -->
<jsp:setProperty name ="rPH" property ="pgFreqReturn" value ="直おす回数"/>
<jsp:setProperty name ="rPH" property ="pgFreqReject" value ="退く修理する回数"/>

<!--ペ-ジ面は転換して超えて結びがつながった -->
<jsp:setProperty name ="rPH" property ="pgPageAddRMA" value ="「新しさは増加するて補修するて記録を引き取りを育てる」"/>
<jsp:setProperty name ="rPH" property ="pgPage3AddRMA" value ="新しく増加するて三級は補修する引き取りを育てる記録"/>
<jsp:setProperty name ="rPH" property ="pgPageAssign" value ="「労動者はあたって訴訟事件を補修するます」"/>
<jsp:setProperty name ="rPH" property ="pgPage3Assign" value ="「三級は差し向けて労動者はあたるて訴訟事件を補修する」"/>

<!--Send Mailの内容 -->
<jsp:setProperty name ="rPH" property ="pgMailSubjectAssign" value ="から来る補修系統の任名する"/>

<!--返して一人の内容を署名して受け取った -->
<jsp:setProperty name ="rPH" property ="pgCustReceipt" value ="「補修して味うて一人のにを返すれて署名して受け取るます」"/>
<jsp:setProperty name ="rPH" property ="pgTransList" value ="あとおくる補修品物明細書"/>
<jsp:setProperty name ="rPH" property ="pgTransDate" value ="あとおくる期日"/>
<jsp:setProperty name ="rPH" property ="pgListNo" value ="明細書番号をつける(荷口番号)"/>
<jsp:setProperty name ="rPH" property ="pgReceiptNo" value ="署名して受け取る奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgShipDate" value ="商品期日"/>
<jsp:setProperty name ="rPH" property ="pgShipper" value ="責任者"/>
<jsp:setProperty name ="rPH" property ="pgCustSign" value ="取引先署名して受け取る"/>
<jsp:setProperty name ="rPH" property ="pgPSMessage1" value ="于さんに受け取って補修して味って遅れたなかったあと取引先で所を署名して受け取ってサインしてリタ-ン?パスしたと確認してもらいました； にファクスする"/>
<jsp:setProperty name ="rPH" property ="pgPSMessage2" value ="たとえばどんな問題が私と連絡したことを招待しました。 連絡電話"/>
<jsp:setProperty name ="rPH" property ="pgWarnMessage" value ="本社は太陽を送るために標準して，3 日のうちにリタ-ン?パスしなかった見てもう受け取るた； もし争論がいるなら各で下さいて機関自分で責任を負うます」"/>

<!--入庫して一人の内容を署名して受け取った -->
<jsp:setProperty name ="rPH" property ="pgInStockLotList" value ="DOA / DAP工　は補修するますの入庫する書き付け"/>
<jsp:setProperty name ="rPH" property ="pgInStockNo" value ="入庫する奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgInStockDate" value ="入庫する期日"/>
<jsp:setProperty name ="rPH" property ="pgInStocker" value ="入庫するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgWarehouserSign" value ="倉庫スタッフ署名して受け取る"/>

<!--補修して流程は処理したあと情報画面 -->
<jsp:setProperty name ="rPH" property ="pgPrintCustReceipt" value ="印刷されて補修するなことを並ぶます味われて返すは一人のに署名して受け取る"/>
<jsp:setProperty name ="rPH" property ="pgPrintShippedConfirm" value ="「列のインドRMAの商品確認状」"/>
<jsp:setProperty name ="rPH" property ="pgRepairProcess" value ="普通補修処理する流程"/>
<jsp:setProperty name ="rPH" property ="pgDOAProcess" value ="DOA処理する流程"/>
<jsp:setProperty name ="rPH" property ="pgDAPProcess" value ="DAP処理する流程"/>

<!--くびは申請単を推測した -->
<jsp:setProperty name ="rPH" property ="pgMaterialRequest" value ="枚推測する申請単"/>
<jsp:setProperty name ="rPH" property ="pgTransType" value ="異動類型"/>
<jsp:setProperty name ="rPH" property ="pgConReg" value ="国名/地区"/>
<jsp:setProperty name ="rPH" property ="pgDocNo" value ="証票番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgWarehouseNo" value ="くら別れる"/>
<jsp:setProperty name ="rPH" property ="pgLocation" value ="蓄える位置"/>
<jsp:setProperty name ="rPH" property ="pgPersonal" value ="個人"/>
<jsp:setProperty name ="rPH" property ="pgInvTransInput" value ="在庫品異動入れる"/>
<jsp:setProperty name ="rPH" property ="pgInvTransQuery" value ="在庫品異動問い合わせる"/>

<jsp:setProperty name ="rPH" property ="pgAllMRLog" value ="「すべてのに問い合わせるて枚は訴訟事件を推測するます」"/>
<jsp:setProperty name ="rPH" property ="pgAlertMRReason" value ="選びを招待するて受け取られて推測するます原因"/>
<jsp:setProperty name ="rPH" property ="pgAlertMRChoose" value ="まず選択しれてあなたは申請のを希望するます生地はのあとにはまた公文書をファイルに保存する"/>
<jsp:setProperty name ="rPH" property ="pgApDate" value ="申し出る期日"/>
<jsp:setProperty name ="rPH" property ="pgApplicant" value ="申請人"/>
<jsp:setProperty name ="rPH" property ="pgMRReason" value ="枚推測する原因"/>
<jsp:setProperty name ="rPH" property ="pgInvMagProcess" value ="ストックコントロ-ル宿題"/>
<jsp:setProperty name ="rPH" property ="pgMRProcess" value ="枚推測する訴訟事件処理する"/>
<jsp:setProperty name ="rPH" property ="pgApplyPart" value ="申請推測する"/>
<jsp:setProperty name ="rPH" property ="pgReceivePart" value ="事実枚推測する"/>
<jsp:setProperty name ="rPH" property ="pgMRDesc" value ="推測する号説明する"/>
<jsp:setProperty name ="rPH" property ="pgProvdTime" value ="発推測する時間"/>

<jsp:setProperty name ="rPH" property ="pgMRR" value ="推測する返す申請単"/>
<jsp:setProperty name ="rPH" property ="pgReturnPart" value ="返還推測する"/>
<jsp:setProperty name ="rPH" property ="pgOriWhs" value ="もともと帰属するくら別れる"/>
<jsp:setProperty name ="rPH" property ="pgAlertApplicant" value ="まず申請人を選択してください！ !" />
<jsp:setProperty name ="rPH" property ="pgTransReason" value ="異動原因"/>
<jsp:setProperty name ="rPH" property ="pgMAR" value ="推測する転送申請単"/>
<jsp:setProperty name ="rPH" property ="pgAllotPart" value ="転送推測する"/>
<jsp:setProperty name ="rPH" property ="pgAllottee" value ="調撥するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgAlertAllottee" value ="まず選びはスタッフを調撥されてください！ !" />
<jsp:setProperty name ="rPH" property ="pgAlertTransReason" value ="まず異動の原因を選択してください！ !" />

<!--在庫品の異動 -->
<!--次はDOA / DAPメ-タ-でした -->
<jsp:setProperty name ="rPH" property ="pgVeriSvrType" value ="判定するサ-ビスする類型"/>
<jsp:setProperty name ="rPH" property ="pgVerifyStandard" value ="DOA /DAP判定する標準"/>

<!--補修して材料の使いの勘定を費やしてBPCS(明細を推測するよって)に入った  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByItem" value ="「を補修するてBPCS(明細を推測することよって)を材料の使いを費やすれて勘定は入る」"/>
<jsp:setProperty name ="rPH" property ="pgBPCSInvQty" value ="BPCS在庫品数量"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDate" value ="発推測する期日"/>
<jsp:setProperty name ="rPH" property ="pgIssuePerson" value ="発推測するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgTransComment" value ="異動証票"/>
<jsp:setProperty name ="rPH" property ="pgBalanceQty" value ="締め切る残り数量"/>

<!--補修して材料の使いの勘定を費やしてBPCSに入る(くびよって奇数番号を推測する)  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByMRequest" value ="「の勘定を材料の使いを費やすれて入るBPCS"「くびよって奇数番号を推測する」"を補修するます」"/>
<jsp:setProperty name ="rPH" property ="pgCheckItem" value ="選択する"/>
<jsp:setProperty name ="rPH" property ="pgPreparePost2BPCS" value ="ペン資料待つ記帳するBPCS"/>

<!--補修して材料の使いの勘定を費やしてBPCSに入る(サ-ビスエンジニヤをたよる)  -->
<jsp:setProperty name ="rPH" property ="pgRepPostByRPEngineer" value ="「勘定は入るBPCS"「サ-ビスエンジニヤをたよる」"を補修しては材料の使いを費やす」"です/>
<jsp:setProperty name ="rPH" property ="pgRepairEngineer" value ="サ-ビスエンジニヤ"/>
<jsp:setProperty name ="rPH" property ="pgItemQty" value ="「ペンの生地ののうなじさん数」"です/>
<jsp:setProperty name ="rPH" property ="pgMRItemQty" value ="口数"/>

<!--次はコマ-シャルエ-ジェント/取次販売商の資料でした -->
<jsp:setProperty name ="rPH" property ="pgInfo" value ="根本的資料"/>
<jsp:setProperty name ="rPH" property ="pgName" value ="名称"/>
<jsp:setProperty name ="rPH" property ="pgNo" value ="番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgDepend" value ="属する補修する引き取りを育てる機関"/>
<jsp:setProperty name ="rPH" property ="pgContact" value ="連絡する人"/>
<jsp:setProperty name ="rPH" property ="pgFAX" value ="ファックス"/>
<jsp:setProperty name ="rPH" property ="pgKeyAccount" value ="かぎ取次販売する/コマ-シャルエ-ジェント"/>
<jsp:setProperty name ="rPH" property ="pgEdit" value ="編集者"/>

<!--次はペ-ジ面の資料を問い合わせた -->
<!--補修センタ-へ毎日もうBPCS問い合わせに記帳する -->
<jsp:setProperty name ="rPH" property ="pgCentPBpcsTitle" value ="補修センタ-毎日もう記帳するBPCS問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgPostDateFr" value ="記帳する一日起きる"/>
<jsp:setProperty name ="rPH" property ="pgPostDateTo" value ="記帳する日本まで"/>
<jsp:setProperty name ="rPH" property ="pgPostDate" value ="記帳する期日"/>
<jsp:setProperty name ="rPH" property ="pgBelPerson" value ="帰属するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgTransTime" value ="異動時間"/>
<jsp:setProperty name ="rPH" property ="pgExecPerson" value ="実施するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgBPCSSerial" value ="BPCS順序号"/>
<!--モデルを補修して月に費やしましたおよびコスト問い合わせ推測しました -->
<jsp:setProperty name ="rPH" property ="pgModelConsumeTitle" value ="補修しますモデルの月は費やすれておよびコスト問い合わせると推測するます"/>
<jsp:setProperty name ="rPH" property ="pgRpPartsCostTable" value ="補修する費やす材料の使いコストプライスリスト"/>
<jsp:setProperty name ="rPH" property ="pgAnItem" value ="うなじ回"/>
<jsp:setProperty name ="rPH" property ="pgPartsConsumQty" value ="推測する費やす使用量"/>
<jsp:setProperty name ="rPH" property ="pgCostPrice" value ="コスト価格"/>
<jsp:setProperty name ="rPH" property ="pgAccPartsPrice" value ="推測する価格若い計算する"/>
<jsp:setProperty name ="rPH" property ="pgGTotal" value ="総計する"/>
<jsp:setProperty name ="rPH" property ="pgCostMainten" value ="補修する補修する費用表"/>
<jsp:setProperty name ="rPH" property ="pgRPQuantity" value ="補修する件数"/>
<jsp:setProperty name ="rPH" property ="pgStdServiceFee" value ="標準補修代/時間"/>
<jsp:setProperty name ="rPH" property ="pgActServiceFee" value ="現実的補修代/時間"/>
<jsp:setProperty name ="rPH" property ="pgModelFeeSubTotal" value ="モデル費用若い計算する"/>
<!--月故障の原因の分布する問い合わせでした -->
<jsp:setProperty name ="rPH" property ="pgMonthFaultReasonTitle" value ="月故障原因分布問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgRate" value ="比率"/>

<!--BPCS勘定照会する問い合わせを補修してくびは一人の毎日記帳したと推測した -->
<jsp:setProperty name ="rPH" property ="pgMaterialReqBPCSTitle" value ="補修するくびは推測する一人の毎日記帳するBPCSは勘定照会されて問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDateFr" value ="配って期日を推測した  起きる"/>
<jsp:setProperty name ="rPH" property ="pgIssuePartsDateTo" value ="配って期日を推測した  まで"/>
<jsp:setProperty name ="rPH" property ="pgMatRequestForm" value ="枚推測する奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgRepairNo" value ="補修する奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgDetail" value ="明細"/>
<jsp:setProperty name ="rPH" property ="pgBPCSNo" value ="BPCS奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgBPCSDetail" value ="BPCS明細"/>

<!--サ-ビスエンジニヤのくびは推測する/くらは徒事して配るて推測する紀録する問い合わせ -->
<jsp:setProperty name ="rPH" property ="pgMaterialReqIssTitle" value ="サ-ビスエンジニヤのくびは推測する/くらは徒事して配るれて推測するれて紀録されて問い合わせる"/>

<!--くびは申請単が印刷したことを並んだと推測した -->
<jsp:setProperty name ="rPH" property ="pgMReqInquiryLink" value ="枚紀録すると推測するますペ-ジを問い合わせるます"/>
<jsp:setProperty name ="rPH" property ="pgYear" value ="年"/>
<jsp:setProperty name ="rPH" property ="pgMonth" value ="月"/>
<jsp:setProperty name ="rPH" property ="pgDay" value ="太陽"/>
<jsp:setProperty name ="rPH" property ="pgS17DOAP" value ="S17取引先新しい商品悪い物品を取り換える"/>
<jsp:setProperty name ="rPH" property ="pgS11MaterialReq" value ="S11悪い新しい商品枚推測する"/>
<jsp:setProperty name ="rPH" property ="pgS18WarrIn" value ="「生地をくびを補修をS18はうちを保証するます」"/>
<jsp:setProperty name ="rPH" property ="pgS19WarrOut" value ="「生地をくびをS19は外部の補修を保証するます」"/>
<jsp:setProperty name ="rPH" property ="pgEmpNo" value ="従業員番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgDeptNo" value ="部門名称"/>
<jsp:setProperty name ="rPH" property ="pgAppDesc" value ="申請説明する"/>
<jsp:setProperty name ="rPH" property ="pgItemDesc" value ="品名"/>
<jsp:setProperty name ="rPH" property ="pgItemColor" value ="色"/>
<jsp:setProperty name ="rPH" property ="pgAppQty" value ="申し出る数量"/>
<jsp:setProperty name ="rPH" property ="pgActQty" value ="実数"/>
<jsp:setProperty name ="rPH" property ="pgApproval" value ="審査許可する"/>
<jsp:setProperty name ="rPH" property ="pgChief" value ="主管する"/>
<jsp:setProperty name ="rPH" property ="pgTreasurer" value ="会計"/>
<jsp:setProperty name ="rPH" property ="pgPrintDate" value ="列印刷する期日"/>

<!--携帯電話は情報問い合わせを生産した -->
<jsp:setProperty name ="rPH" property ="pgMESMobileInf" value ="携帯電話生産する情報問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgProdDateFr" value ="生産する期日起きる"/>
<jsp:setProperty name ="rPH" property ="pgProdDateTo" value ="生産する期日まで"/>
<jsp:setProperty name ="rPH" property ="pgSearchStr" value ="「IMEI、DSN、完成品の生地の号、号」"/>
<jsp:setProperty name ="rPH" property ="pgMESSOrderNo" value ="生産する労動者奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgProdItemNo" value ="完成品推測する号"/>
<jsp:setProperty name ="rPH" property ="pgMobileSoftware" value ="携帯電話ソフトウェア版本"/>
<jsp:setProperty name ="rPH" property ="pgLineName" value ="産む線名称"/>
<jsp:setProperty name ="rPH" property ="pgStationName" value ="立つ別名言う"/>
<jsp:setProperty name ="rPH" property ="pgSOrderIn" value ="労動者ただ生産を始める期日"/>
<jsp:setProperty name ="rPH" property ="pgPackingDTime" value ="包装する期日時間"/>
<jsp:setProperty name ="rPH" property ="pgOperator" value ="包装する人員"/>
<jsp:setProperty name ="rPH" property ="pgPMCC" value ="PMCCヤ-ド"/>
<jsp:setProperty name ="rPH" property ="pgBPCSOrder" value ="BPCS 労動者奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgTestBay" value ="生産するテスト立つ"/>
<jsp:setProperty name ="rPH" property ="pgCartonNo" value ="パッキングケ-ス号"/>
<jsp:setProperty name ="rPH" property ="pgProductDetail" value ="証票歴程"/>

<!--取次販売商は毎日ァップロ-ド資料は問い合わせをくり越しした -->
<jsp:setProperty name ="rPH" property ="pgAgentUpfileInf" value ="取次販売商毎日ァップロ-ド資料くり越しする問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgDateFr" value ="期日  起きる"/>
<jsp:setProperty name ="rPH" property ="pgDateTo" value ="期日  まで"/>
<jsp:setProperty name ="rPH" property ="pgAgentNo" value ="取次販売商番号をつける"/>
<jsp:setProperty name ="rPH" property ="pgTransmitFlag" value ="あとおくるかどうか"/>
<jsp:setProperty name ="rPH" property ="pgChgIMEIFlag" value ="換えるIMEI否定する"/>

<!--訴訟事件の資料の問い合わせを補修した  -->
<jsp:setProperty name ="rPH" property ="pgRepairCaseInf" value ="補修訴訟事件資料問い合わせる"/>
<jsp:setProperty name ="rPH" property ="pgTransOption" value ="あとおくる/補修する注文する転移する"/>
<jsp:setProperty name ="rPH" property ="pgRetTimes" value ="覆う修理する回数"/>
<jsp:setProperty name ="rPH" property ="pgFinishStatus" value ="しまう修理する状態"/>
<jsp:setProperty name ="rPH" property ="pgExcelButton" value =" Excel" />
<jsp:setProperty name ="rPH" property ="pgRecTime" value ="引き取りを育てる時間"/>
<jsp:setProperty name ="rPH" property ="pgFinishDate" value ="しまう修理する期日"/>
<jsp:setProperty name ="rPH" property ="pgFinishTime" value ="しまう修理する時間"/>
<jsp:setProperty name ="rPH" property ="pgRepMethod" value ="補修する方法"/>
<jsp:setProperty name ="rPH" property ="pgLastMDate" value ="最後処理する期日"/>
<jsp:setProperty name ="rPH" property ="pgLastMPerson" value ="最後処理するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgRepPercent" value ="補修する比率"/>
<jsp:setProperty name ="rPH" property ="pgNotFoundMsg" value ="「目下のところ資料庫は調べて条件の資料を合致されて問い合わせるない」"/>

<jsp:setProperty name ="rPH" property ="pgServiceLog" value ="サ-ビス"/>
<jsp:setProperty name ="rPH" property ="pgReturnLog" value ="客退く"/>
<jsp:setProperty name ="rPH" property ="pgMobileRepair" value ="携帯電話補修する"/>
<jsp:setProperty name ="rPH" property ="pgCType" value ="類型"/>
<jsp:setProperty name ="rPH" property ="pgShipType" value ="商品"/>

<!--次のファストペ-ジおよびスタッフのために資料を管理しました  -->
<jsp:setProperty name ="rPH" property ="pgMenuInstruction" value ="補修する系統説明するキャビネット"/>
<jsp:setProperty name ="rPH" property ="pgDownload" value ="ダウンロ-ド専区"/>
<jsp:setProperty name ="rPH" property ="pgMenuGroup" value ="技術交流園地"/>
<jsp:setProperty name ="rPH" property ="pgChgPwd" value ="修正するパスワ-ド"/>
<jsp:setProperty name ="rPH" property ="pgBulletin" value ="公告/言いおく"/>
<jsp:setProperty name ="rPH" property ="pgLogin" value ="のぼり入る"/>
<jsp:setProperty name ="rPH" property ="pgLogout" value ="登載する"/>
<jsp:setProperty name ="rPH" property ="pgMsgLicence" value ="大きい覇者電子株式有限会社版権所有する"/>
<jsp:setProperty name ="rPH" property ="pgRole" value ="役"/>
<jsp:setProperty name ="rPH" property ="pgList" value ="明細書"/>
<jsp:setProperty name ="rPH" property ="pgNew" value ="新しさ増加する"/>
<jsp:setProperty name ="rPH" property ="pgRevise" value ="修正する"/>
<jsp:setProperty name ="rPH" property ="pgDesc" value ="説明する"/>
<jsp:setProperty name ="rPH" property ="pgSuccess" value ="完成する"/>
<jsp:setProperty name ="rPH" property ="pgAccount" value ="スタッフ"/>
<jsp:setProperty name ="rPH" property ="pgAccountWeb" value ="WEB識別ヤ-ド"/>
<jsp:setProperty name ="rPH" property ="pgMail" value ="電子メ-ル"/>
<jsp:setProperty name ="rPH" property ="pgProfile" value ="大体確定する"/>
<jsp:setProperty name ="rPH" property ="pgPasswd" value ="パスワ-ド"/>
<jsp:setProperty name ="rPH" property ="pgLocale" value ="国名"/>
<jsp:setProperty name ="rPH" property ="pgLanguage" value ="語族"/>
<jsp:setProperty name ="rPH" property ="pgModule" value ="モジュ-ル"/>
<jsp:setProperty name ="rPH" property ="pgSeq" value ="順に並べる号"/>
<jsp:setProperty name ="rPH" property ="pgFunction" value ="機能"/>
<jsp:setProperty name ="rPH" property ="pgRoot" value ="本選択書き付け"/>
<jsp:setProperty name ="rPH" property ="pgHref" value ="つながる締め切るアドレス"/>
<jsp:setProperty name ="rPH" property ="pgAuthoriz" value ="権利を委任する"/>
<jsp:setProperty name ="rPH" property ="pgEmpID" value ="ジオッブ?ナンバ-"/>
<jsp:setProperty name ="rPH" property ="pgRepReceive" value ="補修する受けとる"/>
<jsp:setProperty name ="rPH" property ="pgBasicInf" value ="根本的資料"/>
<jsp:setProperty name ="rPH" property ="pgFLName" value ="名前"/>
<jsp:setProperty name ="rPH" property ="pgID" value ="口座番号"/>

<!--次は伝言版および討論区域資料からでした  -->
<jsp:setProperty name ="rPH" property ="pgBulletinNotice" value ="公告/言いおく"/>
<jsp:setProperty name ="rPH" property ="pgPublishDate" value ="発表する期日"/>
<jsp:setProperty name ="rPH" property ="pgPublisher" value ="発表する人"/>
<jsp:setProperty name ="rPH" property ="pgPublish" value ="言いおく"/>
<jsp:setProperty name ="rPH" property ="pgTopic" value ="主旨"/>
<jsp:setProperty name ="rPH" property ="pgContent" value ="内容"/>
<jsp:setProperty name ="rPH" property ="pgClassOfTopic" value ="テ-マ類別"/>
<jsp:setProperty name ="rPH" property ="pgTopicOfDiscuss" value ="討論するテ-マ"/>
<jsp:setProperty name ="rPH" property ="pgHits" value ="反応する回数"/>
<jsp:setProperty name ="rPH" property ="pgNewTopic" value ="発表する新しいテ-マ"/>
<jsp:setProperty name ="rPH" property ="pgClass" value ="類別"/>
<jsp:setProperty name ="rPH" property ="pgResponse" value ="返す覆う"/>
<jsp:setProperty name ="rPH" property ="pgReturn" value ="エタ-ン"/>
<jsp:setProperty name ="rPH" property ="pgRespond" value ="反応する"/>
<jsp:setProperty name ="rPH" property ="pgNewDiscuss" value ="発表する新しいの討論テ-マ"/>
<jsp:setProperty name ="rPH" property ="pgUserResponse" value ="反応する内容"/>
<jsp:setProperty name ="rPH" property ="pgTime" value ="時間"/>
<jsp:setProperty name ="rPH" property ="pgResponder" value ="反応者"/>
<jsp:setProperty name ="rPH" property ="pgInformation" value ="情報"/>
<jsp:setProperty name ="rPH" property ="pgDocument" value ="公文書"/>

<!--次の売るために材料の機能の資料をつとめました  -->
<jsp:setProperty name ="rPH" property ="pgASMaterial" value ="材料"/>
<jsp:setProperty name ="rPH" property ="pgUpload" value ="載せる"/>
<jsp:setProperty name ="rPH" property ="pgFile" value ="档子"/>
<jsp:setProperty name ="rPH" property ="pgCenter" value ="中心"/>
<jsp:setProperty name ="rPH" property ="pgFormat" value ="書式"/>
<jsp:setProperty name ="rPH" property ="pgFollow" value ="で下さいきまりに従う"/>
<jsp:setProperty name ="rPH" property ="pgBelow" value ="次のとおりの"/>
<jsp:setProperty name ="rPH" property ="pgAbove" value ="以上のとおり"/>
<jsp:setProperty name ="rPH" property ="pgPreview" value ="ざっと目を通す"/>
<jsp:setProperty name ="rPH" property ="pgLevel" value ="等級"/>
<jsp:setProperty name ="rPH" property ="pgLaunch" value ="始動する"/>
<jsp:setProperty name ="rPH" property ="pgSparePart" value ="部分品"/>
<jsp:setProperty name ="rPH" property ="pgModelSeries" value ="モデル"/>
<jsp:setProperty name ="rPH" property ="pgPicture" value ="図形"/>
<jsp:setProperty name ="rPH" property ="pgImage" value ="暎像"/>
<jsp:setProperty name ="rPH" property ="pgInventory" value ="在庫品"/>
<jsp:setProperty name ="rPH" property ="pgLack" value ="に不足"/>
<jsp:setProperty name ="rPH" property ="pgCalculate" value ="計算する"/>
<jsp:setProperty name ="rPH" property ="pgPrice" value ="価格"/>
<jsp:setProperty name ="rPH" property ="pgConsumer" value ="消費者"/>
<jsp:setProperty name ="rPH" property ="pgRetailer" value ="店"/>
<jsp:setProperty name ="rPH" property ="pgASMAuthFailMsg" value ="すみません！ あなたになるて資料を権限はこのを問い合わせるます」"/>
<jsp:setProperty name ="rPH" property ="pgASMInfo" value ="アフタ-?サ-ビス材料情報"/>
<jsp:setProperty name ="rPH" property ="pgMOQ" value ="一番小さい注文する数量"/>
<jsp:setProperty name ="rPH" property ="pgSafeInv" value ="安全在庫数える"/>
<jsp:setProperty name ="rPH" property ="pgCurrInv" value ="目下のところ在庫品数える"/>
<jsp:setProperty name ="rPH" property ="pgFront" value ="正面"/>
<jsp:setProperty name ="rPH" property ="pgBack" value ="背面"/>
<jsp:setProperty name ="rPH" property ="pgAllASM" value ="問い合わせすべての売る飲む材料"/>

<jsp:setProperty name ="rPH" property ="pgChooseMdl" value ="選択するモデル"/>
<jsp:setProperty name ="rPH" property ="pgASM _ EC" value ="売る飲む材料EC"/>
<jsp:setProperty name ="rPH" property ="pgChange" value ="変更"/>
<jsp:setProperty name ="rPH" property ="pgNewPart4EC" value ="欲求に変更のそれが新しい生地の号"/>
<jsp:setProperty name ="rPH" property ="pgCurrModelRef" value ="現行の使えるモデル"/>
<jsp:setProperty name ="rPH" property ="pgModelRefMsg" value ="推測するために号は変更が換える適用のモデル一緒に合わせてを希望するおしり選ぶ項目する"/>
<jsp:setProperty name ="rPH" property ="pgDelImage" value ="消除する考えるキャビネット"/>

<!--次は宿題管理功能の資料でした  -->
<jsp:setProperty name ="rPH" property ="pgAfterService" value ="売るつとめる"/>
<jsp:setProperty name ="rPH" property ="pgInput" value ="入れる"/>
<jsp:setProperty name ="rPH" property ="pgMaintenance" value ="保つ"/>
<jsp:setProperty name ="rPH" property ="pgRefresh" value ="改る"/>
<jsp:setProperty name ="rPH" property ="pgChinese" value ="中国語"/>
<jsp:setProperty name ="rPH" property ="pgDescription" value ="説明する"/>
<jsp:setProperty name ="rPH" property ="pgType" value ="タイプ形"/>
<jsp:setProperty name ="rPH" property ="pgDefinition" value ="定義する"/>


<jsp:setProperty name ="rPH" property ="pgASModelMainten" value ="「モデルの内外部のサイズを服を売るて保つます」"/>
<jsp:setProperty name ="rPH" property ="pgSalesModel" value ="外部サイズ"/>
<jsp:setProperty name ="rPH" property ="pgLaunchDate" value ="登場期日"/>
<jsp:setProperty name ="rPH" property ="pgDisannulDate" value ="失効する期日"/>
<jsp:setProperty name ="rPH" property ="pgProjHoldDate" value ="バリュ-デ-ト"/>

<jsp:setProperty name ="rPH" property ="pgASCodeEntry" value ="売る飲むマ-ク保つ"/>
<jsp:setProperty name ="rPH" property ="pgRegion" value ="地域"/>
<jsp:setProperty name ="rPH" property ="pgCodeClass" value ="マ-ク類別"/>

<jsp:setProperty name ="rPH" property ="pgASItemInput" value ="売る服推測する輸入"/>
<jsp:setProperty name ="rPH" property ="pgPartChDesc" value ="推測する中国語説明する"/>
<jsp:setProperty name ="rPH" property ="pgEnable" value ="使用し始める"/>
<jsp:setProperty name ="rPH" property ="pgDisable" value ="止まる効用"/>
<jsp:setProperty name ="rPH" property ="pgModelRef" value ="使えるモデル"/>
<jsp:setProperty name ="rPH" property ="pgItemLoc" value ="推測する位置"/>

<jsp:setProperty name ="rPH" property ="pgASFaultSympInput" value ="「故障/特別な徴のマ-クの輸入を売って飲む」"/>
<jsp:setProperty name ="rPH" property ="pgFaultCode" value ="故障マ-ク"/>
<jsp:setProperty name ="rPH" property ="pgSymptomCode" value ="特別徴マ-ク"/>
<jsp:setProperty name ="rPH" property ="pgCodeDesc" value ="マ-ク説明する"/>
<jsp:setProperty name ="rPH" property ="pgCodeChDesc" value ="マ-ク中国語説明する"/>
<jsp:setProperty name ="rPH" property ="pgCUser" value ="打ち建てるスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgCDate" value ="打ち建てる期日"/>

<jsp:setProperty name ="rPH" property ="pgASResActInput" value ="もう一度タイプ/口は退くますマ-クは選択する"/>
<jsp:setProperty name ="rPH" property ="pgActionCode" value ="補修する方法マ-ク"/>
<jsp:setProperty name ="rPH" property ="pgActionDesc" value ="補修する方法説明する"/>
<jsp:setProperty name ="rPH" property ="pgActionChDesc" value ="補修する方法中国語説明する"/>
<jsp:setProperty name ="rPH" property ="pgReasonCode" value ="補修する原因マ-ク"/>
<jsp:setProperty name ="rPH" property ="pgReasonDesc" value ="群退く原因説明する"/>
<jsp:setProperty name ="rPH" property ="pgReasonChDesc" value ="補修する原因中国語説明する"/>

<jsp:setProperty name ="rPH" property ="pgASMLauStatusTitle" value ="売る飲む材料モデル国名/使用し始める状態"/>
<jsp:setProperty name ="rPH" property ="pgUpdateLaunch" value ="使用し始める更新"/>


<!--次はプログラムラン状態のペ-ジの資料でした  -->
<jsp:setProperty name ="rPH" property ="pgProgressStsBar" value ="処理する中 ..." />

<!--次は報告表資料でした  -->
<jsp:setProperty name ="rPH" property ="pgReport" value ="報告表"/>
<jsp:setProperty name ="rPH" property ="pgTransaction" value ="異動"/>
<jsp:setProperty name ="rPH" property ="pgLogQty" value ="登録する数える"/>
<jsp:setProperty name ="rPH" property ="pgRepair" value ="補修する"/>
<jsp:setProperty name ="rPH" property ="pgProcess" value ="処理する"/>
<jsp:setProperty name ="rPH" property ="pgNotInclude" value ="含有する"/>
<jsp:setProperty name ="rPH" property ="pgRepCompleteRate" value ="終わる修理率"/>
<jsp:setProperty name ="rPH" property ="pgRepaired" value ="もう補修する"/>
<jsp:setProperty name ="rPH" property ="pgRepairing" value ="補修する処理中"/>
<jsp:setProperty name ="rPH" property ="pgRepGeneral" value ="普通おくる修理する"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl1" value ="一級"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl2" value ="二級"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl3" value ="三つ級"/>
<jsp:setProperty name ="rPH" property ="pgRepLvl12" value ="一、二級"/>
<jsp:setProperty name ="rPH" property ="pgNorth" value ="北"/>
<jsp:setProperty name ="rPH" property ="pgMiddle" value ="中"/>
<jsp:setProperty name ="rPH" property ="pgSouth" value ="南"/>
<jsp:setProperty name ="rPH" property ="pgAll" value ="完全"/>
<jsp:setProperty name ="rPH" property ="pgArea" value ="地域"/>
<jsp:setProperty name ="rPH" property ="pgServiceCenter" value ="売る服部"/>
<jsp:setProperty name ="rPH" property ="pgSubTotal" value ="小さい計算する"/>
<jsp:setProperty name ="rPH" property ="pgLogModelPerm" value ="登録するモデル順位"/>
<jsp:setProperty name ="rPH" property ="pgPermutDetail" value ="順に並べる明細"/>
<jsp:setProperty name ="rPH" property ="pgModelDetail" value ="モデル明細"/>
<jsp:setProperty name ="rPH" property ="pgLvl12FinishTrendChart" value ="「一、二級は趨勢絵を各地域は終わってから勉強する」"/>
<jsp:setProperty name ="rPH" property ="pgLvl3FinishTrendChart" value ="「三級は各絵を趨勢を地域は終わってから勉強するます」"/>
<jsp:setProperty name ="rPH" property ="pgRepFinishTrendChart" value ="しまう勉強する趨勢絵"/>
<jsp:setProperty name ="rPH" property ="pgRepAreaSummaryReport" value ="資料明細書"/>


<!--多種多様なワ-ドバンク  -->
<jsp:setProperty name ="rPH" property ="pgCase" value ="訴訟事件"/>
<jsp:setProperty name ="rPH" property ="pgRecords" value ="記録する"/>
<jsp:setProperty name ="rPH" property ="pgTo" value ="まで"/>

<!--WINSもとの機能のワ-ドバンク  -->
<jsp:setProperty name =" pageHeader" property ="pgTitleName" value ="制品特別処理を要する重大事項インフォ-メ-ションシステム"/>
<jsp:setProperty name =" pageHeader" property ="pgSalesCode" value ="市場サイズ"/>
<jsp:setProperty name =" pageHeader" property ="pgProjectCode" value ="きっかけタイプ"/>
<jsp:setProperty name =" pageHeader" property ="pgProductType" value ="制品類別"/>
<jsp:setProperty name =" pageHeader" property ="pgBrand" value ="品牌"/>
<jsp:setProperty name =" pageHeader" property ="pgLength" value ="長さ"/>
<jsp:setProperty name =" pageHeader" property ="pgWidth" value ="広い"/>
<jsp:setProperty name =" pageHeader" property ="pgHeight" value ="高い"/>
<jsp:setProperty name =" pageHeader" property ="pgWeight" value ="重量"/>

<jsp:setProperty name =" pageHeader" property ="pgLaunchDate" value ="登場期日"/>
<jsp:setProperty name =" pageHeader" property ="pgDeLaunchDate" value ="降る市期日"/>
<jsp:setProperty name =" pageHeader" property ="pgSize" value ="体積"/>
<jsp:setProperty name =" pageHeader" property ="pgDisplay" value ="示す"/>
<jsp:setProperty name =" pageHeader" property ="pgCamera" value ="カメラ"/>
<jsp:setProperty name =" pageHeader" property ="pgRingtone" value ="すずの音"/>
<jsp:setProperty name =" pageHeader" property ="pgPhonebook" value ="電話帳"/>

<jsp:setProperty name =" pageHeader" property ="pgRemark" value ="注"/>

<!--start for common use -->
<jsp:setProperty name =" pageHeader" property ="pgHOME" value ="回族ファストペ-ジ"/>
<jsp:setProperty name =" pageHeader" property ="pgSelectAll" value ="選び全部"/>
<jsp:setProperty name =" pageHeader" property ="pgCancelSelect" value ="取り消す選択する"/>
<jsp:setProperty name =" pageHeader" property ="pgDelete" value ="消除する"/>
<jsp:setProperty name =" pageHeader" property ="pgSave" value ="公文書をファイルに保存する"/>
<jsp:setProperty name =" pageHeader" property ="pgAdd" value ="新しさ増加する"/>
<jsp:setProperty name =" pageHeader" property ="pgOK" value ="確定する"/>
<jsp:setProperty name =" pageHeader" property ="pgSearch" value ="捜す"/>
<jsp:setProperty name =" pageHeader" property ="pgPlsEnter" value ="招待する入れる"/>
<!--end for common use -->

<!--start for page list -->
<jsp:setProperty name =" pageHeader" property ="pgPage" value ="ペ-ジ"/>
<jsp:setProperty name =" pageHeader" property ="pgPages" value ="ペ-ジ"/>
<jsp:setProperty name =" pageHeader" property ="pgFirst" value ="一番目"/>
<jsp:setProperty name =" pageHeader" property ="pgLast" value ="最後一"/>
<jsp:setProperty name =" pageHeader" property ="pgPrevious" value ="受ける一"/>
<jsp:setProperty name =" pageHeader" property ="pgNext" value ="作る一"/>
<jsp:setProperty name =" pageHeader" property ="pgTheNo" value ="第"/>
<jsp:setProperty name =" pageHeader" property ="pgTotal" value ="全部で"/>
<jsp:setProperty name =" pageHeader" property ="pgRecord" value ="筆記録音する"/>
<!--end for page list -->

<!--start for account management -->
<jsp:setProperty name =" pageHeader" property ="pgChgPwd" value ="修正するパスワ-ド"/>
<jsp:setProperty name =" pageHeader" property ="pgLogin" value ="のぼり入る"/>
<jsp:setProperty name =" pageHeader" property ="pgLogout" value ="登載する"/>
<jsp:setProperty name =" pageHeader" property ="pgMsgLicence" value ="大きい覇者電子株式有限会社版権所有する"/>
<jsp:setProperty name =" pageHeader" property ="pgRole" value ="役"/>
<jsp:setProperty name =" pageHeader" property ="pgList" value ="明細書"/>
<jsp:setProperty name =" pageHeader" property ="pgNew" value ="新しさ増加する"/>
<jsp:setProperty name =" pageHeader" property ="pgRevise" value ="修正する"/>
<jsp:setProperty name =" pageHeader" property ="pgDesc" value ="説明する"/>
<jsp:setProperty name =" pageHeader" property ="pgSuccess" value ="完成する"/>
<jsp:setProperty name =" pageHeader" property ="pgFail" value ="失敗する"/>
<jsp:setProperty name =" pageHeader" property ="pgAccount" value ="スタッフ"/>
<jsp:setProperty name =" pageHeader" property ="pgAccountWeb" value ="WEB識別ヤ-ド"/>
<jsp:setProperty name =" pageHeader" property ="pgMail" value ="電子メ-ル"/>
<jsp:setProperty name =" pageHeader" property ="pgProfile" value ="大体確定する"/>
<jsp:setProperty name =" pageHeader" property ="pgPasswd" value ="パスワ-ド"/>
<jsp:setProperty name =" pageHeader" property ="pgLocale" value ="国名"/>
<jsp:setProperty name =" pageHeader" property ="pgLanguage" value ="語族"/>
<jsp:setProperty name =" pageHeader" property ="pgModule" value ="モジュ-ル"/>
<jsp:setProperty name =" pageHeader" property ="pgSeq" value ="順に並べる号"/>
<jsp:setProperty name =" pageHeader" property ="pgFunction" value ="機能"/>
<jsp:setProperty name =" pageHeader" property ="pgHref" value ="つながる締め切るアドレス"/>
<jsp:setProperty name =" pageHeader" property ="pgRoot" value ="本選択書き付け"/>
<jsp:setProperty name =" pageHeader" property ="pgAuthoriz" value ="権利を委任する"/>
<jsp:setProperty name =" pageHeader" property ="pgID" value ="口座番号"/>

<!--期限を渡してただワ-ドバンクに入れたときいた  -->
<jsp:setProperty name ="rPH" property ="pgSalesDRQ" value ="業務は渡す号はきく単さん"/>
<jsp:setProperty name ="rPH" property ="pgQDocNo" value ="きく奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgSalesArea" value ="業務地区別れる"/>
<jsp:setProperty name ="rPH" property ="pgCustInfo" value ="取引先情報"/>
<jsp:setProperty name ="rPH" property ="pgSalesMan" value ="業務員"/>
<jsp:setProperty name ="rPH" property ="pgInvItem" value ="サイズ"/>
<jsp:setProperty name ="rPH" property ="pgDeliveryDate" value ="貨物引渡日"/>
<jsp:setProperty name ="rPH" property ="pgSalesOrderNo" value ="売る注文状号"/>
<jsp:setProperty name ="rPH" property ="pgCustPONo" value ="取引先注文する奇数番号"/>
<jsp:setProperty name ="rPH" property ="pgCurr" value ="貨幣別れる"/>
<jsp:setProperty name ="rPH" property ="pgPreOrderType" value ="預想する注文状類型"/>
<jsp:setProperty name ="rPH" property ="pgProcessUser" value ="処理するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgProcessDate" value ="処理する期日"/>
<jsp:setProperty name ="rPH" property ="pgProcessTime" value ="段取り時間"/>
<jsp:setProperty name ="rPH" property ="pgDRQInputPage" value ="入れるペ-ジ面"/>
<jsp:setProperty name ="rPH" property ="pgProdManufactory" value ="予定する産地"/>
<jsp:setProperty name ="rPH" property ="pgDeptArea" value ="地区"/>
<jsp:setProperty name ="rPH" property ="pgNoBlankMsg" value ="きっと手すりは位置を書き入れる，ぜひ入れて下さい"/>

<jsp:setProperty name ="rPH" property ="pgTSDRQNoHistory" value ="渡して号はきくます証票歴程は記録する"/>
<jsp:setProperty name ="rPH" property ="pgCustNo" value ="取引先略称"/>
<jsp:setProperty name ="rPH" property ="pgCustomerName" value ="取引先名称"/>
<jsp:setProperty name ="rPH" property ="pgRequireReason" value ="渡す期限需要原因説明する"/>
<jsp:setProperty name ="rPH" property ="pgProcessMark" value ="今度の処理説明する"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormUser" value ="折り書き付けスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormDate" value ="折り書き付け期日"/>
<jsp:setProperty name ="rPH" property ="pgCreateFormTime" value ="折り書き付け時間"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessUser" value ="前二番の処理するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessDate" value ="前二番の処理する期日"/>
<jsp:setProperty name ="rPH" property ="pgPreProcessTime" value ="前回段取り時間"/>
<jsp:setProperty name ="rPH" property ="pgProdTransferTo" value ="産地移す転移する"/>
<jsp:setProperty name ="rPH" property ="pgDocTotAssignFac" value ="証票すべての任名する産地"/>
<jsp:setProperty name ="rPH" property ="pgDocAssignFac" value ="もともと項任名する産地"/>
<jsp:setProperty name ="rPH" property ="pgDRQDocProcess" value ="「期限に問い合せの証票処理の流程を渡すます」"/>
<jsp:setProperty name ="rPH" property ="pgDRQInquiryReport" value ="期限に渡すてきくます報告表宿題を問い合わせは着く"/>
<jsp:setProperty name ="rPH" property ="pgSalesOrder" value ="売る注文状"/>
<jsp:setProperty name ="rPH" property ="pgFirmOrderType" value ="注文状類型"/>
<jsp:setProperty name ="rPH" property ="pgIdentityCode" value ="取引先識別ヤ-ド"/>
<jsp:setProperty name ="rPH" property ="pgSoldToOrg" value ="販売取引先"/>
<jsp:setProperty name ="rPH" property ="pgPriceList" value ="プライスリスト"/>
<jsp:setProperty name ="rPH" property ="pgShipToOrg" value ="販売地"/>
<jsp:setProperty name ="rPH" property ="pgGenerateInf" value ="生まれる情報"/>
<jsp:setProperty name ="rPH" property ="pgWait" value ="ウエ-ト"/>
<jsp:setProperty name ="rPH" property ="pgConfirm" value ="確認する"/>
<jsp:setProperty name ="rPH" property ="pgTSCAlias" value ="台ほんのすこし"/>
<jsp:setProperty name ="rPH" property ="pgOrderedItem" value ="商品番号"/>
<jsp:setProperty name ="rPH" property ="pgOR" value ="または"/>
<jsp:setProperty name ="rPH" property ="pgBillTo" value ="立つ勘定アドレス"/>
<jsp:setProperty name ="rPH" property ="pgDeliverTo" value ="貨物を渡すアドレス"/>
<jsp:setProperty name ="rPH" property ="pgPaymentTerm" value ="支はらい条件"/>
<jsp:setProperty name ="rPH" property ="pgFOB" value =" FOB" />
<jsp:setProperty name ="rPH" property ="pgShippingMethod" value ="商品方法"/>
<jsp:setProperty name ="rPH" property ="pgIntExtPurchase" value ="なか/外部買う"/>
<jsp:setProperty name ="rPH" property ="pgPackClass" value ="包装分類する"/>
<jsp:setProperty name ="rPH" property ="pgKPC" value ="千(KPC)"/>
<jsp:setProperty name ="rPH" property ="pgUOM" value ="機関"/>
<jsp:setProperty name ="rPH" property ="pgNewRequestDate" value ="新らしい友だち期限需要日"/>
<jsp:setProperty name ="rPH" property ="pgTempDRQDoc" value ="草稿公文書"/>
<jsp:setProperty name ="rPH" property ="pgExceedValidDate" value ="取引先は期限に渡す確認しで越えられて仕組されて返されて4 日を覆うます"/>
<jsp:setProperty name ="rPH" property ="pgMark" value ="符号"/>
<jsp:setProperty name ="rPH" property ="pgDenote" value ="表す"/>
<jsp:setProperty name ="rPH" property ="pgInvalidDoc" value ="この証票もう失効する"/>
<jsp:setProperty name ="rPH" property ="pgProdPC" value ="工　熟れていない管理するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgSalesPlanner" value ="販売仕組するスタッフ"/>
<jsp:setProperty name ="rPH" property ="pgProdFactory" value ="生産する工場"/>
<jsp:setProperty name ="rPH" property ="pgSalesPlanDept" value ="販売仕組する地域"/>
<jsp:setProperty name ="rPH" property ="pgReAssign" value ="もう一度任名する"/>
<jsp:setProperty name ="rPH" property ="pgRequestDate" value ="渡す期限需要日"/>
<jsp:setProperty name ="rPH" property ="pgFDeliveryDate" value ="工　貨物の受渡し日"/>
<jsp:setProperty name ="rPH" property ="pgReturnTWN" value ="帰るT"/>
<jsp:setProperty name ="rPH" property ="pgCustItemNo" value ="取引先推測する号"/>
<jsp:setProperty name ="rPH" property ="pgPCAssignDate" value ="つまだつ区分派遣する期日"/>
<jsp:setProperty name ="rPH" property ="pgFTArrangeDate" value ="工　並べる貨物の受渡し日"/>
<jsp:setProperty name ="rPH" property ="pgPCConfirmDate" value ="仕組する確認する貨物の受渡し日"/>
<jsp:setProperty name ="rPH" property ="pgOrdCreateDate" value ="注文状生成する期日"/>
<jsp:setProperty name ="rPH" property ="pgAlertSysNotAllowGen" value ="系統いいえ許す生成する"/>
<jsp:setProperty name ="rPH" property ="pgReject" value ="群退く"/>
<jsp:setProperty name ="rPH" property ="pgAbortToTempDRQ" value ="もとの書き付け内容は生まれるて新らしい友だちの期限は一人のときく"/>
<jsp:setProperty name ="rPH" property ="pgChoice" value ="選択する"/>
<jsp:setProperty name ="rPH" property ="pgAbortBefore" value ="放棄する以前"/>
<jsp:setProperty name ="rPH" property ="pgSetup" value ="確定する"/>
<jsp:setProperty name ="rPH" property ="pgOrdCreate" value ="注文状生成する"/>

<jsp:setProperty name ="rPH" property ="pgItemContent" value ="項目"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessStatus" value ="「問い合せ状態をただ処理する明細の」"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessSummary" value ="処理する状態集まる完全"/>
<jsp:setProperty name ="rPH" property ="pgRFQProcessing" value ="「処理の中に折りただ」"/>
<jsp:setProperty name ="rPH" property ="pgRFQDOCNoClosed" value ="もう事件が終結する"/>
<jsp:setProperty name ="rPH" property ="pgRFQCompleteRate" value ="完成率"/>
<jsp:setProperty name ="rPH" property ="pgSPCProcessSummary" value ="仕組する処理する状態集まる完全"/>
<jsp:setProperty name ="rPH" property ="pgFCTProcessSummary" value ="工　処理する状態集まる完全"/>
<jsp:setProperty name ="rPH" property ="pgTTEW" value ="天津成長する威厳"/>
<jsp:setProperty name ="rPH" property ="pgYYEW" value ="陽信成長する威厳"/>
<jsp:setProperty name ="rPH" property ="pgIILAN" value ="宜蘭在庫品"/>
<jsp:setProperty name ="rPH" property ="pgSILAN" value ="宜蘭SKY"/>
<jsp:setProperty name ="rPH" property ="pgOILAN" value ="宜蘭外買う"/>
<jsp:setProperty name ="rPH" property ="pgNTaipei" value ="NBU外買う"/>
<jsp:setProperty name ="rPH" property ="pgRFQTemporary" value ="草稿公文書"/>
<jsp:setProperty name ="rPH" property ="pgRFQAssigning" value ="つまだつ分けるタイプ中"/>
<jsp:setProperty name ="rPH" property ="pgRFQEstimating" value ="「号を工　は渡すて並べるます中」"/>
<jsp:setProperty name ="rPH" property ="pgRFQArrenged" value ="工　並べる待つ確認する"/>
<jsp:setProperty name ="rPH" property ="pgRFQResponding" value ="「仕組して渡すて覆う中に号は返す」"/>
<jsp:setProperty name ="rPH" property ="pgRFQConfirmed" value ="仕事上にかわって取引先確認する"/>
<jsp:setProperty name ="rPH" property ="pgRFQGenerating" value ="売る注文状生成する中"/>
<jsp:setProperty name ="rPH" property ="pgRFQClosed" value ="「期限に渡すてきくて単さんはもう事件が終結する」"です/>
<jsp:setProperty name ="rPH" property ="pgRFQAborted" value ="諦める"/>
<jsp:setProperty name ="rPH" property ="pgProcessQty" value ="処理数える"/>
<jsp:setProperty name ="rPH" property ="pgNewNo" value ="新しい"/>
<jsp:setProperty name ="rPH" property ="pgALogDesc" value ="「期日の区間は降るて各地域はきくれてただ登録しれて証票はペンが数えるます」"/>
<jsp:setProperty name ="rPH" property ="pgYellowItem" value ="エロ-項目"/>
<jsp:setProperty name ="rPH" property ="pgItemExistsMsg" value ="「商品番号選択する注文状の類型をORGは対応するに存在する」"/>
<jsp:setProperty name ="rPH" property ="pgWorkHour" value ="労動時間"/>
<jsp:setProperty name ="rPH" property ="pgtheItem" value ="もともと項"/>
<jsp:setProperty name ="rPH" property ="pgRFQRequestDateMsg" value ="貨物引渡日は今日より小さくてはいけないです！ !" />

<jsp:setProperty name ="rPH" property ="pgDeliverCustomer" value ="貨物を渡す取引先"/>
<jsp:setProperty name ="rPH" property ="pgDeliverLocation" value ="貨物を渡すアドレス"/>
<jsp:setProperty name ="rPH" property ="pgDeliverContact" value ="貨物を渡す連絡する人"/>
<jsp:setProperty name ="rPH" property ="pgDeliveryTo" value ="貨物を渡すマ-ク"/>
<jsp:setProperty name ="rPH" property ="pgDeliverAddress" value ="貨物を渡すアドレス"/>
<jsp:setProperty name ="rPH" property ="pgNotifyContact" value ="知らせる連絡する人"/>
<jsp:setProperty name ="rPH" property ="pgNotifyLocation" value ="知らせる連絡するアドレス"/>
<jsp:setProperty name ="rPH" property ="pgShipContact" value ="商品連絡する人"/>
<jsp:setProperty name ="rPH" property ="pgMain" value ="主"/>
<jsp:setProperty name ="rPH" property ="pgOthers" value ="ほかに"/>
<jsp:setProperty name ="rPH" property ="pgFactoryResponse" value ="工　返す覆う"/>
<jsp:setProperty name ="rPH" property ="pgWith" value ="と"/>
<jsp:setProperty name ="rPH" property ="pgDetailRpt" value ="明細表"/>
<jsp:setProperty name ="rPH" property ="pgDateType" value ="期日種類"/>
<jsp:setProperty name ="rPH" property ="pgFr" value ="起きる"/>
<jsp:setProperty name ="rPH" property ="pgTo _"value ="まで"/>
<jsp:setProperty name ="rPH" property ="pgSSD" value ="見通し出る商品日"/>
<jsp:setProperty name ="rPH" property ="pgOrdD" value ="注文状期日"/>
<jsp:setProperty name ="rPH" property ="pgItmFly" value =" Item Family" />
<jsp:setProperty name ="rPH" property ="pgItmPkg" value =" Item Package" />
<jsp:setProperty name ="rPH" property ="pgLDetailSave" value ="「今度のの見通しは明細のに溜るうとする」"/>
<jsp:setProperty name ="rPH" property ="pgLCheckDelete" value ="「注文して取るて箱を確認するてて消除する」"/>
<jsp:setProperty name ="rPH" property ="pgThAccShpQty" value ="今回疲れる出す数量"/>


<!--start forは出しました商品の送り状は収めてlistを管理したと推測しました -->
<jsp:setProperty name ="rPH" property ="pgInvoiceNo" value ="送り状"/>
<jsp:setProperty name ="rPH" property ="pgPoNo" value ="購入状"/>
<jsp:setProperty name ="rPH" property ="pgAvailableShip" value ="ことができる商品"/>
