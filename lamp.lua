local id, sda, scl, device = 0, 26, 27, 0x68
local BLUE_LED = 2
local name,value,start_time,end_time,timeStr,dateStr,rtctime,rtcdate,getlogTimeon,getlogTimeoff
local netstat = "0"
local status = "0"
local statustf = "0"
local checktime = "0"
local count_on = 0
local count_off = 0
local sw_name = "shelf_1_3"
local api = "capi"
gpio.config({ gpio = BLUE_LED, dir = gpio.IN_OUT })
gpio.write(BLUE_LED, 0)
i2c.setup(id, sda, scl, i2c.SLOW)

-- -- เขียน log รั���ไฟล์จ��ก server
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

-- -- เข��ยน log เมื่อได���ร���บคำสั่ง restart จา�� server
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

-- -- รอร���บคำสั่ง getFile จาก server
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
--         node.restart()
-- local function getRestart()
--   http.get("http://209.58.180.39/code/reset.php", function(code, data)
--     if (code < 0) then
--       print("HTTP request failed")
--     else
--       if data == "1" then
--         logRestart()
--       end
--     end
--   end)
-- end

-- อัพเดท value หลังจากกลับมา online
local function updateStatus()
   if status == "1" then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s&%s=%s', 'name',sw_name,'value',value)
    http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light/updateone.php'), { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
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
      status = "0"
  end
  if statustf == "1" then
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s&%s=%s', 'name',sw_name,'value',value)
    http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light/updateone.php'), { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
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
      statustf = "0"
  end
end

-- บั���ทึกค่��ตัวแปรไว้ในไฟล์ txt
local function saveVar()
  if file.open("start_time.txt","w+") then
    file.writeline(start_time)
    file.close()
  end
  if file.open("end_time.txt","w+") then
    file.writeline(end_time)
    file.close()
  end
  if file.open("value.txt","w+") then
    file.writeline(value)
    file.close()
  end
  if file.open("status.txt","w+") then
    file.writeline(status)
    file.close()
  end
  if file.open("statustf.txt","w+") then
    file.writeline(statustf)
    file.close()
  end
end

-- รั��ค่าจากไฟล์ txt
local function getVar()
  fd = file.open("start_time.txt", "r")
  if fd then
    start_time = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("end_time.txt", "r")
  if fd then
    end_time = fd:read(8)
    fd:close(); fd = nil
  end
  fd = file.open("value.txt", "r")
  if fd then
    value = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("status.txt", "r")
  if fd then
    status = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("statustf.txt", "r")
  if fd then
    statustf = fd:read(1)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeon.txt", "r")
  if fd then
    getlogTimeon = fd:read(33)
    fd:close(); fd = nil
  end
  fd = file.open("logoffline-timeoff.txt", "r")
  if fd then
    getlogTimeoff = fd:read(34)
    fd:close(); fd = nil
  end
end

-- รับค่าเวลาจาก module RTC
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
end

-- เขียน log offline ตอ��ตั้งเวลาเปิด
local function logoffline_Timeon()
  if file.open(string.format('%s.%s','logoffline-timeon','txt'), "w+") then
    file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Time ON'))
    file.close()
    print('write file')
  end
end

-- เขียน log offline ตอนต��้งเวลาปิด
local function logoffline_Timeoff()
  if file.open(string.format('%s.%s','logoffline-timeoff','txt'), "w+") then
    file.writeline(string.format('%s %s %s %s','Offline',rtcdate,rtctime,'Time OFF'))
    file.close()
    print('write file')
  end
end

-- ตั้งค่าก���รทำงานหลังจากส��านะ offline
local function offline_Control()
  print('Offline')
  getRtc()
  getVar()
  print(rtctime, start_time, end_time)
  if value == "0" and start_time == rtctime then
    print('Time ON')
    gpio.write(BLUE_LED, 1)
    value = "1"
    status = "1"
    saveVar()
    -- เขียน log
    logoffline_Timeon()
  elseif value == "1" and end_time == rtctime then
    print('Time OFF')
    gpio.write(BLUE_LED, 0)
    value = "0"
    statustf = "1"
    saveVar()
    -- เ��ี��น log
    logoffline_Timeoff()
  end
