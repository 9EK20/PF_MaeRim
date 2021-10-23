uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, {tx = 1, rx = 3})
local mytimer = tmr.create()
mytimer = tmr.create()
mytimer:register(1000, tmr.ALARM_AUTO, function() 
-- when 4 chars is received.
uart.on("data", 4,
  function(data)
    print("receive from uart:", data)
    if data=="quit" then
      uart.on("data") -- unregister callback function
    end
end, 0)
-- when '\r' is received.
uart.on("data", "\r",
  function(data)
    print("receive from uart:", data)
    if data=="quit\r" then
      uart.on("data") -- unregister callback function
    end
end, 0)

-- uart 2
uart.on(2, "data", "\r",
  function(data)
    print("receive from uart:", data)
  end)

-- error handler
uart.on(2, "error",
  function(data)
    print("error from uart:", data)
  end)
end)
mytimer:start()
