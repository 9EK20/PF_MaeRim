local id, sda, scl, device = 0, 21, 22, 0x68
local BLUE_LED = 13
local name,value,start_time_1,end_time_1,start_time_2,end_time_2
,start_time_3,end_time_3,start_time_4,end_time_4,timeStr,dateStr,rtctime,rtcdate,getlogTimeon,getlogTimeoff,
value_1,value_2,value_3,value_4,rtcHr,rtcMin,light_value
netstat = "0"
getlogTimeon2 = " "
getlogTimeoff2 = " "
getlogTimeon3 = " "
getlogTimeoff3 = " "
getlogTimeon4 = " "
getlogTimeoff4 = " "
logon = "0"
logon2 = "0"
logon3 = "0"
logon4 = "0"
logoff = "0"
logoff2 = "0"
logoff3 = "0"
logoff4 = "0"
statusto = "0"
statustf = "0"
statusto2 = "0"
statustf2 = "0"
statusto3 = "0"
statustf3 = "0"
statusto4 = "0"
statustf4 = "0"
checktime = "0"
local count_on = 0
local count_off = 0
local sw_name = "shelf_1_2"
local api = "capi"
timerstep = 1
gpio.config({ gpio = BLUE_LED, dir = gpio.IN_OUT })
gpio.write(BLUE_LED, 0)
i2c.setup(id, sda, scl, i2c.SLOW)

-- -- เขียน log รันไฟล์จาก server
-- local function logRunfile()
--   headers = {
--     ["Content-Type"] = "application/x-www-form-urlencoded",
--   }
--   body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Run file from server')
--   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
--     function(code, data)
--       if (code < 0) then
--         print("HTTP request failed")
--       else
--         print(data)
--       end
--     end)
-- end

-- -- เขียน log เมื่อได้รับคำสั่ง restart จาก server
-- local function logRestart()
--   headers = {
--     ["Content-Type"] = "application/x-www-form-urlencoded",
--   }
--   body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Restart from server')
--   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
--     function(code, data)
--       if (code < 0) then
--         print("HTTP request failed")
--       else
--         print(data)
--       end
--     end)
-- end

-- -- รอรับคำสั่ง getFile จาก server
-- local function getFile()
--   http.get("http://209.58.180.39/code/lua_update.php", function(code, data)
--     if (code < 0) then
--       print("HTTP request failed")
--     else
--       if data == "1" then
--         http.get("http://209.58.180.39/code/Blink_lua.txt", function(code, data)
--           if (code < 0) then
--             print("HTTP request failed")
--           else
--             print(code, data)
--             file.open("blink.lua", "w+")
--             file.write(data)
--             file.close()
--             node.compile("blink.lua")
--             dofile("blink.lc")
--             logRunfile()
--           end 
--         end)
--       end
--     end
--   end)
-- end

-- -- รอรับคำสั่ง Restart จาก server
-- local function getRestart()
--   http.get("http://209.58.180.39/code/reset.php", function(code, data)
--         node.restart()
--     if (code < 0) then
--       print("HTTP request failed")
--     else
--       if data == "1" then
--         logRestart()
--       end
--     end
--   end)
-- end

