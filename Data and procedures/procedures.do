
//***实质是混合截面数据

use "C:\Users\11561\Desktop\Data and procedures"
order  scode year time time1 gzrts ts  捐赠额 d_donate lndonate soe leverage   Shrcr1 size Growth ROA Seperation cash law government
winsor2    soe leverage    Shrcr1 size Growth ROA Seperation cash law government ,replace cuts(1 99)
sum    time  d_donate lndonate soe leverage   Shrcr1 size Growth ROA Seperation cash law government
global var1"soe leverage  Shrcr1 size Growth ROA Seperation cash law government"
//table3
ttest time if  codetype==1 ,by( d_donate )
ttest time if  codetype==2 ,by( d_donate )
ttest time if  codetype==1 ,by(  donate1 )
ttest time if  codetype==2 ,by(  donate1 )

//table4：基准回归
reg time d_donate $var1 ,r
est store m1
reg time d_donate $var1 i.year,r
est store m2
reg time d_donate $var1 i.year if  codetype==1,r
est store m3
reg time d_donate $var1 i.year if  codetype==2,r
est store m4
reg time lndonate $var1 ,r
est store m5
reg time lndonate $var1 i.year,r
est store m6
reg time lndonate $var1 i.year if  codetype==1,r
est store m7
reg time lndonate $var1 i.year if  codetype==2,r
est store m8
outreg2 [m1 m2 m3 m4 m5 m6 m7 m8  ] using table1,word

//稳健性检验-tobit
tobit time d_donate $var1 
est store m1
tobit time d_donate $var1 i.year 
est store m2
tobit time d_donate $var1 i.year if  codetype==1 
est store m3
tobit time d_donate $var1 i.year if  codetype==2 
est store m4
tobit time lndonate $var1  
est store m5
tobit time lndonate $var1 i.year 
est store m6
tobit time lndonate $var1 i.year if  codetype==1 
est store m7
tobit time lndonate $var1 i.year if  codetype==2 
est store m8
outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 ] using table2,word

//稳健性检验-换估计模型-poisson
poisson time d_donate $var1 ,vce(robust)
poisson time d_donate $var1 i.year ,vce(robust)
poisson time d_donate $var1 i.year if  codetype==1 ,vce(robust)
poisson time d_donate $var1 i.year if  codetype==2 ,vce(robust)
poisson time lndonate $var1 ,vce(robust)
poisson time lndonate $var1 i.year ,vce(robust)
poisson time lndonate $var1 i.year if  codetype==1 ,vce(robust)
poisson time lndonate $var1 i.year if  codetype==2 ,vce(robust)

*table5：稳健性检验-换time1
reg time1 d_donate $var1 ,r
est store m1
reg time1 d_donate $var1 i.year,r
est store m2
reg time1 d_donate $var1 i.year if  codetype==1,r
est store m3
reg time1 d_donate $var1 i.year if  codetype==2,r
est store m4
reg time1 lndonate $var1 ,r
est store m5
reg time1 lndonate $var1 i.year,r
est store m6
reg time1 lndonate $var1 i.year if  codetype==1,r
est store m7
reg time1 lndonate $var1 i.year if  codetype==2,r
est store m8
outreg2 [m1 m2 m3 m4 m5 m6 m7 m8  ] using table8,word

//table6：内生性问题-IV
bysort province industry soe :egen iv_ddonat=mean( d_donate ) 
bysort province industry soe :egen iv_lndonat=mean( lndonate )//工具变量：按省份、行业、企业性质划分的平均捐赠情况
ivregress 2sls  time $var1  i.year (lndonate= iv_ddonat ) ,first r
ivregress 2sls  time $var1 i.year  (lndonate= iv_lndonat ) ,first r
ivregress 2sls  time $var1  i.year (lndonate= iv_ddonat )  if  codetype==1,first r
ivregress 2sls  time $var1 i.year  (lndonate= iv_lndonat )  if  codetype==1,first r
ivregress 2sls  time $var1  i.year (lndonate= iv_ddonat )  if  codetype==2,first r
ivregress 2sls  time $var1 i.year  (lndonate= iv_lndonat )  if  codetype==2,first r

//table7：机制
poisson level d_donate ,r
poisson level d_donate $var1,r
poisson level d_donate $var1 i.year,r
poisson level lndonate ,r
poisson level lndonate $var1,r
poisson level lndonate $var1 i.year,r
reg time level $var1 i.year,r
reg time1 level $var1 i.year,r

