module("luci.controller.admin.nwarp", package.seeall)

function index()
    entry({"admin", "nwarp", "main"}, template("admin_nwarp/main"), _("Home"),1,"home")
    entry({"admin", "nwarp", "main", "msRToken"}, call("action_msRToken"), nil)
    entry({"admin", "nwarp", "main", "delToken"}, call("action_delToken"), nil)
    entry({"admin", "nwarp", "main", "get_member_data"}, call("action_get_member_data"), nil)
    entry({"admin", "nwarp", "main", "get_member_data_logined"}, call("action_get_member_data_logined"), nil)
    entry({"admin", "nwarp", "main", "get_vpn_key"}, call("action_get_vpn_key"), nil)

    entry({"admin", "nwarp", "devices"}, template("admin_nwarp/devices"), _("Devices"),2,"devicesetting")
    entry({"admin", "nwarp", "devices", "toggle_ovpn"}, post("toggle_ovpn"), nil) --add for onoff switch in device page
    entry({"admin", "nwarp", "devices", "get_server_ip"}, call("action_get_server_ip"), nil)

    entry({"admin", "nwarp", "dashboard"}, template("admin_nwarp/dashboard"), _("Dashboard"), 3 , "dashboard")
    entry({"admin", "nwarp", "dashboard", "realtime_data"}, call("action_realtime_data"))
    entry({"admin", "nwarp", "dashboard", "statistical"}, call("action_statistical"))
    entry({"admin", "nwarp", "dashboard", "toggle_ovpn"}, post("toggle_ovpn"), nil)
    entry({"admin", "nwarp", "dashboard", "get_dashboard_stay"}, call("action_get_dashboard_stay"), nil)
    entry({"admin", "nwarp", "dashboard", "get_latency_list"}, call("get_latency_list"), nil)
    entry({"admin", "nwarp", "dashboard", "get_game_list"}, call("get_game_list"), nil)

    entry({"admin", "nwarp", "settings"}, template("admin_nwarp/settings"), _("Settings"),4,"settings")
    entry({"admin", "nwarp", "settings", "getgamelist"}, post("getGameList"), nil)
    entry({"admin", "nwarp", "settings", "getlogo"}, post("getlogo"), nil)
    entry({"admin", "nwarp", "settings", "changeSettings"}, post("changeSettings"), nil)

    entry({"admin", "nwarp", "troubleshooting"}, template("admin_nwarp/troubleshooting"), _("Troubleshoot"),5,"troubleshoot")
    entry({"admin", "nwarp", "troubleshooting", "get_trouble_info"}, call("action_get_trouble_info"), nil)
    entry({"admin", "nwarp", "troubleshooting", "getproblemfileName"}, post("getproblemfileName"), nil)

    -- entry({"admin", "nwarp", "usermileage"}, template("admin_nwarp/mileage"), _("User Mileage"),6,"mileage")

    entry({"admin", "nwarp", "feedback"}, template("admin_nwarp/feedback"), _("Feedback"),7,"feedback")
    entry({"admin", "nwarp", "feedback", "getsn"}, post("getsn"), nil)
    entry({"admin", "nwarp", "feedback", "binding_data"}, call("action_binding_data"), nil)
    entry({"admin", "nwarp", "feedback", "gettoken"}, post("gettoken"), nil)

    entry({"admin", "nwarp", "getGamereportData"}, post("getGamereportData"), nil)
    entry({"admin", "nwarp", "downloadfw"}, post("downloadfw"), nil)
    entry({"admin", "nwarp", "checkfwinfo"}, post("checkfwinfo"), nil)
    entry({"admin", "nwarp", "dofwupgrade"}, post("dofwupgrade"), nil)
    entry({"admin", "nwarp", "check_status"}, post("check_status"), nil)

end


-- add
function action_get_server_ip()
    local uci = require "luci.model.uci"
    cur = uci.cursor()
    vpn_status = cur:get("nwarp", "vpn", "status")
    if vpn_status == "255" then
        luci.sys.exec("/etc/4gamers/getServerIP")
    end
end

function action_msRToken()

    local refreshtoken = luci.http.formvalue("refreshtoken")
    local accesstoken = luci.http.formvalue("accesstoken")

    luci.sys.exec("uci set nwarp.member.refreshtoken=" .. refreshtoken)
    luci.sys.exec("uci set nwarp.member.accesstoken=" .. accesstoken)

    luci.sys.exec("rm /tmp/loginstatus")
end