-- บันทึกค่าตัวแปรไว้ในไฟล์ txt
local function saveVar()
  if file.open("start_time_1.txt","w+") then
    file.writeline(start_time_1)
    file.close()
  end
  if file.open("start_time_2.txt","w+") then
    file.writeline(start_time_2)
    file.close()
  end
  if file.open("start_time_3.txt","w+") then
    file.writeline(start_time_3)
    file.close()
  end
  if file.open("start_time_4.txt","w+") then
    file.writeline(start_time_4)
    file.close()
  end
  if file.open("end_time_1.txt","w+") then
    file.writeline(end_time_1)
    file.close()
  end
  if file.open("end_time_2.txt","w+") then
    file.writeline(end_time_2)
    file.close()
  end
  if file.open("end_time_3.txt","w+") then
    file.writeline(end_time_3)
    file.close()
  end
  if file.open("end_time_4.txt","w+") then
    file.writeline(end_time_4)
    file.close()
  end
  if file.open("value.txt","w+") then
    file.writeline(value)
    file.close()
  end
  if file.open("value_1.txt","w+") then
    file.writeline(value_1)
    file.close()
  end
  if file.open("value_2.txt","w+") then
    file.writeline(value_2)
    file.close()
  end
  if file.open("value_3.txt","w+") then
    file.writeline(value_3)
    file.close()
  end
  if file.open("value_4.txt","w+") then
    file.writeline(value_4)
    file.close()
  end
  if file.open("hrstart_time1.txt","w+") then
    file.writeline(hrstart_time1)
    file.close()
  end
  if file.open("hrstart_time2.txt","w+") then
    file.writeline(hrstart_time2)
    file.close()
  end
  if file.open("hrstart_time3.txt","w+") then
    file.writeline(hrstart_time3)
    file.close()
  end
  if file.open("hrstart_time4.txt","w+") then
    file.writeline(hrstart_time4)
    file.close()
  end
  if file.open("minstart_time1.txt","w+") then
    file.writeline(minstart_time1)
    file.close()
  end
  if file.open("minstart_time2.txt","w+") then
    file.writeline(minstart_time2)
    file.close()
  end
  if file.open("minstart_time3.txt","w+") then
    file.writeline(minstart_time3)
    file.close()
  end
  if file.open("minstart_time4.txt","w+") then
    file.writeline(minstart_time4)
    file.close()
  end
  if file.open("hrend_time1.txt","w+") then
    file.writeline(hrend_time1)
    file.close()
  end
  if file.open("hrend_time2.txt","w+") then
    file.writeline(hrend_time2)
    file.close()
  end
  if file.open("hrend_time3.txt","w+") then
    file.writeline(hrend_time3)
    file.close()
  end
  if file.open("hrend_time4.txt","w+") then
    file.writeline(hrend_time4)
    file.close()
  end
  if file.open("minend_time1.txt","w+") then
    file.writeline(minend_time1)
    file.close()
  end
  if file.open("minend_time2.txt","w+") then
    file.writeline(minend_time2)
    file.close()
  end
  if file.open("minend_time3.txt","w+") then
    file.writeline(minend_time3)
    file.close()
  end
  if file.open("minend_time4.txt","w+") then
    file.writeline(minend_time4)
    file.close()
  end
  if file.open("statusto.txt","w+") then
    file.writeline(statusto)
    file.close()
  end
  if file.open("statustf.txt","w+") then
    file.writeline(statustf)
    file.close()
  end
  if file.open("statusto2.txt","w+") then
    file.writeline(statusto2)
    file.close()
  end
  if file.open("statustf2.txt","w+") then
    file.writeline(statustf2)
    file.close()
  end
  if file.open("statusto3.txt","w+") then
    file.writeline(statusto3)
    file.close()
  end
  if file.open("statustf3.txt","w+") then
    file.writeline(statustf3)
    file.close()
  end
  if file.open("statusto4.txt","w+") then
    file.writeline(statusto4)
    file.close()
  end
  if file.open("statustf4.txt","w+") then
    file.writeline(statustf4)
    file.close()
  end
end

