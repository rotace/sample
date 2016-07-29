# view structure mode

#List = ['1080']
List = [ '1064','1280','1416','1464', '1632', '1920' ]# view list (freqency)
head = '/home/usr/HF_WBM/shibata/fairing/1.1-kaneda_data/fairing_inner/output/'

for freq in List :
	infile = head + 'structure_result' + freq + '.vtk'
	osr = head + 'paraview/structure_mode_' + freq + '_side_real.png' 
	osi = head + 'paraview/structure_mode_' + freq + '_side_imag.png'
	otr = head + 'paraview/structure_mode_' + freq + '_top_real.png'
	oti = head + 'paraview/structure_mode_' + freq + '_top_imag.png'

#	print infile
#	print osr # output side-real-image
#	print osi # output side-imag-image
#	print otr # output top-real-image
#	print oti # output top-imag-image



	try: paraview.simple
	except: from paraview.simple import *
	paraview.simple._DisableFirstRenderCameraReset()

# read file
	structure_result_vtk = LegacyVTKReader( FileNames=[infile] )

	rend = GetRenderView()	# RenderView
	rep1 = Show()			# DataRepresentation1
	rep1.Visibility = 0		# non-visible

# translate by displace
	WarpByVector1 = WarpByVector()
	WarpByVector1.ScaleFactor = 50000000.0
	rep2 = Show()		# DataRepresentation2

# Text
	text = Text()
	text.Text = freq + 'Hz'
	reptext = Show()			# DataRepresentation
	reptext.Color = [0,0,0]


# camera position (side)
	rend.CameraPosition = [0.715747870105369, -0.9218864561336879, 	0.582734782105062]
	rend.CameraViewUp = [-0.19343938567441715, 0.24264892259689158, 	0.9506327915827815]
	rend.CameraFocalPoint = [-2.571016725522367e-17, -1.0375888928000981e-16, 0.2017794996500017]
	rend.CameraClippingRange = [0.8174407860181988, 1.7471385013118947]
	rend.CameraParallelScale = 0.32213729749592374
	rend.InteractionMode = '3D'

# translate by displace real
	WarpByVector1.Vectors = ['POINTS', 'displace_real']

	# color range
	rep2.ColorArrayName = ('POINT_DATA', 'displace_real')
	datarange = rep2.Input.PointData[rep2.ColorArrayName].GetRange()
	rep2.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write real-side image
	Render()
	WriteImage(osr)

# translate by displace imag
	WarpByVector1.Vectors = ['POINTS', 'displace_imag']

	# color range
	rep2.ColorArrayName = ('POINT_DATA', 'displace_imag')
	datarange = rep2.Input.PointData[rep2.ColorArrayName].GetRange()
	rep2.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write real-side image
	Render()
	WriteImage(osi)



# camera position (top)
	rend.CameraViewUp = [0.0, 1.0, 0.0]
	rend.CameraPosition = [0.04843880981206894, -6.556510925292969e-07, 1.5609742498280499]
	rend.CameraClippingRange = [0.9410246645334437, 1.8865587849736336]
	rend.CameraFocalPoint = [0.04843880981206894, -6.556510925292969e-07, 0.20279860496520996]
	rend.CameraParallelScale = 0.35636709150272083
	rend.CenterOfRotation = [0.04843880981206894, -6.556510925292969e-07, 0.20279860496520996]
	rend.InteractionMode = '2D'


# translate by displace real
	WarpByVector1.Vectors = ['POINTS', 'displace_real']

	# color range
	rep2.ColorArrayName = ('POINT_DATA', 'displace_real')
	datarange = rep2.Input.PointData[rep2.ColorArrayName].GetRange()
	rep2.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write real-side image
	Render()
	WriteImage(otr)

# translate by displace imag
	WarpByVector1.Vectors = ['POINTS', 'displace_imag']

	# color range
	rep2.ColorArrayName = ('POINT_DATA', 'displace_imag')
	datarange = rep2.Input.PointData[rep2.ColorArrayName].GetRange()
	rep2.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write real-side image
	Render()
	WriteImage(oti)


# delete
	Delete(text)
	Delete(WarpByVector1)
	Delete(structure_result_vtk)
	Render()

	print "+++++" + freq + " end  +++++"

print "End-script"