function action_delToken()
    luci.sys.exec("uci -q delete nwarp.member.login_scheme")
    luci.sys.exec("uci -q delete nwarp.member.login_name")
    luci.sys.exec("uci -q delete nwarp.member.userID")
    luci.sys.exec("uci -q delete nwarp.member.first_login")
    luci.sys.exec("uci -q delete nwarp.member.avatarUrl")
    luci.sys.exec("uci -q delete nwarp.member.planKeys")
    luci.sys.exec("uci -q delete nwarp.member.scheme_type_UI")
    luci.sys.exec("uci -q delete nwarp.member.purchase_scheme")
    luci.sys.exec("uci -q delete nwarp.member.m_expiredAt")

    luci.sys.exec("uci -q delete nwarp.member.refreshtoken")
    luci.sys.exec("uci -q delete nwarp.member.accesstoken")

    luci.sys.exec("/etc/init.d/userDataManager stop")
	luci.sys.exec("/etc/init.d/switchOn stop")
	luci.sys.exec("/etc/init.d/launch_openvpn stop")
end


function action_get_member_data()
    luci.sys.exec("touch /tmp/loginstatus")

    local login_scheme = luci.http.formvalue("login_scheme")
    local login_name = luci.http.formvalue("login_name")
    local userID = luci.http.formvalue("userID")
    local first_login = luci.http.formvalue("first_login")
    local avatarUrl = luci.http.formvalue("avatarUrl")
    local planKeys = luci.http.formvalue("planKeys")
    local scheme_type_UI = luci.http.formvalue("scheme_type_UI")
    local purchase_scheme = luci.http.formvalue("purchase_scheme")

    luci.sys.exec("uci set nwarp.member.login_scheme=" .. login_scheme)
    luci.sys.exec("uci set nwarp.member.login_name=" .. login_name)
    luci.sys.exec("uci set nwarp.member.userID=" .. userID)
    luci.sys.exec("uci set nwarp.member.first_login=" .. first_login)
    luci.sys.exec("uci set nwarp.member.avatarUrl=" .. avatarUrl)
    luci.sys.exec("uci set nwarp.member.planKeys=" .. planKeys)
    luci.sys.exec("uci set nwarp.member.scheme_type_UI=" .. scheme_type_UI)
    luci.sys.exec("uci set nwarp.member.purchase_scheme=" .. purchase_scheme)

    luci.sys.exec("/etc/init.d/userDataManager start")
--[[
    luci.sys.exec("/etc/4gamers/getNodeIP")
    luci.sys.exec("/etc/init.d/ipset_vpn start")
    luci.sys.exec("/etc/4gamers/getServerIP")
    luci.sys.exec("/etc/4gamers/getGameList &")
    luci.sys.exec("/etc/4gamers/getLogoFull")
--]]
end

function action_get_member_data_logined()
    local login_scheme = luci.http.formvalue("login_scheme")
    local login_name = luci.http.formvalue("login_name")
    local userID = luci.http.formvalue("userID")
    local first_login = luci.http.formvalue("first_login")
    local avatarUrl = luci.http.formvalue("avatarUrl")
    local m_expiredAt = luci.http.formvalue("m_expiredAt")
    local purchase_scheme = luci.http.formvalue("purchase_scheme")

    luci.sys.exec("uci set nwarp.member.login_scheme=" .. login_scheme)
    luci.sys.exec("uci set nwarp.member.login_name=" .. login_name)
    luci.sys.exec("uci set nwarp.member.userID=" .. userID)
    luci.sys.exec("uci set nwarp.member.first_login=" .. first_login)
    luci.sys.exec("uci set nwarp.member.avatarUrl=" .. avatarUrl)
    luci.sys.exec("uci set nwarp.member.m_expiredAt=" .. m_expiredAt)
    luci.sys.exec("uci set nwarp.member.purchase_scheme=" .. purchase_scheme)

end

function action_get_vpn_key()
    luci.sys.exec("/etc/4gamers/getKey")
end


function gettoken()
    local token = luci.sys.exec("/etc/4gamers/getToken")
    luci.http.prepare_content("application/json")
    luci.http.write_json({ token = token })
end

function action_binding_data()
    local name=luci.http.formvalue("name")
    local email=luci.http.formvalue("email")

    luci.sys.exec("fw_setenv name " .. name)
    luci.sys.exec("fw_setenv email " .. email)
    luci.sys.exec("fw_setenv isbind 1")

end

function getsn()
    local sn = luci.sys.exec("fw_printenv -n SN")
    luci.http.prepare_content("application/json")
    luci.http.write_json({ sn = sn })
end

