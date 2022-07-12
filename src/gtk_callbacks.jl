te1Mode = gui["TE1Mode"]
signal_connect(te1Mode, "changed") do widget, others...
	push!(stateTE1,get_gtk_property(te1Mode, "active-id", String) |> Symbol)
    println(stateTE1.value)
    if stateTE1.value == :Ramp
        str1 = Dates.format(now(), "yyyymmddTHHMMSS")
        str2 = get_gtk_property(gui["Experiment"], :text, String)
        base = "C:\\Users\\shd-analy-2\\Documents\\Data\\CS Daq\\"    
        push!(currentSavePath, base*str1*"_"*str2*"\\")
        mkpath(base*str1*"_"*str2*"\\")
    end
end 

updatePower = Signal(false)
te1Power = gui["power"]
signal_connect(te1Power, "state-set") do widget, others...
    push!(updatePower, true)
end

updateBandwidth = Signal(false)
te1Proportional = gui["proportional"]
signal_connect(te1Proportional, "changed") do widget, others...
    push!(updateBandwidth, true)
end

updateIntegral = Signal(false)
te1Integral = gui["integral"]
signal_connect(te1Integral, "changed") do widget, others...
    push!(updateIntegral, true)
end

updateDerivative = Signal(false)
te1Derivative = gui["derivative"]
signal_connect(te1Derivative, "changed") do widget, others...
    push!(updateDerivative, true)
end

updateThermistor = Signal(false)
te1Thermistor = gui["thermistor"]
signal_connect(te1Thermistor, "changed") do widget, others...
    push!(updateThermistor, true)
end

updatePolarity = Signal(false)
te1Polarity = gui["polarity"]
signal_connect(te1Polarity, "changed") do widget, others...
    push!(updatePolarity, true)
end

Godot = @task _->false
id = signal_connect(x->schedule(Godot), gui["closeButton"], "clicked")
Godot = @task _->false