-- รับค่าจากไฟล์ txt
local function getVar()
  fd = file.open("start_time_1.txt", "r")
  if fd then
    start_time_1 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("start_time_2.txt", "r")
  if fd then
    start_time_2 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("start_time_3.txt", "r")
  if fd then
    start_time_3 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("start_time_4.txt", "r")
  if fd then
    start_time_4 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("end_time_1.txt", "r")
  if fd then
    end_time_1 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("end_time_2.txt", "r")
  if fd then
    end_time_2 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("end_time_3.txt", "r")
  if fd then
    end_time_3 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("end_time_4.txt", "r")
  if fd then
    end_time_4 = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("value.txt", "r")
  if fd then
    value = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("value_1.txt", "r")
  if fd then
    value_1 = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("value_2.txt", "r")
  if fd then
    value_2 = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("value_3.txt", "r")
  if fd then
    value_3 = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("value_4.txt", "r")
  if fd then
    value_4 = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("hrstart_time1.txt", "r")
  if fd then
    hrstart_time1 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrstart_time2.txt", "r")
  if fd then
    hrstart_time2 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrstart_time3.txt", "r")
  if fd then
    hrstart_time3 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrstart_time4.txt", "r")
  if fd then
    hrstart_time4 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minstart_time1.txt", "r")
  if fd then
    minstart_time1 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minstart_time2.txt", "r")
  if fd then
    minstart_time2 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minstart_time3.txt", "r")
  if fd then
    minstart_time3 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minstart_time4.txt", "r")
  if fd then
    minstart_time4 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrend_time1.txt", "r")
  if fd then
    hrend_time1 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrend_time2.txt", "r")
  if fd then
    hrend_time2 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrend_time3.txt", "r")
  if fd then
    hrend_time3 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("hrend_time4.txt", "r")
  if fd then
    hrend_time4 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minend_time1.txt", "r")
  if fd then
    minend_time1 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minend_time2.txt", "r")
  if fd then
    minend_time2 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minend_time3.txt", "r")
  if fd then
    minend_time3 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("minend_time4.txt", "r")
  if fd then
    minend_time4 = tonumber(fd:read(2))
    fd:close(); fd = nil
  end
  fd = file.open("statusto.txt", "r")
  if fd then
    statusto = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("statustf.txt", "r")
  if fd then
    statustf = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeon1.txt", "r")
  if fd then
    getlogTimeon = fd:read(35)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeoff1.txt", "r")
  if fd then
    getlogTimeoff = fd:read(36)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeon2.txt", "r")
  if fd then
    getlogTimeon2 = fd:read(35)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeoff2.txt", "r")
  if fd then
    getlogTimeoff2 = fd:read(36)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeon3.txt", "r")
  if fd then
    getlogTimeon3 = fd:read(35)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeoff3.txt", "r")
  if fd then
    getlogTimeoff3 = fd:read(36)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeon4.txt", "r")
  if fd then
    getlogTimeon4 = fd:read(35)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeoff4.txt", "r")
  if fd then
    getlogTimeoff4 = fd:read(36)
    fd:close(); fd = nil
  end
end

--รับค่าเวลาจาก module RTC
local function getRtc()
  i2c.setup(id, sda, scl, i2c.SLOW)
  i2c.start(id)
  i2c.address(id, device, i2c.TRANSMITTER)
  i2c.write(id, 0)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, device, i2c.RECEIVER)
  c = i2c.read(id, 7)  -- Read 7 bytes of data
  i2c.stop(id)

  rtctime = string.format("%02x:%02x:%02x",string.byte(c, 3)
    ,string.byte(c, 2),string.byte(c, 1))
  rtcdate =  string.format("%02x-%02x-%02x",string.byte(c, 5)
    ,string.byte(c, 6),string.byte(c, 7))
  rtcHr = tonumber(string.sub(rtctime,1,-7))
  rtcMin = tonumber(string.sub(rtctime,4,-4))
  print(rtctime)
end

local function logofflineTimeon()
  if logon == "1" then
    if file.open(string.format('%s.%s','logoffline-timeon1','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer1 ON'))
      file.close()
      print('write file')
    end
    logon = "0"
  end
  if logon2 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeon2','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer2 ON'))
      file.close()
      print('write file')
    end
    logon2 = "0"
  end
  if logon3 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeon3','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer3 ON'))
      file.close()
      print('write file')
    end
    logon3 = "0"
  end
  if logon4 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeon4','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer4 ON'))
      file.close()
      print('write file')
    end
    logon4 = "0"
  end
end

-- เขียน log offline ตอนตั้งเวลาปิด
local function logofflineTimeoff()
  if logoff == "1" then
    if file.open(string.format('%s.%s','logoffline-timeoff1','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer1 OFF'))
      file.close()
      print('write file')
    end
    logoff = "0"
  end
  if logoff2 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeoff2','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer2 OFF'))
      file.close()
      print('write file')
    end
    logoff2 = "0"
  end
  if logoff3 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeoff3','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer3 OFF'))
      file.close()
      print('write file')
    end
    logoff3 = "0"
  end
  if logoff4 == "1" then
    if file.open(string.format('%s.%s','logoffline-timeoff4','txt'), "w+") then
      file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Timer4 OFF'))
      file.close()
      print('write file')
    end
    logoff4 = "0"
  end
end

local function updatestatusOn()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s&%s=%s', 'name',sw_name,'light_value','1')
  http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light2/updatelightvalue.php'), { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

local function updatestatusOff()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s&%s=%s', 'name',sw_name,'light_value','0')
  http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light2/updatelightvalue.php'), { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

