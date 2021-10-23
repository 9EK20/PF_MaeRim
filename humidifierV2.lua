--[humidifierV2.lua]
--initial variable
-- require('include')
local ssid = 'ASEP Interface'
local password = 'asep2020'
local apiHostname = 'http://209.58.180.39/capi/setting/readone.php'
local status, temp, humi, temp_dec, humi_dec
setpoint = 0

--initial port and pin
local BLUE_LED = 2
local humidifier = 26
local fan = 27
local pin = 4
gpio.config({gpio={BLUE_LED, humidifier, fan}, dir=gpio.OUT })
--gpio.write(BLUE_LED, 0)
gpio.write(humidifier, 0)
gpio.write(fan, 0)

local function readSetpoint()
    fd = file.open("Setpoint.txt", "r")
    if fd then
         sp = fd:read(2)
         fd:close(); fd = nil
    end
    return tonumber(sp)
end

local function saveSetpoint(hdata)
    if (tonumber(hdata) > 0) and (tonumber(hdata) ~= readSetpoint()) then
        file.open("Setpoint.txt","w+")
        file.writeline(hdata)
        file.close()
    end
end

local function getSetpoint()
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
    }

    body = 'name=humidity'
    http.post(apiHostname, { headers = headers }, body,
    function(code, data)
        if (code < 0) then
        print("HTTP request failed")
        else
        -- print(code, data)
        t = sjson.decode(data)
        for k,v in pairs(t) do
            if k == 'value' then
                -- print('get value ='..v)
                -- setpoint = v
                saveSetpoint(v)
            end
        end
        end
    end)  
end



local function readHumidity()
    status, temp, humi, temp_dec, humi_dec = dht.read2x(pin)
    if status == dht.OK then
        -- Integer firmware using this example
        print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
            math.floor(temp),
            temp_dec,
            math.floor(humi),
            humi_dec
        ))

        -- Float firmware using this example
        print("DHT Temperature:"..temp..";".."Humidity:"..humi)

    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
        humi = mySetpoint
    end
end

local function updateHumidity()
    headers = {
      ["Content-Type"] = "application/x-www-form-urlencoded",
    }
    body = string.format('%s=%s', 'rh',tostring(humi))
    http.post('http://209.58.180.39/capi/moisture/create.php', { headers = headers }, body,
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print(data)
        end
      end)
  end

--Connect WiFi
wifi.mode(wifi.STATION)

wifi.sta.config({
    ssid = ssid,
    pwd  = password,
    auto = false
})

wifi.start()
-- wifi.sta.connect()
wifi.sta.on('got_ip', function()
    print('WiFi connected')
    gpio.write(BLUE_LED, 1)
end)

local timer0 = tmr.create()
local timer1 = tmr.create()
-- Register auto-repeating 1000 ms (1 sec) timer
timer0:register(10000, tmr.ALARM_AUTO, function()
    getSetpoint()
end)

timer1:register(10000, tmr.ALARM_AUTO, function()
    mySetpoint = readSetpoint()
    readHumidity()
    updateHumidity()
    print('mysetpoint = '..mySetpoint)
    if humi < (mySetpoint) then
        gpio.write(fan, 1)
        gpio.write(humidifier, 1)
    elseif humi > (mySetpoint + 1) then
        gpio.write(fan, 0)
        gpio.write(humidifier, 0)
    end
end)

-- Start timer
timer0:start()
timer1:start()