function getGamereportData()
    luci.sys.exec("cat /dev/null > /etc/4gamers/conf/game_report")
    local playDate = luci.http.formvalue("playDate")
    luci.sys.exec("echo playDate=" .. playDate .. " >> /etc/4gamers/conf/game_report")
    local timeStart = luci.http.formvalue("timeStart")
    luci.sys.exec("echo timeStart=" .. timeStart .. " >> /etc/4gamers/conf/game_report")
    local timeEnd = luci.http.formvalue("timeEnd")
    luci.sys.exec("echo timeEnd=" .. timeEnd .. " >> /etc/4gamers/conf/game_report")
    local gameName = luci.http.formvalue("gameName")
    luci.sys.exec("echo gameName=" .. gameName .. " >> /etc/4gamers/conf/game_report")
    local gameServer = luci.http.formvalue("gameServer")
    luci.sys.exec("echo gameServer=" .. gameServer .. " >> /etc/4gamers/conf/game_report")

    local report_status = luci.sys.exec("/etc/4gamers/bigdata/game_report.sh | tail -n1")
    luci.http.prepare_content("application/json")
    luci.http.write_json({ report_status = report_status })

end

function getGameList()
    local gameList = luci.sys.exec("grep $(uci get luci.main.lang) /etc/4gamers/conf/gameId |awk -F, '{print $NF}'")
        gameList = luci.util.trim(gameList)
        gameList = luci.util.split(gameList,'\n')
    local gameIdList = luci.sys.exec("grep $(uci get luci.main.lang) /etc/4gamers/conf/gameId |awk -F, '{print $1}'")
        gameIdList = luci.util.trim(gameIdList)
        gameIdList = luci.util.split(gameIdList,'\n')

    luci.http.prepare_content("application/json")
    luci.http.write_json({  gameList = gameList, gameIdList = gameIdList})
end

function getlogo()
    local gameid=luci.http.formvalue("gameid")

    luci.util.exec("/etc/4gamers/getLogoFull")

    --logo = "/luci-static/resources/tmplogo/" .. gameid .. ".png"
    logo = luci.util.exec("/etc/4gamers/getLogo " .. gameid)

    luci.http.prepare_content("application/json")
    luci.http.write_json({ gameid = gameid, logo = logo })

end

function changeSettings()

    local option=luci.http.formvalue("option")

    local switch = {
        ['1'] = function()    -- for case 1
            local ip=luci.http.formvalue("ip")

            luci.sys.exec("uci set network.lan.ipaddr=" .. ip)
            luci.sys.exec("uci commit network")

            luci.http.prepare_content("application/json")
            luci.http.write_json({ip = ip})
        end,
        ['2'] = function()    -- for case 2
            local lang=luci.http.formvalue("lang")

            luci.sys.exec("uci set luci.main.lang=" .. lang)
            luci.sys.exec("uci commit luci.main.lang")

            local lang_rest=lang
            if lang == "en" then lang_rest="en_us" end
            luci.sys.exec("/etc/4gamers/getGameList " .. lang_rest)

            local result=luci.sys.exec("uci get luci.main.lang")

            luci.http.prepare_content("application/json")
            luci.http.write_json({result = result,lang = lang})
        end,
        ['3'] = function()    -- for case 3
            local country=luci.http.formvalue("country")
            local admin_dist=luci.http.formvalue("admin_dist")

            luci.sys.exec("echo 'country=" .. country .. "' > /etc/4gamers/conf/initconfig")
            luci.sys.exec("echo 'admin_dist=" .. admin_dist .. "' >> /etc/4gamers/conf/initconfig")

            luci.sys.exec("/etc/4gamers/bigdata/router_area.sh")

            luci.http.prepare_content("application/json")
            luci.http.write_json({country = country,admin_dist = admin_dist})
        end
    }

    local f = switch[option]
    if(f) then
        f()
    else                -- for case default
        luci.http.prepare_content("application/json")
        luci.http.write_json({option=option})
    end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function getproblemfileName()

    while( true )
    do
     if file_exists('/tmp/problemfilename') == true then break end
    end

    local problemfilename = luci.sys.exec("cat /tmp/problemfilename")
    problemfilename = luci.util.trim(problemfilename)
    luci.sys.exec("rm /tmp/problemfilename")
    luci.http.prepare_content("application/json")
    luci.http.write_json({ problemfilename = problemfilename })
end