-- ตั้งค่าการทำงานหลังจากสถานะ offline
local function offlineControl()
  print('Offline')
  getRtc()
  getVar()
  if value == "1" then
    print('Main Switch ON')
    if timerstep == 1 then
      if value_1 == "1" then
        print(string.format('%s - %s','timer1 start',start_time_1))
        print(string.format('%s - %s','timer1 end',end_time_1))
        if hrend_time1 < rtcHr then
          timerstep = 2
          if count_off < 2 then
            count_off = count_off + 1
          end
          gpio.write(BLUE_LED, 0)
          count_on = 0
          if count_off == 1 then
            print('Time1 OFF')
            statustf = "1"
            logoff = "1"
            logofflineTimeoff()
            saveVar()
          end
        elseif hrend_time1 == rtcHr and minend_time1 <= rtcMin then
          timerstep = 2
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time1 OFF')
            statustf = "1"
            logoff = "1"
            logofflineTimeoff()
            saveVar()
          end
        elseif hrstart_time1 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time1 ON')
            statusto = "1"
            logon = "1"
            logofflineTimeon()
            saveVar()
          end   
        elseif hrstart_time1 == rtcHr and minstart_time1 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time1 ON')
            statusto = "1"
            logon = "1"
            logofflineTimeon()
            saveVar()
          end   
        else
          gpio.write(BLUE_LED, 0)
        end      
      else
        gpio.write(BLUE_LED, 0)
        timerstep = 2
      end    
    elseif timerstep == 2 then
      if value_2 == "1" then
        print(string.format('%s - %s','timer2 start',start_time_2))
        print(string.format('%s - %s','timer2 end',end_time_2))
        if hrend_time2 < rtcHr then
          timerstep = 3
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time2 OFF')
            statustf2 = "1"
            logoff2 = "1"
            logofflineTimeoff()
            saveVar()
          end 
        elseif hrend_time2 == rtcHr and minend_time2 <= rtcMin then
          timerstep = 3
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time2 OFF')
            statustf2 = "1"
            logoff2 = "1"
            logofflineTimeoff()
            saveVar()
          end 
        elseif hrstart_time2 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time2 ON')
            statusto2 = "1"
            logon2 = "1"
            logofflineTimeon()
            saveVar()
          end
        elseif hrstart_time2 == rtcHr and minstart_time2 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time2 ON')
            statusto2 = "1"
            logon2 = "1"
            logofflineTimeon()
            saveVar()
          end
        else
          gpio.write(BLUE_LED, 0)
        end   
      else
        gpio.write(BLUE_LED, 0)
        timerstep = 3
      end    
    elseif timerstep == 3 then
      if value_3 == "1" then
        print(string.format('%s - %s','timer3 start',start_time_3))
        print(string.format('%s - %s','timer3 end',end_time_3))
        if hrend_time3 < rtcHr then
          timerstep = 4
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0        
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time3 OFF')
            logoff3 = "1"
            statustf3 = "1"
            logofflineTimeoff()
            saveVar()
          end
        elseif hrend_time3 == rtcHr and minend_time3 <= rtcMin then
          timerstep = 4
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time3 OFF')
            statustf3 = "1"
            logoff3 = "1"
            logofflineTimeoff()  
            saveVar()
          end
        elseif hrstart_time3 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time3 ON')
            logon3 = "1"
            statusto3 = "1"
            logofflineTimeon() 
            saveVar()
          end
        elseif hrstart_time3 == rtcHr and minstart_time3 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          gpio.write(BLUE_LED, 1)
          count_off = 0
          if count_on == 1 then
            print('Time3 ON')
            logon3 = "1"
            statusto3 = "1"
            logofflineTimeon() 
            saveVar()
          end
        else
          gpio.write(BLUE_LED, 0)
        end    
      else
        gpio.write(BLUE_LED, 0)
        timerstep = 4
      end    
    elseif timerstep == 4 then
      if value_4 == "1" then
        print(string.format('%s - %s','timer4 start',start_time_4))
        print(string.format('%s - %s','timer4 end',end_time_4))
        if hrend_time4 < rtcHr then
          timerstep = 1 
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time4 OFF')
            logoff4 = "1"
            statustf4 = "1"
            logofflineTimeoff()   
            saveVar()
          end
        elseif hrend_time4 == rtcHr and minend_time4 <= rtcMin then
          timerstep = 1
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time4 OFF')
            logoff4 = "1"
            statustf4 = "1"
            logofflineTimeoff()   
            saveVar() 
          end
        elseif hrstart_time4 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time4 ON')
            logon4 = "1"
            statusto4 = "1"
            logofflineTimeon()   
            saveVar() 
          end
        elseif hrstart_time4 == rtcHr and minstart_time4 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time4 ON')
            logon4 = "1"
            statusto4 = "1"
            logofflineTimeon() 
            saveVar()
          end
        else
          gpio.write(BLUE_LED, 0)
        end 
      else 
        gpio.write(BLUE_LED, 0)
        timerstep = 1
      end
    end
  else
    print('Main Switch OFF')
    gpio.write(BLUE_LED, 0)
    count_off = 0
    count_on = 0
  end
