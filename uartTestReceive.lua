uart.setup(2, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, {tx = 16, rx = 17})
uart.on(2, "data", "\r",
  function(data)
    print("receive from uart:", data)
  end)


  timer0:register(10000, tmr.ALARM_AUTO, function()
    
    
end)