function action_get_trouble_info()
    local trouble_name = luci.http.formvalue("trouble_name")
    local trouble_classify = luci.http.formvalue("trouble_classify")
    local platform_test = luci.http.formvalue("platform_test")
    local description = luci.http.formvalue("description")
    description = string.gsub(description, '\n', "\\n")

    luci.sys.exec("mkdir /tmp/tmp_log")
    luci.sys.exec("cat /dev/null > /tmp/tmp_log/trouble_info")

    file = io.open("/tmp/tmp_log/trouble_info", "a")
    file:write("trouble_name=" .. trouble_name .. "\n")
    file:write("trouble_classify=" .. trouble_classify .. "\n")
    file:write("platform_test=" .. platform_test .. "\n")
    file:write("description=" .. description .. "\n")
    file:close()
    os.execute("/etc/4gamers/bigdata/collection_log.sh &")
end


function check_status()
    local network_status = luci.util.exec("ping -q -c 1 -W 1 8.8.8.8 >/dev/null;echo $?")
    network_status = luci.util.trim(network_status)

    local file = luci.util.exec("[ -d /tmp/tmp_log ] ; echo $?");

    luci.http.prepare_content("application/json")

    luci.http.write_json({ is_exist = file, network_status = network_status })
end

function action_realtime_data()
    luci.http.prepare_content("application/json")
    luci.http.write("[")
    local cpu_usage = luci.sys.exec("top -b -n1 | grep CPU\: | grep -v grep | awk '{print 100 - $8}' | tr -d '\n'")
    luci.http.write("[")
    luci.http.write_json(cpu_usage)
    luci.http.write("],")
    local bwc = io.popen("luci-bwc -i eth0.2 2>/dev/null")

    if bwc then
        while true do
            local ln = bwc:read("*l")
            if not ln then break end
            luci.http.write(ln)
        end
        bwc:close()
    end

    luci.http.write("]")
end

function action_statistical()

    luci.http.prepare_content("application/json")
    local ipList = luci.util.exec("cat /etc/4gamers/conf/triggered_device")
          ipList = luci.util.trim(ipList)
          ipList = luci.util.split(ipList,'\n')
    local macList = {}
    local postfixList = {}

    luci.http.write("[")
    if #ipList == 1 and ipList[1] == "" then
        luci.http.write("")
    else
        for i = 1,#ipList do
            if i > 1 then
                luci.http.write(",")
            end
            --[[
            [
             [ Dev_1_ip , status , (GameName) ] , [ [data1] , [data2] , ... , [dataN] ],
             ... ,
             [ Dev_n_ip , status , (GameName) ] , [ [data1] , [data2] , ... , [dataN] ]
            ]
            --]]
            luci.http.write("[")
            luci.http.write("[")
            macList[i] = luci.util.exec("cat /etc/4gamers/conf/actived_device | grep " .. ipList[i] .. " | awk '{print $2}'")
            --macList[i] = luci.util.exec("cat /etc/4gamers/dhcp.leases | grep " .. ipList[i] .. " | awk '{print $2}'")
            if macList[i] ~= "" then
                macList[i] = luci.util.trim(macList[i])
                postfixList[i] = string.gsub(macList[i],":","")
                luci.http.write("\"" .. ipList[i] .. "\"")
                luci.http.write(",")

                local status = luci.sys.exec("cat /etc/4gamers/tracefiles/PGstatus_" .. postfixList[i])
                if status ~= "" then
                    status = luci.util.trim(status)
                    status = luci.util.split(status,',')

                    if #status == 1 then
                        luci.http.write(status[1])
                    else
                        -- local gameName = luci.sys.exec("sed -n ".. status[2].."p /etc/4gamers/conf/gameId")
                        -- gameName = luci.util.trim(gameName)
                        lang = luci.util.exec("uci get luci.main.lang")
                        lang = luci.util.trim(lang)
                        local gameName = luci.util.exec("grep ^".. status[2] ..",".. lang .." /etc/4gamers/conf/gameId |awk -F, '{print $NF}'")
                        gameName = luci.util.trim(gameName)
                        luci.http.write(status[1]..',\"'..gameName..'\",'..status[2]..',\"'..status[3]..'\"')
                    end
                else
                    luci.http.write("1")
                end

                luci.http.write("]")

                luci.http.write(",")
                luci.http.write("[")


                local tracedata = io.popen("tail -n100 /etc/4gamers/tracefiles/traceupdate_" .. postfixList[i] .. ".json")
                if tracedata then
                    --luci.http.write(",")
                    while true do
                        local ln = tracedata:read("*l")
                        if not ln then break end
                        luci.http.write(ln)
                    end
                    tracedata:close()
                end


            else
                luci.http.write("\"" .. ipList[i] .. "\",1],[")
            end

            luci.http.write("]")
            luci.http.write("]")

        end
    end
    luci.http.write("]")

