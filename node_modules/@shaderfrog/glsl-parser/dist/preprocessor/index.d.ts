import generate from './generator';
import { preprocessAst, preprocessComments, PreprocessorOptions } from './preprocessor';
import parser from './preprocessor-parser.js';
declare const preprocess: (src: string, options: PreprocessorOptions) => string;
export default preprocess;
export { preprocessAst, preprocessComments, generate, preprocess, parser };
