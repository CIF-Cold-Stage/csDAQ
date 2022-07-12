
function graph1(yaxis)
	plot = InspectDR.transientplot(yaxis, title="")
	InspectDR.overwritefont!(plot.layout, fontname="Sans", fontscale=1.0)
	plot.layout[:enable_legend] = true
	plot.layout[:halloc_legend] = 160
	plot.layout[:halloc_left] = 50
	plot.layout[:enable_timestamp] = false
	plot.layout[:length_tickmajor] = 10
	plot.layout[:length_tickminor] = 6
	plot.layout[:format_xtick] = InspectDR.TickLabelStyle(UEXPONENT)
	plot.layout[:frame_data] =  InspectDR.AreaAttributes(
         line=InspectDR.line(style=:solid, color=black, width=0.5))
	plot.layout[:line_gridmajor] = InspectDR.LineStyle(:solid, Float64(0.75), 
													   RGBA(0, 0, 0, 1))

	plot.xext = InspectDR.PExtents1D()
	plot.xext_full = InspectDR.PExtents1D(0, 205)

	a = plot.annotation
	a.xlabel = "Time (s)"
	a.ylabels = ["Temperature (C)"]

	return plot
end

function graph2(yaxis)
	plot = InspectDR.transientplot(yaxis, title="")
	InspectDR.overwritefont!(plot.layout, fontname="Sans", fontscale=1.0)
	plot.layout[:enable_legend] = false
	plot.layout[:enable_timestamp] = true
	plot.layout[:length_tickmajor] = 10
	plot.layout[:length_tickminor] = 6
	plot.layout[:format_xtick] = InspectDR.TickLabelStyle(UEXPONENT)
	plot.layout[:frame_data] =  InspectDR.AreaAttributes(
         line=InspectDR.line(style=:solid, color=black, width=0.5))
	plot.layout[:line_gridmajor] = InspectDR.LineStyle(:solid, Float64(0.75), 
													   RGBA(0, 0, 0, 1))

	plot.xext = InspectDR.PExtents1D()
	plot.xext_full = InspectDR.PExtents1D(0, 1000)

	a = plot.annotation
	a.xlabel = "Time (ms)"
	a.ylabels = ["Amplitude (V)"]

	return plot
end

style = :solid 
plotTemp = graph1(:lin)
plotTemp.layout[:halloc_legend] = 110
mpTemp,gplotTemp = push_plot_to_gui!(plotTemp, gui["TempGraph1"], wnd)
wfrm = add(plotTemp, [0.0], [22.0], id="Set T(°C)")
wfrm.line = line(color=black, width=2, style=style)
wfrm = add(plotTemp, [0.0], [22.0], id="T1 (°C)")
wfrm.line = line(color=mblue, width=2, style=style)
wfrm = add(plotTemp, [0.0], [22.0], id="T2 (°C)")
wfrm.line = line(color=red, width=2, style=style)