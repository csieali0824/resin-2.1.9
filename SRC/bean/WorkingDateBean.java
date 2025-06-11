package bean;

import java.util.Calendar;

public class WorkingDateBean
{
 Calendar calendar=null;
 public WorkingDateBean()
 {
  calendar=Calendar.getInstance();
  calendar.setFirstDayOfWeek(2); //set the first day of week as Monday
 }

 public void setDefineWeekFirstDay(int d)
 {
  calendar.setFirstDayOfWeek(d); //set the first day of week as user define
 } //end of setDefineWeekFirstDay

 public void setAdjWeek(int amt)
 {
  calendar.add(Calendar.WEEK_OF_YEAR,amt);
 } //end of setAdjWeek

 public void setAdjMonth(int amt)
 {
  calendar.add(Calendar.MONTH,amt);
 } //end of setAdjMonth

 public void setAdjDay(int amt)
 {
  calendar.add(Calendar.DATE,amt);
 } //end of setAdjDay

 public void setWorkingDate(int yy,int mm,int dd)
 {
  calendar.set(yy,mm-1,dd);
 } //end of setWorkingDate

 public int getWeek()
 {
  return calendar.get(Calendar.WEEK_OF_YEAR);
 }

 public String getWeekString()
 {
  String ww="00";
  ww=ww+getWeek();
  ww=ww.substring(ww.length()-2);

  return ww;
 }

 public int getYear()
 {
  return calendar.get(Calendar.YEAR);
 }

 public int getMonth()
 {
  return 1+calendar.get(Calendar.MONTH);
 }

 public String getWorkingMonth(String jm)
 {
  String vmm=jm.substring(1,3);
  String tmm=null;
  if (vmm.equals("01") || vmm.equals("02") || vmm.equals("03") || vmm.equals("04") || vmm.equals("05")) { tmm="01";}
  if (vmm.equals("06") || vmm.equals("07") || vmm.equals("08") || vmm.equals("09")) { tmm="02";}
  if (vmm.equals("10") || vmm.equals("11") || vmm.equals("12") || vmm.equals("13")) { tmm="03"; }
  if (vmm.equals("14") || vmm.equals("15") || vmm.equals("16") || vmm.equals("17") || vmm.equals("18")) { tmm="04"; }
  if (vmm.equals("19") || vmm.equals("20") || vmm.equals("21") || vmm.equals("22")) { tmm="05"; }
  if (vmm.equals("23") || vmm.equals("24") || vmm.equals("25") || vmm.equals("26")) { tmm="06"; }
  if (vmm.equals("27") || vmm.equals("28") || vmm.equals("29") || vmm.equals("30") || vmm.equals("31")) { tmm="07"; }
  if (vmm.equals("32") || vmm.equals("33") || vmm.equals("34") || vmm.equals("35")) { tmm="08"; }
  if (vmm.equals("36") || vmm.equals("37") || vmm.equals("38") || vmm.equals("39")) { tmm="09"; }
  if (vmm.equals("40") || vmm.equals("41") || vmm.equals("42") || vmm.equals("43") || vmm.equals("44")) { tmm="10"; }
  if (vmm.equals("45") || vmm.equals("46") || vmm.equals("47") || vmm.equals("48")) { tmm="11"; }
  if (vmm.equals("49") || vmm.equals("50") || vmm.equals("51") || vmm.equals("52")) { tmm="12"; }
  return tmm;
 }

 public String [] getWWArrayOfMonth(int mm)
 {
  String km []=null;
  if (mm==1 ) { String tmm[]={"01","02","03","04","05"}; km=tmm;}
  if (mm==2 ) { String tmm[]={"06","07","08","09"}; km=tmm;}
  if (mm==3 ) { String tmm[]={"10","11","12","13"}; km=tmm;}
  if (mm==4 ) { String tmm[]={"14","15","16","17","18"}; km=tmm;}
  if (mm==5 ) { String tmm[]={"19","20","21","22"}; km=tmm;}
  if (mm==6 ) { String tmm[]={"23","24","25","26"}; km=tmm;}
  if (mm==7 ) { String tmm[]={"27","28","29","30","31"}; km=tmm;}
  if (mm==8 ) { String tmm[]={"32","33","34","35"}; km=tmm;}
  if (mm==9 ) { String tmm[]={"36","37","38","39"}; km=tmm;}
  if (mm==10 ) { String tmm[]={"40","41","42","43","44"}; km=tmm;}
  if (mm==11 ) { String tmm[]={"45","46","47","48"}; km=tmm;}
  if (mm==12 ) { String tmm[]={"49","50","51","52"}; km=tmm;}

  return km;
 }


