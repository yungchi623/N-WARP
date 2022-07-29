# N-WARP
The project is part of NARP, including data collection and troubleshooting collection. NWARP is a gaming accelerator which helped user get optimal performance by router. It supports several top game concoles, includes PS5, PS4, Switch.

# Environment
* operating system: OpenWrt Linux

# Guideline
* bigdata: data collection script
  * write_file.sh: after collection data, programer can insert data to database. 
    * ex: write_file.sh $TABLE_NAME "fieldName1" $fieldValue
    * string: "abc"
    * number: 123, +123, -123
    * float: 1.23, +1.23, -1.23
    * datetime: seconds since UNIX epoch
  * other scripts: get NWARP router information, then excute write_file.sh to insert data.
* troubleshooting: web page of troubleshooting and controller function.
  * troubleshooting.htm: user descripts their problems by using this page, when NWARP router can't work.
  * nwarp.lua: interaction between web pages and NWARP router.