//table8：Charitable donations, types of cases and litigation cycles
reg time d_donate $var1  i.year if codesusong ==1,r
est store m1
reg time lndonate $var1 i.year if codesusong ==1,r
est store m2
reg time d_donate $var1  i.year if codesusong ==2,r
est store m3
reg time lndonate $var1 i.year if codesusong ==2,r
est store m4
reg time d_donate $var1  i.year if codesusong ==3,r
est store m5
reg time lndonate $var1 i.year if codesusong ==3,r
est store m6
outreg2 [m1 m2 m3 m4 m5 m6  ] using table3,word


reg time d_donate $var1  i.year if east ==1,r
est store m1
reg time lndonate $var1  i.year if east ==1,r
est store m2
reg time d_donate $var1  i.year if middle ==1,r
est store m3
reg time lndonate $var1  i.year if middle ==1,r
est store m4
reg time d_donate $var1  i.year if west ==1,r
est store m5
reg time lndonate $var1  i.year if west ==1,r
est store m6
reg time d_donate $var1  i.year if northeast ==1,r
est store m7
reg time lndonate $var1  i.year if northeast ==1,r
est store m8
outreg2 [m1 m2 m3 m4 m5 m6  m7 m8 ] using table4,word



reg time d_donate $var1  i.year if west ==1 &codetype ==1,r
est store m1
reg time lndonate $var1  i.year if west ==1 &codetype ==1,r
est store m2
reg time d_donate $var1  i.year if west ==1 &codetype ==2,r
est store m3
reg time lndonate $var1  i.year if west ==1 &codetype ==2,r
est store m4
reg time d_donate $var1  i.year if northeast ==1 &codetype ==1,r
est store m5
reg time lndonate $var1  i.year if northeast ==1 &codetype ==1,r
est store m6
reg time d_donate $var1  i.year if northeast ==1 &codetype ==2,r
est store m7
reg time lndonate $var1  i.year if northeast ==1 &codetype ==2,r
est store m8
outreg2 [m1 m2 m3 m4 m5 m6  m7 m8 ] using table5,word
///table9：Charitable donations, geographical distribution and litigation cycle
reg time d_donate $var1  i.year if east  ==1 ,r
reg time d_donate $var1  i.year if east  ==1 &codetype ==1,r
reg time d_donate $var1  i.year if middle ==1,r
reg time d_donate $var1  i.year if middle ==1 &codetype ==1,r
reg time d_donate $var1  i.year if west ==1,r
reg time d_donate $var1  i.year if west ==1 &codetype ==1,r
reg time d_donate $var1  i.year if northeast ==1 ,r
reg time d_donate $var1  i.year if northeast ==1 &codetype ==1,r


//table10：Charitable giving, market-based indices and the litigation cycle
egen market_med = median( market )
g hmarket=1 if market> market_med
replace hmarket=0 if hmarket==.
reg time d_donate $var1  i.year if hmarket ==1,r
est store m1
reg time lndonate $var1  i.year if hmarket ==1,r
est store m2
reg time d_donate $var1  i.year if  hmarket  ==0 ,r
est store m3
reg time lndonate $var1  i.year if hmarket  ==0 ,r
est store m4
outreg2 [m1 m2 m3 m4  ] using table7,word
clear
//table11：余论

use "C:\Users\11561\Desktop\Data and procedures\Residuals with panel data.dta"
global var1 "leverage mainreturn Seperation Shrcr1 ROA Growth big4 Parttime cash size lngdp"
global var2 "i.year  i.industry"
xtprobit  d_susong d_donate $var1 $var2 if 2007<year<2022
xtprobit  d_susong lndonate $var1 $var2 if 2007<year<2022
xtprobit  d_beigao d_donate $var1 $var2 if 2007<year<2022
xtprobit d_beigao lndonate $var1 $var2 if 2007<year<2022
xtpoisson susong_time d_donate $var1 $var2   if 2007<year<2022 , r
xtpoisson susong_time lndonate $var1 $var2  if 2007<year<2022  , r
xtpoisson beigao_time d_donate $var1 $var2   if 2007<year<2022 , r
xtpoisson beigao_time lndonate $var1 $var2  if 2007<year<2022  , r
