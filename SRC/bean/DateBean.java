package bean;

import java.util.Calendar;
import java.util.Date;

public class DateBean
{
 Calendar calendar=null;

 public DateBean()
 {
  calendar=Calendar.getInstance();
  calendar.setTime(new Date());
 } //end of DateBean()

 public void setDate(int yy,int mm,int dd)
 {
  calendar.set(yy,mm-1,dd);
 } //end of setDate

 public void setVarDate(int yyyy,int mm,int dd)
 {
  calendar.set(yyyy,mm-1,dd);
 } //end of setVariableDate

 public void setAdjDate(int amt)
 {
  calendar.add(Calendar.DATE,amt);
 } //end of setAdjDate

 public void setAdjWeek(int amt)
 {
  calendar.add(Calendar.WEEK_OF_YEAR,amt);
 } //end of setAdjWeek

 public void setAdjMonth(int amt)
 {
  calendar.add(Calendar.MONTH,amt);
 } //end of setAdjMonth

 public void setAdjYear(int amt)
 {
  calendar.add(Calendar.YEAR,amt);
 } //end of setAdjYear

 public int getMaxDay()
 {
  return calendar.getActualMaximum(5);
 }

 public int getMonthMaxDay()
 {
  return calendar.getActualMaximum(Calendar.DATE);
 }

 public String getWeekBeginDate()
 {
  int oriDayOfWeek=calendar.get(Calendar.DAY_OF_WEEK);
  calendar.set(Calendar.DAY_OF_WEEK,2);

  String yyyy="0000";
  yyyy=yyyy+calendar.get(Calendar.YEAR);
  yyyy=yyyy.substring(yyyy.length()-4);

  String mm="00";
  mm=mm+(1+calendar.get(Calendar.MONTH));
  mm=mm.substring(mm.length()-2);

  String dd="00";
  dd=dd+calendar.get(Calendar.DAY_OF_MONTH);
  dd=dd.substring(dd.length()-2);

  calendar.set(Calendar.DAY_OF_WEEK,oriDayOfWeek); //restore the Date
  return yyyy+mm+dd;
 }

 public int getYear()
 {
  return calendar.get(Calendar.YEAR);
 }

 public int getMonth()
 {
  return 1+calendar.get(Calendar.MONTH);
 }

 public int getDayOfWeek()
 {
  return calendar.get(Calendar.DAY_OF_WEEK);
 }

 public int getDay()
 {
  return calendar.get(Calendar.DAY_OF_MONTH);
 }

 public int getHour()
 {
  return calendar.get(Calendar.HOUR_OF_DAY);
 }

 public int getMinute()
 {
  return calendar.get(Calendar.MINUTE);
 }

 public int getSecond()
 {
  return calendar.get(Calendar.SECOND);
 }

 public String getDate()
 {
  return getYear()+"/"+getMonth()+"/"+getDay();
 }

 public String getTime()
 {
  return getHour()+":"+getMinute()+":"+getSecond();
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

 public String getHourMinute()
 {
  String hh="00",mm="00";
  hh=hh+getHour();
  mm=mm+getMinute();
  hh=hh.substring(hh.length()-2,hh.length());
  mm=mm.substring(mm.length()-2,mm.length());

  return hh+mm;
 }

 public String getHourString()
 {
  String hh="00";
  hh=hh+getHour();
  hh=hh.substring(hh.length()-2,hh.length());
  return hh;
 }

 public String getMinuteString()
 {
  String mm="00";
  mm=mm+getMinute();
  mm=mm.substring(mm.length()-2,mm.length());
  return mm;
 }

 public String getSecondString()
 {
  String ss="00";
  ss=ss+getSecond();
  ss=ss.substring(ss.length()-2,ss.length());
  return ss;
 }

 public String getHourMinuteSecond()
 {
  String hh="00",mm="00",ss="00";
  hh=hh+getHour();
  mm=mm+getMinute();
  ss=ss+getSecond();
  hh=hh.substring(hh.length()-2,hh.length());
  mm=mm.substring(mm.length()-2,mm.length());
  ss=ss.substring(ss.length()-2,ss.length());

  return hh+mm+ss;
 }

 public int monthDifferentFromDate(int v_year,int v_month)
 {
   //c_year and c_month means current year,month, v_year and v_month means the another year,month to compare
   int c_year=getYear(),diff_year=0;
   int c_month=getMonth(),diff_month=0;

   diff_year=v_year-c_year;
   diff_month=v_month-c_month;

   if (diff_year<0)
   {
     diff_month=-(12*diff_year)+diff_month;
   } else {
     if (diff_year>0)
     {
      diff_month=(12*diff_year)+diff_month;
     }
   }
  return diff_month;
 }
} //end of DateBean class