# See any of the existing projects for a template.
# Also see P5Wrapper.coffee for the expected interface.
module.exports =

  # ===========================================================================
  # This is the project that will be run by default when you first open the page
  DEFAULT_PROJECT_NAME: 'Shader_Chain_On_Geometry'
  # ===========================================================================

  FRAMEWORK_DEVELOPMENT:
    Pixels_CPU_Test: require('./projects/Pixels_CPU_Test')
    Pixels_Shader_Test: require('./projects/Pixels_Shader_Test')
    PostProcessing_Shader_Image: require('./projects/PostProcessing_Shader_Image')
    Bezier_Creator: require('./projects/Bezier_Creator')
    Pixel_Sorting: require('./projects/Pixel_Sorting')
    Shapes_To_Image_Filter: require('./projects/Shapes_To_Image_Filter')
    Multiple_Shaders: require('./projects/Multiple_Shaders')
    Shader_Chain_On_Geometry: require('./projects/Shader_Chain_On_Geometry')