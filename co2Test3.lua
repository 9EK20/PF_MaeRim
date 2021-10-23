co2Av = 0
co2Max = 0
led = 2
count = 0
api = "capi"
local timeStr,dateStr

local function updateApi()
  headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded",
  }
  body = string.format('%s=%d', 'co2',co2Av)
  http.post(string.format('%s%s%s','http://209.58.180.39/',api,'/co2/update.php'), { headers = headers }, body,
    function(code, data)
      if (code < 0) then
        print("HTTP request failed")
      else
        print(data)
      end
    end)
  -- headers = {
  --   ["Content-Type"] = "application/x-www-form-urlencoded",
  -- }
  -- body = string.format('%s=%s-%s&%s=%s %d %s','fname','co2Log',dateStr,'line',timeStr,co2Max,'ppm')
  -- http.post("http://209.58.180.39/log/line.php", { headers = headers }, body,
  --   function(code, data)
  --     if (code < 0) then
  --       print("HTTP request failed")
  --     else
  --       print(data)
  --     end
  --   end)    
end

local function updateCo2()
  v = adc.read(adc.ADC1, 0) * (3.3 / 4095)
  v = (v - 3.3) * -1
  co2 = v * 2500
  print(co2)
  if co2Max < co2 then
    co2Max = co2
  elseif co2 == 0 then
    if co2Max >= 250 then
      if count < 21 then
       co2Av = co2Av + co2Max
       count = count + 1
       print(co2Av)
      end
      if count == 21 then
        co2Av = co2Av / 5
        updateApi()
        print(string.format('%s : %d %s','ค่าเฉลี่ย Co2',co2Av,'ppm'))
        count = 0
      end
    end
    co2Max = 0
  end
end

local function updateClock(_time)
    timeStr = string.format('%02d:%02d:%02d', _time.hour, _time.min, _time.sec)
    dateStr = string.format('%02d-%02d-%02d', _time.day, _time.mon, _time.year-2000)
    updateCo2()
end

wifi.mode(wifi.STATION)
wifi.sta.config({
    ssid  = 'ASEP Interface',
    pwd   = 'asep2020',
    auto  = false
})

-- loop การทำงาน Online
wifi.sta.on('got_ip', function()
  time.settimezone('GMT-7')
  time.initntp()
  mytimer = tmr.create()
  mytimer:register(1000, tmr.ALARM_AUTO, function() 
    updateClock(time.getlocal())
  end)
  mytimer:start()
end)

wifi.start()
wifi.sta.connect()