end

local function uploadLogoffline()
  if statusto == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeon)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
 if statustf == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeoff)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
  if statusto2 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeon2)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
 if statustf2 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeoff2)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
  if statusto3 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeon3)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
 if statustf3 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeoff3)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
  if statusto4 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeon4)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
 if statustf4 == "1" then
   headers = {
     ["Content-Type"] = "application/x-www-form-urlencoded",
   }
   body = string.format('%s=%s-%s&%s=%s','fname',sw_name,rtcdate,'line',getlogTimeoff4)
   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
     function(code, data)
       if (code < 0) then
         print("HTTP request failed")
       else
         print(data)
       end
     end)
 end
 if statustf == "1" or statustf2 == "1" or statustf3 == "1" or statustf4 == "1"  then
  updatestatusOff()
  statustf = "0"
  statustf2 = "0"
  statustf3 = "0"
  statustf4 = "0"
  saveVar()
 end
 if statusto == "1" or statusto2 == "1" or statusto3 == "1" or statusto4 == "1" then
  updatestatusOn()
  statusto = "0"
  statusto2 = "0"
  statusto3 = "0"
  statusto4 = "0"
  saveVar()
  end
end

-- เขียน log online ตั้งเวลาเปิด
local function logonlineTimeon()
  if timerstep == 1 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer1 ON')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  elseif timerstep == 2 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer2 ON')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  elseif timerstep == 3 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer3 ON')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  elseif timerstep == 4 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer4 ON')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  end
end

-- เขียน log online ตั้งเวลาปิด
local function logonlineTimeoff()
  if timerstep == 1 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer4 OFF')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  elseif timerstep == 2 then
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer1 OFF')
  http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
  elseif timerstep == 3 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer2 OFF')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  elseif timerstep == 4 then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Timer3 OFF')
    http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  end
end

