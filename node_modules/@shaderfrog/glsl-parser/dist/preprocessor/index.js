"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.parser = exports.preprocess = exports.generate = exports.preprocessComments = exports.preprocessAst = void 0;
var generator_1 = __importDefault(require("./generator"));
exports.generate = generator_1.default;
var preprocessor_1 = require("./preprocessor");
Object.defineProperty(exports, "preprocessAst", { enumerable: true, get: function () { return preprocessor_1.preprocessAst; } });
Object.defineProperty(exports, "preprocessComments", { enumerable: true, get: function () { return preprocessor_1.preprocessComments; } });
var preprocessor_parser_js_1 = __importDefault(require("./preprocessor-parser.js"));
exports.parser = preprocessor_parser_js_1.default;
// Should this be in a separate file? There's no tests for it either
var preprocess = function (src, options) {
    return (0, generator_1.default)((0, preprocessor_1.preprocessAst)(preprocessor_parser_js_1.default.parse(options.preserveComments ? src : (0, preprocessor_1.preprocessComments)(src)), options));
};
exports.preprocess = preprocess;
exports.default = preprocess;
