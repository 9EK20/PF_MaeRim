local function init_ws()
    require('ws32_client')
    .on('receive', function(data, ws)
        print('WS received: ', data)
    end)
    .on('connection', function(ws)
        print('WS connected')

        local timer = tmr.create()

        timer:register(2000, tmr.ALARM_AUTO, function(t)
            ws.send('Hello!')
        end)

        timer:start()
    end)
    .connect('http://209.58.180.39/capi/moisture/readone.php')
end

wifi.mode(wifi.STATION)

wifi.sta.config({
    ssid = "AIS 4G Hi-Speed Home WiFi_166250",
    pwd  = "50166250",
    auto = false
})

wifi.sta.on('got_ip', init_ws)

wifi.start()
wifi.sta.connect()