 public int getDay()
 {
  return calendar.get(Calendar.DAY_OF_MONTH);
 }

 public int getFirstDayOfWeek()
 {
  return calendar.getFirstDayOfWeek();
 }

 public int getDayOfWeek()
 {
  return calendar.get(Calendar.DAY_OF_WEEK);
 }

 public String getYearString()
 {
  String yyyy="0000";
  yyyy=yyyy+getYear();
  yyyy=yyyy.substring(yyyy.length()-4);

  return yyyy;
 }

 public String getMonthString()
 {
  String mm="00";
  mm=mm+getMonth();
  mm=mm.substring(mm.length()-2);

  return mm;
 }

 public String getDayString()
 {
  String dd="00";
  dd=dd+getDay();
  dd=dd.substring(dd.length()-2);

  return dd;
 }

 public String getWorkingWeek()
 {
  String y="0",ww="00";
  if (calendar.get(Calendar.DAY_OF_YEAR)>350 & calendar.get(Calendar.WEEK_OF_YEAR)==1) //判斷若日期為跨年之週中日時則年份算到隔年
  {
   y=y+(getYear()+1);
  } else {
   y=y+getYear();
  }
  ww=ww+getWeek();
  y=y.substring(y.length()-1);
  ww=ww.substring(ww.length()-2);

  return y+ww;
 }

 public String getYearMonthDay()
 {
  String yyyy="0000",mm="00",dd="00";
  yyyy=yyyy+getYear();
  mm=mm+getMonth();
  dd=dd+getDay();
  yyyy=yyyy.substring(yyyy.length()-4);
  mm=mm.substring(mm.length()-2);
  dd=dd.substring(dd.length()-2);
  return yyyy+mm+dd;
 }

 public String getFirstDateOfWorkingWeek()
 {
  Calendar tempCal=calendar;
  for (int i=0;i<7;i++)
  {
   if (tempCal.get(Calendar.DAY_OF_WEEK)==getFirstDayOfWeek()) break;
   tempCal.add(Calendar.DAY_OF_YEAR,-1);
  }

  String yyyy="0000",mm="00",dd="00";
  yyyy=yyyy+tempCal.get(Calendar.YEAR);
  mm=mm+(tempCal.get(Calendar.MONTH)+1);
  dd=dd+tempCal.get(Calendar.DAY_OF_MONTH);
  yyyy=yyyy.substring(yyyy.length()-4);
  mm=mm.substring(mm.length()-2);
  dd=dd.substring(dd.length()-2);
  return yyyy+mm+dd;
 }

 public String getLastDateOfWorkingWeek()
 {
  Calendar tempCal=calendar;
  for (int i=0;i<7;i++)
  {
   tempCal.add(Calendar.DAY_OF_YEAR,1);
   if (tempCal.get(Calendar.DAY_OF_WEEK)==getFirstDayOfWeek())
   {
    tempCal.add(Calendar.DAY_OF_YEAR,-1);
    break;
   }
  }

  String yyyy="0000",mm="00",dd="00";
  yyyy=yyyy+tempCal.get(Calendar.YEAR);
  mm=mm+(tempCal.get(Calendar.MONTH)+1);
  dd=dd+tempCal.get(Calendar.DAY_OF_MONTH);
  yyyy=yyyy.substring(yyyy.length()-4);
  mm=mm.substring(mm.length()-2);
  dd=dd.substring(dd.length()-2);
  return yyyy+mm+dd;
 }
} //end of WorkingDateBean class