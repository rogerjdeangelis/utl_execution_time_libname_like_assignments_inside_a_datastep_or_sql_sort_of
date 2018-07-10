Execution time libname like assignments inside a datastep or sql

Hiding the physical path to a SAS dataset

Not sure I know what you mean by hide

 Here are sevel methods for hiding  "d:/sd1/class.sas7bdat"

  1. Path inside datatep and output dataset
  2. Path inside datatep and output view
  3. Path inside SQL and output datastep
  4. Path inside SQL and output view
  5. DOSUBL (should also work with view)
  6. Stored program

TECHNIQUES

1. Path inside datatep and output dataset

  data class_males;
    set "d:/sd1/class.sas7bdat"(where=(sex='M'));
  run;quit;


2. Path inside datatep and output view
  data class_m/view=class_m;
    set "d:/sd1/class.sas7bdat"(where=(sex='M'));
  run;quit;


3. Path inside SQL and output datastep
  proc sql;
     create
        table class_males as
     select
        *
     from
        "d:/sd1/class.sas7bdat"
     where
        sex="M"
  ;quit;


4. Path inside SQL and output view
  proc sql;
     create
        view class_m as
     select
        *
     from
        "d:/sd1/class.sas7bdat"
     where
        sex="M"
  ;quit;


5. DOSUBL (should also work with view)
  * this is flexible because you can encrypt and
    decrypt the path in such a way that the pther is never shown;
  %symdel _pth / nowarn; /* just in case */
  data class_males;
    if _n_=0 then do;
       %let rc=%sysfunc(dosubl('
           %let _pth="d:/sd1/class.sas7bdat";
       '));
    end;

    set &_pth(where=(sex='M'));

  run;quit;

6. STORED PROGRAM

  data class_mmm/pgm=sasuser.class_x;
    set "d:/sd1/class.sas7bdat"(where=(sex='M'));
  run;quit;

  data clss;
    set sasuser.class_x;
  run;quit;

  * how ro execute the stored program
  data work.sample / pgm=sasuser.sample;
     set "d:/sd1/class.sas7bdat";
  run;quit;

  data pgm=sasuser.sample;
     redirect output work.sample=work.samplex;
  run;




