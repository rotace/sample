proj ='Eva2_3'
freqs=1500
freqe=4500+1
freqd=500

import os
import sys

# iteration
List =range(freqs, freqe, freqd)
# if you sellect the sets of freqencies, you have to use below.
# List = ['2288','2312','2408','2480','2496']

# abs_path
current_path = os.path.abspath(os.path.basename('paraview_python'))
parent_path = os.path.abspath(os.path.dirname('paraview_python'))
import_path = parent_path
export_path = current_path

for freq in List :
    inhead = import_path + '/' + proj + '_' +str(freq) + '.0000_'
    exhead = export_path + '/' + proj + '_' +str(freq) + '.0000_'
    infile = inhead + '000acousticmesh.vtk'
    


    # initialize
    try: paraview.simple
    except: from paraview.simple import *
    paraview.simple._DisableFirstRenderCameraReset()


    # rendering
    rend = GetRenderView()      # RenderView
    rend.InteractionMode= '2D'
    rend.Background=[1.0, 1.0, 1.0]
    rend.OrientationAxesLabelColor = [0.0, 0.0, 0.0]

    # text information
    text = Text()
    text.Text = str(freq) + 'Hz'
    rep_text = Show()            # DataRepresentation
    rep_text.Color = [0,0,0]

    # import mesh
    result = LegacyVTKReader( FileNames=[infile] )
    rep_mesh = Show()                # DataRepresentation

    # bounding box and range
    SetActiveSource(result)
    outline = Outline()

    # rep
    rep_outline = Show()
    rep_outline.ScaleFactor = 0.1
    rep_outline.EdgeColor = [0.0, 0.0, 0.0]
    rep_outline.DiffuseColor = [0.0, 0.0, 0.0] # outline color
    rep_outline.CubeAxesColor = [0.0, 0.0, 0.0] # cube axes color
    rep_outline.CustomRange = [0.0, 0.5, 0.0, 0.2, 0.0, 0.2]
    rep_outline.CustomBounds = [0.0, 0.5, 0.0, 0.2, 0.0, 0.2]
    rep_outline.CubeAxesVisibility = 1


    
    


#### preal-top    
    # camera set (if you want to set the camera potision)
    rend.CameraViewUp = [0.0, 0.0, 1.0]
    rend.CameraPosition = [-0.8, 0.09, 0.1]
    rend.CameraFocalPoint = [0.2, 0.09,0.1]
    rend.CameraClippingRange = [0.6, 1.7]
    rend.CameraParallelScale = 0.2 # 2D

    # rep
    rep_mesh.ColorArrayName = ('POINT_DATA', 'pressure_real')
    
    # color range (auto range)
    datarange = rep_mesh.Input.PointData[rep_mesh.ColorArrayName].GetRange()
    rep_mesh.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])
    
    # write image
    Render()
    exfile = exhead + 'preal-top_view.png'
    WriteImage(exfile)




    
#### stream-top
    rep_mesh.Visibility = 0          # non-visible
    
    # stream tracer
    SetActiveSource(result)
    streamtracer = StreamTracer( SeedType = "Point Source" )
    streamtracer.SeedType = "Point Source"
    streamtracer.SeedType.Radius = 0.1
    streamtracer.SeedType.Center = [0.0, 0.1, 0.1]
    streamtracer.Vectors = ['POINTS', 'intensity']
    streamtracer.MaximumStreamlineLength = 0.5

    # toggle the 3D widget visibility
    active_objects.source.SMProxy.InvokeEvent('UserEvent', 'ShowWidget')
    
    # rep
    rep_stream = Show()
    rep_stream.EdgeColor = [0.0, 0.0, 0.5]
    rep_stream.SelectionPointFieldDataArrayName = 'intensity'
    rep_stream.SelectionCellFieldDataArrayName = 'ReasonForTermination'
    rep_stream.ColorArrayName =  ('POINT_DATA', 'intensity')
    rep_stream.ScaleFactor = 0.05
    
    # color range (auto range)
    datarange = rep_stream.Input.PointData[rep_stream.ColorArrayName].GetRange()
    rep_stream.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

    # write image
    Render()
    exfile = exhead + 'stream-top_view.png'
    WriteImage(exfile)



    
#### stream-side
    # camera set (if you want to set the camera potision)
    rend.CameraViewUp = [0.0, 0.0, 1.0]
    rend.CameraPosition = [0.2495, -0.7, 0.10]
    rend.CameraFocalPoint = [0.2495, 0.1, 0.10]
    rend.CameraClippingRange = [0.899, 1.376]
    rend.CameraParallelScale = 0.2 # 2D

    # write image
    Render()
    exfile = exhead + 'stream-side_view.png'
    WriteImage(exfile)
    
    # delete
    Delete(streamtracer)


    
#### preal-side
    
    # slice
    SetActiveSource(result)
    slice_view = Slice( SliceType="Plane" )
    slice_view.SliceType.Origin = [0.25, 0.15, 0.1]
    slice_view.SliceType.Normal = [0.0, 1.0, 0.0]
    slice_view.SliceType = "Plane"
    active_objects.source.SMProxy.InvokeEvent('UserEvent', 'HideWidget') # hide guide
    
    # rep
    rep_slice = Show()
    rep_slice.ColorArrayName = ('POINT_DATA', 'pressure_real')
    
    # color range (auto range)
    datarange = rep_slice.Input.PointData[rep_slice.ColorArrayName].GetRange()
    rep_slice.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])
    
    # write image
    Render()
    exfile = exhead + 'preal-side_view.png'
    WriteImage(exfile)

    
#### spl-side
    # rep
    rep_slice = Show()
    rep_slice.ColorArrayName = ('POINT_DATA', 'spl')
    
    # color range (auto range)
    datarange = rep_slice.Input.PointData[rep_slice.ColorArrayName].GetRange()
    rep_slice.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])
    
    # write image
    Render()
    exfile = exhead + 'spl-side_view.png'
    WriteImage(exfile)


    
    
#### intensity-side
    # rep_slice.Opacity = 0.6     # opacity
    rep_slice.Visibility = 0          # non-visible

    # glyph
    SetActiveSource(slice_view)
    glyph_view = Glyph( GlyphType="Arrow", GlyphTransform="Transform2")
    glyph_view.ScaleMode = 'off'
    glyph_view.SetScaleFactor = 0.01
    # glyph_view.ScaleMode = 'vector'     
    # glyph_view.SetScaleFactor = 0.1
    glyph_view.Vectors = ['POINTS', 'intensity']
    glyph_view.GlyphTransform = "Transform2"
    glyph_view.GlyphType ="Arrow"
    
    # rep
    rep_glyph = Show()
    rep_glyph.ColorArrayName = ('POINT_DATA', 'intensity')
    
    # color range (auto range)
    datarange = rep_glyph.Input.PointData[rep_glyph.ColorArrayName].GetRange()
    rep_glyph.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])
    rep_glyph.LookupTable = GetLookupTableForArray(
        "intensity", 3, VectorMode='Magnitude')
    

    # write image
    Render()
    exfile = exhead + 'intensity-side_view.png'
    WriteImage(exfile)

    # delete
    Delete(glyph_view)
    Delete(slice_view)


    
###### end #####
    Delete(outline)
    Delete(result)
    Delete(text)
    Render()

    print "+++++" + str(freq) + " end  +++++"

print "End-script"

raw_input("Pause... please type something and Enter")

