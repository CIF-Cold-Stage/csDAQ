using Gtk
using GtkReactive
using InspectDR
using Reactive
using Colors
using DataFrames    
using Printf
using Dates
using CSV
using FileIO    
using LibSerialPort
using Interpolations
using Statistics
using ImageView
using Images
using TETechTC3625RS232
using IDS_peak

(@isdefined wnd) && destroy(wnd)
gui = GtkBuilder(filename=pwd()*"/gui.glade")  # Load GUI

cvs = gui["Image"]
wnd = gui["mainWindow"]
c = canvas(UserUnit)
push!(cvs, c)

serialPort = get_gtk_property(gui["TESerialPort1"], "text", String)
(@isdefined portTE1) || (portTE1 = TETechTC3625RS232.configure_port("COM3"))
TETechTC3625RS232.turn_power_off(portTE1)

include("global_variables.jl")        # Reactive Signals and global variables
include("te_io.jl")                   # Thermoelectric Signals (wavefrom)
include("gtk_graphs.jl")              # push graphs to the UI#
include("setup_graphs.jl")            # Initialize graphs 
include("daq_loops.jl")               # Contains DAQ loops               
include("gtk_callbacks.jl")           # Link gui to signals               

Gtk.showall(wnd)                      # Show GUI

# Generate signals
sampleHz = fps(0.5*1.0015272)                # Sample frequency
main_elapsed_time = foldp(+, 0.0, sampleHz)  # Main timer
TE1_elapsed_time = foldp(+, 0.0, sampleHz)   # Time since last state change
TE1setT, TE1reset = TE1_signals()            # Signal for setpoint Temperature

# Instantiate parallel  1 Hz Loops and start 10 Hz loop
function main()
    @async sampleHz_data_file()         # Write data file
    @async sampleHz_generic_loop()      # Generic DAQ 
    @async sampleHz_disp_image()      # Generic DAQ 
end
    
MainLoop = map(_ -> main(), sampleHz)   # Run Master Loop

IDS_peak.initialize_camera()
IDS_peak.open_camera()
IDS_peak.prepare_acquisition()
IDS_peak.alloc_and_announce_buffers()
IDS_peak.start_acquisition(2)

const currentImage1 = Signal(IDS_peak.acquire_image())

a = true
@async while a == true
    push!(currentImage1, IDS_peak.acquire_image());
    sleep(0.5)
end  

imgsig = map(currentImage1) do r
	img =IDS_peak.image_preview(currentImage1.value)
    view(img, 1:973, 1:1297)
end

redraw = draw(c, imgsig) do cnvs, image
    copy!(cnvs, image)
end


println("Events: ")
push!(updatePower,true)
sleep(1)
push!(updateBandwidth,true)
sleep(1)
push!(updateIntegral, true) 
sleep(1)
push!(updateDerivative, true) 
sleep(1)
push!(updateThermistor, true) 
sleep(1)
push!(updatePolarity, true) 


#IDS_peak.close()