end

function action_get_dashboard_stay()
    local is_start = luci.http.formvalue("is_start")
    os.execute("/etc/4gamers/bigdata/dashboard_stay.sh " .. is_start .. " &")
end

function checkfwinfo()
    local upgrade_res=luci.util.exec("/etc/4gamers/getFW -f")
    upgrade_res=luci.util.trim(upgrade_res)
    upgrade_res=luci.util.split(upgrade_res,",")
    upgrade_status=upgrade_res[1]
    upgrade_ver=upgrade_res[2]
    upgrade_force=upgrade_res[3]

    luci.http.prepare_content("application/json")
    luci.http.write_json({ status = upgrade_status, ver = upgrade_ver })
end

function dofwupgrade()
    luci.util.exec("/etc/4gamers/doFWUpgrade -w")
end

function downloadfw()
    local ver = luci.http.formvalue("ver")

    expireDate=luci.util.exec("cat /etc/4gamers/conf/fwUpgradeInfo|grep expireDate")
    expireDate=luci.util.trim(expireDate)
    expireDate=string.sub(expireDate,12)

    queryCksum=luci.util.exec("cat /etc/4gamers/conf/fwUpgradeInfo|grep cksum")
    queryCksum=luci.util.trim(queryCksum)
    queryCksum=string.sub(queryCksum,7)

    cur = os.date("!%s")
    if cur > expireDate then
        url=luci.util.exec("/etc/4gamers/getFW " .. ver)
    end
    url=luci.util.exec("cat /etc/4gamers/conf/fwUpgradeInfo|grep link")
    url=luci.util.trim(url)
    url=string.sub(url,6)

    --luci.util.exec("curl -s " .. url .. " -o /tmp/fw.tar")

    luci.util.exec("curl -s http://175.111.192.15/fw.tar -o /tmp/fw.tar")

    tmpCksum = luci.util.exec("md5sum /tmp/fw.tar |awk '{print $1}'")
    tmpCksum = luci.util.trim(tmpCksum)

    if queryCksum == tmpCksum then
        result = 0
    else
        result = 1
    end

    luci.http.prepare_content("application/json")
    luci.http.write_json({  queryCksum = queryCksum, tmpCksum = tmpCksum, result = result })
end

function toggle_ovpn()
    local ovpn = tonumber(luci.http.formvalue("ovpn"))

    local result = luci.util.exec("/etc/4gamers/togglevpn " .. ovpn)
          result = luci.util.trim(result)
          result = luci.util.split(result,',')

    luci.http.prepare_content("application/json")
    luci.http.write_json({
        ovpn = result[1],
        status = result[2],
	errorcode = result[3]
	--[[
        nstatus = result[3],
        lstatus = result[4],
        sn = result[5],
        sol1 = result[6],
        sol2 = result[7],
        kstatus = result[8],
        kstatus2 = result[9]
	--]]
        })

end

function get_latency_list()
    local result=luci.util.exec("cat /tmp/latencylist")
    result = string.split(result)
    list = {}
    for i = 1,#result do
        tmp=string.split(result[i],' ')
        list[tmp[1]] = tmp[2]
    end

    luci.http.prepare_content("application/json")
    luci.http.write_json(list)
end

function get_game_list()
    vpnReady=luci.util.exec("uci get nwarp.vpn.ready")
    vpnReady=luci.util.trim(vpnReady)
    while( vpnReady ~= "1" )
    do
        os.execute("sleep 1")
        vpnReady=luci.util.exec("uci get nwarp.vpn.ready")
        vpnReady=luci.util.trim(vpnReady)
    end

    regionList=luci.util.exec("sed -n '2,$p' /etc/4gamers/conf/vpnip | awk '{print $1,$3}' | sort -n | uniq")
    regionList=luci.util.trim(regionList)
    regionList=luci.util.split(regionList,'\n')
    for i, v in ipairs(regionList) do
        regionList[i]=luci.util.split(v,' ')
    end

    lang=luci.util.exec("uci get luci.main.lang")
    lang=luci.util.trim(lang)

    if lang == "" then
        lang = "en_us"
    end

    gameNameList=luci.util.exec("grep " .. lang .. " /etc/4gamers/conf/gameId")
    gameNameList=luci.util.split(gameNameList,'\n')
    for i, v in ipairs(gameNameList) do
        tmp=luci.util.split(v,',')
        gameNameList[i]={tmp[1],tmp[3]}
    end

    rv = {regionList,gameNameList}

    luci.http.prepare_content("application/json")
    luci.http.write_json(rv)
end
