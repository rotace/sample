# view acoustic mode

# view list(acoustic mode + structure mode) (freqency)
#List = ['528']
List = ['528','952','1008','1064','1224','1328','1584','1616',\
'1696','1760','1824','1968','2088','2104','2136','2248',\
'2288','2312','2408','2480','2496']
#List = [ '528','952','1032','1216','1336','1584','1672','1768','1816',\
#'1976','2096','2112','2144','2256','2296','2320','2416','2496',\
#'1080','1424','1464','1632','1920','2184']
head = '/home/usr/HF_WBM/shibata/fairing/1.1-kaneda_data/fairing_inner/output/'

for freq in List :
	infile = head + 'inner_result' + freq + '.vtk'
	osr = head + 'paraview/acoustic_mode_' + freq + '_side_real.png' 
	osi = head + 'paraview/acoustic_mode_' + freq + '_side_imag.png'
#	otr = head + 'paraview/acoustic_mode_' + freq + '_top_real.png'
#	oti = head + 'paraview/acoustic_mode_' + freq + '_top_imag.png'

#	print infile
#	print osr # output side-real-image
#	print osi # output side-imag-image
#	print otr # output top-real-image
#	print oti # output top-imag-image


	try: paraview.simple
	except: from paraview.simple import *
	paraview.simple._DisableFirstRenderCameraReset()


# input
	inner_result_vtk = LegacyVTKReader( FileNames=[infile] )

	rend = GetRenderView() 		# RenderView
	rep = Show() 				# DataRepresentation

# Text
	text = Text()
	text.Text = freq + 'Hz'
	reptext = Show()			# DataRepresentation
	reptext.Color = [0,0,0]


#### camera set (side)
	rend.CameraViewUp = [-0.2610402165326639, 0.3151207364219328, 0.9124455747218454]
	rend.CameraPosition = [0.7016788768538017, -0.8505241268438334, 0.6944779287277533]
	rend.CameraClippingRange = [0.7778488897088819, 1.753310828718753]
	rend.CameraFocalPoint = [-2.9669004104002803e-18, -1.5964749827391983e-17, 0.20000000298023204]


#### pressure real
	# input real
	rep.ScalarOpacityFunction = []
	rep.ColorArrayName = ('POINT_DATA', 'pressure_real')

	# color range
	datarange = rep.Input.PointData[rep.ColorArrayName].GetRange()
	rep.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write pressure-real
	Render()
	WriteImage(osr)

#### pressure imag
	# input imag
	rep.ScalarOpacityFunction = []
	rep.ColorArrayName = ('POINT_DATA', 'pressure_imag')

	# color range
	datarange = rep.Input.PointData[rep.ColorArrayName].GetRange()
	rep.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write pressure-imag
	Render()
	WriteImage(osi)


#### delete
	Delete(text)
	Delete(inner_result_vtk)
	Render()


	print "+++++" + freq + " end  +++++"

print "End-script"
