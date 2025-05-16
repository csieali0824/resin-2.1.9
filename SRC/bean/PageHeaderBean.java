package bean;

import java.io.Serializable;

public class PageHeaderBean implements Serializable
{
 private String pgTitleName;
 private String pgProjectCode;
 private String pgSalesCode;
 private String pgRemark;
 private String pgProductType;
 private String pgBrand;
 private String pgLength;
 private String pgWidth; 
 private String pgHeight;
 private String pgWeight;
 private String pgLaunchDate;
 private String pgDeLaunchDate;
 private String pgSize;
 private String pgDisplay; 
 private String pgCamera;  
 private String pgRingtone;
 private String pgPhonebook;
 private String pgUpFileFront;
 private String pgUpFileSide;
 private String pgUpFileOpen;

 //---start for common use
 private String pgHOME,pgDelete,pgAdd,pgOK,pgSave,pgSelectAll,pgCancelSelect,pgSearch,pgPlsEnter;
 //---start for common use

 //start for page list
 private String pgTotal,pgRecord,pgFirst,pgLast,pgPrevious,pgNext,pgPage,pgPages,pgTheNo;
 //end for page list
 
 //---start for account management
 private String pgAuthoriz,pgList,pgNew,pgRevise,pgRole,pgDesc,pgSuccess,pgFail,pgAccount,pgAccountWeb,pgProfile,pgPasswd,pgMail;
 private String pgLocale,pgLanguage,pgModule,pgSeq,pgFunction,pgHref,pgID,pgRoot;
 private String pgChgPwd,pgLogin,pgLogout,pgMsgLicence;

 //---end for account management

 public PageHeaderBean() 
 {} 

 public String getPGTitleName() 
 {
    return pgTitleName;
 } 

 public void setPGTitleName(String para)  
 {
   this.pgTitleName = para;
 }

 public String getPGProjectCode() 
 {
   return pgProjectCode;
 }  

 public void setPGProjectCode(String para) 
 {
   this.pgProjectCode = para;
 }

  public String getPGSalesCode() 
 {
   return pgSalesCode;
 }  

 public void setPGSalesCode(String para) 
 {
   this.pgSalesCode = para;
 }

 public String getPGProductType() 
 {
   return pgProductType;
 }
 
 public void setPGProductType(String para) 
 {
   this.pgProductType = para;
 }


 public String getPGRemark() 
 {
   return pgRemark;
 }
 
 public void setPGRemark(String para) 
 {
   this.pgRemark = para;
 }

 public String getPGBrand() 
 {
   return pgBrand;
 }
 
 public void setPGBrand(String para) 
 {
   this.pgBrand = para;
 }

 public String getPGLength() 
 {
   return pgLength;
 }
 
 public void setPGLength(String para) 
 {
   this.pgLength = para;
 }

 public String getPGWidth() 
 {
   return pgWidth;
 }
 
 public void setPGWidth(String para) 
 {
   this.pgWidth = para;
 }

 public String getPGHeight() 
 {
   return pgHeight;
 }
 
 public void setPGHeight(String para) 
 {
   this.pgHeight = para;
 }

 public String getPGWeight() 
 {
   return pgWeight;
 }
 
 public void setPGWeight(String para) 
 {
   this.pgWeight = para;
 }

 public String getPGLaunchDate() 
 {
   return pgLaunchDate;
 }
 
 public void setPGLaunchDate(String para) 
 {
   this.pgLaunchDate = para;
 }

 public String getPGDeLaunchDate() 
 {
   return pgDeLaunchDate;
 }
 
 public void setPGDeLaunchDate(String para) 
 {
   this.pgDeLaunchDate = para;
 }

 public String getPGSize() 
 {
   return pgSize;
 }
 
 public void setPGSize(String para) 
 {
   this.pgSize = para;
 }

 public String getPGDisplay() 
 {
   return pgDisplay;
 }
 
 public void setPGDisplay(String para) 
 {
   this.pgDisplay = para;
 }

 public String getPGCamera() 
 {
   return pgCamera;
 }
 
 public void setPGCamera(String para) 
 {
   this.pgCamera = para;
 }

 public String getPGRingtone() 
 {
   return pgRingtone;
 }
 
 public void setPGRingtone(String para) 
 {
   this.pgRingtone = para;
 }

 public String getPGPhonebook() 
 {
   return pgPhonebook;
 }
 
 public void setPGPhonebook(String para) 
 {
   this.pgPhonebook = para;
 }

 //---start for common use
    public String getPGHOME()
    {
        return pgHOME;
    }

    public void setPGHOME(String s)
    {
        pgHOME = s;
    }

    public String getPGSave()
    {
        return pgSave;
    }

    public void setPGSave(String s)
    {
        pgSave = s;
    }

    public String getPGDelete()
    {
        return pgDelete;
    }

    public void setPGDelete(String s)
    {
        pgDelete = s;
    }

    public String getPGAdd()
    {
        return pgAdd;
    }

    public void setPGAdd(String s)
    {
        pgAdd = s;
    }

    public String getPGOK()
    {
        return pgOK;
    }

    public void setPGOK(String s)
    {
        pgOK = s;
    }

    public String getPGSelectAll()
    {
        return pgSelectAll;
    }

    public void setPGSelectAll(String s)
    {
        pgSelectAll = s;
    }

