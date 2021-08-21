local BLUE_LED = 2
local fan = 27
local humidifier = 26

local function getHmax()
     fd = file.open("maxSetpoint.txt", "r")
     if fd then
          max = fd:read(2)
          fd:close(); fd = nil
     end
     return max
end

local function getHmin()
     fd = file.open("minSetpoint.txt", "r")
     if fd then
          min = fd:read(2)
          fd:close(); fd = nil
     end
     return min
end




gpio.config({ gpio = BLUE_LED, dir = gpio.IN_OUT })
gpio.config({ gpio = fan, dir = gpio.OUT })
gpio.config({ gpio = humidifier, dir = gpio.OUT })
gpio.write(BLUE_LED, 0)

local client = mqtt.Client('humidifier', 120)

client:on('connect', function() print('connected') end)
client:on('offline', function() print('offline') end)

client:on('message', function(_, topic, data)
    print(topic, ':', data)

    if topic == 'fan' then
        if data == 'ON' then
            gpio.write(fan, 1)
        elseif data == 'OFF' then
            gpio.write(fan, 0)
        end
    end

    if topic == 'sensor/humidity' then
          hmax = tonumber(getHmax())
          hmin = tonumber(getHmin())
          DATA = tonumber(data)
          print('data : '.. data)
          print('hmax :'.. hmax)
          print('hmin :'.. hmin)
          
          if DATA > hmax then
               gpio.write(fan, 0)
               gpio.write(humidifier, 0)
          elseif DATA < hmin then
               gpio.write(fan, 1)
               gpio.write(humidifier, 1)
          end

     end

     if topic == 'humi_max_setpoint' then
          if file.open("maxSetpoint.txt","w+") then
               file.writeline(data)
               file.close()
          end
     end

     if topic == 'humi_min_setpoint' then
          if file.open("minSetpoint.txt","w+") then
               file.writeline(data)
               file.close()
          end
     end

end)

local function getHmax()
     fd = file.open("maxSetpoint.txt", "r")
     if fd then
          max = fd:read(2)
          fd:close(); fd = nil
          print('hmax : ' .. hmax)
     end
     return max
end

local function getHmin()
     fd = file.open("minSetpoint.txt", "r")
     if fd then
          min = fd:read(2)
          fd:close(); fd = nil
          print('hmin : ' .. hmin)
     end
     return min
end


function connect()
    client:connect('135.181.248.74', 1883, 0, function()
        print('connected')

          client:subscribe('fan', 0, function()
            print('subscribed Fan')
          end)

          client:subscribe('humi_max_setpoint', 0)
          client:subscribe('humi_min_setpoint', 0)
          client:subscribe('sensor/humidity', 0)
    end,
    function(_, reason)
        print('failed', reason)
    end)
end

wifi.mode(wifi.STATION)

wifi.sta.config({
    ssid  = 'ASEP Interface',
    pwd   = 'asep2020',
    auto  = false
})

wifi.sta.on('got_ip', connect)

wifi.start()
wifi.sta.connect()