local function control()
  if value == "1" then
    print('Main Switch ON')
    if timerstep == 1 then
      if value_1 == "1" then
        print(string.format('%s - %s','timer1 start',start_time_1))
        print(string.format('%s - %s','timer1 end',end_time_1))
        if hrend_time1 < rtcHr then
          timerstep = 2
          if count_off < 2 then
            count_off = count_off + 1
          end
          gpio.write(BLUE_LED, 0)
          count_on = 0
          if count_off == 1 then
            print('Time1 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()
          end
        elseif hrend_time1 == rtcHr and minend_time1 <= rtcMin then
          timerstep = 2
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time1 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()
          end
        elseif hrstart_time1 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time1 ON')
            -- Log Online
            updatestatusOn()
            logonlineTimeon() 
          end   
        elseif hrstart_time1 == rtcHr and minstart_time1 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time1 ON')
            -- Log Online
            updatestatusOn()
            logonlineTimeon() 
          end   
        else 
          gpio.write(BLUE_LED, 0)
          updatestatusOff()
        end      
      else
        gpio.write(BLUE_LED, 0)
        updatestatusOff()
        timerstep = 2
      end    
    elseif timerstep == 2 then
      if value_2 == "1" then
        print(string.format('%s - %s','timer2 start',start_time_2))
        print(string.format('%s - %s','timer2 end',end_time_2))
        if hrend_time2 < rtcHr then
          timerstep = 3
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time2 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()  
          end 
        elseif hrend_time2 == rtcHr and minend_time2 <= rtcMin then
          timerstep = 3
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time2 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()  
          end 
        elseif hrstart_time2 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time2 ON')
            -- Log Online
            updatestatusOn()
            logonlineTimeon() 
          end
        elseif hrstart_time2 == rtcHr and minstart_time2 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time2 ON')
            -- Log Online
            updatestatusOn()
            logonlineTimeon() 
          end
        else 
          gpio.write(BLUE_LED, 0)
          updatestatusOff()
        end   
      else
        gpio.write(BLUE_LED, 0)
        updatestatusOff()
        timerstep = 3
      end    
    elseif timerstep == 3 then
      if value_3 == "1" then
        print(string.format('%s - %s','timer3 start',start_time_3))
        print(string.format('%s - %s','timer3 end',end_time_3))
        if hrend_time3 < rtcHr then
          timerstep = 4
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0        
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time3 OFF')
            -- Log Online
            logonlineTimeoff()   
            updatestatusOff()
          end
        elseif hrend_time3 == rtcHr and minend_time3 <= rtcMin then
          timerstep = 4   
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time3 OFF')
            -- Log Online
            logonlineTimeoff()
            updatestatusOff()
          end
        elseif hrstart_time3 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time3 ON')
            -- Log Online
            logonlineTimeon() 
            updatestatusOn()
          end
        elseif hrstart_time3 == rtcHr and minstart_time3 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          gpio.write(BLUE_LED, 1)
          count_off = 0
          if count_on == 1 then
            print('Time3 ON')
            -- Log Online
            logonlineTimeon() 
            updatestatusOn()
          end
        else
          gpio.write(BLUE_LED, 0)
          updatestatusOff()
        end    
      else
        gpio.write(BLUE_LED, 0)
        updatestatusOff()
        timerstep = 4
      end    
    elseif timerstep == 4 then
      if value_4 == "1" then
        print(string.format('%s - %s','timer4 start',start_time_4))
        print(string.format('%s - %s','timer4 end',end_time_4))
        if hrend_time4 < rtcHr then
          timerstep = 1
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time4 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()  
          end
        elseif hrend_time4 == rtcHr and minend_time4 <= rtcMin then
          timerstep = 1
          if count_off < 2 then
            count_off = count_off + 1
          end
          count_on = 0
          gpio.write(BLUE_LED, 0)
          if count_off == 1 then
            print('Time4 OFF')
            -- Log Online
            updatestatusOff()
            logonlineTimeoff()   
          end
        elseif hrstart_time4 < rtcHr then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time4 ON')
            -- Log Online
            logonlineTimeon() 
            updatestatusOn()
          end
        elseif hrstart_time4 == rtcHr and minstart_time4 <= rtcMin then
          if count_on < 2 then
            count_on = count_on + 1
          end
          count_off = 0
          gpio.write(BLUE_LED, 1)
          if count_on == 1 then
            print('Time4 ON')
            -- Log Online
            logonlineTimeon() 
            updatestatusOn()
          end
        else
          gpio.write(BLUE_LED, 0)
          updatestatusOff()
        end 
      else 
        gpio.write(BLUE_LED, 0)
        updatestatusOff()
        timerstep = 1
      end
    end
  else
    print('Main Switch OFF')
    gpio.write(BLUE_LED, 0)
    updatestatusOff()
    count_off = 0
    count_on = 0
  end
end

-- เขียน log online เปิด Switch
-- local function logonlineSwitchon()
--   headers = {
--     ["Content-Type"] = "application/x-www-form-urlencoded",
--   }
--   body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,dateStr,'line','Online',rtctime,'Switch ON')
--   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
--     function(code, data)
--       if (code < 0) then
--         print("HTTP request failed")
--       else
--         print(data)
--       end
--     end)
-- end

-- -- เขียน log online ปิด Switch
-- local function logonlineSwitchoff()
--   headers = {
--     ["Content-Type"] = "application/x-www-form-urlencoded",
--   }
--   body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,dateStr,'line','Online',rtctime,'Switch OFF')
--   http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
--     function(code, data)
--       if (code < 0) then
--         print("HTTP request failed")
--       else
--         print(data)
--       end
--     end)
-- end

