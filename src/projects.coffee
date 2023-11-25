# See any of the existing projects for a template.
# Also see P5Wrapper.coffee for the expected interface.
module.exports =

  # ===========================================================================
  # This is the project that will be run by default when you first open the page
  DEFAULT_PROJECT_NAME: 'Trunk'
  # DEFAULT_PROJECT_NAME: 'Multiple_Shaders'
  # ===========================================================================

  FRAMEWORK_DEVELOPMENT:
    Pixels_CPU_Test: require('./projects/Pixels_CPU_Test')
    GLSL_Test: require('./projects/GLSL_Test')
    GLSL_Image_Manip: require('./projects/GLSL_Image_Manip')
    Bezier_Creator: require('./projects/Bezier_Creator')
    Pixel_Sorting: require('./projects/Pixel_Sorting')
    Shapes_To_Image_Filter: require('./projects/Shapes_To_Image_Filter')
    Multiple_Shaders: require('./projects/Multiple_Shaders')
    Shader_Chain_On_Geometry: require('./projects/Shader_Chain_On_Geometry')
  
  CLONES:
    # Pixel_Sorting_1: require("./projects/Generated_Space_Pixel_Sorting_1")
    Similar_Pixels_Sort: require("./projects/Generated_Space_Pixel_Sorting")
    Trunk: require("./projects/Generated_Space_Trunk")