end

-- เขียน log online ตั้งเวลาเปิด
local function logonline_Timeon()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Time ON')
  http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

-- เขียน log online ตั้งเวลาปิด
local function logonline_Timeoff()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Time OFF')
  http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

-- เขียน log online เปิด Switch
local function logonline_Swon()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Switch ON')
  http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

-- เขียน log online ปิด Switch
local function logonline_Swoff()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s-%s&%s=%s %s %s','fname',sw_name,rtcdate,'line','Online',rtctime,'Switch OFF')
  http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
end

-- การทำงานใน���ถานะ online
local function online_Control()
  -- เชื่อมต่อ API
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%s', 'name',sw_name)
  http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light/readone.php'), { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
        offline_Control()
      else
        -- ถ้าต่อ API
        -- getFile()
        -- getRestart()
        getVar()
        updateStatus()
        -- ถอดร���ัสจาก API มาเก็บไว้ในตัวแปรเพื่อใ���้ในการควบคุมหลอดไฟ
        t = sjson.decode(data)
        for k,v in pairs(t) do
          if k == "name" then
            name = v
          elseif k == "value" then
            value = v
          elseif k == "start_time" then
            start_time = v
          elseif k == "end_time" then
            end_time = v
          end
        end
        saveVar()
        -- Online Control
        if value == "0" and start_time == rtctime then
          count_on = count_on + 1
          print('Time ON')
          gpio.write(BLUE_LED, 1)
          -- Update API
          headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
          }
          body = string.format('%s=%s&%s', 'name',sw_name,'value=1')
          http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light/updateone.php'), { headers = headers }, body,
            function(code, data)
              if (code < 0) then
                print("HTTP request failed")
              else
                print(data)
              end
            end)
          -- Log Online
            logonline_Timeon()
        -- Online Control                    
        elseif value == "1" and end_time == rtctime then
          count_off = count_off + 1
          print('Time OFF')
          gpio.write(BLUE_LED, 0)
          -- Update API
          headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
          }
          body = string.format('%s=%s&%s', 'name',sw_name,'value=0')
          http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/light/updateone.php'), { headers = headers }, body,
            function(code, data)
              if (code < 0) then
                print("HTTP request failed")
              else
                print(data)
              end
            end)
          -- Log Online
            logonline_Timeoff()
        -- Online Control
        elseif value == "1" then
          count_off = 0
          count_on = count_on + 1
          if count_on == 1 then
            print('Switch ON')
            gpio.write(BLUE_LED, 1)
            -- Log Online
            logonline_Swon()
          end
        -- Online Control
        elseif value == "0" then
          count_on = 0
          count_off = count_off + 1
          if count_off == 1 then
            print('Switch OFF')
            gpio.write(BLUE_LED, 0)
            -- Log Online
            logonline_Swoff()
          end
        end
      end
    end)
end

-- อัพ���ดทเวลา
local function updateClock(_time)
  if netstat == "1" then
    print('Online')
    print(timeStr, start_time, end_time)
    -- SNTP date/time
    -- hh:mm:ss
    timeStr = string.format('%02d:%02d:%02d', _time.hour, _time.min, _time.sec)
    -- DD.MM.YYYY
    dateStr = string.format('%02d-%02d-%02d', _time.day, _time.mon, _time.year-2000)
    -- RTC date/time
    getRtc()
    -- SNTP = RTC
    if timeStr == rtctime and dateStr == rtcdate then
      online_Control()
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
    ssid  = 'Polarbear_2.4G',
    pwd   = 'chinabear',
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
  offline_Control()
end)

wifi.start()
wifi.sta.connect(
