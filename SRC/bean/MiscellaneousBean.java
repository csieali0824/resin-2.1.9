package bean;

public class MiscellaneousBean
{

    public MiscellaneousBean()
    {
    }

    public void setRoundDigit(int i)
    {
        roundDigit = i+1;
    }

    public String getFloatRoundStr(float d)
    {
        if (roundDigit==0)  roundDigit=2; // 預設取小數兩位作四捨五入,若未設定取至幾位



        String roundJdgStr = null;
        String roundNoRndStr = null;
        String roundNoStr = Float.toString(d);
        int roundNoStrLngth = roundNoStr.length();
        int dotIndex = roundNoStr.indexOf(".");
        int dotLeft = roundNoStrLngth-dotIndex-1;

        if (Float.isInfinite(d)==false)    // 若分母不為零,才進行處理
        {
            if (dotLeft>=roundDigit)
            {
                roundJdgStr = roundNoStr.substring(dotIndex+roundDigit,dotIndex+roundDigit+1);
            }
            else if ((dotLeft==roundDigit))
            {
                roundJdgStr = roundNoStr+"0";
                roundNoRndStr = "0";
            }

            int roundJdgInt = 0;
            if (roundJdgStr!=null)
            {
                roundJdgInt = Integer.parseInt(roundJdgStr);
            } else { roundJdgInt = 0; }

            if (roundJdgInt>4)
            {
                if (roundDigit==2)
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit);
                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    roundNoInt++;
                    if (roundNoInt<10)
                    {
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt; //out.println("Step1="+roundNoStr);
                    } else
                    {
                        roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));
                        roundNoInt++;
                        roundNoStr = Integer.toString(roundNoInt)+".0";
                        //out.println("Step2="+roundNoStr);
                    }
                } else
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit); //out.println("roundNoRndStr ="+roundNoRndStr);

                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    roundNoInt++;  //out.println("roundNoInt++ ="+roundNoInt++);
                    if (roundNoInt<10) { roundNoRndStr = "0"+roundNoInt; }
                    else { roundNoRndStr = Integer.toString(roundNoInt); }
                    roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr;
                }
            }
            else // Else if roundJdgInt <=4
            {
                if (roundDigit==2)
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit); //out.println("Step3="+roundNoRndStr);
                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    if (roundNoInt<10)
                    {
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt;  //out.println("Step4="+roundNoStr);
                    } else
                    {
                        roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));
                        roundNoStr = Integer.toString(roundNoInt)+".0";   //out.println("Step5="+roundNoStr);
                    }
                }
                else {
                    if (roundDigit>dotLeft)
                    {
                        roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+dotLeft+1);
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr+"0";
                    }
                    else {
                        roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit);
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr;
                    }
                }
            }
        }  // End if 分母不為零
        else {  roundNoStr = "N/A"; }

        return roundNoStr;
    }

    public String getDoubleRoundStr(double d)
    {
        if (roundDigit==0)  roundDigit=2; // 預設取小數兩位作四捨五入,若未設定取至幾位

        String roundJdgStr = null;
        String roundNoRndStr = null;
        String roundNoStr = Double.toString(d);
        int roundNoStrLngth = roundNoStr.length();
        int dotIndex = roundNoStr.indexOf(".");
        int dotLeft = roundNoStrLngth-dotIndex-1;

        if (Double.isInfinite(d)==false)    // 若分母不為零,才進行處理
        {
            if (dotLeft>=roundDigit)
            {
                roundJdgStr = roundNoStr.substring(dotIndex+roundDigit,dotIndex+roundDigit+1);
            }
            else if ((dotLeft==roundDigit))
            {
                roundJdgStr = roundNoStr+"0";
                roundNoRndStr = "0";
            }

            int roundJdgInt = 0;
            if (roundJdgStr!=null)
            {
                roundJdgInt = Integer.parseInt(roundJdgStr);
            } else { roundJdgInt = 0; }

            if (roundJdgInt>4)
            {
                if (roundDigit==2)
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit);
                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    roundNoInt++;
                    if (roundNoInt<10)
                    {
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt; //out.println("Step1="+roundNoStr);
                    } else
                    {
                        roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));
                        roundNoInt++;
                        roundNoStr = Integer.toString(roundNoInt)+".0";
                        //out.println("Step2="+roundNoStr);
                    }
                } else
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit); //out.println("roundNoRndStr ="+roundNoRndStr);

                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    roundNoInt++;  //out.println("roundNoInt++ ="+roundNoInt++);
                    if (roundNoInt<10) { roundNoRndStr = "0"+roundNoInt; }
                    else { roundNoRndStr = Integer.toString(roundNoInt); }
                    roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr;
                }
            }
            else // Else if roundJdgInt <=4
            {
                if (roundDigit==2)
                {
                    roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit); //out.println("Step3="+roundNoRndStr);
                    int roundNoInt = Integer.parseInt(roundNoRndStr);
                    if (roundNoInt<10)
                    {
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt;  //out.println("Step4="+roundNoStr);
                    } else
                    {
                        roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));
                        roundNoStr = Integer.toString(roundNoInt)+".0";   //out.println("Step5="+roundNoStr);
                    }
                }
                else {
                    if (roundDigit>dotLeft)
                    {
                        roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+dotLeft+1);
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr+"0";
                    }
                    else {
                        roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit);
                        roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr;
                    }
                }
            }
        }  // End if 分母不為零
        else {  roundNoStr = "N/A"; }

        return roundNoStr;
    }

    private int roundDigit;
}