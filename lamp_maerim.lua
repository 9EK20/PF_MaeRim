local BLUE_LED = 2

gpio.config({ gpio = BLUE_LED, dir = gpio.IN_OUT })
gpio.write(BLUE_LED, 0)

local client = mqtt.Client('clientx', 120)

client:on('connect', function() print('connected') end)
client:on('offline', function() print('offline') end)

client:on('message', function(_, topic, data)
    print(topic, ':', data)

    if topic == 'Device/Lamp11' then
        if data == 'ON' then
            gpio.write(BLUE_LED, 1)
        elseif data == 'OFF' then
            gpio.write(BLUE_LED, 0)
        end
    end
end)

function connect()
    client:connect('135.181.248.74', 1883, 0, function()
        print('connected')

        client:subscribe('Device/Lamp11', 0, function()
            print('subscribe success')
        end)
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
