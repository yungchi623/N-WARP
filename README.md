# N-WARP
The project is part of NARP, including data collection and troubleshooting collection. NWARP is a gaming accelerator which helped user get optimal performance by router. It supports several top game concoles, includes PS5, PS4, Switch.

# Environment
* operating system: OpenWrt Linux

# Guideline
* bigdata: data collection script
  * write_file.sh: after collection data, programer can insert data to database. 
    * ex: write_file.sh $FILE_NAME "serialNo","modelName","connectStatus" $serial_no,$model_name,$ping_result
* troubleshooting: web page of troubleshooting and controller function.
