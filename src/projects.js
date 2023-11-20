(function() {
  // See any of the existing projects for a template.
  // Also see P5Wrapper.coffee for the expected interface.
  module.exports = {
    // ===========================================================================
    // This is the project that will be run by default when you first open the page
    DEFAULT_PROJECT_NAME: 'Shapes_To_Image_Filter',
    // ===========================================================================
    Pixels_CPU_Test: require('./projects/Pixels_CPU_Test'),
    Pixels_Shader_Test: require('./projects/Pixels_Shader_Test'),
    PostProcessing_Shader_Test: require('./projects/PostProcessing_Shader_Test'),
    PostProcessing_Shader_Image: require('./projects/PostProcessing_Shader_Image'),
    Bezier_Creator: require('./projects/Bezier_Creator'),
    Pixel_Sorting: require('./projects/Pixel_Sorting'),
    Shapes_To_Image_Filter: require('./projects/Shapes_To_Image_Filter')
  };

}).call(this);