-- การทำงานในสถานะ online
local function onlineControl()
  -- เชื่อมต่อ API
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s', 'name',sw_name)
  http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light2/readone.php'), { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
        offlineControl()
      else
        -- ถ้าต่อ API ได้
        uploadLogoffline()
        -- ถอดรหัสจาก API มาเก็บไว้ในตัวแปรเพื่อใช้ในการควบคุมหลอดไฟ
        t = sjson.decode(data)
        for k,v in pairs(t) do
          if k == "name" then
            name = v
          elseif k == "value" then
            value = v
          elseif k == "value_1" then
            value_1 = v
          elseif k == "value_2" then
            value_2 = v
          elseif k == "value_3" then
            value_3 = v
          elseif k == "value_4" then
            value_4 = v
          elseif k == "start_time_1" then
            start_time_1 = v
          elseif k == "end_time_1" then
            end_time_1 = v
          elseif k == "start_time_2" then
            start_time_2 = v
          elseif k == "end_time_2" then
            end_time_2 = v
          elseif k == "start_time_3" then
            start_time_3 = v
          elseif k == "end_time_3" then
            end_time_3 = v
          elseif k == "start_time_4" then
            start_time_4 = v
          elseif k == "end_time_4" then
            end_time_4 = v
          elseif k == "light_value" then
            light_value = value
          end
        end
        hrstart_time1 = tonumber(string.sub(start_time_1,1,-7))
        hrstart_time2 = tonumber(string.sub(start_time_2,1,-7))
        hrstart_time3 = tonumber(string.sub(start_time_3,1,-7))
        hrstart_time4 = tonumber(string.sub(start_time_4,1,-7))
        hrend_time1 = tonumber(string.sub(end_time_1,1,-7))
        hrend_time2 = tonumber(string.sub(end_time_2,1,-7))
        hrend_time3 = tonumber(string.sub(end_time_3,1,-7))
        hrend_time4 = tonumber(string.sub(end_time_4,1,-7))
        minstart_time1 = tonumber(string.sub(start_time_1,4,-4))
        minstart_time2 = tonumber(string.sub(start_time_2,4,-4))
        minstart_time3 = tonumber(string.sub(start_time_3,4,-4))
        minstart_time4 = tonumber(string.sub(start_time_4,4,-4))
        minend_time1 = tonumber(string.sub(end_time_1,4,-4))
        minend_time2 = tonumber(string.sub(end_time_2,4,-4))
        minend_time3 = tonumber(string.sub(end_time_3,4,-4))
        minend_time4 = tonumber(string.sub(end_time_4,4,-4))
        saveVar()
        control()
      end
    end)
end

-- อัพเดทเวลา
local function updateClock(_time)
  if netstat == "1" then
    print('Online')
    -- SNTP date/time
    -- hh:mm:ss
    timeStr = string.format('%02d:%02d:%02d', _time.hour, _time.min, _time.sec)
    -- DD.MM.YYYY
    dateStr = string.format('%02d-%02d-%02d', _time.day, _time.mon, _time.year-2000)
    -- RTC date/time
    getRtc()
    -- -- SNTP = RTC
    if timeStr == rtctime and dateStr == rtcdate then
      onlineControl()
    else
      -- Update RTC date/time
      i2c.start(id)
      i2c.address(id, device, i2c.TRANSMITTER)
      i2c.write(id, 0)
      i2c.write(id, tonumber(_time.sec+1,16))   -- seconds
      i2c.write(id, tonumber(_time.min,16))  -- minutes
      i2c.write(id, tonumber(_time.hour,16))  -- hours
      i2c.write(id, tonumber(_time.wday,16))   -- wday
      i2c.write(id, tonumber(_time.day,16))  -- day
      i2c.write(id, tonumber(_time.mon,16))  -- month
      i2c.write(id, tonumber(_time.year-2000,16))  -- year
      i2c.stop(id)
      print('Updated time',timeStr,rtctime)
    end
  end
end

wifi.mode(wifi.STATION)
wifi.sta.config({
    ssid  = 'ASEP Interface',
    pwd   = 'asep2020',
    auto  = false
})

-- loop การทำงาน Online
wifi.sta.on('got_ip', function()
  netstat = "1"
  checktime = "1"
  time.settimezone('GMT-7')
  time.initntp()
  mytimer = tmr.create()
  mytimer:register(1000, tmr.ALARM_AUTO, function() 
    updateClock(time.getlocal())
  end)
  mytimer:start()
end)

-- loop การทำงาน Offline
wifi.sta.on('disconnected', function()
  netstat = "0"
  if checktime == "1" then
    mytimer:stop()
    checktime = "0"
  end
  time.ntpstop()
  offlineControl()
end)

wifi.start()
wifi.sta.connect()