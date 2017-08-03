package com.android.quieromas.helper;

import android.widget.Chronometer;

import org.joda.time.DateTime;
import org.joda.time.Months;
import org.joda.time.Weeks;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by lucas on 12/7/17.
 */

public class AgeHelper {


    DateTimeFormatter dtf;

    public AgeHelper(){
        dtf = DateTimeFormat.forPattern("dd/MM/yyyy");
    }

    public boolean canAccessPlan(String babyBirthdate){
        DateTime birthdate = dtf.parseDateTime(babyBirthdate);
        int diff = Months.monthsBetween(birthdate,new DateTime()).getMonths();
        if (diff >= 6 && diff < 12){
            return true;
        }else{
            return false;
        }
    }

    public int getPlanWeek(String babyBirthdate){

        if(!canAccessPlan(babyBirthdate))
            return -1;

        DateTime birthdate = dtf.parseDateTime(babyBirthdate);

        DateTime sixMonths = birthdate.plusMonths(6);

        return Weeks.weeksBetween(sixMonths,new DateTime()).getWeeks();
    }

    public int getPlanWeekStartDay(String babyBirthdate){

       int week = getPlanWeek(babyBirthdate);

        int day = week * 7;

        //para no quedarse sin recetas!
        if(day  > 180){
            day = 179;
        }

        return day;
    }

    public int getTotalWeeks(String babyBirthdate){
        DateTime birthdate = dtf.parseDateTime(babyBirthdate);

        int weeks = Weeks.weeksBetween(birthdate,new DateTime()).getWeeks();

        return weeks;
    }

}