    public String getPGCancelSelect()
    {
        return pgCancelSelect;
    }

    public void setPGCancelSelect(String s)
    {
        pgCancelSelect = s;
    }

    public String getPGSearch()
    {
        return pgSearch;
    }

    public void setPGSearch(String s)
    {
        pgSearch = s;
    }

    public String getPGPlsEnter()
    {
        return pgPlsEnter;
    }

    public void setPGPlsEnter(String s)
    {
        pgPlsEnter = s;
    }
//end

//start
    public String getPGFirst()
    {
        return pgFirst;
    }

    public void setPGFirst(String s)
    {
        pgFirst = s;
    }

    public String getPGLast()
    {
        return pgLast;
    }

    public void setPGLast(String s)
    {
        pgLast = s;
    }

    public String getPGPrevious()
    {
        return pgPrevious;
    }

    public void setPGPrevious(String s)
    {
        pgPrevious = s;
    }

    public String getPGNext()
    {
        return pgNext;
    }

    public void setPGNext(String s)
    {
        pgNext = s;
    }

    public String getPGPage()
    {
        return pgPage;
    }

    public void setPGPage(String s)
    {
        pgPage = s;
    }

    public String getPGPages()
    {
        return pgPages;
    }

    public void setPGPages(String s)
    {
        pgPages = s;
    }

    public String getPGTheNo()
    {
        return pgTheNo;
    }

    public void setPGTheNo(String s)
    {
        pgTheNo = s;
    }


    public String getPGTotal()
    {
        return pgTotal;
    }

    public void setPGTotal(String s)
    {
        pgTotal = s;
    }

    public String getPGRecord()
    {
        return pgRecord;
    }

    public void setPGRecord(String s)
    {
        pgRecord = s;
    }

 //---end for common use

 //---start for account management
    public void setPGAuthoriz(String s)
    {
        pgAuthoriz = s;
    }
    public String getPGAuthoriz()
    {
        return pgAuthoriz;
    }
    public String getPGRole()
    {
        return pgRole;
    }

    public void setPGRole(String s)
    {
        pgRole = s;
    }

    public String getPGList()
    {
        return pgList;
    }

    public void setPGList(String s)
    {
        pgList = s;
    }

    public String getPGNew()
    {
        return pgNew;
    }

    public void setPGNew(String s)
    {
        pgNew = s;
    }

    public String getPGRevise()
    {
        return pgRevise;
    }

    public void setPGRevise(String s)
    {
        pgRevise = s;
    }

    public String getPGDesc()
    {
        return pgDesc;
    }

    public void setPGDesc(String s)
    {
        pgDesc = s;
    }

    public String getPGSuccess()
    {
        return pgSuccess;
    }

    public void setPGSuccess(String s)
    {
        pgSuccess = s;
    }

    public String getPGFail()
    {
        return pgFail;
    }

    public void setPGFail(String s)
    {
        pgFail = s;
    }
    public String getPGAccount()
    {
        return pgAccount;
    }

    public void setPGAccount(String s)
    {
        pgAccount = s;
    }

    public String getPGAccountWeb()
    {
        return pgAccountWeb;
    }

    public void setPGAccountWeb(String s)
    {
        pgAccountWeb = s;
    }

    public String getPGMail()
    {
        return pgMail;
    }

    public void setPGMail(String s)
    {
        pgMail = s;
    }

    public String getPGProfile()
    {
        return pgProfile;
    }

    public void setPGProfile(String s)
    {
        pgProfile = s;
    }

    public String getPGPasswd()
    {
        return pgPasswd;
    }

    public void setPGPasswd(String s)
    {
        pgPasswd = s;
    }

    public String getPGLocale()
    {
        return pgLocale;
    }

    public void setPGLocale(String s)
    {
        pgLocale = s;
    }

    public String getPGLanguage()
    {
        return pgLanguage;
    }

    public void setPGLanguage(String s)
    {
        pgLanguage = s;
    }

    public String getPGModule()
    {
        return pgModule;
    }

    public void setPGModule(String s)
    {
        pgModule = s;
    }

    public String getPGRoot()
    {
        return pgRoot;
    }

    public void setPGRoot(String s)
    {
        pgRoot = s;
    }

    public String getPGSeq()
    {
        return pgSeq;
    }

    public void setPGSeq(String s)
    {
        pgSeq = s;
    }

    public String getPGFunction()
    {
        return pgFunction;
    }

    public void setPGFunction(String s)
    {
        pgFunction = s;
    }

    public String getPGHref()
    {
        return pgHref;
    }

    public void setPGHref(String s)
    {
        pgHref = s;
    }
    
    public String getPGID()
    {
        return pgID;
    }

    public void setPGID(String s)
    {
        pgID = s;
    }
    public String getPGChgPwd()
    {
        return pgChgPwd;
    }

    public void setPGChgPwd(String s)
    {
        pgChgPwd = s;
    }

    public String getPGLogin()
    {
        return pgLogin;
    }

    public void setPGLogin(String s)
    {
        pgLogin = s;
    }

    public String getPGLogout()
    {
        return pgLogout;
    }

    public void setPGLogout(String s)
    {
        pgLogout = s;
    }

    public String getPGMsgLicence()
    {
        return pgMsgLicence;
    }

    public void setPGMsgLicence(String s)
    {
        pgMsgLicence = s;
    }

 //---end for account management

} //end of this Bean

